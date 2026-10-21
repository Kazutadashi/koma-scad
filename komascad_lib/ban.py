"""The board: read a ban preset, render its panels, and write the 3MF files and the manifest.

ban/ban.scad decides the geometry. Its Export_Metadata run reports the size
and place of every panel, so this module never repeats the model's sums.
"""

from __future__ import annotations

import json
import os
import re
import tempfile
from collections.abc import Callable
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from . import openscad
from .export import portable_path, safe_name, sha256_file
from .openscad import Part
from .project import BAN_SCAD, KomaError
from .threemf import create_3mf

# The line in which the model reports the board, such as
# ECHO: "KOMASCAD_BAN", [192, 208.5, 12], [1, 1], [[0, 0, 192, 208.5, 0, 0]], 0, "Connectors"
# The last two are how many loose parts (connectors or keys) to print, and their kind.
BOARD_REPORT = re.compile(r'^ECHO: "KOMASCAD_BAN", (.+)$', re.M)

# The color parts of each panel, as the model's Output_Mode names them.
COLOR_MODES = ["Color body", "Color markings"]

# The Output_Mode that draws every connector or key.
LOOSE_MODE = "Loose parts"

# manifest.json is indented by this many spaces, for people who read it.
MANIFEST_INDENT = 2

# How manifest.json counts panels and measures their offsets.
COORDINATES = "columns count from the left, rows from the front; offsets from the front-left corner"

# A panel address has two digits for the column and two for the row, such as "01-02".
ADDRESS_DIGITS = 2

Report = Callable[[str], None]


@dataclass
class Panel:
    """One printed panel of a board.

    Attributes:
        column: Counted from 0 at the left.
        row: Counted from 0 at the front.
        width: mm, from left to right, without the tabs.
        depth: mm, from front to back, without the tabs.
        x: mm from the left edge of the board to the left edge of the panel.
        y: mm from the front edge of the board to the front edge of the panel.
    """

    column: int
    row: int
    width: float
    depth: float
    x: float
    y: float

    @property
    def address(self) -> str:
        """The column and row, such as "01-02"."""
        column = str(self.column).zfill(ADDRESS_DIGITS)
        row = str(self.row).zfill(ADDRESS_DIGITS)
        return column + "-" + row


@dataclass
class Board:
    """What the model reports about one board preset.

    Attributes:
        name: The preset name.
        size: Width, depth and thickness of the assembled board, in mm.
        columns: Panels from left to right.
        rows: Panels from front to back.
        panels: Every panel, row by row from the front left.
        materials: (role, material, rgba) of each color part, body first.
        loose: How many connectors or keys to print, spares included. 0 for
            a board without them.
        loose_name: "Connectors" or "Keys".
    """

    name: str
    size: list[float]
    columns: int
    rows: int
    panels: list[Panel]
    materials: list[tuple[str, str, list[float]]]
    loose: int = 0
    loose_name: str = ""

    @property
    def one_piece(self) -> bool:
        """True when the board prints as one panel."""
        return len(self.panels) == 1


@dataclass
class BoardFile:
    """One 3MF file of a board export.

    Attributes:
        filename: The name of the .3mf file.
        panels: The panels that it holds. Empty for the file of loose parts.
    """

    filename: str
    panels: list[Panel]


# --- Reading the board ----------------------------------------------------------


def resolved_settings(values: dict[str, Any]) -> dict[str, Any]:
    """Puts a preset's values over the model's defaults, as OpenSCAD does.

    Args:
        values: The saved settings of one preset, as text.

    Returns:
        Every public setting of ban/ban.scad, with its value for this preset.
    """
    defaults, _ = openscad.scad_parameters(BAN_SCAD)
    settings = dict(defaults)
    for name, value in values.items():
        if name not in defaults:
            continue
        if isinstance(value, str) and not isinstance(defaults[name], str):
            value = json.loads(value)
        settings[name] = value
    return settings


def parse_board(name: str, log: str) -> Board:
    """Reads the board that the model reports in its Export_Metadata run.

    Args:
        name: The preset name.
        log: The output of openscad.read_metadata().

    Returns:
        The board.

    Raises:
        KomaError: The model did not report the board.
    """
    report = BOARD_REPORT.search(log)
    if not report:
        raise KomaError("OpenSCAD did not report the panels of the board. Is ban/ban.scad current?")

    size, grid, panel_rows, loose, loose_name = json.loads("[" + report.group(1) + "]")
    panels = []
    for column, row, width, depth, x, y in panel_rows:
        panels.append(Panel(column, row, width, depth, x, y))

    materials = openscad.parse_materials(log, "board", BAN_SCAD)
    return Board(name, size, grid[0], grid[1], panels, materials, loose, loose_name)


def read_board(executable: str, name: str, definitions: list[str]) -> Board:
    """Asks the model for the size, panels and materials of one board.

    Args:
        executable: The OpenSCAD program.
        name: The preset name.
        definitions: The -D arguments of the preset.

    Returns:
        The board.

    Raises:
        KomaError: OpenSCAD cannot read the board, or a font is missing.
    """
    with tempfile.TemporaryDirectory(prefix="komascad-ban-") as temporary:
        log = openscad.read_metadata(executable, definitions, Path(temporary), "board", BAN_SCAD)
    return parse_board(name, log)


def read_preset(executable: str, name: str, values: dict[str, Any]) -> Board:
    """Reads the board that one saved preset makes, without rendering it.

    Args:
        executable: The OpenSCAD program.
        name: The preset name.
        values: The saved settings of the preset.

    Returns:
        The board.

    Raises:
        KomaError: The preset has an unknown setting, or OpenSCAD cannot read the board.
    """
    definitions = openscad.scad_definitions(name, values, {}, BAN_SCAD)
    return read_board(executable, name, definitions)


def render_panels(
    executable: str, definitions: list[str], board: Board
) -> tuple[list[list[Part]], Part | None]:
    """Renders the body and markings of every panel, and the loose parts, in one OpenSCAD run.

    Args:
        executable: The OpenSCAD program.
        definitions: The -D arguments of the preset.
        board: The board, from read_board().

    Returns:
        The parts of each panel, in the order of board.panels, and the loose
        parts as one part in the body material, or None for a board without them.

    Raises:
        KomaError: OpenSCAD cannot render a panel, or a part is not a closed mesh.
    """
    # Two frames for each panel: its body, then its markings.
    modes = []
    columns = []
    rows = []
    for panel in board.panels:
        for mode in COLOR_MODES:
            modes.append(mode)
            columns.append(panel.column)
            rows.append(panel.row)
    # One more frame for the loose parts, after the panels.
    if board.loose:
        modes.append(LOOSE_MODE)
        columns.append(0)
        rows.append(0)
    frames = {"Output_Mode": modes, "Panel_X": columns, "Panel_Y": rows}

    with tempfile.TemporaryDirectory(prefix="komascad-ban-") as temporary:
        folder = Path(temporary)
        files = openscad.render_frames(executable, definitions, folder, frames, BAN_SCAD)

        panel_frames = len(board.panels) * len(COLOR_MODES)
        parts = []
        for frame, file in enumerate(files[:panel_frames]):
            role, material, rgba = board.materials[frame % len(COLOR_MODES)]
            vertices, faces = openscad.read_stl(file)
            parts.append(Part(role, material, tuple(rgba), vertices, faces))

        loose = None
        if board.loose:
            _, material, rgba = board.materials[0]
            vertices, faces = openscad.read_stl(files[panel_frames])
            loose = Part(board.loose_name.lower(), material, tuple(rgba), vertices, faces)

    panel_parts = []
    for first in range(0, len(parts), len(COLOR_MODES)):
        panel_parts.append(parts[first : first + len(COLOR_MODES)])
    return panel_parts, loose


# --- Planning the files ---------------------------------------------------------


def plan_files(board: Board) -> list[BoardFile]:
    """Decides which panels go into which file.

    A one-piece board is one file. Otherwise each panel gets its own file, and
    one more file holds every panel on one bed. A board with connectors or keys
    has one more file with all of them.

    Args:
        board: The board.

    Returns:
        The files, in export order.
    """
    base = safe_name(board.name)
    if board.one_piece:
        return [BoardFile(base + ".3mf", board.panels)]

    files = []
    for panel in board.panels:
        files.append(BoardFile(f"{base} - Panel {panel.address}.3mf", [panel]))
    files.append(BoardFile(base + " - All panels.3mf", board.panels))
    if board.loose:
        files.append(BoardFile(f"{base} - {board.loose_name}.3mf", []))
    return files


def assembly_order(board: Board) -> list[Panel]:
    """Lists the panels in the order in which they go on the table.

    Each panel has tabs on its right and back edges, and sockets on its left
    and front edges. A panel therefore goes in after its left and front
    neighbors: row by row from the front, each row from the left.

    Args:
        board: The board.

    Returns:
        The panels, first to last.
    """
    return sorted(board.panels, key=lambda panel: (panel.row, panel.column))


def neighbors(board: Board, panel: Panel) -> dict[str, str]:
    """Names the panels next to one panel.

    Args:
        board: The board.
        panel: The panel.

    Returns:
        "left", "right", "front" and "back" -> address, for each neighbor that exists.
    """
    found = {}
    for other in board.panels:
        if other.row == panel.row and other.column == panel.column - 1:
            found["left"] = other.address
        if other.row == panel.row and other.column == panel.column + 1:
            found["right"] = other.address
        if other.column == panel.column and other.row == panel.row - 1:
            found["front"] = other.address
        if other.column == panel.column and other.row == panel.row + 1:
            found["back"] = other.address
    return found


def bed_order(panels: list[Panel], board: Board) -> tuple[list[Panel], list[int]]:
    """Orders the panels of the all-panels file, so that the bed looks like the board.

    Args:
        panels: The panels.
        board: The board.

    Returns:
        The panels from the back row to the front row, each row from the left,
        and the number of panels in each row, for threemf.create_3mf().
    """
    ordered = sorted(panels, key=lambda panel: (-panel.row, panel.column))
    rows = [board.columns] * board.rows
    return ordered, rows


# --- Writing ----------------------------------------------------------------------


def export_board(
    executable: str,
    preset_path: Path,
    name: str,
    values: dict[str, Any],
    destination: Path,
    force: bool,
    plain: bool,
    report: Report,
) -> tuple[int, int]:
    """Renders one board preset and writes its 3MF files and manifest.json.

    A file that exists is skipped unless force is set. When every file exists,
    nothing is rendered.

    Args:
        executable: The OpenSCAD program.
        preset_path: The preset file, for the manifest.
        name: The preset name.
        values: The saved settings of the preset.
        destination: The folder to write into. It is made if needed.
        force: Write files that already exist again.
        plain: Leave out the slicer filament slots.
        report: Receives a progress message for each step.

    Returns:
        The number of files written, and the number skipped.

    Raises:
        KomaError: The preset or the model has a problem that the user can fix.
    """
    definitions = openscad.scad_definitions(name, values, {}, BAN_SCAD)
    board = read_board(executable, name, definitions)
    plan = plan_files(board)

    pending = []
    for planned in plan:
        if force or not (destination / planned.filename).exists():
            pending.append(planned)
    skipped = len(plan) - len(pending)

    if pending:
        report(f"Rendering {len(board.panels)} panel(s) of {name} ...")
        panel_parts, loose = render_panels(executable, definitions, board)
        parts_of = {}
        for panel, parts in zip(board.panels, panel_parts, strict=True):
            parts_of[panel.address] = parts

        destination.mkdir(parents=True, exist_ok=True)
        for planned in pending:
            output = destination / planned.filename
            if planned.panels:
                _write_file(output, planned, board, parts_of, plain)
            else:
                _write_loose(output, loose, board.loose_name, plain)
            report("Saved " + planned.filename)

    write_manifest(destination, board, plan, preset_path, resolved_settings(values))
    return len(pending), skipped


def _write_file(
    output: Path,
    planned: BoardFile,
    board: Board,
    parts_of: dict[str, list[Part]],
    plain: bool,
) -> None:
    """Writes one 3MF, so that it gets its final name only when it is complete.

    Args:
        output: Where to write it.
        planned: The file and its panels.
        board: The board.
        parts_of: The parts of each panel, by address.
        plain: Leave out the slicer filament slots.
    """
    panels = planned.panels
    rows = None
    if len(panels) > 1:
        panels, rows = bed_order(panels, board)

    pieces = []
    for panel in panels:
        pieces.append(("Panel " + panel.address, parts_of[panel.address]))

    partial = output.with_name("." + output.name + ".partial")
    try:
        create_3mf(partial, pieces, output.stem, rows, slicer_settings=not plain)
        os.replace(partial, output)
    finally:
        if partial.exists():
            partial.unlink()


def _write_loose(output: Path, loose: Part | None, name: str, plain: bool) -> None:
    """Writes the 3MF of the loose parts, so that it gets its final name only when it is complete.

    Args:
        output: Where to write it.
        loose: The connectors or keys, as one part.
        name: "Connectors" or "Keys", the object name in the slicer.
        plain: Leave out the slicer filament slots.
    """
    partial = output.with_name("." + output.name + ".partial")
    try:
        create_3mf(partial, [(name, [loose])], output.stem, slicer_settings=not plain)
        os.replace(partial, output)
    finally:
        if partial.exists():
            partial.unlink()


def write_manifest(
    folder: Path,
    board: Board,
    plan: list[BoardFile],
    preset_path: Path,
    settings: dict[str, Any],
) -> None:
    """Records the board, how to put it together, and the files, in manifest.json.

    Args:
        folder: The export folder.
        board: The board.
        plan: The files of the export.
        preset_path: The preset file.
        settings: Every setting of the preset, from resolved_settings().
    """
    panel_file = {}
    for planned in plan:
        if len(planned.panels) == 1:
            panel_file[planned.panels[0].address] = planned.filename

    panels = []
    for panel in board.panels:
        panels.append(
            {
                "address": panel.address,
                "column": panel.column,
                "row": panel.row,
                "file": panel_file[panel.address],
                "size_mm": [panel.width, panel.depth],
                "offset_mm": [panel.x, panel.y],
                "neighbors": neighbors(board, panel),
            }
        )

    files = []
    for planned in plan:
        path = folder / planned.filename
        if path.exists():
            files.append(
                {
                    "file": planned.filename,
                    "bytes": path.stat().st_size,
                    "sha256": sha256_file(path),
                }
            )

    order = []
    for panel in assembly_order(board):
        order.append(panel.address)

    document = {
        "format_version": 1,
        "board": board.name,
        "source_parameters": portable_path(preset_path),
        "source_scad": portable_path(BAN_SCAD),
        "board_mm": board.size,
        "panel_grid": [board.columns, board.rows],
        "joint": settings["Joint_Style"],
        "loose_parts": {"kind": board.loose_name, "count": board.loose},
        "print_orientation": settings["Print_Orientation"],
        "coordinates": COORDINATES,
        "assembly": _assembly_text(board),
        "assembly_order": order,
        "panels": panels,
        "files": files,
        "settings": settings,
    }
    text = json.dumps(document, ensure_ascii=False, indent=MANIFEST_INDENT) + "\n"
    (folder / "manifest.json").write_text(text, encoding="utf-8")


def _assembly_text(board: Board) -> str:
    """Tells, in one sentence, how to put the panels together."""
    if board.one_piece:
        return "One-piece board. No assembly."
    if board.loose_name == "Connectors":
        return (
            "On a flat table, lay the panels face down, edges together. Drop a connector "
            "(or an M4 x 20 or #8-32 x 3/4 inch screw with its nut) into each socket "
            "across the seams, then turn the board over. Lift any panel straight up to free it."
        )
    if board.loose_name == "Keys":
        return (
            "On a flat table, lay the panels face down, edges together. Press a key "
            "into each pocket across the seams, then turn the board over."
        )
    return (
        "On a flat table, put the panels down face up in assembly_order. Hold each "
        "panel against its neighbors, then lower it straight down. Lift them off in reverse."
    )

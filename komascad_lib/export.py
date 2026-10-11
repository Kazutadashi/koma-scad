"""Plan and write an export: which pieces go into which 3MF file, and the manifest."""

from __future__ import annotations

import functools
import hashlib
import json
import math
import os
import re
from collections.abc import Callable
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
from pathlib import Path
from typing import NamedTuple

from . import openscad, printability
from .openscad import Part
from .project import ROOT, SCAD, KomaError
from .threemf import create_3mf

# Progress messages for the pieces of a layout are indented under the file's line.
PIECE_INDENT = "      "

# manifest.json is indented by this many spaces, for people who read it.
MANIFEST_INDENT = 2

# Files are read in blocks of this many bytes for their checksum.
CHECKSUM_BLOCK = 1024 * 1024

Report = Callable[[str], None]


class PlannedFile(NamedTuple):
    """One file of an export.

    Attributes:
        filename: The name of the .3mf file.
        presets: The preset of each piece in the file, one entry for each copy.
    """

    filename: str
    presets: list[str]


@dataclass
class ExportOptions:
    """How to render and write the files of an export.

    Attributes:
        executable: The OpenSCAD program.
        jobs: How many pieces to render at the same time.
        force: Write files that already exist again.
        plain: Leave out the slicer filament slots.
        rows: Optional row plan for a layout that holds every piece.
    """

    executable: str
    jobs: int
    force: bool
    plain: bool
    rows: list[int] | None


def unique_in_order(items: list[str]) -> list[str]:
    """Removes repeated items, and keeps the first of each in its place.

    Args:
        items: Any list, such as the preset of each placed piece.

    Returns:
        Each different item once, in order of first appearance.
    """
    unique = []
    for item in items:
        if item not in unique:
            unique.append(item)
    return unique


def safe_name(name: str) -> str:
    """Turns a preset or set name into a readable file name that works on every system.

    Args:
        name: Any name.

    Returns:
        The name, with characters that file names cannot hold replaced by " - ".

    Example:
        >>> safe_name('Chu Shogi: Lion / Kirin')
        'Chu Shogi - Lion - Kirin'
    """
    cleaned = re.sub(r'[<>:"/\\|?*\x00-\x1f]', " - ", name)
    cleaned = re.sub(r"\s+", " ", cleaned).strip(" .")
    # Join runs of dashes, such as " -  - ", into one.
    return re.sub(r"(?:\s*-\s*){2,}", " - ", cleaned)


def plan_files(
    presets: list[str], counts: dict[str, int], set_name: str, size: float | None
) -> list[PlannedFile]:
    """Decides which pieces go into which file.

    Args:
        presets: The presets to export, in order.
        counts: How many of each preset a full set needs.
        set_name: The set name, for layout file names.
        size: None for one file per preset. Otherwise the most pieces in one
            layout file, with every preset placed as many times as the set
            needs; math.inf puts the full set in one file.

    Returns:
        The files, in export order.
    """
    if not size:
        return [PlannedFile(safe_name(preset) + ".3mf", [preset]) for preset in presets]

    # One entry for each physical piece, so the layouts hold the full count.
    placements = []
    for preset in presets:
        placements += [preset] * counts[preset]

    if size == math.inf:
        pieces_per_file = len(placements)
    else:
        pieces_per_file = int(size)

    files: list[PlannedFile] = []
    for first in range(0, len(placements), pieces_per_file):
        number = len(files) + 1
        filename = f"{safe_name(set_name)} - Layout {number:02d}.3mf"
        files.append(PlannedFile(filename, placements[first : first + pieces_per_file]))
    return files


def describe_pieces(presets: list[str]) -> str:
    """Summarizes the pieces of a file for a progress message.

    Args:
        presets: The preset of each piece, one entry for each copy.

    Returns:
        A summary such as "Pawn x18, King".
    """
    counts: dict[str, int] = {}
    for preset in presets:
        counts[preset] = counts.get(preset, 0) + 1

    descriptions = []
    for name, count in counts.items():
        if count == 1:
            descriptions.append(name)
        else:
            descriptions.append(f"{name} x{count}")
    return ", ".join(descriptions)


def check_printable(
    executable: str, presets: dict[str, dict], names: list[str], overrides: dict
) -> None:
    """Stops the export when the lettering of a piece would not survive printing.

    Args:
        executable: The OpenSCAD program.
        presets: The settings of each preset, by name.
        names: The presets to check.
        overrides: Settings that replace the saved ones in every preset.

    Raises:
        KomaError: At least one piece is over the printability limits. The
            message names each piece and face, and how to fix them.
    """
    measured = printability.measure_presets(executable, presets, names, overrides)

    problems = []
    for name, values in measured.items():
        faces = printability.printability_problems(values)
        if faces:
            problems.append(f"  {name}\n    " + "\n    ".join(faces))

    if not problems:
        return

    advice = (
        "Use larger characters (raise Model Scale, or fewer characters on the face), "
        "a font with fewer strokes, or a smaller nozzle with a matching Print_Line_Width. "
        "Open the piece in OpenSCAD with Output Mode 'Inspect printability' to see where. "
        "To export anyway, add --no-print-check."
    )
    message_lines = ["Lettering on these pieces would not survive printing:"]
    message_lines += problems
    message_lines.append(advice)
    raise KomaError("\n".join(message_lines))


def export_files(
    plan: list[PlannedFile],
    presets: dict[str, dict],
    overrides: dict,
    destination: Path,
    options: ExportOptions,
    report: Report,
) -> tuple[int, int]:
    """Renders the pieces and writes the planned files.

    A file that exists is skipped unless options.force is set, so an export
    that was stopped continues where it stopped. Each preset is rendered once,
    however many copies of it are placed.

    Args:
        plan: The files to write, from plan_files().
        presets: The settings of each preset, by name.
        overrides: Settings that replace the saved ones in every preset.
        destination: The folder to write into. It is made if needed.
        options: How to render and write.
        report: Receives a progress message for each file.

    Returns:
        The number of files written, and the number skipped.
    """
    destination.mkdir(parents=True, exist_ok=True)

    written = 0
    skipped = 0
    # The parts of each preset rendered so far, so that each is rendered only once.
    rendered: dict[str, list[Part]] = {}
    for number, planned in enumerate(plan, start=1):
        output = destination / planned.filename
        progress = f"[{number}/{len(plan)}] "

        if output.exists() and not options.force:
            report(progress + "Skipping existing " + planned.filename)
            skipped += 1
            continue

        report(progress + "Exporting " + describe_pieces(planned.presets))
        _export_one(planned, output, presets, overrides, options, report, rendered)
        written += 1

    return written, skipped


def _export_one(
    planned: PlannedFile,
    output: Path,
    presets: dict[str, dict],
    overrides: dict,
    options: ExportOptions,
    report: Report,
    rendered: dict[str, list[Part]],
) -> None:
    """Renders the pieces of one file that are not rendered yet, and writes the file.

    Args:
        planned: The file to write.
        output: Where to write it.
        presets: The settings of each preset, by name.
        overrides: Settings that replace the saved ones in every preset.
        options: How to render and write.
        report: Receives the name of each piece as its rendering starts.
        rendered: The parts of each preset rendered so far. New ones are added.
    """
    different_presets = unique_in_order(planned.presets)
    not_yet_rendered = [preset for preset in different_presets if preset not in rendered]

    # Name each piece as its rendering starts, but only when the file holds
    # more than one kind of piece.
    piece_report = None
    if len(different_presets) > 1:
        piece_report = report

    new_parts = render_presets(
        options.executable, presets, not_yet_rendered, overrides, options.jobs, piece_report
    )
    rendered.update(new_parts)

    # A file of one piece is titled after the piece, a layout after its file name.
    if len(planned.presets) == 1:
        title = planned.presets[0]
    else:
        title = Path(planned.filename).stem

    pieces = [(preset, rendered[preset]) for preset in planned.presets]
    _write_whole(output, pieces, title, options)


def _write_whole(output: Path, pieces: list, title: str, options: ExportOptions) -> None:
    """Writes a 3MF so that it gets its final name only when it is complete.

    An export that is stopped half way then leaves no file that looks finished.
    """
    partial = output.with_name("." + output.name + ".partial")
    try:
        create_3mf(partial, pieces, title, options.rows, slicer_settings=not options.plain)
        os.replace(partial, output)
    finally:
        if partial.exists():
            partial.unlink()


def render_presets(
    executable: str,
    presets: dict[str, dict],
    names: list[str],
    overrides: dict,
    jobs: int,
    report: Report | None = None,
) -> dict[str, list[Part]]:
    """Renders the parts of several presets, up to jobs at the same time.

    Args:
        executable: The OpenSCAD program.
        presets: The settings of each preset, by name.
        names: The presets to render.
        overrides: Settings that replace the saved ones in every preset.
        jobs: How many to render at the same time.
        report: Optional. Receives the name of each preset as its rendering starts.

    Returns:
        The parts of each preset, by name.
    """
    definitions = [openscad.scad_definitions(name, presets[name], overrides) for name in names]
    render = functools.partial(_render_one, executable, report)

    # OpenSCAD does the work in its own process, so threads are enough.
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        parts = list(pool.map(render, names, definitions))
    return dict(zip(names, parts, strict=True))


def _render_one(
    executable: str, report: Report | None, name: str, definitions: list[str]
) -> list[Part]:
    """Renders one preset, and reports its name first when asked."""
    if report is not None:
        report(PIECE_INDENT + "rendering " + name)
    return openscad.render_parts(executable, definitions)


def portable_path(path: Path) -> str:
    """Describes a source file without showing where the project is stored.

    Manifests are shared with exported sets, so they must not record a maker's
    home folder.

    Args:
        path: The source file.

    Returns:
        The path relative to the project, or only the file name for a file
        outside the project.
    """
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return path.name


def sha256_file(path: Path) -> str:
    """Calculates the SHA-256 checksum of a file, without reading it all into memory.

    Args:
        path: The file.

    Returns:
        The checksum, in hexadecimal.
    """
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while True:
            block = source.read(CHECKSUM_BLOCK)
            if not block:
                break
            digest.update(block)
    return digest.hexdigest()


def write_manifest(
    folder: Path,
    set_name: str,
    preset_file: Path,
    plan: list[PlannedFile],
    counts: dict[str, int],
    layouts: bool,
) -> None:
    """Records the source, contents, sizes and checksums of an exported set in manifest.json.

    Args:
        folder: The export folder.
        set_name: The set name.
        preset_file: The preset file that was exported.
        plan: The files that were written.
        counts: How many of each preset a full set needs.
        layouts: True when the files are layouts, False for one file per preset.
    """
    files = []
    for planned in plan:
        path = folder / planned.filename
        entry: dict = {"file": planned.filename}

        if layouts:
            # A layout lists every piece placed in it.
            entry["presets"] = planned.presets
        else:
            # A single-piece file names its preset and how many to print.
            preset = planned.presets[0]
            entry["preset"] = preset
            entry["quantity"] = counts[preset]

        entry["bytes"] = path.stat().st_size
        entry["sha256"] = sha256_file(path)
        files.append(entry)

    document = {
        "format_version": 1,
        "set_name": set_name,
        "source_parameters": portable_path(preset_file),
        "source_scad": portable_path(SCAD),
        "piece_count": len(counts),
        "total_quantity": sum(counts.values()),
        "files": files,
    }
    text = json.dumps(document, ensure_ascii=False, indent=MANIFEST_INDENT) + "\n"
    (folder / "manifest.json").write_text(text, encoding="utf-8")

"""Running OpenSCAD: turn presets into -D arguments, render color parts, read STL files.

OpenSCAD is the geometry engine. This module checks and reads what it makes,
but never changes the geometry. The functions work with any module's model;
by default, with the pieces (koma/koma.scad).
"""

from __future__ import annotations

import functools
import json
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from .project import SCAD, KomaError, shown

# Settings that older versions of the model had. Saved presets can still hold
# them; they are ignored.
RETIRED_PARAMETERS = {
    "Reference_Line_Width",
    "Paint_Floor_Thickness",
    "Paint_Wall_Thickness",
    "Paint_Top_Lip",
}

# OpenSCAD warns about these when a font has closed glyph shells that touch at
# an exact edge, because STL carries no topology. read_stl() handles them.
TOUCHING_SHELL_WARNINGS = (
    "Object may not be a valid 2-manifold and may need repair",
    "Exported object may not be a valid 2-manifold and may need repair",
)

# How much of OpenSCAD's output an error message shows: the end, where the error is.
LOG_TAIL = 8000

# A binary STL is an 80-byte header, a triangle count, then the triangles.
# Each triangle is a normal and three corners (twelve floats) and two spare bytes.
STL_HEADER = 80
STL_COUNT_FORMAT = "<I"
STL_TRIANGLE_FORMAT = "<12fH"
STL_FIRST_TRIANGLE = STL_HEADER + struct.calcsize(STL_COUNT_FORMAT)
STL_TRIANGLE_SIZE = struct.calcsize(STL_TRIANGLE_FORMAT)
# The three corners of a triangle, among its twelve floats: after the normal (floats 0 to 2).
STL_CORNERS = (slice(3, 6), slice(6, 9), slice(9, 12))

# OpenSCAD numbers the frames of an animation export with five digits: part00000.stl.
FRAME_DIGITS = 5

# Patterns in the models and in OpenSCAD's output.
# A setting with its default, such as `Piece_Length = 32;` (name, then value).
SETTING = re.compile(r"^([A-Za-z_]\w*)\s*=\s*(.+?);", re.M)
# The name of any variable, such as `Export_Metadata` in `Export_Metadata = false;`.
VARIABLE_NAME = re.compile(r"^([A-Za-z_]\w*)\s*=", re.M)
# The lines that the model prints for the tool, such as `ECHO: "KOMASCAD_FONTS", [...]`.
FONTS_REPORT = re.compile(r'^ECHO: "KOMASCAD_FONTS", (.+)$', re.M)
MATERIALS_REPORT = re.compile(r'^ECHO: "KOMASCAD_EXPORT", (.+)$', re.M)
# A backslash that is not already escaping a quote or another backslash.
LONE_BACKSLASH = re.compile(r'\\(?!["\\])')

# The shell number of a triangle that is not yet in a shell.
UNASSIGNED = -1

Vertex = tuple[float, float, float]
Triangle = tuple[int, int, int]
Edge = tuple[int, int]


@dataclass
class Part:
    """One material part of a piece.

    Attributes:
        role: "body", "front", "back" or "signature".
        material: The filament name, such as "Wood".
        rgba: The display color, each channel from 0 to 1.
        vertices: The corner coordinates of the mesh.
        faces: The triangles, as three indexes into vertices.
    """

    role: str
    material: str
    rgba: tuple[float, ...]
    vertices: list[Vertex]
    faces: list[Triangle]


def run_openscad(command: list[str]) -> tuple[int, str]:
    """Runs OpenSCAD without opening a window.

    Args:
        command: The OpenSCAD command line, starting with the executable.

    Returns:
        The exit status, and everything OpenSCAD printed.
    """
    environment = os.environ.copy()
    # Without a display, OpenSCAD's Qt libraries need the offscreen platform.
    if sys.platform.startswith("linux") and not environment.get("DISPLAY"):
        environment.setdefault("QT_QPA_PLATFORM", "offscreen")

    result = subprocess.run(command, capture_output=True, text=True, env=environment)
    return result.returncode, result.stdout + "\n" + result.stderr


@functools.cache
def scad_parameters(scad: Path = SCAD) -> tuple[dict[str, Any], set[str]]:
    """Reads the settings that a model declares.

    Args:
        scad: The model, such as koma/koma.scad.

    Returns:
        The public settings with their default values, and the names of the
        hidden variables (those after the "[Hidden]" marker).
    """
    source = scad.read_text(encoding="utf-8")
    public_source, marker, hidden_source = source.partition("/* [Hidden] */")
    if not marker:
        hidden_source = ""

    defaults = {}
    for name, value in SETTING.findall(public_source):
        defaults[name] = json.loads(value)

    hidden = set(VARIABLE_NAME.findall(hidden_source))
    return defaults, hidden


def scad_definitions(
    preset: str, values: dict[str, Any], overrides: dict[str, Any], scad: Path = SCAD
) -> list[str]:
    """Turns one saved preset, plus overrides, into OpenSCAD -D arguments.

    OpenSCAD 2021.01 lets -p preset values win over -D, so the values are read
    here and passed as -D arguments: then the overrides always win. Output_Mode
    is left out, because each run sets its own.

    Args:
        preset: The preset name, for error messages.
        values: The saved settings of the preset.
        overrides: Settings that replace the saved ones.
        scad: The model that the preset is for.

    Returns:
        The arguments, such as ["-D", "Piece_Length=32", "-D", 'Font_Name="Yuji Syuku"'].

    Raises:
        KomaError: The preset has a setting that the model does not have.
    """
    defaults, hidden = scad_parameters(scad)

    typed = {}
    for name, value in values.items():
        # The Customizer saves some hidden variables into presets. Skip them,
        # but reject unknown or misspelled public settings.
        if name in hidden or name in RETIRED_PARAMETERS:
            continue
        if name not in defaults:
            raise KomaError(f"Preset {preset!r} has an unsupported parameter: {name}")

        # Presets store every value as text, such as "28" or "[1, 0, 0]".
        # Read it back as a number or list, unless the setting is text itself.
        if isinstance(value, str) and not isinstance(defaults[name], str):
            value = json.loads(value)
        typed[name] = value

    typed.update(overrides)

    definitions = []
    for name, value in typed.items():
        if name == "Output_Mode":
            continue
        definitions += ["-D", name + "=" + json.dumps(value, ensure_ascii=False)]
    return definitions


def check_fonts(log: str) -> None:
    """Stops when the system put another font in place of a requested one.

    The check needs the fontconfig tools (fc-match and fc-pattern). Without
    them, it does nothing.

    Args:
        log: OpenSCAD's output from a run with Export_Metadata, which lists the fonts.

    Raises:
        KomaError: A requested font is not installed.
    """
    match = FONTS_REPORT.search(log)
    has_fontconfig = shutil.which("fc-match") is not None and shutil.which("fc-pattern") is not None
    if not match or not has_fontconfig:
        return

    # A request for one of these is satisfied by any font.
    generic_families = {"sans", "sans-serif", "serif", "monospace", "system-ui"}

    # OpenSCAD echoes a literal backslash in some registered family names
    # (such as "A\-OTF"), which JSON does not allow. Escape those backslashes.
    font_list = LONE_BACKSLASH.sub(r"\\\\", match.group(1))

    for requested in set(json.loads(font_list)):
        wanted = subprocess.check_output(
            ["fc-pattern", "-f", "%{family}", requested], text=True
        ).strip()
        actual = subprocess.check_output(
            ["fc-match", "-f", "%{family}", requested], text=True
        ).strip()

        wanted_families = {family.strip().casefold() for family in wanted.split(",")}
        actual_families = {family.strip().casefold() for family in actual.split(",")}
        if wanted_families & actual_families or wanted_families & generic_families:
            continue

        raise KomaError(
            f'Font "{requested}" resolves to "{actual}". Install the intended font '
            "or choose its registered family in your preset before exporting."
        )


# --- Reading STL ------------------------------------------------------------------


def _edges(face: Triangle) -> list[tuple[int, int]]:
    """The three edges of a triangle, each as (start, end) in winding order."""
    a, b, c = face
    return [(a, b), (b, c), (c, a)]


def _undirected(start: int, end: int) -> Edge:
    """The edge between two vertices, the same whichever way it is walked."""
    return (min(start, end), max(start, end))


def _is_closed(faces: list[Triangle]) -> bool:
    """Checks that a mesh is closed and wound one way.

    In a closed mesh, each edge belongs to exactly two triangles. When the
    triangles are wound one way, those two walk the edge in opposite directions.

    Args:
        faces: The triangles of the mesh.

    Returns:
        True when the mesh is closed and consistently wound.
    """
    uses: dict[Edge, int] = {}
    # Counts +1 for each walk from the lower vertex id to the higher one, and -1
    # for each walk the other way. Two opposite walks add up to 0.
    direction: dict[Edge, int] = {}
    for face in faces:
        for start, end in _edges(face):
            edge = _undirected(start, end)
            uses[edge] = uses.get(edge, 0) + 1
            if start < end:
                direction[edge] = direction.get(edge, 0) + 1
            else:
                direction[edge] = direction.get(edge, 0) - 1

    for edge in uses:
        if uses[edge] != 2 or direction[edge] != 0:
            return False
    return True


def _triangles_by_edge(faces: list[Triangle]) -> dict[Edge, list[int]]:
    """Lists, for each edge, the triangles that use it.

    Args:
        faces: The triangles of the mesh.

    Returns:
        The indexes of the triangles that use each edge.
    """
    triangles_of_edge: dict[Edge, list[int]] = {}
    for index, face in enumerate(faces):
        for start, end in _edges(face):
            edge = _undirected(start, end)
            triangles_of_edge.setdefault(edge, []).append(index)
    return triangles_of_edge


def _joined_neighbors(
    index: int, faces: list[Triangle], triangles_of_edge: dict[Edge, list[int]]
) -> list[int]:
    """Finds the triangles that share an ordinary edge with one triangle.

    An ordinary edge has exactly two triangles. An edge with four triangles is
    where two shells touch, and it joins nothing.

    Args:
        index: The triangle.
        faces: The triangles of the mesh.
        triangles_of_edge: From _triangles_by_edge().

    Returns:
        The indexes of the joined triangles.
    """
    neighbors = []
    for start, end in _edges(faces[index]):
        triangles = triangles_of_edge[_undirected(start, end)]
        if len(triangles) != 2:
            continue
        for other in triangles:
            if other != index:
                neighbors.append(other)
    return neighbors


def _find_shells(faces: list[Triangle]) -> list[int]:
    """Groups triangles into shells: sets of triangles joined by ordinary edges.

    Args:
        faces: The triangles of the mesh.

    Returns:
        The shell number of each triangle.
    """
    triangles_of_edge = _triangles_by_edge(faces)
    shell_of = [UNASSIGNED] * len(faces)

    shell_count = 0
    for seed in range(len(faces)):
        if shell_of[seed] == UNASSIGNED:
            _fill_shell(seed, shell_count, faces, triangles_of_edge, shell_of)
            shell_count += 1
    return shell_of


def _fill_shell(
    seed: int,
    shell: int,
    faces: list[Triangle],
    triangles_of_edge: dict[Edge, list[int]],
    shell_of: list[int],
) -> None:
    """Gives one shell number to a triangle and to every triangle joined to it.

    Args:
        seed: The first triangle of the shell.
        shell: The shell number to give.
        faces: The triangles of the mesh.
        triangles_of_edge: From _triangles_by_edge().
        shell_of: The shell number of each triangle so far, or UNASSIGNED.
            It is filled in place.
    """
    shell_of[seed] = shell
    pending = [seed]
    while pending:
        index = pending.pop()
        for neighbor in _joined_neighbors(index, faces, triangles_of_edge):
            if shell_of[neighbor] == UNASSIGNED:
                shell_of[neighbor] = shell
                pending.append(neighbor)


def _separate_touching_shells(
    vertices: list[Vertex], faces: list[Triangle]
) -> tuple[list[Vertex], list[Triangle]]:
    """Gives each closed shell its own vertex ids.

    Font outlines can make separate closed shells that touch at an exact edge.
    STL has coordinates but no topology, so once shared coordinates become
    shared ids, that edge has four triangles and the mesh looks broken. After
    this step, each shell has its own ids for the same coordinates. Nothing moves.

    Args:
        vertices: The corner coordinates.
        faces: The triangles, as indexes into vertices.

    Returns:
        The new vertices and triangles.
    """
    shell_of = _find_shells(faces)

    new_vertices: list[Vertex] = []
    new_faces: list[Triangle] = []
    # (shell, old vertex id) -> new vertex id
    new_ids: dict[tuple[int, int], int] = {}
    for index, face in enumerate(faces):
        shell = shell_of[index]
        for vertex_id in face:
            if (shell, vertex_id) not in new_ids:
                new_ids[(shell, vertex_id)] = len(new_vertices)
                new_vertices.append(vertices[vertex_id])

        a, b, c = (new_ids[(shell, vertex_id)] for vertex_id in face)
        new_faces.append((a, b, c))

    return new_vertices, new_faces


def read_stl(path: Path) -> tuple[list[Vertex], list[Triangle]]:
    """Reads one binary STL and checks that it is a closed mesh.

    Corners with the same coordinates become one vertex.

    Args:
        path: The STL file.

    Returns:
        The vertices and the triangles.

    Raises:
        KomaError: The mesh is not closed, or not consistently wound.
    """
    data = path.read_bytes()
    (triangle_count,) = struct.unpack_from(STL_COUNT_FORMAT, data, STL_HEADER)
    end_of_triangles = STL_FIRST_TRIANGLE + STL_TRIANGLE_SIZE * triangle_count
    triangle_data = data[STL_FIRST_TRIANGLE:end_of_triangles]

    vertices: list[Vertex] = []
    faces: list[Triangle] = []
    vertex_ids: dict[Vertex, int] = {}
    for values in struct.iter_unpack(STL_TRIANGLE_FORMAT, triangle_data):
        corners = [values[corner] for corner in STL_CORNERS]
        for xyz in corners:
            if xyz not in vertex_ids:
                vertex_ids[xyz] = len(vertices)
                vertices.append(xyz)

        a, b, c = (vertex_ids[xyz] for xyz in corners)
        faces.append((a, b, c))

    if not _is_closed(faces):
        vertices, faces = _separate_touching_shells(vertices, faces)
        if not _is_closed(faces):
            raise KomaError(f"Part is not a closed, consistently wound mesh: {path}")
    return vertices, faces


# --- Rendering color parts -------------------------------------------------------


def read_metadata(
    executable: str, definitions: list[str], folder: Path, subject: str, scad: Path = SCAD
) -> str:
    """Runs the model with Export_Metadata, and checks its fonts.

    With Export_Metadata the model draws nothing; it only prints what the tool
    needs, such as its fonts and materials, so this run is fast.

    Args:
        executable: The OpenSCAD program.
        definitions: The -D arguments of the model.
        folder: A temporary folder for OpenSCAD's output.
        subject: What the model makes, such as "piece", for error messages.
        scad: The model.

    Returns:
        Everything that OpenSCAD printed.

    Raises:
        KomaError: OpenSCAD reports a problem, or a font is missing.
    """
    echo = folder / "metadata.echo"
    command = [executable, "--hardwarnings", "-o", str(echo)] + definitions
    command += ["-D", "Export_Metadata=true", str(scad)]

    status, log = run_openscad(command)
    if echo.exists():
        log += "\n" + echo.read_text(encoding="utf-8")

    failed = status != 0 or "ERROR:" in log or "WARNING:" in log
    if failed:
        raise KomaError(f"OpenSCAD could not read the {subject}:\n" + log[-LOG_TAIL:])

    check_fonts(log)
    return log


def parse_materials(
    log: str, subject: str, scad: Path = SCAD
) -> list[tuple[str, str, list[float]]]:
    """Reads the parts that a model reports in its Export_Metadata run.

    Args:
        log: The output of read_metadata().
        subject: What the model makes, such as "piece", for error messages.
        scad: The model, for error messages.

    Returns:
        (role, material, rgba) for each part that the model makes, in the model's order.

    Raises:
        KomaError: The model did not report its parts.
    """
    report = MATERIALS_REPORT.search(log)
    if not report:
        raise KomaError(
            f"OpenSCAD did not report the materials of the {subject}. Is {shown(scad)} current?"
        )

    materials = []
    for role, material, rgba, active in json.loads(report.group(1)):
        if active:
            materials.append((role, material, rgba))
    return materials


def render_frames(
    executable: str,
    definitions: list[str],
    folder: Path,
    frames: dict[str, list[Any]],
    scad: Path = SCAD,
) -> list[Path]:
    """Renders several variants of one model into STL files, in one OpenSCAD run.

    Each animation frame sets the settings in frames to their next value, for
    example the next Output_Mode. The frames share OpenSCAD's geometry cache,
    so shared geometry is built only once.

    Args:
        executable: The OpenSCAD program.
        definitions: The -D arguments of the model.
        folder: A temporary folder for the STL files.
        frames: Setting name -> its value in each frame. Every list has one
            value for each frame, such as {"Output_Mode": ["Color body", "Color front"]}.
        scad: The model.

    Returns:
        One STL file for each frame, in order.

    Raises:
        KomaError: OpenSCAD reports an error, or a warning other than touching shells.
    """
    frame_count = len(next(iter(frames.values())))
    # $t runs from 0 to 1 over the animation, so frame i gets values[i].
    frame_index = f"min(floor($t*{frame_count}),{frame_count - 1})"

    output = folder / "part.stl"
    command = [executable, "--animate", str(frame_count)]
    command += ["-o", str(output), "--export-format", "binstl"]
    command += definitions
    for name, values in frames.items():
        value_list = json.dumps(values, ensure_ascii=False)
        command += ["-D", f"{name}={value_list}[{frame_index}]"]
    command += ["-D", "Export_Metadata=false", str(scad)]

    status, log = run_openscad(command)
    warnings = [line for line in log.splitlines() if "WARNING:" in line]
    unexpected = [line for line in warnings if not _is_touching_shell_warning(line)]

    failed = status != 0 or "ERROR:" in log or len(unexpected) > 0
    if failed:
        raise KomaError("OpenSCAD could not export color parts:\n" + log[-LOG_TAIL:])

    files = []
    for frame in range(frame_count):
        number = str(frame).zfill(FRAME_DIGITS)
        files.append(output.with_name(output.stem + number + output.suffix))
    return files


def _is_touching_shell_warning(line: str) -> bool:
    """Checks whether an OpenSCAD warning is about glyph shells that touch (see read_stl)."""
    for known in TOUCHING_SHELL_WARNINGS:
        if known in line:
            return True
    return False


def render_parts(executable: str, definitions: list[str]) -> list[Part]:
    """Renders every material part of one piece.

    Args:
        executable: The OpenSCAD program.
        definitions: The -D arguments of the piece, from scad_definitions().

    Returns:
        The parts, in body, front, back, signature order.

    Raises:
        KomaError: OpenSCAD cannot render the piece, a font is missing, or a
            part is not a closed mesh.
    """
    with tempfile.TemporaryDirectory(prefix="komascad-") as temporary:
        folder = Path(temporary)
        log = read_metadata(executable, definitions, folder, "piece")
        materials = parse_materials(log, "piece")
        modes = ["Color " + role for role, _, _ in materials]
        files = render_frames(executable, definitions, folder, {"Output_Mode": modes})

        parts = []
        for (role, material, rgba), file in zip(materials, files, strict=True):
            vertices, faces = read_stl(file)
            parts.append(Part(role, material, tuple(rgba), vertices, faces))
        return parts

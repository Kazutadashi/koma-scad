#!/usr/bin/env python3
"""Export one KomaSCAD piece or a complete preset set as multipart 3MF files.

Requires Python 3.8+ (standard library only) and OpenSCAD 2021.01+.
Save Customizer changes as a preset first: a separate OpenSCAD process cannot
see unsaved settings in the GUI. The 3MF contains aligned, slicer-safe parts
and standard material colours, but printer and filament profiles belong in
your slicer.

OpenSCAD remains the geometry engine: this script asks the model for each
closed material part, validates those STL meshes, and packages them with the
open 3MF Core and Materials and Properties specifications. Each part carries
its selected standard colour property so compatible slicers can create and
assign logical filament slots automatically, without surface painting. The
script does not modify, approximate, or regenerate the geometry and contains
no slicer- or printer-specific project data.

QUICK START
    Export exactly one saved preset to a directory:
        python3 scripts/komascad_export.py --preset-file /path/to/shogi_piece.json --piece "King - Professional Grid 02 - Yuji Syuku - Narrow - Thin - Deep" --out /path/to/3mf

    Export every preset in a JSON file to a directory:
        python3 scripts/komascad_export.py --preset-file /path/to/shogi_piece.json --out /path/to/3mf

    Preview every filename and destination without starting OpenSCAD:
        python3 scripts/komascad_export.py --preset-file /path/to/shogi_piece.json --out /path/to/3mf --dry-run

    List exact piece names before exporting one:
        python3 scripts/komascad_export.py --preset-file /path/to/shogi_piece.json --list

PATHS AND PRESETS
    --preset-file selects the JSON collection. Add --piece with its exact saved
    name for one 3MF; omit --piece for the whole collection. --out is always a
    directory that directly receives the 3MF files. Existing same-named files
    are skipped, making all exports safe to resume; add --replace to overwrite.

    --preset-file and --out use paths exactly as your shell sees them: a
    relative path starts from the directory where you run the command.
    --target only controls where a relative --scad file is read from. Use
    --list to discover exact piece names before exporting one.
"""

import argparse
import hashlib
import json
import math
import os
import re
import shutil
import struct
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Sequence


MODEL_NAMESPACE = "http://schemas.microsoft.com/3dmanufacturing/core/2015/02"
MATERIAL_NAMESPACE = "http://schemas.microsoft.com/3dmanufacturing/material/2015/02"
ET.register_namespace("", MODEL_NAMESPACE)
ET.register_namespace("m", MATERIAL_NAMESPACE)

CONTENT_TYPES = b'''<?xml version="1.0" encoding="UTF-8"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="model" ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/><Default Extension="json" ContentType="application/json"/></Types>'''
RELATIONSHIPS = b'''<?xml version="1.0" encoding="UTF-8"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Target="/3D/3dmodel.model" Id="rel0" Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/></Relationships>'''

# CLI spelling and the corresponding public OpenSCAD parameter.
CUSTOM_PARAMETERS = {
    "body_colour": "Body_Filament",
    "front_colour": "Front_Filament",
    "back_colour": "Back_Filament",
    "front_text": "Front_Characters",
    "back_text": "Back_Characters",
    "signature_text": "Signature_Text",
    "signature_colour": "Signature_Filament",
}


def node(parent, tag, **attrs):
    """Add an element in the 3MF model namespace.

    Args:
        parent: XML element that will contain the new element.
        tag: Local XML element name, such as ``mesh`` or ``vertex``.
        **attrs: XML attributes; values are converted to strings.

    Returns:
        The newly created XML element.
    """
    qualified_tag = "{%s}%s" % (MODEL_NAMESPACE, tag)
    return ET.SubElement(parent, qualified_tag, {k: str(v) for k, v in attrs.items()})


def read_stl(path):
    """Read and validate one nonempty, closed binary STL mesh.

    Shared coordinates become shared vertex IDs. Each edge must appear in two
    triangles with opposite directions. If independently closed glyph shells
    merely touch along an edge, their vertex IDs are separated without moving
    coordinates; this preserves the exact outline while keeping each shell
    topologically manifold.

    Args:
        path: Path to the STL produced by OpenSCAD.

    Returns:
        A pair ``(vertices, faces)``. Vertices are XYZ tuples, and faces are
        triples of vertex indices.

    Raises:
        ValueError: The STL is empty, malformed, degenerate, or not closed.
    """
    data = path.read_bytes()
    if len(data) < 84:
        raise ValueError("Empty STL: " + str(path))

    triangle_count = struct.unpack_from("<I", data, 80)[0]
    if triangle_count == 0 or len(data) != 84 + 50 * triangle_count:
        raise ValueError("Expected nonempty binary STL: " + str(path))

    vertices = []
    faces = []
    vertex_ids = {}
    for triangle_index in range(triangle_count):
        # A binary triangle stores its normal, three vertices, and two spare bytes.
        values = struct.unpack_from("<12fH", data, 84 + 50 * triangle_index)
        face = []
        for start in (3, 6, 9):
            xyz = tuple(values[start:start + 3])
            if not all(math.isfinite(coordinate) for coordinate in xyz):
                raise ValueError("Non-finite mesh coordinate")
            if xyz not in vertex_ids:
                vertex_ids[xyz] = len(vertices)
                vertices.append(xyz)
            face.append(vertex_ids[xyz])
        if len(set(face)) != 3:
            raise ValueError("Degenerate STL triangle")
        faces.append(face)

    def edge_statistics(mesh_faces):
        statistics = {}
        for a, b, c in mesh_faces:
            for start, end in ((a, b), (b, c), (c, a)):
                edge = (min(start, end), max(start, end))
                count, balance = statistics.get(edge, (0, 0))
                statistics[edge] = (
                    count + 1, balance + (1 if start < end else -1),
                )
        return statistics

    edges = edge_statistics(faces)
    if any(count != 2 or balance != 0 for count, balance in edges.values()):
        # Font outlines can form separate closed extrusions that touch at an
        # exact edge. STL has coordinates but no vertex topology, so global
        # coordinate deduplication makes that edge appear four-sided. Discover
        # shells through ordinary two-face edges, then give touching shells
        # independent IDs at the same coordinates. Truly open or inconsistently
        # wound input still fails the closure check below.
        edge_faces = {}
        face_edges = []
        for face_index, (a, b, c) in enumerate(faces):
            local_edges = []
            for start, end in ((a, b), (b, c), (c, a)):
                edge = (min(start, end), max(start, end))
                edge_faces.setdefault(edge, []).append(face_index)
                local_edges.append(edge)
            face_edges.append(local_edges)

        components = [-1] * len(faces)
        component = 0
        for seed in range(len(faces)):
            if components[seed] != -1:
                continue
            components[seed] = component
            pending = [seed]
            while pending:
                face_index = pending.pop()
                for edge in face_edges[face_index]:
                    incident = edge_faces[edge]
                    if len(incident) != 2:
                        continue
                    other = incident[0] if incident[1] == face_index else incident[1]
                    if components[other] == -1:
                        components[other] = component
                        pending.append(other)
            component += 1

        separated_vertices = []
        separated_faces = []
        separated_ids = {}
        for face_index, face in enumerate(faces):
            separated_face = []
            for vertex_id in face:
                key = (components[face_index], vertex_id)
                if key not in separated_ids:
                    separated_ids[key] = len(separated_vertices)
                    separated_vertices.append(vertices[vertex_id])
                separated_face.append(separated_ids[key])
            separated_faces.append(separated_face)
        vertices, faces = separated_vertices, separated_faces
        edges = edge_statistics(faces)

    if any(count != 2 or balance != 0 for count, balance in edges.values()):
        raise ValueError("Part is not a closed, consistently wound mesh: " + str(path))

    return vertices, faces


def run_scad(executable, scad, output, common, mode, metadata=False):
    """Run OpenSCAD for a specific part or for export metadata.

    Args:
        executable: OpenSCAD command or executable path.
        scad: Source SCAD file.
        output: Temporary ``.stl`` or ``.echo`` path.
        common: Shared ``-D`` parameter arguments from preset and CLI options.
        mode: KomaSCAD ``Output_Mode`` value.
        metadata: Whether to enable KomaSCAD's metadata echo.

    Returns:
        Combined OpenSCAD output, including the contents of an ``.echo`` file.

    Raises:
        RuntimeError: OpenSCAD reports a warning/error or creates no output.
    """
    command = [executable, "--hardwarnings", "-o", str(output)]
    if output.suffix == ".stl":
        command.extend(["--export-format", "binstl"])
    command.extend(common)
    command.extend(["-D", "Output_Mode=" + json.dumps(mode)])
    command.extend(["-D", "Export_Metadata=" + str(metadata).lower(), str(scad)])

    environment = os.environ.copy()
    if sys.platform.startswith("linux") and not environment.get("DISPLAY"):
        environment.setdefault("QT_QPA_PLATFORM", "offscreen")

    result = subprocess.run(command, capture_output=True, text=True, env=environment)
    log = result.stdout + "\n" + result.stderr
    if output.suffix == ".echo" and output.exists():
        log += "\n" + output.read_text(encoding="utf-8")
    if result.returncode or "ERROR:" in log or "WARNING:" in log:
        raise RuntimeError("OpenSCAD could not export " + mode + ":\n" + log[-8000:])
    if not output.exists():
        raise RuntimeError("OpenSCAD did not create " + str(output) + "\n" + log)
    return log


def run_scad_batch(executable, scad, output, common, roles):
    """Render all enabled material roles in one cache-preserving OpenSCAD run.

    OpenSCAD animation frames share geometry and CGAL caches. Selecting one
    output mode per frame avoids restarting OpenSCAD and rebuilding the same
    printable piece independently for body, front, back, and signature.

    Args:
        executable: OpenSCAD command or executable path.
        scad: Source SCAD file.
        output: Base temporary STL path. OpenSCAD inserts a frame number.
        common: Shared ``-D`` parameter arguments from preset and CLI options.
        roles: Enabled material role names in export order.

    Returns:
        Frame STL paths in the same order as ``roles``.

    Raises:
        RuntimeError: OpenSCAD reports a warning/error or omits a frame.
    """
    if not roles:
        raise ValueError("No enabled material parts to export")
    modes = ["Colour " + role for role in roles]
    last_frame = len(modes) - 1
    mode_expression = (
        json.dumps(modes, ensure_ascii=False)
        + "[min(floor($t*" + str(len(modes)) + ")," + str(last_frame) + ")]"
    )
    command = [
        executable, "--animate", str(len(modes)),
        "-o", str(output), "--export-format", "binstl",
    ]
    command.extend(common)
    command.extend([
        "-D", "Output_Mode=" + mode_expression,
        "-D", "Export_Metadata=false", str(scad),
    ])

    environment = os.environ.copy()
    if sys.platform.startswith("linux") and not environment.get("DISPLAY"):
        environment.setdefault("QT_QPA_PLATFORM", "offscreen")

    result = subprocess.run(command, capture_output=True, text=True, env=environment)
    log = result.stdout + "\n" + result.stderr
    # A direct extrusion can contain independently closed font shells that
    # touch at an exact edge. OpenSCAD warns because STL carries no topology;
    # read_stl() separates their vertex IDs and then performs the strict mesh
    # check. All other OpenSCAD warnings remain fatal.
    allowed_warnings = (
        "Object may not be a valid 2-manifold and may need repair",
        "Exported object may not be a valid 2-manifold and may need repair",
    )
    warning_lines = [line for line in log.splitlines() if "WARNING:" in line]
    unexpected_warnings = [
        line for line in warning_lines
        if not any(message in line for message in allowed_warnings)
    ]
    if result.returncode or "ERROR:" in log or unexpected_warnings:
        raise RuntimeError("OpenSCAD could not export colour parts:\n" + log[-8000:])

    frames = [
        output.with_name(output.stem + ("%05d" % index) + output.suffix)
        for index in range(len(modes))
    ]
    missing = [str(frame) for frame in frames if not frame.exists()]
    if missing:
        raise RuntimeError("OpenSCAD did not create batch frame(s): " + ", ".join(missing) + "\n" + log)
    return frames


def create_3mf(destination, parts, title):
    """Package aligned meshes and standard material/colour data into a 3MF.

    Core ``basematerials`` retain human-readable filament names. One
    Materials and Properties ``colorgroup`` per selected material also gives
    every mesh an object-level colour property. Popular slicers that ignore
    Core base-material assignments can use this open-standard property to
    create and assign logical filament slots without per-part painting.

    Args:
        destination: Final ``.3mf`` path. A temporary ZIP is staged beside it.
        parts: Tuples ``(role, material_name, rgba, vertices, faces)``.
        title: Name of the combined model.

    Returns:
        List of part/material dictionaries displayed after export.

    Raises:
        ValueError: Validation of the staged 3MF ZIP fails.
    """
    model = ET.Element(
        "{%s}model" % MODEL_NAMESPACE,
        {"unit": "millimeter", "{http://www.w3.org/XML/1998/namespace}lang": "en-US"},
    )
    node(model, "metadata", name="Title").text = title
    node(model, "metadata", name="Application").text = "KomaSCAD colour exporter 3.4"
    node(model, "metadata", name="Description").text = (
        "One aligned multipart koma with standard 3MF material and colour "
        "assignments and printable supporting volumes for body/front/back/"
        "signature parts. Glitter/metallic "
        "labels describe filament choice, not surface textures."
    )
    resources = node(model, "resources")
    materials = node(resources, "basematerials", id=1)
    material_ids = {}
    prepared_parts = []

    # Discover materials first so every kind of resource receives a unique
    # 3MF resource ID. The material key deliberately includes the name: two
    # visually equal swatches may still describe different physical filaments.
    for role, name, rgba, vertices, faces in parts:
        rgb = "#" + "".join("%02X" % round(255 * channel) for channel in rgba[:3])
        material_key = (name, rgb)
        if material_key not in material_ids:
            material_ids[material_key] = len(material_ids)
            # Explicit opaque alpha avoids readers that incorrectly interpret
            # a legal six-digit 3MF colour as transparent RGBA.
            node(materials, "base", name=name, displaycolor=rgb + "FF")
        prepared_parts.append((role, name, rgb, material_key, vertices, faces))

    # Base materials are useful to standards-aware manufacturing tools, but
    # several FDM slicers treat them as display-only. Object-level colour-group
    # properties are also standard 3MF and are commonly converted to logical
    # filament assignments on generic-model import. Separate one-colour groups
    # retain compatibility with consumers that do not implement pindex fully.
    next_resource_id = 2
    colour_group_ids = {}
    for material_key in material_ids:
        colour_group_ids[material_key] = next_resource_id
        colour_group = ET.SubElement(
            resources, "{%s}colorgroup" % MATERIAL_NAMESPACE,
            {"id": str(next_resource_id)},
        )
        ET.SubElement(
            colour_group, "{%s}color" % MATERIAL_NAMESPACE,
            {"color": material_key[1] + "FF"},
        )
        next_resource_id += 1

    component_ids = []
    manifest = []

    for role, name, rgb, material_key, vertices, faces in prepared_parts:
        object_id = next_resource_id
        next_resource_id += 1
        component_ids.append(object_id)
        part_object = node(
            resources, "object", id=object_id, type="model",
            name=role.title() + " | " + name,
            pid=colour_group_ids[material_key], pindex=0,
        )
        mesh = node(part_object, "mesh")
        xml_vertices = node(mesh, "vertices")
        xml_faces = node(mesh, "triangles")
        for x, y, z in vertices:
            node(xml_vertices, "vertex", x=format(x, ".9g"), y=format(y, ".9g"), z=format(z, ".9g"))
        for a, b, c in faces:
            node(xml_faces, "triangle", v1=a, v2=b, v3=c)
        manifest.append({
            "part": role, "material": name, "display_colour": rgb,
            "material_index": material_ids[material_key],
        })

    assembly_id = next_resource_id
    assembly = node(resources, "object", id=assembly_id, type="model", name=title)
    components = node(assembly, "components")
    for object_id in component_ids:
        node(components, "component", objectid=object_id)
    node(node(model, "build"), "item", objectid=assembly_id)

    destination.parent.mkdir(parents=True, exist_ok=True)
    # Keep an existing successful export intact if the next export fails.
    with tempfile.NamedTemporaryFile(dir=destination.parent, suffix=".3mf", delete=False) as temp:
        staged = Path(temp.name)
    try:
        with zipfile.ZipFile(staged, "w", zipfile.ZIP_DEFLATED) as archive:
            archive.writestr("[Content_Types].xml", CONTENT_TYPES)
            archive.writestr("_rels/.rels", RELATIONSHIPS)
            archive.writestr("3D/3dmodel.model", ET.tostring(model, encoding="utf-8", xml_declaration=True))
            archive.writestr("Metadata/KomaSCAD.json", json.dumps({
                "version": "3.4", "units": "mm", "parts": manifest,
                "type": (
                    "portable multipart model with standard colour assignments; "
                    "no printer settings"
                ),
            }, ensure_ascii=False, indent=2))
        with zipfile.ZipFile(staged) as archive:
            if archive.testzip() is not None:
                raise ValueError("3MF ZIP validation failed")
        os.replace(staged, destination)
    finally:
        if staged.exists():
            staged.unlink()
    return manifest


def default_target():
    """Find the project directory when no ``--target`` is given.

    Returns:
        The parent of a ``scripts`` directory, or the script's own directory
        when it lives beside the SCAD source.
    """
    script_directory = Path(__file__).resolve().parent
    return script_directory.parent if script_directory.name == "scripts" else script_directory


def target_path(path, target):
    """Resolve a SCAD or preset path against the chosen project directory.

    Args:
        path: Absolute path or path relative to ``target``.
        target: KomaSCAD project directory.

    Returns:
        Absolute, resolved path.
    """
    return (path if path.is_absolute() else target / path).resolve()


def build_parser():
    """Define CLI options and their help text in one place.

    Returns:
        Argument parser ready to parse command-line arguments.
    """
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--target", type=Path, default=default_target(),
                        help="KomaSCAD project directory (default: script directory or parent of scripts)")
    parser.add_argument("--scad", type=Path, default=Path("shogi_piece.scad"),
                        help="SCAD source, relative to --target unless absolute")
    parser.add_argument("--preset-file", type=Path, required=True,
                        help="Customizer JSON file (relative to your current directory); one --piece exports one preset, otherwise exports every preset")
    parser.add_argument("--piece",
                        help="exact saved preset name to export; omit to export the entire --preset-file")
    parser.add_argument("--out", type=Path, default=Path("exports"),
                        help="directory receiving 3MF files; relative paths use the current directory")
    parser.add_argument("--set-name",
                        help="collection name stored in manifest.json when exporting every preset")
    parser.add_argument("--replace", action="store_true",
                        help="overwrite existing same-named 3MF files; otherwise they are skipped")
    parser.add_argument("--list", action="store_true",
                        help="list presets in --preset-file, then exit")
    parser.add_argument("--dry-run", action="store_true",
                        help="show output paths without exporting")
    parser.add_argument("--openscad", default="openscad", help="OpenSCAD executable")
    for option in CUSTOM_PARAMETERS:
        parser.add_argument("--" + option.replace("_", "-"))
    return parser


def load_preset(scad, parameters, preset, parser):
    """Load typed OpenSCAD parameter values from a saved Customizer preset.

    Args:
        scad: SCAD source used to identify valid public parameters and types.
        parameters: Preset JSON path.
        preset: Name of the saved parameter set.
        parser: CLI parser used to report invalid presets clearly.

    Returns:
        Dictionary of valid OpenSCAD parameter names and typed values.

    Raises:
        ValueError: Preset JSON or a typed parameter value is malformed.
    """
    if not parameters.is_file():
        parser.error("Preset JSON not found: " + str(parameters))
    parameter_sets = json.loads(parameters.read_text(encoding="utf-8")).get("parameterSets", {})
    if preset not in parameter_sets:
        parser.error("Unknown preset: " + preset)

    # OpenSCAD 2021.01 preset loading can override -D public parameters. Read
    # the values ourselves so explicit CLI choices always take precedence.
    source = scad.read_text(encoding="utf-8")
    public_source, marker, hidden_source = source.partition("/* [Hidden] */")
    defaults = {
        name: json.loads(value)
        for name, value in re.findall(r"^([A-Za-z_]\w*)\s*=\s*(.+?);", public_source, re.M)
    }
    # OpenSCAD 2021.01 can leak literal variables declared after its Hidden
    # marker into a saved Customizer preset. They are implementation details,
    # not user controls, so ignore declared hidden names while retaining the
    # error for genuinely unknown or misspelled public parameters.
    hidden_names = set(re.findall(
        r"^([A-Za-z_]\w*)\s*=", hidden_source if marker else "", re.M,
    ))
    values = {}
    for name, value in parameter_sets[preset].items():
        if name in hidden_names:
            continue
        if name not in defaults:
            parser.error("Preset has an unsupported parameter: " + name)
        values[name] = value if isinstance(defaults[name], str) else (
            json.loads(value) if isinstance(value, str) else value
        )
    return values


def scad_arguments(args, scad, parameters, piece, parser):
    """Combine preset parameters with command-line overrides for OpenSCAD.

    Args:
        args: Parsed CLI arguments.
        scad: Resolved SCAD source path.
        parameters: Resolved preset JSON path.
        piece: Exact preset name to load.
        parser: CLI parser used for invalid option combinations.

    Returns:
        List of ``-D`` arguments shared by all OpenSCAD runs.
    """
    values = {}
    if piece:
        values = load_preset(scad, parameters, piece, parser)
    for option, parameter in CUSTOM_PARAMETERS.items():
        choice = getattr(args, option)
        if choice is not None:
            values[parameter] = choice
    if args.signature_text is not None:
        values["Signature_Enabled"] = True

    common = []
    for name, value in values.items():
        if name != "Output_Mode":
            common.extend(["-D", name + "=" + json.dumps(value, ensure_ascii=False)])
    return common


def check_fonts(log):
    """Reject substituted font families when fontconfig tools are present.

    Args:
        log: OpenSCAD metadata output containing optional ``KOMASCAD_FONTS``.

    Raises:
        ValueError: A requested font resolves to a different non-generic family.
    """
    match = re.search(r'^ECHO: "KOMASCAD_FONTS", (.+)$', log, re.M)
    if not match or not (shutil.which("fc-match") and shutil.which("fc-pattern")):
        return

    generic_families = {"sans", "sans-serif", "serif", "monospace", "system-ui"}
    # OpenSCAD echoes a literal backslash in some registered font family names
    # (for example ``A\-OTF``), while JSON requires that backslash to be
    # escaped. Preserve OpenSCAD's text and make only those literal slashes
    # JSON-safe before decoding the simple string array.
    encoded_fonts = re.sub(r'\\(?!["\\])', r'\\\\', match.group(1))
    for requested in set(json.loads(encoded_fonts)):
        wanted = subprocess.check_output(
            ["fc-pattern", "-f", "%{family}", requested], text=True,
        ).strip()
        actual = subprocess.check_output(
            ["fc-match", "-f", "%{family}", requested], text=True,
        ).strip()
        wanted_families = {family.strip().casefold() for family in wanted.split(",")}
        actual_families = {family.strip().casefold() for family in actual.split(",")}
        if not (wanted_families & actual_families or wanted_families & generic_families):
            raise ValueError(
                'Font "' + requested + '" resolves to "' + actual + '". '
                "Install the intended font or choose its registered family "
                "in your preset before exporting."
            )


def export_parts(executable, scad, common, folder):
    """Discover enabled materials and export their meshes in one cached batch.

    Args:
        executable: OpenSCAD command or executable path.
        scad: Source SCAD file.
        common: Shared preset and CLI ``-D`` arguments.
        folder: Temporary directory for the ``.echo`` and ``.stl`` files.

    Returns:
        Tuples ``(role, material_name, rgba, vertices, faces)`` for the 3MF.

    Raises:
        ValueError: Required KomaSCAD v3 metadata is missing.
    """
    log = run_scad(executable, scad, folder / "materials.echo", common, "Colour assembly", True)
    match = re.search(r'^ECHO: "KOMASCAD_EXPORT", (.+)$', log, re.M)
    if not match:
        raise ValueError("SCAD does not provide KomaSCAD v3 export metadata")
    check_fonts(log)

    enabled_parts = [part for part in json.loads(match.group(1)) if part[3]]
    for role, name, rgba, _enabled in enabled_parts:
        print("Preparing " + role + " — " + name, flush=True)
    print("Rendering all parts in one cached OpenSCAD run", flush=True)
    stls = run_scad_batch(
        executable, scad, folder / "part.stl", common,
        [role for role, name, rgba, _enabled in enabled_parts],
    )

    parts = []
    for (role, name, rgba, _enabled), stl in zip(enabled_parts, stls):
        vertices, faces = read_stl(stl)
        parts.append((role, name, rgba, vertices, faces))
    return parts


def export_piece(args, scad, parameters, piece, output, parser):
    """Render one named preset and package it as a completed 3MF file."""
    common = scad_arguments(args, scad, parameters, piece, parser)
    with tempfile.TemporaryDirectory(prefix="komascad-") as temporary:
        parts = export_parts(args.openscad, scad, common, Path(temporary))
        return create_3mf(output, parts, piece)



@dataclass(frozen=True)
class ExportJob:
    """Describe one preset-to-file export in a batch.

    Attributes:
        preset: Exact, case-sensitive preset name from ``parameterSets``.
        filename: Filesystem-safe output filename ending in ``.3mf``.

    Examples:
        >>> job = ExportJob("30 Taikyoku - Fire Demon", "30 Taikyoku - Fire Demon.3mf")
        >>> job.filename
        '30 Taikyoku - Fire Demon.3mf'
    """

    preset: str
    filename: str


def load_parameter_sets(path: Path) -> Dict[str, object]:
    """Load the named parameter sets from an OpenSCAD preset JSON file.

    Args:
        path: JSON file containing a top-level ``parameterSets`` object.

    Returns:
        A dictionary retaining the source file's preset order.

    Raises:
        ValueError: The file is malformed or has no nonempty parameter sets.

    Examples:
        >>> import tempfile
        >>> folder = Path(tempfile.mkdtemp())
        >>> sample = folder / "sample.json"
        >>> _ = sample.write_text('{"parameterSets":{"Pawn":{}}}', encoding="utf-8")
        >>> list(load_parameter_sets(sample))
        ['Pawn']
    """
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError("Could not read preset JSON %s: %s" % (path, error))
    parameter_sets = document.get("parameterSets") if isinstance(document, dict) else None
    if not isinstance(parameter_sets, dict) or not parameter_sets:
        raise ValueError("Preset JSON has no nonempty parameterSets object: " + str(path))
    if not all(isinstance(name, str) and name for name in parameter_sets):
        raise ValueError("Every preset name must be a nonempty string: " + str(path))
    if not all(isinstance(values, dict) for values in parameter_sets.values()):
        raise ValueError("Every parameter set must be a JSON object: " + str(path))
    return parameter_sets


def safe_name(name: str) -> str:
    """Convert a human name into a safe cross-platform file component.

    Unicode letters and numbers are retained. Reserved punctuation, control
    characters, repeated whitespace, and trailing Windows separators are
    normalized without obscuring the original preset name.

    Args:
        name: Human-readable preset or set name.

    Returns:
        A safe filename component.

    Raises:
        ValueError: Normalization would produce an empty or reserved name.

    Examples:
        >>> safe_name('Chu Shogi: Lion / Kirin')
        'Chu Shogi - Lion - Kirin'
    """
    cleaned = re.sub(r'[<>:"/\\|?*\x00-\x1f]', " - ", name)
    cleaned = re.sub(r"\s+", " ", cleaned).strip(" .")
    cleaned = re.sub(r"(?:\s*-\s*){2,}", " - ", cleaned)
    reserved = {
        "con", "prn", "aux", "nul",
        *("com%d" % number for number in range(1, 10)),
        *("lpt%d" % number for number in range(1, 10)),
    }
    if not cleaned or cleaned.casefold() in reserved:
        raise ValueError("Name cannot be converted to a safe filename: " + repr(name))
    return cleaned


def plan_exports(presets: Sequence[str]) -> List[ExportJob]:
    """Create one collision-free 3MF export job per preset.

    Args:
        presets: Ordered preset names selected for the set.

    Returns:
        Export jobs whose filenames preserve the human-readable preset names.

    Raises:
        ValueError: Two preset names normalize to the same filename.

    Examples:
        >>> plan_exports(["Chu - Lion"])
        [ExportJob(preset='Chu - Lion', filename='Chu - Lion.3mf')]
    """
    jobs = [ExportJob(preset, safe_name(preset) + ".3mf") for preset in presets]
    folded_names = [job.filename.casefold() for job in jobs]
    collisions = sorted({name for name in folded_names if folded_names.count(name) > 1})
    if collisions:
        raise ValueError("Preset names produce colliding filenames: " + ", ".join(collisions))
    return jobs


def sha256_file(path: Path) -> str:
    """Calculate a SHA-256 checksum without loading a whole 3MF into memory.

    Args:
        path: File whose contents should be hashed.

    Returns:
        Lowercase hexadecimal SHA-256 digest.

    Examples:
        >>> import tempfile
        >>> sample = Path(tempfile.mkstemp()[1])
        >>> _ = sample.write_bytes(b"KomaSCAD")
        >>> len(sha256_file(sample))
        64
    """
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def write_set_manifest(
        path: Path, set_name: str, parameters: Path,
        scad: Path, jobs: Sequence[ExportJob]) -> None:
    """Write provenance, filenames, sizes, and checksums for a completed set.

    Args:
        path: Destination JSON path inside the staged set folder.
        set_name: Human-readable collection name.
        parameters: Source preset JSON path.
        scad: Source model path.
        jobs: Successfully completed exports.

    Examples:
        ``write_set_manifest(folder / "manifest.json", "Chu Shogi",
        presets, model, jobs)`` records every file delivered with the set.
    """
    files = []
    for job in jobs:
        exported = path.parent / job.filename
        files.append({
            "preset": job.preset,
            "file": job.filename,
            "bytes": exported.stat().st_size,
            "sha256": sha256_file(exported),
        })
    document = {
        "format_version": 1,
        "set_name": set_name,
        "source_parameters": str(parameters),
        "source_scad": str(scad),
        "piece_count": len(jobs),
        "files": files,
    }
    path.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")





def export_set(args, parser) -> int:
    """Export selected presets directly to a resumable output directory.

    Args:
        args: Parsed unified export command options.
        parser: Parser used to report command-line errors.

    Returns:
        Zero on success, or one when validation/export fails.
    """
    try:
        target = args.target.resolve()
        scad = target_path(args.scad, target)
        parameters = args.preset_file.resolve()
        if not scad.is_file():
            raise ValueError("SCAD file not found: " + str(scad))
        if not parameters.is_file():
            raise ValueError("Preset JSON not found: " + str(parameters))
        parameter_sets = load_parameter_sets(parameters)
        selected = list(parameter_sets)
        jobs = plan_exports(selected)

        if args.list:
            for job in jobs:
                print(job.preset)
            return 0

        default_name = parameters.stem.replace("_", " ").replace("-", " ").title()
        set_name = args.set_name or default_name
        destination = args.out.resolve()

        if args.dry_run:
            print("Set: " + set_name)
            print("Folder: " + str(destination))
            for job in jobs:
                print("  " + job.preset + " -> " + job.filename)
            return 0

        if destination.exists() and not destination.is_dir():
            raise ValueError("--out must be a directory: " + str(destination))
        destination.mkdir(parents=True, exist_ok=True)
        exported = 0
        skipped = 0
        for index, job in enumerate(jobs, 1):
            output = destination / job.filename
            if output.exists() and not args.replace:
                if not output.is_file():
                    raise ValueError("Output path is not a file: " + str(output))
                print("[%d/%d] Skipping existing %s" % (index, len(jobs), job.filename), flush=True)
                skipped += 1
                continue

            print("[%d/%d] Exporting %s" % (index, len(jobs), job.preset), flush=True)
            # A completed file stays in the destination immediately. A partial
            # export is kept under a distinct temporary name and never skipped.
            temporary_output = output.with_name("." + output.name + ".partial")
            if temporary_output.exists():
                temporary_output.unlink()
            export_piece(args, scad, parameters, job.preset, temporary_output, parser)
            if not temporary_output.is_file():
                raise RuntimeError("Exporter reported success but created no file for " + repr(job.preset))
            os.replace(temporary_output, output)
            exported += 1

        write_set_manifest(destination / "manifest.json", set_name, parameters, scad, jobs)
        print("Saved %d new 3MF file(s); skipped %d existing file(s) in %s" % (exported, skipped, destination))
        print("Set manifest: " + str(destination / "manifest.json"))
        return 0
    except (OSError, ValueError, RuntimeError) as error:
        print("Set export failed: " + str(error), file=sys.stderr)
        return 1



def main(argv=None):
    """Validate CLI inputs, export the model, and print slicer guidance.

    Raises:
        OSError: A file or external tool cannot be opened or run.
        ValueError: A mesh, preset, or metadata record is invalid.
        RuntimeError: OpenSCAD fails to create an export.
    """
    parser = build_parser()
    raw_argv = list(argv) if argv is not None else sys.argv[1:]
    args = parser.parse_args(raw_argv)

    if not args.piece:
        if any(getattr(args, option) is not None for option in CUSTOM_PARAMETERS):
            parser.error("Text and colour overrides require --piece; save set-wide changes in the preset file")
        return export_set(args, parser)

    target = args.target.resolve()
    scad = target_path(args.scad, target)
    parameters = args.preset_file.resolve()
    output_directory = args.out.resolve()
    output_directory.mkdir(parents=True, exist_ok=True)
    output = output_directory / (safe_name(args.piece) + ".3mf")

    if not scad.is_file():
        parser.error("SCAD file not found: " + str(scad))
    if not parameters.is_file():
        parser.error("Preset JSON not found: " + str(parameters))
    if args.list:
        print(args.piece)
        return 0
    if args.dry_run:
        print("Piece: " + args.piece)
        print("File: " + str(output))
        return 0
    if output.exists() and not args.replace:
        print("Skipping existing " + str(output))
        return 0
    manifest = export_piece(args, scad, parameters, args.piece, output, parser)

    print("Saved " + str(output))
    print("Open as ONE multipart object; standard logical filament assignments are embedded:")
    for part in manifest:
        print("  " + part["part"] + ": " + part["material"] + " (" + part["display_colour"] + ")")
    print("No paint bucket is required in a compatible slicer. Confirm that "
          "its logical colours match your physically loaded spools before printing. "
          "No printer profile or physical glitter/metallic texture is encoded.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, RuntimeError) as error:
        print("Export failed: " + str(error), file=sys.stderr)
        sys.exit(1)

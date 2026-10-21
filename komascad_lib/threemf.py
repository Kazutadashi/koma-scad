"""Write multipart color 3MF files.

Every piece is a named object made of aligned material parts. Slicers read the
colors in different ways, so the file holds three kinds of color information:

- basematerials (3MF Core): the filament name and display color of each material.
- colorgroup (3MF Materials and Properties): one color for each material. Several
  slicers treat base materials as display only, but turn color groups into
  filament assignments.
- Metadata/model_settings.config: the filament slot of each part, which Bambu
  Studio and the OrcaSlicer family (such as Elegoo Slicer) read.
"""

from __future__ import annotations

import json
import math
import xml.etree.ElementTree as ET
import zipfile
from collections.abc import Sequence
from pathlib import Path
from typing import NamedTuple
from xml.sax.saxutils import quoteattr

from .openscad import Part
from .project import VERSION

MODEL_NAMESPACE = "http://schemas.microsoft.com/3dmanufacturing/core/2015/02"
MATERIAL_NAMESPACE = "http://schemas.microsoft.com/3dmanufacturing/material/2015/02"
XML_LANGUAGE = "{http://www.w3.org/XML/1998/namespace}lang"
ET.register_namespace("", MODEL_NAMESPACE)
ET.register_namespace("m", MATERIAL_NAMESPACE)

# The two fixed files of every 3MF package.
CONTENT_TYPES = (
    b'<?xml version="1.0" encoding="UTF-8"?>'
    b'<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
    b'<Default Extension="rels"'
    b' ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
    b'<Default Extension="model"'
    b' ContentType="application/vnd.ms-package.3dmanufacturing-3dmodel+xml"/>'
    b'<Default Extension="json" ContentType="application/json"/>'
    b'<Default Extension="config" ContentType="text/xml"/>'
    b"</Types>"
)
RELATIONSHIPS = (
    b'<?xml version="1.0" encoding="UTF-8"?>'
    b'<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
    b'<Relationship Target="/3D/3dmodel.model" Id="rel0"'
    b' Type="http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel"/>'
    b"</Relationships>"
)

# mm between pieces on the bed, so that each piece is easy to select in a slicer.
BED_MARGIN = 6.0

# Colors are written as #RRGGBB with channels from 0 to 255, then an explicit
# opaque alpha: some readers take a six-digit color as transparent.
CHANNEL_MAX = 255
OPAQUE = "FF"

# Coordinates are written with nine significant digits, enough for a float.
COORDINATE_FORMAT = ".9g"

# Metadata/KomaSCAD.json is indented by this many spaces, for people who read it.
SUMMARY_INDENT = 2

# A 4 x 4 transform that moves nothing, for model_settings.config.
IDENTITY_MATRIX = "1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1"

Bounds = tuple[float, float, float, float]  # min x, max x, min y, max y
MaterialKey = tuple[str, str]  # filament name, #RRGGBB
PlacedPiece = tuple[str, Sequence[Part]]  # preset name, its parts


class Component(NamedTuple):
    """One part of a placed piece, for model_settings.config."""

    object_id: int
    name: str
    material: MaterialKey


class BuildItem(NamedTuple):
    """One placed piece, for model_settings.config."""

    object_id: int
    name: str
    components: list[Component]


def node(parent: ET.Element, tag: str, **attributes: object) -> ET.Element:
    """Adds an element in the 3MF model namespace.

    Args:
        parent: The element to add to.
        tag: The tag name, without the namespace.
        **attributes: The attributes; every value is written as text.

    Returns:
        The new element.
    """
    text_attributes = {key: str(value) for key, value in attributes.items()}
    return ET.SubElement(parent, f"{{{MODEL_NAMESPACE}}}{tag}", text_attributes)


def hex_color(rgba: Sequence[float]) -> str:
    """Formats a color as #RRGGBB.

    Args:
        rgba: The channels, each from 0 to 1. Alpha is ignored.

    Returns:
        The color, such as "#C29657".
    """
    red, green, blue = rgba[0], rgba[1], rgba[2]
    channels = [round(CHANNEL_MAX * channel) for channel in (red, green, blue)]
    return "#" + "".join(f"{channel:02X}" for channel in channels)


def part_name(part: Part) -> str:
    """The name that a slicer shows for a part, such as "Front | Black"."""
    return part.role.title() + " | " + part.material


def material_key(part: Part) -> MaterialKey:
    """Identifies the material of a part.

    Two parts share a material only when both the filament name and the color
    match: two equal swatches can still be different filaments.
    """
    return (part.material, hex_color(part.rgba))


def piece_bounds(parts: Sequence[Part]) -> Bounds:
    """Measures the footprint of a piece on the bed.

    Args:
        parts: The parts of the piece.

    Returns:
        (min x, max x, min y, max y) in mm.
    """
    xs = []
    ys = []
    for part in parts:
        for x, y, _z in part.vertices:
            xs.append(x)
            ys.append(y)
    return (min(xs), max(xs), min(ys), max(ys))


# --- Bed layout -------------------------------------------------------------------


def grid_positions(
    bounds: list[Bounds], rows: list[int] | None = None
) -> list[tuple[float, float]]:
    """Places pieces on the bed, centered at the origin.

    Without rows, every piece gets the same cell, in a near-square grid, so no
    two pieces overlap. With rows, each row is only as deep and as wide as its
    own pieces. Rows fill from left to right, from the back of the bed. A single
    piece stays where it is.

    Args:
        bounds: The footprint of each piece, from piece_bounds().
        rows: Optional. The number of pieces in each row, from the back of the bed.

    Returns:
        The (x, y) shift of each piece.
    """
    if len(bounds) == 1:
        return [(0.0, 0.0)]
    if rows:
        return _row_positions(bounds, rows)

    widest = max(max_x - min_x for min_x, max_x, _, _ in bounds)
    deepest = max(max_y - min_y for _, _, min_y, max_y in bounds)
    cell_width = widest + BED_MARGIN
    cell_depth = deepest + BED_MARGIN

    columns = math.ceil(math.sqrt(len(bounds)))
    row_count = math.ceil(len(bounds) / columns)

    positions = []
    for index, (min_x, max_x, min_y, max_y) in enumerate(bounds):
        column = index % columns
        row = index // columns

        # The center of this cell, with the whole grid centered on the origin.
        cell_x = (column - (columns - 1) / 2) * cell_width
        cell_y = ((row_count - 1) / 2 - row) * cell_depth

        # Move the piece so that its own center lands on the cell center.
        piece_x = (min_x + max_x) / 2
        piece_y = (min_y + max_y) / 2
        positions.append((cell_x - piece_x, cell_y - piece_y))
    return positions


def fixed_positions(
    bounds: list[Bounds], positions: list[tuple[float, float]]
) -> list[tuple[float, float]]:
    """Moves each piece so that the middle of its footprint lands on a given spot.

    Args:
        bounds: The footprint of each piece, from piece_bounds().
        positions: Where the middle of each footprint goes, (x, y) in mm.

    Returns:
        The (x, y) shift of each piece.
    """
    shifts = []
    for (min_x, max_x, min_y, max_y), (x, y) in zip(bounds, positions, strict=True):
        piece_x = (min_x + max_x) / 2
        piece_y = (min_y + max_y) / 2
        shifts.append((x - piece_x, y - piece_y))
    return shifts


def _row_positions(bounds: list[Bounds], rows: list[int]) -> list[tuple[float, float]]:
    """Places pieces in planned rows. See grid_positions().

    Args:
        bounds: The footprint of each piece.
        rows: The number of pieces in each row, from the back of the bed.

    Returns:
        The (x, y) shift of each piece.
    """
    # Split the pieces into their rows.
    row_bounds = []
    first = 0
    for count in rows:
        row_bounds.append(bounds[first : first + count])
        first += count

    # Each row is as deep as its deepest piece.
    depths = []
    for row in row_bounds:
        deepest = max(max_y - min_y for _, _, min_y, max_y in row)
        depths.append(deepest + BED_MARGIN)

    positions = []
    back = sum(depths) / 2  # the back edge of the first row; the rows are centered on the bed
    for row, depth in zip(row_bounds, depths, strict=True):
        row_width = sum(max_x - min_x + BED_MARGIN for min_x, max_x, _, _ in row)
        left = -row_width / 2

        for min_x, max_x, min_y, max_y in row:
            width = max_x - min_x + BED_MARGIN

            # Each piece is centered in its own cell.
            cell_x = left + width / 2
            cell_y = back - depth / 2
            piece_x = (min_x + max_x) / 2
            piece_y = (min_y + max_y) / 2
            positions.append((cell_x - piece_x, cell_y - piece_y))

            left += width
        back -= depth
    return positions


# --- Slicer filament slots ----------------------------------------------------------


def filament_settings(items: list[BuildItem], slots: dict[MaterialKey, int]) -> str:
    """Writes Metadata/model_settings.config: the filament slot of each part.

    OrcaSlicer forks ignore the standard 3MF colors when they import a file
    (Elegoo Slicer puts every part on filament 1), but read this file: one
    object for each placed piece, one part for each component, each with its
    filament ("extruder") slot, counted from 1.

    Args:
        items: Every placed piece, in build order.
        slots: The filament slot of each material.

    Returns:
        The file text.
    """
    lines = ['<?xml version="1.0" encoding="UTF-8"?>', "<config>"]
    for item in items:
        first_material = item.components[0].material
        lines.append(f'  <object id="{item.object_id}">')
        lines.append(f'    <metadata key="name" value={quoteattr(item.name)}/>')
        lines.append(f'    <metadata key="extruder" value="{slots[first_material]}"/>')

        for component in item.components:
            lines.append(f'    <part id="{component.object_id}" subtype="normal_part">')
            lines.append(f'      <metadata key="name" value={quoteattr(component.name)}/>')
            # Components carry no transform, so each part sits as stored.
            lines.append(f'      <metadata key="matrix" value="{IDENTITY_MATRIX}"/>')
            lines.append(f'      <metadata key="extruder" value="{slots[component.material]}"/>')
            lines.append("    </part>")

        lines.append("  </object>")
    lines.append("</config>")
    return "\n".join(lines) + "\n"


# --- The model document ---------------------------------------------------------------


class _ModelXML:
    """The 3D/3dmodel.model document of a 3MF, built step by step.

    Every resource (base materials, color group, mesh, assembly) gets the next
    id, in the order in which it is added.

    Attributes:
        color_groups: The color group id of each material, in order of first appearance.
    """

    def __init__(self, title: str):
        self.root = ET.Element(
            f"{{{MODEL_NAMESPACE}}}model", {"unit": "millimeter", XML_LANGUAGE: "en-US"}
        )
        node(self.root, "metadata", name="Title").text = title
        node(self.root, "metadata", name="Application").text = "KomaSCAD " + VERSION
        self.resources = node(self.root, "resources")
        self.build = node(self.root, "build")
        self.color_groups: dict[MaterialKey, int] = {}
        self.next_id = 1

    def new_id(self) -> int:
        """Takes the next free resource id."""
        resource_id = self.next_id
        self.next_id += 1
        return resource_id

    def add_materials(self, pieces: list[PlacedPiece]) -> None:
        """Adds one base material and one color group for each material.

        Args:
            pieces: Every placed piece. Materials are added in order of first appearance.
        """
        base_materials = node(self.resources, "basematerials", id=self.new_id())
        for _, parts in pieces:
            for part in parts:
                key = material_key(part)
                if key in self.color_groups:
                    continue
                self.color_groups[key] = 0  # the id is given below
                node(base_materials, "base", name=part.material, displaycolor=key[1] + OPAQUE)

        # One color group for each material: some readers do not fully support
        # the index into a shared group.
        for key in self.color_groups:
            group_id = self.new_id()
            self.color_groups[key] = group_id
            group_tag = f"{{{MATERIAL_NAMESPACE}}}colorgroup"
            color_tag = f"{{{MATERIAL_NAMESPACE}}}color"
            group = ET.SubElement(self.resources, group_tag, {"id": str(group_id)})
            ET.SubElement(group, color_tag, {"color": key[1] + OPAQUE})

    def add_mesh(self, part: Part) -> int:
        """Stores the mesh of one part, in its material's color.

        Args:
            part: The part.

        Returns:
            The object id of the mesh.
        """
        object_id = self.new_id()
        color_group = self.color_groups[material_key(part)]
        part_object = node(
            self.resources,
            "object",
            id=object_id,
            type="model",
            name=part_name(part),
            pid=color_group,
            pindex=0,
        )
        mesh = node(part_object, "mesh")

        xml_vertices = node(mesh, "vertices")
        for x, y, z in part.vertices:
            node(
                xml_vertices,
                "vertex",
                x=format(x, COORDINATE_FORMAT),
                y=format(y, COORDINATE_FORMAT),
                z=format(z, COORDINATE_FORMAT),
            )

        xml_triangles = node(mesh, "triangles")
        for a, b, c in part.faces:
            node(xml_triangles, "triangle", v1=a, v2=b, v3=c)
        return object_id

    def add_assembly(self, name: str, mesh_ids: list[int]) -> int:
        """Adds a named object made of meshes that are already stored.

        Args:
            name: The name that the slicer shows, such as the preset name.
            mesh_ids: The object ids of the meshes.

        Returns:
            The object id of the assembly.
        """
        object_id = self.new_id()
        assembly = node(self.resources, "object", id=object_id, type="model", name=name)
        components = node(assembly, "components")
        for mesh_id in mesh_ids:
            node(components, "component", objectid=mesh_id)
        return object_id

    def place(self, object_id: int, shift: tuple[float, float] | None) -> None:
        """Puts an object on the bed.

        Args:
            object_id: The object to place.
            shift: The (x, y) move, or None to leave the object where it is.
        """
        if shift is None:
            node(self.build, "item", objectid=object_id)
            return

        x = format(shift[0], COORDINATE_FORMAT)
        y = format(shift[1], COORDINATE_FORMAT)
        # A 3MF transform is a 3 x 3 matrix (here, no rotation) and then the move.
        node(self.build, "item", objectid=object_id, transform=f"1 0 0 0 1 0 0 0 1 {x} {y} 0")

    def to_bytes(self) -> bytes:
        return ET.tostring(self.root, encoding="utf-8", xml_declaration=True)


# --- Writing the file -----------------------------------------------------------------


def create_3mf(
    destination: Path,
    pieces: list[PlacedPiece],
    title: str,
    rows: list[int] | None = None,
    slicer_settings: bool = True,
    positions: list[tuple[float, float]] | None = None,
) -> list[dict]:
    """Writes one or more pieces as a multipart color 3MF.

    Args:
        destination: The .3mf file to write.
        pieces: (preset name, parts) for each piece to place. Repeat a pair to
            place more copies: the copies share one stored mesh, but each is its
            own named object.
        title: The model title.
        rows: Optional. A row plan for grid_positions().
        slicer_settings: Also write the filament slot of each part (see
            filament_settings()). Turn it off for a tool that cannot read them,
            such as Bambu Studio 2.8's command line.
        positions: Optional. Where the middle of each piece's footprint goes,
            (x, y) in mm from the middle of the bed. They replace the grid and
            the row plan.

    Returns:
        One record for each placed piece: its preset, object id, x and y
        shift, and parts.
    """
    model = _ModelXML(title)
    model.add_materials(pieces)
    slots = _filament_slots(model.color_groups)

    footprints = [piece_bounds(parts) for _, parts in pieces]
    if positions:
        shifts = fixed_positions(footprints, positions)
    else:
        shifts = grid_positions(footprints, rows)
    single_piece = len(pieces) == 1 and not positions

    mesh_ids: dict[str, list[int]] = {}
    placed = []
    build_items = []
    for (preset, parts), shift in zip(pieces, shifts, strict=True):
        # A copy uses the meshes stored for the first copy of its preset.
        if preset not in mesh_ids:
            mesh_ids[preset] = [model.add_mesh(part) for part in parts]

        # Every copy gets its own named object: Bambu Studio turns build items
        # that share one object into unnamed duplicates.
        object_id = model.add_assembly(preset, mesh_ids[preset])
        if single_piece:
            model.place(object_id, None)
        else:
            model.place(object_id, shift)

        build_items.append(_build_item(object_id, preset, mesh_ids[preset], parts))
        placed.append(_placement_record(object_id, preset, shift, parts))

    settings = None
    if slicer_settings:
        settings = filament_settings(build_items, slots)
    _write_package(destination, model, settings, _summary(placed, slots))
    return placed


def _filament_slots(color_groups: dict[MaterialKey, int]) -> dict[MaterialKey, int]:
    """Gives each material a filament slot, counted from 1.

    The slots follow the order in which the materials first appear: body, then
    front, then back lettering. The bundled sets therefore read Wood 1, Black 2, Red 3.

    Args:
        color_groups: Every material, in order of first appearance.

    Returns:
        The filament slot of each material.
    """
    slots = {}
    for slot, key in enumerate(color_groups, start=1):
        slots[key] = slot
    return slots


def _build_item(
    object_id: int, preset: str, mesh_ids: list[int], parts: Sequence[Part]
) -> BuildItem:
    """Describes one placed piece for model_settings.config.

    Args:
        object_id: The object id of the placed piece.
        preset: The preset name.
        mesh_ids: The object id of each part's mesh.
        parts: The parts, in the same order as mesh_ids.

    Returns:
        The piece and its components.
    """
    components = []
    for mesh_id, part in zip(mesh_ids, parts, strict=True):
        components.append(Component(mesh_id, part_name(part), material_key(part)))
    return BuildItem(object_id, preset, components)


def _placement_record(
    object_id: int, preset: str, shift: tuple[float, float], parts: Sequence[Part]
) -> dict:
    """Describes one placed piece for Metadata/KomaSCAD.json and the caller.

    Args:
        object_id: The object id of the placed piece.
        preset: The preset name.
        shift: How far the piece was moved on the bed, (x, y) in mm.
        parts: The parts of the piece.

    Returns:
        The preset, object id, x and y shift, and each part's role, material and color.
    """
    part_records = []
    for part in parts:
        part_records.append(
            {
                "part": part.role,
                "material": part.material,
                "display_color": hex_color(part.rgba),
            }
        )

    x, y = shift
    return {"preset": preset, "object_id": object_id, "x": x, "y": y, "parts": part_records}


def _summary(placed: list[dict], slots: dict[MaterialKey, int]) -> dict:
    """Makes Metadata/KomaSCAD.json: what the file holds, for people and tools.

    Args:
        placed: The record of each placed piece.
        slots: The filament slot of each material.

    Returns:
        The summary, ready to write as JSON.
    """
    slot_records = []
    for (material, color), slot in slots.items():
        slot_records.append({"slot": slot, "material": material, "display_color": color})

    return {
        "version": VERSION,
        "units": "mm",
        "pieces": placed,
        "filament_slots": slot_records,
        "type": "portable multipart model with standard color assignments; no printer settings",
    }


def _write_package(
    destination: Path, model: _ModelXML, settings: str | None, summary: dict
) -> None:
    """Writes the 3MF package: a zip file of the model and its metadata.

    Args:
        destination: The .3mf file to write.
        model: The model document.
        settings: The text of model_settings.config, or None to leave it out.
        summary: The content of Metadata/KomaSCAD.json.
    """
    with zipfile.ZipFile(destination, "w", zipfile.ZIP_DEFLATED) as archive:
        archive.writestr("[Content_Types].xml", CONTENT_TYPES)
        archive.writestr("_rels/.rels", RELATIONSHIPS)
        archive.writestr("3D/3dmodel.model", model.to_bytes())
        if settings is not None:
            archive.writestr("Metadata/model_settings.config", settings)
        summary_text = json.dumps(summary, ensure_ascii=False, indent=SUMMARY_INDENT)
        archive.writestr("Metadata/KomaSCAD.json", summary_text)

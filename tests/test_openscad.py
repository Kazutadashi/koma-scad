"""Preset values for OpenSCAD, and reading the STL files that it writes."""

import struct
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from komascad_lib import openscad
from komascad_lib.project import KomaError

# A unit cube: 8 corners and 12 triangles, wound outward.
CUBE_POINTS = [
    (0, 0, 0),
    (1, 0, 0),
    (1, 1, 0),
    (0, 1, 0),
    (0, 0, 1),
    (1, 0, 1),
    (1, 1, 1),
    (0, 1, 1),
]
CUBE_FACES = [
    (0, 2, 1),
    (0, 3, 2),
    (4, 5, 6),
    (4, 6, 7),
    (0, 1, 5),
    (0, 5, 4),
    (1, 2, 6),
    (1, 6, 5),
    (2, 3, 7),
    (2, 7, 6),
    (3, 0, 4),
    (3, 4, 7),
]


def cube(offset=(0.0, 0.0, 0.0)):
    """Makes the triangles of a unit cube.

    Args:
        offset: Where the cube's lowest corner is.

    Returns:
        Twelve triangles, each as three (x, y, z) corners.
    """
    dx, dy, dz = offset
    points = []
    for x, y, z in CUBE_POINTS:
        points.append((float(x + dx), float(y + dy), float(z + dz)))

    triangles = []
    for a, b, c in CUBE_FACES:
        triangles.append([points[a], points[b], points[c]])
    return triangles


def write_stl(path, triangles):
    """Write a binary STL: an 80-byte header, the count, then 50 bytes per triangle."""
    data = bytearray(80) + struct.pack("<I", len(triangles))
    for triangle in triangles:
        data += struct.pack("<12fH", 0, 0, 0, *[c for corner in triangle for c in corner], 0)
    path.write_bytes(bytes(data))


class STLTests(unittest.TestCase):
    """Binary STL files are read into closed meshes."""

    def read(self, triangles):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "part.stl"
            write_stl(path, triangles)
            return openscad.read_stl(path)

    def test_closed_mesh_shares_its_vertices(self):
        vertices, faces = self.read(cube())
        self.assertEqual((len(vertices), len(faces)), (8, 12))

    def test_shells_that_touch_at_an_edge_are_kept_apart(self):
        """Two cubes that share one edge are two closed shells, not one broken mesh."""
        vertices, faces = self.read(cube() + cube((1.0, 1.0, 0.0)))
        self.assertEqual((len(vertices), len(faces)), (16, 24))

    def test_open_mesh_is_rejected(self):
        with self.assertRaisesRegex(KomaError, "not a closed"):
            self.read(cube()[:-1])


class DefinitionTests(unittest.TestCase):
    """Saved presets become OpenSCAD -D arguments."""

    def test_values_are_typed_and_overrides_win(self):
        definitions = openscad.scad_definitions(
            "Test",
            {"Piece_Length": "30", "Front_Characters": "歩", "Output_Mode": "Inspect front"},
            {"Piece_Length": 31},
        )
        self.assertEqual(definitions, ["-D", "Piece_Length=31", "-D", 'Front_Characters="歩"'])

    def test_hidden_and_retired_settings_are_ignored(self):
        self.assertEqual(
            openscad.scad_definitions(
                "Test", {"Export_Metadata": "false", "Paint_Floor_Thickness": "0.8"}, {}
            ),
            [],
        )

    def test_unknown_setting_is_rejected(self):
        with self.assertRaisesRegex(KomaError, "Piece_Lenght"):
            openscad.scad_definitions("Test", {"Piece_Lenght": "30"}, {})


class RenderFailureTests(unittest.TestCase):
    """When OpenSCAD fails, the export stops with OpenSCAD's own message."""

    def render_with(self, *results):
        """Runs render_parts with each OpenSCAD run returning the next (status, output)."""
        replies = iter(results)
        with mock.patch.object(openscad, "run_openscad", lambda command: next(replies)):
            openscad.render_parts("openscad", [])

    def test_unreadable_piece_shows_the_openscad_error(self):
        with self.assertRaisesRegex(KomaError, "could not read the piece:\n.*Assertion failed"):
            self.render_with((1, "ERROR: Assertion failed: Bevel Width is too large."))

    def test_missing_material_report_is_explained(self):
        with self.assertRaisesRegex(KomaError, "did not report the materials"):
            self.render_with((0, "ECHO: something else"))

    def test_failed_render_shows_the_openscad_error(self):
        report = 'ECHO: "KOMASCAD_EXPORT", [["body", "Wood", [0.8, 0.6, 0.4, 1], true]]'
        with self.assertRaisesRegex(KomaError, "could not export color parts:\n.*CGAL"):
            self.render_with((0, report), (1, "ERROR: CGAL error in union"))

    def test_touching_shell_warnings_are_not_errors(self):
        self.assertTrue(
            openscad._is_touching_shell_warning(
                "WARNING: Exported object may not be a valid 2-manifold and may need repair"
            )
        )
        self.assertFalse(openscad._is_touching_shell_warning("WARNING: Ignoring unknown variable"))


if __name__ == "__main__":
    unittest.main()

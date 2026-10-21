"""Writing 3MF files, without rendering anything."""

import re
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

from komascad_lib import threemf

from .support import PARTS, part


class ThreeMFTests(unittest.TestCase):
    """3MF files hold the right parts, names, colors and layout."""

    def write(self, pieces, **options):
        """Write a 3MF in a temporary folder. Returns its model XML and placed records."""
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "out.3mf"
            placed = threemf.create_3mf(output, pieces, "Title", **options)
            with zipfile.ZipFile(output) as archive:
                files = {name: archive.read(name) for name in archive.namelist()}
        return files, placed

    def test_single_piece_keeps_its_coordinates(self):
        files, _ = self.write([("Pawn", PARTS)])
        model = files["3D/3dmodel.model"].decode("utf-8")
        self.assertEqual(model.count("<item "), 1)
        self.assertNotIn("transform", model)
        self.assertIn('name="Body | PLA"', model)

    def test_layout_keeps_presets_as_separate_placed_objects(self):
        """A layout holds separate objects and no printer profile."""
        files, _ = self.write([("Pawn", PARTS), ("King", PARTS)])
        model = files["3D/3dmodel.model"].decode("utf-8")
        self.assertIn('name="Pawn"', model)
        self.assertIn('name="King"', model)
        self.assertEqual(model.count("<item "), 2)
        self.assertIn("no printer settings", files["Metadata/KomaSCAD.json"].decode("utf-8"))

    def test_repeated_presets_are_placed_again_but_stored_once(self):
        """Copies of a piece add build items without storing its mesh again."""
        files, placed = self.write([("Pawn", PARTS)] * 3 + [("King", PARTS)])
        model = files["3D/3dmodel.model"].decode("utf-8")
        self.assertEqual(model.count("<item "), 4)
        self.assertEqual(model.count("<mesh>"), 2)
        # Each copy is its own named object, so that slicers keep the name.
        self.assertEqual(model.count('name="Pawn"'), 3)
        self.assertEqual(len(set(re.findall(r'<item objectid="(\d+)"', model))), 4)
        self.assertEqual(len({(entry["x"], entry["y"]) for entry in placed}), 4)

    def test_slicer_settings_put_each_part_on_its_filament_slot(self):
        """model_settings.config ids match the model, and slots follow the materials."""
        pawn = [
            part("body", "Wood", (0.8, 0.6, 0.4, 1)),
            part("front", "Black", (0, 0, 0, 1)),
            part("back", "Red", (1, 0, 0, 1)),
        ]
        gold = [part("body", "Wood", (0.8, 0.6, 0.4, 1)), part("front", "Black", (0, 0, 0, 1))]
        files, _ = self.write([("Pawn", pawn), ("Pawn", pawn), ("Gold", gold)])
        model = ET.fromstring(files["3D/3dmodel.model"])
        config = ET.fromstring(files["Metadata/model_settings.config"])
        namespace = {"c": threemf.MODEL_NAMESPACE}
        items = [item.get("objectid") for item in model.find("c:build", namespace)]
        objects = config.findall("object")
        # One block per placed piece, copies included, in build order.
        self.assertEqual([o.get("id") for o in objects], items)
        components = {
            o.get("id"): [
                c.get("objectid") for c in o.iter(f"{{{threemf.MODEL_NAMESPACE}}}component")
            ]
            for o in model.iter(f"{{{threemf.MODEL_NAMESPACE}}}object")
        }
        slots = {}
        for o in objects:
            self.assertEqual([p.get("id") for p in o.findall("part")], components[o.get("id")])
            for p in o.findall("part"):
                meta = {m.get("key"): m.get("value") for m in p.findall("metadata")}
                slots[meta["name"]] = meta["extruder"]
        self.assertEqual(slots, {"Body | Wood": "1", "Front | Black": "2", "Back | Red": "3"})
        self.assertIn('Extension="config"', files["[Content_Types].xml"].decode("utf-8"))

    def test_plain_files_leave_out_slicer_settings(self):
        """--plain writes only standard 3MF, which Bambu Studio's command line can load."""
        files, _ = self.write([("Pawn", PARTS)], slicer_settings=False)
        self.assertNotIn("Metadata/model_settings.config", files)

    def test_grid_centres_pieces_without_overlap(self):
        """Pieces fill a near-square grid, each in its own cell around the origin."""
        self.assertEqual(threemf.grid_positions([(5.0, 15.0, 0.0, 20.0)]), [(0.0, 0.0)])
        positions = threemf.grid_positions([(0.0, 10.0, 0.0, 20.0)] * 4)
        # 10 x 20 mm pieces plus the 6 mm margin make 16 x 26 mm cells.
        self.assertEqual(positions, [(-13.0, 3.0), (3.0, 3.0), (-13.0, -23.0), (3.0, -23.0)])

    def test_row_plan_packs_mixed_sizes_row_by_row(self):
        """Planned rows are centered, as deep as their own pieces, and do not overlap."""
        big, small = (0.0, 40.0, 0.0, 40.0), (0.0, 10.0, 0.0, 10.0)
        (big_x, big_y), (left_x, left_y), (right_x, right_y) = threemf.grid_positions(
            [big, small, small], rows=[1, 2]
        )
        # Lower-left corners: the big piece is centered behind two small ones.
        self.assertEqual((big_x, left_x, right_x), (-20.0, -13.0, 3.0))
        # The 10 mm pieces end one 6 mm margin in front of the big piece.
        self.assertEqual(big_y - (left_y + 10.0), 6.0)
        self.assertEqual(left_y, right_y)

    def test_fixed_positions_center_each_footprint_on_its_spot(self):
        footprints = [(0.0, 10.0, 0.0, 20.0), (-5.0, 5.0, -5.0, 5.0)]
        shifts = threemf.fixed_positions(footprints, [(100.0, -50.0), (0.0, 0.0)])
        self.assertEqual(shifts, [(95.0, -60.0), (0.0, 0.0)])

    def test_one_piece_at_a_fixed_position_is_moved(self):
        """A single piece normally keeps its coordinates, but a fixed position moves it."""
        files, placed = self.write([("Pawn", PARTS)], positions=[(50.0, 50.0)])
        self.assertIn("transform", files["3D/3dmodel.model"].decode("utf-8"))
        self.assertEqual((placed[0]["x"], placed[0]["y"]), (45.0, 45.0))


if __name__ == "__main__":
    unittest.main()

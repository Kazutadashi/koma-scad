"""The print test page stays fixed and exportable."""

import json
import re
import unittest

from komascad_lib import print_test_page
from komascad_lib.openscad import scad_definitions
from komascad_lib.project import TEST_PAGE


class TestPageTests(unittest.TestCase):
    """The print test page stays fixed and exportable."""

    def setUp(self):
        self.plates = print_test_page.build_test_page()

    def pieces(self):
        """Every piece of the page, in order, across all plates."""
        merged = {}
        for plate in self.plates:
            merged.update(plate.presets)
        return merged

    def test_build_writes_every_plate_and_nothing_else(self):
        """Every committed plate file is one that the build makes."""
        self.assertEqual(
            sorted(path.name for path in TEST_PAGE.glob("*.json")),
            sorted(plate.filename for plate in self.plates),
        )

    def test_page_fills_its_budget_in_planned_rows(self):
        """The page has 59 pieces, and each plate's rows place all of its pieces."""
        self.assertEqual(len(self.pieces()), 59)
        for plate in self.plates:
            self.assertEqual(sum(plate.rows), len(plate.presets), plate.filename)
            # The exporter places presets in sorted order; the rows rely on it.
            self.assertEqual(sorted(plate.presets), list(plate.presets), plate.filename)

    def test_presets_use_only_parameters_the_model_declares(self):
        for name, preset in self.pieces().items():
            scad_definitions(name, preset, {})

    def test_pieces_print_face_down_with_a_red_reverse(self):
        """The front lies on the bed, so it is never raised; the reverse is red."""
        for name, preset in self.pieces().items():
            self.assertEqual(preset["Print_Orientation"], "Front face down", name)
            self.assertEqual(preset["Back_Filament"], "Red", name)
            self.assertEqual(preset["Front_Text_Style"], "Recessed", name)
            self.assertTrue(preset["Back_Characters"], name)

    def test_stroke_sweep_changes_only_the_stroke_and_its_label(self):
        """Pieces of one sweep are otherwise identical, on both faces."""
        row = [preset for name, preset in self.pieces().items() if " 1x Yuji Syuku stroke " in name]
        expected = ["-0.1", "-0.03", "0.04", "0.11", "0.18"]
        self.assertEqual([p["Front_Stroke_Expansion"] for p in row], expected)
        self.assertEqual([p["Back_Stroke_Expansion"] for p in row], expected)
        self.assertEqual(
            [p["Signature_Text"] for p in row], ["3-06", "3-07", "3-08", "3-09", "3-10"]
        )
        varying = {key for key in row[0] if len({p[key] for p in row}) > 1}
        self.assertEqual(
            varying,
            {"Front_Stroke_Expansion", "Back_Stroke_Expansion", "Signature_Text", "Category"},
        )

    def test_every_piece_has_a_unique_red_heel_label_naming_its_plate(self):
        """Labels match the preset name; small pieces use distinct dot codes."""
        labels = []
        for name, preset in self.pieces().items():
            identifier = re.search(r" - (\d)-(\d\d) ", name)
            plate, piece = int(identifier.group(1)), int(identifier.group(2))
            self.assertEqual(preset["Signature_Enabled"], "true", name)
            self.assertEqual(preset["Signature_Filament"], "Red", name)
            if float(preset["Model_Scale"]) >= 1:
                self.assertEqual(preset["Signature_Text"], f"{plate}-{piece:02d}", name)
            else:
                self.assertEqual(
                    preset["Signature_Text"], print_test_page.dot_code(plate, piece), name
                )
            labels.append(preset["Signature_Text"])
        self.assertEqual(len(set(labels)), len(labels))

    def test_dot_code_is_unique_and_never_joins_dots_at_a_corner(self):
        """Codes start with a full column and avoid shapes that OpenSCAD cannot extrude."""
        quadrants = print_test_page.QUADRANTS
        left_filled = {character for dots, character in quadrants.items() if dots[0] and dots[2]}
        codes = {
            print_test_page.dot_code(plate, piece) for plate in (1, 2, 3) for piece in range(1, 81)
        }
        self.assertEqual(len(codes), 3 * 80)
        self.assertTrue(all(len(code) == 3 and code[0] in left_filled for code in codes))
        # A top dot always has the bottom dot under it.
        hanging = {
            character
            for (ul, ur, ll, lr), character in quadrants.items()
            if (ul and not ll) or (ur and not lr)
        }
        self.assertFalse(any(set(code) & hanging for code in codes))
        # Plate 3, piece 5: start, two dots, then 0, 0, 1, 2 in base three.
        self.assertEqual(print_test_page.dot_code(3, 5), "█　▟")

    def test_one_character_pieces_cover_both_fonts_at_every_size(self):
        names = [name for name in self.pieces() if name.endswith(" one character")]
        self.assertEqual(len(names), 10)
        for size in ("0.25x", "0.5x", "1x", "1.5x", "2x"):
            for family in ("Yuji Syuku", "LXGW WenKai Mono"):
                self.assertTrue(any(f" {size} {family} " in name for name in names), (size, family))

    def test_every_size_has_both_fonts_at_the_stroke_extremes(self):
        names = list(self.pieces())
        for size in ("0.25x", "0.5x", "1x", "1.5x", "2x"):
            for family in ("Yuji Syuku", "LXGW WenKai Mono"):
                found = [name for name in names if f" {size} {family} stroke " in name]
                for stroke in ("very thin", "normal", "very thick"):
                    self.assertTrue(
                        any(name.endswith(" " + stroke) for name in found), (size, family, stroke)
                    )

    def test_ladders_are_full_size_with_each_width_once_per_group(self):
        """Ladders are in final mm; each pattern is on the bed face and the top face."""
        ladders = {name: p for name, p in self.pieces().items() if " Ladder " in name}
        self.assertEqual(len(ladders), 6)
        widths = print_test_page.LADDER_WIDTHS
        for name, ladder in ladders.items():
            self.assertEqual(ladder["Model_Scale"], "1", name)
            self.assertIn(
                len(ladder["Back_Characters"]), (2 * len(widths), 2 * (len(widths) + 1)), name
            )
        lines_down = next(p for name, p in ladders.items() if "L1" in name)
        self.assertEqual(json.loads(lines_down["Front_Glyph_Height"])[: len(widths)], widths)
        self.assertEqual(json.loads(lines_down["Front_Glyph_Width"])[len(widths) :], widths)
        gaps_down = next(p for name, p in ladders.items() if "L2" in name)
        self.assertEqual(gaps_down["Back_Glyph_Width"], lines_down["Front_Glyph_Width"])


if __name__ == "__main__":
    unittest.main()

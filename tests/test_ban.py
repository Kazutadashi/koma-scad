"""The board: reading the model's report, planning the files, and the ban command."""

import json
import shutil
import tempfile
import unittest
import zipfile
from pathlib import Path

from komascad_lib import ban, threemf
from komascad_lib.openscad import Part
from komascad_lib.project import BAN_PRESETS, KomaError

from .support import part, run

# What ban.scad prints for a 2 x 2 board in its Export_Metadata run.
TWO_BY_TWO_LOG = """\
ECHO: "KOMASCAD_FONTS", []
ECHO: "KOMASCAD_EXPORT", [["body", "Wood", [0.76, 0.58, 0.34, 1], true], \
["markings", "Black", [0.08, 0.06, 0.04, 1], true]]
ECHO: "KOMASCAD_BAN", [192, 208.5, 12], [2, 2], [[0, 0, 113.975, 123.875, 0, 0], \
[1, 0, 78.025, 123.875, 113.975, 0], [0, 1, 113.975, 84.625, 0, 123.875], \
[1, 1, 78.025, 84.625, 113.975, 123.875]], 0, "Connectors"
"""

ONE_PIECE_LOG = """\
ECHO: "KOMASCAD_EXPORT", [["body", "Wood", [0.76, 0.58, 0.34, 1], true], \
["markings", "Black", [0.08, 0.06, 0.04, 1], true]]
ECHO: "KOMASCAD_BAN", [192, 208.5, 12], [1, 1], [[0, 0, 192, 208.5, 0, 0]], 0, "Connectors"
"""

# The same 2 x 2 board with 10 connectors and 2 spares.
CONNECTORS_LOG = TWO_BY_TWO_LOG.replace("]], 0,", "]], 12,")


class BoardReportTests(unittest.TestCase):
    """The model's report becomes a board, and the board becomes a list of files."""

    def setUp(self):
        self.board = ban.parse_board("Mini", TWO_BY_TWO_LOG)

    def test_report_gives_the_size_panels_and_materials(self):
        self.assertEqual(self.board.size, [192, 208.5, 12])
        self.assertEqual((self.board.columns, self.board.rows), (2, 2))
        self.assertEqual(
            [panel.address for panel in self.board.panels], ["00-00", "01-00", "00-01", "01-01"]
        )
        self.assertEqual(self.board.panels[3].x, 113.975)
        self.assertEqual([role for role, _, _ in self.board.materials], ["body", "markings"])

    def test_missing_report_is_explained(self):
        with self.assertRaisesRegex(KomaError, "did not report the panels"):
            ban.parse_board("Mini", "ECHO: something else")

    def test_tiled_board_has_one_whole_board_file_and_one_per_panel(self):
        names = [planned.filename for planned in ban.plan_files(self.board)]
        self.assertEqual(names[0], "Mini - Whole board.3mf")
        self.assertEqual(names[1], "Mini - Panel 00-00.3mf")
        self.assertEqual(len(names), 5)

    def test_one_piece_board_is_one_file(self):
        board = ban.parse_board("Mini: one/piece", ONE_PIECE_LOG)
        self.assertEqual(
            [planned.filename for planned in ban.plan_files(board)], ["Mini - one - piece.3mf"]
        )

    def test_board_with_connectors_has_a_file_of_connectors(self):
        board = ban.parse_board("Mini", CONNECTORS_LOG)
        self.assertEqual((board.loose, board.loose_name), (12, "Connectors"))
        self.assertEqual(ban.plan_files(board)[-1].filename, "Mini - Connectors.3mf")

    def test_each_panel_goes_in_after_its_left_and_front_neighbors(self):
        order = [panel.address for panel in ban.assembly_order(self.board)]
        self.assertEqual(order, ["00-00", "01-00", "00-01", "01-01"])

    def test_neighbors_are_named_by_side(self):
        corner = self.board.panels[3]
        self.assertEqual(ban.neighbors(self.board, corner), {"left": "00-01", "front": "01-00"})

    def test_a_markings_part_as_tall_as_the_board_is_rejected(self):
        board = ban.parse_board("Mini", TWO_BY_TWO_LOG)
        ban.check_role("body", [(0, 0, 0), (0, 0, 12)], board)
        ban.check_role("markings", [(0, 0, 11.6), (0, 0, 12)], board)
        with self.assertRaisesRegex(KomaError, "as tall as the board"):
            ban.check_role("markings", [(0, 0, 0), (0, 0, 12)], board)
        with self.assertRaisesRegex(KomaError, "body rendered only"):
            ban.check_role("body", [(0, 0, 11.6), (0, 0, 12)], board)

    def test_pieces_that_fit_share_a_plate(self):
        pieces = [(name, square(100, 110)) for name in ("a", "b", "c", "d")]
        pieces.append(("Connectors", square(200, 20)))
        positions, plates = ban.pack_plates(pieces, (256, 256))
        self.assertEqual(plates, [0, 0, 0, 0, 0])
        # Two rows of two panels, the connectors in front, all on one bed.
        self.assertTrue(all(0 < x < 256 and 0 < y < 256 for x, y in positions))
        self.assertGreater(positions[0][1], positions[2][1])
        self.assertLess(positions[4][1], positions[2][1])

    def test_pieces_too_large_for_one_bed_get_more_plates(self):
        # The panels of a full shogi board in 2 x 2: one on each 256 mm bed.
        pieces = [
            ("01", square(186, 163)),
            ("11", square(150, 163)),
            ("00", square(186, 202)),
            ("10", square(150, 202)),
            ("Connectors", square(229, 31)),
        ]
        positions, plates = ban.pack_plates(pieces, (256, 256))
        self.assertEqual(plates, [0, 1, 2, 3, 0])
        # Each piece lies inside its plate, in the grid that the slicers use.
        for (x, y), plate in zip(positions, plates, strict=True):
            left, front = threemf.plate_origin(plate, 4, (256, 256))
            self.assertTrue(left < x < left + 256 and front < y < front + 256)

    def test_the_plate_grid_follows_bambu_studio(self):
        self.assertEqual(
            [threemf.plate_columns(count) for count in (1, 2, 3, 4, 5, 9)], [1, 2, 2, 2, 3, 3]
        )
        self.assertEqual(threemf.plate_origin(1, 2, (256, 256)), (307.2, 0))
        self.assertEqual(threemf.plate_origin(2, 3, (256, 200)), (0, -240.0))

    def test_bed_puts_the_back_row_at_the_back(self):
        ordered, rows = ban.bed_order(self.board.panels, self.board)
        self.assertEqual([panel.address for panel in ordered], ["00-01", "01-01", "00-00", "01-00"])
        self.assertEqual(rows, [2, 2])


def square(width, depth):
    """A flat part of the given footprint, enough to place on a bed."""
    return [Part("body", "PLA", (0, 0, 0, 1), [(0, 0, 0), (width, depth, 0)], [])]


class BanCommandTests(unittest.TestCase):
    """The ban command, with OpenSCAD replaced by stubs."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.out = Path(folder.name) / "board"
        self.rendered = []
        self.stub(
            ban,
            "read_board",
            lambda executable, name, definitions: ban.parse_board(name, TWO_BY_TWO_LOG),
        )
        self.stub(ban, "render_panels", self.render)

    def stub(self, module, name, replacement):
        original = getattr(module, name)
        self.addCleanup(setattr, module, name, original)
        setattr(module, name, replacement)

    def render(self, executable, definitions, board):
        self.rendered.append(board.name)
        panels = [[part("body"), part("markings", "Black")] for _ in board.panels]
        return panels, (part("connectors") if board.loose else None)

    def test_without_a_board_the_presets_are_listed(self):
        status, out, _ = run("ban")
        self.assertEqual(status, 0)
        self.assertIn("Minishogi - 2 x 2 panels  (5 x 5 squares, 2 x 2 panels)", out)

    def test_export_writes_each_panel_and_a_manifest(self):
        status, out, _ = run("ban", "Minishogi - 2 x 2 panels", "-o", self.out)

        self.assertEqual(status, 0, out)
        self.assertIn("Saved 5 new 3MF file(s)", out)
        manifest = json.loads((self.out / "manifest.json").read_text(encoding="utf-8"))
        self.assertEqual(manifest["source_scad"], "ban/ban.scad")
        self.assertEqual(manifest["source_parameters"], "ban/ban.json")
        self.assertEqual(manifest["assembly_order"], ["00-00", "01-00", "00-01", "01-01"])
        self.assertEqual(len(manifest["files"]), 5)
        self.assertEqual(manifest["settings"]["Joint_Style"], "Connectors")

        with zipfile.ZipFile(self.out / "Minishogi - 2 x 2 panels - Whole board.3mf") as archive:
            settings = archive.read("Metadata/model_settings.config").decode("utf-8")
        self.assertEqual(settings.count('subtype="normal_part"'), 8)

    def test_the_whole_board_file_also_holds_the_connectors(self):
        self.stub(
            ban,
            "read_board",
            lambda executable, name, definitions: ban.parse_board(name, CONNECTORS_LOG),
        )
        status, out, _ = run("ban", "Minishogi - 2 x 2 panels", "-o", self.out)

        self.assertEqual(status, 0, out)
        with zipfile.ZipFile(self.out / "Minishogi - 2 x 2 panels - Whole board.3mf") as archive:
            summary = json.loads(archive.read("Metadata/KomaSCAD.json"))
            settings = archive.read("Metadata/model_settings.config").decode("utf-8")
        names = [piece["preset"] for piece in summary["pieces"]]
        self.assertEqual(names[-1], "Connectors")
        self.assertEqual(len(names), 5)
        self.assertIn('<metadata key="plater_id" value="1"/>', settings)
        self.assertTrue((self.out / "Minishogi - 2 x 2 panels - Connectors.3mf").exists())

    def test_existing_files_are_skipped_without_rendering(self):
        run("ban", "Minishogi - 2 x 2 panels", "-o", self.out)
        status, out, _ = run("ban", "Minishogi - 2 x 2 panels", "-o", self.out)
        self.assertEqual(status, 0)
        self.assertIn("skipped 5 existing", out)
        self.assertEqual(len(self.rendered), 1)

    def test_dry_run_writes_nothing(self):
        status, out, _ = run("ban", "Minishogi - 2 x 2 panels", "-o", self.out, "-n")
        self.assertEqual(status, 0)
        self.assertIn("Whole board.3mf  (4 panel(s))", out)
        self.assertFalse(self.out.exists())

    def test_unknown_board_is_explained(self):
        status, _, err = run("ban", "go board", "-o", self.out)
        self.assertEqual(status, 1)
        self.assertIn("No board matches 'go board'", err)

    def test_a_name_must_pick_one_board(self):
        status, _, err = run("ban", "minishogi", "-o", self.out)
        self.assertEqual(status, 1)
        self.assertIn("matches more than one board", err)


@unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD")
class BoardExportTests(unittest.TestCase):
    """A real board export, from a bundled preset."""

    def test_one_piece_board_exports_two_aligned_parts(self):
        with tempfile.TemporaryDirectory() as folder:
            out = Path(folder)
            status, _, err = run("ban", "Custom - 2 x 3 squares", "-o", out)

            self.assertEqual(status, 0, err)
            self.assertEqual(
                sorted(path.name for path in out.iterdir()),
                ["Custom - 2 x 3 squares.3mf", "manifest.json"],
            )
            with zipfile.ZipFile(out / "Custom - 2 x 3 squares.3mf") as archive:
                summary = json.loads(archive.read("Metadata/KomaSCAD.json"))
        parts = summary["pieces"][0]["parts"]
        self.assertEqual(
            [(entry["part"], entry["material"]) for entry in parts],
            [("body", "Kaya"), ("markings", "Black")],
        )

    def test_every_bundled_board_can_be_read(self):
        names = json.loads(BAN_PRESETS.read_text(encoding="utf-8"))["parameterSets"]
        for name, values in names.items():
            with self.subTest(board=name):
                board = ban.read_preset("openscad", name, values)
                columns, rows = ban.panel_grid(ban.resolved_settings(values))
                self.assertEqual(len(board.panels), columns * rows)


if __name__ == "__main__":
    unittest.main()

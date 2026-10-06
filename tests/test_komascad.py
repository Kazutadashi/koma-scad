"""Tests for the komascad command-line tool. None of them start OpenSCAD."""

import contextlib
import io
import json
import sys
import tempfile
import unittest
import zipfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
import komascad  # noqa: E402

TRIANGLE = [(0.0, 0.0, 0.0), (10.0, 0.0, 0.0), (0.0, 10.0, 0.0)]
PARTS = [("body", "PLA", (0.0, 0.0, 0.0, 1.0), TRIANGLE, [(0, 1, 2)])]


def run(*arguments):
    """Run one command quietly; return ``(exit status, stdout, stderr)``."""
    out, err = io.StringIO(), io.StringIO()
    with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
        status = komascad.main([str(argument) for argument in arguments])
    return status, out.getvalue(), err.getvalue()


class BuildTests(unittest.TestCase):
    """Check that games stay in step with the master piece list."""

    def test_generated_files_are_up_to_date(self):
        """Committed game files and shogi_piece.json match the piece files."""
        outputs = komascad.generated_files(komascad.build_games())
        self.assertEqual(komascad.stale_files(outputs), [])
        self.assertEqual(run("build", "--check")[0], 0)

    def test_games_share_one_piece_definition(self):
        """A piece has the same body in every game that uses it."""
        games = komascad.build_games()
        self.assertEqual(
            games["minishogi"][0]["Minishogi 07 - Pawn"]["Piece_Length"],
            games["shogi-1char"][0]["Shogi 1-char 09 - Pawn"]["Piece_Length"],
        )

    def test_full_sets_have_the_standard_piece_totals(self):
        """Shogi needs 40 pieces and minishogi 12, counting both players."""
        games = komascad.build_games()
        self.assertEqual(sum(games["shogi"][1].values()), 40)
        self.assertEqual(sum(games["minishogi-1char"][1].values()), 12)

    def test_unknown_parameter_is_rejected(self):
        """A misspelled parameter name fails instead of being silently ignored."""
        defaults = komascad.read_json(komascad.PIECES / "_defaults.json")
        piece = komascad.read_json(komascad.PIECES / "pawn.json")
        piece["body"]["Peice_Length"] = "28"
        with self.assertRaisesRegex(ValueError, "Peice_Length"):
            komascad.build_preset(defaults, piece, "pawn", "two", "one")

    def test_bundled_presets_use_only_parameters_the_model_declares(self):
        """Every generated preset can be turned into OpenSCAD definitions."""
        for sets, _ in komascad.build_games().values():
            for name, values in sets.items():
                komascad.scad_definitions(komascad.SCAD, name, values, {})


class SelectionTests(unittest.TestCase):
    """Games and pieces are found by short, forgiving names."""

    def test_game_name_and_path_reach_the_same_file(self):
        path = komascad.GAMES / "shogi.json"
        self.assertEqual(komascad.find_preset_file("shogi"), path)
        self.assertEqual(komascad.find_preset_file(str(path)), path)

    def test_unknown_game_suggests_a_close_name(self):
        with self.assertRaisesRegex(ValueError, "Did you mean 'shogi'"):
            komascad.find_preset_file("shgi")

    def test_pieces_match_by_exact_name_or_part_of_a_name(self):
        names = ["Shogi 01 - King (Osho)", "Shogi 02 - King (Gyokusho)", "Shogi 09 - Pawn"]
        self.assertEqual(komascad.select_presets(names, []), names)
        self.assertEqual(komascad.select_presets(names, ["pawn", "KING"]), names)
        self.assertEqual(komascad.select_presets(names, ["Shogi 09 - Pawn"]), names[2:])
        with self.assertRaisesRegex(ValueError, "No piece matches 'lion'"):
            komascad.select_presets(names, ["lion"])

    def test_piece_counts_default_to_one(self):
        """A preset file's pieceCounts set the copies; other presets count once."""
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "set.json"
            path.write_text(json.dumps({
                "parameterSets": {"Pawn": {}, "King": {}}, "pieceCounts": {"Pawn": 18},
            }), encoding="utf-8")
            self.assertEqual(komascad.load_parameter_sets(path)[1], {"Pawn": 18, "King": 1})

    def test_list_shows_games_then_pieces(self):
        status, out, _ = run("list")
        self.assertEqual(status, 0)
        self.assertRegex(out, r"shogi\s+9\s+40")
        status, out, _ = run("list", "shogi")
        self.assertIn("Shogi 09 - Pawn  x18", out)


class PackagingTests(unittest.TestCase):
    """3MF files and their names, without rendering anything."""

    def test_safe_names_are_readable(self):
        """Punctuation that filenames cannot hold becomes a readable dash."""
        self.assertEqual(komascad.safe_name("Chu Shogi: Lion / Kirin"), "Chu Shogi - Lion - Kirin")

    def test_layout_files_hold_the_full_count_of_every_piece(self):
        counts = {"Pawn": 3, "King": 1}
        self.assertEqual(
            komascad.plan_files(["Pawn", "King"], counts, "My: Set", 3),
            [("My - Set - Layout 01.3mf", ["Pawn"] * 3), ("My - Set - Layout 02.3mf", ["King"])])
        self.assertEqual(
            komascad.plan_files(["Pawn", "King"], counts, "Set", komascad.math.inf),
            [("Set - Layout 01.3mf", ["Pawn", "Pawn", "Pawn", "King"])])

    def test_single_piece_keeps_its_coordinates(self):
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "pawn.3mf"
            komascad.create_3mf(output, [("Pawn", PARTS)], "Pawn")
            with zipfile.ZipFile(output) as archive:
                model = archive.read("3D/3dmodel.model").decode("utf-8")
        self.assertEqual(model.count("<item "), 1)
        self.assertNotIn("transform", model)
        self.assertIn('name="Body | PLA"', model)

    def test_layout_keeps_presets_as_separate_placed_objects(self):
        """A portable layout contains separate objects and no printer profile."""
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "layout.3mf"
            komascad.create_3mf(output, [("Pawn", PARTS), ("King", PARTS)], "Grid")
            with zipfile.ZipFile(output) as archive:
                model = archive.read("3D/3dmodel.model").decode("utf-8")
                metadata = archive.read("Metadata/KomaSCAD.json").decode("utf-8")
        self.assertIn('name="Pawn"', model)
        self.assertIn('name="King"', model)
        self.assertEqual(model.count("<item "), 2)
        self.assertIn("no printer settings", metadata)

    def test_repeated_presets_are_placed_again_but_stored_once(self):
        """Copies of a piece add build items without duplicating its mesh."""
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "layout.3mf"
            placed = komascad.create_3mf(output, [("Pawn", PARTS)] * 3 + [("King", PARTS)], "Set")
            with zipfile.ZipFile(output) as archive:
                model = archive.read("3D/3dmodel.model").decode("utf-8")
        self.assertEqual(model.count("<item "), 4)
        self.assertEqual(model.count("<mesh>"), 2)
        # Each copy is its own named object so slicers keep the name.
        self.assertEqual(model.count('name="Pawn"'), 3)
        self.assertEqual(len(set(komascad.re.findall(r'<item objectid="(\d+)"', model))), 4)
        self.assertEqual(len({(entry["x"], entry["y"]) for entry in placed}), 4)

    def test_grid_centres_pieces_without_overlap(self):
        """Pieces fill a square-ish grid, each in its own cell around the origin."""
        self.assertEqual(komascad.grid_positions([(5.0, 15.0, 0.0, 20.0)]), [(0.0, 0.0)])
        positions = komascad.grid_positions([(0.0, 10.0, 0.0, 20.0)] * 4)
        # 10 x 20 mm pieces plus the 6 mm margin make 16 x 26 mm cells.
        self.assertEqual(positions, [(-13.0, 3.0), (3.0, 3.0), (-13.0, -23.0), (3.0, -23.0)])

    def test_manifest_paths_outside_the_project_keep_only_the_filename(self):
        """A source file elsewhere on disk is recorded without its folders."""
        self.assertEqual(
            komascad.portable_path(komascad.GAMES / "shogi.json"), "presets/games/shogi.json")
        self.assertEqual(komascad.portable_path(Path("/elsewhere/private/mine.json")), "mine.json")


class ExportCommandTests(unittest.TestCase):
    """Drive the export command with OpenSCAD replaced by a stub."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        self.presets = self.root / "piece.json"
        self.presets.write_text(json.dumps({
            "parameterSets": {"01 Pawn": {}, "02 Lion": {}}, "pieceCounts": {"01 Pawn": 2},
        }), encoding="utf-8")
        self.out = self.root / "exports"
        self.rendered = []
        original = komascad.render_parts
        self.addCleanup(lambda: setattr(komascad, "render_parts", original))
        komascad.render_parts = self.render

    def render(self, executable, scad, definitions):
        self.rendered.append(definitions)
        return PARTS

    def test_whole_file_exports_every_piece_and_a_manifest(self):
        status, _, _ = run("export", self.presets, "-o", self.out, "--name", "Chu Shogi")
        self.assertEqual(status, 0)
        self.assertTrue(zipfile.is_zipfile(self.out / "01 Pawn.3mf"))
        self.assertTrue(zipfile.is_zipfile(self.out / "02 Lion.3mf"))
        manifest = json.loads((self.out / "manifest.json").read_text(encoding="utf-8"))
        self.assertEqual(manifest["set_name"], "Chu Shogi")
        # Manifests are shared, so they never record the maker's folders.
        self.assertEqual(manifest["source_parameters"], "piece.json")
        self.assertEqual(manifest["source_scad"], "shogi_piece.scad")
        self.assertNotIn(str(self.root), json.dumps(manifest))
        self.assertEqual((manifest["piece_count"], manifest["total_quantity"]), (2, 3))
        self.assertEqual(
            [(entry["preset"], entry["quantity"]) for entry in manifest["files"]],
            [("01 Pawn", 2), ("02 Lion", 1)])
        self.assertTrue(all(entry["sha256"] for entry in manifest["files"]))

    def test_per_file_all_places_the_full_set_and_renders_each_piece_once(self):
        status, _, _ = run("export", self.presets, "-o", self.out, "--per-file", "all")
        self.assertEqual(status, 0)
        with zipfile.ZipFile(self.out / "Piece - Layout 01.3mf") as archive:
            self.assertEqual(archive.read("3D/3dmodel.model").decode("utf-8").count("<item "), 3)
        self.assertEqual(len(self.rendered), 2)
        manifest = json.loads((self.out / "manifest.json").read_text(encoding="utf-8"))
        self.assertEqual(manifest["files"][0]["presets"], ["01 Pawn", "01 Pawn", "02 Lion"])

    def test_existing_files_are_skipped_unless_forced(self):
        run("export", self.presets, "-o", self.out)
        self.assertEqual(run("export", self.presets, "-o", self.out)[0], 0)
        self.assertEqual(len(self.rendered), 2)
        run("export", self.presets, "-o", self.out, "--force")
        self.assertEqual(len(self.rendered), 4)

    def test_named_piece_exports_alone_with_overrides_and_no_manifest(self):
        status, _, _ = run("export", self.presets, "lion", "-o", self.out, "--front-text", "獅子",
                           "--body-color", "Purple", "--orientation", "front-down")
        self.assertEqual(status, 0)
        self.assertEqual([path.name for path in self.out.iterdir()], ["02 Lion.3mf"])
        self.assertIn('Front_Characters="獅子"', self.rendered[0])
        self.assertIn('Body_Filament="Purple"', self.rendered[0])
        self.assertIn('Print_Orientation="Front face down"', self.rendered[0])

    def test_dry_run_writes_nothing(self):
        status, out, _ = run("export", self.presets, "-o", self.out, "-n")
        self.assertEqual(status, 0)
        self.assertIn("01 Pawn.3mf  (print 2)", out)
        self.assertFalse(self.out.exists())

    def test_failed_piece_keeps_completed_exports_for_resume(self):
        """A failed export retains completed files and leaves no partial one."""
        def failing(executable, scad, definitions):
            if len(self.rendered) == 1:
                raise RuntimeError("intentional failure")
            return self.render(executable, scad, definitions)

        komascad.render_parts = failing
        status, _, err = run("export", self.presets, "-o", self.out)
        self.assertEqual(status, 1)
        self.assertIn("intentional failure", err)
        self.assertEqual([path.name for path in self.out.iterdir()], ["01 Pawn.3mf"])


class SetCommandTests(unittest.TestCase):
    """Bulk edits of hand-kept preset files."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.path = Path(folder.name) / "mine.json"
        self.path.write_text(json.dumps({"fileFormatVersion": "1", "parameterSets": {
            "Grid 01": {"Category": "Grid search", "Base_Width": "28"},
            "Pawn": {"Category": "Shogi / Pawn", "Base_Width": "24"},
        }}), encoding="utf-8")

    def widths(self):
        sets = json.loads(self.path.read_text(encoding="utf-8"))["parameterSets"]
        return [values["Base_Width"] for values in sets.values()]

    def test_changes_only_the_selected_presets(self):
        self.assertEqual(run("set", self.path, "Base_Width=30", "--category", "grid")[0], 0)
        self.assertEqual(self.widths(), ["30", "24"])

    def test_dry_run_writes_nothing(self):
        self.assertEqual(run("set", self.path, "Base_Width=30", "--all", "-n")[0], 0)
        self.assertEqual(self.widths(), ["28", "24"])

    def test_misspelled_parameter_is_rejected(self):
        status, _, err = run("set", self.path, "Base_Widht=30", "--all")
        self.assertEqual(status, 1)
        self.assertIn("Base_Widht", err)


if __name__ == "__main__":
    unittest.main()

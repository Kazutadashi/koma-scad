"""Tests for the komascad command-line tool. None of them start OpenSCAD."""

import contextlib
import io
import json
import re
import shutil
import subprocess
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

    def test_learner_pieces_show_their_moves_on_both_faces(self):
        """Every lettered learner face has a move grid; promoted minor pieces move like gold."""
        sets = komascad.build_games()["shogi-learner"][0]
        for name, preset in sets.items():
            for side in ("Front", "Back"):
                if not preset[side + "_Characters"]:
                    continue
                grid = preset[side + "_Moves"]
                rows = grid.split("/")
                self.assertEqual(grid.count("@"), 1, (name, side))
                self.assertEqual(set(grid) - set(".ox#@/"), set(), (name, side))
                self.assertEqual(len({len(row) for row in rows}), 1, (name, side))
        gold = sets["Shogi Learner 05 - Gold"]["Front_Moves"]
        for piece in ("06 - Silver", "07 - Knight", "08 - Lance", "09 - Pawn"):
            self.assertEqual(sets["Shogi Learner %s" % piece]["Back_Moves"], gold, piece)

    def test_bundled_presets_use_only_parameters_the_model_declares(self):
        """Every generated preset can be turned into OpenSCAD definitions."""
        for sets, _ in komascad.build_games().values():
            for name, values in sets.items():
                komascad.scad_definitions(komascad.SCAD, name, values, {})


EDITOR = ROOT / "move-editor.html"
EXAMPLE_GRIDS = [
    "o/@", "#/@", "x.x/.../.@.", "ooo/.@./o.o", "o#o/#@#/o#o", ".x./#!#/#@#/###",
    "xxxxx/xooox/xo@ox/xooox/xxxxx", "o..o..o/.oxoxo./.xooox./ooo@ooo/.xooox./.oxoxo./o..o..o",
    "#3#/.@./#3#", "===/=@=/===", ".L./L@L/.L.", "234/5@6/.7.", "#/x/./@",
]


def editor_solver(script):
    """Run JavaScript against the move editor's solver; return its JSON output."""
    source = re.search(r'<script id="solver">(.*?)</script>', EDITOR.read_text(encoding="utf-8"), re.S).group(1)
    with tempfile.TemporaryDirectory() as folder:
        module = Path(folder) / "solver.js"
        module.write_text(source, encoding="utf-8")
        result = subprocess.run(["node", "-e", "const S = require(%s);\n%s" % (json.dumps(str(module)), script)],
                                capture_output=True, text=True, check=True)
    return json.loads(result.stdout)


@unittest.skipUnless(shutil.which("node"), "needs node to run the move editor's solver")
class MoveEditorTests(unittest.TestCase):
    """The move editor accepts what the model accepts."""

    def test_bundled_and_example_grids_are_valid(self):
        grids = set(EXAMPLE_GRIDS)
        for sets, _ in komascad.build_games().values():
            for preset in sets.values():
                grids.update(preset[side + "_Moves"] for side in ("Front", "Back") if preset.get(side + "_Moves"))
        errors = editor_solver("console.log(JSON.stringify(%s.map(g => S.parseGrid(g).errors)))" % json.dumps(sorted(grids)))
        self.assertEqual(dict(zip(sorted(grids), errors)), {grid: [] for grid in sorted(grids)})

    def test_invalid_grids_are_explained(self):
        errors = editor_solver("console.log(JSON.stringify(%s.map(g => S.parseGrid(g).errors)))" % json.dumps(
            ["o/o", "..!/.../.@.", "#.../..@.", "o!/..@", "a/@"]))
        self.assertTrue(all(errors), errors)

    @unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD to compare with the model")
    def test_editor_and_model_solve_the_same_layout(self):
        """The editor's preview spacing is the model's smallest printable spacing."""
        editor = editor_solver(
            "const z = S.sizes(0.8, 0.8); console.log(JSON.stringify(%s.map(g => {"
            " const m = S.parseGrid(g).marks, p = S.solve(m, z), b = S.box(m, p, z);"
            " return [p, b[1][0] - b[0][0], b[1][1] - b[0][1]]; })))" % json.dumps(EXAMPLE_GRIDS))
        for grid, expected in zip(EXAMPLE_GRIDS, editor):
            with tempfile.TemporaryDirectory() as folder:
                echo = Path(folder) / "moves.echo"
                subprocess.run(["openscad", "-o", str(echo), "-D", 'Front_Characters=""',
                                "-D", "Front_Moves=" + json.dumps(grid), "-D", "Move_Stroke=0.8", "-D", "Move_Gap=0.8",
                                str(komascad.SCAD)], capture_output=True, check=True)
                line = re.search(r'"KOMASCAD_MOVES", "Front", (.*)$', echo.read_text(encoding="utf-8"), re.M).group(1)
            values = json.loads("[%s]" % line)
            model = [values[2], values[3][0], values[3][1]]
            for a, b in zip(model, expected):
                self.assertAlmostEqual(a, b, places=3, msg=grid)


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

    def test_row_plan_packs_mixed_sizes_row_by_row(self):
        """Planned rows are centered, as deep as their own pieces, and do not overlap."""
        big, small = (0.0, 40.0, 0.0, 40.0), (0.0, 10.0, 0.0, 10.0)
        (big_x, big_y), (left_x, left_y), (right_x, right_y) = komascad.grid_positions(
            [big, small, small], rows=[1, 2])
        # Lower-left corners: the big piece is centered behind two small ones.
        self.assertEqual((big_x, left_x, right_x), (-20.0, -13.0, 3.0))
        # The 10 mm pieces end one 6 mm margin in front of the big piece.
        self.assertEqual(big_y - (left_y + 10.0), 6.0)
        self.assertEqual(left_y, right_y)

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
        self.measured = {"front": (1.0, 1.0)}
        original_check = komascad.check_printability
        self.addCleanup(lambda: setattr(komascad, "check_printability", original_check))
        komascad.check_printability = lambda executable, scad, definitions: self.measured

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

    def test_layout_rows_place_a_whole_file_layout(self):
        """layoutRows arranges a one-file layout; parallel jobs render each piece once."""
        document = json.loads(self.presets.read_text(encoding="utf-8"))
        document["layoutRows"] = [2, 1]
        self.presets.write_text(json.dumps(document), encoding="utf-8")
        status, _, _ = run("export", self.presets, "-o", self.out, "--per-file", "all", "-j", "2")
        self.assertEqual(status, 0)
        self.assertEqual(len(self.rendered), 2)
        with zipfile.ZipFile(self.out / "Piece - Layout 01.3mf") as archive:
            placed = json.loads(archive.read("Metadata/KomaSCAD.json"))["pieces"]
        # Two pawns side by side at the back, the lion alone and centered in front.
        self.assertEqual(placed[0]["y"], placed[1]["y"])
        self.assertEqual((placed[2]["x"], placed[2]["y"] < placed[0]["y"]), (-5.0, True))

    def test_layout_rows_must_add_up_to_the_pieces(self):
        document = json.loads(self.presets.read_text(encoding="utf-8"))
        document["layoutRows"] = [2, 2]
        self.presets.write_text(json.dumps(document), encoding="utf-8")
        status, _, err = run("export", self.presets, "-o", self.out, "--per-file", "all")
        self.assertEqual(status, 1)
        self.assertIn("places 4 pieces but the file has 3", err)

    def test_jobs_must_be_at_least_one(self):
        with contextlib.redirect_stderr(io.StringIO()), self.assertRaises(SystemExit):
            run("export", self.presets, "-o", self.out, "-j", "0")

    def test_unprintable_lettering_stops_the_export(self):
        """Nothing is rendered or written when lettering would not print."""
        self.measured = {"back": (13.0, 8.8)}
        status, _, err = run("export", self.presets, "-o", self.out)
        self.assertEqual(status, 1)
        self.assertIn("would not survive printing", err)
        self.assertEqual(self.rendered, [])
        self.assertFalse(self.out.exists())
        self.assertEqual(run("export", self.presets, "-o", self.out, "--no-print-check")[0], 0)

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


class TestPageTests(unittest.TestCase):
    """The print test page stays fixed and exportable."""

    def setUp(self):
        self.plates = komascad.build_test_page()

    def pieces(self):
        """Every piece of the page, in order, across all plates."""
        merged = {}
        for sets, _ in self.plates.values():
            merged.update(sets)
        return merged

    def test_build_writes_every_plate_and_nothing_else(self):
        """Every committed plate file is one the build produces."""
        self.assertEqual(sorted(path.name for path in komascad.TEST_PAGE.glob("*.json")),
                         sorted(self.plates))

    def test_page_fills_its_budget_in_planned_rows(self):
        """The page uses its whole budget and each plate's rows place its pieces."""
        self.assertEqual(len(self.pieces()), komascad.TEST_PAGE_PIECES)
        for name, (sets, rows) in self.plates.items():
            self.assertEqual(sum(rows), len(sets), name)
            # The exporter places presets in sorted order; rows rely on it.
            self.assertEqual(sorted(sets), list(sets), name)

    def test_presets_use_only_parameters_the_model_declares(self):
        """Every plate preset can be turned into OpenSCAD definitions."""
        for name, preset in self.pieces().items():
            komascad.scad_definitions(komascad.SCAD, name, preset, {})

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
        self.assertEqual([p["Signature_Text"] for p in row], ["3-06", "3-07", "3-08", "3-09", "3-10"])
        varying = {key for key in row[0] if len({p[key] for p in row}) > 1}
        self.assertEqual(varying, {"Front_Stroke_Expansion", "Back_Stroke_Expansion",
                                   "Signature_Text", "Category"})

    def test_every_piece_has_a_unique_red_heel_label_naming_its_plate(self):
        """Labels match the preset name; small pieces use distinct dot codes."""
        labels = []
        for name, preset in self.pieces().items():
            identifier = komascad.re.search(r" - (\d)-(\d\d) ", name)
            plate, piece = int(identifier.group(1)), int(identifier.group(2))
            self.assertEqual(preset["Signature_Enabled"], "true", name)
            self.assertEqual(preset["Signature_Filament"], "Red", name)
            if float(preset["Model_Scale"]) >= 1:
                self.assertEqual(preset["Signature_Text"], "%d-%02d" % (plate, piece), name)
            else:
                self.assertEqual(preset["Signature_Text"], komascad.dot_code(plate, piece), name)
            labels.append(preset["Signature_Text"])
        self.assertEqual(len(set(labels)), len(labels))

    def test_dot_code_is_unique_and_never_joins_dots_at_a_corner(self):
        """Codes start with a full column and avoid shapes OpenSCAD cannot extrude."""
        quadrants = komascad.QUADRANTS
        left_filled = {character for dots, character in quadrants.items() if dots[0] and dots[2]}
        codes = {komascad.dot_code(plate, piece) for plate in (1, 2, 3) for piece in range(1, 81)}
        self.assertEqual(len(codes), 3 * 80)
        self.assertTrue(all(len(code) == 3 and code[0] in left_filled for code in codes))
        # A top dot always has the bottom dot under it.
        hanging = {character for (ul, ur, ll, lr), character in quadrants.items()
                   if (ul and not ll) or (ur and not lr)}
        self.assertFalse(any(set(code) & hanging for code in codes))
        # Plate 3, piece 5: start, two dots, then 0, 0, 1, 2 in base three.
        self.assertEqual(komascad.dot_code(3, 5), "\u2588\u3000\u259f")

    def test_one_character_pieces_cover_both_fonts_at_every_size(self):
        """The one-character series is both fonts at all five sizes."""
        names = [name for name in self.pieces() if name.endswith(" one character")]
        self.assertEqual(len(names), 10)
        for size in ("0.25x", "0.5x", "1x", "1.5x", "2x"):
            for family in ("Yuji Syuku", "LXGW WenKai Mono"):
                self.assertTrue(any(" %s %s " % (size, family) in name for name in names), (size, family))

    def test_every_size_has_both_fonts_at_the_stroke_extremes(self):
        """All five sizes carry very thin, normal and very thick in both fonts."""
        names = list(self.pieces())
        for size in ("0.25x", "0.5x", "1x", "1.5x", "2x"):
            for family in ("Yuji Syuku", "LXGW WenKai Mono"):
                found = [name for name in names if " %s %s stroke " % (size, family) in name]
                for stroke in ("very thin", "normal", "very thick"):
                    self.assertTrue(any(name.endswith(" " + stroke) for name in found), (size, family, stroke))

    def test_ladders_are_full_size_with_each_width_once_per_group(self):
        """Ladders are in final mm; each pattern is on the bed face and the top."""
        ladders = {name: p for name, p in self.pieces().items() if " Ladder " in name}
        self.assertEqual(len(ladders), 6)
        widths = komascad.LADDER_WIDTHS
        for name, ladder in ladders.items():
            self.assertEqual(ladder["Model_Scale"], "1", name)
            self.assertIn(len(ladder["Back_Characters"]), (2 * len(widths), 2 * (len(widths) + 1)), name)
        lines_down = next(p for name, p in ladders.items() if "L1" in name)
        self.assertEqual(json.loads(lines_down["Front_Glyph_Height"])[:len(widths)], widths)
        self.assertEqual(json.loads(lines_down["Front_Glyph_Width"])[len(widths):], widths)
        gaps_down = next(p for name, p in ladders.items() if "L2" in name)
        self.assertEqual(gaps_down["Back_Glyph_Width"], lines_down["Front_Glyph_Width"])


class PrintabilityTests(unittest.TestCase):
    """Lettering too fine to print is caught before export."""

    def test_svg_area_subtracts_holes(self):
        """A 10 mm square with a 4 mm hole has 84 mm² of ink."""
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "ring.svg"
            path.write_text('<svg><path d="M 0,0 L 10,0 L 10,10 L 0,10 z M 3,3 L 3,7 L 7,7 L 7,3 z"/></svg>', encoding="utf-8")
            self.assertAlmostEqual(komascad.svg_area(path), 84.0)
            self.assertEqual(komascad.svg_area(Path(folder) / "missing.svg"), 0.0)

    def test_limits_name_the_failing_face(self):
        problems = komascad.printability_problems({"front": (1.0, 2.0), "back": (13.0, 8.8)})
        self.assertEqual(len(problems), 1)
        self.assertTrue(problems[0].startswith("back: 13.0%"))

    @unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD")
    def test_bundled_piece_passes_and_dense_lettering_fails(self):
        """A bundled pawn and the chu shogi example print; 鷹 in Yuji Syuku does not."""
        def measure(path, name, **changes):
            sets, _ = komascad.load_parameter_sets(path)
            return komascad.check_printability(
                "openscad", komascad.SCAD, komascad.scad_definitions(komascad.SCAD, name, dict(sets[name], **changes), {}))
        chu = ROOT / "presets" / "misc" / "chu-shogi-learner.json"
        self.assertEqual(komascad.printability_problems(measure(komascad.GAMES / "shogi.json", "Shogi 09 - Pawn")), [])
        self.assertEqual(komascad.printability_problems(measure(chu, "Chu Shogi - Dragon Horse")), [])
        failing = komascad.printability_problems(measure(
            chu, "Chu Shogi - Dragon Horse", Font_Name="Yuji Syuku:style=Regular"))
        self.assertTrue(any(problem.startswith("back") for problem in failing), failing)


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

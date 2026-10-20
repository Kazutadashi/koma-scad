"""The export command, with OpenSCAD replaced by a stub."""

import contextlib
import io
import json
import math
import tempfile
import unittest
import zipfile
from pathlib import Path

from komascad_lib import export, openscad, printability
from komascad_lib.project import GAMES, KomaError

from .support import PARTS, run


class PlanTests(unittest.TestCase):
    """File names and the split of a set into files."""

    def test_safe_names_are_readable(self):
        """Punctuation that file names cannot hold becomes a readable dash."""
        self.assertEqual(export.safe_name("Chu Shogi: Lion / Kirin"), "Chu Shogi - Lion - Kirin")

    def test_layout_files_hold_the_full_count_of_every_piece(self):
        counts = {"Pawn": 3, "King": 1}
        self.assertEqual(
            export.plan_files(["Pawn", "King"], counts, "My: Set", 3),
            [("My - Set - Layout 01.3mf", ["Pawn"] * 3), ("My - Set - Layout 02.3mf", ["King"])],
        )
        self.assertEqual(
            export.plan_files(["Pawn", "King"], counts, "Set", math.inf),
            [("Set - Layout 01.3mf", ["Pawn", "Pawn", "Pawn", "King"])],
        )

    def test_manifest_paths_outside_the_project_keep_only_the_filename(self):
        """A source file elsewhere on disk is recorded without its folders."""
        self.assertEqual(
            export.portable_path(GAMES / "shogi.json"), "koma/presets/games/shogi.json"
        )
        self.assertEqual(export.portable_path(Path("/elsewhere/private/mine.json")), "mine.json")


class ExportCommandTests(unittest.TestCase):
    """The export command, with OpenSCAD replaced by a stub."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        self.presets = self.root / "piece.json"
        self.presets.write_text(
            json.dumps(
                {
                    "parameterSets": {"01 Pawn": {}, "02 Lion": {}},
                    "pieceCounts": {"01 Pawn": 2},
                }
            ),
            encoding="utf-8",
        )
        self.out = self.root / "exports"
        self.rendered = []
        self.measured = {"front": (1.0, 1.0)}
        self.stub(openscad, "render_parts", self.render)
        self.stub(printability, "check_printability", lambda executable, definitions: self.measured)

    def stub(self, module, name, replacement):
        original = getattr(module, name)
        self.addCleanup(setattr, module, name, original)
        setattr(module, name, replacement)

    def render(self, executable, definitions):
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
        self.assertEqual(manifest["source_scad"], "koma/koma.scad")
        self.assertNotIn(str(self.root), json.dumps(manifest))
        self.assertEqual((manifest["piece_count"], manifest["total_quantity"]), (2, 3))
        self.assertEqual(
            [(entry["preset"], entry["quantity"]) for entry in manifest["files"]],
            [("01 Pawn", 2), ("02 Lion", 1)],
        )
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
        """LayoutRows arranges a one-file layout; parallel jobs render each piece once."""
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
        """Nothing is rendered or written when the lettering would not print."""
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
        status, _, _ = run(
            "export",
            self.presets,
            "lion",
            "-o",
            self.out,
            "--front-text",
            "獅子",
            "--body-color",
            "Purple",
            "--orientation",
            "front-down",
        )
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
        """A failed export keeps the completed files and leaves no partial one."""

        def failing(executable, definitions):
            if len(self.rendered) == 1:
                raise KomaError("intentional failure")
            return self.render(executable, definitions)

        openscad.render_parts = failing
        status, _, err = run("export", self.presets, "-o", self.out)
        self.assertEqual(status, 1)
        self.assertIn("intentional failure", err)
        self.assertEqual([path.name for path in self.out.iterdir()], ["01 Pawn.3mf"])


if __name__ == "__main__":
    unittest.main()

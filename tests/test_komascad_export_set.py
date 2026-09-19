"""Tests for the whole-set 3MF export coordinator."""

import importlib.util
import json
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "komascad_export", ROOT / "scripts" / "komascad_export.py",
)
EXPORT = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(EXPORT)


class SetExportTests(unittest.TestCase):
    """Exercise selection, naming, delegation, and atomic publication."""

    def test_select_presets_keeps_source_order(self):
        """Include and exclude globs retain the JSON collection's order."""
        selected = EXPORT.select_presets(
            ["King", "Grid 01", "Grid 02", "Grid 03"],
            [], ["Grid *"], ["*02"],
        )

        self.assertEqual(selected, ["Grid 01", "Grid 03"])

    def test_explicit_presets_keep_command_line_order(self):
        """Exact selections preserve the order supplied by the caller."""
        selected = EXPORT.select_presets(
            ["Pawn", "King", "Lion"], ["Lion", "Pawn"], [], [],
        )

        self.assertEqual(selected, ["Lion", "Pawn"])

    def test_safe_names_are_readable_and_collision_checked(self):
        """Unsafe punctuation is normalized and ambiguous files are rejected."""
        self.assertEqual(
            EXPORT.safe_name("Chu Shogi: Lion / Kirin"),
            "Chu Shogi - Lion - Kirin",
        )
        with self.assertRaisesRegex(ValueError, "colliding filenames"):
            EXPORT.plan_exports(["Lion/Pawn", "Lion:Pawn"])

    def test_export_command_delegates_one_preset(self):
        """Each job becomes one invocation of the existing piece exporter."""
        command = EXPORT.build_export_command(
            "python3", Path("export.py"), Path("/project"),
            Path("/project/piece.scad"), Path("/project/piece.json"),
            "openscad-nightly", EXPORT.ExportJob("Lion", "Lion.3mf"),
            Path("/tmp/Lion.3mf"),
        )

        self.assertEqual(command[command.index("--preset") + 1], "Lion")
        self.assertEqual(command[command.index("--output") + 1], "/tmp/Lion.3mf")
        self.assertEqual(command.count("--openscad"), 1)

    def test_main_exports_collection_and_writes_manifest(self):
        """A complete collection is published with printable files and metadata."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            scad = root / "piece.scad"
            parameters = root / "piece.json"
            exporter = root / "fake_exporter.py"
            output_root = root / "exports"
            scad.write_text("// test model\n", encoding="utf-8")
            parameters.write_text(json.dumps({
                "parameterSets": {"01 Pawn": {}, "02 Lion": {}},
            }), encoding="utf-8")
            exporter.write_text(
                "import pathlib, sys\n"
                "output = pathlib.Path(sys.argv[sys.argv.index('--output') + 1])\n"
                "preset = sys.argv[sys.argv.index('--preset') + 1]\n"
                "output.write_bytes(('3MF:' + preset).encode('utf-8'))\n",
                encoding="utf-8",
            )

            result = EXPORT.main([
                "--set",
                "--target", str(root),
                "--scad", scad.name,
                "--parameters", parameters.name,
                "--exporter", str(exporter),
                "--set-name", "Chu Shogi",
                "--output-root", str(output_root),
            ])

            destination = output_root / "Chu Shogi"
            self.assertEqual(result, 0)
            self.assertEqual(
                (destination / "01 Pawn.3mf").read_bytes(), b"3MF:01 Pawn",
            )
            self.assertEqual(
                (destination / "02 Lion.3mf").read_bytes(), b"3MF:02 Lion",
            )
            manifest = json.loads(
                (destination / "manifest.json").read_text(encoding="utf-8"),
            )
            self.assertEqual(manifest["set_name"], "Chu Shogi")
            self.assertEqual(manifest["piece_count"], 2)
            self.assertEqual(
                [entry["preset"] for entry in manifest["files"]],
                ["01 Pawn", "02 Lion"],
            )
            self.assertTrue(all(entry["sha256"] for entry in manifest["files"]))

    def test_failed_piece_does_not_publish_partial_collection(self):
        """A failed delegated export leaves no incomplete destination folder."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            scad = root / "piece.scad"
            parameters = root / "piece.json"
            exporter = root / "fake_exporter.py"
            output_root = root / "exports"
            scad.write_text("// test model\n", encoding="utf-8")
            parameters.write_text(json.dumps({
                "parameterSets": {"01 Pawn": {}, "02 Lion": {}},
            }), encoding="utf-8")
            exporter.write_text(
                "import pathlib, sys\n"
                "preset = sys.argv[sys.argv.index('--preset') + 1]\n"
                "if preset == '02 Lion':\n"
                "    raise SystemExit(9)\n"
                "output = pathlib.Path(sys.argv[sys.argv.index('--output') + 1])\n"
                "output.write_bytes(b'partial')\n",
                encoding="utf-8",
            )

            result = EXPORT.main([
                "--set",
                "--target", str(root),
                "--scad", scad.name,
                "--parameters", parameters.name,
                "--exporter", str(exporter),
                "--set-name", "Incomplete Set",
                "--output-root", str(output_root),
            ])

            self.assertEqual(result, 1)
            self.assertFalse((output_root / "Incomplete Set").exists())
            self.assertEqual(list(output_root.iterdir()), [])

    def test_mixed_exact_and_glob_selection_is_rejected(self):
        """Mutually exclusive selection styles report an actionable error."""
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            scad = root / "piece.scad"
            parameters = root / "piece.json"
            exporter = root / "exporter.py"
            scad.write_text("// test model\n", encoding="utf-8")
            parameters.write_text(
                '{"parameterSets":{"Pawn":{}}}', encoding="utf-8",
            )
            exporter.write_text("# test exporter\n", encoding="utf-8")

            result = EXPORT.main([
                "--set",
                "--target", str(root),
                "--scad", scad.name,
                "--parameters", parameters.name,
                "--exporter", str(exporter),
                "--preset", "Pawn",
                "--include", "P*",
                "--list",
            ])

            self.assertEqual(result, 1)


if __name__ == "__main__":
    unittest.main()

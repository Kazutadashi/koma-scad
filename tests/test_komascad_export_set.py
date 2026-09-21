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
    """Exercise naming, delegation, and resumable collection exports."""

    def test_safe_names_are_readable_and_collision_checked(self):
        """Unsafe punctuation is normalized and ambiguous files are rejected."""
        self.assertEqual(
            EXPORT.safe_name("Chu Shogi: Lion / Kirin"),
            "Chu Shogi - Lion - Kirin",
        )
        with self.assertRaisesRegex(ValueError, "colliding filenames"):
            EXPORT.plan_exports(["Lion/Pawn", "Lion:Pawn"])

    def test_layout_keeps_presets_as_separate_placed_objects(self):
        """A portable layout contains separate objects and no printer profile."""
        triangle = [(0.0, 0.0, 0.0), (10.0, 0.0, 0.0), (0.0, 10.0, 0.0)]
        parts = [("body", "PLA", (0.0, 0.0, 0.0, 1.0), triangle, [(0, 1, 2)])]
        with tempfile.TemporaryDirectory() as temporary:
            output = Path(temporary) / "layout.3mf"
            EXPORT.create_layout_3mf(output, [("Pawn", parts), ("King", parts)], "Grid")
            with EXPORT.zipfile.ZipFile(output) as archive:
                model = archive.read("3D/3dmodel.model").decode("utf-8")
                metadata = archive.read("Metadata/KomaSCAD.json").decode("utf-8")
        self.assertIn('name="Pawn"', model)
        self.assertIn('name="King"', model)
        self.assertEqual(model.count("<item "), 2)
        self.assertIn("no printer settings", metadata)
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

            original_export_piece = EXPORT.export_piece
            EXPORT.export_piece = lambda args, scad, parameters, piece, output, parser: output.write_bytes(
                ("3MF:" + piece).encode("utf-8")
            )
            try:
                result = EXPORT.main([
                "--target", str(root),
                "--scad", scad.name,
                "--preset-file", str(parameters),
                "--set-name", "Chu Shogi",
                "--out", str(output_root),
                ])
            finally:
                EXPORT.export_piece = original_export_piece

            destination = output_root
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

    def test_failed_piece_keeps_completed_exports_for_resume(self):
        """A failed export retains completed 3MF files in the output directory."""
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

            def failing_export_piece(args, scad, parameters, piece, output, parser):
                if piece == "02 Lion":
                    raise RuntimeError("intentional failure")
                output.write_bytes(b"partial")

            original_export_piece = EXPORT.export_piece
            EXPORT.export_piece = failing_export_piece
            try:
                result = EXPORT.main([
                "--target", str(root),
                "--scad", scad.name,
                "--preset-file", str(parameters),
                "--set-name", "Incomplete Set",
                "--out", str(output_root),
                ])
            finally:
                EXPORT.export_piece = original_export_piece

            self.assertEqual(result, 1)
            self.assertEqual((output_root / "01 Pawn.3mf").read_bytes(), b"partial")
            self.assertFalse((output_root / "02 Lion.3mf").exists())
            self.assertFalse((output_root / "manifest.json").exists())

if __name__ == "__main__":
    unittest.main()

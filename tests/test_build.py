"""The build command, writing into a temporary folder instead of the project."""

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from komascad_lib import cli, presets

from .support import run


class BuildCommandTests(unittest.TestCase):
    """build writes the generated files, reports stale ones, and protects Customizer edits."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        self.games = self.root / "games"
        self.customizer = self.root / "shogi_piece.json"

        # Point the generated files at the temporary folder. The piece files
        # are still read from the project.
        for module, name, value in [
            (presets, "GAMES", self.games),
            (presets, "TEST_PAGE", self.root / "print-test"),
            (presets, "CUSTOMIZER", self.customizer),
            (cli, "CUSTOMIZER", self.customizer),
        ]:
            patcher = mock.patch.object(module, name, value)
            patcher.start()
            self.addCleanup(patcher.stop)

    def test_build_writes_every_file_and_a_summary(self):
        status, out, _ = run("build")

        self.assertEqual(status, 0)
        self.assertTrue((self.games / "shogi.json").is_file())
        self.assertTrue(self.customizer.is_file())
        self.assertTrue((self.root / "print-test" / "print-test-plate-1.json").is_file())
        self.assertIn("presets/games/shogi.json: 9 presets, 40 pieces in a full set", out)
        self.assertEqual(run("build", "--check")[0], 0)

    def test_check_lists_missing_files_and_fails(self):
        status, out, _ = run("build", "--check")

        self.assertEqual(status, 1)
        self.assertIn("Out of date:", out)

    def test_customizer_edits_stop_the_build_until_forced(self):
        run("build")
        document = json.loads(self.customizer.read_text(encoding="utf-8"))
        document["parameterSets"]["Shogi 09 - Pawn"]["Base_Width"] = "30"
        self.customizer.write_text(json.dumps(document), encoding="utf-8")

        status, out, err = run("build")
        self.assertEqual(status, 1)
        self.assertIn("Shogi 09 - Pawn: Base_Width = 30 (built value: 24.5)", out)
        self.assertIn("--force", err)

        self.assertEqual(run("build", "--force")[0], 0)
        rebuilt = json.loads(self.customizer.read_text(encoding="utf-8"))
        self.assertEqual(rebuilt["parameterSets"]["Shogi 09 - Pawn"]["Base_Width"], "24.5")


if __name__ == "__main__":
    unittest.main()

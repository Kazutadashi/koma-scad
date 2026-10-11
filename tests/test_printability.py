"""Lettering too fine to print is caught before export."""

import json
import shutil
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from komascad_lib import printability
from komascad_lib.openscad import scad_definitions
from komascad_lib.presets import load_preset_file
from komascad_lib.project import GAMES, ROOT

from .support import run


class PrintabilityTests(unittest.TestCase):
    """Lettering too fine to print is caught before export."""

    def test_svg_area_subtracts_holes(self):
        """A 10 mm square with a 4 mm hole has 84 mm² of ink."""
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "ring.svg"
            path.write_text(
                '<svg><path d="M 0,0 L 10,0 L 10,10 L 0,10 z M 3,3 L 3,7 L 7,7 L 7,3 z"/></svg>',
                encoding="utf-8",
            )
            self.assertAlmostEqual(printability.svg_area(path), 84.0)
            self.assertEqual(printability.svg_area(Path(folder) / "missing.svg"), 0.0)

    def test_limits_name_the_failing_face(self):
        problems = printability.printability_problems({"front": (1.0, 2.0), "back": (13.0, 8.8)})
        self.assertEqual(len(problems), 1)
        self.assertTrue(problems[0].startswith("back: 13.0%"))

    @unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD")
    def test_bundled_piece_passes_and_dense_lettering_fails(self):
        """A bundled pawn and the chu shogi example print; 鷹 in Yuji Syuku does not."""

        def measure(path, name, **changes):
            presets = load_preset_file(path).presets
            definitions = scad_definitions(name, dict(presets[name], **changes), {})
            return printability.check_printability("openscad", definitions)

        chu = ROOT / "presets" / "misc" / "chu-shogi-learner.json"
        self.assertEqual(
            printability.printability_problems(measure(GAMES / "shogi.json", "Shogi 09 - Pawn")), []
        )
        self.assertEqual(
            printability.printability_problems(measure(chu, "Chu Shogi - Dragon Horse")), []
        )
        failing = printability.printability_problems(
            measure(chu, "Chu Shogi - Dragon Horse", Font_Name="Yuji Syuku:style=Regular")
        )
        self.assertTrue(any(problem.startswith("back") for problem in failing), failing)


class CheckCommandTests(unittest.TestCase):
    """check prints each piece's measurement and fails when one is over the limits."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.presets = Path(folder.name) / "pieces.json"
        # Each preset gets its own Category, so that the stub can tell them apart.
        names = ["Pawn", "Dragon", "Blank"]
        document = {"parameterSets": {name: {"Category": name} for name in names}}
        self.presets.write_text(json.dumps(document), encoding="utf-8")

    def check_with(self, measurements):
        """Runs the check command, with each piece measured as given.

        Args:
            measurements: The measurement of each preset, by name.

        Returns:
            The exit status, the output and the errors of the command.
        """

        def measure(executable, definitions):
            # The pieces are measured in parallel, so find the piece by its Category.
            for name, measurement in measurements.items():
                if f'Category="{name}"' in definitions:
                    return measurement
            raise AssertionError(f"unexpected piece: {definitions}")

        with mock.patch.object(printability, "check_printability", measure):
            return run("check", self.presets)

    def test_passing_pieces_exit_cleanly(self):
        status, out, _ = self.check_with(
            {"Pawn": {"front": (1.0, 2.0)}, "Dragon": {"back": (0.5, 0.25)}, "Blank": {}}
        )

        self.assertEqual(status, 0)
        self.assertIn("ok   Pawn  (front thin 1.0% gaps 2.0%)", out)
        self.assertIn("ok   Blank  (no characters)", out)
        self.assertIn("0 of 3 pieces fail.", out)

    def test_a_failing_piece_fails_the_command(self):
        status, out, _ = self.check_with(
            {"Pawn": {"front": (1.0, 2.0)}, "Dragon": {"back": (13.0, 8.8)}, "Blank": {}}
        )

        self.assertEqual(status, 1)
        self.assertIn("FAIL Dragon  (back thin 13.0% gaps 8.8%)", out)
        self.assertIn("1 of 3 pieces fail.", out)


if __name__ == "__main__":
    unittest.main()

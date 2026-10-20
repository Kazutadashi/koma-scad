"""The models of the board, the piece stand and the piece box."""

import json
import re
import shutil
import tempfile
import unittest
from pathlib import Path

from komascad_lib import openscad
from komascad_lib.project import BAN_PRESETS, BAN_SCAD, KOMABAKO_SCAD, KOMADAI_SCAD, MODELS, VERSION

# The choices of a model's Output Mode, from its Customizer comment, such as
# Output_Mode = "Box and lid"; // [Box and lid,Box,Lid,Closed]
OUTPUT_CHOICES = re.compile(r'^Output_Mode = "[^"]*"; // \[(.*)\]$', re.M)

FURNITURE = [BAN_SCAD, KOMADAI_SCAD, KOMABAKO_SCAD]

# A tiled board with T-hook joints, so that every joint shape is drawn.
TILED_BOARD = ["-D", "Panel_Columns=2", "-D", "Panel_Rows=2", "-D", 'Joint_Style="T-hook"']


def output_modes(scad: Path) -> list[str]:
    """The Output Modes that a user can select in the Customizer of a model."""
    match = OUTPUT_CHOICES.search(scad.read_text(encoding="utf-8"))
    return match.group(1).split(",")


def board_presets() -> dict[str, dict]:
    """The settings of each bundled board preset, by name."""
    return json.loads(BAN_PRESETS.read_text(encoding="utf-8"))["parameterSets"]


class VersionTests(unittest.TestCase):
    """Every model has the version of the tool."""

    def test_every_model_has_the_same_version(self):
        for scad in MODELS:
            with self.subTest(model=scad.name):
                self.assertIn(f'version = "{VERSION}";', scad.read_text(encoding="utf-8"))


class BoardPresetTests(unittest.TestCase):
    """The bundled board presets use only settings that ban.scad declares."""

    def test_every_preset_setting_is_declared(self):
        # scad_definitions() stops on a setting that the model does not declare.
        for name, values in board_presets().items():
            with self.subTest(board=name):
                openscad.scad_definitions(name, values, {}, BAN_SCAD)


@unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD")
class ModelTests(unittest.TestCase):
    """Every Output Mode draws without an OpenSCAD warning or error."""

    def render(self, scad: Path, output: Path, settings: list[str]) -> None:
        """Runs OpenSCAD and fails the test on any warning or error."""
        command = ["openscad", "--hardwarnings", "-o", str(output), "--imgsize=200,200"]
        command += settings
        command.append(str(scad))

        status, log = openscad.run_openscad(command)
        self.assertEqual(status, 0, log[-800:])
        self.assertNotIn("WARNING", log)

    def test_every_output_mode_draws_cleanly(self):
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / "view.png"
            for scad in FURNITURE:
                for mode in output_modes(scad):
                    with self.subTest(model=scad.name, mode=mode):
                        settings = ["-D", f'Output_Mode="{mode}"']
                        if scad == BAN_SCAD:
                            settings += TILED_BOARD
                        self.render(scad, image, settings)

    def test_every_board_preset_draws_cleanly(self):
        with tempfile.TemporaryDirectory() as folder:
            tree = Path(folder) / "board.csg"
            for name, values in board_presets().items():
                for mode in output_modes(BAN_SCAD):
                    with self.subTest(board=name, mode=mode):
                        settings = openscad.scad_definitions(name, values, {}, BAN_SCAD)
                        settings += ["-D", f'Output_Mode="{mode}"']
                        self.render(BAN_SCAD, tree, settings)

    def test_printed_parts_render_as_solids(self):
        cases = [
            (
                BAN_SCAD,
                TILED_BOARD
                + ["-D", 'Output_Mode="One panel"', "-D", "Panel_X=1", "-D", "Panel_Y=1"],
            ),
            (KOMADAI_SCAD, ["-D", 'Table_Style="Pedestal"', "-D", "Edge_Lip_Height=2"]),
            (KOMABAKO_SCAD, []),
        ]
        with tempfile.TemporaryDirectory() as folder:
            mesh = Path(folder) / "part.stl"
            for scad, settings in cases:
                with self.subTest(model=scad.name):
                    self.render(scad, mesh, ["--export-format", "binstl"] + settings)
                    # read_stl() stops on a mesh that is not closed.
                    _, faces = openscad.read_stl(mesh)
                    self.assertGreater(len(faces), 0)

    def test_closed_box_is_preview_only(self):
        with tempfile.TemporaryDirectory() as folder:
            command = [
                "openscad",
                "-o",
                str(Path(folder) / "box.stl"),
                "-D",
                'Output_Mode="Closed"',
            ]
            command.append(str(KOMABAKO_SCAD))
            _, log = openscad.run_openscad(command)
        self.assertIn("Closed is F5 only", log)


if __name__ == "__main__":
    unittest.main()

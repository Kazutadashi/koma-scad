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

# A legged board's playing surface, so that the legged komadai styles fit beside it.
LEGGED_KOMADAI = ["-D", "Board_Surface_Height=230", "-D", 'Signature_Text="KS"']

# A tiled board with the default joint (Connectors).
TILED_BOARD = ["-D", "Panel_Columns=2", "-D", "Panel_Rows=2"]

# Hardware that must fit the connector socket (spec v1), from the ISO and
# ASME standards: shank diameter, head diameter and length, nut across flats,
# across corners and thickness, in mm.
HARDWARE = {
    "M4 socket head cap screw (ISO 4762) and M4 nut (ISO 4032)": (4.0, 7.0, 4.0, 7.0, 8.08, 3.2),
    "#8-32 socket cap screw (ASME B18.3) and #8-32 nut": (4.17, 6.86, 4.17, 8.73, 10.08, 3.18),
}

# The socket dimensions, as ban.scad declares them, such as `spec_height = 9.3;`.
SPEC = re.compile(r"^(spec_\w+) = ([\d.]+);", re.M)


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


class ConnectorSpecTests(unittest.TestCase):
    """The connector socket takes standard screws and nuts, so a lost connector can be bought."""

    def test_standard_hardware_fits_the_socket(self):
        spec = {
            name: float(value) for name, value in SPEC.findall(BAN_SCAD.read_text(encoding="utf-8"))
        }
        for hardware, (shank, head, head_length, flats, corners, nut) in HARDWARE.items():
            with self.subTest(hardware=hardware):
                self.assertLess(shank, spec["spec_neck_width"])
                self.assertLess(max(head, corners), spec["spec_end_width"])
                self.assertLess(max(head_length, nut), spec["spec_end_length"])
                # Lying flat: the head stands its diameter tall, a nut its width across flats.
                self.assertLess(max(head, flats), spec["spec_height"])


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

    def test_every_komadai_style_draws_cleanly(self):
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / "view.png"
            for style in ["Flat", "Yagura", "One leg"]:
                with self.subTest(style=style):
                    settings = LEGGED_KOMADAI + ["-D", f'Table_Style="{style}"']
                    self.render(KOMADAI_SCAD, image, settings)

    def test_every_box_lid_style_draws_cleanly(self):
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / "view.png"
            for style in ["Inro", "Cap"]:
                with self.subTest(style=style):
                    settings = ["-D", f'Lid_Style="{style}"', "-D", 'Output_Mode="Closed"']
                    self.render(KOMABAKO_SCAD, image, settings)

    def test_every_board_preset_draws_cleanly(self):
        with tempfile.TemporaryDirectory() as folder:
            tree = Path(folder) / "board.csg"
            for name, values in board_presets().items():
                has_loose_parts = values["Joint_Style"] in ("Connectors", "Keys")
                one_piece = values["Panel_Columns"] == "1" and values["Panel_Rows"] == "1"
                for mode in output_modes(BAN_SCAD):
                    if mode == "Loose parts" and (one_piece or not has_loose_parts):
                        continue
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
            (
                KOMADAI_SCAD,
                LEGGED_KOMADAI + ["-D", 'Table_Style="Yagura"', "-D", 'Output_Mode="One to print"'],
            ),
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

    def test_board_checks_stop_boards_that_cannot_print(self):
        cases = [
            (
                ["-D", "Panel_Columns=1", "-D", "Panel_Rows=1"],
                "larger than the 256 x 256 mm print bed",
            ),
            (["-D", 'Line_Style="Raised"'], "must print face up"),
        ]
        with tempfile.TemporaryDirectory() as folder:
            for settings, message in cases:
                with self.subTest(message=message):
                    command = ["openscad", "-o", str(Path(folder) / "board.csg")] + settings
                    command.append(str(BAN_SCAD))
                    _, log = openscad.run_openscad(command)
                    self.assertIn(message, log)

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

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
LEGGED_KOMADAI = ["-D", "Board_Surface_Height=230", "-D", 'Mark_Line_1="KS"']

# A full maker's mark: an emblem, a wide-spaced main line, and a Japanese line.
MARK = [
    "-D",
    'Mark_Line_1="KOMASCAD"',
    "-D",
    'Mark_Line_2="SHOGI · 将棋"',
    "-D",
    "Mark_Spacing_1=1.7",
    "-D",
    "Mark_Spacing_2=2.2",
    "-D",
    "Mark_Emblem=true",
    "-D",
    'Mark_Emblem_Character="王"',
    "-D",
    'Mark_Emblem_Font="Yuji Syuku:style=Regular"',
]

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


def mesh_volume(path: Path) -> float:
    """The volume of an ASCII STL, in cubic mm. An empty or flat mesh has none."""
    points = [
        tuple(float(value) for value in line.split()[1:])
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.strip().startswith("vertex")
    ]
    volume = 0.0
    for first in range(0, len(points), 3):
        (ax, ay, az), (bx, by, bz), (cx, cy, cz) = points[first : first + 3]
        volume += (
            ax * (by * cz - bz * cy) - ay * (bx * cz - bz * cx) + az * (bx * cy - by * cx)
        ) / 6
    return abs(volume)


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
                # Lying flat: the head stands its diameter tall, a nut its width across flats.
                self.assertLess(max(head, flats), spec["spec_height"])
                # The shoulders lean into the pocket, so it is shortest at the top of each part.
                taper = spec["spec_taper"]
                self.assertLess(head_length, spec["spec_end_length"] - taper * head)
                self.assertLess(nut, spec["spec_end_length"] - taper * flats)


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

    def test_a_module_is_the_same_on_every_board(self):
        # A center module of a 9 x 9 board and of a 12 x 12 board, both of
        # 3 x 3 squares. Camp dots depend on the board, so they are off.
        module = [
            "-D",
            'Panel_Layout="Modules"',
            "-D",
            "Camp_Dots=false",
            "-D",
            "Panel_X=1",
            "-D",
            "Panel_Y=1",
        ]
        meshes = []
        with tempfile.TemporaryDirectory() as folder:
            for size in (9, 12):
                for mode in ("Color body", "Color markings"):
                    mesh = Path(folder) / f"{size}-{mode}.stl"
                    settings = module + [
                        "-D",
                        f"Playing_Columns={size}",
                        "-D",
                        f"Playing_Rows={size}",
                    ]
                    settings += ["-D", f'Output_Mode="{mode}"', "--export-format", "binstl"]
                    self.render(BAN_SCAD, mesh, settings)
                    vertices, faces = openscad.read_stl(mesh)
                    corners = sorted(
                        tuple(round(c, 3) for c in vertices[i]) for face in faces for i in face
                    )
                    meshes.append(corners)
        self.assertEqual(meshes[0], meshes[2])
        self.assertEqual(meshes[1], meshes[3])

    def test_a_full_mark_fits_every_part_at_its_automatic_size(self):
        cases = [
            (BAN_SCAD, ["-D", 'Output_Mode="Color body"']),
            (KOMADAI_SCAD, []),
            (KOMABAKO_SCAD, ["-D", 'Mark_Place="Both"']),
        ]
        with tempfile.TemporaryDirectory() as folder:
            tree = Path(folder) / "mark.csg"
            for scad, settings in cases:
                with self.subTest(model=scad.name):
                    self.render(scad, tree, MARK + settings)

    def test_a_mark_too_large_or_too_small_is_refused(self):
        cases = [
            (["-D", "Mark_Size=12"], "does not fit on the box"),
            (["-D", "Mark_Size=4", "-D", 'Mark_Line_2=""'], "smaller than Mark Min Text Size"),
        ]
        with tempfile.TemporaryDirectory() as folder:
            for settings, message in cases:
                with self.subTest(message=message):
                    command = ["openscad", "-o", str(Path(folder) / "box.csg")] + MARK + settings
                    command.append(str(KOMABAKO_SCAD))
                    _, log = openscad.run_openscad(command)
                    self.assertIn(message, log)

    def test_every_joint_style_bevels_the_underside_of_each_seam(self):
        # Panel 0, 0 of a 2 x 2 board has seams on its right and back edges.
        # Where the panel touches the table (z = 0), it must stop the bevel
        # short of each seam.
        bevel = 0.8
        with tempfile.TemporaryDirectory() as folder:
            mesh = Path(folder) / "panel.stl"
            for style in ("Connectors", "T-hook", "Dovetail", "Keys"):
                with self.subTest(style=style):
                    settings = TILED_BOARD + [
                        "-D",
                        f'Joint_Style="{style}"',
                        "-D",
                        'Output_Mode="Color body"',
                    ]
                    settings += [
                        "-D",
                        'Print_Orientation="Playing face up"',
                        "-D",
                        "Camp_Dots=false",
                    ]
                    settings += [
                        "-D",
                        "Joint_Edge_Margin=20",
                        "-D",
                        "Support_Band=15",
                        "--export-format",
                        "binstl",
                    ]
                    if style == "Dovetail":
                        settings += [
                            "-D",
                            "Joint_Depth=5",
                            "-D",
                            "Joint_Clearance=0.3",
                            "-D",
                            "Joint_Bottom_Chamfer=1",
                        ]
                    self.render(BAN_SCAD, mesh, settings)
                    vertices, _ = openscad.read_stl(mesh)
                    # The seam edge, where the straight seam wall meets the 0.4 mm
                    # top edge bevel: 11.6 mm up, above every tab.
                    side = [(x, y) for x, y, z in vertices if abs(z - 11.6) < 0.001]
                    seam_x = max(x for x, _ in side)
                    seam_y = max(y for _, y in side)
                    on_table = [(x, y) for x, y, z in vertices if abs(z) < 0.001]
                    self.assertLessEqual(max(x for x, _ in on_table), seam_x - bevel + 0.01)
                    self.assertLessEqual(max(y for _, y in on_table), seam_y - bevel + 0.01)

    def test_assembled_panels_meet_without_overlap(self):
        # The tongue on panel 0, 0 sits in the groove of panel 1, 0 and of
        # panel 0, 1: the panels may touch at the seam, but not overlap.
        with tempfile.TemporaryDirectory() as folder:
            model = Path(folder) / "overlap.scad"
            model.write_text(
                f"include <{BAN_SCAD.resolve()}>\n"
                "module placed(at) translate([tile_x_min(at[0]), tile_y_min(at[1]), 0])"
                " panel_body(at[0], at[1]);\n"
                "intersection() { placed([0, 0]); placed(B); }\n",
                encoding="utf-8",
            )
            mesh = Path(folder) / "overlap.stl"
            for neighbor in ("[1, 0]", "[0, 1]"):
                with self.subTest(neighbor=neighbor):
                    command = ["openscad", "-o", str(mesh), "--export-format", "asciistl"]
                    command += TILED_BOARD + ["-D", "Export_Metadata=true", "-D", f"B={neighbor}"]
                    command.append(str(model))
                    status, log = openscad.run_openscad(command)
                    self.assertEqual(status, 0, log[-800:])
                    self.assertLess(mesh_volume(mesh), 0.001)

    def test_a_pressed_connector_stops_at_its_seat(self):
        # A connector in the first socket of panel 0, 0's right seam. At its
        # seat it touches the shoulders; 0.05 mm deeper, it would be inside them.
        with tempfile.TemporaryDirectory() as folder:
            model = Path(folder) / "seat.scad"
            model.write_text(
                f"include <{BAN_SCAD.resolve()}>\n"
                "module placed(at) translate([tile_x_min(at[0]), tile_y_min(at[1]), 0])"
                " panel_body(at[0], at[1]);\n"
                "intersection() {\n"
                "    union() { placed([0, 0]); placed([1, 0]); }\n"
                "    translate([tile_x_min(0) + tile_width(0),"
                " tile_y_min(0) + socket_places_y(0)[0], connector_seat + DEEPER])"
                " connector();\n"
                "}\n",
                encoding="utf-8",
            )
            mesh = Path(folder) / "seat.stl"
            for deeper, touches in ((-0.05, False), (0.05, True)):
                with self.subTest(deeper=deeper):
                    mesh.unlink(missing_ok=True)
                    command = ["openscad", "-o", str(mesh), "--export-format", "asciistl"]
                    command += TILED_BOARD + [
                        "-D",
                        "Export_Metadata=true",
                        "-D",
                        f"DEEPER={deeper}",
                    ]
                    command.append(str(model))
                    openscad.run_openscad(command)
                    volume = mesh_volume(mesh) if mesh.exists() else 0.0
                    if touches:
                        self.assertGreater(volume, 0.1)
                    else:
                        self.assertLess(volume, 0.001)

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

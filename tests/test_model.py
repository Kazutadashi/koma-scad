"""The OpenSCAD model, and the move editor's copy of its diagram solver."""

import json
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

from komascad_lib import presets
from komascad_lib.openscad import run_openscad
from komascad_lib.project import ROOT, SCAD, VERSION

EDITOR = ROOT / "move-editor.html"

# Move grids that cover every mark and rule of the diagram solver.
EXAMPLE_GRIDS = [
    "o/@",
    "#/@",
    "x.x/.../.@.",
    "ooo/.@./o.o",
    "o#o/#@#/o#o",
    ".x./#!#/#@#/###",
    "xxxxx/xooox/xo@ox/xooox/xxxxx",
    "o..o..o/.oxoxo./.xooox./ooo@ooo/.xooox./.oxoxo./o..o..o",
    "#3#/.@./#3#",
    "===/=@=/===",
    ".L./L@L/.L.",
    "234/5@6/.7.",
    "#/x/./@",
    "#/x/x/./@",
    "#..=..#/......./..x!x../..#@#../...#.../.L...L.",
    "o/x/./@",
    "=/!/@",
    "!@!",
    "L.L/.@./L.L",
]

# The Output Modes that a user can select in the Customizer.
OUTPUT_MODES = [
    "Model",
    "Blank",
    "Inspect front",
    "Inspect back",
    "Inspect printability",
    "Inspect signature",
    "Inspect pawn circle",
]

# The model prints the diagram sizes on a line such as:
# ECHO: "KOMASCAD_MOVES", "Front", 3.75, [10.8, 10.8], 0.6, [10.8, 10.8]
MOVES_REPORT = re.compile(r'"KOMASCAD_MOVES", "Front", (.*)$', re.M)

# How many decimal places the editor and the model must agree to.
SOLVER_PLACES = 3


def definitions(**settings: str) -> list[str]:
    """Turns settings into OpenSCAD -D arguments.

    Args:
        **settings: Each value is written as OpenSCAD source, such as '"歩"' or "0".

    Returns:
        The arguments, such as ["-D", 'Front_Characters="歩"'].
    """
    arguments = []
    for name, value in settings.items():
        arguments += ["-D", f"{name}={value}"]
    return arguments


def editor_solver(script: str) -> object:
    """Runs JavaScript against the move editor's solver.

    The solver is the <script id="solver"> block of move-editor.html. The
    script reaches it as S, and prints its result as JSON.

    Args:
        script: JavaScript that ends by printing one JSON value.

    Returns:
        The printed value.
    """
    page = EDITOR.read_text(encoding="utf-8")
    source = re.search(r'<script id="solver">(.*?)</script>', page, re.S).group(1)

    with tempfile.TemporaryDirectory() as folder:
        module = Path(folder) / "solver.js"
        module.write_text(source, encoding="utf-8")
        program = f"const S = require({json.dumps(str(module))});\n{script}"
        result = subprocess.run(["node", "-e", program], capture_output=True, text=True, check=True)
    return json.loads(result.stdout)


class VersionTests(unittest.TestCase):
    """The model and the tool show the same version."""

    def test_model_and_tool_have_the_same_version(self):
        self.assertIn(f'version = "{VERSION}";', SCAD.read_text(encoding="utf-8"))


@unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD")
class ModelTests(unittest.TestCase):
    """Every Output Mode draws without an OpenSCAD warning or error."""

    def test_every_output_mode_draws_cleanly(self):
        settings = definitions(
            Front_Characters='"歩"',
            Back_Characters='"と"',
            Front_Moves='"o/@"',
            Front_Font_Size="0",
            Front_Character_Spacing="0",
            Signature_Enabled="true",
            Signature_Text='"KS"',
        )
        with tempfile.TemporaryDirectory() as folder:
            image = Path(folder) / "view.png"
            for mode in OUTPUT_MODES:
                command = ["openscad", "--hardwarnings", "-o", str(image), "--imgsize=200,200"]
                command += settings
                command += definitions(Output_Mode=f'"{mode}"')
                command.append(str(SCAD))

                status, log = run_openscad(command)
                self.assertEqual(status, 0, f"{mode}: {log[-800:]}")
                self.assertNotIn("WARNING", log, mode)


@unittest.skipUnless(shutil.which("node"), "needs node to run the move editor's solver")
class MoveEditorTests(unittest.TestCase):
    """The move editor accepts what the model accepts, and lays it out the same way."""

    def test_bundled_and_example_grids_are_valid(self):
        grids = set(EXAMPLE_GRIDS)
        for game in presets.build_games().values():
            for preset in game.presets.values():
                for side in ("Front", "Back"):
                    grid = preset.get(side + "_Moves")
                    if grid:
                        grids.add(grid)
        grids = sorted(grids)

        script = f"""
            const grids = {json.dumps(grids)};
            const errors = grids.map(grid => S.parseGrid(grid).errors);
            console.log(JSON.stringify(errors));
        """
        errors = editor_solver(script)

        errors_by_grid = dict(zip(grids, errors, strict=True))
        no_errors = {grid: [] for grid in grids}
        self.assertEqual(errors_by_grid, no_errors)

    def test_invalid_grids_are_explained(self):
        bad_grids = ["o/o", "..!/.../.@.", "#.../..@.", "o!/..@", "a/@"]
        script = f"""
            const grids = {json.dumps(bad_grids)};
            console.log(JSON.stringify(grids.map(grid => S.parseGrid(grid).errors)));
        """
        errors = editor_solver(script)
        self.assertTrue(all(errors), errors)

    @unittest.skipUnless(shutil.which("openscad"), "needs OpenSCAD to compare with the model")
    def test_editor_and_model_solve_the_same_layout(self):
        """The editor's preview spacing is the model's smallest printable spacing."""
        # For each grid: the smallest printable pitch, then the diagram's width and height.
        script = f"""
            const sizes = S.markSizes(0.8, 0.8);
            const results = {json.dumps(EXAMPLE_GRIDS)}.map(grid => {{
                const moves = S.parseGrid(grid).moves;
                const pitch = S.solve(moves, sizes);
                const box = S.box(moves, pitch, sizes);
                return [pitch, box[1][0] - box[0][0], box[1][1] - box[0][1]];
            }});
            console.log(JSON.stringify(results));
        """
        editor_results = editor_solver(script)

        for grid, expected in zip(EXAMPLE_GRIDS, editor_results, strict=True):
            with self.subTest(grid=grid):
                self.check_model_matches(grid, expected)

    def check_model_matches(self, grid: str, expected: list[float]) -> None:
        """Checks the model's smallest pitch and diagram size for one grid against the editor's."""
        with tempfile.TemporaryDirectory() as folder:
            echo = Path(folder) / "moves.echo"
            command = ["openscad", "-o", str(echo)]
            command += definitions(
                Front_Characters='""',
                Front_Moves=json.dumps(grid),
                Move_Stroke="0.8",
                Move_Gap="0.8",
                # Spacing is in final mm; a large piece keeps wide grids clear of the fit checks.
                Model_Scale="2",
            )
            command.append(str(SCAD))
            subprocess.run(command, capture_output=True, check=True)
            report = MOVES_REPORT.search(echo.read_text(encoding="utf-8")).group(1)

        # The report is: drawn pitch, drawn size, smallest pitch, smallest size.
        _, _, smallest_pitch, smallest_size = json.loads(f"[{report}]")
        model = [smallest_pitch, smallest_size[0], smallest_size[1]]
        for model_value, editor_value in zip(model, expected, strict=True):
            self.assertAlmostEqual(model_value, editor_value, places=SOLVER_PLACES, msg=grid)


if __name__ == "__main__":
    unittest.main()

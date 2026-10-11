"""The preview command, with OpenSCAD replaced by a stub."""

import json
import tempfile
import unittest
from pathlib import Path
from unittest import mock

from komascad_lib import openscad

from .support import run


def fake_render(command: list[str]) -> tuple[int, str]:
    """Stands in for OpenSCAD: writes an empty image where -o asks for one."""
    output = Path(command[command.index("-o") + 1])
    output.write_bytes(b"")
    return 0, ""


def failed_render(command: list[str]) -> tuple[int, str]:
    """Stands in for OpenSCAD when a render fails: no image, and an error."""
    return 1, "ERROR: the font is missing"


class PreviewCommandTests(unittest.TestCase):
    """preview renders both faces of every piece and writes one page."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.root = Path(folder.name)
        self.presets = self.root / "pieces.json"
        presets = {"parameterSets": {"Pawn": {}, "King <1>": {}}}
        self.presets.write_text(json.dumps(presets), encoding="utf-8")
        self.out = self.root / "preview"

    def test_page_shows_both_faces_of_every_piece(self):
        with mock.patch.object(openscad, "run_openscad", fake_render):
            status, out, _ = run("preview", self.presets, "-o", self.out)

        self.assertEqual(status, 0)
        self.assertIn("Rendering 2 pieces", out)
        image_names = sorted(path.name for path in self.out.glob("*.png"))
        self.assertEqual(
            image_names, ["01-back.png", "01-front.png", "02-back.png", "02-front.png"]
        )

        page = (self.out / "index.html").read_text(encoding="utf-8")
        self.assertIn('<img src="02-front.png" alt="">', page)
        # Preset names are escaped, so that they cannot break the page.
        self.assertIn("King &lt;1&gt;", page)

    def test_failed_render_names_the_piece_and_view(self):
        with mock.patch.object(openscad, "run_openscad", failed_render):
            status, _, err = run("preview", self.presets, "-o", self.out)

        self.assertEqual(status, 1)
        self.assertIn("Pawn (front): ERROR: the font is missing", err)


if __name__ == "__main__":
    unittest.main()

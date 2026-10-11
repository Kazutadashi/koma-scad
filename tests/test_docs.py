"""The guides stay in step with the model and with each other."""

import re
import unittest

from komascad_lib.openscad import scad_parameters
from komascad_lib.project import ROOT


class DocumentationTests(unittest.TestCase):
    """The guides stay in step with the model and with each other."""

    def test_parameter_reference_lists_every_setting(self):
        reference = (ROOT / "docs" / "parameters.md").read_text(encoding="utf-8")
        defaults, _ = scad_parameters()
        self.assertEqual([name for name in defaults if f"| `{name}` |" not in reference], [])

    def test_relative_links_point_to_files(self):
        broken = []
        for page in ROOT.glob("**/*.md"):
            if "ignored" in page.parts:
                continue
            for target in re.findall(
                r"\]\(([^)#\s]+)(?:#[^)]*)?\)", page.read_text(encoding="utf-8")
            ):
                if not re.match(r"[a-z]+:", target) and not (page.parent / target).exists():
                    broken.append(f"{page.relative_to(ROOT)} -> {target}")
        self.assertEqual(broken, [])


if __name__ == "__main__":
    unittest.main()

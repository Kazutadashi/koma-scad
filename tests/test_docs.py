"""The guides stay in step with the model and with each other."""

import re
import unittest

from komascad_lib.openscad import scad_parameters
from komascad_lib.project import BAN_SCAD, KOMABAKO_SCAD, KOMADAI_SCAD, ROOT, SCAD

# Each model, and the page that lists its settings.
REFERENCES = {
    SCAD: ROOT / "docs" / "parameters.md",
    BAN_SCAD: ROOT / "docs" / "ban.md",
    KOMADAI_SCAD: ROOT / "docs" / "komadai.md",
    KOMABAKO_SCAD: ROOT / "docs" / "komabako.md",
}


class DocumentationTests(unittest.TestCase):
    """The guides stay in step with the model and with each other."""

    def test_parameter_reference_lists_every_setting(self):
        for scad, page in REFERENCES.items():
            with self.subTest(model=scad.name):
                reference = page.read_text(encoding="utf-8")
                defaults, _ = scad_parameters(scad)
                missing = [name for name in defaults if f"| `{name}` |" not in reference]
                self.assertEqual(missing, [])

    def test_relative_links_point_to_files(self):
        broken = []
        for page in ROOT.glob("**/*.md"):
            if "ignored" in page.parts:
                continue
            # A link inside an HTML comment is not shown, such as a placeholder
            # for a picture that is not taken yet.
            text = re.sub(r"<!--.*?-->", "", page.read_text(encoding="utf-8"), flags=re.S)
            for target in re.findall(r"\]\(([^)#\s]+)(?:#[^)]*)?\)", text):
                if not re.match(r"[a-z]+:", target) and not (page.parent / target).exists():
                    broken.append(f"{page.relative_to(ROOT)} -> {target}")
        self.assertEqual(broken, [])


if __name__ == "__main__":
    unittest.main()

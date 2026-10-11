"""The code follows the project style (see ruff.toml, .prettierrc.json and CONTRIBUTING.md)."""

import shutil
import subprocess
import unittest

from komascad_lib.project import ROOT


@unittest.skipUnless(shutil.which("ruff"), "needs ruff on the PATH; or run: uvx ruff check")
class StyleTests(unittest.TestCase):
    """Ruff finds nothing to change or report."""

    def run_ruff(self, *arguments: str) -> subprocess.CompletedProcess:
        """Runs Ruff in the project folder.

        Args:
            *arguments: The Ruff command and its options.

        Returns:
            The finished process, with its output.
        """
        return subprocess.run(["ruff", *arguments], cwd=ROOT, capture_output=True, text=True)

    def test_code_is_formatted(self):
        result = self.run_ruff("format", "--check")
        self.assertEqual(result.returncode, 0, "Run: uvx ruff format\n" + result.stdout)

    def test_code_passes_the_style_checks(self):
        result = self.run_ruff("check")
        self.assertEqual(result.returncode, 0, "Run: uvx ruff check\n" + result.stdout)


@unittest.skipUnless(
    shutil.which("prettier"), "needs prettier on the PATH; or run: npx prettier --check ."
)
class EditorStyleTests(unittest.TestCase):
    """Prettier finds nothing to change in the move editor."""

    def test_move_editor_is_formatted(self):
        result = subprocess.run(
            ["prettier", "--check", "."], cwd=ROOT, capture_output=True, text=True
        )
        self.assertEqual(result.returncode, 0, "Run: npx prettier --write .\n" + result.stdout)


if __name__ == "__main__":
    unittest.main()

"""Tests for the game preset builder."""

import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location(
    "build_games", ROOT / "scripts" / "build_games.py",
)
BUILD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BUILD)


class BuildGamesTests(unittest.TestCase):
    """Check that games stay in step with the master piece list."""

    def test_generated_files_are_up_to_date(self):
        """Committed game files match what the piece files produce."""
        for key, (sets, counts) in BUILD.build_games().items():
            path = BUILD.GAMES / (key + ".json")
            self.assertEqual(path.read_text(encoding="utf-8"), BUILD.render(sets, counts), path.name)

    def test_games_share_one_piece_definition(self):
        """A piece has the same body in every game that uses it."""
        games = BUILD.build_games()
        self.assertEqual(
            games["minishogi"][0]["Minishogi 07 - Pawn"]["Piece_Length"],
            games["shogi-1char"][0]["Shogi 1-char 09 - Pawn"]["Piece_Length"],
        )

    def test_full_sets_have_the_standard_piece_totals(self):
        """Shogi needs 40 pieces and minishogi 12, counting both players."""
        games = BUILD.build_games()
        self.assertEqual(sum(games["shogi"][1].values()), 40)
        self.assertEqual(sum(games["minishogi-1char"][1].values()), 12)

    def test_unknown_parameter_is_rejected(self):
        """A misspelled parameter name fails instead of being silently ignored."""
        defaults = BUILD.read(BUILD.PIECES / "_defaults.json")
        piece = BUILD.read(BUILD.PIECES / "pawn.json")
        piece["body"]["Peice_Length"] = "28"
        with self.assertRaisesRegex(ValueError, "Peice_Length"):
            BUILD.build_preset(defaults, piece, "pawn", "two", "one")


if __name__ == "__main__":
    unittest.main()

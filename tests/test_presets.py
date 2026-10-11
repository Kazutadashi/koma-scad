"""Building game presets, and finding, selecting and editing presets."""

import json
import tempfile
import unittest
from pathlib import Path

from komascad_lib import presets
from komascad_lib.openscad import scad_definitions
from komascad_lib.project import GAMES, PIECES, KomaError, read_json

from .support import run


class BuildTests(unittest.TestCase):
    """Games stay in step with the piece files."""

    def test_generated_files_are_up_to_date(self):
        """The committed game files and shogi_piece.json match the piece files."""
        outputs = presets.generated_files(presets.build_games())
        self.assertEqual(presets.stale_files(outputs), [])
        self.assertEqual(run("build", "--check")[0], 0)

    def test_games_share_one_piece_definition(self):
        """A piece has the same body in every game that uses it."""
        games = presets.build_games()
        self.assertEqual(
            games["minishogi"].presets["Minishogi 07 - Pawn"]["Piece_Length"],
            games["shogi-1char"].presets["Shogi 1-char 09 - Pawn"]["Piece_Length"],
        )

    def test_full_sets_have_the_standard_piece_totals(self):
        """Shogi needs 40 pieces and minishogi 12, counting both players."""
        games = presets.build_games()
        self.assertEqual(sum(games["shogi"].counts.values()), 40)
        self.assertEqual(sum(games["minishogi-1char"].counts.values()), 12)

    def test_unknown_parameter_is_rejected(self):
        """A misspelled parameter name fails instead of being silently ignored."""
        defaults = read_json(PIECES / "_defaults.json")
        piece = read_json(PIECES / "pawn.json")
        piece["body"]["Peice_Length"] = "28"
        with self.assertRaisesRegex(KomaError, "Peice_Length"):
            presets.build_preset(defaults, piece, "pawn", "two", "one")

    def test_learner_pieces_show_their_moves_on_both_faces(self):
        """Every lettered learner face has a move grid; promoted minor pieces move like gold."""
        learner = presets.build_games()["shogi-learner"].presets
        for name, preset in learner.items():
            for side in ("Front", "Back"):
                if not preset[side + "_Characters"]:
                    continue
                grid = preset[side + "_Moves"]
                rows = grid.split("/")
                self.assertEqual(grid.count("@"), 1, (name, side))
                self.assertEqual(set(grid) - set(".ox#@/"), set(), (name, side))
                self.assertEqual(len({len(row) for row in rows}), 1, (name, side))
        gold = learner["Shogi Learner 05 - Gold"]["Front_Moves"]
        for piece in ("06 - Silver", "07 - Knight", "08 - Lance", "09 - Pawn"):
            self.assertEqual(learner[f"Shogi Learner {piece}"]["Back_Moves"], gold, piece)

    def test_bundled_presets_use_only_parameters_the_model_declares(self):
        """Every generated preset can be turned into OpenSCAD definitions."""
        for game in presets.build_games().values():
            for name, values in game.presets.items():
                scad_definitions(name, values, {})


class SelectionTests(unittest.TestCase):
    """Games and pieces are found by short, forgiving names."""

    def test_game_name_and_path_reach_the_same_file(self):
        path = GAMES / "shogi.json"
        self.assertEqual(presets.find_preset_file("shogi"), path)
        self.assertEqual(presets.find_preset_file(str(path)), path)

    def test_unknown_game_suggests_a_close_name(self):
        with self.assertRaisesRegex(KomaError, "Did you mean 'shogi'"):
            presets.find_preset_file("shgi")

    def test_pieces_match_by_exact_name_or_part_of_a_name(self):
        names = ["Shogi 01 - King (Osho)", "Shogi 02 - King (Gyokusho)", "Shogi 09 - Pawn"]
        self.assertEqual(presets.select_presets(names, []), names)
        self.assertEqual(presets.select_presets(names, ["pawn", "KING"]), names)
        self.assertEqual(presets.select_presets(names, ["Shogi 09 - Pawn"]), names[2:])
        with self.assertRaisesRegex(KomaError, "No piece matches 'lion'"):
            presets.select_presets(names, ["lion"])

    def test_piece_counts_default_to_one(self):
        """A file's pieceCounts set the copies; other presets count once."""
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "set.json"
            path.write_text(
                json.dumps(
                    {"parameterSets": {"Pawn": {}, "King": {}}, "pieceCounts": {"Pawn": 18}}
                ),
                encoding="utf-8",
            )
            self.assertEqual(presets.load_preset_file(path).counts, {"Pawn": 18, "King": 1})

    def test_list_shows_games_then_pieces(self):
        status, out, _ = run("list")
        self.assertEqual(status, 0)
        self.assertRegex(out, r"shogi\s+9\s+40")
        status, out, _ = run("list", "shogi")
        self.assertIn("Shogi 09 - Pawn  x18", out)


class SetCommandTests(unittest.TestCase):
    """Bulk edits of hand-kept preset files."""

    def setUp(self):
        folder = tempfile.TemporaryDirectory()
        self.addCleanup(folder.cleanup)
        self.path = Path(folder.name) / "mine.json"
        self.path.write_text(
            json.dumps(
                {
                    "fileFormatVersion": "1",
                    "parameterSets": {
                        "Grid 01": {"Category": "Grid search", "Base_Width": "28"},
                        "Pawn": {"Category": "Shogi / Pawn", "Base_Width": "24"},
                    },
                }
            ),
            encoding="utf-8",
        )

    def widths(self):
        sets = json.loads(self.path.read_text(encoding="utf-8"))["parameterSets"]
        return [values["Base_Width"] for values in sets.values()]

    def test_changes_only_the_selected_presets(self):
        self.assertEqual(run("set", self.path, "Base_Width=30", "--category", "grid")[0], 0)
        self.assertEqual(self.widths(), ["30", "24"])

    def test_dry_run_writes_nothing(self):
        self.assertEqual(run("set", self.path, "Base_Width=30", "--all", "-n")[0], 0)
        self.assertEqual(self.widths(), ["28", "24"])

    def test_misspelled_parameter_is_rejected(self):
        status, _, err = run("set", self.path, "Base_Widht=30", "--all")
        self.assertEqual(status, 1)
        self.assertIn("Base_Widht", err)


if __name__ == "__main__":
    unittest.main()

"""Where the project's files are, the version, and the error shown to users."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any

# The same as `version` in shogi_piece.scad. A test checks that they match.
VERSION = "3.5"

ROOT = Path(__file__).resolve().parent.parent
SCAD = ROOT / "shogi_piece.scad"

# Every game in one file, for the OpenSCAD Customizer.
CUSTOMIZER = ROOT / "shogi_piece.json"

# The sources that people edit: one file per piece, and the pieces in each game.
PIECES = ROOT / "presets" / "pieces"
RECIPES = ROOT / "presets" / "games.json"

# Files that the build command makes from the sources.
GAMES = ROOT / "presets" / "games"
TEST_PAGE = ROOT / "presets" / "print-test"


class KomaError(Exception):
    """A problem that the user can fix.

    The tool prints the message without a traceback. Any other exception is a
    bug in the tool, and shows its traceback.
    """


def shown(path: Path) -> str:
    """Describes a path for a message.

    Args:
        path: Any path.

    Returns:
        The path relative to the project folder when it is inside it, otherwise
        the full path.
    """
    try:
        return path.relative_to(ROOT).as_posix()
    except ValueError:
        return str(path)


def read_json(path: Path) -> Any:
    """Reads one JSON file.

    Args:
        path: The file to read.

    Returns:
        The parsed JSON.

    Raises:
        KomaError: The file is missing or is not valid JSON. The message names the file.
    """
    try:
        text = path.read_text(encoding="utf-8")
    except FileNotFoundError:
        raise KomaError(f"Missing file: {shown(path)}") from None

    try:
        return json.loads(text)
    except json.JSONDecodeError as error:
        raise KomaError(f"Invalid JSON in {shown(path)}: {error}") from None

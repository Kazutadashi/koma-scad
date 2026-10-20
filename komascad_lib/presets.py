"""Game presets: build them from the piece files, then find, read and select them.

Sources (edit these):
    koma/presets/pieces/_defaults.json   settings that every piece shares
    koma/presets/pieces/<piece>.json     one file per piece
    koma/presets/games.json              which pieces, and how many, make up each game

Made by the build command (do not edit):
    koma/presets/games/<game>.json       one Customizer file per game
    koma/koma.json                       every game, for the Customizer
    koma/presets/print-test/*.json       the print test page (see print_test_page.py)
"""

from __future__ import annotations

import difflib
import json
import sys
from dataclasses import dataclass
from pathlib import Path

from .print_test_page import build_test_page
from .project import CUSTOMIZER, GAMES, PIECES, RECIPES, TEST_PAGE, KomaError, read_json, shown

Settings = dict[str, str]

# The body dimensions that a piece file may set. Every other setting must also
# be in _defaults.json, so that a misspelled name is caught.
BODY_SETTINGS = {"Piece_Length", "Base_Width", "Rear_Thickness", "Tip_Thickness"}

# Generated files use the layout that the OpenSCAD Customizer writes.
JSON_INDENT = 4


@dataclass
class Game:
    """The presets of one game.

    Attributes:
        presets: The settings of each preset, by preset name, in game order.
        counts: How many of each preset a full set needs, by preset name.
    """

    presets: dict[str, Settings]
    counts: dict[str, int]


@dataclass
class PresetFile:
    """A Customizer preset file.

    Attributes:
        path: Where the file is.
        presets: The settings of each preset, by preset name, in file order.
        counts: How many of each preset a full set needs, by preset name.
    """

    path: Path
    presets: dict[str, Settings]
    counts: dict[str, int]


# --- Building game presets -------------------------------------------------------


def face_style(source: dict, side: str, style: str, where: str) -> Settings:
    """Finds the settings of one face style, such as the "two" style of the front.

    Args:
        source: A piece file, or _defaults.json, as parsed JSON.
        side: "front" or "back".
        style: The style name, such as "one", "two" or "learner".
        where: The file name, for the error message.

    Returns:
        The settings of that style.

    Raises:
        KomaError: The file has no such style.
    """
    styles = source.get(side, {})
    if style in styles:
        return styles[style]

    available = ", ".join(styles)
    if not available:
        available = "none"
    raise KomaError(f"{where} has no {side} style {style!r} (available: {available})")


def build_preset(defaults: dict, piece: dict, filename: str, front: str, back: str) -> Settings:
    """Combines the shared defaults and one piece into a full set of settings.

    The settings are layered in this order, and a later layer wins:
    common defaults, front style defaults, back style defaults, the piece body,
    the piece front style, and the piece back style.

    Args:
        defaults: _defaults.json, as parsed JSON.
        piece: One piece file, as parsed JSON.
        filename: The piece file name without ".json", for error messages.
        front: The front style of the game, such as "two".
        back: The back style of the game, such as "one".

    Returns:
        Every setting of the preset.

    Raises:
        KomaError: A style is missing, or a layer uses a setting that does not exist.
    """
    where = f"{filename}.json"

    layers = [
        defaults["common"],
        face_style(defaults, "front", front, "_defaults.json"),
        face_style(defaults, "back", back, "_defaults.json"),
        piece.get("body", {}),
        face_style(piece, "front", front, where),
    ]
    # Kings and golds have no promoted side, so their back stays blank.
    if "back" in piece:
        layers.append(face_style(piece, "back", back, where))

    known = set(layers[0]) | set(layers[1]) | set(layers[2]) | BODY_SETTINGS

    preset = {}
    for layer in layers:
        unknown = sorted(set(layer) - known)
        if unknown:
            raise KomaError(f"{where} uses unknown parameter(s): {', '.join(unknown)}")
        preset.update(layer)
    return preset


def build_games() -> dict[str, Game]:
    """Builds every game in games.json from the piece files.

    Returns:
        Each game, by its key in games.json (such as "shogi").
    """
    defaults = read_json(PIECES / "_defaults.json")
    recipes = read_json(RECIPES)

    games = {}
    for key, recipe in recipes.items():
        title = recipe["title"]
        game = Game(presets={}, counts={})

        for number, (filename, count) in enumerate(recipe["pieces"].items(), start=1):
            piece = read_json(PIECES / (filename + ".json"))

            preset = build_preset(defaults, piece, filename, recipe["front"], recipe["back"])
            preset["Category"] = f"{title} / {piece['category']}"

            name = f"{title} {number:02d} - {piece['name']}"
            game.presets[name] = preset
            game.counts[name] = count

        games[key] = game
    return games


def render_presets(
    presets: dict[str, Settings],
    counts: dict[str, int] | None = None,
    rows: list[int] | None = None,
) -> str:
    """Writes presets as the text of a Customizer preset file.

    Args:
        presets: The settings of each preset, by preset name.
        counts: Optional. How many of each preset a set needs; written as pieceCounts.
        rows: Optional. The pieces in each row of a layout; written as layoutRows.

    Returns:
        The file text. OpenSCAD ignores pieceCounts and layoutRows; the export
        command reads them.
    """
    document: dict[str, object] = {"fileFormatVersion": "1", "parameterSets": presets}
    if counts:
        document["pieceCounts"] = counts
    if rows:
        document["layoutRows"] = rows

    text = json.dumps(document, ensure_ascii=False, indent=JSON_INDENT, sort_keys=True)
    return text + "\n"


def generated_files(games: dict[str, Game]) -> dict[Path, str]:
    """Makes the text of every file that the build command writes.

    Args:
        games: Every game, from build_games().

    Returns:
        The text of each file, by its path.

    Raises:
        KomaError: Two games make a preset with the same name.
    """
    all_presets: dict[str, Settings] = {}
    for game in games.values():
        duplicates = sorted(set(game.presets) & set(all_presets))
        if duplicates:
            raise KomaError("Two games produce the same preset name: " + duplicates[0])
        all_presets.update(game.presets)

    outputs: dict[Path, str] = {}
    for key, game in games.items():
        outputs[GAMES / (key + ".json")] = render_presets(game.presets, game.counts)

    outputs[CUSTOMIZER] = render_presets(all_presets)

    for plate in build_test_page():
        outputs[TEST_PAGE / plate.filename] = render_presets(plate.presets, rows=plate.rows)
    return outputs


def write_generated_files(outputs: dict[Path, str]) -> None:
    """Writes the generated files, and makes their folders when needed.

    Args:
        outputs: The text of each file, by its path, from generated_files().
    """
    for path, text in outputs.items():
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")


def stale_files(outputs: dict[Path, str]) -> list[Path]:
    """Finds the generated files that are missing, or differ from a fresh build.

    Args:
        outputs: The fresh build, from generated_files().

    Returns:
        The paths that do not match.
    """
    stale = []
    for path, text in outputs.items():
        if not path.exists() or path.read_text(encoding="utf-8") != text:
            stale.append(path)
    return stale


def unsaved_edits() -> list[str]:
    """Finds Customizer changes in koma/koma.json that a rebuild would erase.

    The Customizer saves into koma/koma.json, and the build writes that file
    again. Anything in it that differs from the last build exists nowhere else.

    Returns:
        One line for each change, such as "Shogi 09 - Pawn: Base_Width = 25 (built value: 24.5)".
    """
    if not CUSTOMIZER.exists():
        return []

    current = read_json(CUSTOMIZER).get("parameterSets", {})
    built: dict[str, Settings] = {}
    for path in sorted(GAMES.glob("*.json")):
        built.update(read_json(path).get("parameterSets", {}))

    edits = []
    for name, values in current.items():
        if name not in built:
            edits.append(f"{name}: preset is not in any game file")
            continue

        for parameter in sorted(set(values) | set(built[name])):
            built_value = built[name].get(parameter)
            saved_value = values.get(parameter)
            if built_value != saved_value:
                edits.append(f"{name}: {parameter} = {saved_value} (built value: {built_value})")
    return edits


# --- Finding and reading preset files --------------------------------------------


def find_preset_file(text: str) -> Path:
    """Finds the preset file that a GAME argument names.

    Args:
        text: A game name such as "shogi", or the path of any preset file.

    Returns:
        The full path of the file.

    Raises:
        KomaError: No such game or file, or a game file is older than its piece files.
    """
    path = Path(text)
    if not path.is_file():
        path = GAMES / (text + ".json")

    if not path.is_file():
        games = sorted(candidate.stem for candidate in GAMES.glob("*.json"))
        close = difflib.get_close_matches(text, games, n=1)
        suggestion = f" Did you mean {close[0]!r}?" if close else ""
        raise KomaError(
            f"No game or preset file named {text!r}.{suggestion} Games: {', '.join(games)}"
        )

    path = path.resolve()

    # Only the game files must match the piece files: koma/koma.json may hold
    # Customizer edits on purpose.
    if path.parent == GAMES:
        fresh_build = generated_files(build_games())
        if path in stale_files(fresh_build):
            tool = Path(sys.argv[0]).name
            raise KomaError(
                f"{shown(path)} is older than the piece files. Run '{tool} build' first."
            )
    return path


def load_preset_file(path: Path) -> PresetFile:
    """Reads a Customizer preset file.

    Args:
        path: The file to read.

    Returns:
        The presets and their counts. The counts come from the optional
        pieceCounts object; a preset that it does not name counts once.
    """
    document = read_json(path)
    presets = document["parameterSets"]
    declared = document.get("pieceCounts", {})

    counts = {}
    for name in presets:
        counts[name] = declared.get(name, 1)
    return PresetFile(path, presets, counts)


def load_layout_rows(path: Path, pieces: int) -> list[int] | None:
    """Reads the optional row plan of a preset file.

    A row plan gives the number of pieces in each row of a layout, from the
    back of the bed. It suits files that mix piece sizes, where one shared grid
    cell would waste space on the bed.

    Args:
        path: The preset file.
        pieces: The number of pieces placed from the file, counting copies.

    Returns:
        The pieces in each row, or None when the file has no row plan.

    Raises:
        KomaError: The rows do not add up to the number of pieces.
    """
    rows = read_json(path).get("layoutRows")
    if rows and sum(rows) != pieces:
        raise KomaError(
            f"layoutRows in {shown(path)} places {sum(rows)} pieces but the file has {pieces}"
        )
    return rows


def select_presets(names: list[str], filters: list[str]) -> list[str]:
    """Picks presets by their exact name, or by a part of the name in any letter case.

    Args:
        names: All preset names, in file order.
        filters: The texts to look for. No filters selects every preset.

    Returns:
        The selected names, in file order.

    Raises:
        KomaError: A filter matches no preset.
    """
    if not filters:
        return list(names)

    chosen = set()
    for text in filters:
        if text in names:
            matches = [text]
        else:
            matches = [name for name in names if text.casefold() in name.casefold()]

        if not matches:
            raise KomaError(f"No piece matches {text!r}. Use the list command to see the names.")
        chosen.update(matches)

    return [name for name in names if name in chosen]


# --- Editing hand-kept preset files ----------------------------------------------


def set_values(
    document: dict,
    assignments: list[tuple[str, str]],
    select_all: bool,
    name_filters: list[str],
    category_filters: list[str],
) -> tuple[list[str], int]:
    """Sets the same values in a group of presets. The document changes in place.

    Args:
        document: A preset file, as parsed JSON.
        assignments: (parameter name, new value) pairs. Values are text, as the
            Customizer saves them.
        select_all: Select every preset.
        name_filters: Select the presets whose name contains one of these texts.
        category_filters: Select the presets whose Category contains one of these texts.

    Returns:
        A line for each value that changed, and the number of selected presets.

    Raises:
        KomaError: A selected preset does not have one of the parameters. This
            is usually a spelling mistake.
    """
    names = [text.casefold() for text in name_filters]
    categories = [text.casefold() for text in category_filters]

    changes = []
    selected = 0
    for name, values in document["parameterSets"].items():
        category = str(values.get("Category", "")).casefold()
        name_matches = any(text in name.casefold() for text in names)
        category_matches = any(text in category for text in categories)
        if not (select_all or name_matches or category_matches):
            continue

        selected += 1
        for key, value in assignments:
            if key not in values:
                raise KomaError(f"{name!r} has no parameter {key!r}; check the spelling")

            old = values[key]
            if old != value:
                changes.append(f"{name}: {key}: {old!r} -> {value!r}")
                values[key] = value

    return changes, selected

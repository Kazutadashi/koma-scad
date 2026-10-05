#!/usr/bin/env python3
"""Combine the master piece list into complete game preset files.

Python 3.8+; standard library only.

Sources (edit these):
    presets/individual pieces/_defaults.json   settings every piece shares
    presets/individual pieces/<piece>.json     one file per piece
    presets/games.json                         which pieces, and how many, make up each game

Generated (do not edit; rebuilt on every run):
    presets/games/<game>.json                  one Customizer file per game
    shogi_piece.json                           every game, for the Customizer

Each preset is layered, later entries winning:
    common defaults -> front style defaults -> back style defaults
    -> piece body -> piece front style -> piece back style

Usage:
    python3 scripts/build_games.py           rebuild everything
    python3 scripts/build_games.py --check   report stale files, change nothing
    python3 scripts/build_games.py --force   also discard unsaved Customizer edits
"""

import argparse
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PIECES = ROOT / "presets" / "individual pieces"
RECIPES = ROOT / "presets" / "games.json"
GAMES = ROOT / "presets" / "games"
CUSTOMIZER = ROOT / "shogi_piece.json"


def read(path):
    """Parse one JSON source file, naming it in any error."""
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise ValueError("Missing file: %s" % path.relative_to(ROOT))
    except json.JSONDecodeError as error:
        raise ValueError("Invalid JSON in %s: %s" % (path.relative_to(ROOT), error))


def face(source, side, style, where):
    """Return the ``style`` settings of one face, or explain what is missing."""
    styles = source.get(side, {})
    if style not in styles:
        raise ValueError("%s has no %s style %r (available: %s)" % (
            where, side, style, ", ".join(styles) or "none"))
    return styles[style]


def build_preset(defaults, piece, filename, front, back):
    """Layer the shared defaults and one piece into a full parameter set."""
    where = "%s.json" % filename
    layers = [
        defaults["common"],
        face(defaults, "front", front, "_defaults.json"),
        face(defaults, "back", back, "_defaults.json"),
        piece.get("body", {}),
        face(piece, "front", front, where),
    ]
    # Kings and golds have no promoted side: their reverse stays blank.
    if "back" in piece:
        layers.append(face(piece, "back", back, where))
    known = set(layers[0]) | set(layers[1]) | set(layers[2]) | {
        "Piece_Length", "Base_Width", "Rear_Thickness", "Tip_Thickness"}
    preset = {}
    for layer in layers:
        unknown = sorted(set(layer) - known)
        if unknown:
            raise ValueError("%s uses unknown parameter(s): %s" % (where, ", ".join(unknown)))
        preset.update(layer)
    return preset


def build_games():
    """Return ``{game filename: (presets, counts)}`` for every recipe.

    ``presets`` maps preset names to parameters; ``counts`` maps the same
    names to how many of that piece a complete set needs.
    """
    defaults = read(PIECES / "_defaults.json")
    games = {}
    for key, recipe in read(RECIPES).items():
        sets, counts = {}, {}
        if not isinstance(recipe["pieces"], dict):
            raise ValueError("games.json: %s pieces must map each piece to its count" % key)
        for number, (filename, count) in enumerate(recipe["pieces"].items(), 1):
            if not isinstance(count, int) or isinstance(count, bool) or count < 1:
                raise ValueError("games.json: %s needs a whole number of %s, at least 1" % (key, filename))
            piece = read(PIECES / (filename + ".json"))
            preset = build_preset(defaults, piece, filename, recipe["front"], recipe["back"])
            preset["Category"] = "%s / %s" % (recipe["title"], piece["category"])
            name = "%s %02d - %s" % (recipe["title"], number, piece["name"])
            sets[name], counts[name] = preset, count
        games[key] = (sets, counts)
    return games


def render(sets, counts=None):
    """Serialize parameter sets the way the OpenSCAD Customizer saves them.

    ``counts`` adds the ``pieceCounts`` object the exporter reads; OpenSCAD
    ignores it.
    """
    document = {"fileFormatVersion": "1", "parameterSets": sets}
    if counts:
        document["pieceCounts"] = counts
    return json.dumps(document, ensure_ascii=False, indent=4, sort_keys=True) + "\n"


def unsaved_edits():
    """List Customizer changes in shogi_piece.json that a rebuild would erase.

    The Customizer saves into shogi_piece.json, which this script regenerates.
    Anything there that differs from the last build exists nowhere else.
    """
    if not CUSTOMIZER.exists():
        return []
    current = read(CUSTOMIZER).get("parameterSets", {})
    previous = {}
    for path in sorted(GAMES.glob("*.json")):
        previous.update(read(path).get("parameterSets", {}))
    edits = []
    for name, values in current.items():
        if name not in previous:
            edits.append("%s: preset is not in any game file" % name)
            continue
        for parameter in sorted(set(values) | set(previous[name])):
            old, new = previous[name].get(parameter), values.get(parameter)
            if old != new:
                edits.append("%s: %s = %s (built value: %s)" % (name, parameter, new, old))
    return edits


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--check", action="store_true",
                        help="exit 1 if any generated file is out of date; write nothing")
    parser.add_argument("--force", action="store_true",
                        help="overwrite shogi_piece.json even if it holds unsaved Customizer edits")
    args = parser.parse_args()

    try:
        games = build_games()
        combined = {}
        for sets, _ in games.values():
            duplicate = sorted(set(sets) & set(combined))
            if duplicate:
                raise ValueError("Two games produce the same preset name: " + duplicate[0])
            combined.update(sets)
        outputs = {GAMES / (key + ".json"): render(sets, counts) for key, (sets, counts) in games.items()}
        outputs[CUSTOMIZER] = render(combined)
        edits = [] if args.check or args.force else unsaved_edits()
    except ValueError as error:
        sys.exit("Error: %s" % error)

    if args.check:
        stale = [path for path, text in outputs.items()
                 if not path.exists() or path.read_text(encoding="utf-8") != text]
        for path in stale:
            print("Out of date: %s" % path.relative_to(ROOT))
        sys.exit(1 if stale else 0)

    if edits:
        print("shogi_piece.json has Customizer edits that are not in the piece files:\n")
        for edit in edits:
            print("  " + edit)
        sys.exit("\nCopy the values you want to keep into presets/individual pieces/, "
                 "then rerun (or use --force to discard them).")

    GAMES.mkdir(parents=True, exist_ok=True)
    for path, text in outputs.items():
        path.write_text(text, encoding="utf-8")
    for key, (sets, counts) in games.items():
        print("presets/games/%s.json: %d presets, %d pieces in a full set" % (
            key, len(sets), sum(counts.values())))
    print("shogi_piece.json: %d presets (all games, for the Customizer)" % len(combined))


if __name__ == "__main__":
    main()

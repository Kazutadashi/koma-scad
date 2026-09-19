#!/usr/bin/env python3
"""Preview and mass-edit OpenSCAD Customizer presets safely.

The tool is dependency-free and uses dry runs by default.  It selects presets
by name or Category, then applies each ``--set PARAMETER=VALUE`` change to all
of them.  Preset values stay as strings, matching OpenSCAD Customizer JSON.

Examples:
    # Discover the exact preset names and categories in a file.
    python3 scripts/mass_edit_presets.py shogi_piece.json --list

    # Preview a change to all matching grid presets; no file is changed.
    python3 scripts/mass_edit_presets.py shogi_piece.json \
        --category 'Professional king grid search' --set Base_Width=30

    # Apply two reviewed settings to Chu Shogi presets.
    python3 scripts/mass_edit_presets.py chu_shogi.json --preset 'Chu Shogi' \
        --set Front_Stroke_Expansion=0.18 --set Front_Relief_Depth=0.30 --write

    # An array is also a normal Customizer string, so quote it for the shell.
    python3 scripts/mass_edit_presets.py shogi_piece.json --preset 'Grid 05' \
        --set 'Front_Glyph_Width=[1.0, 1.1, 1.0]' --write
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import tempfile
from pathlib import Path


def assignment(text: str) -> tuple[str, str]:
    """Parse a ``PARAMETER=VALUE`` option while keeping the value as text.

    Args:
        text: Value passed to ``--set``.

    Returns:
        The parameter name and its replacement Customizer string.

    Raises:
        argparse.ArgumentTypeError: If the option is not an assignment.
    """
    if "=" not in text:
        raise argparse.ArgumentTypeError("Use PARAMETER=VALUE, for example Base_Width=30")
    key, value = text.split("=", 1)
    if not key.strip() or value == "":
        raise argparse.ArgumentTypeError("Both PARAMETER and VALUE are required")
    return key.strip(), value


def parser() -> argparse.ArgumentParser:
    """Build the command-line interface and its help text."""
    result = argparse.ArgumentParser(
        description=("Preview or mass-edit OpenSCAD Customizer presets. Changes are a safe dry run "
                     "unless you add --write."),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""\
QUICK START
  1. List what is available:
       python3 scripts/mass_edit_presets.py shogi_piece.json --list

  2. Preview one change for every matching grid preset (nothing is saved):
       python3 scripts/mass_edit_presets.py shogi_piece.json \\
           --category 'Professional king grid search' --set Base_Width=30

  3. Read the preview, then repeat the command with --write to save it:
       python3 scripts/mass_edit_presets.py shogi_piece.json \\
           --category 'Professional king grid search' --set Base_Width=30 --write

MORE EXAMPLES
  Change two settings in every preset whose NAME includes "Chu Shogi":
       python3 scripts/mass_edit_presets.py chu_shogi.json --preset 'Chu Shogi' \\
           --set Front_Stroke_Expansion=0.18 --set Front_Relief_Depth=0.30 --write

  Change one known preset by part of its name:
       python3 scripts/mass_edit_presets.py shogi_piece.json --preset 'Grid 05' \\
           --set Front_Character_Spacing=15 --write

  Store a Customizer array value (quote it so the shell leaves it intact):
       python3 scripts/mass_edit_presets.py shogi_piece.json --preset 'Grid 05' \\
           --set 'Front_Glyph_Width=[1.0, 1.1, 1.0]' --write

  Deliberately update every preset in a file:
       python3 scripts/mass_edit_presets.py shogi_piece.json --all \\
           --set Text_Curve_Resolution=64 --write

SELECTION AND SAFETY
  --preset and --category use case-insensitive text matching. Repeating either
  option selects the union (OR) of its matches. You must supply --preset,
  --category, or the explicit --all safeguard before edits are allowed.

  Parameter names must be exact JSON/SCAD identifiers, such as Bevel_Width or
  Front_Spacing_Scale. The OpenSCAD UI may render underscores as spaces, but
  those display labels are not valid preset keys. Values are stored as
  Customizer text. Quote a --set assignment if it contains brackets, commas,
  spaces, or shell-special characters. Missing names are rejected to catch
  typos; use --create-missing only when adding a genuinely new parameter.
""",
    )
    result.add_argument("file", type=Path, help="Customizer JSON preset file")
    result.add_argument("--list", action="store_true", help="list preset names and categories, then exit")
    result.add_argument("--preset", action="append", default=[], metavar="TEXT",
                        help="select names containing TEXT; may be repeated")
    result.add_argument("--category", action="append", default=[], metavar="TEXT",
                        help="select Categories containing TEXT; may be repeated")
    result.add_argument("--all", action="store_true", help="select every preset (required for an unfiltered edit)")
    result.add_argument("--set", action="append", default=[], type=assignment,
                        metavar="PARAMETER=VALUE", help="parameter update; may be repeated")
    result.add_argument("--create-missing", action="store_true",
                        help="allow a new parameter; normally missing names are errors")
    result.add_argument("--write", action="store_true", help="save updates; omit for a safe preview")
    return result


def load(path: Path) -> dict:
    """Read a preset file and verify it has a Customizer ``parameterSets`` object.

    Args:
        path: JSON file selected on the command line.

    Returns:
        The parsed JSON document.

    Raises:
        ValueError: If the file is absent, invalid JSON, or not a preset file.
    """
    try:
        with path.open(encoding="utf-8") as source:
            data = json.load(source)
    except FileNotFoundError as error:
        raise ValueError(f"Preset file does not exist: {path}") from error
    except json.JSONDecodeError as error:
        raise ValueError(f"Invalid JSON in {path}: {error}") from error
    if not isinstance(data, dict) or not isinstance(data.get("parameterSets"), dict):
        raise ValueError("Expected a JSON object with a 'parameterSets' object")
    return data


def choose(parameter_sets: dict, names: list[str], categories: list[str], all_presets: bool) -> list[tuple[str, dict]]:
    """Find presets using case-insensitive name/category substring filters.

    Args:
        parameter_sets: Preset name-to-parameter mapping from the JSON file.
        names: ``--preset`` filters.
        categories: ``--category`` filters.
        all_presets: Whether every valid preset should be returned.

    Returns:
        Selected ``(preset_name, parameters)`` pairs in file order.
    """
    names = [item.casefold() for item in names]
    categories = [item.casefold() for item in categories]
    selected = []
    for name, parameters in parameter_sets.items():
        if not isinstance(parameters, dict):
            continue
        category = str(parameters.get("Category", "")).casefold()
        if all_presets or any(word in name.casefold() for word in names) or any(word in category for word in categories):
            selected.append((name, parameters))
    return selected


def apply(selected: list[tuple[str, dict]], updates: list[tuple[str, str]], create_missing: bool) -> list[str]:
    """Validate/apply in-memory edits and create a readable preview.

    Args:
        selected: Presets chosen by the filters.
        updates: Parameter/value assignments from ``--set``.
        create_missing: Whether an absent parameter may be added.

    Returns:
        Lines describing the values that actually changed.

    Raises:
        ValueError: If a parameter is absent and adding it was not requested.
    """
    changes = []
    for preset_name, parameters in selected:
        for key, value in updates:
            if key not in parameters and not create_missing:
                raise ValueError(f"{preset_name!r} has no exact key {key!r}; check spelling or use --create-missing")
            old = parameters.get(key, "<missing>")
            if old != value:
                changes.append(f"{preset_name}: {key}: {old!r} -> {value!r}")
                parameters[key] = value
    return changes


def save(path: Path, document: dict) -> None:
    """Atomically replace the JSON file so an interrupted save cannot corrupt it.

    Args:
        path: Existing preset file to replace.
        document: Updated complete JSON document.
    """
    # A temporary sibling allows os.replace() to be atomic on normal filesystems.
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent,
                                     prefix=f".{path.name}.", suffix=".tmp", delete=False) as temporary:
        json.dump(document, temporary, ensure_ascii=False, indent=4)
        temporary.write("\n")
        temporary_path = temporary.name
    os.replace(temporary_path, path)


def main(argv: list[str] | None = None) -> int:
    """Run the command-line application.

    Args:
        argv: Optional arguments excluding the program name.

    Returns:
        Process exit status: zero on success and argparse's normal error code otherwise.
    """
    args_parser = parser()
    args = args_parser.parse_args(argv)
    try:
        document = load(args.file)
        parameter_sets = document["parameterSets"]
        if args.list:
            for name, parameters in parameter_sets.items():
                category = parameters.get("Category", "(no category)") if isinstance(parameters, dict) else "(invalid preset)"
                print(f"{name}\t[{category}]")
            return 0
        if not args.set:
            raise ValueError("Supply --set PARAMETER=VALUE, or use --list")
        if not (args.preset or args.category or args.all):
            raise ValueError("Select presets with --preset, --category, or explicit --all")
        selected = choose(parameter_sets, args.preset, args.category, args.all)
        if not selected:
            raise ValueError("No presets matched the selection")
        changes = apply(selected, args.set, args.create_missing)
    except ValueError as error:
        args_parser.error(str(error))

    print(f"Selected {len(selected)} preset(s).")
    if not changes:
        print("No values would change.")
        return 0
    print(*changes, sep="\n")
    if not args.write:
        print("\nDry run only: no file was changed. Re-run with --write to apply these edits.")
        return 0
    save(args.file, document)
    print(f"\nWrote {len(changes)} change(s) to {args.file}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())

"""The commands of komascad.py and their options.

Each cmd_* function runs one command and returns the exit status. The work is
done in the other modules; this module reads the options and prints the results.
"""

from __future__ import annotations

import argparse
import json
import math
import os
import sys
from pathlib import Path

from . import ban, export, presets, preview
from .export import ExportOptions
from .presets import JSON_INDENT, find_preset_file, load_preset_file, select_presets
from .print_test_page import build_test_page
from .printability import GAP_LIMIT, THIN_LIMIT, measure_presets, printability_problems
from .project import BAN_PRESETS, CUSTOMIZER, VERSION, KomaError, read_json, shown

# --orientation choices, and the Print_Orientation value that each selects.
ORIENTATIONS = {
    "upright": "Upright",
    "front-down": "Front face down",
    "back-down": "Back face down",
}

# Export overrides: option name -> (OpenSCAD parameter, help text).
OVERRIDES = {
    "front_text": ("Front_Characters", "front inscription"),
    "back_text": ("Back_Characters", "back inscription"),
    "body_color": ("Body_Filament", "body filament, e.g. Wood"),
    "front_color": ("Front_Filament", "front lettering filament, e.g. Black"),
    "back_color": ("Back_Filament", "back lettering filament, e.g. Red"),
    "signature_text": ("Signature_Text", "heel signature; also enables it"),
    "signature_color": ("Signature_Filament", "signature filament"),
}

# The table of the list command. The numbers line up under these headings.
COLUMN_GAP = "  "
GAME_HEADING = "GAME"
PIECES_HEADING = "PIECES"
FULL_SET_HEADING = "FULL SET"

# The check command starts each line with a status of this width, so the names line up.
STATUS_WIDTH = len("FAIL")

# Lines of the dry run are indented under the folder name.
DRY_RUN_INDENT = "  "

# Exit statuses. 130 is the shell's convention for Ctrl+C: 128 + signal 2.
EXIT_OK = 0
EXIT_FAILED = 1
EXIT_INTERRUPTED = 130


def progress(message: str) -> None:
    """Prints a progress message at once, even when the output is a pipe."""
    print(message, flush=True)


# --- list ---------------------------------------------------------------------------


def cmd_list(args: argparse.Namespace) -> int:
    """Shows every game, or the presets in one game or preset file."""
    if args.game is None:
        print_games()
    else:
        print_pieces(args.game, show_category=args.long)
    return EXIT_OK


def print_games() -> None:
    """Prints a table of the games: how many different pieces, and how many in a full set."""
    games = presets.build_games()
    longest_name = max(len(name) for name in games)
    name_width = max(longest_name, len(GAME_HEADING))

    print(
        GAME_HEADING.ljust(name_width) + COLUMN_GAP + PIECES_HEADING + COLUMN_GAP + FULL_SET_HEADING
    )
    for name, game in games.items():
        different_pieces = str(len(game.presets))
        full_set = str(sum(game.counts.values()))

        line = name.ljust(name_width)
        line += COLUMN_GAP + different_pieces.rjust(len(PIECES_HEADING))
        line += COLUMN_GAP + full_set.rjust(len(FULL_SET_HEADING))
        print(line)


def print_pieces(game: str, show_category: bool) -> None:
    """Prints the presets of one game, with how many a set needs when it is more than one.

    Args:
        game: A game name or the path of a preset file.
        show_category: Also print the Category of each preset.
    """
    preset_file = load_preset_file(find_preset_file(game))

    for name, values in preset_file.presets.items():
        line = name

        count = preset_file.counts[name]
        if count > 1:
            line += f"  x{count}"

        if show_category:
            category = values.get("Category", "no category")
            line += f"  [{category}]"

        print(line)


# --- build --------------------------------------------------------------------------


def cmd_build(args: argparse.Namespace) -> int:
    """Writes the generated preset files again, or reports which are out of date."""
    games = presets.build_games()
    outputs = presets.generated_files(games)

    if args.check:
        return _report_stale_files(outputs)

    # The Customizer saves into koma/koma.json, so stop before erasing its changes.
    if not args.force:
        _stop_for_unsaved_edits()

    presets.write_generated_files(outputs)
    _print_build_summary(games)
    return EXIT_OK


def _report_stale_files(outputs: dict[Path, str]) -> int:
    """Prints the generated files that are out of date.

    Args:
        outputs: A fresh build, from presets.generated_files().

    Returns:
        EXIT_FAILED when a file is out of date, otherwise EXIT_OK.
    """
    stale = presets.stale_files(outputs)
    for path in stale:
        print(f"Out of date: {shown(path)}")

    if stale:
        return EXIT_FAILED
    return EXIT_OK


def _stop_for_unsaved_edits() -> None:
    """Stops the build when koma/koma.json holds changes that the piece files do not.

    Raises:
        KomaError: There are unsaved Customizer edits. They are printed first.
    """
    edits = presets.unsaved_edits()
    if not edits:
        return

    print("koma/koma.json has Customizer edits that are not in the piece files:\n")
    for edit in edits:
        print("  " + edit)
    raise KomaError(
        "Copy the values you want to keep into koma/presets/pieces/, "
        "then rerun (or use --force to discard them)."
    )


def _print_build_summary(games: dict[str, presets.Game]) -> None:
    """Prints what the build wrote: each game, the Customizer file and each test plate."""
    for key, game in games.items():
        full_set = sum(game.counts.values())
        print(
            f"koma/presets/games/{key}.json: {len(game.presets)} presets, "
            f"{full_set} pieces in a full set"
        )

    all_presets = sum(len(game.presets) for game in games.values())
    print(f"{CUSTOMIZER.name}: {all_presets} presets (all games, for the Customizer)")

    for plate in build_test_page():
        print(
            f"koma/presets/print-test/{plate.filename}: {len(plate.presets)} pieces "
            f"in rows of {plate.rows}"
        )


# --- preview ------------------------------------------------------------------------


def cmd_preview(args: argparse.Namespace) -> int:
    """Renders every piece of a game onto one HTML page."""
    preset_file = find_preset_file(args.game)
    names = list(load_preset_file(preset_file).presets)
    default_folder = Path("exports") / "preview" / preset_file.stem
    folder = (args.output or default_folder).resolve()

    progress(f"Rendering {len(names)} pieces from {shown(preset_file)} ...")
    page = preview.write_preview(args.openscad, preset_file, names, folder)
    print("Preview: " + str(page))
    return EXIT_OK


# --- check --------------------------------------------------------------------------


def cmd_check(args: argparse.Namespace) -> int:
    """Reports how much of each piece's lettering would be lost in printing."""
    preset_file = load_preset_file(find_preset_file(args.game))
    names = select_presets(list(preset_file.presets), args.piece)
    measured = measure_presets(args.openscad, preset_file.presets, names, {})

    failed = 0
    for name in names:
        problems = printability_problems(measured[name])
        if problems:
            failed += 1

        face_results = []
        for face, (thin, gaps) in measured[name].items():
            face_results.append(f"{face} thin {thin:.1f}% gaps {gaps:.1f}%")
        details = ", ".join(face_results)
        if not details:
            details = "no characters"

        status = "FAIL" if problems else "ok"
        print(f"{status.ljust(STATUS_WIDTH)} {name}  ({details})")

    print(
        f"{failed} of {len(names)} pieces fail. Limits: {THIN_LIMIT:.1f}% thin strokes, "
        f"{GAP_LIMIT:.1f}% narrow gaps; "
        "see them in OpenSCAD with Output Mode 'Inspect printability'."
    )
    if failed:
        return EXIT_FAILED
    return EXIT_OK


# --- export -------------------------------------------------------------------------


def export_overrides(args: argparse.Namespace) -> dict:
    """Collects the settings that the export options replace in every preset.

    Args:
        args: The parsed export options.

    Returns:
        OpenSCAD parameter -> value.
    """
    overrides: dict = {}
    for option, (parameter, _) in OVERRIDES.items():
        value = getattr(args, option)
        if value is not None:
            overrides[parameter] = value

    # Giving signature text also turns the signature on.
    if args.signature_text is not None:
        overrides["Signature_Enabled"] = True
    if args.orientation:
        overrides["Print_Orientation"] = ORIENTATIONS[args.orientation]
    return overrides


def print_dry_run(
    destination: Path, plan: list[export.PlannedFile], counts: dict[str, int], layouts: bool
) -> None:
    """Prints the files that an export would write.

    Args:
        destination: The export folder.
        plan: The files.
        counts: How many of each preset a full set needs.
        layouts: True when the files are layouts, False for one file per preset.
    """
    print(str(destination) + os.sep)
    for planned in plan:
        if layouts:
            pieces = export.describe_pieces(planned.presets)
            print(f"{DRY_RUN_INDENT}{planned.filename}  ({len(planned.presets)} pieces: {pieces})")
            continue

        copies = counts[planned.presets[0]]
        line = DRY_RUN_INDENT + planned.filename
        if copies > 1:
            line += f"  (print {copies})"
        print(line)


def cmd_export(args: argparse.Namespace) -> int:
    """Exports the chosen presets of one game or preset file as color 3MF files."""
    path = find_preset_file(args.game)
    preset_file = load_preset_file(path)
    selected = select_presets(list(preset_file.presets), args.piece)
    overrides = export_overrides(args)

    set_name = args.name or path.stem.replace("_", " ").replace("-", " ").title()
    default_folder = Path("exports") / path.stem
    destination = (args.output or default_folder).resolve()
    plan = export.plan_files(selected, preset_file.counts, set_name, args.per_file)
    layouts = bool(args.per_file)
    # Read the row plan and positions now, so that even a dry run reports a wrong one.
    rows = _row_plan(args, path, plan)
    positions = _layout_positions(args, path, plan)

    if args.dry_run:
        print_dry_run(destination, plan, preset_file.counts, layouts)
        return EXIT_OK

    if not args.no_print_check:
        _check_lettering(args, plan, preset_file, overrides)

    options = ExportOptions(
        executable=args.openscad,
        jobs=args.jobs,
        force=args.force,
        plain=args.plain,
        rows=rows,
        positions=positions,
    )
    written, skipped = export.export_files(
        plan, preset_file.presets, overrides, destination, options, report=progress
    )
    print(f"Saved {written} new 3MF file(s); skipped {skipped} existing in {destination}")

    # A manifest describes a complete delivery, so a hand-picked subset has none.
    if not args.piece:
        _write_manifest(destination, set_name, preset_file, plan, layouts)
    return EXIT_OK


def _row_plan(
    args: argparse.Namespace, path: Path, plan: list[export.PlannedFile]
) -> list[int] | None:
    """Reads the row plan of the preset file, when it applies to this export.

    A row plan describes the whole file, so it applies only to one layout that
    holds every piece.

    Returns:
        The pieces in each row, or None.
    """
    if not _is_whole_layout(args, plan):
        return None
    return presets.load_layout_rows(path, len(plan[0].presets))


def _layout_positions(
    args: argparse.Namespace, path: Path, plan: list[export.PlannedFile]
) -> list[tuple[float, float]] | None:
    """Reads the fixed positions of the preset file, when they apply to this export.

    Like a row plan, positions describe the whole file, so they apply only to
    one layout that holds every piece.

    Returns:
        The position of each piece, or None.
    """
    if not _is_whole_layout(args, plan):
        return None
    return presets.load_layout_positions(path, len(plan[0].presets))


def _is_whole_layout(args: argparse.Namespace, plan: list[export.PlannedFile]) -> bool:
    """Checks whether the export is one layout file that holds every piece of the file."""
    return bool(args.per_file) and not args.piece and len(plan) == 1


def _check_lettering(
    args: argparse.Namespace,
    plan: list[export.PlannedFile],
    preset_file: presets.PresetFile,
    overrides: dict,
) -> None:
    """Stops the export when the lettering of a planned piece would not print.

    Raises:
        KomaError: A piece is over the printability limits.
    """
    progress("Checking that the lettering will print ...")
    placed = [name for planned in plan for name in planned.presets]
    names = export.unique_in_order(placed)
    export.check_printable(args.openscad, preset_file.presets, names, overrides)


def _write_manifest(
    destination: Path,
    set_name: str,
    preset_file: presets.PresetFile,
    plan: list[export.PlannedFile],
    layouts: bool,
) -> None:
    """Writes manifest.json, and says how to get the full set in one file when that helps."""
    export.write_manifest(
        destination, set_name, preset_file.path, plan, preset_file.counts, layouts
    )
    print("Manifest: " + str(destination / "manifest.json"))

    needs_copies = any(count > 1 for count in preset_file.counts.values())
    if not layouts and needs_copies:
        print(
            "Some pieces are needed more than once; the manifest lists quantities. "
            "Use --per-file all for the complete set in one file."
        )


# --- set ----------------------------------------------------------------------------


def cmd_set(args: argparse.Namespace) -> int:
    """Sets the same values in a chosen group of presets of a hand-kept file."""
    path = args.file.resolve()
    document = read_json(path)
    changes, selected = presets.set_values(
        document, args.assignments, args.all, args.preset, args.category
    )

    for change in changes:
        print(change)

    if args.dry_run:
        print(
            f"Would change {len(changes)} value(s) in {selected} selected preset(s); "
            "nothing written."
        )
    elif changes:
        text = json.dumps(document, ensure_ascii=False, indent=JSON_INDENT) + "\n"
        path.write_text(text, encoding="utf-8")
        print(f"Changed {len(changes)} value(s) in {selected} selected preset(s) of {shown(path)}.")
    else:
        print(f"Nothing to change in {selected} selected preset(s).")
    return EXIT_OK


# --- ban ----------------------------------------------------------------------------


def cmd_ban(args: argparse.Namespace) -> int:
    """Shows the board presets, or exports one board as color 3MF files."""
    preset_file = presets.load_preset_file(args.presets.resolve())
    if args.board is None:
        print_boards(preset_file)
        return EXIT_OK

    name = choose_board(list(preset_file.presets), args.board)
    values = preset_file.presets[name]
    default_folder = Path("exports") / "ban" / export.safe_name(name)
    destination = (args.output or default_folder).resolve()

    if args.dry_run:
        board = ban.read_preset(args.openscad, name, values)
        print(str(destination) + os.sep)
        for planned in ban.plan_files(board):
            print(f"{DRY_RUN_INDENT}{planned.filename}  ({len(planned.panels)} panel(s))")
        return EXIT_OK

    written, skipped = ban.export_board(
        args.openscad,
        preset_file.path,
        name,
        values,
        destination,
        args.force,
        args.plain,
        report=progress,
    )
    print(f"Saved {written} new 3MF file(s); skipped {skipped} existing in {destination}")
    print("Manifest: " + str(destination / "manifest.json"))
    return EXIT_OK


def print_boards(preset_file: presets.PresetFile) -> None:
    """Prints each board preset with its squares and panels.

    Args:
        preset_file: The board preset file.
    """
    for name, values in preset_file.presets.items():
        settings = ban.resolved_settings(values)
        squares = f"{settings['Playing_Columns']} x {settings['Playing_Rows']} squares"
        columns, rows = ban.panel_grid(settings)
        panels = f"{columns} x {rows} panels"
        print(f"{name}  ({squares}, {panels})")


def choose_board(names: list[str], text: str) -> str:
    """Picks one board preset by its exact name, or by a part of the name in any letter case.

    Args:
        names: All preset names, in file order.
        text: The name, or a part of it.

    Returns:
        The preset name.

    Raises:
        KomaError: No preset matches, or more than one does.
    """
    if text in names:
        return text

    matches = []
    for name in names:
        if text.casefold() in name.casefold():
            matches.append(name)

    if not matches:
        raise KomaError(f"No board matches {text!r}. Run 'ban' without a board to see the names.")
    if len(matches) > 1:
        raise KomaError(f"{text!r} matches more than one board: {', '.join(matches)}")
    return matches[0]


# --- Option types -------------------------------------------------------------------


def positive_count(text: str) -> int:
    """Reads a whole number of at least 1, such as --jobs.

    Raises:
        argparse.ArgumentTypeError: The text is not a whole number of at least 1.
    """
    try:
        count = int(text)
    except ValueError:
        raise argparse.ArgumentTypeError("expected a whole number") from None

    if count < 1:
        raise argparse.ArgumentTypeError("must be at least 1")
    return count


def per_file(text: str) -> float:
    """Reads --per-file: a piece count of at least 1, or "all" for one file (math.inf)."""
    if text == "all":
        return math.inf
    return positive_count(text)


def assignment(text: str) -> tuple[str, str]:
    """Reads one NAME=VALUE argument. The value stays text, as the Customizer saves it.

    Raises:
        argparse.ArgumentTypeError: There is no "=".
    """
    key, separator, value = text.partition("=")
    if not separator:
        raise argparse.ArgumentTypeError("use NAME=VALUE, for example Base_Width=30")
    return key.strip(), value


# --- The parser ---------------------------------------------------------------------

MAIN_HELP = """\
A GAME is a game name (see '%(prog)s list') or a path to any preset JSON file.

examples:
  %(prog)s list                           show the games
  %(prog)s export shogi --per-file all    the complete set in one color 3MF
  %(prog)s export shogi pawn              just the pawn
  %(prog)s preview minishogi              check a whole set on one page
  %(prog)s build                          after editing koma/presets/pieces/
  %(prog)s ban "Minishogi - 2 x 2"        a board, one color 3MF per panel

Run '%(prog)s COMMAND --help' for the options of one command.
"""


# Example command lines, shown at the end of each command's --help.
EXAMPLES = {
    "list": """\
  %(prog)s            every game and its size
  %(prog)s shogi      the pieces in shogi, with how many a set needs
  %(prog)s -l koma/presets/misc/taikyoku.json
""",
    "build": """\
  %(prog)s            rebuild koma/presets/games/, koma/koma.json and koma/presets/print-test/
  %(prog)s --check    exit 1 if they are out of date; write nothing
""",
    "preview": """\
  %(prog)s minishogi
  %(prog)s shogi -o /tmp/shogi-preview
""",
    "export": """\
  %(prog)s shogi                        one 3MF per different piece
  %(prog)s shogi --per-file all         the complete 40-piece set in one 3MF
  %(prog)s shogi --per-file 20          the complete set, 20 pieces per 3MF
  %(prog)s shogi pawn king              only the pieces whose names match
  %(prog)s shogi --orientation front-down -o flat
  %(prog)s shogi -n                     show what would be written
  %(prog)s koma/presets/print-test/print-test-plate-1.json --per-file all -j 8

Existing files are skipped, so an interrupted export resumes where it
stopped; use --force to write them again.
""",
    "check": """\
  %(prog)s shogi                       every piece in a game
  %(prog)s koma/presets/misc/chu-shogi-learner.json

Each face is measured at Print_Line_Width: the share of strokes thinner than
one printed line and of gaps narrower than one line. export runs the same
check and stops when a piece fails.
""",
    "ban": """\
  %(prog)s                              the boards in ban/ban.json
  %(prog)s "Shogi - 2 x 2 panels"       one board, as color 3MF files
  %(prog)s "Minishogi - 2 x 2" -n       show what would be written
  %(prog)s "My board" -p my-boards.json

Save the board in the OpenSCAD Customizer first: the export reads saved
presets only. Existing files are skipped; use --force to write them again.
""",
    "set": """\
  %(prog)s my.json Base_Width=30 --category 'grid search'
  %(prog)s my.json Front_Relief_Depth=0.30 Back_Relief_Depth=0.30 --all
  %(prog)s my.json 'Front_Glyph_Width=[1.0, 1.1, 1.0]' --preset 'Grid 05' -n

Names are exact Customizer parameter names with underscores. Quote a value
that contains brackets, commas or spaces. For the bundled games, edit
koma/presets/pieces/ and run build instead.
""",
}


def build_parser() -> argparse.ArgumentParser:
    """Defines every command, its options and its help text.

    Returns:
        The parser. Each command sets args.run to its cmd_* function.
    """
    parser = argparse.ArgumentParser(
        description="Build, preview and export 3D-printable shogi pieces and boards.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=MAIN_HELP,
    )
    parser.add_argument("-V", "--version", action="version", version="KomaSCAD " + VERSION)
    commands = parser.add_subparsers(dest="command", metavar="COMMAND", title="commands")
    _add_list_command(commands)
    _add_build_command(commands)
    _add_preview_command(commands)
    _add_export_command(commands)
    _add_check_command(commands)
    _add_set_command(commands)
    _add_ban_command(commands)
    return parser


def _command(commands, name: str, run, summary: str) -> argparse.ArgumentParser:
    """Adds one command.

    Args:
        commands: The subparsers of the main parser.
        name: The command name, such as "export".
        run: The cmd_* function that runs the command.
        summary: The one-line help, starting in lower case.

    Returns:
        The command's parser, to add its options to.
    """
    parser = commands.add_parser(
        name,
        help=summary,
        description=summary[0].upper() + summary[1:] + ".",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="examples:\n" + EXAMPLES[name],
    )
    parser.set_defaults(run=run)
    return parser


def _add_game_argument(parser: argparse.ArgumentParser) -> None:
    """Adds the GAME argument that most commands take."""
    parser.add_argument("game", metavar="GAME", help="game name or preset JSON file")


def _add_openscad_option(parser: argparse.ArgumentParser) -> None:
    """Adds --openscad, for commands that run OpenSCAD."""
    parser.add_argument(
        "--openscad", default="openscad", metavar="PATH", help="OpenSCAD executable"
    )


def _add_list_command(commands) -> None:
    """Adds the list command and its options."""
    parser = _command(commands, "list", cmd_list, "show the games, or the pieces in one game")
    parser.add_argument("game", nargs="?", metavar="GAME", help="game name or preset JSON file")
    parser.add_argument("-l", "--long", action="store_true", help="also show each piece's category")


def _add_build_command(commands) -> None:
    """Adds the build command and its options."""
    parser = _command(
        commands, "build", cmd_build, "rebuild the game presets and the print test page"
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="exit 1 if any generated file is out of date; write nothing",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="overwrite koma/koma.json even if it holds unsaved Customizer edits",
    )


def _add_preview_command(commands) -> None:
    """Adds the preview command and its options."""
    parser = _command(
        commands, "preview", cmd_preview, "render every piece of a game onto one HTML page"
    )
    _add_game_argument(parser)
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        metavar="DIR",
        help="output folder (default: exports/preview/GAME)",
    )
    _add_openscad_option(parser)


def _add_export_command(commands) -> None:
    """Adds the export command and its options."""
    parser = _command(commands, "export", cmd_export, "write print-ready color 3MF files")
    _add_export_selection(parser)
    _add_export_run_options(parser)
    _add_export_overrides(parser)


def _add_export_selection(parser: argparse.ArgumentParser) -> None:
    """Adds the options that choose what to export, and where."""
    _add_game_argument(parser)
    parser.add_argument(
        "piece",
        nargs="*",
        metavar="PIECE",
        help="export only pieces whose name is, or contains, this text (default: all)",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        metavar="DIR",
        help="folder receiving the 3MF files (default: exports/GAME)",
    )
    parser.add_argument(
        "--per-file",
        type=per_file,
        metavar="N|all",
        help="place this many pieces in each 3MF, or 'all' for one file, with as many "
        "copies of each piece as a complete set needs",
    )
    parser.add_argument(
        "--orientation",
        choices=sorted(ORIENTATIONS),
        help="how the pieces sit on the bed, overriding the presets: upright stands "
        "on the heel; front-down and back-down lie flat on that face",
    )


def _add_export_run_options(parser: argparse.ArgumentParser) -> None:
    """Adds the options that control how the export runs."""
    parser.add_argument(
        "-j",
        "--jobs",
        type=positive_count,
        default=1,
        metavar="N",
        help="render this many different pieces at once; each OpenSCAD run uses one "
        "processor core and can need a gigabyte or more of memory (default: 1)",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="overwrite existing 3MF files instead of skipping them",
    )
    parser.add_argument(
        "--plain",
        action="store_true",
        help="leave out the per-part filament slots that Bambu Studio, OrcaSlicer and "
        "Elegoo Slicer read; only for tools that cannot load them, such as Bambu "
        "Studio's command line",
    )
    parser.add_argument(
        "--no-print-check",
        action="store_true",
        help="export even when lettering is too fine to print (see the check command)",
    )
    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="show the files that would be written, without rendering",
    )
    parser.add_argument("--name", help="set name used in layout filenames and manifest.json")
    _add_openscad_option(parser)


def _add_export_overrides(parser: argparse.ArgumentParser) -> None:
    """Adds the options that change text and colors of every exported piece."""
    overrides = parser.add_argument_group("overrides for the exported pieces")
    for option, (_, description) in OVERRIDES.items():
        overrides.add_argument("--" + option.replace("_", "-"), metavar="TEXT", help=description)


def _add_check_command(commands) -> None:
    """Adds the check command and its options."""
    parser = _command(
        commands, "check", cmd_check, "check that each piece's lettering is coarse enough to print"
    )
    _add_game_argument(parser)
    parser.add_argument(
        "piece",
        nargs="*",
        metavar="PIECE",
        help="check only pieces whose name is, or contains, this text",
    )
    _add_openscad_option(parser)


def _add_set_command(commands) -> None:
    """Adds the set command and its options."""
    parser = _command(
        commands, "set", cmd_set, "change a setting across many presets in a hand-kept file"
    )
    parser.add_argument(
        "file", type=Path, metavar="FILE", help="Customizer preset JSON file to edit"
    )
    parser.add_argument(
        "assignments",
        nargs="+",
        type=assignment,
        metavar="NAME=VALUE",
        help="parameter and its new value",
    )
    parser.add_argument(
        "--preset",
        action="append",
        default=[],
        metavar="TEXT",
        help="select presets whose name contains TEXT; may be repeated",
    )
    parser.add_argument(
        "--category",
        action="append",
        default=[],
        metavar="TEXT",
        help="select presets whose Category contains TEXT; may be repeated",
    )
    parser.add_argument("--all", action="store_true", help="select every preset in the file")
    parser.add_argument(
        "-n", "--dry-run", action="store_true", help="show the changes without writing the file"
    )


def _add_ban_command(commands) -> None:
    """Adds the ban command and its options."""
    parser = _command(
        commands, "ban", cmd_ban, "show the board presets, or export one board as color 3MF files"
    )
    parser.add_argument(
        "board",
        nargs="?",
        metavar="BOARD",
        help="board preset name, or a part of it (default: list the boards)",
    )
    parser.add_argument(
        "-p",
        "--presets",
        type=Path,
        default=BAN_PRESETS,
        metavar="FILE",
        help="board preset file (default: ban/ban.json)",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        metavar="DIR",
        help="folder receiving the 3MF files (default: exports/ban/BOARD)",
    )
    parser.add_argument(
        "-f",
        "--force",
        action="store_true",
        help="overwrite existing 3MF files instead of skipping them",
    )
    parser.add_argument(
        "--plain",
        action="store_true",
        help="leave out the per-part filament slots (see export --plain)",
    )
    parser.add_argument(
        "-n",
        "--dry-run",
        action="store_true",
        help="show the files that would be written; reads the board but renders nothing",
    )
    _add_openscad_option(parser)


def main(argv: list[str] | None = None) -> int:
    """Runs one command.

    Args:
        argv: The command-line arguments, without the program name. None reads sys.argv.

    Returns:
        The exit status: 0 on success, 1 when the command fails, 130 when the
        user presses Ctrl+C. argparse itself exits with 2 for a wrong command line.
    """
    parser = build_parser()
    args = parser.parse_args(argv)
    if not args.command:
        parser.print_help()
        return EXIT_FAILED

    try:
        return args.run(args)
    except (KomaError, OSError) as error:
        print(f"{parser.prog}: error: {error}", file=sys.stderr)
        return EXIT_FAILED
    except KeyboardInterrupt:
        return EXIT_INTERRUPTED

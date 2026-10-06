# Command reference

Everything on the command line goes through one tool, `komascad.py`, in the
repository root. It needs Python 3.8 or later and nothing else from Python;
`preview` and `export` also need the `openscad` command on your PATH.

```bash
python3 komascad.py COMMAND [options]
```

| Command | What it does |
| --- | --- |
| [`list [GAME]`](#list) | Show the games, or the pieces in one game |
| [`export GAME [PIECE ...]`](#export) | Write print-ready color 3MF files |
| [`preview GAME`](#preview) | Render every piece of a game onto one HTML page |
| [`build`](#build) | Rebuild the game presets after editing `presets/pieces/` |
| [`set FILE NAME=VALUE ...`](#set) | Change a setting across many presets in a hand-kept file |

`python3 komascad.py --help` shows this list, and
`python3 komascad.py COMMAND --help` shows one command's options with
examples. The tool works from any directory.

## Conventions

- **`GAME`** is a game name from `list`, such as `shogi` or `minishogi-1char`,
  or a path to any Customizer preset file, such as `shogi_piece.json` or
  `presets/misc/taikyoku.json`.
- **`PIECE`** is an exact preset name or any part of one, in any letter case.
  `pawn` matches `Shogi 09 - Pawn`; `king` matches both kings. Quote text that
  contains spaces.
- **`-o DIR`** chooses the output folder. Relative paths start from the
  directory where you run the command.
- **`-n`** (`--dry-run`) shows what would happen and writes nothing.
- **`-f`** (`--force`) overwrites what the command would otherwise protect.
- Results are printed to standard output and errors to standard error. The
  exit status is 0 on success, 1 when a command fails, and 2 for a mistyped
  command line.

## list

```bash
python3 komascad.py list                # every game and its size
python3 komascad.py list shogi          # the pieces in shogi, with how many a set needs
python3 komascad.py list -l presets/misc/taikyoku.json   # also show each Category
```

## export

```bash
python3 komascad.py export shogi
```

writes one color 3MF per different piece into `exports/shogi/`. Add options
to change what is written:

| I want... | Add |
| --- | --- |
| The complete set in one 3MF (all 40 shogi pieces) | `--per-file all` |
| The complete set split across files, at most 20 pieces each | `--per-file 20` |
| Only some pieces | their names after the game: `export shogi pawn king` |
| A different output folder | `-o DIR` |
| Pieces lying flat on the front face | `--orientation front-down` |
| Pieces lying flat on the back face | `--orientation back-down` |
| Pieces standing on the heel, whatever the preset says | `--orientation upright` |
| To see what would be written, without rendering | `-n` |
| To export again after a change | `-f` (existing files are skipped otherwise) |
| A different name on layout files and in the manifest | `--name "My Shogi"` |

### One file per piece, or complete sets

Without `--per-file`, each different piece is exported once, under its preset
name, and `manifest.json` records how many of it a complete set needs.

With `--per-file`, the tool counts physical pieces: every piece is rendered
once and placed as many times as the set needs, spaced so nothing overlaps.
`--per-file all` puts the whole set in one file; a number splits it into
layout files of at most that many pieces. A full shogi set is about
242 × 95 mm standing upright and about 242 × 228 mm lying flat, so use a
smaller number if that does not fit your bed, or rearrange in the slicer.

The quantities come from a top-level `pieceCounts` object in the preset file.
The bundled game files get theirs from `presets/games.json`; presets a file
does not mention count once.

The files hold geometry and colors only, with no printer, nozzle, filament,
bed or process settings, so choose those normally in your slicer after
importing. Each piece appears under its preset name with its colored parts
listed beneath it.

### Resuming

Completed files are skipped, so cancelling and running the same command again
continues with the remaining work. A piece in progress uses a hidden
`.partial` filename and only becomes a `.3mf` once it is complete. Use `-f`
after changing a design to write the files again.

When a whole game or preset file is exported, `manifest.json` in the output
folder records the files, their sizes and checksums. Exporting only chosen
pieces writes no manifest.

### Print orientation

`--orientation` sets how every exported piece sits on the bed, overriding the
orientation saved in the presets:

| Value | Result |
| --- | --- |
| `upright` | Stands on the broad heel |
| `front-down` | Lies flat with the front face on the bed |
| `back-down` | Lies flat with the back face on the bed |

Raised lettering cannot be on the face that lies on the bed; the export stops
with a message if a preset asks for that. The
[print guide](printing/print-guide.md) explains why we print face down.

### Changing a piece on the way out

Text and colors can be overridden without editing the preset. The options
apply to every piece being exported, so name the one you mean:

```bash
python3 komascad.py export shogi "King (Osho)" --body-color Purple --front-color Silver --signature-text "KomaSCAD"
```

The options are `--front-text`, `--back-text`, `--body-color`,
`--front-color`, `--back-color`, `--signature-text` and
`--signature-color`. Save set-wide changes in the presets instead.

### Your own presets

A preset you saved in the Customizer lives in `shogi_piece.json`. Export it by
naming that file and the preset:

```bash
python3 komascad.py export shogi_piece.json "My piece"
```

Any other Customizer JSON works the same way. `--scad FILE` renders a
different model file, and `--openscad PATH` uses a specific OpenSCAD
executable.

## preview

```bash
python3 komascad.py preview minishogi
```

renders every piece of the game, front and back, at one scale, and writes
`exports/preview/minishogi/index.html`. Open it in a browser and refresh after
each new preview. `-o DIR` chooses another folder.

## build

```bash
python3 komascad.py build
```

turns the piece files in `presets/pieces/` and the recipes in
`presets/games.json` into `presets/games/*.json` and `shogi_piece.json`. Run
it after editing either source. `export` and `preview` refuse to use a game
file that is older than its piece files and ask you to build first.

| Option | Effect |
| --- | --- |
| `--check` | Exit with status 1 if any generated file is out of date; write nothing |
| `-f`, `--force` | Overwrite `shogi_piece.json` even if it holds unsaved Customizer edits |

The build stops if `shogi_piece.json` holds Customizer changes that the piece
files do not, and lists them; see
[tuning by eye](user-guide.md#tuning-by-eye-in-openscad).

## set

```bash
python3 komascad.py set my-presets.json Base_Width=30 --category "grid search"
```

applies the same value to a chosen group of presets in a preset file you keep
by hand, such as those in `presets/misc/`. Give one or more `NAME=VALUE`
pairs and say which presets to change:

| Option | Selects |
| --- | --- |
| `--preset TEXT` | Presets whose name contains TEXT; may be repeated |
| `--category TEXT` | Presets whose Category contains TEXT; may be repeated |
| `--all` | Every preset in the file |

Names are the exact Customizer parameter names with underscores, such as
`Front_Spacing_Scale`. Values are stored as text, as the Customizer saves
them; quote a pair that contains brackets, commas or spaces:

```bash
python3 komascad.py set my-presets.json 'Front_Glyph_Width=[1.0, 1.1, 1.0]' --preset 'Grid 05'
```

Each change is printed as it is made. Add `-n` to see the changes without
writing the file. A parameter that a preset does not already have is treated
as a typo. For the bundled games, change `presets/pieces/` and run `build`
instead: the next build overwrites edits to the generated files.

# Command reference

`komascad.py` is the command-line tool. It needs Python 3.8 or later.
`preview`, `check` and `export` also need the `openscad` command on your PATH.

```bash
python3 komascad.py COMMAND [options]
```

| Command | Use it to |
| --- | --- |
| [`list [GAME]`](#list) | Show the games, or the pieces in one game |
| [`build`](#build) | Make the game presets after you edit `presets/pieces/` |
| [`preview GAME`](#preview) | Show every piece of a game on one HTML page |
| [`check GAME [PIECE ...]`](#check) | Check that the lettering will print |
| [`export GAME [PIECE ...]`](#export) | Write color 3MF files |
| [`set FILE NAME=VALUE ...`](#set) | Change a setting in many presets of a hand-kept file |

`python3 komascad.py COMMAND --help` shows the options of one command.

## Terms

- **GAME** is a game name from `list`, such as `shogi`. It can also be the
  path of a preset file, such as `shogi_piece.json` or
  `presets/misc/taikyoku.json`.
- **PIECE** is a preset name, or part of one, in any letter case. `pawn`
  selects `Shogi 09 - Pawn`. `king` selects both kings. Put quotes around
  text with spaces.
- **`-o DIR`** sets the output folder.
- **`-n`** shows what the command would do. It writes nothing.
- **`-f`** writes files that the command would otherwise keep.
- The exit status is 0 when the command works, 1 when it fails, and 2 for a
  wrong command line.

## list

```bash
python3 komascad.py list                               # all games
python3 komascad.py list shogi                         # the pieces in shogi, and how many
python3 komascad.py list -l presets/misc/taikyoku.json # also show each Category
```

## build

```bash
python3 komascad.py build
```

Makes `presets/games/*.json` and `shogi_piece.json` from `presets/pieces/`
and `presets/games.json`. Run it after you edit these files. It also writes
the [print test page](print-test-page.md) files in `presets/print-test/`.

`preview`, `check` and `export` do not use a game file that is older than
its piece files. They tell you to build first.

| Option | Effect |
| --- | --- |
| `--check` | Show the generated files that are old. Write nothing. Exit with 1 if a file is old. |
| `-f`, `--force` | Write `shogi_piece.json` even if it has Customizer changes |

The build stops if `shogi_piece.json` has Customizer changes that are not in
the piece files. It shows each change. See
[tune a piece by eye](user-guide.md#tune-a-piece-by-eye-in-openscad).

## preview

```bash
python3 komascad.py preview minishogi
```

Renders the front and back of every piece at one scale. It writes
`exports/preview/minishogi/index.html`. Open it in a browser. `-o DIR` sets
another folder.

## check

```bash
python3 komascad.py check shogi
python3 komascad.py check presets/misc/chu-shogi-learner.json
```

Measures the lettering of each face at **Print Line Width**. It shows the
share of strokes thinner than one printed line, and of gaps narrower than one
line. A piece above 2.5% or 5% shows FAIL, and the exit status is 1. See
[lettering printability](parameters.md#lettering-printability).

## export

```bash
python3 komascad.py export shogi
```

Writes one color 3MF for each different piece into `exports/shogi/`. Add
options to change this:

| To get | Add |
| --- | --- |
| The full set in one 3MF | `--per-file all` |
| The full set in files of at most 20 pieces | `--per-file 20` |
| Some pieces only | Their names: `export shogi pawn king` |
| Another output folder | `-o DIR` |
| Pieces flat on the front face | `--orientation front-down` |
| Pieces flat on the back face | `--orientation back-down` |
| Pieces standing on the heel | `--orientation upright` |
| Several pieces rendered at the same time | `-j N` |
| A list of the files, without rendering | `-n` |
| New files after a change | `-f` |
| Lettering that the check stops | `--no-print-check` |
| Files without filament slots | `--plain` |
| Another name on layout files | `--name "My Shogi"` |

Before it renders, `export` runs the same test as `check`. It stops if a piece
fails.

### One file for each piece, or full sets

Without `--per-file`, the tool exports each different piece one time.
`manifest.json` in the output folder gives how many of each a set needs.

With `--per-file`, the tool renders each piece one time and places it as many
times as the set needs. `--per-file all` puts the full set in one file. A
number puts at most that many pieces in each file. A full shogi set is about
242 × 95 mm upright, and 242 × 228 mm flat. If that is too large for your
bed, use a smaller number.

The counts come from `pieceCounts` in the preset file. A preset that is not
in `pieceCounts` counts once.

A preset file can also have `layoutRows`: the number of pieces in each row,
from the back of the bed. Each row is then only as deep as its own pieces.
The numbers must add up to all the pieces in the file. The tool uses
`layoutRows` only when one file holds all the pieces. The print test page
uses it:

```json
"layoutRows": [5, 5, 10, 11]
```

### Print orientation

`--orientation` sets the orientation of all pieces. Without it, each piece
uses its saved **Print Orientation**. The bundled sets stand upright. The
[print guide](printing/print-guide.md) tells you why we print face down.
Raised text cannot be on the face that touches the bed: the export stops.

### Render faster

`-j N` renders N different pieces at the same time. Each OpenSCAD run uses
one processor core and can use 1 GB of memory or more. Select N for your
computer:

```bash
python3 komascad.py export shogi --per-file all -j 4
```

### Stop and continue

The tool does not write a file that exists. Stop an export, then run the same
command again: it continues with the remaining files. A file is complete when
it has its `.3mf` name. Use `-f` after a change, to write the files again.

When you export a full game or preset file, `manifest.json` lists the files,
their sizes and their checksums.

### Filament slots

Each 3MF holds the standard 3MF colors. It also holds the filament slot of
each part, for Bambu Studio, OrcaSlicer and Elegoo Slicer. See
[the print guide](printing/print-guide.md#import-a-color-3mf). Use `--plain`
to leave the slots out, for a tool that cannot read them. Bambu Studio's
command line is one such tool.

### Change text or colors on export

Change the text and colors of the exported pieces without a change to the
preset:

```bash
python3 komascad.py export shogi "King (Osho)" --body-color Purple --front-color Silver --signature-text "KomaSCAD"
```

The options are `--front-text`, `--back-text`, `--body-color`,
`--front-color`, `--back-color`, `--signature-text` and `--signature-color`.
They change every exported piece, so name the piece. `--signature-text` also
turns the signature on.

### Your own presets

The Customizer saves your presets in `shogi_piece.json`. Export one by name:

```bash
python3 komascad.py export shogi_piece.json "My piece"
```

Any Customizer preset file works the same way. `--openscad PATH` uses a
specific OpenSCAD program.

## set

```bash
python3 komascad.py set my-presets.json Base_Width=30 --category "grid search"
```

Sets the same value in a group of presets in a file that you keep by hand,
such as a file in `presets/misc/`. Give one or more `NAME=VALUE` pairs. Then
select the presets:

| Option | Selects |
| --- | --- |
| `--preset TEXT` | Presets with TEXT in their name. You can use it more than once. |
| `--category TEXT` | Presets with TEXT in their Category. You can use it more than once. |
| `--all` | All presets in the file |

Use the exact parameter names. Put quotes around a pair with brackets, commas
or spaces:

```bash
python3 komascad.py set my-presets.json 'Front_Glyph_Width=[1.0, 1.1, 1.0]' --preset 'Grid 05'
```

The command shows each change. Add `-n` to see the changes without a change to
the file. A parameter that a preset does not have stops the command: it is
usually a spelling mistake.

Do not use `set` on the generated game files. The next build overwrites
them. Edit `presets/pieces/` instead.

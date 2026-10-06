# User guide: making a game set

This guide covers the everyday job: change a piece, see the whole set, and
export it for printing, all with one tool: `komascad.py`.

The commands below are written for the repository root. The
[command reference](cli.md) lists every option.

## The idea in one minute

Each piece is described once. Games are lists of pieces. A build step turns
those into the preset files that OpenSCAD and the exporter use.

```
presets/pieces/         you edit these (one file per piece)
presets/games.json      you edit this (which pieces, and how many, are in each game)
            |
            |  python3 komascad.py build
            v
presets/games/*.json    generated: one preset file per game
shogi_piece.json        generated: every game, shown in the Customizer
```

Two rules follow from this:

- **Edit the piece files, not the generated files.** Anything you change in
  `presets/games/` or `shogi_piece.json` is overwritten by the next build.
- **A piece is shared.** Change the pawn once and every game that contains a
  pawn gets the change.

## Before you start

- OpenSCAD 2021.01, with the `openscad` command on your PATH.
- Python 3.8 or later. No extra packages are needed.
- The Yuji Syuku font installed (it is bundled in [fonts/](../fonts/suggested_fonts.md)).
  Restart OpenSCAD after installing a font.

## The games

| Game name | Front | Back | Different pieces | Pieces in a full set |
| --- | --- | --- | --- | --- |
| `minishogi` | two characters | one character | 7 | 12 |
| `minishogi-1char` | one character | one character | 7 | 12 |
| `shogi` | two characters | one character | 9 | 40 |
| `shogi-1char` | one character | one character | 9 | 40 |

The game name is what you type in commands, and it is also the filename in
`presets/games/`. `python3 komascad.py list` prints this table, and
`python3 komascad.py list shogi` prints the pieces in one game.

## The everyday loop

1. **Edit** a file in `presets/pieces/`.
2. **Build:**
   ```bash
   python3 komascad.py build
   ```
3. **Preview** the whole game on one page:
   ```bash
   python3 komascad.py preview minishogi
   ```
   Open `exports/preview/minishogi/index.html` in a browser. Refresh the page
   after each new preview.
4. **Export** when it looks right:
   ```bash
   python3 komascad.py export minishogi --per-file all
   ```
   This writes one color 3MF into `exports/minishogi/` holding the complete
   set: every piece, in the quantity the game needs.

## Where a setting lives

Decide how far the change should reach, then edit the matching place.

| I want to change... | Edit this |
| --- | --- |
| Something on every piece in every game (font, colors, engraving depth) | `common` in `_defaults.json` |
| The layout of every two-character front | `front` → `two` in `_defaults.json` |
| The layout of every one-character front | `front` → `one` in `_defaults.json` |
| The layout of every one-character back | `back` → `one` in `_defaults.json` |
| The size of one piece, in every game | `body` in that piece's file |
| One piece's lettering in one style only | `front` → `two`, `front` → `one` or `back` → `one` in that piece's file |

When the same setting appears in more than one place, the more specific one
wins: a piece file beats `_defaults.json`.

Setting names are the exact Customizer names with underscores, such as
`Front_Font_Size`. Values are always written in quotes, including numbers:
`"28"`, `"[1, 0, 0]"`, `"true"`. The [parameter reference](parameters.md)
explains what each setting does.

## Worked examples

### Make the pawn longer

In `presets/pieces/pawn.json`:

```json
"body": {
    "Piece_Length": "29",
```

Build. The pawn is now 29 mm in all four games.

### Make every promoted side red

In `presets/pieces/_defaults.json`, inside `common`:

```json
"Back_Filament": "Red",
```

Build. Pieces with a blank back (kings and golds) are unaffected.

### Give one piece a different color from the rest

Put the setting in that piece's own block. In `pawn.json`:

```json
"back": {
    "one": {
        "Back_Characters": "と",
        "Back_Filament": "Black",
```

### Nudge one character

Per-character settings are lists of three values: first, second and third
character, counted from the point down. A one-character face uses the first.
To move the rook's one-character front 0.5 mm further toward the point, in
`rook.json`:

```json
"front": {
    "one": {
        "Front_Characters": "飛",
        "Front_Glyph_Y": "[1.5, 0, 0]",
```

## Tuning by eye in OpenSCAD

Typing numbers and rebuilding is slow for fine adjustments. To tune live:

1. Open `shogi_piece.scad` and pick the preset in the Customizer, for example
   `Minishogi 07 - Pawn`. If OpenSCAD was already open, close and reopen the
   file so the preset list reloads.
2. Adjust the controls until it looks right, then save the preset.
3. Run the build. It **stops** and lists exactly what you changed:
   ```
   Minishogi 07 - Pawn: Front_Font_Size = 9.2 (built value: 8.94)
   ```
4. Copy those values into the piece file.
5. Run `python3 komascad.py build --force` to finish.

Step 3 is a safety net: the Customizer saves into `shogi_piece.json`, which
the build regenerates, so the build refuses to erase changes that exist
nowhere else. `--force` tells it you have copied what you want to keep.

## Adding a game

Add an entry to `presets/games.json`:

```json
"shogi-pawns-only": {
    "title": "Pawn test",
    "front": "two",
    "back": "one",
    "pieces": { "pawn": 18, "gold": 2 }
}
```

- The key (`shogi-pawns-only`) becomes the filename and the game name.
- `title` starts every preset name, so it must differ from other games.
- `front` and `back` pick the lettering style: `two` or `one`.
- `pieces` lists piece filenames without `.json`, in the order you want, each
  with how many a complete set needs (both players together).

Build, and `presets/games/shogi-pawns-only.json` appears.

## Adding a piece

Copy an existing piece file of a similar size, rename it, and change the
`name`, `category`, `body` and characters. Then add its filename and count to
the games that should include it and build. Leave out the whole `back` block for a piece
with a blank reverse.

## Exporting

Start from this command, which writes into `exports/shogi/`, and add options:

```bash
python3 komascad.py export shogi
```

| I want... | Add |
| --- | --- |
| The complete set in one 3MF (all 40 shogi pieces) | `--per-file all` |
| The complete set split across files, at most 20 pieces each | `--per-file 20` |
| One 3MF per different piece, to duplicate in the slicer | nothing |
| Pieces lying flat on the front (black) face | `--orientation front-down` |
| Pieces lying flat on the back face | `--orientation back-down` |
| Pieces standing on the heel, whatever the preset says | `--orientation upright` |
| Just one piece | its name after the game: `export shogi pawn` |
| A different output folder (default: `exports/shogi`) | `-o DIR` |
| To see what would be written, without rendering | `-n` |
| To re-export after a change | `-f` (existing files are skipped otherwise) |
| A different name on the layout files | `--name "My Shogi"` |

How many of each piece go into a set comes from the counts in
`presets/games.json`, so a new variant needs no changes to the exporter. A
full shogi set is about 242 × 95 mm as laid out; use a smaller
`--per-file` if that does not fit your bed, or rearrange in the slicer.
Without `--per-file`, each file holds one piece and `manifest.json` lists
the quantity to print.

Without `--orientation`, pieces use the orientation saved in the preset, which
is upright for the bundled games. Lying flat takes more bed: a full shogi set
is about 242 × 228 mm, so split it with `--per-file 20` on a smaller bed.
In the slicer, each piece appears under its preset name; its colored parts
are listed beneath it.

Colors in the 3MF are logical names. Match them to your loaded spools in the
slicer. More detail is in the [command reference](cli.md#export) and the
[color quickstart](color-quickstart.md).

## When something goes wrong

| What you see | What to do |
| --- | --- |
| The set has the wrong number of a piece | Fix the count in `presets/games.json`, build, and export with `-f`. |
| A command says a game file "is older than the piece files" | Run `python3 komascad.py build`. |
| The build stops with "has Customizer edits" | Copy the listed values into the piece files, then build with `--force`. See [Tuning by eye](#tuning-by-eye-in-openscad). |
| "uses unknown parameter(s)" | A setting name is misspelled. Names are case-sensitive and use underscores. |
| "has no front style" or "has no back style" | The game asks for a style that piece file does not define. Add the block or change the game. |
| "Invalid JSON" | Usually a missing or extra comma, or a missing quote, on the line named in the message. |
| My change did not show up | Run the build, then reopen the SCAD file or refresh the preview page. |
| My change disappeared | It was made in a generated file. Make it in the piece file instead. |
| Characters show as boxes or are missing | The font is not installed, or lacks that character. Install it and restart OpenSCAD. |

## Commands at a glance

| Command | What it does |
| --- | --- |
| `komascad.py list [GAME]` | Shows the games, or the pieces in one game. |
| `komascad.py build` | Rebuilds the game preset files from the piece files. `--check` reports stale files without writing; `--force` discards unsaved Customizer edits. |
| `komascad.py preview GAME` | Renders every piece of a game, front and back, onto one page. |
| `komascad.py export GAME [PIECE ...]` | Exports color 3MF files for a whole game or chosen pieces. |
| `komascad.py set FILE NAME=VALUE ...` | Bulk-edits a hand-maintained preset file, such as those in `presets/misc/`. For game presets, change `_defaults.json` instead. |

`presets/misc/` holds older studies and the separately licensed Taikyoku set.
Those files are maintained by hand and are not touched by the build.

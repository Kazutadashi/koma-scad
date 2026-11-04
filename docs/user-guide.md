# User guide: game sets

This guide shows how to export and print a bundled set, and how to change a
set: its font, sizes, colors or pieces. You need the tools from the
[install guide](install.md). Run all commands in a
[terminal in the KomaSCAD folder](install.md#open-a-terminal-in-the-komascad-folder)
(on Windows, type `py` instead of `python3`). The
[command reference](cli.md) gives every option.

To print a set without changing it, download a
[ready-made set](ready-sets.md). You only need a slicer for that.

## The games

For new players, use `shogi-learner`. Each Learner piece shows a small
diagram of its moves, and its back shows the moves after promotion. The
[ready-made sets page](ready-sets.md#choose-a-set) describes the Learner,
Classic and One character styles and the two fonts.

| Game | Style | Font | Different pieces | Pieces in a set |
| --- | --- | --- | --- | --- |
| `shogi` | Classic | Yuji Syuku | 9 | 40 |
| `shogi-1char` | One character | Yuji Syuku | 9 | 40 |
| `shogi-wenkai` | Classic | LXGW WenKai Mono | 9 | 40 |
| `shogi-1char-wenkai` | One character | LXGW WenKai Mono | 9 | 40 |
| `shogi-learner` | Learner | LXGW WenKai Mono | 9 | 40 |
| `shogi-learner-syuku` | Learner | Yuji Syuku | 9 | 40 |
| `minishogi` | Classic | Yuji Syuku | 7 | 12 |
| `minishogi-1char` | One character | Yuji Syuku | 7 | 12 |
| `minishogi-learner` | Learner | LXGW WenKai Mono | 7 | 12 |

A learner piece shows a diagram of its moves under the character. The back
shows the moves after promotion. See [movement diagrams](move-diagrams.md).

`python3 komascad.py list` lists the games. `python3 komascad.py list shogi`
shows the pieces in one game.

## Print a set

1. Check the pieces on one page. Open the HTML file that the command shows
   in your browser.

   ```bash
   python3 komascad.py preview shogi-learner
   ```

2. See what the export will write, without rendering anything:

   ```bash
   python3 komascad.py export shogi-learner --per-file all -n
   ```

   It lists one file, `Shogi Learner - Layout 01.3mf`, with all 40 pieces,
   and says how they will lie: `Front face down`. If the file already
   exists, it says it will skip it.

3. Export the full set as one color 3MF:

   ```bash
   python3 komascad.py export shogi-learner --per-file all
   ```

   The tool checks the lettering, then renders each of the 9 different
   pieces once and places all 40 copies. It prints its progress, and ends
   with `Saved 1 new 3MF file(s)`. Rendering takes a while; `-j 4` renders
   four pieces at the same time on a computer with enough memory (see
   [render faster](cli.md#render-faster)).

4. Open `exports/shogi-learner/Shogi Learner - Layout 01.3mf` in your
   slicer, and follow [print your first set](print/first-print.md).

`manifest.json`, next to the 3MF, lists the pieces in it and how many of
each.

## Change a set

1. Edit a file in `koma/presets/pieces/`.
2. Build the presets:

   ```bash
   python3 komascad.py build
   ```

3. Make a preview of the full set:

   ```bash
   python3 komascad.py preview shogi
   ```

4. Open `exports/preview/shogi/index.html` in a browser. Refresh the page
   after each new preview.
5. Check that the lettering will print:

   ```bash
   python3 komascad.py check shogi
   ```

6. Export the set:

   ```bash
   python3 komascad.py export shogi --per-file all -f
   ```

## How the sets are made

Each piece is in one file. A game is a list of pieces. The `build` command
makes the preset files from these sources:

```
koma/presets/pieces/*.json   you edit these: one file for each piece
koma/presets/games.json      you edit this: the pieces, and how many, in each game
        |
        |  python3 komascad.py build
        v
koma/presets/games/*.json    generated: one preset file for each game
koma/koma.json               generated: all games, for the OpenSCAD Customizer
```

Two rules follow:

- Edit the source files only. The next build overwrites the generated
  files.
- A piece is shared. A change to the pawn file changes the pawn in every
  game.

## Where a setting goes

Decide which pieces the change is for. Then edit that place.

| To change | Edit |
| --- | --- |
| All pieces in all games (font, colors, depth) | `common` in `_defaults.json` |
| All two-character fronts | `front` → `two` in `_defaults.json` |
| All one-character fronts | `front` → `one` in `_defaults.json` |
| All learner fronts | `front` → `learner` in `_defaults.json` |
| All backs | `back` → `one` or `learner` in `_defaults.json` |
| The size of one piece, in all games | `body` in the piece file |
| One piece, in one style | `front` → style, or `back` → style, in the piece file |

The more specific place wins: a piece file wins over `_defaults.json`.

Use the exact parameter names, with underscores: `Front_Font_Size`. Put every
value in quotes, also numbers: `"28"`, `"[1, 0, 0]"`, `"true"`. The
[parameter reference](parameters.md) tells you what each setting does. The
file format is in [koma/presets/README.md](../koma/presets/README.md).

## Examples

### Make the pawn longer

In `koma/presets/pieces/pawn.json`, change:

```json
"body": {
    "Piece_Length": "29",
```

Build. The pawn is now 29 mm long in all games.

### Make all promoted sides red

In `koma/presets/pieces/_defaults.json`, in `common`, set:

```json
"Back_Filament": "Red",
```

Build. Kings and golds do not change, because their back is blank.

### Move one character

A per-character setting has three values: the first, second and third
character, from the point. To move the rook's one-character front 0.5 mm
toward the point, edit `rook.json`:

```json
"front": {
    "one": {
        "Front_Characters": "飛",
        "Front_Glyph_Y": "[1.5, 0, 0]",
```

## Tune a piece by eye in OpenSCAD

1. Open `koma/koma.scad`. Select the preset, for example
   **Minishogi 07 - Pawn**. If OpenSCAD was open before the build, open the
   file again to load the new presets.
2. Change the settings until the piece looks correct.
3. Save the preset.
4. Run the build. It stops and shows each change that you made, for example:

   ```
   Minishogi 07 - Pawn: Front_Font_Size = 9.2 (built value: 8.94)
   ```

5. Copy the values into the piece file.
6. Run `python3 komascad.py build --force`.

The Customizer saves into `koma/koma.json`, and the build writes that file
again. So the build stops before it deletes changes that are not in the
piece files. `--force` tells it that you copied what you want to keep.

## Add a game

Add an entry to `koma/presets/games.json`:

```json
"shogi-pawns-only": {
    "title": "Pawn test",
    "front": "two",
    "back": "one",
    "pieces": { "pawn": 18, "gold": 2 }
}
```

- The key (`shogi-pawns-only`) is the game name and the file name.
- `title` starts every preset name. It must be different from other games.
- `front` and `back` select the style: `two`, `one` or `learner`.
- `pieces` gives the piece files, without `.json`, and how many of each a set
  needs (for both players).

Build. `koma/presets/games/shogi-pawns-only.json` is made.

## Add a piece

1. Copy a piece file of a similar size.
2. Change `name`, `category`, `body` and the characters. For a piece with a
   blank back, remove the `back` block.
3. Add the file name and the count to the games in `koma/presets/games.json`.
4. Build.

## Troubleshooting

| Problem | Do this |
| --- | --- |
| A set has the wrong number of a piece | Correct the count in `koma/presets/games.json`. Build. Export with `-f`. |
| "is older than the piece files" | Run `python3 komascad.py build`. |
| The build stops with "has Customizer edits" | Copy the values into the piece files. Then build with `--force`. |
| "uses unknown parameter(s)" | Correct the spelling of the setting name. Names are case-sensitive. |
| "has no front style" or "has no back style" | Add the style block to the piece file, or change the game. |
| "Invalid JSON" | Look for a missing or extra comma or quote on the line in the message. |
| My change does not show | Build. Then open the SCAD file again, or refresh the preview page. |
| My change went away | You edited a generated file. Make the change in the piece file. |
| The characters show as boxes | [Install the font](install.md#4-install-the-fonts). Then restart OpenSCAD. |
| `check` says FAIL | See [lettering printability](parameters.md#lettering-printability). |

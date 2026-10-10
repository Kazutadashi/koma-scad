# User guide: game sets

This guide tells you how to change a bundled set, see the full set, and
export it. Run all commands from the repository folder. The
[command reference](cli.md) gives every option.

## How the sets are made

Each piece is in one file. A game is a list of pieces. The `build` command
makes the preset files from these sources:

```
presets/pieces/*.json     you edit these: one file for each piece
presets/games.json        you edit this: the pieces, and how many, in each game
        |
        |  python3 komascad.py build
        v
presets/games/*.json      generated: one preset file for each game
shogi_piece.json          generated: all games, for the OpenSCAD Customizer
```

Two rules follow:

- **Edit the source files only.** The next build overwrites the generated
  files.
- **A piece is shared.** A change to the pawn file changes the pawn in every
  game.

## The games

| Game | Front | Back | Different pieces | Pieces in a set |
| --- | --- | --- | --- | --- |
| `shogi` | two characters | one character | 9 | 40 |
| `shogi-1char` | one character | one character | 9 | 40 |
| `shogi-learner` | one character and its moves | one character and its moves | 9 | 40 |
| `minishogi` | two characters | one character | 7 | 12 |
| `minishogi-1char` | one character | one character | 7 | 12 |
| `minishogi-learner` | one character and its moves | one character and its moves | 7 | 12 |

A learner piece shows a diagram of its moves under the character. The back
shows the moves after promotion. See [movement diagrams](move-diagrams.md).

`python3 komascad.py list` shows this table. `python3 komascad.py list shogi`
shows the pieces in one game.

## Change a set

1. Edit a file in `presets/pieces/`.
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
file format is in [presets/README.md](../presets/README.md).

## Examples

### Make the pawn longer

In `presets/pieces/pawn.json`, change:

```json
"body": {
    "Piece_Length": "29",
```

Build. The pawn is now 29 mm long in all games.

### Make all promoted sides red

In `presets/pieces/_defaults.json`, in `common`, set:

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

1. Open `shogi_piece.scad`. Select the preset, for example
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

The Customizer saves into `shogi_piece.json`, and the build writes that file
again. Thus the build stops before it deletes changes that are not in the
piece files. `--force` tells it that you copied what you want to keep.

## Add a game

Add an entry to `presets/games.json`:

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

Build. `presets/games/shogi-pawns-only.json` is made.

## Add a piece

1. Copy a piece file of a similar size.
2. Change `name`, `category`, `body` and the characters. For a piece with a
   blank back, remove the `back` block.
3. Add the file name and the count to the games in `presets/games.json`.
4. Build.

## Troubleshooting

| Problem | Do this |
| --- | --- |
| A set has the wrong number of a piece | Correct the count in `presets/games.json`. Build. Export with `-f`. |
| "is older than the piece files" | Run `python3 komascad.py build`. |
| The build stops with "has Customizer edits" | Copy the values into the piece files. Then build with `--force`. |
| "uses unknown parameter(s)" | Correct the spelling of the setting name. Names are case-sensitive. |
| "has no front style" or "has no back style" | Add the style block to the piece file, or change the game. |
| "Invalid JSON" | Look for a missing or extra comma or quote on the line in the message. |
| My change does not show | Build. Then open the SCAD file again, or refresh the preview page. |
| My change went away | You edited a generated file. Make the change in the piece file. |
| The characters show as boxes | Install the font. Then restart OpenSCAD. |
| `check` says FAIL | See [lettering printability](parameters.md#lettering-printability). |

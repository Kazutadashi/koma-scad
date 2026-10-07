# Presets

New here? The [user guide](../docs/user-guide.md) walks through the whole workflow.
This page is the file-format reference.

| Path | What it is | Edit it? |
| --- | --- | --- |
| `pieces/` | Master list: one file per piece, plus `_defaults.json` | Yes |
| `games.json` | Which pieces, how many, and which character styles make up each game | Yes |
| `games/` | One complete Customizer file per game | No, generated |
| `../shogi_piece.json` | Every game in one file, so the Customizer lists them all | No, generated |
| `print-test/` | The [print test page](../docs/print-test-page.md): a fixed reference print | No, generated |
| `misc/` | Older studies and the separately licensed Taikyoku set | Independent files |

After editing a piece or `games.json`, rebuild:

```bash
python3 komascad.py build
```

## Pieces

A piece file holds its body and one block per face style. Parameter names are
the exact Customizer names; values are strings, as the Customizer saves them.

```json
{
    "name": "Pawn",
    "category": "Pawn",
    "body":  { "Piece_Length": "28", "Base_Width": "24.5" },
    "front": {
        "two": { "Front_Characters": "歩兵", "Front_Font_Size": "8.94" },
        "one": { "Front_Characters": "歩", "Front_Font_Size": "13.4" }
    },
    "back": {
        "one": { "Back_Characters": "と", "Back_Font_Size": "13.4" }
    }
}
```

Leave out `back` for a piece with a blank reverse. Any parameter may go in any
block, so a body tweak applies to every game and a `front.one` tweak applies
only to games that use one-character fronts.

`_defaults.json` holds what pieces share: `common` for everything (font,
colors, engraving), and `front` / `back` for the layout of each style. Each
preset is layered, later entries winning:

    common -> front style defaults -> back style defaults
    -> piece body -> piece front style -> piece back style

## Games

```json
"shogi-1char": {
    "title": "Shogi 1-char",
    "front": "one",
    "back": "one",
    "pieces": { "king-osho": 1, "king-gyokusho": 1, "rook": 2, "pawn": 18 }
}
```

The key is the output filename in `games/`, `title` prefixes the preset names,
`front` and `back` pick the face style, and `pieces` maps piece filenames, in
order, to how many a complete set needs. To add a game, add an entry and
rebuild.

The counts are written into each game file as a top-level `pieceCounts`
object. OpenSCAD ignores it; the exporter's `--per-file` uses it to place
the right number of every piece.

## Tuning in the Customizer

The Customizer saves into `shogi_piece.json`, which the build regenerates. If
that file holds changes the piece files do not, the build stops and lists each
changed parameter. Copy the ones you want into the piece file and rebuild;
`--force` discards them instead.

# Preset files

The [user guide](../docs/user-guide.md) tells you how to use these files. This
page gives their format.

| Path | Contents | Edit? |
| --- | --- | --- |
| `pieces/` | One file for each piece, and `_defaults.json` | Yes |
| `games.json` | The pieces, and how many, in each game | Yes |
| `games/` | One preset file for each game | No: `build` makes it |
| `../shogi_piece.json` | All games in one file, for the Customizer | No: `build` makes it |
| `print-test/` | The [print test page](../docs/print-test-page.md) | No: `build` makes it |
| `misc/` | Chu shogi learner pieces, and the Taikyoku set (CC BY-SA 4.0) | Yes, by hand |

After you edit a piece or `games.json`, run `python3 komascad.py build`.

## Piece file

```json
{
    "name": "Pawn",
    "category": "Pawn",
    "body":  { "Piece_Length": "28", "Base_Width": "24.5" },
    "front": {
        "two": { "Front_Characters": "歩兵", "Front_Font_Size": "8.94" },
        "one": { "Front_Characters": "歩", "Front_Font_Size": "13.4" },
        "learner": { "Front_Characters": "歩", "Front_Moves": "o/@" }
    },
    "back": {
        "one": { "Back_Characters": "と", "Back_Font_Size": "13.4" },
        "learner": { "Back_Characters": "と", "Back_Moves": "ooo/o@o/.o." }
    }
}
```

- The keys in each block are the exact OpenSCAD parameter names.
- The values are text, as the Customizer saves them.
- For a piece with a blank back, leave out `back`.

## _defaults.json

`common` holds the settings of all pieces. `front` and `back` hold the
settings of each style. The build puts the settings together in this order.
A later layer wins:

    common -> front style -> back style -> piece body -> piece front style -> piece back style

## games.json

```json
"shogi-1char": {
    "title": "Shogi 1-char",
    "front": "one",
    "back": "one",
    "pieces": { "king-osho": 1, "king-gyokusho": 1, "rook": 2, "pawn": 18 }
}
```

- The key is the game name and the file name in `games/`.
- `title` starts each preset name.
- `front` and `back` select the style in each piece file.
- `pieces` gives the piece files, in order, and how many a set needs.

The build writes the counts into each game file as `pieceCounts`. OpenSCAD
ignores it. `export --per-file` uses it to place the correct number of each
piece.

## Customizer preset files

A preset file is a normal OpenSCAD Customizer file. You can export any of
them with `komascad.py`. Two extra keys are optional:

- `pieceCounts`: how many of each preset a set needs. A preset that is not in
  the list counts once.
- `layoutRows`: the number of pieces in each row of a layout, from the back of
  the bed. See [the command reference](../docs/cli.md#one-file-for-each-piece-or-full-sets).

# Exporting preset files

`komascad_export.py` uses one simple rule: point `--preset-file` at a
Customizer JSON file. Add `--piece` to export one exact named preset; omit it
to export every preset in that file.

## Export one piece

First discover the exact saved name:

```bash
python3 scripts/komascad_export.py --preset-file shogi_piece.json --list
```

Then export that one piece into a directory. The output filename is the preset
name plus `.3mf`:

```bash
python3 scripts/komascad_export.py --preset-file shogi_piece.json --piece "King - Professional Grid 02 - Yuji Syuku - Narrow - Thin - Deep" --out exports
```

## Export a whole preset file

Omit `--piece` to export every saved preset:

```bash
python3 scripts/komascad_export.py --preset-file presets/misc/taikyoku.json --set-name "Taikyoku Shogi" --out exports
```

`--set-name` is only the human-readable name recorded in `manifest.json`; it
does not create another folder.

## Preview and resume

Preview output paths without starting OpenSCAD:

```bash
python3 scripts/komascad_export.py --preset-file shogi_piece.json --out exports --dry-run
```

`--out` is always the actual directory containing the 3MF files. Completed
same-named files are skipped by default, so cancelling and running the command
again resumes the remaining work. Use `--replace` only when you want to
overwrite existing matching files:

```bash
python3 scripts/komascad_export.py --preset-file shogi_piece.json --out exports --replace
```

Completed pieces are written immediately. A piece in progress uses a hidden
`.partial` filename and only becomes a `.3mf` after its export completes.

## Import several presets at once

Use `--layout-size` to make portable layout files instead of one file per
preset. Each layout contains that many separately selectable presets, already
spaced so they do not overlap. It stores geometry and colours only—no printer,
nozzle, filament, bed, or process preset—so select or change those normally in
Bambu Studio after importing:

```bash
python3 scripts/komascad_export.py --preset-file shogi_piece.json --out grid_search --layout-size 8
```

For a 64-preset grid search, this creates eight layout 3MFs, each containing
eight placed pieces. Importing one layout requires one import action rather
than eight separate 3MF imports. Use a smaller value for a smaller bed.

## Print orientation

`--orientation` sets how every exported piece sits on the bed, overriding the
orientation saved in the presets:

| Value | Result |
| --- | --- |
| `upright` | Stands on the broad heel |
| `front-down` | Lies flat with the front face on the bed |
| `back-down` | Lies flat with the back face on the bed |

```bash
python3 scripts/komascad_export.py --preset-file presets/games/shogi.json --out exports/shogi-flat --layout-size all --orientation front-down
```

Raised lettering cannot be on the face that lies on the bed; the export stops
with a message if a preset asks for that.

## Complete sets

A preset file can say how many of each piece a full set needs, in a top-level
`pieceCounts` object next to `parameterSets`:

```json
"pieceCounts": { "Shogi 09 - Pawn": 18, "Shogi 05 - Gold": 4 }
```

Presets it does not mention count once. `--layout-size` then counts physical
pieces: each preset is rendered once and placed that many times. Use `all` to
put the whole set in one file:

```bash
python3 scripts/komascad_export.py --preset-file presets/games/shogi.json --out exports/shogi --layout-size all
```

The game files in `presets/games/` get their counts from `presets/games.json`;
see the [user guide](user-guide.md). Without `--layout-size`, each preset is
still exported once and `manifest.json` records its `quantity`.

## Paths

Use absolute paths whenever the model and preset file are outside the current
project. `--preset-file` and `--out` resolve from the directory where you run
the command, so `../shogi_piece.json` means “one directory above here.”
`--target` only controls where a relative `--scad` file resolves.

```bash
python3 scripts/komascad_export.py --target /path/to/KomaSCAD --preset-file /path/to/KomaSCAD/my-presets.json --out /path/to/print-order
```

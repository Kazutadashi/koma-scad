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
python3 scripts/komascad_export.py --preset-file presets/taikyoku.json --set-name "Taikyoku Shogi" --out exports
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

## Paths

Use absolute paths whenever the model and preset file are outside the current
project. `--preset-file` and `--out` resolve from the directory where you run
the command, so `../shogi_piece.json` means “one directory above here.”
`--target` only controls where a relative `--scad` file resolves.

```bash
python3 scripts/komascad_export.py --target /path/to/KomaSCAD --preset-file /path/to/KomaSCAD/my-presets.json --out /path/to/print-order
```

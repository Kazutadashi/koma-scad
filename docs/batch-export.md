# Batch-exporting a preset collection

`komascad_export.py --set` turns a JSON collection of saved Customizer presets
into a named folder containing one multipart colour 3MF per preset. It is a
coordinator: each piece is rendered by the existing `komascad_export.py`
single-piece exporter, so batch and individual exports use the same geometry,
mesh validation, materials, and 3MF packaging.

## Collection format

The input is an ordinary OpenSCAD preset JSON file. Every entry under
`parameterSets` is one piece to export:

```json
{
  "fileFormatVersion": "1",
  "parameterSets": {
    "01 Chu - Pawn": {
      "Front_Characters": "歩兵",
      "Back_Characters": "金将"
    },
    "02 Chu - Lion": {
      "Front_Characters": "獅子",
      "Back_Characters": ""
    }
  }
}
```

Distributed presets should remain complete flat records, as described in the
[preset guide](presets.md). The shortened records above only illustrate the
collection structure.

Preset names become filenames, so use stable, descriptive names. Numeric
prefixes are useful when the output should sort in a deliberate order. Unsafe
filesystem punctuation is converted to a readable separator, and the command
stops if two names would produce the same filename.

## Export an entire collection

Run the command from the repository root:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/chu-shogi.json \
  --set-name "Chu Shogi"
```

When every export succeeds, the result has this structure:

```text
exports/
└── Chu Shogi/
    ├── 01 Chu - Pawn.3mf
    ├── 02 Chu - Lion.3mf
    └── manifest.json
```

The script stages the complete collection first. If any individual export
fails, it removes the incomplete staged files and does not publish a partial
set folder.

The manifest records the set name, source files, preset-to-filename mapping,
file sizes, and SHA-256 checksums. This makes the delivered folder easy to
audit without changing the printable 3MF files.

## Preview before rendering

Rendering a large collection can take time. First list the selected presets:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/chu-shogi.json \
  --list
```

Then preview the folder and filenames without invoking OpenSCAD:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/chu-shogi.json \
  --set-name "Chu Shogi" \
  --dry-run
```

## Export part of a collection

Use repeatable, case-sensitive `--include` and `--exclude` glob patterns. This
example exports all Professional King grid-search records from the main preset
file:

```bash
python3 scripts/komascad_export.py --set \
  --parameters shogi_piece.json \
  --include "King - Professional Grid *" \
  --set-name "Professional King Grid Search"
```

Multiple include patterns are combined. Excludes are applied afterward:

```bash
python3 scripts/komascad_export.py --set \
  --parameters shogi_piece.json \
  --include "King - Professional Grid *" \
  --include "King - Font *" \
  --exclude "*Retired*" \
  --set-name "King Studies"
```

For a hand-picked set, repeat `--preset` with exact names. Exact selections
are exported in command-line order:

```bash
python3 scripts/komascad_export.py --set \
  --preset "00 Base - King" \
  --preset "King - Professional Yuji Syuku" \
  --set-name "King Comparison"
```

Use either exact `--preset` values or `--include` patterns in one command, not
both. `--exclude` can be used with either selection style.

## Taikyoku and generated collections

To export every record currently stored in the Taikyoku preset file:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/taikyoku.json \
  --set-name "Taikyoku Shogi"
```

The same command works when an LLM or another generator creates a new preset
collection. A reliable automation flow is:

1. Generate complete, uniquely named records under `parameterSets`.
2. Validate the selection with `--list` and `--dry-run`.
3. Install every font referenced by the selected records and restart any open
   OpenSCAD process.
4. Run the batch export.
5. Open representative 3MF files in the target slicer and confirm part and
   material assignments before ordering or printing the full collection.

Each preset produces one 3MF model. The script does not infer game-specific
piece quantities or duplicate a model automatically. If a manufacturing order
needs several copies of one piece, set that quantity in the slicer or the
print provider's order.

## Output and replacement options

The default parent folder is `exports/`. Choose another location with
`--output-root`:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/chu-shogi.json \
  --set-name "Chu Shogi" \
  --output-root /path/to/print-orders
```

An existing set folder is never changed by default. After reviewing the exact
destination, pass `--replace` to replace it only after the new collection has
exported successfully:

```bash
python3 scripts/komascad_export.py --set \
  --parameters presets/chu-shogi.json \
  --set-name "Chu Shogi" \
  --replace
```

Use `--scad` and `--target` for another compatible model checkout, and
`--openscad` when the OpenSCAD executable is not named `openscad` on `PATH`.
Run `python3 scripts/komascad_export.py --set --help` for the complete interface.

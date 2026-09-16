# Presets — KomaSCAD 3.4

Keep the bundled `shogi_piece.json` beside `shogi_piece.scad`. It contains complete base and test records, including **00 Base - King**, **01 Shogi - Pawn**, and **30 Taikyoku - Fire Demon**, plus experimental typography presets. The Fire Demon uses the attributed dataset's `火鬼` front and `奔火` promoted back. Its dimensions and typography are project test defaults, not verified historical measurements.

## Save and share

1. Open the SCAD, show Customizer, and select the base preset.
2. Change dimensions, inscriptions, font and layout. Category is informational; it never changes dimensions.
3. Inspect both faces with F5. Use Inspect signature or Inspect pawn circle when relevant.
4. Use **+** to name a new preset and save it. Keep personal copies before replacing the bundled JSON.
5. Share the saved JSON with the matching SCAD version and the font family/version needed to reproduce it.

Customizer presets are flat records, not inherited profiles. Copy the full base record for a new piece. Keep `fileFormatVersion` as `"1"`; numbers, booleans and numeric lists in the bundled records are strings. Use the exact case-sensitive public parameter names. Avoid partial records when distributing reproducible designs.

## Reproducible example

Run this from the repository root to make a separate complete preset file without changing the bundled base:

```bash
python3 - <<'PYTHON'
import json
from pathlib import Path
source = json.loads(Path('shogi_piece.json').read_text(encoding='utf-8'))
base = source['parameterSets']['00 Base - King'].copy()
base.update({
    'Category': 'Personal / Rook study',
    'Front_Characters': '飛車',
    'Back_Characters': '龍王',
    'Mirror_Front_Settings': 'true',
    'Output_Mode': 'Print',
})
source['parameterSets'] = {'My Rook Study': base}
Path('my-presets.json').write_text(json.dumps(source, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
PYTHON
```

This is a lettering study on the base king body, not a validated rook size profile. Edit Piece Length, Base Width, Rear Thickness and Tip Thickness before adopting a set's size hierarchy.

## Export

For STL, save the preset with Output Mode set to Print (or Blank):

```bash
openscad -o king.stl -p shogi_piece.json -P '00 Base - King' shogi_piece.scad
openscad -o rook-study.stl -p my-presets.json -P 'My Rook Study' shogi_piece.scad
```

For colour 3MF, use the exporter, not the GUI Export menu:

```bash
python3 scripts/komascad_export.py --preset '00 Base - King' --output king.3mf
python3 scripts/komascad_export.py --parameters my-presets.json --preset 'My Rook Study' --output rook-study.3mf
```

The exporter controls the output-part mode even if the preset was saved in an Inspect view or Colour assembly. It reads saved values only. It starts with SCAD defaults for omitted keys and applies explicit CLI text/colour overrides last. Do not rely on the GUI retaining/resetting unspecified values the same way; distribute complete records.

OpenSCAD 2021.01 can give `-p` preset values priority over public `-D` arguments. For ordinary CLI STL variations, edit a copied preset rather than assuming `-D` will override it.

## Linked settings and optional features

- Mirror Front Settings links twenty typography/engraving controls. Back text, colour and taper remain independent; stored back settings return when disabled. Automatic size still adapts to each side's character count.
- Signature Enabled controls the optional heel mark. Also enter Signature Text. Signature settings are independent of the front/back link.
- Pawn Circle enforces a twenty-piece ring in plan view. At base 81°, shoulder and tip satisfy `2 × shoulder + tip = 378°`; Angle Mode selects the derived input. Conflicts are reported.
- Font Size and Character Spacing use 0 for automatic values. Positive values are explicit sizes/distances in mm; font size is typographic, not measured glyph height.

## Extending to whole games

Use full records and consistent names, for example `10 Shogi - Pawn`, `20 Chu - ...`, `30 Taikyoku - ...`. Confirm dimensions, glyphs, promotion relationships and font coverage before treating any game collection as ready for play. Promotion uses the same physical body as the front.

Keep historical datasets and their attribution separate from model defaults. The legacy data and build script were not supplied with this release package; do not run an old preset builder over the new JSON. See [MIGRATION.md](MIGRATION.md) before upgrading an existing repository.

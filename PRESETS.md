# Categories and named presets

Open `shogi_piece.scad` with `shogi_piece.json` beside it in desktop OpenSCAD.
Show the Customizer (Window > Hide Customizer toggles visibility), then select
**Shogi Rook** or **Taikyoku Free Dream Eater** in its Preset dropdown.
Install **Noto Sans CJK JP** first, or select your installed Japanese font.
Press F5 to preview, F6 to render, then export STL.

## Category versus preset

`category` selects body dimensions. A named JSON preset sets category, inscriptions,
font, typography, and the other visible settings together. The bundled presets include the original controls; recently added text-style and
rounding controls are not stored. Check those after changing presets, since omitted
values can remain from the previous selection.
`model_scale` then uniformly scales the entire result, including engraving depth.
`Custom` preserves the original manual dimension controls and default A/B model.
The Dimensions fields only apply in Custom mode; the console prints resolved dimensions.
`auto_text_layout` fits a conservative centered vertical stack to the selected body;
turn it off to use the original per-face typography controls.

## Size profiles (mm before scaling)

These are editable **project design defaults**, not certified traditional dimensions.
The eight Shogi types have separate profiles so even small differences can be tuned.
The four Taikyoku tiers are a starting scheme, **not a complete historical size taxonomy**.
The uploaded character manifest has no dimensions or size ranking. Most Taikyoku
entries therefore start at medium; Pawn is small, Flying chariot and Free dream-eater
large, and King/Crown prince royal. These assignments are explicitly provisional.
A source set's measurements are needed to reproduce every historical size change.
Do not infer physical size from movement strength or promotion name.

| Category | Length | Width | Rear thickness |
| --- | ---: | ---: | ---: |
| Shogi pawn | 26 | 21 | 8.5 |
| Shogi lance | 27 | 22 | 8.6 |
| Shogi knight | 28 | 23 | 8.7 |
| Shogi silver | 29 | 24 | 9 |
| Shogi gold | 29.5 | 25 | 9.2 |
| Shogi bishop | 30 | 26 | 9.3 |
| Shogi rook | 30.5 | 27 | 9.4 |
| Shogi king | 31.5 | 28 | 9.5 |
| Taikyoku small | 26 | 21 | 8.5 |
| Taikyoku medium | 28 | 24 | 8.8 |
| Taikyoku large | 30 | 27 | 9.3 |
| Taikyoku royal | 31.5 | 28 | 9.5 |

Edit `category_profiles` in the SCAD to adjust shared dimensions. Edit
`data/taikyoku_size_categories.csv` to assign existing pieces to tiers, then run
`python3 scripts/build_presets.py`. The script overwrites bundled JSON files;
keep personal presets in a separate file before rebuilding. For another exact
size, choose Custom, enter dimensions, and save a named preset; no new category
is required. To add a shared category, update both the SCAD dropdown and table.

## Load a preset file from the command line

Run from this project directory:

```sh
openscad -o shogi-rook.stl -p presets/shogi.json -P "Shogi Rook" shogi_piece.scad
openscad -o free-dream-eater.stl -p presets/taikyoku.json -P "Taikyoku Free Dream Eater" shogi_piece.scad
```

The root `shogi_piece.json` combines both collections for desktop discovery by
matching the SCAD basename. The `presets/` files are separate collections for CLI
use; to use one in the GUI, copy it beside a copy of the SCAD with matching basenames.
Web playgrounds may not expose desktop Customizer JSON loading.

## Save your own

Select a starting preset, change its settings, click **+** in the Customizer preset
area to create a new named set, and use the save preset button. Keep the JSON file
with the SCAD when sharing. A JSON file may contain one or many named sets:

```json
{"parameterSets":{"My Rook":{"category":"Shogi rook","front_characters":"飛車","back_characters":"龍王","auto_text_layout":"true","font_name":"Noto Sans CJK JP"}},"fileFormatVersion":"1"}
```

This minimal example is a partial preset: unspecified GUI values remain as they
were. Use the GUI's saved full preset or the bundled full presets for repeatability.
Do not rely on `-D` overriding a parameter already stored in a preset across versions;
edit/save a separate preset for the variation.

## Character coverage and verification

Taikyoku names and both faces come from the supplied CSV, including promotion-only
forms. A promoted face uses the same physical body as its front. Entries containing
Ideographic Description Sequences are listed in `presets/omitted-pieces.txt` and
excluded, because they require custom glyph artwork. Other rare characters still
need a font that contains them. Preview both sides before printing; automatic
layout cannot verify a font's glyph coverage or every dense stroke.

Generated Taikyoku presets and the combined JSON carry the character data's
CC BY-SA 4.0 terms; retain `data/ATTRIBUTION.md` when sharing them.

Reference: [OpenSCAD Customizer manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Customizer#Saving_Parameters_value_in_JSON_file).

## Validation

See [model controls and rendering status](docs/parameters.md#rendering-and-printing-status)
for the current validation scope. Preview glyphs and inspect sliced toolpaths before printing.

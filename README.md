# KomaSCAD

**Make your own shogi pieces with OpenSCAD and a 3D printer.**

![OpenSCAD](https://img.shields.io/badge/OpenSCAD-2021.01%2B-yellow)
![Code license](https://img.shields.io/badge/code-MIT-blue)
![Data license](https://img.shields.io/badge/data-CC_BY--SA_4.0-green)

KomaSCAD is an open-source, customizable shogi piece generator. Make a replacement pawn, a complete shogi set, an oversized display piece, or a Taikyoku Free Dream Eater—with your choice of size, lettering, and finish.

Choose a piece, export an STL, and print it with one filament for the body and another for the text. Both recessed and raised lettering are supported, with independent inscriptions on the front and back.

## Features

- **Named pieces:** 9 Shogi and 207 Taikyoku presets.
- **Custom sizing:** piece categories, editable dimensions, and uniform scaling.
- **Two-sided lettering:** choose characters, fonts, spacing, and promotion text.
- **Your choice of finish:** recessed or raised text, adjustable depth, and sharp or rounded edges.
- **Standard STL export:** prepare the print in your preferred compatible slicer.

## What you need

- [OpenSCAD](https://openscad.org/downloads.html), version 2021.01 or newer.
- A Japanese font, such as [Noto Sans CJK JP](https://github.com/notofonts/noto-cjk), for kanji lettering.
- A slicer with multi-material surface painting, such as PrusaSlicer with a compatible multi-material printer profile.
- A printer setup that can use two filaments within the same layer: an automatic filament changer, multiple extruders, or a toolchanger.
- Two compatible filaments: for example, ivory PLA for the body and black PLA for both inscriptions.

A single-color printer works too: print recessed lettering and fill it with paint afterward. The two-filament instructions below assume automatic material changes.

## Quick start

1. Download and extract this repository, or clone it.
2. Install your Japanese font and restart OpenSCAD.
3. Open **`shogi_piece.scad`**. Keep **`shogi_piece.json`** beside it so OpenSCAD can find the presets.
4. Show the **Customizer** panel and choose **Shogi Rook**, **Taikyoku Free Dream Eater**, or another named preset.
5. Set `font_name` to an installed font. Check **Help → Font List** for its exact name.
6. Set the front and back text styles to `Recessed` or `Raised`. Start with `text_edge_radius = 0` for crisp edges and a fast render.
7. Keep `output_mode = "Printable engraved"` and `print_orientation = "Upright"`.
8. Press **F5** to preview both sides, then **F6** to render. Export through **File → Export → Export as STL**.

Despite its name, **Printable engraved** exports either recessed or raised lettering, depending on the selected styles. **Clean inspection** is only a placement preview; use the printable mode for STL export.

For a first test without installing a font, use the default **A / B** piece.

## Customize your piece

| Want to change… | Use… |
| --- | --- |
| The piece and its inscriptions | The Customizer preset dropdown |
| Its size category | `category` |
| Exact dimensions | `category = "Custom"`, then `piece_length`, `base_width`, and `rear_thickness` |
| Overall scale | `model_scale` — `2` doubles every dimension |
| Front and back lettering | `front_characters` and `back_characters` |
| Raised or recessed lettering | `front_text_style` and `back_text_style` |
| Text depth or height | `front_engraving_depth` and `back_engraving_depth` |
| Sharp or rounded text edges | `text_edge_radius` — `0` keeps sharp edges |

Characters stack vertically. Leave an inscription empty for a blank face. Automatic text layout is available through `auto_text_layout`; check the result with your chosen font.

Scaling also scales text depth and rounding. For example, a 0.8 mm recess becomes 1.6 mm deep at `model_scale = 2`.

See [the parameter guide](docs/parameters.md) for more controls, or [the preset guide](PRESETS.md) to load, save, and share named pieces. Existing presets do not store every recently added text control, so check those settings after switching presets.

## Print with two filaments

### 1. Prepare the model

Import your exported STL into the slicer and select the correct printer, nozzle, and multi-material profile. Keep the broad rear edge on the build plate—the default **Upright** export already uses this orientation.

Add two filament profiles and assign them to the correct physical spools or tools. Use the same material type with compatible print temperatures for both colors. Start with one piece before filling a plate.

The STL contains one combined model. It does not contain filament assignments or separate text parts; OpenSCAD's preview colors do not transfer to the print.

### 2. Assign the colors

Give the whole piece the body filament, then select the text filament in the slicer's **multi-material painting** tool. Use a small brush, or smart fill with an angle threshold that stops at the letter boundary. Rotate the piece to reach both faces. See [PrusaSlicer's painting guide](https://help.prusa3d.com/article/multi-material-painting_262620) for the tools and how painted regions become material regions during slicing.

For **raised text**, color the letter tops and exposed sidewalls. For **recessed text**, color the groove floors and inner walls. Keep the surrounding face and the enclosed background areas inside characters in the body color.

Recesses remain recessed: surface painting assigns filament to the plastic around the grooves; it does not add a flush text inlay. Sharp edges are a useful starting point when selecting lettering. If a fill spills onto the face, undo it and use a smaller brush.

### 3. Slice and check both colors

Start with your printer's established profile. These are starting points to tune on a test piece:

| Setting | Starting point |
| --- | --- |
| Nozzle | 0.4 mm; a smaller nozzle can help with dense kanji |
| Layer height | 0.12–0.16 mm with a 0.4 mm nozzle |
| Walls | 3–4 |
| Infill | 15–25%, adjusted for the weight you want |
| Bed adhesion | Add a brim if the upright piece needs it |
| Text rounding | Off for the first print |

Use your printer's purge or wipe arrangement and tune the transition from dark text to a light body to avoid color contamination. Inspect overhangs before adding supports, especially around raised text and the upper edges of grooves.

In the **sliced toolpath preview**, display colors by filament/tool and inspect layers through both inscriptions. Confirm that fine strokes survive slicing, enclosed details remain open, and the lettering is actually assigned to the second filament. Surface painting can lose features that are too small to print; the colored model preview alone is not sufficient.

A single filament swap at a chosen height will not isolate the text on this upright, two-sided model: body and lettering occupy the same layers.

### 4. Save and print

Save the painted setup as a **slicer project, usually 3MF**, so you retain the color assignments and settings. Export the printer-specific job from that slicer, verify its filament-to-spool mapping, and print one piece.

Let it cool, remove the brim and any supports, and inspect both faces. If strokes disappear, enlarge the lettering or piece, try a suitable font, or use a smaller nozzle. Once the test looks right, duplicate the painted piece for a batch and review the estimated time and material changes.

## Troubleshooting

| Problem | Try this |
| --- | --- |
| Missing kanji or square boxes | Select an installed Japanese font and verify that it includes the particular glyph |
| Text too close to the rim | Reduce its size or spacing, or move the text center; lettering is not clipped to the face |
| Thin strokes disappear | Reduce rounding, cautiously increase `stroke_expansion`, or enlarge the text |
| OpenSCAD reports the piece is too thin | Reduce recess depth or increase thickness in `Custom` mode |
| Rendering is slow | Set `text_edge_radius = 0`; reduce text curve resolution if needed |
| No color-painting tool | Select a compatible multi-material printer profile in the slicer |
| Text looks colored but slices in one filament | Check the tool assignment and whether the strokes are wide enough to print |

## Taikyoku pieces

The character reference contains 209 entries. Two entries that require custom historical glyph artwork are excluded from the presets; see [the omitted pieces](presets/omitted-pieces.txt). Other rare characters may also need a different font.

Size categories are editable project defaults, not verified measurements of a historical Taikyoku set. Check your intended board spacing before printing a full set. Sources and character-data notes are in [data/ATTRIBUTION.md](data/ATTRIBUTION.md).

## Project files

| File | Purpose |
| --- | --- |
| `shogi_piece.scad` | Main piece generator |
| `shogi_piece.json` | Combined Customizer presets |
| `presets/` | Separate Shogi and Taikyoku preset collections |
| `data/` | Character reference, size assignments, and attribution |
| `PRESETS.md` | Preset loading and editing guide |
| `docs/parameters.md` | Detailed model controls |
| `paint_test.scad` | Optional groove test coupon for hand-painted pieces |
| `scripts/build_presets.py` | Rebuild preset collections from the source data |

## Contributing

Bug reports, print photos, verified glyph corrections, and tested printing settings are welcome. For a modeling or print issue, include the piece name, font, relevant settings, OpenSCAD/slicer versions, and a screenshot. For a print result, include the printer, nozzle, materials, and layer height. Please include a source with historical character or size corrections.

## License

Code and original documentation are available under the [MIT License](LICENSE). Wikipedia-derived character data and the preset files containing it are **CC BY-SA 4.0**; see [data/ATTRIBUTION.md](data/ATTRIBUTION.md). Fonts and external tools retain their own licenses.

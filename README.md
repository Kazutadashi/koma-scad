# KomaSCAD

![OpenSCAD](https://img.shields.io/badge/OpenSCAD-2021.01-yellow)
![Code licence](https://img.shields.io/badge/code-MIT-blue)
![Data licence](https://img.shields.io/badge/data-CC_BY--SA_4.0-green)

KomaSCAD is an open-source parametric generator for shogi pieces, written in OpenSCAD. It produces complete, printable 3D models of pieces from their inscribed characters and a defined set of parameters governing dimensions, edge geometry and lettering.

The project consists of the piece generator, a base preset, an exporter for multicolour models, and documentation covering piece geometry, typography and every configurable parameter.

![OpenSCAD preview of a KomaSCAD king](images/preview.png)

## Features

**Piece shape**

- Adjustable length, heel width, heel thickness and tip thickness, with a configurable edge bevel.
- A pawn-circle constraint that holds the piece angles to values at which twenty pieces placed side by side close into a ring.

**Lettering**

- Separate inscriptions for the front and back of each piece, such as a piece's name and its promoted name.
- Support for any installed font that contains the required characters.
- Size, spacing, position and proportions set independently for each face, with further adjustment of individual characters.
- Stroke expansion, which thickens or thins the strokes of the chosen font.
- Recessed or raised lettering for single-filament printing, with face-only, painted-groove or flush-inlay material regions for multicolour printing.
- An option to apply the front's typography settings to the back.
- A maker's signature inscribed on the heel.

**Inspection and export**

- Inspection views that mark the safe lettering region, highlight overflow, and check the signature and pawn circle.
- STL export of complete pieces, blank bodies or individual material parts.
- Multicolour export to a single 3MF file containing aligned, named parts for the body, front lettering, back lettering and signature.
- Named presets that store a complete piece design for reuse and sharing.

Every configurable parameter is documented, with its default value, in the [parameter reference](docs/parameters.md).

## Requirements

- [OpenSCAD 2021.01](https://openscad.org/downloads.html).
- A font containing the Japanese characters you intend to use. The default is Noto Serif CJK JP SemiBold, available from [Noto CJK](https://github.com/notofonts/noto-cjk). Fonts are not included with KomaSCAD.
- A filament 3D printer and a slicer. KomaSCAD does not depend on any particular brand.
- For multicolour export only: Python 3.8 or later, with the `openscad` command available on your PATH. The exporter uses only the Python standard library.

## Installation

1. Download this repository with **Code → Download ZIP**, or clone it with Git.
2. Install the font you intend to use, then start or restart OpenSCAD so that it detects the font.

Keep `shogi_piece.scad` and `shogi_piece.json` in the same folder. OpenSCAD loads a model's presets from the JSON file that shares its name.

## Getting started

This walkthrough produces a single-filament king. **Print is the main working mode**, and every bundled preset is saved in Print. With Customizer's **Automatic Preview** enabled (the normal OpenSCAD setting), opening the file or choosing a preset displays the printable piece immediately. **Render (F6)** builds the exact geometry required for STL export.

1. Open `shogi_piece.scad` in OpenSCAD. If the Customizer panel is not visible, uncheck **Window → Hide Customizer**.
2. At the top of the Customizer, select the preset **00 Base - King**. A preset is a saved set of Customizer values. It opens in Print and updates automatically. F5 is only a fallback if you have disabled Automatic Preview in OpenSCAD.
3. Find the exact name of your font under **Help → Font List**, and enter it in the Customizer's font setting without quotation marks.
4. Enter the inscriptions in **Front Characters** and **Back Characters**. Characters are stacked from the point of the piece towards the heel. Leave Back Characters empty for a blank reverse side.
5. Set the mode to **Inspect front** and press F5. The blue area is the safe lettering region; lettering highlighted in red extends beyond it and will be clipped. Repeat with **Inspect back**.
6. Set the mode to **Print** and leave **Print Orientation** at **Upright**, which stands the piece on its heel. Press F6, wait for the render to finish, then choose **File → Export → Export as STL**.
7. Open the STL in your slicer, check the toolpaths, and print one test piece before printing a full set.

To keep your design, save it as a named preset in the Customizer. [PRESETS.md](PRESETS.md) explains how to save, share and extend presets.

## Export modes

| To produce | Mode | Procedure |
| --- | --- | --- |
| A single-filament piece with recessed or raised lettering | Print | Render (F6), then export STL |
| A piece body without lettering | Blank | Render (F6), then export STL |
| A layout check of the lettering, signature or pawn circle | An Inspect mode | Preview (F5) only |
| A preview of multicolour lettering | Colour assembly | Fast Preview (F5) only; export with `scripts/komascad_export.py` |
| A single material part as a separate STL | Colour body, Colour front, Colour back or Colour signature | Render (F6), then export STL |

Separately exported material parts share a common alignment. Import them together without moving them to reassemble the piece.

## Multicolour printing

Colour assembly previews the selected body, lettering and signature materials without building every exact export mesh. It uses the same driver-safe open-face preview as Print, then applies the selected colour swatches at the selected recess depths; the individual Colour modes still build the complete closed material volumes for export. The default **Face only** treatment puts a thin printable colour region directly behind each visible inscription face. On recessed text, the groove walls remain body material and the surface geometry stays identical to Print. **Painted grooves** optionally extends the colour region beside those walls while retaining the same open recess. **Flush filled** instead closes the recess with a level inlay. The exporter writes the body, lettering and signature as named, aligned parts of a single 3MF file.

1. Finish and inspect the geometry in **Print** mode. Under **07 – Filament colours**, choose a material colour for the body and each inscription.
2. Keep the default **Face only** for colour at the inscription face without coloured groove walls. Choose **Painted grooves** if you also want colour beside the groove walls, or **Flush filled** for a level recessed inlay. Keep **Protect Face Edges** enabled.
3. Save your settings as a named preset. The exporter reads saved presets only, so unsaved changes are not exported.
4. Optionally select **Colour assembly** and press F5 for a fast material preview. You can also leave the saved Output Mode set to Print; the exporter chooses the required part modes itself.
5. Open a terminal in the project folder and run the exporter, replacing `00 Base - King` with your preset name. No F6 render in OpenSCAD is needed first.

   ```bash
   python3 scripts/komascad_export.py --preset '00 Base - King' --output king.3mf
   ```

6. Import `king.3mf` into your slicer as a single multipart object. Keep the parts in their original positions. Standard colour properties are already attached to the named parts, so compatible slicers create the logical filament assignments without painting strokes or selecting each part. Confirm that those colours match the spools physically loaded in your printer.

> [!WARNING]
> Colour assembly is a preview-only mode. Do not render it with F6 or export it with OpenSCAD's built-in 3MF export: OpenSCAD cannot reliably merge the touching material regions. The exporter preserves them as separate meshes while sharing one cached render batch.

Before printing, note the following:

- The exported file is a 3MF model, not G-code or a slicer project. Slicers that ignore standard colour properties may still require assignment by part name.
- The exporter uses standard 3MF Core and Materials and Properties resources. It does not claim to be a vendor slicer or embed proprietary printer/project configuration.
- The colours chosen in the Customizer identify each part. The printed finish, including any metallic or glitter effect, depends on the filament you load.
- In Upright orientation, the front and back lettering share layers with the body, so a single filament change at one layer height cannot colour both inscriptions.
- A single-nozzle printer requires a filament-change workflow that supports multicolour printing.
- As an alternative on any printer, print the piece with recessed lettering in one filament and fill the lettering by hand.

The [colour quickstart](KomaSCAD-colour-quickstart.md) covers material mapping and limitations in more detail.

## Customizer reference

The Customizer in OpenSCAD 2021.01 cannot be searched. The table below shows where each group of settings is located. For individual parameters, see the [parameter reference](docs/parameters.md) or search the code editor with Ctrl+F. Enable **Show Details** at the top of the Customizer to display each parameter's description and units.

| Settings | Customizer section |
| --- | --- |
| Piece dimensions and tip thickness | 02 – Piece dimensions |
| Text size, spacing, position and proportions | 03 – Front layout; 04 – Back layout |
| Applying the front's settings to the back | 04 – Back layout → Mirror Front Settings |
| Individual characters, including a third character | 05 – Front character adjustments; 06 – Back character adjustments |
| Filament colours and material labels | 07 – Filament colours |
| Stroke weight | 08 – Engraving and stroke weight → Front Stroke Expansion, Back Stroke Expansion |
| Edge bevel and face margins | 09 – Edges and face margin |
| Pawn-circle constraint | 10 – Advanced shape angles → Pawn Circle |
| Text rendering resolution | 11 – Inspection and quality → Text Curve Resolution |
| Maker's signature | 12 – Maker signature on heel |

**Piece dimensions.** The default piece is 31.5 mm long, 28 mm wide at the heel and 9.5 mm thick at the heel, with a tip 3 mm thick before bevelling. These are project defaults, not traditional dimensions. The **Category** setting is a descriptive label only; the dimension settings always determine the shape of the piece.

**Stroke expansion.** Front and Back Stroke Expansion default to +0.12 mm. Set a value of 0 for the font's original weight, or a small negative value to thin the strokes.

**Mirror Front Settings.** When enabled, the back uses the front's typography and engraving settings. The back text and colours remain independent, and the lettering is not reflected. Disabling the setting restores the back's own stored values.

## Troubleshooting

| Problem | Solution |
| --- | --- |
| Print is empty | Current Print preview avoids subtractive 3D OpenCSG operations: it opens only the broad preview face, applies a fast 2D glyph cutout, and displays its floor at the selected recess depth. F6/export retains the exact solid. Reopen the updated SCAD, enable **Design → Automatic Preview**, and select the preset again. Use **View → View All** if needed. |
| Nothing to export in Colour assembly | Colour assembly is preview-only. Export with `scripts/komascad_export.py`. |
| A coloured 3MF is invisible in a neutral viewer | Regenerate it with the current exporter. It stores explicit opaque alpha in both standard 3MF colour resources; older generated files may be interpreted as transparent by some viewers. |
| Bambu Studio 2.8.2.60 says the 3MF has “invalid config” | This version reports the same warning for ordinary geometry-only 3MF files. Dismiss the dialog to load the geometry; the KomaSCAD export intentionally contains no Bambu project config. See [BambuStudio issue #11927](https://github.com/bambulab/BambuStudio/issues/11927). |
| Render fails with a CGAL error | Keep the preset and the full console output, and report the problem as described in [Contributing](#contributing). |
| Previews are slow | Print and Colour assembly use an open-face F5 display proxy with only fast 2D cutouts; use the Inspect modes for flat layout work. Very detailed fonts can still benefit from Text Curve Resolution 24 while composing, then 48 for final export. |
| Kanji appear as boxes, or the wrong font is used | Check the font name against Help → Font List and confirm that the font contains the characters. Restart OpenSCAD after installing a font. |
| Lettering is too heavy | Reduce Front or Back Stroke Expansion, then check thin strokes in the slicer. |
| Lettering is highlighted in red | Reduce the text size or adjust spacing or position. Lettering outside the safe region is clipped, not scaled to fit. |
| Changes to back settings have no effect | Disable Mirror Front Settings. |
| Pawn Circle rejects the angles | Read the console message. The base angle must be 81°, and Angle Mode determines which other angle is derived. |
| The signature prints faintly | In Upright orientation, the signature is printed against the bed. Check the first layers in the slicer and print a test piece. |

## Repository contents

| Path | Description |
| --- | --- |
| `shogi_piece.scad` | Piece generator |
| `shogi_piece.json` | Presets, including the base king |
| `scripts/komascad_export.py` | Multicolour 3MF exporter |
| [docs/parameters.md](docs/parameters.md) | Parameter reference: every configurable parameter, with defaults and descriptions |
| [KomaSCAD-guide.md](KomaSCAD-guide.md) | Design guide: piece geometry, typography and features |
| [KomaSCAD-colour-quickstart.md](KomaSCAD-colour-quickstart.md) | Multicolour export in detail |
| [PRESETS.md](PRESETS.md) | Saving, sharing and extending presets |
| [examples/README.md](examples/README.md) | Example STL and 3MF files and what each demonstrates |
| [CHANGELOG.md](CHANGELOG.md) | Changes in each release |
| [MIGRATION.md](MIGRATION.md) | Upgrading from earlier releases |

The example files demonstrate KomaSCAD's output. They are not tuned for any particular printer or slicer.

## Contributing

Bug reports, print results and improvements are welcome through GitHub issues and pull requests.

**Reporting problems.** For rendering or geometry problems, include the `.scad` and `.json` files, the preset name, the exact font name, your OpenSCAD version and the full console output.

**Sharing print results.** Include the nozzle size, filament, slicer and layer settings. Results from different printers, filaments and slicers help establish reliable settings for everyone.

**Historical glyphs and promotion mappings.** Contributions must cite their sources.

## Acknowledgements

Thanks to [@imtrmu](https://github.com/imtrmu), whose work inspired KomaSCAD's parametric design approach.

## Licence

Code and original documentation are released under the [MIT License](LICENSE). Retain existing copyright notices when redistributing or modifying the project.

Historical datasets and presets derived from Wikipedia are licensed under CC BY-SA 4.0 and must retain their attribution. Fonts and external tools are covered by their own licences.

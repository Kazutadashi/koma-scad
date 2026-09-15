# KomaSCAD 3.3.1 — colours and multipart 3MF

Keep **shogi_piece.scad**, **shogi_piece.json**, and **komascad_export.py** together. The exporter needs Python 3.8 or newer and OpenSCAD 2021.01 or newer; it uses only Python's standard library. Install the selected font before generating geometry. The supplied examples use Noto Serif CJK JP SemiBold.

## Optional maker signature

Expand **12 - Maker signature on heel** in Customizer, enable it, and enter your text. It appears on the broad bottom edge. **Inspect signature** checks its fit; **Print** engraves it, and **Colour assembly** adds a separate filled signature part. The default Signature Filament is **Same as front**, so it adds no new material unless you choose one. Empty or disabled signatures add no part. **Blank** remains unsigned.

The existing exporter reads the signature from your saved preset. Alternatively:

```bash
python3 komascad_export.py --preset '00 Base - King' --signature-text 'KomaSCAD' --signature-colour Gold --output signed-king.3mf
```

The heel touches the bed in Upright orientation. Check the signature in the first sliced layers before printing. See [KomaSCAD-guide.md](KomaSCAD-guide.md) for the size, spacing, depth, margin, position and rotation controls.

## Choose the appearance

In OpenSCAD Customizer, expand **07 - Filament colours**:

| Control | What it chooses |
| --- | --- |
| Body Filament | Body colour/material label |
| Front Filament | Front lettering colour/material label; Same as body is available |
| Back Filament | Back lettering colour/material label; Same as front/body is available |

Choices include Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1/2/3, and Custom. **Glitter and metallic finishes come from the loaded filament.** The swatches are flat colours; the 3MF does not encode sparkle, metallic reflectance, filament chemistry, temperature, or a particular printer slot.

**Same as front/body** shares the named material. Choosing the same palette colour independently also reuses the same material resource. For example: Body = Purple, Front = Silver, Back = Same as front produces two materials and up to three geometric parts. Empty text, None style, or zero relief depth omits that face's lettering part.

**Custom** uses that role's existing RGBA control under Inspection and quality. RGB supplies the 3MF swatch; alpha remains a preview property. Custom body/front/back are separate material names unless linked with Same as. If an older preset contains customised RGBA values, select Custom for the corresponding new Filament dropdown to use them.

For a spool not represented by the palette, choose Filament 1/2/3 and assign your actual spool in the slicer. Those are descriptive material labels, not promises that a particular extruder slot has already been configured.

## Keep using STL

- **Print** produces the original engraved or raised single-material solid. Export STL normally. Colour dropdowns do not turn STL into a colour format.
- **Blank** produces the unlettered body.
- **Inspect front/back** remain F5-only flat composition views, using the selected swatches. Blue guides and bright-red overflow are not printable materials.

The existing neutral layout defaults, unit descriptions, and Print preview correction are retained.

## Export a colour-ready piece

1. Choose your strings, dimensions, and filament colours in Customizer.
2. Select **Colour assembly**, then press F5. Do not press F6 in this mode or use File → Export: the Python script below performs the separate renders itself. This previews a filled, flush inlay design. For this workflow use **Recessed** on active faces and leave **Protect Face Edges** enabled. Raised text remains available in the ordinary Print workflow.
3. Check both Inspect views for overflow and check your font selection. Three-character layouts are supported; small intricate characters still require a slicer/print check.
4. Save your settings as a named Customizer preset. The exporter cannot read unsaved settings from the GUI.
5. From the folder containing the files, run:

```bash
python3 komascad_export.py --preset 'My piece' --output my-piece.3mf
```

For the supplied base:

```bash
python3 komascad_export.py --preset '00 Base - King' --output king.3mf
```

Omit `--preset` to use the SCAD source defaults. An alternative JSON can be selected with `--parameters path/to/presets.json`. Use `--scad path/to/shogi_piece.scad` or `--openscad /path/to/openscad` when necessary.

The exporter reads your saved settings, builds body/front/back/signature separately, and packages one aligned assembly with named colour/material resources. It deliberately controls the part-selection mode, regardless of the Output Mode saved in the preset. Explicit command-line colour/text overrides take precedence over the saved values.

**Do not use OpenSCAD 2021.01's native 3MF export for the colour assembly.** It drops the material assignments. F6 on Colour assembly is intentionally blocked: merging exactly touching material parts can fail in CGAL and loses their separation. Use Print for an engraved STL instead. If OpenSCAD says Nothing to export, use the script for colour output.

## In the slicer

Open the 3MF as **one object with multiple parts/volumes**, preserving their relative positions. Do not place each lettering part separately on the bed: the files use a shared coordinate system, and lettering intentionally sits inside its matching body recesses.

The intended part names are **Body | material**, **Front | material**, **Back | material**, and optional **Signature | material**. Map them to the filaments/extruders available in your printer profile. If your slicer ignores the standard 3MF colour resources, use those part names to assign the filaments once, then save a native slicer project for that configuration. You should not need to paint individual character strokes.

These are portable 3MF **models**, not printer-specific slicer projects or G-code. Colour and part preservation varies between slicers and versions. Once a target slicer is chosen and tested, a native project can retain its spool assignments, plate arrangement, and print settings. No such slicer-specific project has been qualified in this release.

A single nozzle without a filament-changing mechanism still needs manual filament changes. The upright two-sided design shares many layers between body and lettering, so automated switching is the practical colour-print path. Multiple colours do not require a proprietary printer brand, but they do require a way to supply those filaments.

## Three characters

Text is stacked from point to heel. For `大将軍`, the first entry controls 大, the second 将, and the third 軍. Each face now exposes three entries for glyph size, width, height, X, Y, and rotation. All scale defaults are 1; all offsets and rotations are 0. For shorter inscriptions unused entries do nothing. Longer strings retain neutral values beyond the supplied entries unless the lists are extended in the source.

Automatic font size accounts for the character count. Width Scale only changes width; it does not change height or spacing. The exporter groups all glyphs on a face into one material part, even when their strokes form several disconnected regions.

## Included examples

- **KomaSCAD-colour-base.3mf**: wood body, black 王将, blank reverse. Same dimensions and layout as the base preset, with flush black inlays instead of open recesses.
- **KomaSCAD-three-character-demo.3mf**: purple body and silver 大将軍 on both faces. This is a three-character geometry/material demonstration, not a verified historical piece/promotion prescription.

Reproduce the demonstration with:

```bash
python3 komascad_export.py --body-colour Purple --front-colour Silver --back-colour 'Same as front' --front-text '大将軍' --back-text '大将軍' --output three-character-demo.3mf
```

For black with glitter lettering, choose Body = Black and Front = Glitter silver or Glitter gold. Choose Back = Same as front if both faces use the same spool.

## Geometry and verification

Inlays are the intersection of the original blank with the engraving cutter. The body is the original blank minus those inlays. This creates complementary volumes sharing exact boundaries, with no intentional air clearance or overlapping volume. They are **co-printed material regions, not press-fit inserts**. Engraving depth determines how far each inlay extends into the body. Existing text rounding, taper, scale, and face placement are reused.

The delivered base and three-character packages were checked for closed, consistently wound material meshes, expected part/material counts, and conserved total volume. Both were reimported through OpenSCAD/lib3mf with preserved bounds and total volume. A flattened STL of a multipart model can have shared internal surfaces; it is not the distribution format for these material regions. The ordinary Print STL remains the single watertight printable output.

Actual slicer filament mapping, toolpaths, and physical multicolour printing have not been tested here. On systems with Fontconfig tools, the exporter rejects an obvious font-family substitution; this is not a complete rare-glyph or style-coverage check. Review the preview before distributing a whole set.

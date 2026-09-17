# KomaSCAD 3.4 — colours and multipart 3MF

Keep **shogi_piece.scad** and **shogi_piece.json** in the project root and leave **komascad_export.py** in the **scripts** folder. The exporter needs Python 3.8 or newer and OpenSCAD 2021.01 or newer; it uses only Python's standard library. Install the selected font before generating geometry. The supplied examples use Noto Serif CJK JP SemiBold.

## Optional maker signature

Expand **12 - Maker signature on heel** in Customizer, enable it, and enter your text. It appears on the broad bottom edge. **Inspect signature** checks its fit; **Model** shows both the engraving and selected signature material. Painted grooves can colour its walls, while Flush filled closes it with a level inlay. The default Signature Filament is **Same as front**, so it adds no new material unless you choose one. Empty or disabled signatures add no part. **Blank** remains unsigned.

The existing exporter reads the signature from your saved preset. Alternatively:

```bash
python3 scripts/komascad_export.py --preset '00 Base - King' --signature-text 'KomaSCAD' --signature-colour Gold --output signed-king.3mf
```

The heel touches the bed in Upright orientation. Check the signature in the first sliced layers before printing. See [the design guide](design-guide.md) for the size, spacing, depth, margin, position and rotation controls.

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

- **Model** previews geometry and selected colours together. F6 exports the engraved or raised geometry as one ordinary single-material STL; use the Python exporter for the shown colours.
- **Blank** produces the unlettered body.
- **Inspect front/back** remain F5-only flat composition views, using the selected swatches. Blue guides and bright-red overflow are not printable materials.

The existing neutral layout defaults and unit descriptions are retained.

## Export a colour-ready piece

1. Finish the strings, dimensions and relief in **Model**, using the Inspect modes for flat safe-area checks. Choose the body/front/back/signature filament colours in Customizer; Model shows them immediately.
2. Keep the default **Face only** for colour on the visible inscription floor with body-coloured walls. Choose **Painted grooves** if you also want coloured walls, or **Flush filled** for a level inlay. Leave **Protect Face Edges** enabled.
3. The visible relief depth and printable material thickness are separate. Bundled recesses remain `0.2 mm` deep, while the exporter automatically provides `0.8 mm` of supporting colour material inside the body for ordinary 0.4 mm extrusion systems. No thickness tuning is required.
4. Check both Inspect views for overflow and check your font selection. Three-character layouts are supported; small intricate characters still require a slicer/print check.
5. Save your settings as a named Customizer preset. The exporter cannot read unsaved settings from the GUI.
6. From the project folder, run:

```bash
python3 scripts/komascad_export.py --preset 'My piece' --output my-piece.3mf
```

For the supplied base:

```bash
python3 scripts/komascad_export.py --preset '00 Base - King' --output king.3mf
```

Omit `--preset` to use the SCAD source defaults. An alternative JSON can be selected with `--parameters path/to/presets.json`. Use `--scad path/to/shogi_piece.scad` or `--openscad /path/to/openscad` when necessary.

The exporter reads your saved settings, builds body/front/back/signature as closed solids, validates them, and packages one aligned assembly with named colour/material resources. It deliberately controls the part-selection mode, regardless of the Output Mode saved in the preset. Explicit command-line colour/text overrides take precedence over the saved values.

**Do not use OpenSCAD 2021.01's native 3MF export for colour.** It drops the multipart material assignments. Use F6 Model only for a single-material STL; use the script for colour 3MF.

## In the slicer

Open the 3MF as **one object with multiple parts/volumes**, preserving their relative positions. Do not place each lettering part separately on the bed: the files use a shared coordinate system, and lettering intentionally sits inside its matching body recesses.

The intended part names are **Body | material**, **Front | material**, **Back | material**, and optional **Signature | material**. Their display colours and object-level colour properties are stored in the 3MF. Slicers that support the standard 3MF Materials and Properties extension can turn those properties into logical filament slots and assign every part automatically. You should not need to use a paint bucket or select the body/front/back/signature parts individually. Confirm only that the resulting logical colours correspond to the spools actually loaded in the printer. If a slicer ignores standard 3MF colour properties, the names remain as a manual fallback.

These are portable 3MF **models**, not printer-specific slicer projects or G-code. The exporter uses standard 3MF Core components, base materials, and Materials and Properties colour groups. It does not identify the archive as a vendor slicer's project or add proprietary printer configuration. Colour import still varies between slicers and versions. A model can specify “this part is red,” but cannot know which physical slot contains a suitable red spool or which temperature profile that spool requires. Once a target slicer is chosen and tested, a native project can retain physical spool mapping, plate arrangement, and print settings. Any vendor adapter belongs outside the core exporter.

### Bambu Studio 2.8.2.60 warning

Bambu Studio 2.8.2.60 displays **“The 3mf file has invalid config, load geometry data only”** for ordinary standards-based 3MF model files that contain no Bambu project configuration. Dismiss the dialog to continue loading the geometry. This is a [reported Bambu Studio issue](https://github.com/bambulab/BambuStudio/issues/11927), not a request to add proprietary data to the portable export.

A single nozzle without a filament-changing mechanism still needs manual filament changes. The upright two-sided design shares many layers between body and lettering, so automated switching is the practical colour-print path. Multiple colours do not require a proprietary printer brand, but they do require a way to supply those filaments.

## Three characters

Text is stacked from point to heel. For `大将軍`, the first entry controls 大, the second 将, and the third 軍. Each face now exposes three entries for glyph size, width, height, X, Y, and rotation. All scale defaults are 1; all offsets and rotations are 0. For shorter inscriptions unused entries do nothing. Longer strings retain neutral values beyond the supplied entries unless the lists are extended in the source.

Automatic font size accounts for the character count. Width Scale only changes width; it does not change height or spacing. The exporter groups all glyphs on a face into one material part, even when their strokes form several disconnected regions.

## Included examples

- **KomaSCAD-colour-base.3mf**: wood body, black 王将, blank reverse. Same dimensions and layout as the base preset, with flush black inlays instead of open recesses.
- **KomaSCAD-three-character-demo.3mf**: purple body and silver 大将軍 on both faces. This is a three-character geometry/material demonstration, not a verified historical piece/promotion prescription.

Reproduce the demonstration with:

```bash
python3 scripts/komascad_export.py --body-colour Purple --front-colour Silver --back-colour 'Same as front' --front-text '大将軍' --back-text '大将軍' --output three-character-demo.3mf
```

For black with glitter lettering, choose Body = Black and Front = Glitter silver or Glitter gold. Choose Back = Same as front if both faces use the same spool.

## Geometry and verification

The exact export parts are complementary volumes sharing boundaries, with no intentional air clearance or overlapping volume. **Face only** partitions a closed `0.8 mm` supporting material region behind the exposed inscription floor while leaving the visible groove depth and body-coloured walls unchanged. Raised text receives the same inward backing rather than an unprintably thin cap. **Painted grooves** colours the walls and retains the inward support. **Flush filled** closes the recess and extends the inlay inward to the same printable thickness. These are **co-printed material regions, not press-fit inserts**. Existing text rounding, taper, scale, and face placement are reused.

The delivered packages were checked for closed, consistently wound material meshes, expected part/material counts, minimum backing thickness, and conserved total volume. A flattened STL of a multipart model can have shared internal surfaces; it is not the distribution format for these material regions. F6 Model remains the single watertight STL output.

The standard colour assignments and multipart structure have been inspected in the generated XML and through independent 3MF/mesh readers. A generated Fire Demon was also sliced successfully with an ordinary 0.4 mm nozzle / 0.20 mm layer profile. Physical spool matching, multicolour tool switching, and a physical print have not been tested here. On systems with Fontconfig tools, the exporter rejects an obvious font-family substitution; this is not a complete rare-glyph or style-coverage check. Review the preview and sliced toolpaths before distributing a whole set.

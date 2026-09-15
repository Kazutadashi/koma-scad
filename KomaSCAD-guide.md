# KomaSCAD — community base, revision 2

A reproducible starting point for a readable, balanced koma in OpenSCAD 2021.01. This revision concentrates on one king, with the controls needed to establish an ordinary shogi set next. It does not claim to reproduce the exact calligraphy in the reference photographs.

## Start in five steps

1. Keep **shogi_piece.scad** and **shogi_piece.json** together. Open the SCAD in OpenSCAD 2021.01, show Customizer, and select **00 Base - King**. If an already-open session shows old presets, reopen the file.
2. Install **Noto Serif CJK JP SemiBold**, or choose your own Japanese font from **Help > Font List**. On Arch, `noto-fonts-cjk` is the official package. The [Arch package page](https://archlinux.org/packages/extra/any/noto-fonts-cjk/) and [upstream font download guide](https://github.com/notofonts/noto-cjk/blob/main/Serif/README.md) provide the sources. Restart OpenSCAD after installing fonts. `fc-match 'Noto Serif CJK JP:style=SemiBold'` should identify the intended family and style. A missing font can silently fall back; rectangles or unexpected Latin shapes are not valid inscriptions.
3. Select **Inspect front**, then F5 and a top view. The black shapes are the actual font outlines. Blue marks the safe margin and centreline; red marks lettering outside that margin. Inspect the back the same way. The external blue bar represents `Reference_Line_Width` at final size; it is not a measured minimum stroke test.
4. Select **Print**, use **Upright**, press F6, then export STL. Inspection is intentionally F5-only: F6 and geometry export reject it. **Blank** exports just the body. Colours do not create a second material.
5. Slice and print one piece before building a set. Judge its lettering at arm's length, the counters between strokes, the edge feel, and its balance on the board.

Command-line export from the folder containing the two files:

```bash
openscad -o king.stl -p shogi_piece.json -P '00 Base - King' shogi_piece.scad
```

## The base design

| Item | Base choice | Reason |
| --- | --- | --- |
| Face inscription | 王将 / blank reverse | A neutral king for establishing the body and a two-character composition |
| Body | 31.5 mm long × 28 mm wide × 9.5 mm heel thickness | Retains the original project's king dimensions; not asserted as a universal historical standard |
| Point thickness | 3 mm before bevel | Allows a more useful web when future pieces receive two-sided recesses |
| Taper | Equal front and back slopes | A simple, comprehensible default; independent reference angles remain available |
| Typeface | Noto Serif CJK JP SemiBold | Reproducible serif starting point, not the photographed brush lettering |
| Layout | Automatic size and spacing, 1.25 front width multiplier | Fills the broad face while leaving breathing room |
| First character | Width ×0.94, height ×0.90 | A slightly narrower, flatter 王 above 将 |
| Recess | 0.8 mm perpendicular to face | A starting depth for later hand colouring |
| Stroke expansion | 0.12 mm outward per contour | Gives fine outlines more presence, while requiring inspection of counters |
| Bevel | 0.35 mm wide, 0.18 mm deep | A small edge break |
| Safe margin | 0.8 mm beyond the flat-face edge | Keeps lettering away from the chamfer |
| Orientation | Upright on the broad heel | Exposes both inscription faces without putting either inscription against the bed |

The original side angles yield a point thickness of about 1.755 mm at the king dimensions. The new base deliberately changes this to 3 mm. The conservative two-sided 0.8 mm recess check leaves approximately 1.03 mm after also allowing for both bevel depths. This is a bound, not a measurement of the exact local web beneath every stroke.

## Tune the composition

The top of the written string is toward the point. `王将` therefore puts 王 above 将. `王` produces one character; no separate one-character switch is necessary. Empty text produces a blank face. Whitespace is still a character and occupies a slot; avoid accidental spaces.

Work in this order: overall position, overall size, spacing, individual glyph proportions, then stroke weight. Inspect again after changing the font: fonts have different geometry even at the same numerical size.

| Desired adjustment | Control and example |
| --- | --- |
| Make both front characters 10% larger | `Front_Text_Scale = 1.10` |
| Use a specific typographic size | Set `Front_Font_Size` above zero; zero restores automatic size |
| Widen lettering without making it taller | Increase `Front_Width_Scale`, e.g. 1.25 to 1.30 |
| Make only the upper character larger | `Front_Glyph_Size = [1.10, 1]` |
| Make only the lower character taller | `Front_Glyph_Height = [0.90, 1.10]` |
| Move the lower character down 0.5 mm | `Front_Glyph_Y = [0, -0.5]` |
| Move the whole inscription toward the point | `Front_Text_Y = 0.5` |
| Increase distance between centres | Increase `Front_Spacing_Scale`, or set explicit `Front_Character_Spacing` |
| Rotate just the upper character | `Front_Glyph_Rotation = [2, 0]` |
| Start a single-character version | Set `Front_Characters = "王"`; reset the first glyph width/height to 1 if you want its natural proportions |
| Suppress a face while retaining its text | Set that face's `Text_Style` to `None` |
| Use another font on the reverse | Set `Back_Font_Override`; an empty override inherits `Font_Name` |

Pairs mean **[first character, second character]**. A single character uses the first entry. Third and later characters use neutral adjustments unless you extend the corresponding numeric lists in the SCAD source. The stacking algorithm accepts longer strings; long names are not guaranteed readable on an ordinary-sized piece. The numeric entries are multipliers, millimetres, or degrees as indicated, not character codes.

X always means the viewer's right on the face being edited; Y points toward the tip. Back text is automatically oriented to read correctly from the reverse with the point up. Do not mirror it manually. Whole-inscription rotation rotates the arrangement around its centre. Glyph offsets are in this arrangement's coordinate system, so they rotate with it. Glyph rotation turns an individual glyph around its own text alignment origin.

`*_Width_Scale` and `*_Height_Scale` change the shapes, not the character-centre spacing. `*_Text_Scale` also changes automatic spacing. With explicit spacing, size and spacing are independent. Optical alignment still depends on the font's metrics; the offsets are provided for that reason.

## Automatic layout: useful, but honest

OpenSCAD 2021.01 is the actual target. This implementation does not depend on newer `textmetrics()` features. Automatic size is an estimate based on character count, face length, body width, and the overall width multiplier. It does not measure glyph bounds, solve kerning, or automatically fit every font to the pentagon. The blue safe-face boundary and red overflow display work on actual 2D outlines.

With `Protect_Face_Edges = true`, printable lettering is intersected with the safe face. **Protection trims overflowing strokes; it does not shrink or move them.** Always correct any red overflow using size, width, spacing, or position before printing. Disabling protection allows intentional edge breaches and can also create detached raised fragments. There is no numerical assertion that rejects all text overflow in this OpenSCAD version.

Likewise, `Stroke_Expansion` is a contour offset, not an automatic minimum-line-width guarantee. Positive values thicken strokes by expanding their boundaries and shrink holes between strokes. Negative values thin the design and can erase fine details. Enlarging a glyph and expanding its strokes are different operations.

## Wood-filament workflow

The intended path is an ordinary single-nozzle printer, wood-filled filament, and optional hand-filled dark recesses. It does not require a colour changer or a proprietary printer. Preview colours are only an inspection aid.

A **0.6 mm reference line width** is used for judging the design. Select nozzle diameter, layer height, and temperatures from the chosen filament's guidance and your printer profile. Many wood-filled materials with larger particles need a 0.6 mm or larger nozzle; [the manufacturer's composite-material guidance](https://help.prusa3d.com/article/composite-materials-with-metal-or-wood-particles_166863) discusses this. A filament specifically approved for a 0.4 mm nozzle can use that setup instead. Line width and nozzle diameter are related but are not the same setting.

Inspect the sliced paths at the fine horizontal strokes, small islands, and counters. A watertight STL cannot guarantee that these features will survive extrusion. On an upright piece, face-normal engraving depth does not correspond directly to a fixed number of Z layers. Print one king and, before committing to the set, one small two-sided pawn. A brim can be added in the slicer if bed adhesion requires it; it is not built into the CAD model.

For stronger visual contrast with one filament, test sealing and hand filling the recesses on a sample before colouring the set. Surface absorption and finishing compatibility depend on the filament and coating. This base has been rendered and geometry-checked, not physically printed or qualified for a particular spool.

## Complete parameter reference

`Front_` and `Back_` controls operate independently. Values are before uniform `Model_Scale`, except `Minimum_Web` and `Reference_Line_Width`, which describe final-size millimetres.

| Parameter(s) | Meaning / precedence |
| --- | --- |
| `Category` | Informational string only. Never selects hidden dimensions. |
| `Front_Characters`, `Back_Characters` | Unicode strings, stacked in order from point to heel; empty means blank. |
| `Font_Name` | Shared installed font family and optional Fontconfig style. |
| `Output_Mode` | Print, Blank, Inspect front, or Inspect back. Inspect is F5-only. |
| `Print_Orientation` | Upright, Back face down, or Design coordinates; ignored by flat inspection views. Raised reverse text cannot use Back face down. |
| `Model_Scale` | Uniformly scales body, lettering, offsets, bevel, and relief. Does not resize only the blank. |
| `Piece_Length`, `Base_Width`, `Rear_Thickness` | Authoritative dimensions in all categories. |
| `Taper_Mode`, `Tip_Thickness` | Tip thickness mode uses equal slopes and ignores the reference side angles. Reference side angles mode derives point thickness and ignores Tip_Thickness. |
| `Front_Font_Size`, `Back_Font_Size` | Zero uses automatic size; positive values use OpenSCAD text size, not measured glyph height. |
| `Front_Text_Scale`, `Back_Text_Scale` | Multiplier on automatic or explicit font size. |
| `Front_Character_Spacing`, `Back_Character_Spacing` | Zero uses automatic spacing; otherwise explicit centre-to-centre distance in face mm. |
| `Front_Spacing_Scale`, `Back_Spacing_Scale` | Multiplies automatic spacing only. Ignored when explicit spacing is positive. |
| `Front_Center_Fraction`, `Back_Center_Fraction` | Centre of character stack as a fraction of the heel-to-point face length. |
| `Front_Text_X`, `Back_Text_X` | Whole-inscription lateral offset in face mm. |
| `Front_Text_Y`, `Back_Text_Y` | Additional whole-inscription offset toward the point, in face mm. |
| `Front_Width_Scale`, `Back_Width_Scale` | Width multiplier for each glyph; automatic font-size estimate also accounts for this multiplier. |
| `Front_Height_Scale`, `Back_Height_Scale` | Height multiplier for each glyph; does not change centres. |
| `Front_Text_Rotation`, `Back_Text_Rotation` | Rotation of the entire layout about its centre. |
| `Front_Glyph_Size`, `Back_Glyph_Size` | Per-character uniform size multipliers. |
| `Front_Glyph_Width`, `Back_Glyph_Width` | Per-character width multipliers. |
| `Front_Glyph_Height`, `Back_Glyph_Height` | Per-character height multipliers. |
| `Front_Glyph_X`, `Back_Glyph_X` | Per-character lateral offsets, in layout mm. |
| `Front_Glyph_Y`, `Back_Glyph_Y` | Per-character offsets toward the point, in layout mm. |
| `Front_Glyph_Rotation`, `Back_Glyph_Rotation` | Per-character rotations in degrees. |
| `Front_Text_Style`, `Back_Text_Style` | Recessed, Raised, or None. Raised text affects surface feel and is not the wood-fill base choice. |
| `Front_Relief_Depth`, `Back_Relief_Depth` | Recess depth or relief height, perpendicular to the face. Zero produces no relief. |
| `Front_Stroke_Expansion`, `Back_Stroke_Expansion` | Contour expansion after glyph scaling, in mm. Negative values thin. |
| `Front_Font_Override`, `Back_Font_Override` | Empty inherits shared font; otherwise overrides it for that face. |
| `Text_Edge_Radius` | Rounded outline corners plus approximate rounded raised tops / recessed bottoms; capped at half relief depth. Narrow strokes may disappear. |
| `Text_Rounding_Steps` | 2–12 layers approximating the rounded profile. Only relevant for a nonzero radius; can significantly slow CGAL rendering. |
| `Bevel_Width`, `Bevel_Depth` | Width is a plan-view inset; depth is a model-Z drop of each rim. Either zero disables the bevel. |
| `Text_Margin` | Extra plan-view inset beyond the flat face; same value on both faces. |
| `Protect_Face_Edges` | Clips print lettering to the safe region; inspection shows original overflow in red. |
| `Minimum_Web` | Conservative minimum remaining solid thickness in model-Z direction, after scaling. Not a slicer wall count. |
| `Angle_Mode` | Selects which plan angle to derive, or checks all three. The derived angle's input field is inactive. |
| `Face_Base_Angle`, `Face_Shoulder_Angle`, `Face_Tip_Angle` | Symmetric pentagon interior angles; must satisfy `2*base + 2*shoulder + tip = 540`. |
| `Front_Side_Base_Angle`, `Back_Side_Base_Angle` | Independent reference side angles, used only in Reference side angles mode. |
| `Body_Colour` | Display colour for the body. |
| `Front_Inscription_Colour`, `Back_Inscription_Colour` | Separate ink colours in inspection; no separate material output. |
| `Show_Layout_Guides` | Shows safe outline, centreline, and reference-width bar in inspection. Red overflow remains visible even when guides are hidden. |
| `Reference_Line_Width` | Final-size width of the external inspection reference bar. Does not alter geometry or set the slicer. |
| `Text_Curve_Resolution` | Curve tessellation for lettering and rounded contours; the body itself is planar. |

## Audit and migration of all original parameters

This is a deliberate preset-schema revision. Do not load the old 216-entry JSON unchanged: category names no longer supply dimensions, and several control names and coordinate meanings have changed. The active JSON now contains exactly one full base preset. The original files remain available through their saved version history.

| Original parameter(s) | Revision 2 decision |
| --- | --- |
| `Category` | Removed hidden category dimensions; retained as a descriptive label. Future named presets must explicitly contain their own dimensions. |
| `Model_Scale` | Retained uniform meaning; final-size web constraint now documented. |
| `Automatic_Text_Layout` | Removed the global all-or-nothing switch. Zero font size and zero spacing choose automation independently per face. Position, proportion, and glyph adjustments remain active. |
| `Front_Characters`, `Back_Characters` | Retained; no hard-coded two-character limit. Blank reverse stays supported. |
| `Font_Name` | Retained; Japanese serif base plus independent optional face overrides. |
| `Front_Font_Size`, `Back_Font_Size` | Retained names; zero now means automatic. Positive values remain typographic sizes. |
| `Front_Character_Spacing`, `Back_Character_Spacing` | Retained names; zero now means automatic. Positive values measure along the face. |
| `Front_Text_Center`, `Back_Text_Center` | Replaced with centre fraction plus Y offset. These adapt to piece length. Old values were measured in plan Y; new distances are face coordinates. |
| `Front_Text_X`, `Back_Text_X` | Retained, including viewer-relative reverse-face coordinates; no longer overridden by automatic layout. |
| `Front_Text_Style`, `Back_Text_Style` | Retained Recessed/Raised and added None. |
| `Front_Engraving_Depth`, `Back_Engraving_Depth` | Renamed to `*_Relief_Depth` to describe both engraving and raised relief. |
| `Text_Edge_Radius` | Retained; radius clamp and feature-loss tradeoff documented. |
| `Text_Curve_Resolution` | Retained as the single curve-quality control. |
| `Text_Rounding_Steps` | Retained bounded layer approximation. Default rounding remains off for speed and detail. |
| `Stroke_Expansion` | Split into front/back controls; applied after glyph scaling. Allows deliberate thinning as well as thickening. |
| `Piece_Length`, `Base_Width`, `Rear_Thickness` | Retained; always authoritative instead of silently replaced by a category. |
| `Bezel_Width`, `Bezel_Depth` | Renamed `Bevel_Width`, `Bevel_Depth`. Preserved their plan-width / model-Z-depth definitions. |
| `Front_Side_Base_Angle`, `Back_Side_Base_Angle` | Retained in explicit reference-angle mode; simple tip-thickness mode is the default. |
| `Face_Base_Angle`, `Face_Shoulder_Angle`, `Face_Tip_Angle` | Retained and validated. |
| `Angle_Mode` | Default changed from Check all three to Derive shoulder; inactive input documented and resolved values echoed. |
| `Output_Mode` | Replaced ambiguous Printable engraved with Print; kept blank output and added individual face inspection. Inspection export is blocked. |
| `Print_Orientation` | Retained Upright / Design coordinates; added Back face down with reverse-relief checks. Typos now reject instead of silently selecting another orientation. |
| `Curve_Resolution` | Removed redundant body-quality control; the pentagonal body has no curved tessellation to tune. |
| `Body_Colour` | Retained, with a wood-toned base. |
| `Inscription_Colour` | Split into front and back inspection colours. |
| `Inspection_Decal_Height`, `Inspection_Decal_Gap` | Removed user-facing controls; inspection layer heights are internal constants. These are drawing details, not koma design choices. |

For a manual migration of an old text centre `y_old`, use `Center_Fraction = 0` and `Text_Y = y_old / cos(atan(face_slope))`. Convert old plan-Y spacing the same way. The new orthonormal face transform intentionally removes the old slight stretching along the sloped face, so final optical tuning is still needed. Set `Taper_Mode = "Reference side angles"` to reproduce old face slopes; the new web assertion can reject old overly thin combinations. Do not weaken that check just to silence a failing preset without inspecting the cross-section.

## Preset organization and next stage

Each preset is a complete, flat OpenSCAD parameter set. There is no custom inheritance mechanism to maintain or install. Keep `fileFormatVersion` as the string `"1"`. Numeric, Boolean, and vector values are represented as strings in the JSON, matching OpenSCAD's preset format.

The single base preset explicitly includes all 71 public parameters and matches the SCAD defaults. For now, save personal tuning under another preset name in Customizer. Once the base passes a physical test, establish separate ordinary-shogi king, rook, bishop, gold, silver, knight, lance, and pawn compositions, including their reverse sides. Size hierarchy and inscription conventions should be reviewed as a set; they are not inferred from category names.

Later, keep one SCAD engine and separate preset files by game or family. A useful future naming scheme is `10 Shogi - King`, `10 Shogi - Pawn`, `20 Chu - ...`, `30 Taikyoku - ...`. Game-specific promotion mappings, variant nomenclature, rare-character font coverage, and historical dimensional choices require their own review. The former 216-entry catalogue has not been treated as a verified source for those details.

## Validation and remaining limits

**24 validation checks passed.** Validation uses OpenSCAD **2021.01** and the stated Noto Serif CJK JP SemiBold font. The base SVG outlines were visually checked, and actual outline subtraction checks test whether they extend beyond the safe face. The printable output is checked for one connected, watertight solid with consistent winding and positive volume. Both face transforms use right-handed orthonormal bases, avoiding mirrored reverse text and wedge-induced glyph stretching.

The checks cover single/two/four-character layouts, a smaller two-sided pawn, blank and unbevelled bodies, mixed raised/recessed lettering, rounded text, reference-angle taper, face-down orientation, scaling, deliberate invalid inputs, margin protection, and rejection of inspection export. These are geometry and regression checks; the experimental pawn is not a delivered shogi-set preset.

The available environment does not provide an X server for OpenSCAD's OpenGL screenshots. The supplied face illustration therefore uses actual OpenSCAD-exported SVG paths composed over the analytic face outline. It is a flat artwork preview, not a photograph, a slicer simulation, or a claim of physical print quality. The GUI widgets have not been interactively exercised on Arch.

The exact brush-style glyphs shown in the references remain a future artwork decision. This revision supports installed fonts, not imported per-piece SVG calligraphy. It does not implement automatic stroke-width repair, font-coverage detection, maker's marks on the heel, multi-material inserts, or bed packing. None is required to evaluate this base's body and lettering controls.

The supplied base STL is the tested single solid: volume approximately **4525.59 mm³**, standing **31.5 mm** tall in Upright orientation. Its smallest build-plate Z coordinate is **0 mm**. The STL includes geometry only.

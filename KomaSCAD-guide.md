# KomaSCAD — community base, revision 3.3.1

A reproducible starting point for a readable, balanced koma in OpenSCAD 2021.01. This revision concentrates on one king, with the controls needed to establish an ordinary shogi set next. It does not claim to reproduce the exact calligraphy in the reference photographs.

## Maker signature in 3.1

Expand **12 - Maker signature on heel**, enable **Signature Enabled**, and enter your name or mark in **Signature Text**. The default is disabled with empty text, so existing pieces are unchanged. This is horizontal text on the broad bottom edge (heel), not an additional inscription on the reverse face. Looking straight at the heel with the front inscription face uppermost, text reads left to right.

Use **Inspect signature** and F5, then a top view, to check the composition. The blue border shows the safe area; red shows overflow. The signature is clipped to that area, not automatically shrunk. Reduce the font size or adjust position when red appears. Rotation is available for unusual layouts. The signature has its own font choice; empty inherits Font Name. It is independent of the front/back glyph layout and does not inherit their stroke expansion or rounding.

| Signature control | Meaning |
| --- | --- |
| `Signature_Enabled` | Off by default; enables the optional mark. |
| `Signature_Text` | Horizontal name, initials, date, or other text; empty leaves no mark. |
| `Signature_Font` | Font family/style; empty inherits shared Font_Name. |
| `Signature_Font_Size` | Typographic size in mm; default 2.5. |
| `Signature_Letter_Spacing` | Unitless spacing multiplier; default 1. |
| `Signature_X` | mm from centre, positive to the viewer’s right. |
| `Signature_Y` | mm across heel thickness, positive toward the front inscription face. |
| `Signature_Rotation` | Degrees counterclockwise as viewed. |
| `Signature_Depth` | mm into heel; default 0.4. Zero creates no mark. |
| `Signature_Margin` | mm protective border; default 0.6. Accounts for the taper over the cut depth. |
| `Signature_Filament` | Colour-workflow material; default Same as front. |
| `Signature_Colour` | Custom RGBA swatch, used when Signature Filament is Custom. |

**Print** engraves the mark; **Blank** remains completely unmarked. **Colour assembly** assigns the mark a fourth possible material region beneath the groove, or fills it when Flush filled is selected. It shares the front material by default, or can use another palette/custom choice. **Colour signature** exports just the aligned signature region. This is a co-printed region, not a loose insert. If signature and face engraving volumes intersect under unusual manual settings, the signature owns the intersection so material volumes do not overlap.

In **Upright** orientation the heel faces the print bed. The signature therefore occupies the first layers; check those sliced layers for legible small features, bridging over recesses, or correct material assignment. The default shallow recess avoids protruding text on the base. Its physical print quality remains untested.

The colour exporter accepts saved signature settings. You can also enable and set a mark directly:

```bash
python3 scripts/komascad_export.py --preset '00 Base - King' --signature-text 'KomaSCAD' --output signed-king.3mf
```

`--signature-colour Gold` can override its material. The supplied signed STL and 3MF are demonstrations using “KomaSCAD”; that name is not inserted into the base preset. Verification checks disabled/empty behaviour, a closed engraved solid with unchanged outer bounds, a signature that fits the safe heel, and colour-part volume conservation. The colour signature occupies 0–0.4 mm above the bed in the Upright demonstration.

## Colour workflow in 3.0

See [KomaSCAD-colour-quickstart.md](KomaSCAD-colour-quickstart.md) for the complete multipart workflow and exporter commands. The **Body_Filament**, **Front_Filament**, and **Back_Filament** dropdowns choose preview swatches and named 3MF materials. Colour assembly uses a lightweight F5 material preview; Colour body/front/back select exact aligned export parts. Use **scripts/komascad_export.py** to retain these materials in a 3MF on OpenSCAD 2021.01. Standard Print/Blank STL exports are retained.

Colour inlays require Recessed or None on active faces and Protect Face Edges enabled. Existing RGBA controls apply when the new Filament choice is Custom. Explicit Same as body/front choices reuse a material. Metallic and glitter finishes depend on filament selection, not rendered texture.

Per-character lists now expose three entries; defaults remain neutral. Older two-entry lists still work because missing entries use neutral values. The exporter accepts saved presets and can override body/front/back colours or strings from the command line.

## Opening the file and units in 2.3

The SCAD contains complete standalone defaults and generates the king without loading JSON or changing a preset. If opening it leaves the viewport empty, press **F5** to initiate Preview. Changing a preset also requests a preview when Customizer's Automatic Preview is enabled; that does not mean the preset is needed to construct the piece. SCAD code cannot trigger its own execution or change the application's preview settings. If geometry has been compiled but is off screen, use **View > View All**.

In Customizer select **Show Details**. Each numeric control now has an adjacent description starting with its units: **mm**, **Degrees**, **Multiplier**, **Fraction**, **Count**, or **RGBA**. Parameter identifiers are unchanged so existing presets continue to work. Unless stated otherwise, mm values are before Model Scale; Minimum Web and Reference Line Width describe final-size mm. Glyph size/width/height entries are multipliers, not millimetres.

## Neutral proportions in 2.2

Front and back now start with identical layout controls: all size/width/height multipliers are 1, and all character offsets and rotations are 0. No king-specific reshaping is applied. Width Scale now changes only glyph width; it no longer reduces automatic font size or changes character spacing. Automatic size still responds to body dimensions and character count. Different glyphs retain their natural font proportions.

Existing saved custom presets can retain the old multipliers. Select the updated **00 Base - King** preset or explicitly reset Front Width Scale to 1 and Front Glyph Width / Height to [1, 1]. These changes preserve the Print preview correction.

## Print preview correction in 2.1

Print mode now explicitly evaluates its Boolean geometry with `render(convexity=30)` before F5 displays it. This avoids relying on the raw OpenCSG preview of the engraved polyhedron. Preview updates may take longer, especially with text rounding enabled. Inspect mode remains available for fast lettering adjustments.

The previous checks validated exported solids but did not validate their OpenGL F5 display. The corrected two-sided 王将 model exports an identical set of triangles to the previous version and remains one watertight solid. An actual OpenGL screenshot could not be obtained in this environment, so GUI confirmation on the user's installation remains necessary. Existing JSON presets are compatible with this correction.

## Start in five steps

1. Keep **shogi_piece.scad** and **shogi_piece.json** together. Open the SCAD in OpenSCAD 2021.01, show Customizer, and press **F5**. Selecting **00 Base - King** is optional; the source defaults match it. If an already-open session shows old presets, reopen the file.
2. Install **Noto Serif CJK JP SemiBold**, or choose your own Japanese font from **Help > Font List**. On Arch, `noto-fonts-cjk` is the official package. The [Arch package page](https://archlinux.org/packages/extra/any/noto-fonts-cjk/) and [upstream font download guide](https://github.com/notofonts/noto-cjk/blob/main/Serif/README.md) provide the sources. Restart OpenSCAD after installing fonts. `fc-match 'Noto Serif CJK JP:style=SemiBold'` should identify the intended family and style. A missing font can silently fall back; rectangles or unexpected Latin shapes are not valid inscriptions.
3. Select **Inspect front**, then F5 and a top view. The black shapes are the actual font outlines. Blue marks the safe margin and centreline; red marks lettering outside that margin. Inspect the back the same way. The external blue bar represents `Reference_Line_Width` at final size; it is not a measured minimum stroke test.
4. Select **Print**, use **Upright**, press F6, then export STL. Inspection is intentionally F5-only: F6 and geometry export reject it. **Blank** exports just the body. In Print/Blank, colours do not create a second material; use the separate colour workflow for multipart output.
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
| Layout | Automatic size and spacing; identical front/back controls | Predictable starting point for any inscription |
| Character proportions | All width/height multipliers are 1 | Preserves the font’s natural proportions |
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
| Widen lettering without making it taller | Increase `Front_Width_Scale`, e.g. 1 to 1.10 |
| Make only the upper character larger | `Front_Glyph_Size = [1.10, 1]` |
| Make only the lower character taller | `Front_Glyph_Height = [1, 1.10]` |
| Move the lower character down 0.5 mm | `Front_Glyph_Y = [0, -0.5]` |
| Move the whole inscription toward the point | `Front_Text_Y = 0.5` |
| Increase distance between centres | Increase `Front_Spacing_Scale`, or set explicit `Front_Character_Spacing` |
| Rotate just the upper character | `Front_Glyph_Rotation = [2, 0]` |
| Start a single-character version | Set `Front_Characters = "王"`; neutral glyph multipliers already preserve its natural proportions |
| Suppress a face while retaining its text | Set that face's `Text_Style` to `None` |
| Use another font on the reverse | Set `Back_Font_Override`; an empty override inherits `Font_Name` |

Lists mean **[first character, second character, third character]**. A single character uses the first entry. The third character has its own controls. Fourth and later characters use neutral adjustments unless you extend the corresponding numeric lists in the SCAD source. The stacking algorithm accepts longer strings; long names are not guaranteed readable on an ordinary-sized piece. The numeric entries are multipliers, millimetres, or degrees as indicated, not character codes.

X always means the viewer's right on the face being edited; Y points toward the tip. Back text is automatically oriented to read correctly from the reverse with the point up. Do not mirror it manually. Whole-inscription rotation rotates the arrangement around its centre. Glyph offsets are in this arrangement's coordinate system, so they rotate with it. Glyph rotation turns an individual glyph around its own text alignment origin.

`*_Width_Scale` and `*_Height_Scale` change the shapes, not the character-centre spacing. `*_Text_Scale` also changes automatic spacing. With explicit spacing, size and spacing are independent. Optical alignment still depends on the font's metrics; the offsets are provided for that reason.

## Automatic layout: useful, but honest

OpenSCAD 2021.01 is the actual target. This implementation does not depend on newer `textmetrics()` features. Automatic size is an estimate based on character count, face length, body width. It does not measure glyph bounds, solve kerning, or automatically fit every font to the pentagon. The blue safe-face boundary and red overflow display work on actual 2D outlines.

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
| `Output_Mode` | Print/Blank; Inspect front/back/signature/pawn circle; Colour assembly/body/front/back/signature. All Inspect views and Colour assembly are F5-only. Use the exporter for colour 3MF. |
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
| `Front_Width_Scale`, `Back_Width_Scale` | Width multiplier for each glyph; does not change font size, height, or character spacing. |
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
| `Body_Colour` | Custom body RGBA swatch, used when Body_Filament is Custom. |
| `Front_Inscription_Colour`, `Back_Inscription_Colour` | Custom front/back RGBA swatches, used when the respective Filament choice is Custom. |
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

The single base preset explicitly includes all 88 public parameters and matches the SCAD defaults. For now, save personal tuning under another preset name in Customizer. Once the base passes a physical test, establish separate ordinary-shogi king, rook, bishop, gold, silver, knight, lance, and pawn compositions, including their reverse sides. Size hierarchy and inscription conventions should be reviewed as a set; they are not inferred from category names.

Later, keep one SCAD engine and separate preset files by game or family. A useful future naming scheme is `10 Shogi - King`, `10 Shogi - Pawn`, `20 Chu - ...`, `30 Taikyoku - ...`. Game-specific promotion mappings, variant nomenclature, rare-character font coverage, and historical dimensional choices require their own review. The former 216-entry catalogue has not been treated as a verified source for those details.

## Validation and remaining limits

**The initial release passed 24 validation checks.** Validation uses OpenSCAD **2021.01** and the stated Noto Serif CJK JP SemiBold font. The base SVG outlines were visually checked, and actual outline subtraction checks test whether they extend beyond the safe face. The printable output is checked for one connected, watertight solid with consistent winding and positive volume. Both face transforms use right-handed orthonormal bases, avoiding mirrored reverse text and wedge-induced glyph stretching.

The checks cover single/two/four-character layouts, a smaller two-sided pawn, blank and unbevelled bodies, mixed raised/recessed lettering, rounded text, reference-angle taper, face-down orientation, scaling, deliberate invalid inputs, margin protection, and rejection of inspection export. These are geometry and regression checks; the experimental pawn is not a delivered shogi-set preset.

The available environment does not provide an X server for OpenSCAD's OpenGL screenshots. The supplied face illustration therefore uses actual OpenSCAD-exported SVG paths composed over the analytic face outline. It is a flat artwork preview, not a photograph, a slicer simulation, or a claim of physical print quality. The GUI widgets have not been interactively exercised on Arch.

The exact brush-style glyphs shown in the references remain a future artwork decision. This revision supports installed fonts, not imported per-piece SVG calligraphy. It does not implement automatic stroke-width repair, complete font-coverage detection, loose press-fit inserts, or bed packing. Co-printed colour inlays are supported in revision 3.0. None is required to evaluate this base's body and lettering controls.

The supplied base STL is a tested single solid, standing **31.5 mm** tall in Upright orientation. Its smallest build-plate Z coordinate is **0 mm**. The STL includes geometry only.

Revision 2.2 verification: matching front/back strings produce identical raw 2D outlines at the default symmetric taper. Width adjustment no longer changes the resolved automatic font size or spacing. The updated base was re-exported and checked as one watertight solid.

| New colour parameter | Meaning |
| --- | --- |
| `Body_Filament` | Palette/custom choice or generic Filament 1/2/3 for the body. |
| `Front_Filament` | Palette/custom choice or Same as body for front lettering. |
| `Back_Filament` | Palette/custom choice, Same as body, or Same as front for reverse lettering. |

## Pawn Circle — revision 3.2

Enable **Pawn Circle** in **10 - Advanced shape angles**. It is off by default, so existing designs stay unchanged. The default 81° / 117° / 144° base already satisfies it. Select **Inspect pawn circle** and press F5 (then View All if needed) for a diagram of twenty copies of the current outline. This view is deliberately blocked from STL export; choose Print to export one piece.

The name is descriptive: we could not verify a formal Japanese name for this arrangement. [Itsutsu's explanation](https://www.i-tsu-tsu.co.jp/blog/tools-of/) describes twenty pieces and ideal face angles of 81°, 117°, and 144°. Twenty pawns means eighteen playing pawns plus two spares; the [Japan Shogi Association's title-match report](https://kifulog.shogi.or.jp/oui/2018/08/post-db22.html) notes that two spare pawns are usual for title-match sets. This is a useful geometric check, not a complete certification of craftsmanship.

**Angle Mode determines which inputs you retain.** Nothing silently rewrites your Customizer values. Resolved angles and ring diameters appear in the Console after preview.

| Angle Mode | Supplied angles | Circle behaviour |
|---|---|---|
| Derive shoulder | Base and tip | Base must be 81°; shoulder = (378° − tip)/2. Shoulder field is unused. |
| Derive tip | Base and shoulder | Base must be 81°; tip = 378° − 2 × shoulder. Tip field is unused. |
| Derive base | Shoulder and tip | Base is solved as 81°; supplied shoulder and tip must satisfy 2 × shoulder + tip = 378°. Base field is unused. |
| Check all three | All three | Base must be 81° and the pentagon must close. |

Incompatible inputs stop preview/export with an error explaining the required relationship. The solver also keeps the existing convex-shape, thickness, bevel, and printable-web checks. For example, base 80° is incompatible with a twenty-piece circle; shoulder 119° with tip 140° is a valid alternative at base 81°. Shoulder and tip are not uniquely fixed by ring closure alone.

### What is exact?

The constraint is on the **design-plan outline**, the same plane used by the existing face-angle controls. Twenty identical pentagons sit point-inward with their long sides touching. Each neighbour turns `180° − 2 × base = 18°`, and twenty turns give 360°. The outer heels form a regular twenty-sided polygon whose corners lie on a circle; straight-edged pieces do not produce a mathematically smooth circular perimeter.

For heel width W and length L, the ring centre is W/(2 tan 9°) from the heel midpoint. L must be smaller than that distance, otherwise tips reach or cross the centre. The reported outer diameter is W/sin 9°; the inner tip-circle diameter is 2 × (W/(2 tan 9°) − L). Both reports include Model Scale and use mm.

This derivation applies equally to twenty identical kings or other sizes. A normal set contains too few identical larger pieces for that demonstration. Mixing different dimensions does not have the same guarantee. Thickness-taper angles are independent and are not solved by this toggle. The inspection diagram omits bevels and thickness; placing a sloped back face flat on a table changes its projected footprint. Bevel seams, printed tolerances, warping, and final sanding still affect physical fit. The toggle guarantees the nominal plan geometry, not a gap-free three-dimensional ring in every resting orientation.

Validation: all four angle modes, incompatible inputs, alternative compatible tip/shoulder angles, a watertight rendered STL, unchanged default geometry, and independent twenty-piece contact/overlap checks for pawn and king dimensions. Colour export uses the same validated geometry.


## Mirror Front Settings — revision 3.3

In **04 - Back layout**, enable **Mirror Front Settings** to make the back follow the front. This links settings; it does not reflect glyphs or make the letters read backwards. It is off by default.

Linked settings: font override, font size, text and spacing scales, character spacing, centre fraction, X/Y offsets, width/height scales, rotation, all per-character adjustments, text style (recessed/raised/none), relief depth and stroke expansion. Shared model-wide controls already apply to both faces.

The back keeps its own characters, filament/colour and body taper. A blank reverse stays blank. X remains the viewer's right on each face, so matching offsets look the same when each face is viewed directly. Per-character settings follow the character's position from tip to heel, including a third character.

The back controls remain visible because OpenSCAD 2021.01 cannot dynamically hide them; they are ignored while the link is enabled. Their stored values are preserved, and disabling the toggle restores them. A Console message confirms that linking is active. Save your preset to use the link in the 3MF exporter.

Automatic font sizing still adapts separately to each face's character count and length. For equal typographic sizes on a one-character front and three-character back, enter an explicit positive Front Font Size; likewise set Front Character Spacing explicitly if you want a fixed spacing. Inspect both faces for overflow. All size and position controls keep their existing units.


## Colour assembly and F6 — revision 3.3.1

Colour assembly is **F5 preview only**. Its preview intentionally leaves the aligned material regions as interactive OpenCSG operations instead of converting every part to a closed CGAL mesh. F6 would union the touching material parts, lose their separation, and can trigger a CGAL precondition failure, so the model blocks that route. Use Print for an engraved STL, or the Python exporter for multipart colour 3MF. Individual Colour body/front/back/signature modes still produce exact closed, aligned STL geometry for the exporter.

This guard prevents the assembly union path; it does not repair every possible CGAL failure in a complex font or individual part. If an error also occurs in F5 or separate-part export, retain the selected preset and font details for diagnosis.

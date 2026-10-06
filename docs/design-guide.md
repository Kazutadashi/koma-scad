# KomaSCAD design guide

How the piece is shaped and lettered, and what each group of controls does. For a first piece, follow the five steps below; for whole sets, see the [user guide](user-guide.md). The design aims at a readable, balanced koma in OpenSCAD 2021.01; it does not claim to reproduce any particular historical calligraphy.

## Start in five steps

1. Keep **shogi_piece.scad** and **shogi_piece.json** together. Open the SCAD in OpenSCAD 2021.01 and show Customizer. It starts in Model and displays automatically when **Design → Automatic Preview** is enabled; F5 is only the manual fallback. Selecting a preset is optional: the source defaults already produce a king. If an already-open session shows old presets, reopen the file.
2. Install **Noto Serif CJK JP SemiBold**, or choose your own Japanese font from **Help > Font List**. On Arch, `noto-fonts-cjk` is the official package. The [Arch package page](https://archlinux.org/packages/extra/any/noto-fonts-cjk/) and [upstream font download guide](https://github.com/notofonts/noto-cjk/blob/main/Serif/README.md) provide the sources. Restart OpenSCAD after installing fonts. `fc-match 'Noto Serif CJK JP:style=SemiBold'` should identify the intended family and style. A missing font can silently fall back; rectangles or unexpected Latin shapes are not valid inscriptions.
3. Select **Inspect front**, then F5 and a top view. The black shapes are the actual font outlines. Blue marks the safe margin and centerline; red marks lettering outside that margin. Inspect the back the same way. The external blue bar represents `Reference_Line_Width` at final size; it is not a measured minimum stroke test.
4. Return to **Model** and choose the material colors. For a single-material file, use Upright, press F6, then export STL. For the displayed materials, save the preset and run `python3 komascad.py export`. Inspection is intentionally F5-only; **Blank** exports just the unlettered body.
5. Slice and print one piece before building a set. Judge its lettering at arm's length, the counters between strokes, the edge feel, and its balance on the board.

Command-line export from the folder containing the two files:

```bash
openscad -o king.stl -p shogi_piece.json -P 'Shogi 01 - King (Osho)' shogi_piece.scad
```

## Opening the file and units

The SCAD contains complete standalone defaults and generates the king without loading JSON or changing a preset. **Model is the main workspace**, and every bundled preset is saved in Model. With Customizer's **Automatic Preview** enabled, opening the file or selecting a preset immediately requests its fast geometry-and-material preview; F5 is only the manual fallback when that application setting is disabled. SCAD code cannot turn an OpenSCAD application setting back on. If geometry has been compiled but is off screen, use **View > View All**.

In Customizer select **Show Details**. Each numeric control has an adjacent description starting with its units: **mm**, **Degrees**, **Multiplier**, **Fraction**, **Count**, or **RGBA**. Unless stated otherwise, mm values are before Model Scale; Minimum Web and Reference Line Width describe final-size mm. Glyph size/width/height entries are multipliers, not millimeters.

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
| Recess | 0.2 mm perpendicular to face | A shallow starting depth for printing fine inscriptions |
| Stroke expansion | 0.12 mm outward per contour | Gives fine outlines more presence, while requiring inspection of counters |
| Bevel | 0.35 mm wide, 0.18 mm deep | A small edge break |
| Safe margin | 0.8 mm beyond the flat-face edge | Keeps lettering away from the chamfer |
| Orientation | Upright on the broad heel | Exposes both inscription faces without putting either inscription against the bed |

The original side angles yield a point thickness of about 1.755 mm at the king dimensions. The new base deliberately changes this to 3 mm. The conservative two-sided 0.2 mm recess check leaves approximately 2.24 mm after also allowing for both bevel depths. This is a bound, not a measurement of the exact local web beneath every stroke.

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
| Increase distance between centers | Increase `Front_Spacing_Scale`, or set explicit `Front_Character_Spacing` |
| Rotate just the upper character | `Front_Glyph_Rotation = [2, 0]` |
| Start a single-character version | Set `Front_Characters = "王"`; neutral glyph multipliers already preserve its natural proportions |
| Suppress a face while retaining its text | Set that face's `Text_Style` to `None` |
| Use another font on the reverse | Set `Back_Font_Override`; an empty override inherits `Font_Name` |

Lists mean **[first character, second character, third character]**. A single character uses the first entry. The third character has its own controls. Fourth and later characters use neutral adjustments unless you extend the corresponding numeric lists in the SCAD source. The stacking algorithm accepts longer strings; long names are not guaranteed readable on an ordinary-sized piece. The numeric entries are multipliers, millimeters, or degrees as indicated, not character codes.

X always means the viewer's right on the face being edited; Y points toward the tip. Back text is automatically oriented to read correctly from the reverse with the point up. Do not mirror it manually. Whole-inscription rotation rotates the arrangement around its center. Glyph offsets are in this arrangement's coordinate system, so they rotate with it. Glyph rotation turns an individual glyph around its own text alignment origin.

`*_Width_Scale` and `*_Height_Scale` change the shapes, not the character-center spacing. `*_Text_Scale` also changes automatic spacing. With explicit spacing, size and spacing are independent. Optical alignment still depends on the font's metrics; the offsets are provided for that reason.

## Neutral proportions

Front and back start with identical layout controls: all size/width/height multipliers are 1, and all character offsets and rotations are 0. No king-specific reshaping is applied. Width Scale changes only glyph width; it does not reduce automatic font size or change character spacing. Automatic size still responds to body dimensions and character count. Different glyphs retain their natural font proportions.

## Automatic layout: useful, but honest

OpenSCAD 2021.01 is the actual target. This implementation does not depend on newer `textmetrics()` features. Automatic size is an estimate based on character count, face length, body width. It does not measure glyph bounds, solve kerning, or automatically fit every font to the pentagon. The blue safe-face boundary and red overflow display work on actual 2D outlines.

With `Protect_Face_Edges = true`, printable lettering is intersected with the safe face. **Protection trims overflowing strokes; it does not shrink or move them.** Always correct any red overflow using size, width, spacing, or position before printing. Disabling protection allows intentional edge breaches and can also create detached raised fragments. There is no numerical assertion that rejects all text overflow in this OpenSCAD version.

Likewise, `Stroke_Expansion` is a contour offset, not an automatic minimum-line-width guarantee. Positive values thicken strokes by expanding their boundaries and shrink holes between strokes. Negative values thin the design and can erase fine details. Enlarging a glyph and expanding its strokes are different operations.

## Mirror Front Settings

In **04 - Back layout**, enable **Mirror Front Settings** to make the back follow the front. This links settings; it does not reflect glyphs or make the letters read backwards. It is off by default.

Linked settings: font override, font size, text and spacing scales, character spacing, center fraction, X/Y offsets, width/height scales, rotation, all per-character adjustments, text style (recessed/raised/none), relief depth and stroke expansion. Shared model-wide controls already apply to both faces.

The back keeps its own characters, filament/color and body taper. A blank reverse stays blank. X remains the viewer's right on each face, so matching offsets look the same when each face is viewed directly. Per-character settings follow the character's position from tip to heel, including a third character.

The back controls remain visible because OpenSCAD 2021.01 cannot dynamically hide them; they are ignored while the link is enabled. Their stored values are preserved, and disabling the toggle restores them. A Console message confirms that linking is active. Save your preset to use the link in the 3MF exporter.

Automatic font sizing still adapts separately to each face's character count and length. For equal typographic sizes on a one-character front and three-character back, enter an explicit positive Front Font Size; likewise set Front Character Spacing explicitly if you want a fixed spacing. Inspect both faces for overflow. All size and position controls keep their existing units.

## Maker signature

Expand **12 - Maker signature on heel**, enable **Signature Enabled**, and enter your name or mark in **Signature Text**. The default is disabled with empty text. This is horizontal text on the broad bottom edge (heel), not an additional inscription on the reverse face. Looking straight at the heel with the front inscription face uppermost, text reads left to right.

Use **Inspect signature** and F5, then a top view, to check the composition. The blue border shows the safe area; red shows overflow. The signature is clipped to that area, not automatically shrunk. Reduce the font size or adjust position when red appears. Rotation is available for unusual layouts. The signature has its own font choice; empty inherits Font Name. It is independent of the front/back glyph layout and does not inherit their stroke expansion or rounding.

| Signature control | Meaning |
| --- | --- |
| `Signature_Enabled` | Off by default; enables the optional mark. |
| `Signature_Text` | Horizontal name, initials, date, or other text; empty leaves no mark. |
| `Signature_Font` | Font family/style; empty inherits shared Font_Name. |
| `Signature_Font_Size` | Typographic size in mm; default 2.5. |
| `Signature_Letter_Spacing` | Unitless spacing multiplier; default 1. |
| `Signature_X` | mm from center, positive to the viewer’s right. |
| `Signature_Y` | mm across heel thickness, positive toward the front inscription face. |
| `Signature_Rotation` | Degrees counterclockwise as viewed. |
| `Signature_Depth` | mm into heel; default 0.4. Zero creates no mark. |
| `Signature_Margin` | mm protective border; default 0.6. Accounts for the taper over the cut depth. |
| `Signature_Filament` | Color-workflow material; default Same as front. |
| `Signature_Color` | Custom RGBA swatch, used when Signature Filament is Custom. |

**Model** is the unified geometry, font and material workspace; **Blank** remains completely unmarked. By default, Face only assigns each inscription a slicer-safe supporting material region behind its visible groove floor while leaving the groove walls in the body material. Painted grooves can color those walls; Flush filled closes the groove with a level inlay. The signature shares the front material by default or can use another palette/custom choice. Export parts are internal implementation modes rather than Customizer choices. These are co-printed regions, not loose inserts; explicit material priority prevents overlap where unusual manual settings make regions meet.

In **Upright** orientation the heel faces the print bed. The signature therefore occupies the first layers; check those sliced layers for legible small features, bridging over recesses, or correct material assignment. The default shallow recess avoids protruding text on the base.

The color exporter accepts saved signature settings. You can also enable and set a mark directly:

```bash
python3 komascad.py export shogi "King (Osho)" --signature-text 'KomaSCAD'
```

`--signature-color Gold` can override its material.

## Pawn Circle

Enable **Pawn Circle** in **10 - Advanced shape angles**. It is off by default. The default 81° / 117° / 144° base already satisfies it. Select **Inspect pawn circle** and press F5 (then View All if needed) for a diagram of twenty copies of the current outline. This view is deliberately blocked from STL export; return to Model to export one piece.

The name is descriptive: we could not verify a formal Japanese name for this arrangement. [Itsutsu's explanation](https://www.i-tsu-tsu.co.jp/blog/tools-of/) describes twenty pieces and ideal face angles of 81°, 117°, and 144°. Twenty pawns means eighteen playing pawns plus two spares; the [Japan Shogi Association's title-match report](https://kifulog.shogi.or.jp/oui/2018/08/post-db22.html) notes that two spare pawns are usual for title-match sets. This is a useful geometric check, not a complete certification of craftsmanship.

**Angle Mode determines which inputs you retain.** Nothing silently rewrites your Customizer values. Resolved angles and ring diameters appear in the Console after preview.

| Angle Mode | Supplied angles | Circle behavior |
|---|---|---|
| Derive shoulder | Base and tip | Base must be 81°; shoulder = (378° − tip)/2. Shoulder field is unused. |
| Derive tip | Base and shoulder | Base must be 81°; tip = 378° − 2 × shoulder. Tip field is unused. |
| Derive base | Shoulder and tip | Base is solved as 81°; supplied shoulder and tip must satisfy 2 × shoulder + tip = 378°. Base field is unused. |
| Check all three | All three | Base must be 81° and the pentagon must close. |

Incompatible inputs stop preview/export with an error explaining the required relationship. The solver also keeps the existing convex-shape, thickness, bevel, and printable-web checks. For example, base 80° is incompatible with a twenty-piece circle; shoulder 119° with tip 140° is a valid alternative at base 81°. Shoulder and tip are not uniquely fixed by ring closure alone.

### What is exact?

The constraint is on the **design-plan outline**, the same plane used by the existing face-angle controls. Twenty identical pentagons sit point-inward with their long sides touching. Each neighbour turns `180° − 2 × base = 18°`, and twenty turns give 360°. The outer heels form a regular twenty-sided polygon whose corners lie on a circle; straight-edged pieces do not produce a mathematically smooth circular perimeter.

For heel width W and length L, the ring center is W/(2 tan 9°) from the heel midpoint. L must be smaller than that distance, otherwise tips reach or cross the center. The reported outer diameter is W/sin 9°; the inner tip-circle diameter is 2 × (W/(2 tan 9°) − L). Both reports include Model Scale and use mm.

This derivation applies equally to twenty identical kings or other sizes. A normal set contains too few identical larger pieces for that demonstration. Mixing different dimensions does not have the same guarantee. Thickness-taper angles are independent and are not solved by this toggle. The inspection diagram omits bevels and thickness; placing a sloped back face flat on a table changes its projected footprint. Bevel seams, printed tolerances, warping, and final sanding still affect physical fit. The toggle guarantees the nominal plan geometry, not a gap-free three-dimensional ring in every resting orientation.

## Model preview path

Model uses a driver-safe visual proxy during automatic/F5 preview and leaves exact solid evaluation to F6 or the exporter. For each recessed side, it rebuilds an open face as a thin skin with a fast 2D glyph cutout, then draws the walls and color floor at the selected relief depth. The heel signature uses the same treatment. Face opening and floor outlines respond to Text Edge Radius; raised relief remains additive. Body, front, back and signature surfaces use their selected material colors. This avoids the driver-dependent blank viewport that some OpenSCAD 2021/OpenCSG combinations produce after 3D transformed-text subtraction while retaining useful modeling feedback.

The preview-only proxy does not change the body, text depth, face placement, or exact export geometry. Automatic display still depends on OpenSCAD's Automatic Preview setting; the SCAD model cannot enable that application preference itself.

## Color workflow

See [the color quickstart](color-quickstart.md) for exporter commands. The **Body_Filament**, **Front_Filament**, and **Back_Filament** dropdowns update Model immediately and become named 3MF materials with standard object-level color properties. Compatible slicers use those properties to create logical filament assignments automatically. Use **komascad.py export** for color 3MF; use F6 Model for one single-material STL.

Face only is the default: it preserves Model's relief geometry and assigns a closed `0.8 mm` supporting region behind the visible inscription surface. Recessed walls remain body material; raised text continues inward into the body instead of becoming a fragile `0.2 mm` cap. Painted grooves colors the walls too. Flush filled requires Recessed or None and extends the level inlay inward to the same printable thickness. These internal dimensions require no user tuning. Existing RGBA controls apply when the Filament choice is Custom. Explicit Same as body/front choices reuse a material. Metallic and glitter finishes depend on filament selection, not rendered texture.

Per-character lists expose three entries with neutral defaults; missing entries use neutral values. The exporter accepts saved presets and can override body/front/back colors or strings from the command line.

## How color export works

There are no separate color or material-part modes to switch to. Model already shows the selected materials on its open-face preview. F6 Model produces the exact one-piece solid for STL; `komascad.py export` privately selects the body/front/back/signature modes and packages their aligned closed meshes as 3MF components. This separation prevents OpenSCAD from unioning touching materials while keeping technical modes out of the normal workflow.

The default Face only export uses a direct complementary partition. A recessed floor gets `0.8 mm` of inward material support beyond the visible cavity; raised text includes the relief plus the same inward support. Flush inlays also extend `0.8 mm` inward. Front, back and signature priority prevents overlap, and the parts conserve Model's total volume. Rounded or unusually edge-adjacent configurations automatically use the general exact path; there is no performance switch for the user to manage.

This guard prevents the assembly union path; it does not repair every possible CGAL failure in a complex font or individual part. If an error also occurs in F5 or separate-part export, retain the selected preset and font details for diagnosis.

## Single-filament workflow

The simplest path is an ordinary single-nozzle printer, wood-filled filament, and optional hand-filled dark recesses. It does not require a color changer or a proprietary printer. Preview colors are only an inspection aid.

A **0.6 mm reference line width** is used for judging the design. Select nozzle diameter, layer height, and temperatures from the chosen filament's guidance and your printer profile. Many wood-filled materials with larger particles need a 0.6 mm or larger nozzle; [the manufacturer's composite-material guidance](https://help.prusa3d.com/article/composite-materials-with-metal-or-wood-particles_166863) discusses this. A filament specifically approved for a 0.4 mm nozzle can use that setup instead. Line width and nozzle diameter are related but are not the same setting.

Inspect the sliced paths at the fine horizontal strokes, small islands, and counters. A watertight STL cannot guarantee that these features will survive extrusion. On an upright piece, face-normal engraving depth does not correspond directly to a fixed number of Z layers. Print one king and, before committing to the set, one small two-sided pawn. A brim can be added in the slicer if bed adhesion requires it; it is not built into the CAD model.

For stronger visual contrast with one filament, test sealing and hand filling the recesses on a sample before coloring the set. Surface absorption and finishing compatibility depend on the filament and coating. For multicolor printing, see the [print guide](printing/print-guide.md).

## Limits

OpenSCAD 2021.01 is the target. The design supports installed fonts, not imported per-piece SVG calligraphy. It does not implement automatic stroke-width repair, complete font-coverage detection, loose press-fit inserts, or optimized bed packing.

Automatic size is an estimate, protection trims overflowing strokes without shrinking them, and a watertight model cannot guarantee that fine strokes survive extrusion. Inspect both faces, check the sliced toolpaths, and print one piece before a set.

Every parameter, with its default, is listed in the [parameter reference](parameters.md).

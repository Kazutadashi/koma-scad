# Parameter index — 3.3.1

All 88 public controls in `shogi_piece.scad`. Search this page for a name or keyword. Customizer displays underscores as spaces. Values below are source defaults; a saved preset may override them. Units are before Model Scale unless stated otherwise.

See the [design guide](../KomaSCAD-guide.md) for geometry and the [colour quickstart](../KomaSCAD-colour-quickstart.md) for 3MF export.

## 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Category` | `"Base / King"` | Informational label ONLY. Dimensions below are always authoritative. |
| `Front_Characters` | `"王将"` |  |
| `Back_Characters` | `""` | Empty string makes a blank reverse. Characters are stacked from tip to heel. |
| `Font_Name` | `"Noto Serif CJK JP:style=SemiBold"` | Install this font or select an installed Japanese font via Help > Font List. |
| `Output_Mode` | `"Print"` | Print/Blank export ordinary STL. Colour assembly is F5-only and previews flush inlays; use komascad_export.py for coloured 3MF. Colour body/front/back export aligned parts. |
| `Print_Orientation` | `"Upright"` | Upright: broad heel on bed. Back face down: usually unsuitable for an engraved reverse. |
| `Model_Scale` | `1` | Multiplier (unitless) — 1 = original dimensions; 2 = double all lengths. |
## 02 - Piece dimensions

| Parameter | Default | Description |
| --- | --- | --- |
| `Piece_Length` | `31.5` | mm — Heel-to-point length in plan view. |
| `Base_Width` | `28` | mm — Width across the broad heel. |
| `Rear_Thickness` | `9.5` | mm — Thickness at the broad heel. Thickness at the broad heel; not the thickness near the point. |
| `Taper_Mode` | `"Tip thickness"` | Simple taper controls the actual thickness at the point; faces taper equally. |
| `Tip_Thickness` | `3` | mm — Thickness at the point before bevel. |
## 03 - Front layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Font_Size` | `0` | mm — Typographic size, not measured glyph height; 0 = automatic. 0 selects a size based on piece dimensions and character count; positive mm overrides it. |
| `Front_Text_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Multiplies automatic OR explicit font size. All adjustments remain active. |
| `Front_Character_Spacing` | `0` | mm — Centre-to-centre distance along the face; 0 = automatic. 0 selects centre-to-centre spacing automatically; positive mm overrides it. |
| `Front_Spacing_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing. In auto spacing, multiply the nominal spacing; does not resize characters. |
| `Front_Center_Fraction` | `0.46` | Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway. Fraction of face length from broad heel to point. 0.46 is slightly below centre. |
| `Front_Text_X` | `0` | mm — Whole inscription shift; positive = viewer’s right. Positive X = viewer's right; positive Y = toward the point, measured along the face. |
| `Front_Text_Y` | `0` | mm — Whole inscription shift; positive = toward the point. |
| `Front_Width_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Width changes glyph width only; it never changes font size or spacing. |
| `Front_Height_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Front_Text_Rotation` | `0` | Degrees — rotates the whole inscription counterclockwise as viewed. Rotation in degrees about the inscription centre, counterclockwise as viewed. |
## 04 - Back layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Mirror_Front_Settings` | `false` | Link back typography and engraving to front settings. Back text, colour and body taper stay independent. Back controls remain visible but are unused while enabled; disable to restore them. This does not reflect the lettering. |
| `Back_Font_Size` | `0` | mm — Typographic size, not measured glyph height; 0 = automatic. |
| `Back_Text_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Back_Character_Spacing` | `0` | mm — Centre-to-centre distance along the face; 0 = automatic. |
| `Back_Spacing_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing. |
| `Back_Center_Fraction` | `0.46` | Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway. |
| `Back_Text_X` | `0` | mm — Whole inscription shift; positive = viewer’s right. Coordinates are seen from the reverse. Do not mirror the characters manually. |
| `Back_Text_Y` | `0` | mm — Whole inscription shift; positive = toward the point. |
| `Back_Width_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Back_Height_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Back_Text_Rotation` | `0` | Degrees — rotates the whole inscription counterclockwise as viewed. |
## 05 - Front character adjustments

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Glyph_Size` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. Each pair is [first, second, third; written from point to heel]. Single-character text uses the FIRST entry. Three entries are provided. For two characters, the third is unused; further characters use neutral values. |
| `Front_Glyph_Width` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. |
| `Front_Glyph_Height` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. |
| `Front_Glyph_X` | `[0, 0, 0]` | mm — Per-character lateral offsets [first, second, third]. Independent offsets in face mm; positive Y moves toward the point. |
| `Front_Glyph_Y` | `[0, 0, 0]` | mm — Per-character offsets toward the point [first, second, third]. |
| `Front_Glyph_Rotation` | `[0, 0, 0]` | Degrees — individual character rotations [first, second, third]. |
## 06 - Back character adjustments

| Parameter | Default | Description |
| --- | --- | --- |
| `Back_Glyph_Size` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. |
| `Back_Glyph_Width` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. |
| `Back_Glyph_Height` | `[1, 1, 1]` | Multipliers (unitless) — [first, second, third]; 1 = unchanged. |
| `Back_Glyph_X` | `[0, 0, 0]` | mm — Per-character lateral offsets [first, second, third]. |
| `Back_Glyph_Y` | `[0, 0, 0]` | mm — Per-character offsets toward the point [first, second, third]. |
| `Back_Glyph_Rotation` | `[0, 0, 0]` | Degrees — individual character rotations [first, second, third]. |
## 07 - Filament colours

| Parameter | Default | Description |
| --- | --- | --- |
| `Body_Filament` | `"Wood"` | Preview swatch and 3MF material label, not a printer slot. Custom uses Body Colour below. |
| `Front_Filament` | `"Black"` | Same as body shares its material. Metallic/glitter appearance comes from the actual filament. |
| `Back_Filament` | `"Red"` | Same as front shares the front material. Map these material labels to loaded spools in your slicer. |
## 08 - Engraving and stroke weight

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Text_Style` | `"Recessed"` |  |
| `Back_Text_Style` | `"Recessed"` |  |
| `Front_Relief_Depth` | `0.8` | mm — Recess depth or raised height, perpendicular to the face. Recess depth OR raised height, perpendicular to face; independent of print orientation. |
| `Back_Relief_Depth` | `0.8` | mm — Recess depth or raised height, perpendicular to the face. |
| `Front_Stroke_Expansion` | `0.12` | mm — Contour expansion; positive thickens strokes and narrows counters. Positive values thicken every outline. They also close small counters: inspect before printing. |
| `Back_Stroke_Expansion` | `0.12` | mm — Contour expansion; positive thickens strokes and narrows counters. |
| `Front_Font_Override` | `""` | Blank uses Font_Name. Override only when the reverse needs another typeface. |
| `Back_Font_Override` | `""` |  |
| `Text_Edge_Radius` | `0` | mm — Text edge radius; 0 disables rounding. 0 keeps details sharp; rounding can remove narrow strokes. Radius is capped at half relief depth. |
| `Text_Rounding_Steps` | `6` | Count (integer) — layers used to approximate text rounding. |
## 09 - Edges and face margin

| Parameter | Default | Description |
| --- | --- | --- |
| `Bevel_Width` | `0.35` | mm — Plan-view width of the edge bevel. Chamfer width measured in plan view; depth measured in model Z. Either zero disables it. |
| `Bevel_Depth` | `0.18` | mm — Model-Z depth of each edge bevel. |
| `Text_Margin` | `0.8` | mm — Extra plan-view margin beyond the flat face. Additional plan-view inset beyond the flat face edge. Applies to both faces. |
| `Protect_Face_Edges` | `true` | Protect trims lettering at the safe boundary. Inspect red overflow and correct it before export. |
| `Minimum_Web` | `1` | mm — Minimum solid web in model Z, AFTER Model Scale. Conservative minimum solid web, measured in model Z, AFTER scaling. |
## 10 - Advanced shape angles

| Parameter | Default | Description |
| --- | --- | --- |
| `Pawn_Circle` | `false` | Enforce a 20-piece ring in the design plan: base angle = 81 degrees. Uses Angle Mode below; incompatible supplied angles stop rendering. Off preserves free shape design. |
| `Angle_Mode` | `"Derive shoulder"` | Pentagon closure: 2*base + 2*shoulder + tip = 540 degrees. In a derive mode the named angle below is ignored; the Console reports resolved angles. With Pawn Circle, Derive base fixes base at 81 degrees and checks shoulder + tip; other modes require the supplied base to be 81 degrees. |
| `Face_Base_Angle` | `81` | Degrees — pentagon interior angle; ignored if selected for derivation. |
| `Face_Shoulder_Angle` | `117` | Degrees — pentagon interior angle; ignored if selected for derivation. |
| `Face_Tip_Angle` | `144` | Degrees — pentagon interior angle; ignored if selected for derivation. |
| `Front_Side_Base_Angle` | `85` | Degrees — used only in Reference side angles mode. Used ONLY in Reference side angles mode. Tip_Thickness is then ignored. |
| `Back_Side_Base_Angle` | `81` | Degrees — used only in Reference side angles mode. |
## 11 - Inspection and quality

| Parameter | Default | Description |
| --- | --- | --- |
| `Body_Colour` | `[0.76, 0.58, 0.34, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. These colours never create a second material or survive ordinary STL export. |
| `Front_Inscription_Colour` | `[0.08, 0.06, 0.04, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. |
| `Back_Inscription_Colour` | `[0.65, 0.05, 0.04, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. |
| `Show_Layout_Guides` | `true` |  |
| `Reference_Line_Width` | `0.6` | mm — Inspection reference-bar width, AFTER Model Scale. Effective toolpath line width, for reference guides ONLY. Does not guarantee printability. |
| `Text_Curve_Resolution` | `48` | Count (integer) — curve tessellation segments; higher is smoother and slower. |
## 12 - Maker signature on heel

| Parameter | Default | Description |
| --- | --- | --- |
| `Signature_Enabled` | `false` | Optional mark on the broad bottom edge, NOT on the reverse inscription face. Off preserves existing pieces. |
| `Signature_Text` | `""` | Horizontal text, read left to right while looking straight at the heel with the front face uppermost. |
| `Signature_Font` | `""` | Empty uses Font Name. Customizer font names have no surrounding quotes. |
| `Signature_Font_Size` | `2.5` | mm — typographic size, not measured glyph height. Start small and use Inspect signature. |
| `Signature_Letter_Spacing` | `1` | Multiplier (unitless) — horizontal letter spacing; 1 = font default. |
| `Signature_X` | `0` | mm — horizontal shift from heel centre; positive = viewer's right. |
| `Signature_Y` | `0` | mm — shift across heel thickness; positive = toward the front inscription face. |
| `Signature_Rotation` | `0` | Degrees — rotation about the signature centre, counterclockwise as viewed. |
| `Signature_Depth` | `0.4` | mm — depth into the heel, perpendicular to that edge. Print engraves; Colour assembly fills the same volume. |
| `Signature_Margin` | `0.6` | mm — protective border around heel lettering. Overflow is clipped and shown red in Inspect signature. |
| `Signature_Filament` | `"Same as front"` | Colour 3MF material; Same as front reuses its filament. Ordinary Print remains single-material engraving. |
| `Signature_Colour` | `[0.08, 0.06, 0.04, 1]` | RGBA (unitless, 0-1) — used only when Signature Filament is Custom; alpha is preview-only. |

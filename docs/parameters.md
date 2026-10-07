# Parameter reference

All 97 public controls in `shogi_piece.scad`. Search this page for a name or keyword. Customizer displays underscores as spaces. Values below are source defaults; a saved preset may override them. Units are before Model Scale unless stated otherwise. Color-support thickness is an internal slicer-safe default rather than a user adjustment.

See the [design guide](design-guide.md) for geometry and the [color quickstart](color-quickstart.md) for 3MF export.

## 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Category` | `"Base / King"` | Informational label ONLY. Dimensions below are always authoritative. |
| `Front_Characters` | `"王将"` |  |
| `Back_Characters` | `""` | Empty string makes a blank reverse. Characters are stacked from tip to heel. |
| `Font_Name` | `"Noto Serif CJK JP:style=SemiBold"` | Install this font or select an installed Japanese font via Help > Font List. |
| `Output_Mode` | `"Model"` | Unified geometry/font/material workspace. F6 Model exports one single-material STL; the Python exporter creates the displayed multipart color 3MF. Blank and Inspect views remain available. |
| `Print_Orientation` | `"Upright"` | Upright: broad heel on bed. Front face down or Back face down: lies flat with that face on the bed; a raised inscription on the bed-side face is rejected. |
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
| `Front_Character_Spacing` | `0` | mm — Center-to-center distance along the face; 0 = automatic. 0 selects center-to-center spacing automatically; positive mm overrides it. |
| `Front_Spacing_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing. In auto spacing, multiply the nominal spacing; does not resize characters. |
| `Front_Center_Fraction` | `0.46` | Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway. Fraction of face length from broad heel to point. 0.46 is slightly below center. |
| `Front_Text_X` | `0` | mm — Whole inscription shift; positive = viewer’s right. Positive X = viewer's right; positive Y = toward the point, measured along the face. |
| `Front_Text_Y` | `0` | mm — Whole inscription shift; positive = toward the point. |
| `Front_Width_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Width changes glyph width only; it never changes font size or spacing. |
| `Front_Height_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Front_Text_Rotation` | `0` | Degrees — rotates the whole inscription counterclockwise as viewed. Rotation in degrees about the inscription center, counterclockwise as viewed. |
## 04 - Back layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Mirror_Front_Settings` | `false` | Link back typography and engraving to front settings. Back text, color and body taper stay independent. Back controls remain visible but are unused while enabled; disable to restore them. This does not reflect the lettering. |
| `Back_Font_Size` | `0` | mm — Typographic size, not measured glyph height; 0 = automatic. |
| `Back_Text_Scale` | `1` | Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. |
| `Back_Character_Spacing` | `0` | mm — Center-to-center distance along the face; 0 = automatic. |
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
## 07 - Filament colors

| Parameter | Default | Description |
| --- | --- | --- |
| `Body_Filament` | `"Wood"` | Live Model color and standard 3MF logical material, not a physical printer slot. Custom uses Body Color below. |
| `Front_Filament` | `"Black"` | Same as body shares its material. Metallic/glitter appearance comes from the actual filament. |
| `Back_Filament` | `"Red"` | Same as front shares its logical filament. Confirm logical colors against loaded physical spools in your slicer. |
## 08 - Engraving and stroke weight

| Parameter | Default | Description |
| --- | --- | --- |
| `Text_Color_Treatment` | `"Face only"` | Face only assigns a slicer-safe supporting region directly behind the visible inscription surface and is the default. Painted grooves also assigns material beside recessed walls. Flush filled closes recessed text with a level inlay. |
| `Front_Text_Style` | `"Recessed"` |  |
| `Back_Text_Style` | `"Recessed"` |  |
| `Front_Relief_Depth` | `0.2` | mm — Recess depth or raised height, perpendicular to the face. Recess depth OR raised height, perpendicular to face; independent of print orientation. |
| `Back_Relief_Depth` | `0.2` | mm — Recess depth or raised height, perpendicular to the face. |
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
| `Body_Color` | `[0.76, 0.58, 0.34, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. These colors never create a second material or survive ordinary STL export. |
| `Front_Inscription_Color` | `[0.08, 0.06, 0.04, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. |
| `Back_Inscription_Color` | `[0.65, 0.05, 0.04, 1]` | RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. |
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
| `Signature_X` | `0` | mm — horizontal shift from heel center; positive = viewer's right. |
| `Signature_Y` | `0` | mm — shift across heel thickness; positive = toward the front inscription face. |
| `Signature_Rotation` | `0` | Degrees — rotation about the signature center, counterclockwise as viewed. |
| `Signature_Depth` | `0.4` | mm — depth into the heel, perpendicular to that edge. Model engraves it; Face only colors the visible floor, Painted grooves colors the walls too, and Flush filled closes the recess. |
| `Signature_Margin` | `0.6` | mm — protective border around heel lettering. Overflow is clipped and shown red in Inspect signature. |
| `Signature_Filament` | `"Same as front"` | Live Model and color 3MF material; Same as front reuses its filament. F6 Model remains a single-material STL. |
| `Signature_Color` | `[0.08, 0.06, 0.04, 1]` | RGBA (unitless, 0-1) — used only when Signature Filament is Custom; alpha is preview-only. |

## 13 - Movement diagrams

A movement diagram is a small picture of where a piece can go, drawn below or
above its characters and engraved and colored like them. The easiest way to
make one is the move editor: open [move-editor.html](../move-editor.html) in a
browser, click the squares, and copy the result.

A diagram is written as a grid of the squares around the piece. Rows run from
the point (forward) to the heel and are separated by `/`; spaces are ignored.

| Symbol | Meaning | Drawn as |
| --- | --- | --- |
| `@` | The piece | A small pentagon pointing forward |
| `o` | Can move to this square | A line from the piece ending in a dot; every square it can stop on has a dot |
| `x` | Jumps to this square, over anything between | A ring, with no line |
| `!` | Captures here without moving (igui), or moves on: a lion move | A line ending in an ✕; next to the `@` only |
| `#` | Slides any distance this way | A line ending in an arrowhead, past the last mark on its line |
| `=` | Flies over any number of pieces this way, capturing them | A double arrowhead |
| `L` | Slides this way and may turn 90° once (hook move) | A line ending in a bar across it |
| `2` | Moves up to 2 squares this way; next to the `@` | Two dots |
| `3`–`7` | Moves up to that many squares this way; next to the `@` | A line ending in the number |
| `.` | Nothing | Nothing |

A `#`, `=` or `L` that lies beyond an `x` on the same line slides on from the
jump. A grid that reaches every square within two steps (a lion) is drawn as a
square frame around the piece.

| Piece | Grid |
| --- | --- |
| Pawn | `o/@` |
| Lance | `#/@` |
| Knight | `x.x/.../.@.` |
| Gold | `ooo/o@o/.o.` |
| Rook | `.#./#@#/.#.` |
| Dragon (promoted rook) | `o#o/#@#/o#o` |
| Chu shogi horned falcon | `.x./#!#/#@#/###` |
| Lion | `xxxxx/xooox/xo@ox/xooox/xxxxx` |
| Taikyoku great dragon | `#3#/.@./#3#` |
| Taikyoku great general | `===/=@=/===` |
| Taikyoku hook mover | `.L./L@L/.L.` |

### How diagrams stay printable

Every mark is built from two sizes, `Move_Stroke` (the thinnest line) and
`Move_Gap` (the narrowest space between marks), measured after Model Scale so
a small piece keeps printable marks. The model places the squares as close as
those two sizes allow, then enlarges the diagram to about one character's size
when the face has room. Marks differ in outline, so none is told apart by size
alone.

Automatic character sizes give the characters whatever face length the
smallest printable diagram leaves. If the characters and diagram together are
longer than the face, the model stops with a message.

Whether the characters then print depends on their strokes, not only their
size: 鷹 has 24 strokes and needs about three times the size of と. The
exporter measures this (see [lettering printability](#lettering-printability)),
and that is what limits most variant pieces. With a 0.4 mm nozzle, one
character and a diagram fit a standard piece; two dense characters and a
diagram generally do not. The fonts differ too: Yuji Syuku cannot print 鷹 at
any size, while LXGW WenKai Mono prints it once stroke expansion is 0: extra
thickness is what closes its narrow gaps. The chu shogi example in
`presets/misc/chu-shogi-learner.json` therefore uses 馬 and 鷹 in LXGW WenKai
Mono, like the learner sets, with no stroke expansion, at 1.4× size.

For a set, give every piece the same `Move_Stroke`, `Move_Gap` and
`Move_Pitch`, so each mark is the same size on every piece, and characters in
the same proportion to the body. The learner sets use LXGW WenKai Mono with
0.08 mm stroke expansion, characters 0.30 × the body length, character slots
at 0.92 spacing, 0.6 mm lines and 3.75 mm between squares: a full step diagram
is then about as wide as its character, and slides reach a little further.

Set `Move_Stroke` and `Move_Gap` from your [print test page](print-test-page.md):
the thinnest line and narrowest gap from the ladders. Neither can be smaller
than `Print_Line_Width`.

What a diagram cannot show: the lion's ability to move twice is implied by the
✕ and the frame, not drawn step by step; burning, and pieces that capture
differently from how they move, belong in a rules sheet.

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Moves` | `""` | Move grid for the front; empty = no diagram. |
| `Front_Move_Position` | `"Below"` | Below or Above the front characters. The diagram takes one character slot; Glyph X, Y and Rotation for that slot move it, and a Glyph Size above 1 enlarges it. |
| `Back_Moves` | `""` | Moves after promotion, shown on the reverse. |
| `Back_Move_Position` | `"Below"` | Below or Above the back characters. |
| `Move_Stroke` | `0.6` | mm, after Model Scale — thinnest diagram line. |
| `Move_Gap` | `0.6` | mm, after Model Scale — narrowest space between diagram marks. |
| `Move_Pitch` | `0` | mm, after Model Scale — distance between squares; 0 = automatic. Use one value for a whole set. The model stops if a grid needs more space to print. |

## Lettering printability

A stroke thinner than one printed line disappears, and a gap narrower than one
line fills in. Set Output Mode to **Inspect printability** to see both on the
current piece: front on the left, back on the right, thin strokes in yellow and
narrow gaps in blue. Diagrams are not marked; they are printable by
construction.

`komascad.py check GAME` measures every piece: the share of each face's
lettering that is too thin, and the share that would fill in. `export` runs the
same check first and stops if any piece is over the limits, 2.5% and 5%. The
bundled shogi and minishogi sets, which print cleanly, measure at most 1.4% and
2.4%; the limits leave headroom above them. Larger characters, a font with fewer strokes, or a
smaller nozzle with a matching `Print_Line_Width` bring a piece under them.

| Parameter | Default | Description |
| --- | --- | --- |
| `Print_Line_Width` | `0.5` | mm, after Model Scale — your printer's line width on the face; 0.5 with the [print guide](printing/print-guide.md)'s settings. Use your nozzle's first-layer line width with another nozzle. |

# Parameter reference

Every setting of `shogi_piece.scad`, in Customizer order. The Customizer shows
underscores as spaces. The defaults below make the king of the bundled shogi
set. A preset can change them.

Lengths are in mm, before **Model Scale**, unless the description says "after
Model Scale". The [design guide](design-guide.md) tells you how to use the
settings together.



## 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Category` | `"King"` | A label for your own use. It does not change the piece. |
| `Front_Characters` | `"王将"` | Characters on the front, from the point to the heel. |
| `Back_Characters` | `""` | Characters on the back (the promoted side). Empty = blank back. |
| `Font_Name` | `"Yuji Syuku:style=Regular"` | An installed Japanese font. Find its exact name in Help > Font List. |
| `Output_Mode` | `"Model"` | Model shows the piece in its colors; press F6 for an STL. Use komascad.py export for a color 3MF. Choices: Model, Blank, Inspect front, Inspect back, Inspect printability, Inspect signature, Inspect pawn circle. |
| `Print_Orientation` | `"Upright"` | How the piece sits on the print bed. Raised text cannot touch the bed. Choices: Upright, Front face down, Back face down. |
| `Model_Scale` | `1` | Multiplier for all lengths. 1 = the dimensions below. |

## 02 - Piece dimensions

| Parameter | Default | Description |
| --- | --- | --- |
| `Piece_Length` | `32` | mm. Length from the heel to the point. |
| `Base_Width` | `28.5` | mm. Width at the heel. |
| `Rear_Thickness` | `9.8` | mm. Thickness at the heel. |
| `Taper_Mode` | `"Tip thickness"` | Tip thickness: set the thickness at the point. Reference side angles: set the slope of each face. Choices: Tip thickness, Reference side angles. |
| `Tip_Thickness` | `3.2` | mm. Thickness at the point, before the bevel. |

## 03 - Front layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Font_Size` | `10.4` | mm. Text size, not the measured glyph height. 0 = automatic. |
| `Front_Text_Scale` | `1` | Multiplier for the text size. 1.1 = 10% larger. |
| `Front_Character_Spacing` | `10.5` | mm. Distance between character centers. 0 = automatic. |
| `Front_Spacing_Scale` | `1` | Multiplier for the automatic spacing. It does not change the text size. |
| `Front_Center_Fraction` | `0.455` | Center of the text: 0 = heel, 1 = point. With Move Pitch above 0, the center of the characters only. |
| `Front_Text_X` | `0` | mm. Moves all the text. Positive = to the right. |
| `Front_Text_Y` | `0` | mm. Moves all the text. Positive = toward the point. |
| `Front_Width_Scale` | `1` | Multiplier for the glyph width. It does not change the spacing. |
| `Front_Height_Scale` | `1.06` | Multiplier for the glyph height. |
| `Front_Text_Rotation` | `0` | Degrees, counterclockwise. Turns all the text around its center. |

## 04 - Back layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Mirror_Front_Settings` | `false` | Use the front layout, text style, depth and stroke on the back. Back text and color stay separate. |
| `Back_Font_Size` | `0` | mm. Text size, not the measured glyph height. 0 = automatic. |
| `Back_Text_Scale` | `1` | Multiplier for the text size. 1.1 = 10% larger. |
| `Back_Character_Spacing` | `0` | mm. Distance between character centers. 0 = automatic. |
| `Back_Spacing_Scale` | `1` | Multiplier for the automatic spacing. It does not change the text size. |
| `Back_Center_Fraction` | `0.42` | Center of the text: 0 = heel, 1 = point. With Move Pitch above 0, the center of the characters only. |
| `Back_Text_X` | `0` | mm. Moves all the text. Positive = to the right, seen from the back. |
| `Back_Text_Y` | `0` | mm. Moves all the text. Positive = toward the point. |
| `Back_Width_Scale` | `1` | Multiplier for the glyph width. It does not change the spacing. |
| `Back_Height_Scale` | `1` | Multiplier for the glyph height. |
| `Back_Text_Rotation` | `0` | Degrees, counterclockwise. Turns all the text around its center. |

## 05 - Front character adjustments

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Glyph_Size` | `[1, 1, 1]` | Multiplier for each character: [first, second, third], from the point. A diagram uses the entry of its slot. |
| `Front_Glyph_Width` | `[1, 1.4, 1]` | Multiplier for the width of each character. |
| `Front_Glyph_Height` | `[1, 1, 1]` | Multiplier for the height of each character. |
| `Front_Glyph_X` | `[0, 0, 0]` | mm. Moves each character. Positive = to the right. |
| `Front_Glyph_Y` | `[2, -1, 0]` | mm. Moves each character. Positive = toward the point. |
| `Front_Glyph_Rotation` | `[0, 0, 0]` | Degrees, counterclockwise. Turns each character. |

## 06 - Back character adjustments

| Parameter | Default | Description |
| --- | --- | --- |
| `Back_Glyph_Size` | `[1, 1, 1]` | Multiplier for each character: [first, second, third], from the point. A diagram uses the entry of its slot. |
| `Back_Glyph_Width` | `[1, 1, 1]` | Multiplier for the width of each character. |
| `Back_Glyph_Height` | `[1, 1, 1]` | Multiplier for the height of each character. |
| `Back_Glyph_X` | `[0, 0, 0]` | mm. Moves each character. Positive = to the right, seen from the back. |
| `Back_Glyph_Y` | `[1, 0, 0]` | mm. Moves each character. Positive = toward the point. |
| `Back_Glyph_Rotation` | `[0, 0, 0]` | Degrees, counterclockwise. Turns each character. |

## 07 - Filament colors

| Parameter | Default | Description |
| --- | --- | --- |
| `Body_Filament` | `"Wood"` | Body color. It becomes a named material in the color 3MF. Custom uses Body Color. Choices: Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Front_Filament` | `"Black"` | Front text color. Choices: Same as body, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Back_Filament` | `"Red"` | Back text color. Choices: Same as body, Same as front, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |

## 08 - Engraving and stroke weight

| Parameter | Default | Description |
| --- | --- | --- |
| `Text_Color_Treatment` | `"Flush filled"` | Face only: color the groove floor. Painted grooves: floor and walls. Flush filled: fill the groove. Choices: Face only, Painted grooves, Flush filled. |
| `Front_Text_Style` | `"Recessed"` | Recessed: cut into the face. Raised: stands up from the face. None: no text. Choices: Recessed, Raised, None. |
| `Back_Text_Style` | `"Recessed"` | Recessed: cut into the face. Raised: stands up from the face. None: no text. Choices: Recessed, Raised, None. |
| `Front_Relief_Depth` | `0.35` | mm. Depth of recessed text, or height of raised text. |
| `Back_Relief_Depth` | `0.35` | mm. Depth of recessed text, or height of raised text. |
| `Front_Stroke_Expansion` | `0.04` | mm. Makes each stroke wider (positive) or thinner (negative). Wide strokes can close small gaps. |
| `Back_Stroke_Expansion` | `0.04` | mm. Makes each stroke wider (positive) or thinner (negative). Wide strokes can close small gaps. |
| `Front_Font_Override` | `""` | A different font for the front. Empty = Font Name. |
| `Back_Font_Override` | `""` | A different font for the back. Empty = Font Name. |
| `Text_Edge_Radius` | `0` | mm. Rounds the text edges. 0 = sharp. Rounding can remove thin strokes. |
| `Text_Rounding_Steps` | `6` | Number of layers that make a rounded text edge. |

## 09 - Edges and face margin

| Parameter | Default | Description |
| --- | --- | --- |
| `Bevel_Width` | `0` | mm. Width of the edge bevel, seen from above. 0 = no bevel. |
| `Bevel_Depth` | `0` | mm. Depth of the edge bevel. 0 = no bevel. |
| `Text_Margin` | `0.9` | mm. Smallest distance from the text to the edge of the flat face. |
| `Protect_Face_Edges` | `true` | Cut off text that goes past the margin. Inspect front and Inspect back show it in red. |
| `Minimum_Web` | `1.2` | mm, after Model Scale. Smallest solid thickness at the point, between the front and back recesses. |

## 10 - Advanced shape angles

| Parameter | Default | Description |
| --- | --- | --- |
| `Pawn_Circle` | `true` | Make the outline fit 20 pieces into a ring (base angle 81 degrees). Check it with Inspect pawn circle. |
| `Angle_Mode` | `"Derive shoulder"` | The angle to calculate from the other two: 2 x base + 2 x shoulder + tip = 540 degrees. Choices: Derive shoulder, Derive tip, Derive base, Check all three. |
| `Face_Base_Angle` | `81` | Degrees. Outline angle at the two heel corners. |
| `Face_Shoulder_Angle` | `117` | Degrees. Outline angle at the two shoulders. |
| `Face_Tip_Angle` | `144` | Degrees. Outline angle at the point. |
| `Front_Side_Base_Angle` | `85` | Degrees. Slope of the front face at the heel. Only for Reference side angles. |
| `Back_Side_Base_Angle` | `81` | Degrees. Slope of the back face at the heel. Only for Reference side angles. |

## 11 - Inspection and quality

| Parameter | Default | Description |
| --- | --- | --- |
| `Body_Color` | `[0.82, 0.68, 0.43, 1]` | [red, green, blue, opacity], 0 to 1. Used when Body Filament is Custom. |
| `Front_Inscription_Color` | `[0.025, 0.02, 0.015, 1]` | [red, green, blue, opacity], 0 to 1. Used when Front Filament is Custom. |
| `Back_Inscription_Color` | `[0.65, 0.05, 0.04, 1]` | [red, green, blue, opacity], 0 to 1. Used when Back Filament is Custom. |
| `Show_Layout_Guides` | `true` | Show the safe area and the center line in the Inspect views. |
| `Text_Curve_Resolution` | `64` | Number of segments in a curve. More is smoother and slower. |
| `Print_Line_Width` | `0.5` | mm, after Model Scale. The line width of your printer on the face. Inspect printability and komascad.py check use it. |

## 12 - Maker signature on heel

| Parameter | Default | Description |
| --- | --- | --- |
| `Signature_Enabled` | `false` | Put a mark on the heel (the wide bottom edge). |
| `Signature_Text` | `""` | The mark. It reads left to right when you look at the heel with the front face up. |
| `Signature_Font` | `""` | Font of the mark. Empty = Font Name. |
| `Signature_Font_Size` | `5` | mm. Text size of the mark. |
| `Signature_Letter_Spacing` | `1` | Multiplier for the letter spacing. |
| `Signature_X` | `0` | mm. Moves the mark. Positive = to the right. |
| `Signature_Y` | `0` | mm. Moves the mark. Positive = toward the front face. |
| `Signature_Rotation` | `0` | Degrees, counterclockwise. Turns the mark. |
| `Signature_Depth` | `0.2` | mm. Depth of the mark into the heel. |
| `Signature_Margin` | `0.6` | mm. Smallest distance from the mark to the heel edges. |
| `Signature_Filament` | `"Same as front"` | Color of the mark. Choices: Same as body, Same as front, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Signature_Color` | `[0.025, 0.02, 0.015, 1]` | [red, green, blue, opacity], 0 to 1. Used when Signature Filament is Custom. |

## 13 - Movement diagrams

| Parameter | Default | Description |
| --- | --- | --- |
| `Front_Moves` | `""` | Movement grid, rows from point to heel, / between rows. See docs/move-diagrams.md. Empty = none. |
| `Front_Move_Position` | `"Below"` | Put the diagram below or above the characters. Choices: Below, Above. |
| `Back_Moves` | `""` | Movement grid for the back, after promotion. Empty = no diagram. |
| `Back_Move_Position` | `"Below"` | Put the diagram below or above the characters. Choices: Below, Above. |
| `Move_Stroke` | `0.6` | mm, after Model Scale. Thinnest diagram line. |
| `Move_Gap` | `0.6` | mm, after Model Scale. Smallest space between diagram marks. |
| `Move_Pitch` | `0` | mm, after Model Scale. Distance between squares. 0 = automatic. Use one value for all pieces of a set. |

See [movement diagrams](move-diagrams.md) for the grid symbols and sizes.

## Lettering printability

A stroke thinner than one printed line does not print. A gap narrower than
one line fills with plastic. **Print Line Width** sets that line.

Set **Output Mode** to **Inspect printability** to see both on the current
piece: the front is on the left, the back on the right. Thin strokes are
yellow. Narrow gaps are blue. Diagrams are not marked: their sizes always
print.

`python3 komascad.py check GAME` measures every piece. It gives the share of
each face's lettering that is too thin, and the share that would fill in.
`export` does the same check first. It stops when a face is above 2.5% thin
strokes or 5% narrow gaps. The bundled shogi and minishogi sets measure at
most 1.4% and 2.4%.

If a piece fails, do one of these:

- Make the characters larger: increase **Model Scale**, or use fewer
  characters.
- Use a font with fewer and wider strokes.
- Decrease **Stroke Expansion** if the gaps fail. Increase it if the strokes
  fail.
- Use a smaller nozzle, and set **Print Line Width** to its line width.

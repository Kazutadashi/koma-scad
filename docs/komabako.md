# Komabako: the piece box

`komabako/komabako.scad` makes a komabako: a box with a lid for a set of
pieces. The defaults hold the 40 pieces of a shogi set, loose.

## Make a komabako

1. Open `komabako/komabako.scad` in OpenSCAD 2021.01.
2. In **02 - Pieces**, set the number of pieces and the size of the largest
   piece.
3. Set **Output Mode** to **Closed**. Press F5 to see the box with its lid.
4. Read the outside and inside sizes in the Console.
5. Set **Output Mode** to **Box and lid**, or to **Box** and **Lid** in turn.
6. Press F6. Export the STL.

Closed works with F5 only.

## Lid styles

| Lid Style | Shape |
| --- | --- |
| Inro (default) | The lid sits on a step at the top of the box. Its sides are flush with the box, so the closed box reads as one block with a fine line around it (印籠). |
| Cap | The lid fits over the outside of the box. |

An Inro lid takes part of the box wall for its step. Keep
**Wall Thickness** at least **Lid Skirt Thickness** + **Lid Clearance** +
1.2 mm.

## Size

With **Inner Width**, **Inner Depth** and **Inner Height** at 0, the inside
follows the pieces:

- The floor is 3.3 times the width of the largest piece, or 3 times its
  length, whichever is larger.
- The pieces lie in layers of **Pieces Per Layer**. Each layer adds
  **Packing Factor** times the piece thickness. Loose pieces nest, so the
  factor is less than 1.
- **Headroom** adds space above the top layer.

For 40 pieces of the bundled shogi set, the inside is 96 x 96 x 34.8 mm, and
the closed box is 104 x 104 x 41.3 mm. Set an inside size to make the box fit
a packing of your choice.

## Print

- The box prints on its bottom, and the lid prints top down. Neither needs
  supports.
- The outside edges have a 45 degree chamfer (面取り), and the corners are
  rounded (隅丸).
- **Kuwa** is the color of the island mulberry of fine boxes. **Kurogaki**
  is the color of black persimmon. Use a matte PLA.
- Print the lid first. Raise **Lid Clearance** if it is tight.

A fine box holds the pieces in a cloth bag (駒袋), so that they do not knock
together. A PLA box cannot include one.

## Maker's mark

The [maker's mark](makers-mark.md) (銘) is cut into the underside of the box,
into the lid top, or both: set **Mark Place**. A mark on the lid reads from
above when the box is closed. Use the same mark on the board and the komadai.

## Settings

Every setting of `komabako/komabako.scad`, in Customizer order. The
Customizer shows underscores as spaces.

### 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Output_Mode` | `"Box and lid"` | Box and Lid are one part each. Box and lid puts both on one bed. Closed shows the lid in place (F5 only). Choices: Box and lid, Box, Lid, Closed. |
| `Lid_Style` | `"Inro"` | Inro: the lid sits on a step, and its sides are flush with the box (印籠). Cap: the lid fits over the outside of the box. Choices: Inro, Cap. |

### 02 - Pieces

| Parameter | Default | Description |
| --- | --- | --- |
| `Piece_Count` | `40` | How many pieces the box holds. |
| `Piece_Length` | `32` | mm. Length of the largest piece, from the heel to the point. |
| `Base_Width` | `28.5` | mm. Width of the largest piece at the heel. |
| `Rear_Thickness` | `9.8` | mm. Thickness of the largest piece at the heel. |

### 03 - Inside size

| Parameter | Default | Description |
| --- | --- | --- |
| `Pieces_Per_Layer` | `10` | How many pieces lie flat in one layer. The automatic height counts the layers. |
| `Packing_Factor` | `0.76` | Fraction of a piece's thickness that one loose layer adds. Below 1 because loose pieces nest. |
| `Headroom` | `5` | mm. Space above the top layer. |
| `Inner_Width` | `0` | mm. Inside width. 0 = automatic, from the largest piece. |
| `Inner_Depth` | `0` | mm. Inside depth. 0 = automatic, from the largest piece. |
| `Inner_Height` | `0` | mm. Inside height, from the floor to the top of the box. 0 = automatic, from the layers. |

### 04 - Box

| Parameter | Default | Description |
| --- | --- | --- |
| `Wall_Thickness` | `4` | mm. Thickness of the side walls. An Inro lid takes part of it for its step. |
| `Bottom_Thickness` | `3` | mm. Thickness of the bottom. |
| `Corner_Radius` | `4` | mm. Radius of the outside corners (隅丸). |
| `Edge_Chamfer` | `0.8` | mm. 45 degree chamfer (面取り) on the outside edges of the box and the lid. |

### 05 - Lid

| Parameter | Default | Description |
| --- | --- | --- |
| `Lid_Clearance` | `0.25` | mm. Space on each side between the box and the lid. Raise it if the lid is tight. |
| `Lid_Skirt_Thickness` | `2` | mm. Thickness of the lid walls. |
| `Lid_Skirt_Height` | `12` | mm. How far the lid walls come down the box. |
| `Lid_Roof_Thickness` | `3` | mm. Thickness of the lid top. |

### 06 - Maker's mark

| Parameter | Default | Description |
| --- | --- | --- |
| `Mark_Place` | `"Underside"` | Where the mark goes: under the box, on top of the lid, or both. Choices: Underside, Lid top, Both. |
| `Mark_Line_1` | `""` | The main line of the mark (銘), on the box: your name or brand. Empty = no mark. |
| `Mark_Line_2` | `""` | A smaller line under it, such as SHOGI · 将棋. Empty = none. |
| `Mark_Size` | `0` | mm. Text size of the main line. The second line and the emblem follow it. 0 = automatic: as large as the room allows, up to Mark Max Size. |
| `Mark_Max_Size` | `14` | mm. Automatic only: the largest text size of the main line. |
| `Mark_Line_2_Ratio` | `0.42` | Size of the second line, as a fraction of the main line. Keep Japanese characters 3 mm or larger. |
| `Mark_Min_Text_Size` | `7` | mm. Smallest size of any text in the mark, and of the emblem's character, so that it prints. The second line and the emblem grow to it. See docs/makers-mark.md for measured values. |
| `Mark_Stroke` | `0` | mm. Thickens every stroke of the mark by this much on each side, so that thin strokes print. 0.12 for a thin Mincho. |
| `Mark_Spacing_1` | `1` | Letter spacing of the main line. 1 = normal. About 1.7 gives a wide-spaced wordmark. |
| `Mark_Spacing_2` | `1` | Letter spacing of the second line. |
| `Mark_Font_1` | `"Kaisei Tokumin:style=ExtraBold"` | An installed font for the main line. Find its exact name in Help > Font List. |
| `Mark_Font_2` | `"Kaisei Tokumin:style=ExtraBold"` | An installed font for the second line. Use one with Japanese characters for Japanese text. |
| `Mark_Emblem` | `false` | A koma above the text, with a character cut into it. |
| `Mark_Emblem_Character` | `""` | The character on the emblem, such as 王. |
| `Mark_Emblem_Font` | `""` | An installed font for the emblem's character, such as a brush font. Empty = Mark Font 1. |
| `Mark_Depth` | `0.4` | mm. Depth of the mark. |

### 07 - Filament colors and layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Box_Filament` | `"Kuwa"` | Box color. Kuwa is the island mulberry of fine boxes. Custom uses Box Color. Choices: Kuwa, Kurogaki, Kaya, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Lid_Filament` | `"Kuwa"` | Lid color. Custom uses Lid Color. Choices: Kuwa, Kurogaki, Kaya, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Box_Color` | `[0.48, 0.23, 0.11, 1]` | [red, green, blue, opacity], 0 to 1. Used when Box Filament is Custom. |
| `Lid_Color` | `[0.62, 0.36, 0.17, 1]` | [red, green, blue, opacity], 0 to 1. Used when Lid Filament is Custom. |
| `Print_Layout_Gap` | `10` | mm. Space between the box and the lid in Box and lid. |

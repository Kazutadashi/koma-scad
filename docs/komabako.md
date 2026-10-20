# Komabako: the piece box

`komabako/komabako.scad` makes a komabako: a box with a lift-off lid for a
set of pieces. The defaults hold the 40 pieces of a shogi set, loose.

## Make a komabako

1. Open `komabako/komabako.scad` in OpenSCAD 2021.01.
2. In **02 - Pieces**, set the number of pieces and the size of the largest
   piece.
3. Set **Output Mode** to **Closed**. Press F5 to see the box with its lid.
4. Read the outside and inside sizes in the Console.
5. Set **Output Mode** to **Box and lid**, or to **Box** and **Lid** in turn.
6. Press F6. Export the STL.

The lid is drawn top down, so that it prints without supports. Closed works
with F5 only.

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
the outside is 102 x 102 x 37.8 mm. Set an inside size to make the box fit a
packing of your choice.

## Fit the lid

**Lid Clearance** is the space on each side between the box and the lid. If
you do not know how accurate your printer is, print the lid first. Raise
**Lid Clearance** if the lid is tight.

## Settings

Every setting of `komabako/komabako.scad`, in Customizer order. The
Customizer shows underscores as spaces.

### 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Output_Mode` | `"Box and lid"` | Box and Lid are one part each. Box and lid puts both on one bed. Closed shows the lid in place (F5 only). Choices: Box and lid, Box, Lid, Closed. |

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
| `Inner_Height` | `0` | mm. Inside height. 0 = automatic, from the layers. |

### 04 - Box

| Parameter | Default | Description |
| --- | --- | --- |
| `Wall_Thickness` | `3` | mm. Thickness of the side walls. |
| `Bottom_Thickness` | `3` | mm. Thickness of the bottom. |
| `Corner_Radius` | `5` | mm. Radius of the outside corners. |

### 05 - Lid

| Parameter | Default | Description |
| --- | --- | --- |
| `Lid_Clearance` | `0.3` | mm. Space on each side between the box and the lid. Raise it if the lid is tight. |
| `Lid_Skirt_Thickness` | `2.4` | mm. Thickness of the lid walls. |
| `Lid_Skirt_Height` | `9` | mm. How far the lid walls come down the box. |
| `Lid_Roof_Thickness` | `3` | mm. Thickness of the lid top. |

### 06 - Filament colors and layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Box_Filament` | `"Wood"` | Box color. Custom uses Box Color. Choices: Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Lid_Filament` | `"Wood"` | Lid color. Custom uses Lid Color. Choices: Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Box_Color` | `[0.48, 0.23, 0.11, 1]` | [red, green, blue, opacity], 0 to 1. Used when Box Filament is Custom. |
| `Lid_Color` | `[0.62, 0.36, 0.17, 1]` | [red, green, blue, opacity], 0 to 1. Used when Lid Filament is Custom. |
| `Print_Layout_Gap` | `10` | mm. Space between the box and the lid in Box and lid. |

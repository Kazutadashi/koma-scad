# Komadai: the piece stand

`komadai/komadai.scad` makes a komadai: the stand next to the board for the
pieces that a player captures. Each player has one.

## Make a komadai

1. Open `komadai/komadai.scad` in OpenSCAD 2021.01.
2. In **02 - Largest piece**, set the length and width of the largest piece
   of your set.
3. Select a **Table Style**:
   - **Low** is a solid slab next to a tabletop board. It is as tall as
     **Board Surface Height**.
   - **Pedestal** is a top on a tapered column, for a raised board. It is
     70 mm tall.
4. Press F5 to see the komadai. Read its size in the Console.
5. Set **Output Mode** to **Pair** to print the two komadai together.
6. Press F6. Export the STL.

The komadai prints in one color, so it needs no color 3MF.

## Size

With **Top Width** and **Top Depth** at 0, the top is square and follows the
largest piece: 3.6 times its width, or 3.2 times its length, whichever is
larger. For the bundled king (28.5 x 32 mm), the top is 102.6 mm square.

Set **Overall Height** to make a Low or Pedestal komadai of any height.

## Top

- **Surface Border Groove** cuts a thin groove around the top, inside the
  edge.
- **Edge Lip Height** adds a raised rim. It is 0 by default, so that the
  pieces slide on and off the top.

## Settings

Every setting of `komadai/komadai.scad`, in Customizer order. The Customizer
shows underscores as spaces.

### 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Output_Mode` | `"One komadai"` | One komadai, or two side by side for one print. Choices: One komadai, Pair. |
| `Table_Style` | `"Low"` | Low: a slab beside a tabletop board. Pedestal: a raised top on a tapered column. Choices: Low, Pedestal. |

### 02 - Largest piece

| Parameter | Default | Description |
| --- | --- | --- |
| `Piece_Length` | `32` | mm. Length of the largest piece, from the heel to the point. The automatic top size follows it. |
| `Base_Width` | `28.5` | mm. Width of the largest piece at the heel. |

### 03 - Size

| Parameter | Default | Description |
| --- | --- | --- |
| `Top_Width` | `0` | mm. Width of the top. 0 = automatic, from the largest piece. |
| `Top_Depth` | `0` | mm. Depth of the top. 0 = automatic, from the largest piece. |
| `Board_Surface_Height` | `12` | mm. Height of the playing surface of the board. A Low komadai is this tall when Overall Height is 0. |
| `Overall_Height` | `0` | mm. From the table to the top surface. 0 = Board Surface Height for Low, 70 for Pedestal. |

### 04 - Top

| Parameter | Default | Description |
| --- | --- | --- |
| `Top_Thickness` | `6` | mm. Thickness of the top. A Low komadai is solid, so this applies to Pedestal only. |
| `Corner_Radius` | `5` | mm. Radius of the four corners. |
| `Surface_Border_Groove` | `true` | A shallow groove around the top surface, inside the edge. |
| `Groove_Inset` | `7` | mm. Distance from the edge to the groove. |
| `Groove_Width` | `0.7` | mm. Width of the groove. |
| `Groove_Depth` | `0.4` | mm. Depth of the groove. |
| `Edge_Lip_Height` | `0` | mm. Height of a raised rim around the top. 0 = no rim, so that pieces slide on and off. |
| `Edge_Lip_Width` | `2` | mm. Width of the rim. |

### 05 - Pedestal

| Parameter | Default | Description |
| --- | --- | --- |
| `Foot_Thickness` | `5` | mm. Thickness of the foot. |
| `Foot_Size_Ratio` | `0.76` | Size of the foot, as a fraction of the top. |
| `Column_Bottom_Ratio` | `0.58` | Size of the column at the foot, as a fraction of the top. |
| `Column_Top_Ratio` | `0.48` | Size of the column under the top, as a fraction of the top. |

### 06 - Filament color and layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Komadai_Filament` | `"Wood"` | Preview color. Custom uses Komadai Color. Choices: Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Komadai_Color` | `[0.74, 0.5, 0.24, 1]` | [red, green, blue, opacity], 0 to 1. Used when Komadai Filament is Custom. |
| `Pair_Gap` | `12` | mm. Space between the two komadai of a Pair. |

# Komadai: the piece stand

`komadai/komadai.scad` makes a pair of komadai: the stands next to the board
for the pieces that each player captures. Each player has one, at the right
of the board, so that the opponent can see the captured pieces.

## Make a pair of komadai

1. Open `komadai/komadai.scad` in OpenSCAD 2021.01.
2. Select a **Table Style**. See [Styles](#styles).
3. In **02 - Board and pieces**, set **Board Surface Height** to the height of
   your board's playing surface above the table. Set the size of the largest
   piece of your set.
4. Press F5 to see the pair. Read the size and height in the Console.
5. Set **Output Mode** to **Pair to print**, or to **One to print** for one
   komadai.
6. Press F6. Export the STL.

The komadai prints in one color of PLA, so it needs no color 3MF.

## Styles

A traditional komadai matches the board beside it. Its top is a little lower
than the playing surface, so that the captured pieces sit at or below the
pieces on the board.

| Table Style | Shape | Use it beside | Height |
| --- | --- | --- | --- |
| Flat | A plate (板状) | A tabletop board, such as the bundled 12 mm board | **Flat Thickness**, 6 mm by default |
| Yagura | A top on four legs (櫓), tied by stretchers near the foot | A thick legged board | **Height Below Board** below the playing surface |
| One leg | A top on a tapered column and a foot (一本脚) | A medium legged board | **Height Below Board** below the playing surface |

Shops make legged komadai 1 to 2 cm lower than the board. The default
**Height Below Board** is 15 mm.

## Size

With **Top Width** and **Top Depth** at 0, the top is square and follows the
largest piece: 4.2 times its width or 3.75 times its length, whichever is
larger. For the bundled king (28.5 x 32 mm), the top is 120 mm square, the
size of a traditional komadai.

## Print

- Each komadai prints top face down, so that the top is as smooth as the
  board. Every part grows from the top without supports: the column of a One
  leg komadai meets its foot at 45 degrees, and the yagura stretchers have a
  45 degree ridge.
- Print the two komadai of a pair together, from one spool. Then their color
  matches, as the two komadai of a fine set come from one log.
- A legged komadai prints in one piece. Beside a legged board, it can be
  taller than your printer. The model stops when the komadai is taller than
  **Print Height**.
- Use the same PLA as the board. **Kaya** matches the bundled board.

## Maker's mark

The [maker's mark](makers-mark.md) (銘) is cut into the underside of the top,
between the legs or beside the column. Use the same mark on the board and the
box: fine sets carry the maker's name on each part.

## Settings

Every setting of `komadai/komadai.scad`, in Customizer order. The Customizer
shows underscores as spaces.

### 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Output_Mode` | `"Display"` | Display shows the pair standing, as on the table. One to print and Pair to print turn them top face down for the bed. Choices: Display, One to print, Pair to print. |
| `Table_Style` | `"Flat"` | Flat: a plate beside a tabletop board. Yagura: a top on four legs. One leg: a top on a column and foot. Use the legged styles beside a legged board. Choices: Flat, Yagura, One leg. |

### 02 - Board and pieces

| Parameter | Default | Description |
| --- | --- | --- |
| `Board_Surface_Height` | `12` | mm. Height of the board's playing surface above the table. 12 = the bundled tabletop board. |
| `Height_Below_Board` | `15` | mm. Yagura and One leg: how far the top sits below the playing surface. Tradition: 10 to 20. |
| `Piece_Length` | `32` | mm. Length of the largest piece, from the heel to the point. The automatic top size follows it. |
| `Base_Width` | `28.5` | mm. Width of the largest piece at the heel. |

### 03 - Top

| Parameter | Default | Description |
| --- | --- | --- |
| `Top_Width` | `0` | mm. Width of the top. 0 = automatic: about 120 for the bundled pieces. |
| `Top_Depth` | `0` | mm. Depth of the top. 0 = automatic. |
| `Flat_Thickness` | `6` | mm. Flat only: thickness of the plate. Keep it below the board surface. |
| `Top_Thickness` | `12` | mm. Yagura and One leg: thickness of the top. |
| `Corner_Radius` | `1.5` | mm. Radius of the four corners. |
| `Edge_Chamfer` | `1.2` | mm. 45 degree chamfer (面取り) round the top and bottom edges of the top. |
| `Surface_Border_Groove` | `false` | A thin groove inside the edge of the top. Tradition: plain. |
| `Groove_Inset` | `7` | mm. Distance from the edge to the groove. |
| `Groove_Width` | `0.9` | mm. Width of the groove. |
| `Groove_Depth` | `0.4` | mm. Depth of the groove. |

### 04 - Legs

| Parameter | Default | Description |
| --- | --- | --- |
| `Leg_Width` | `16` | mm. Yagura: width of each square leg at the top. |
| `Leg_Taper` | `0.85` | Yagura: width of each leg at the foot, as a fraction of its width at the top. |
| `Leg_Inset` | `8` | mm. Yagura: distance from the edge of the top to each leg. |
| `Stretchers` | `true` | Yagura: stretchers (貫, nuki) that tie the legs together near the foot. They make the stand stiffer. |
| `Stretcher_Height` | `30` | mm. Yagura: height of the stretchers above the table. |
| `Column_Top_Ratio` | `0.3` | One leg: width of the column under the top, as a fraction of the top. |
| `Column_Bottom_Ratio` | `0.36` | One leg: width of the column at the foot, as a fraction of the top. |
| `Foot_Size_Ratio` | `0.8` | One leg: width of the foot, as a fraction of the top. |
| `Foot_Thickness` | `8` | mm. One leg: thickness of the foot plate. |

### 05 - Maker's mark

| Parameter | Default | Description |
| --- | --- | --- |
| `Mark_Line_1` | `""` | The main line of the mark (銘), cut into the underside of the top: your name or brand. Empty = no mark. |
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

### 06 - Filament color and layout

| Parameter | Default | Description |
| --- | --- | --- |
| `Komadai_Filament` | `"Kaya"` | Color. Kaya matches the bundled board. Custom uses Komadai Color. Choices: Kaya, Kuwa, Kurogaki, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Komadai_Color` | `[0.74, 0.5, 0.24, 1]` | [red, green, blue, opacity], 0 to 1. Used when Komadai Filament is Custom. |
| `Pair_Gap` | `12` | mm. Space between the two komadai of a pair. |
| `Print_Height` | `256` | mm. The tallest part your printer can make. A legged komadai prints in one piece, top face down. |

# Ban: the board

`ban/ban.scad` makes a shogi board with any number of squares, as one print
or as panels joined by small connectors. Each panel is one PLA print, with no
glue or supports. You can print the connectors, or replace any of them with a
screw and nut from a hardware store. The [design notes](ban-design-notes.md)
tell why the joints have their shape.

The defaults follow the traditional board: squares of 35.4 x 38.7 mm, a thin
7.5 mm border, and an overall size of 333.6 x 363.3 mm, the 1尺1寸 x 1尺2寸
of a standard board. No common print bed holds that in one piece, so the
default board prints as 2 x 2 panels for a 256 mm bed.

## Make a board

1. Open `ban/ban.scad` in OpenSCAD 2021.01.
2. Select a preset at the top of the Customizer, for example
   **Shogi - 2 x 2 panels**.
3. In **04 - Printed panels**, set **Print Bed Width** and
   **Print Bed Depth** to your printer. The model stops if a panel and its
   tabs do not fit.
4. In **03 - Largest piece**, set the length and width of the largest piece
   of your set. The model stops if a square is too small for it.
5. Press F5 to see the board. Read the size in the Console.
6. Set **Output Mode** to **Joint test**. Print the two small blocks, and
   check the fit. See [Print](#print).
7. Save the preset with a new name. Click **+** next to the preset list.
8. Export the board as color 3MF files. See
   [Export a color 3MF](#export-a-color-3mf).

## Bundled boards

| Preset | Squares | Panels | Size (mm) | For |
| --- | --- | --- | --- | --- |
| Shogi - 2 x 2 panels | 9 x 9 | 2 x 2 | 333.6 x 363.3 | A 256 mm bed, with connectors |
| Shogi - 2 x 2 panels, T-hook | 9 x 9 | 2 x 2 | 333.6 x 363.3 | Tabs printed on the panels: the joint that has been printed and tuned |
| Shogi - 3 x 3 panels, 180 mm bed | 9 x 9 | 3 x 3 | 333.6 x 363.3 | A 180 mm bed |
| Shogi - 3 x 3 modules | 9 x 9 | 3 x 3 modules of 3 x 3 squares | 333.6 x 363.3 | Modules that also fit the chu shogi board |
| Shogi - one piece, large printer | 9 x 9 | 1 | 333.6 x 363.3 | A bed of 334 x 364 mm or more |
| Shogi - 2 x 2 panels, keys | 9 x 9 | 2 x 2 | 333.6 x 363.3 | Butterfly keys, assembled face down |
| Shogi - raised lines | 9 x 9 | 2 x 2 | 333.6 x 363.3 | Display: lines stand above the surface |
| Minishogi - one piece | 5 x 5 | 1 | 192 x 208.5 | A 256 mm bed |
| Minishogi - 2 x 2 panels | 5 x 5 | 2 x 2 | 192 x 208.5 | A small bed |
| Chu shogi - 4 x 4 modules | 12 x 12 | 4 x 4 modules of 3 x 3 squares | 439.8 x 479.4 | Modules that also fit the shogi board |
| Taikyoku shogi - 9 x 9 panels | 36 x 36 | 9 x 9 | 1289.4 x 1408.2 | A 256 mm bed |
| Custom - 5 x 7 squares | 5 x 7 | 1 x 2 | 201 x 294.9 | A 256 mm bed |
| Custom - 2 x 3 squares | 2 x 3 | 1 | 90.8 x 136.1 | Any bed |

All boards are 12 mm thick, except **Custom - 2 x 3 squares** (10 mm). All
boards in panels use connectors, except the T-hook and keys presets.

To put your name or brand under the board, see the
[maker's mark](makers-mark.md). It goes under panel 0, 0, clear of the
connector sockets.

## Output modes

| Output Mode | Shows | Export |
| --- | --- | --- |
| Assembled board | Every panel in its place, face up | F6, then STL (one color) |
| One panel | The panel at **Panel X**, **Panel Y**, as it sits on the bed | F6, then STL (one color) |
| All panels | Every panel, as each sits on the bed | F6, then STL (one color) |
| Joint test | Two small blocks with one joint and a grid line at the seam. With Connectors or Keys, also one connector or key. | F6, then STL |
| Loose parts | Every connector or key of the board, and the spares | F6, then STL |

F5 shows the grid lines in their color. F6 makes the board with empty grid
grooves, which you can paint. For a board with colored lines, use
`komascad.py ban`.

## Lines

A fine board has lines of black lacquer, built up so that they stand a
little above the wood. Printing can match their crisp, even edges. It can
match their height only by printing the board face up, which gives a rougher
playing surface. Thus there are two **Line Style** choices:

| Line Style | The lines | The playing surface | Use it for |
| --- | --- | --- | --- |
| Flush inlay (default) | Level with the surface | Face down on the bed: the smoothest | Play |
| Raised | **Line Raise** above the surface, like lacquer | Face up: rougher | Display |

For a raised board, set **Print Orientation** to **Playing face up**. Set
**Line Raise** to a whole number of layers: 0.12 mm is one 0.12 mm layer or
three 0.04 mm layers.

Set **Grid Groove Width** to a whole number of printed line widths. Then the
slicer fills each line with clean passes, not one uneven pass. 0.9 mm (the
default) is two lines of a 0.4 mm nozzle. 0.45 mm is one line, for a finer
look.

The four camp dots (星) mark the lines one third in from each side, as on a
traditional board.

## Squares and panels

**Playing Columns** and **Playing Rows** count the squares. **Panel Layout**
decides how the board is cut into printed panels:

| Panel Layout | Panels | Use it for |
| --- | --- | --- |
| Split board (default) | **Panel Columns** x **Panel Rows** panels. 1 x 1 is a one-piece board. | The fewest seams for your bed |
| Modules | Panels of **Module Columns** x **Module Rows** squares | Panels that also fit other boards |

- Each seam is on a grid line, so each panel holds whole squares.
- In a split board, when the squares do not divide evenly, two panels differ
  by one row or column at most.
- Use as few panels as your bed allows. With 2 x 2 panels, no camp dot is on
  a seam.

Panels are counted from 0 at the front left. **Panel X** counts columns
from the left. **Panel Y** counts rows from the front.

### Modules

With **Panel Layout** set to **Modules**, every panel has the same number of
squares. **Playing Columns** must be a multiple of **Module Columns**, and
**Playing Rows** of **Module Rows**.

A module is the same on every board with the same squares, so you can reuse
modules. With 3 x 3 modules:

| Board | Modules | Center | Edge | Corner |
| --- | --- | --- | --- | --- |
| Shogi, 9 x 9 | 3 x 3 | 1 | 4 | 4 |
| Chu shogi, 12 x 12 | 4 x 4 | 4 | 8 | 4 |
| Taikyoku shogi, 36 x 36 | 12 x 12 | 100 | 40 | 4 |

The four corner modules and the edge modules carry the border. A center
module fits any center place, and any board of the same squares. An edge
module fits any edge place on the same side. A shogi set's modules start a
chu shogi board: print 3 center and 4 edge modules more.

The camp dots depend on the board: on a 9 x 9 board they fall on module
corners, on a 12 x 12 board inside the modules. For modules that you want to
use on more than one board, set **Camp Dots** off.

### Seam lines

**Seam Lines** decides which panel carries the grid line on a seam:

| Seam Lines | The line on a seam | Camp dot on a seam |
| --- | --- | --- |
| Split (default) | Half on each panel: 0.45 mm each side of a 0.9 mm line. Every seam edge is the same. | Cut with the line: each panel carries its part |
| One side | All on one panel. The seam runs along the edge of the line. | Kept whole on a plug, with a notch in the neighbor |

Either way, the seam gap merges into the black line. Split lines make every
panel edge the same, which modules need.

## Joints

Four **Joint Style** choices join the panels. All of them hold the panels
together and in line.

| Joint Style | Put the board together | What sets the height | If a joint breaks |
| --- | --- | --- | --- |
| Connectors (default) | Face down: drop a connector into each socket, then turn the board over | The table | Replace one connector: print it, or use a screw and nut |
| T-hook | Face up: lower each panel straight down onto the table | The table | The panel's tab is broken: reprint the panel |
| Dovetail | The same, with angled tab sides | The table | Reprint the panel |
| Keys | Face down: press butterfly keys (契り) into the underside, then turn the board over | The table, touching the playing faces | Replace one key |

**Connectors** are the default because they make the board repairable and
modular:

- **Nothing breaks on a panel.** A panel has only sockets; nothing sticks out.
  The connector is the weak link. If a seam is pulled hard, a connector
  breaks, and the panel is not damaged.
- **No need to buy parts from us.** A lost or broken connector can be
  replaced with an **M4 x 20 socket head cap screw and an M4 hex nut**, or a
  **#8-32 x 3/4 inch socket cap screw and nut**. Hardware stores and hobby
  shops sell both. See the [connector spec](ban-connector-spec.md).
- **Every seam edge is the same.** All sockets follow one fixed spec, so
  connectors fit every board.
- **Nothing is forced.** Lift any panel straight up to free it. The
  connectors stay on the table.

The T-hook has been printed and tuned. The Connectors and Keys styles have
not been printed yet. Print their Joint test first.

### Connectors

Each seam has sockets in the underside, half in each panel. A socket has a
slot across the seam, and a pocket on each side for the head or the nut. Its
roof is flat, 9.3 mm above the underside.

1. Lay the panels face down on a flat table, in their places. Push the edges
   together.
2. Drop a connector into each socket. It falls in: there is no press fit.
3. Turn the board over. Each connector drops about 1 mm onto the table, and
   stays in its sockets.

To take a panel out, lift it straight up. To change the layout, lift the
panels, pick up the connectors, and start again.

**Connector Fit**: **Slip** (the default) lets a pulled seam open 0.4 mm, the
same as the T-hook. **Snug** opens 0.2 mm, for flatter, tighter seams, but
needs a more accurate printer.

**With a screw and nut:** turn the nut onto the screw until the gap between
the head and the nut is a little over 14 mm. Lay it flat in the socket, with
the head in one pocket and the nut in the other. Use the smallest gap that
still drops in: a larger gap lets the seam open more. See the
[connector spec](ban-connector-spec.md).

### T-hook and Dovetail

- Each tab is **Joint Floor Gap** (1 mm) above the table. Its socket is open
  below it, so nothing pushes the tab up.
- Each tab has **Joint Roof Clearance** (1 mm) above it at the seam.
- The tab sides have a slip fit, so nothing grips a panel at any height.
- Each seam has two tabs or more, so a panel cannot turn about one tab.

Each panel has tabs on its right and back edges, and sockets on its left and
front edges. The tab top slopes at 45 degrees, so the tab prints face down
without supports.

| Joint Style | Shape | A pulled seam opens |
| --- | --- | --- |
| T-hook | A neck and a wider head with square shoulders | About Joint Clearance: 0.4 mm |
| Dovetail | Angled sides | About Joint Clearance / sin(Joint Flank Angle): 0.42 mm at 0.3 mm |

![Plan and side sections of the T-hook joint](../images/ban/t-hook-joint.svg)

The T-hook socket has a flat roof, so sideways play cannot push a panel up.
The first socket on an edge sets the panel's position along the seam. The
other sockets get **T Spacing Relief**, so that small spacing errors do not
bind the edge. **T Neck Relief** adds room only beside the narrow neck.
T-hook panels also have a bevel of **Joint Bottom Chamfer** on each
underside edge.

For a T-hook, set **Joint Edge Margin** to 20 and **Support Band** to 15, as
in the T-hook preset. A Dovetail needs a shorter tab than the T-hook
defaults. Set **Joint Depth** to 5, **Joint Clearance** to 0.3 and
**Joint Bottom Chamfer** to 1.

### Keys

Each seam has butterfly-shaped pockets in the underside, half in each panel.
A key fills each pocket, across the seam. The keys print flat, as a separate
file, with **Key Spares** extra.

1. Lay the panels face down on a flat table, in their places. Push the edges
   together.
2. Press a key into each pocket. **Key Clearance** (0.15 mm) gives a press
   fit. The pocket mouth is chamfered, so the key finds its place.
3. Turn the board over.

A seated key sits 0.2 mm below the underside, so the board stands on its
panels, not on the keys. To take the board apart, turn it over and push each
key out.

### Seam reveal

With **Seam Reveal** on (the default), both edges of each seam get the 45
degree **Seam Bevel**, not only the neighbor's edge. The small V hides a
slight step, and a sliding piece does not catch on it. On the panel that
owns the grid line, the bevel cuts the edge of the black line too, so the V
stays inside the line.

### Seam underside bevel

Every seam edge has a 45 degree bevel of **Seam Underside Bevel** (0.8 mm)
along its bottom, on both panels, with every joint style. The underside is
the last layer of a face-down print, and its edges can come out uneven. A
bulge at a seam edge would lift the panel, so that it does not sit flat on
the table. The bevel keeps the edge off the table. The playing surface does
not change.

### Underside relief

**Underside Relief** recesses the middle of each panel's underside by 0.3 mm.
The panel then stands on a band of **Support Band** (15 mm) around its edges.
Both sides of a seam stand on the table within a few millimeters of the
seam, where the table is nearly the same height. This reduces the step that
an uneven table makes. Set it to 0 for a flat underside.

## Export a color 3MF

Save the board as a preset first. The export reads saved presets only.

```bash
python3 komascad.py ban                                # the boards in ban/ban.json
python3 komascad.py ban "Shogi - 2 x 2 panels"         # export one board
python3 komascad.py ban "My board" -p my-boards.json   # a board from another preset file
```

The files go to `exports/ban/BOARD/`:

| Board | Files |
| --- | --- |
| One piece | `BOARD.3mf` |
| Panels | `BOARD - Panel CC-RR.3mf` for each panel, and `BOARD - All panels.3mf` with every panel on one bed |
| Panels with Connectors or Keys | The panel files, and `BOARD - Connectors.3mf` or `BOARD - Keys.3mf` with all of them and the spares |

`CC-RR` is the column and the row of the panel, such as `01-00`. Each 3MF
has two aligned parts: **Body** on filament 1, and **Markings** (the grid
lines and camp dots) on filament 2. Set filament 2 to black in the slicer.
See [the print guide](printing/print-guide.md#import-a-color-3mf).

`manifest.json` lists each panel: its file, size, offset on the board and
neighbors. It also gives the assembly order and every setting of the preset.

The [command reference](cli.md#ban) gives every option.

## Print

All parts are PLA.

1. Print the **Joint test** first.
   - T-hook or Dovetail: put the socket block on the table. Lower the tab
     block straight down into it. It must drop in under its own weight, and
     lift out freely. Change **Joint Clearance** in 0.05 mm steps until it
     does.
   - Connectors: lay both blocks face down, edges together. Drop the
     connector in. Turn the blocks over. Pull them apart gently: the seam must
     open no more than about 0.4 mm. Try a screw and nut in the same socket.
   - Keys: lay both blocks face down, edges together. Press the key in by
     hand. It must go in firmly, and hold the blocks level when you lift
     them. Change **Key Clearance** in 0.05 mm steps.
2. Print the panels with the playing surface on the bed. In the slicer, the
   grid is on the underside. This gives the smoothest playing surface.
3. Use a smooth build plate for a satin surface. A textured plate prints its
   pattern on the playing surface.
4. Use a matte PLA in a pale, warm yellow for the board. **Kaya** is the
   color of the traditional wood. Silk PLA is too glossy.
5. Set the slicer for a firm surface that does not sound hollow: at least
   2 mm of solid layers under the playing surface (for example, 10 bottom
   layers at 0.2 mm), and 25 to 40 percent gyroid infill. A thin skin over
   sparse infill makes a hollow "tock" when you put a piece down.
6. Set the bottom surface pattern to straight lines that run from the front
   to the back of the board. The faint lines then follow the files, like
   straight-grained wood.

## Put the board together

For a **Connectors** board, see [Connectors](#connectors). For a **Keys**
board, see [Keys](#keys). For a T-hook or Dovetail board, put the panels
together on a flat table, face up.

1. Put panel 00-00 at the front left.
2. Take the next panel in the assembly order. The order is row by row from
   the front, each row from the left.
3. Hold the panel above the table. Put its edges against its neighbors.
4. Lower the panel straight down until it sits on the table. Do not push it.
5. Do steps 2 to 4 again for each panel.

To take the board apart, lift each panel straight up, in the opposite order.

## Troubleshooting

| Problem | Do this |
| --- | --- |
| "Panel ... is larger than the ... print bed" | Use more panels, or set **Print Bed Width** and **Print Bed Depth** to your printer. |
| A panel does not drop into place under its own weight | Raise **Joint Clearance**. Do not push the panel down: a tight joint can hold it up. |
| A seam opens too far when you pull the panels | Lower **Joint Clearance**, but only while the panels still drop in freely. |
| A seam has a step | Put each panel on the table alone. Make sure that no corner rocks. The joint cannot make a bent panel flat. |
| A panel stands high or rocks at a seam | Look at the bottom edge of the seam for a bulge from the last layers. Raise **Seam Underside Bevel**, for example to 1.2 mm. |
| "Raised lines ... must print face up" | Set **Print Orientation** to **Playing face up**, or use **Flush inlay**. |
| "A square ... must be larger than the largest piece" | Make **Cell Width** and **Cell Depth** larger, or correct **03 - Largest piece**. |
| "The shortest seam ... is too short for two tabs" | Use fewer, larger panels, or reduce **Joint Width**. |
| "A joint must be at least ... mm from a panel corner" | Raise **Joint Edge Margin**, use fewer panels, or use smaller keys. |
| A key is too tight or falls out | Change **Key Clearance** in 0.05 mm steps. Print the Joint test again. |
| A connector is lost or broken | Print one with Output Mode **Loose parts**, or use an M4 x 20 socket head screw and M4 nut, or a #8-32 x 3/4 inch screw and nut. |
| "Connectors need a board at least ... mm thick" | The sockets are 9.3 mm deep. Use **Board Thickness** 11 mm or more. |
| A change is not in the export | Save the preset. Then export with `-f`. |

## Settings

Every setting of `ban/ban.scad`, in Customizer order. The Customizer shows
underscores as spaces.

### 01 - Start here

| Parameter | Default | Description |
| --- | --- | --- |
| `Category` | `"Shogi"` | A label for your own use. It does not change the board. |
| `Output_Mode` | `"Assembled board"` | Assembled board shows every panel in place. One panel and All panels show the parts to print. Joint test is two small blocks, to check the fit first. Loose parts is the connectors or keys of the board. Use komascad.py ban for a color 3MF. Choices: Assembled board, One panel, All panels, Joint test, Loose parts. |
| `Panel_X` | `0` | The column of the panel that One panel shows, counted from 0 at the left. |
| `Panel_Y` | `0` | The row of the panel that One panel shows, counted from 0 at the front. |
| `Print_Orientation` | `"Playing face down"` | How the panels sit on the print bed. Face down gives the smoothest playing surface. Raised lines need Playing face up. Choices: Playing face down, Playing face up. |

### 02 - Board

| Parameter | Default | Description |
| --- | --- | --- |
| `Playing_Columns` | `9` | Squares from left to right. |
| `Playing_Rows` | `9` | Squares from front to back. |
| `Cell_Width` | `35.4` | mm. Width of one square. 35.4 is the Japan Shogi Association board. |
| `Cell_Depth` | `38.7` | mm. Depth of one square, front to back. 38.7 is the Japan Shogi Association board. |
| `Board_Margin` | `7.5` | mm. Border around the grid on each edge. 7.5 with the default squares gives the traditional 1尺1寸 x 1尺2寸 board (333 x 364 mm). |
| `Board_Thickness` | `12` | mm. From the underside to the playing surface. |
| `Outer_Corner_Radius` | `3` | mm. Radius of the four outer corners. |

### 03 - Largest piece

| Parameter | Default | Description |
| --- | --- | --- |
| `Piece_Length` | `32` | mm. Length of the largest piece that the squares must hold, from the heel to the point. |
| `Base_Width` | `28.5` | mm. Width of the largest piece at the heel. |

### 04 - Printed panels

| Parameter | Default | Description |
| --- | --- | --- |
| `Panel_Layout` | `"Split board"` | Split board: cut the board into Panel Columns x Panel Rows panels. Modules: cut it into panels of Module Columns x Module Rows squares, which also fit other boards with the same squares. Choices: Split board, Modules. |
| `Panel_Columns` | `2` | Split board: panels from left to right. 1 x 1 is a one-piece board. Seams follow grid lines, so each panel holds whole squares. |
| `Panel_Rows` | `2` | Split board: panels from front to back. |
| `Module_Columns` | `3` | Modules: squares from left to right in each module. Playing Columns must be a multiple of it. |
| `Module_Rows` | `3` | Modules: squares from front to back in each module. Playing Rows must be a multiple of it. |
| `Print_Bed_Width` | `256` | mm. Width of your print bed. The model stops if a panel and its tabs do not fit. |
| `Print_Bed_Depth` | `256` | mm. Depth of your print bed. |
| `Print_Layout_Gap` | `10` | mm. Space between the panels in All panels. |

### 05 - Markings

| Parameter | Default | Description |
| --- | --- | --- |
| `Seam_Lines` | `"Split"` | Split: each panel carries half of the grid line on a seam, so every seam edge is the same and panels fit anywhere. One side: one panel carries the whole line. Choices: Split, One side. |
| `Line_Style` | `"Flush inlay"` | Flush inlay: the lines are level with the playing surface. Raised: they stand above it, like lacquer lines, and the board prints face up. Choices: Flush inlay, Raised. |
| `Grid_Groove_Width` | `0.9` | mm. Width of the grid lines. Use a whole number of printed line widths: 0.9 is two lines of a 0.4 mm nozzle. |
| `Grid_Groove_Depth` | `0.45` | mm. Depth of the grid grooves. |
| `Line_Recess` | `0` | mm. Flush inlay only: how far the top of the line color sits below the playing surface. 0 = level. |
| `Line_Raise` | `0.12` | mm. Raised only: how far the lines stand above the playing surface. Use whole layers, such as 0.12 or 0.16. |
| `Camp_Dots` | `true` | Four dots where the lines one third in from each side cross. |
| `Camp_Dot_Diameter` | `2.4` | mm. Diameter of each camp dot. |

### 06 - Filament colors

| Parameter | Default | Description |
| --- | --- | --- |
| `Board_Filament` | `"Kaya"` | Board color. It becomes a named material in the color 3MF. Custom uses Board Color. Choices: Kaya, Kuwa, Kurogaki, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Line_Filament` | `"Black"` | Color of the grid lines and camp dots. Custom uses Line Color. Choices: Kaya, Kuwa, Kurogaki, Wood, Black, White, Red, Blue, Green, Purple, Yellow, Orange, Silver, Gold, Glitter silver, Glitter gold, Filament 1, Filament 2, Filament 3, Custom. |
| `Board_Color` | `[0.82, 0.63, 0.34, 1]` | [red, green, blue, opacity], 0 to 1. Used when Board Filament is Custom. |
| `Line_Color` | `[0.01, 0.01, 0.01, 1]` | [red, green, blue, opacity], 0 to 1. Used when Line Filament is Custom. |

### 07 - Joint fit

| Parameter | Default | Description |
| --- | --- | --- |
| `Joint_Style` | `"Connectors"` | Connectors: every panel has the same sockets on every seam edge, joined by small separate connectors, which you can print or replace with an M4 or #8-32 screw and nut. A broken connector costs one connector, and panels fit anywhere. T-hook: tabs printed on the panels; drop each panel in. Dovetail: the same, with angled sides. Keys: butterfly keys (契り) pressed into the underside. Choices: Connectors, T-hook, Dovetail, Keys. |
| `Connector_Fit` | `"Slip"` | Connectors only: Slip drops in and lifts out freely. Snug has less play, for flatter seams. Choices: Slip, Snug. |
| `Connector_Spares` | `2` | Connectors only: extra connectors to print, in case one is lost or breaks. |
| `Joint_Clearance` | `0.4` | mm. Space between each tab side and its socket. Each panel must drop into place under its own weight. Raise this if one does not. |
| `Joint_Roof_Clearance` | `1` | mm. Gap above each tab at the seam. The T-hook socket roof is flat, so sideways play cannot close this gap. |
| `Seam_Bevel` | `0.3` | mm. 45 degree bevel on the top edge of each seam. It takes up first-layer squish, so the seam closes at the playing surface. |
| `Seam_Reveal` | `true` | Bevel both edges of each seam, not only the neighbor's. The small V hides a slight step, and a sliding piece does not catch on it. |
| `Seam_Underside_Bevel` | `0.8` | mm. 45 degree bevel along the bottom edge of each seam, on both panels. The last layers of a print (the underside) can end with an uneven edge; the bevel keeps it off the table, so that each panel sits flat. 0 = none. |
| `Camp_Dot_Plug_Clearance` | `0.2` | mm. Space around a camp dot where a seam goes around it. |

### 08 - Joint shape

| Parameter | Default | Description |
| --- | --- | --- |
| `Joint_Width` | `12` | mm. Width of the tab neck at the seam. The T-hook head is wider by T Head Overhang on each side. |
| `Joint_Depth` | `6` | mm. How far a tab reaches past the seam. |
| `Joint_Floor_Gap` | `1` | mm. Gap between each tab and the table. The socket is open below the tab, so nothing pushes a tab up or down. |
| `Joint_Thickness` | `0` | mm. Tab thickness at the seam. 0 = as thick as the board allows. The top falls at 45 degrees to the tip, so the tab prints without supports. |
| `Joint_Bottom_Chamfer` | `0.8` | mm. Chamfer around the underside of each tab. On T-hook panels, also the bevel on every underside edge and on the socket mouth. |
| `Joint_Flank_Angle` | `45` | Degrees. Dovetail only: angle of each tab side from straight across the seam. More = a pulled seam opens less. |
| `Joint_Spacing` | `60` | mm. Approximate distance between tabs on a long seam. Each seam has at least two tabs. |
| `Joint_Edge_Margin` | `25` | mm. Preferred distance from a joint to a panel corner. |
| `T_Head_Overhang` | `2.5` | mm. T-hook only: how far the head extends on each side of the neck. |
| `T_Shoulder_Length` | `2` | mm. T-hook only: distance from the seam to the retaining shoulders. |
| `T_Spacing_Relief` | `0.4` | mm. T-hook only: extra clearance along the seam at each socket after the first on an edge. |
| `T_Neck_Relief` | `0.35` | mm. T-hook only: extra clearance on each side of the socket neck. The head keeps Joint Clearance. |

### 09 - Keys

| Parameter | Default | Description |
| --- | --- | --- |
| `Key_Length` | `22` | mm. Keys only: length of each butterfly key across the seam. |
| `Key_Width` | `14` | mm. Keys only: width of each key at its ends. |
| `Key_Waist` | `7` | mm. Keys only: width of each key at its waist, on the seam. |
| `Key_Thickness` | `4` | mm. Keys only: thickness of each key, and the depth of its pocket in the underside. |
| `Key_Clearance` | `0.15` | mm. Keys only: space on each side between a key and its pocket. A small value gives a press fit. |
| `Key_Spares` | `2` | Keys only: extra keys to print, in case one is lost. |

### 10 - Underside

| Parameter | Default | Description |
| --- | --- | --- |
| `Underside_Relief` | `0.3` | mm. Recess the middle of each panel's underside, so that the panel stands on a band near its edges. Both sides of a seam then stand on the same part of the table. 0 = flat underside. |
| `Support_Band` | `25` | mm. Width of the band that the panel stands on. It covers the sockets. |
| `Socket_Frame` | `true` | Cut a bevelled frame round the mouth of each connector socket, for its look. The frame follows the outline of the socket with its inner corners filled in. It takes the first 0.4 mm of the shoulders that hold a connector, which leaves almost all of their grip. |

### 11 - Maker's mark

| Parameter | Default | Description |
| --- | --- | --- |
| `Mark_Line_1` | `""` | The main line of the mark (銘), cut into the underside of panel 0, 0: your name or brand. Empty = no mark. |
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

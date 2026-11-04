# Make the whole set

A full shogi set has four parts. This page shows how they fit together, what
each one needs, and where its detailed guide is.

<!-- TODO(photo): the four parts together: board assembled, two komadai at
     the right of each player, pieces in the box with the lid beside it.
     Save as images/whole-set.jpg. -->

| Part | What it is | Ready-made download? | You need | Colors | Guide |
| --- | --- | --- | --- | --- | --- |
| Koma (駒), the pieces | 40 pieces | [Yes](ready-sets.md) | A slicer; or OpenSCAD + Python + fonts to make your own | 3 | [ready sets](ready-sets.md), [user guide](user-guide.md) |
| Ban (盤), the board | 9 × 9 squares, 333.6 × 363.3 mm, in 4 panels for a 256 mm bed | Not yet | OpenSCAD + Python + fonts | 2: body and black lines | [board guide](ban.md) |
| Komadai (駒台), the stands | Two stands for captured pieces, one per player | Not yet | OpenSCAD | 1 | [komadai guide](komadai.md) |
| Komabako (駒箱), the box | A box and lid that hold the 40 pieces | Not yet | OpenSCAD | 1 | [komabako guide](komabako.md) |

All parts are PLA. To install the tools, see [install](install.md).

## Suggested order

1. Print the pieces first. Their size sets the size of the squares, the
   stands and the box. The bundled presets of all four parts already match
   the bundled pieces, so you can skip this if you print a ready-made set.
2. Print the board's joint test. It is two small blocks with one joint,
   and takes far less filament than a panel. It tells you which connector
   fit your printer needs. See [board guide: print](ban.md#print).
3. Print the board, one panel per plate. Each panel is a long print.
4. Print the komadai pair and the box. They are one color, with no
   supports.

## The board, in short

The default board, **Shogi - 2 x 2 panels**, is a full-size board that fits
a 256 × 256 mm bed in four panels. The panels hold together with small
printed connectors that press into sockets under the seams. A spring in each
connector pulls the seam closed. You don't need glue, screws or tools to put
it together. The connector joint is new and has not yet been confirmed in a
full printed board. Print the joint test first.

```bash
python3 komascad.py ban "Shogi - 2 x 2 panels" -n     # list the files it will make
python3 komascad.py ban "Shogi - 2 x 2 panels"        # make them
```

The files go to `exports/ban/Shogi - 2 x 2 panels/`. Print
`... - Whole board.3mf`: it holds every panel and every connector, one plate
per bed load. Filament 1 is the board color, filament 2 the black lines.

To put it together, lay the panels face down in their places, press a
connector into each socket with your thumb, and turn the board over. To
take it apart, lift the panels straight up, starting with the back-right
one. The [board guide](ban.md#put-the-board-together) has every step.

Lost a connector? Print another from `... - Connectors.3mf`, or use an
M4 × 22 socket head screw and an M4 nut from a hardware store.

For a smaller printer, there are presets with 3 × 3 panels for a 180 mm bed,
and one-piece boards for minishogi. `python3 komascad.py ban` lists them all.

## The stands and the box

They print in one color, so you export them straight from OpenSCAD:

1. Open `komadai/komadai.scad` (or `komabako/komabako.scad`) in OpenSCAD.
2. Set **Output Mode** to **Pair to print** (komadai) or **Box and lid**
   (komabako).
3. Press **F6**, wait for the render, and select
   **File → Export → Export as STL**.
4. Open the STL in your slicer and print it.

The defaults match the bundled pieces and the 12 mm board.

## Storage

- Pieces: in the box. It holds the 40 pieces loose.
- Board: take the panels apart and store them flat. Keep the connectors
  together in a small bag, so none go missing.

## Make it yours

Put your name or emblem on the board, the stands and the box with a
[maker's mark](makers-mark.md), and on the heel of each piece with a
[signature](design-guide.md#add-a-signature).

# Glossary

Plain-language meanings of the printing, software and shogi words used in
these guides. For more shogi terms, see the
[glossary in How to play](play/how-to-play.md#glossary).

## 3D printing

**3MF**
: A 3D file format that can hold several parts, their colors and which
  filament prints each one. KomaSCAD's files are *color 3MFs*: one file
  holds the body and the lettering of every piece, each on its own filament.

**AMS (Automatic Material System)**
: Bambu Lab's add-on that holds several spools and feeds the printer the
  right one. The AMS lite is the version for the A1 printers. Other makers
  have similar units.

**Arachne**
: A way for the slicer to draw walls with varying line width. It fills thin
  letter strokes better than the older "Classic" walls.

**Bed, build plate, plate**
: The flat surface the print is made on. "Bed size" is the largest area the
  printer can print on. A *plate* in the slicer is one bed-load of parts.

**Bevel (chamfer)**
: A small slanted cut along an edge. KomaSCAD pieces have a 0.3 mm bevel on
  every edge, mainly to hide *elephant's foot*.

**Brim**
: Extra lines around the bottom of a part to help it stick to the plate.
  KomaSCAD pieces don't need one.

**Elephant's foot**
: The first layer of a print is pressed onto the plate, so it spreads a
  little wider than the layers above. On a flat piece this leaves a thin lip
  around the bottom face. The edge bevel hides it.

**Filament**
: The plastic strand, on a spool, that an FDM printer melts. KomaSCAD uses
  PLA.

**Filament slot (extruder number)**
: The number the slicer gives each filament: 1, 2, 3 and so on. Each part
  of a KomaSCAD file names its slot. The slot number is a position in the
  slicer; you can load any color in it.

**First layer filament sequence**
: A plate setting in Bambu Studio that sets which filament prints first on
  layer 1. For KomaSCAD, the body (filament 1) goes first.

**Flow ratio**
: A multiplier for how much plastic the printer pushes out. A few percent
  too little leaves grooves; a few percent too much makes blobs. Calibrating
  it means printing a test and choosing the best value for each spool.

**FDM printer**
: The common kind of home 3D printer, which builds a part from melted
  filament, one layer at a time.

**G-code**
: The list of moves and temperatures that the slicer writes and the printer
  follows. You don't need to read it.

**Infill and walls**
: Walls are the outer lines of each layer; infill is the pattern that fills
  the inside. The first layer of a KomaSCAD piece is mostly solid infill,
  which is why its direction and speed matter.

**Layer height**
: How thick each printed layer is. The KomaSCAD profile uses 0.15 mm.

**Nozzle**
: The hot tip the plastic comes out of. Its width (usually 0.4 mm) limits
  the finest line the printer can make.

**PEI plate (smooth or textured)**
: A common removable, flexible build plate. A smooth PEI plate gives a
  satin face; a textured one prints its texture into the face.

**PLA**
: The most common, easiest filament. Matte PLA and wood-filled PLA (PLA with
  wood fiber) look most like real pieces.

**Pressure advance**
: A printer setting that evens out the flow when the print head speeds up
  or slows down. It helps a little; the flow ratio matters far more.

**Prime tower and purge**
: When a single nozzle changes color, the old color has to be pushed out.
  The waste goes into a *prime tower* printed beside the parts, or out of
  the printer as a "purge". Every multi-color print wastes some filament.

**Profile (process preset)**
: A saved set of slicer settings. KomaSCAD has one for the Bambu Lab A1.

**Skirt**
: A few loose lines printed around the parts before they start. KomaSCAD's
  profile prints 6, so the plastic flows steadily before it draws the
  letters. Peel it off afterwards.

**Slicer**
: The program that turns a 3D file into instructions for the printer:
  Bambu Studio, OrcaSlicer, Elegoo Slicer, PrusaSlicer and others.

**STL**
: A simple 3D file format: one shape, no colors. Use it for one-color parts
  such as the komadai and the box.

**Supports**
: Temporary structures that hold up parts of a print that hang in the air.
  Nothing in KomaSCAD needs them.

**Toolchanger**
: A printer with several separate print heads, one per filament. It can
  print several colors without purging.

## Software

**Command, terminal**
: A *terminal* is a window where you type commands instead of clicking. On
  Windows it is called Command Prompt or Terminal; on a Mac, Terminal. The
  [install guide](install.md#open-a-terminal-in-the-komascad-folder) shows
  how to open one.

**Customizer**
: OpenSCAD's panel of settings, with sliders and boxes, at the right of the
  window. KomaSCAD's settings all appear there.

**Download ZIP / clone**
: Two ways to get the files of this project. *Download ZIP* (green **Code**
  button on GitHub) gives you a normal folder. *Cloning* uses the Git tool
  and lets you update later; you don't need it.

**Export, build**
: `komascad.py export` writes the 3MF print files. `komascad.py build`
  regenerates the preset files after you edit the piece definitions.

**F5 and F6**
: In OpenSCAD, **F5** shows a fast preview. **F6** makes the full, exact
  model, which can take minutes; you need it before you can save an STL.

**JSON**
: A plain-text file format for settings. KomaSCAD's presets are JSON files.

**OpenSCAD**
: The free program that builds KomaSCAD's 3D models from code. You need it
  only to make your own pieces or the board, stands and box.

**Output Mode**
: A setting in **01 - Start here** of every KomaSCAD model. It chooses
  what OpenSCAD shows or exports: the model, one face for inspection, one board panel, and so on.

**PATH**
: The list of folders where your computer looks for programs you type in a
  terminal. "OpenSCAD on your PATH" means you can type `openscad` and it
  runs. If it isn't, give the tool its location with `--openscad`.

**Preset**
: A named group of settings, such as **Shogi 09 - Pawn**. Pick one at the
  top of the Customizer to load it.

**Release**
: A published version of the project on GitHub, with ready-to-print files
  attached. See the
  [Releases page](https://github.com/Kazutadashi/koma-scad/releases).

**Repository (repo)**
: The project's folder of files on GitHub.

## Shogi and KomaSCAD

**Ban (盤)**
: The board.

**Front-down, back-down, upright**
: How a piece lies on the bed: on its front (black-lettered) face, on its
  back face, or standing on its heel. KomaSCAD prints front-down.

**Heel**
: The wide, flat bottom edge of a piece. Your signature can go there.

**Koma (駒)**
: A shogi piece.

**Komabako (駒箱)**
: The box for the pieces.

**Komadai (駒台)**
: The small stand next to the board where each player keeps captured pieces.

**Learner pieces**
: Pieces with a small diagram of their moves on each face.

**Maker's mark (銘)**
: Your name or emblem, under the board, the stands and the box.

**Promoted side**
: The back of a piece. A piece that moves into, within or out of the
  promotion zone (the far three rows) can turn over to show it, and then
  moves differently. Its letters are red.

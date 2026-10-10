# Getting started

This guide tells you how to install KomaSCAD, print a bundled set, and design
your first piece.

## Requirements

- [OpenSCAD 2021.01](https://openscad.org/downloads.html). The `openscad`
  command must be on your PATH.
- Python 3.8 or later. The tool uses only the standard library.
- The fonts in [fonts/](../fonts/suggested_fonts.md). The bundled sets use
  Yuji Syuku and LXGW WenKai Mono.
- A filament 3D printer. For color, you need a printer that can change
  filament.

## Install

1. Download the repository (**Code → Download ZIP**), or clone it with Git.
2. Install the fonts from `fonts/`.
3. Restart OpenSCAD.

Keep `shogi_piece.scad`, `move_diagrams.scad` and `shogi_piece.json` in the
same folder. OpenSCAD reads the presets from the JSON file that has the same
name as the model.

## Print a set

Open a terminal in the repository folder. Then do these steps:

1. Show the games:

   ```bash
   python3 komascad.py list
   ```

2. Check the pieces on one page. Open the HTML file that the command shows.

   ```bash
   python3 komascad.py preview shogi
   ```

3. Export the full set as one color 3MF:

   ```bash
   python3 komascad.py export shogi --per-file all --orientation front-down
   ```

4. Open the 3MF from `exports/shogi/` in your slicer.
5. Load filament 1 = wood, 2 = black, 3 = red.
6. Print one piece first. Then print the set.

The [print guide](printing/print-guide.md) gives the slicer settings that we
use. The [command reference](cli.md) gives all export options.

## Design a piece

1. Open `shogi_piece.scad` in OpenSCAD.
2. If you cannot see the Customizer, clear **Window → Hide Customizer**.
3. Select a preset, for example **Shogi 01 - King (Osho)**.
4. Change the settings. The preview changes immediately.
5. Set **Output Mode** to **Inspect front**. Red text is outside the safe
   area: make it smaller or move it.
6. Set **Output Mode** to **Model** again.
7. Save your settings as a new preset (the **+** button).
8. For one color: press F6, then **File → Export → Export as STL**.
9. For several colors: export the preset with the tool:

   ```bash
   python3 komascad.py export shogi_piece.json "My piece"
   ```

The [design guide](design-guide.md) tells you how to change the shape, the
text, the colors and the signature. To change the bundled sets themselves,
see the [user guide](user-guide.md).

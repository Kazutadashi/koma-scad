# Getting started

This tutorial takes you through the full process once: you design a piece,
export it and print it.

## Requirements

- [OpenSCAD 2021.01](https://openscad.org/downloads.html). The `openscad`
  command must be on your PATH.
- Python 3.10 or later. The tool uses only the standard library.
- The fonts in [fonts/](../fonts/suggested_fonts.md).
- A filament 3D printer. For color pieces, you need a printer that can change
  filament, such as a printer with an AMS.

## Install

1. Download the repository (**Code → Download ZIP**), or clone it with Git.
2. Install the fonts from `fonts/`.
3. Restart OpenSCAD.

Keep `shogi_piece.scad`, `move_diagrams.scad` and `shogi_piece.json` in the
same folder. OpenSCAD reads the presets from the JSON file that has the same
name as the model.

## 1. Design a piece

1. Open `shogi_piece.scad` in OpenSCAD.
2. If you cannot see the Customizer, clear **Window → Hide Customizer**.
3. Select a preset to start from, for example **Shogi 01 - King (Osho)**.
4. Type your text in **Front Characters** and **Back Characters**.
5. Change the other settings that you want. The preview changes immediately.
6. Set **Output Mode** to **Inspect front**. Red text is outside the safe
   area: make it smaller or move it. Do the same with **Inspect back**.
7. Set **Output Mode** to **Model** again.
8. Save your settings as a new preset: select **+** and type a name, for
   example `My piece`.

The [design guide](design-guide.md) tells you what each group of settings
does.

## 2. Export it

Open a terminal in the repository folder. Export the preset as a color 3MF:

```bash
python3 komascad.py export shogi_piece.json "My piece" --orientation front-down
```

The tool first measures the lettering. If strokes or gaps are too fine to
print, it stops and tells you which. When the export is done, the file is
`exports/shogi_piece/My piece.3mf`.

The exporter reads saved presets only. Save your changes before you export.

For a one-color piece, you can export from OpenSCAD instead: press F6, then
select **File → Export → Export as STL**.

> **WARNING:** Do not use **File → Export → Export as 3MF** for a color
> piece. OpenSCAD 2021.01 puts all colors into one part.

## 3. Print it

1. Open the 3MF in Bambu Studio, OrcaSlicer or Elegoo Slicer.
2. Load a filament in each slot that the file uses. The slots follow the
   parts in order: the body, then the front text, then the back text. Each
   part has a name such as **Front | Black**.
3. Make sure that each part shows the correct color.
4. Set the slicer as the [print guide](printing/print-guide.md) tells you.
   Print the piece flat, with the front face down on a smooth PEI plate.
5. Print the piece.

## Next steps

- To print a full set, or to change the bundled sets, see the
  [user guide](user-guide.md).
- To add a diagram of the moves to a piece, see
  [movement diagrams](move-diagrams.md).
- To find the smallest lettering that your printer can make, print the
  [print test page](print-test-page.md).

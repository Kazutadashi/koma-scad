# Getting started: make your first piece

This tutorial takes you through the whole process once: you design a piece
with your own lettering, export it as a color 3MF, and print it. To print a ready-made set instead, see
[ready-made sets](ready-sets.md).

Before you start, install OpenSCAD, Python and the fonts, and check that
`python3 komascad.py list` works. The [install guide](install.md) has steps
for Windows, macOS and Linux. On Windows, type `py` wherever this guide says
`python3`.

## 1. Design a piece

1. Open `koma/koma.scad` (in the KomaSCAD folder) in OpenSCAD.
2. The **Customizer** is the settings panel on the right. If you cannot see
   it, clear **Window → Hide Customizer**.
3. At the top of the Customizer, select a preset to start from, for example
   **Shogi 01 - King (Osho)**. A *preset* is a saved group of settings.
4. Type your text in **Front Characters** and **Back Characters**.
5. Change any other settings you like. The preview updates as you go (if it
   doesn't, press **F5**).
6. Set **Output Mode** to **Inspect front**. Text shown in red is outside the
   safe area: make it smaller or move it. Do the same with **Inspect back**.
7. Set **Output Mode** back to **Model**.
8. Save your settings as a new preset: click **+** next to the preset list
   and type a name, for example `My piece`.

The [design guide](design-guide.md) explains what each group of settings
does.

## 2. Export it

[Open a terminal in the KomaSCAD folder](install.md#open-a-terminal-in-the-komascad-folder),
and export your preset as a color 3MF:

```bash
python3 komascad.py export koma/koma.json "My piece" --orientation front-down
```

The tool first measures the lettering. If strokes or gaps are too fine to
print, it stops and tells you which. Otherwise it renders the piece, with
progress messages as it goes, and writes `exports/koma/My piece.3mf`.

Good to know:

- The exporter reads saved presets only. Save your changes in the
  Customizer before you export.
- If the file already exists, the tool skips it. Add `-f` to write it again.
  Add `-n` to see what it would do without rendering anything.
- For a one-color piece, you can export from OpenSCAD instead: press
  **F6**, then select **File → Export → Export as STL**.

> **Warning:** Don't use **File → Export → Export as 3MF** in OpenSCAD for a
> color piece. OpenSCAD 2021.01 puts all colors into one part. Use
> `komascad.py export`.

## 3. Print it

1. Open the 3MF in your slicer. Bambu Studio is tested and Elegoo Slicer
   opens the files. OrcaSlicer is expected to work but is not tested yet.
2. Load wood, black and red as filaments 1, 2 and 3. Each part has a name
   such as **Front | Black**.
3. Check that each part shows the right color. The piece lies face down, so
   tilt the view to see the front.
4. Print it on a smooth PEI plate, with the body printing first on layer 1.

[Print your first set](print/first-print.md) explains each of these steps in
the slicer, and the [print guide](print/print-guide.md) has every setting.

## Next steps

- Print or change a full set: the [user guide](user-guide.md).
- Add a diagram of the moves to a piece:
  [movement diagrams](move-diagrams.md).
- Find the smallest lettering your printer can make: the
  [print test page](print/print-test-page.md).
- Keep `koma.scad`, `move_diagrams.scad` and `koma.json` together in the
  `koma/` folder, with `lib/` next to it. OpenSCAD reads the presets from the
  JSON file that has the same name as the model, and the model includes the
  others.

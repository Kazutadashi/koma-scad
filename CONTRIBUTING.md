# Contributing

Bug reports, print results and code changes are welcome. Use GitHub issues and
pull requests.

## Report a problem

Give this information:

- The preset file and the preset name.
- The exact font name.
- Your OpenSCAD version.
- The full OpenSCAD Console output, or the full `komascad.py` error.

For print results, also give the printer, the nozzle size, the filament, the
slicer and the layer height.

## How the code is organized

### shogi_piece.scad

The file starts with the Customizer settings. The code after `/* [Hidden] */`
is in ten numbered sections:

| Section | Contents |
| --- | --- |
| 1. Face settings | Small functions that read a setting for the front or the back (`f` is true for the front) |
| 2. Piece body | The plan outline, the face slopes and the body polyhedron |
| 3. Text layout | Font size, spacing and the position of each character slot |
| 4. Movement diagrams | The size of each face's diagram. The solver is in `move_diagrams.scad`. |
| 5. The printed piece | Text relief, the heel signature and the exact one-color piece |
| 6. Color parts | The parts that `komascad.py` puts in a color 3MF |
| 7. Fast preview | The F5 display of Model |
| 8. Inspection views | Inspect front, back, signature, pawn circle and printability |
| 9. Checks | Messages that stop a piece that cannot print |
| 10. Output | Selects what to draw from Output Mode |

Rules:

- Add a Customizer setting only above `/* [Hidden] */`. Give it a one-line
  comment that starts with its unit.
- Add the setting to [docs/parameters.md](docs/parameters.md). A test makes
  sure that the reference lists every setting.
- Do not rename a setting. Saved presets use the names.
- Add a check only for a setting that can make a bad piece. The Customizer
  already limits sliders and lists.

### Movement diagram solver

The solver is in two places: `move_diagrams.scad`, and the
`<script id="solver">` block of `move-editor.html`. Change both in the same
way. `MoveEditorTests` compares them (they need `node` and `openscad`).

### komascad.py

| Part | Contents |
| --- | --- |
| Building game presets | Merges `presets/pieces/` and `presets/games.json` into the game files |
| The print test page | Defines every piece of the print test page |
| Reading preset files | Finds games and pieces by name |
| Running OpenSCAD | Turns a preset into `-D` arguments, renders the color parts, reads STL files |
| Printability | Measures thin strokes and narrow gaps |
| Writing 3MF files | Packs the parts, the colors and the filament slots |
| Exporting, Previewing | The `export` and `preview` commands |
| Command line | Every option and its help text |

## Run the tests

```bash
python3 -m unittest discover tests
```

Most tests need only Python. Some also need `openscad` or `node`. They are
skipped when the program is not installed.

## Write documentation

Write the guides in ASD-STE100 Simplified Technical English:

- Write one instruction in each sentence. Start it with a verb: "Open the
  file."
- Keep a procedure sentence to 20 words or fewer. Keep a description sentence
  to 25 words or fewer.
- Use the active voice.
- Use one word for one thing. For example, always write "preset", not
  "profile" or "design".
- Write the setting names as the Customizer shows them, for example
  **Output Mode**, or as code, for example `Output_Mode`.

## Make a release

Do these steps from the repository root:

1. Run the tests:

   ```bash
   python3 -m unittest discover tests
   ```

2. Make sure that the generated presets are current. The command fails and
   names the old files if they are not.

   ```bash
   python3 komascad.py build --check
   ```

3. Export a full set. This renders every piece and checks each mesh:

   ```bash
   python3 komascad.py export shogi --per-file all -o /tmp/komascad-release
   ```

4. Make a preview, and look at every face:

   ```bash
   python3 komascad.py preview shogi
   ```

5. Open the 3MF in a slicer. Make sure that each piece shows its body, front
   and back parts in their colors.
6. Read [LICENSES.md](LICENSES.md). Make sure that each file in `models/` has
   its license file.
7. Make sure that `VERSION` in `komascad.py` and `version` in
   `shogi_piece.scad` are the same.

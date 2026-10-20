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

KomaSCAD has one folder for each module: a part of a shogi set. The other
folders hold what the modules share.

| Path | Contents |
| --- | --- |
| `koma/` | Koma (駒), the pieces |
| `koma/koma.scad` | The piece generator |
| `koma/move_diagrams.scad` | The movement diagram solver used by the generator |
| `koma/move-editor.html` | The movement diagram editor |
| `koma/presets/` | Piece definitions, game definitions and generated presets |
| `ban/` | Ban (盤), the board. Planned. |
| `komadai/` | Komadai (駒台), the piece stand. Planned. |
| `komabako/` | Komabako (駒箱), the piece box. Planned. |
| `lib/` | OpenSCAD code that more than one module uses |
| `komascad.py` | The command-line tool: build, preview, check and export |
| `komascad_lib/` | The code of the command-line tool |
| `docs/` | Guides and references |
| `fonts/` | Redistributable open fonts and their licenses |
| `data/` | Taikyoku piece data (CC BY-SA 4.0) |
| `models/` | Released print files |
| `tests/` | Tests for the tool, the generator and the editor |

### Add a module

Give each module the same layout. For a module named `NAME`:

| Path | Contents |
| --- | --- |
| `NAME/README.md` | What the module makes, and its files |
| `NAME/NAME.scad` | The model |
| `NAME/NAME.json` | The Customizer presets. OpenSCAD reads the JSON file that has the same name as the model. |
| `NAME/presets/` | Preset sources and generated presets, if the module needs them |

Rules:

- Use the Japanese name of the part, in romaji, as `NAME`.
- Start the `.scad` file with the same header as `koma/koma.scad`.
- Put code that two modules use in `lib/`. Do not include one module's file
  from another module.
- Add the module's paths to `komascad_lib/project.py` next to `KOMA`.
- Add the module to the table above and to [README.md](README.md).

### koma/koma.scad

The file starts with the Customizer settings. The code after `/* [Hidden] */`
is in ten numbered sections:

| Section | Contents |
| --- | --- |
| 1. Face settings | Small functions that read a setting for the front or the back (`f` is true for the front) |
| 2. Piece body | The plan outline, the face slopes and the body polyhedron |
| 3. Text layout | Font size, spacing and the position of each character slot |
| 4. Movement diagrams | The size of each face's diagram. The solver is in `koma/move_diagrams.scad`. |
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

The solver is in two places: `koma/move_diagrams.scad`, and the
`<script id="solver">` block of `koma/move-editor.html`. The two have the same
steps, in the same order: `mv_stop_marks` is `stopMarks`, `mv_tip` is
`tipOf`, and so on. Change both in the same way. `MoveEditorTests` compares
them (they need `node` and `openscad`).

### komascad.py and komascad_lib/

`komascad.py` only starts the tool. The code is in `komascad_lib/`, one
module for each job:

| Module | Contents |
| --- | --- |
| `project.py` | The project paths, the version and `KomaError` |
| `presets.py` | Builds the game presets from `koma/presets/pieces/`; finds, reads, selects and edits presets |
| `print_test_page.py` | Every piece of the print test page |
| `openscad.py` | Turns a preset into `-D` arguments, renders the color parts, reads STL files |
| `printability.py` | Measures thin strokes and narrow gaps |
| `threemf.py` | Writes the 3MF: parts, colors, bed layout and filament slots |
| `export.py` | Plans an export, writes its files and the manifest |
| `preview.py` | The HTML preview page |
| `cli.py` | The commands, their options and their help text |

Rules:

- Keep `cli.py` thin: it reads the options and prints. Put the work in the
  other modules.
- Raise `KomaError` for a problem that the user can fix. The tool prints its
  message without a traceback. Any other exception is a bug, and shows one.
- Use only the Python standard library. The tool must run with Python 3.10.

## Python code style

The Python code follows [PEP 8](https://peps.python.org/pep-0008/), with
docstrings in the
[Google style](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings).
[Ruff](https://docs.astral.sh/ruff/) applies and checks the style. You do not
need to install it: [uv](https://docs.astral.sh/uv/) runs it.

Before you send a change, run these two commands from the project folder:

```bash
uvx ruff format    # lays out the code
uvx ruff check     # reports style problems and likely bugs
```

`ruff.toml` holds the settings, and `.editorconfig` sets up most editors.

The JavaScript and CSS of `koma/move-editor.html` follow
[Prettier](https://prettier.io/). Node runs it without an install:

```bash
npx prettier --write .     # lays out koma/move-editor.html
```

The JavaScript has [JSDoc](https://jsdoc.app/) comments, the counterpart of
the Python docstrings. Its solver uses the same steps and names as
`koma/move_diagrams.scad`, so that a change to one is easy to find in the other.

Write code that a new contributor can read in one pass:

- Write one idea on each line. Give an intermediate value a name instead of
  nesting calls.
- Put a blank line between the steps of a function.
- Give every number a name and, if it is not obvious, a comment that says why
  it has that value. 0, 1 and 2 are fine as they are.
- Do not put logic in f-string braces: only names and simple attributes.
- Prefer a plain loop or an if/else block to a nested comprehension, a
  conditional expression that hides a decision, the walrus operator (`:=`), or
  `x or default`.
- Give every function type hints and a Google-style docstring with `Args:`,
  `Returns:` and `Raises:`.
- Comment only what a reader cannot see quickly in the code: why, not what.

## Run the tests

```bash
python3 -m unittest
```

Most tests need only Python. Some also need `openscad`, `node`, `ruff` or
`prettier`. They are skipped when the program is not installed.

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
   python3 -m unittest
   ```

2. Make sure that the code style is clean:

   ```bash
   uvx ruff format --check
   uvx ruff check
   npx prettier --check .
   ```

3. Make sure that the generated presets are current. The command fails and
   names the old files if they are not.

   ```bash
   python3 komascad.py build --check
   ```

4. Export a full set. This renders every piece and checks each mesh:

   ```bash
   python3 komascad.py export shogi --per-file all -o /tmp/komascad-release
   ```

5. Make a preview, and look at every face:

   ```bash
   python3 komascad.py preview shogi
   ```

6. Open the 3MF in a slicer. Make sure that each piece shows its body, front
   and back parts in their colors.
7. Read [LICENSES.md](LICENSES.md). Make sure that each file in `models/` has
   its license file.
8. Set the new version in `VERSION` in `komascad_lib/project.py` and in
   `version` in `koma/koma.scad`. A test checks that they are the same.

# Contributing

KomaSCAD depends on print results as much as on code, so print reports are
as useful as pull requests. Everyone taking part follows the
[code of conduct](CODE_OF_CONDUCT.md).

## Ways to help

- Send a
  [print report](https://github.com/Kazutadashi/koma-scad/issues/new?template=print-report.yml)
  after you print a set, whether it went well or not. Reports from printers
  and slicers that haven't been tested yet are the most useful.
- Report a bug with the
  [bug report form](https://github.com/Kazutadashi/koma-scad/issues/new?template=bug.yml).
- Share a slicer profile for another printer or slicer, in
  `docs/print/<slicer>/`.
- Improve the docs where something was unclear.
- Change the code: new pieces, games, fonts and fixes.

## Report a problem

The bug form asks for these; have them ready:

- The game or preset file, and the preset name.
- The exact font name.
- Your OpenSCAD version (**Help → About**) and your operating system.
- The full OpenSCAD Console output, or the full `komascad.py` error.

For print results, also give the printer, the nozzle size, the filament, the
slicer and the layer height, and a photo of a piece face.

## Set up

1. Clone the repository (or fork it first, to send a pull request).
2. Install OpenSCAD, Python 3.10 or later and the bundled fonts, as the
   [install guide](docs/install.md) describes.
3. Check that it works: `python3 komascad.py list`.

There is nothing to `pip install`: the tool uses only the standard library.
If you want a `komascad` command, `pip install -e .` adds one from
`pyproject.toml`; it must be an editable install, because the tool reads the
models and presets from the repository folder.

## Run the tests

From the repository folder:

```bash
python3 -m unittest discover -t . -s tests
```

Most tests need only Python. Some need other programs, and are skipped when
they are not installed:

| Program | Un-skips |
| --- | --- |
| `openscad` (with the bundled fonts installed) | Model, board and printability tests |
| `node` | The move editor's solver tests |
| `ruff` on the PATH | The Python style tests (or run `uvx ruff check` yourself) |
| `prettier` on the PATH | The move editor's formatting test (or run `npx prettier --check .`) |

Also check that the generated presets are current:

```bash
python3 komascad.py build --check
```

The [CI workflow](.github/workflows/ci.yml) runs all of these on every pull
request.

## Code style

Python follows PEP 8 with Google-style docstrings, applied by
[Ruff](https://docs.astral.sh/ruff/). You don't need to install it:
[uv](https://docs.astral.sh/uv/) runs it.

```bash
uvx ruff format    # lays out the code
uvx ruff check     # reports style problems and likely bugs
npx prettier --write .    # lays out koma/move-editor.html
```

The [architecture guide](docs/dev/architecture.md) describes how the code is
organized, the rules for each model and module, and the house style for
readable code.

## Send a pull request

1. Make one change per pull request, on a branch.
2. Run the tests, `build --check` and the style checks.
3. If you changed a `.scad` setting, update its reference page (a test
   checks this). If you changed piece files, run `python3 komascad.py build`
   and commit the generated presets too.
4. Add a line to [CHANGELOG.md](CHANGELOG.md) under **Unreleased**.
5. Fill in the pull request template.

## Write documentation

Write for an intelligent adult who has never 3D printed, never used a
terminal, or never played shogi. Often it's all three.

- Write plain, direct English, and don't talk down to the reader.
- Don't use em-dashes. Use a period, a colon, a comma or parentheses.
- Avoid marketing style: no slogans ("No paint, no glue."), no "X, not Y"
  contrasts, no stacked bold lead-ins, no hype words. State the facts.
- Write procedures as numbered steps, one action per step, starting with a
  verb: "Open the file."
- Explain a technical word the first time, or link to the
  [glossary](docs/glossary.md). Add new words there.
- Use one word for one thing. For example, always write "preset", not
  "profile" or "design". (A slicer *profile* is a different thing.)
- Write setting names as the Customizer shows them, such as
  **Output Mode**, or as code, such as `Output_Mode`.
- Don't invent numbers. If a print time or a weight depends on the printer,
  say how to read it from the slicer.
- Don't link an image that doesn't exist. Leave an HTML comment
  `<!-- TODO(photo): ... -->` that names the photo needed.

## Releases

The maintainer's checklist is in [docs/dev/releasing.md](docs/dev/releasing.md).

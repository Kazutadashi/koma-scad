# KomaSCAD

![OpenSCAD](https://img.shields.io/badge/OpenSCAD-2021.01-yellow)
![Code license](https://img.shields.io/badge/code-MIT-blue)
![Data license](https://img.shields.io/badge/data-CC_BY--SA_4.0-green)

KomaSCAD is an open-source parametric generator for shogi pieces, written in OpenSCAD. It produces complete, printable 3D models of pieces from their inscribed characters and a defined set of parameters governing dimensions, edge geometry and lettering.

The project consists of the piece generator, ready-made presets for Shogi and Minishogi in traditional, single-character and learner styles, a command-line tool that builds, checks and exports complete sets as multicolor models, a browser-based editor for movement diagrams, and documentation covering piece geometry, lettering, printing and every configurable parameter.

<!-- Photo to add: a printed learner set. Replace the render below with it. -->
![OpenSCAD preview of a KomaSCAD king](images/preview.png)

KomaSCAD is tested on a Bambu Lab A1 with the AMS lite and a 0.4 mm nozzle, with color files imported into Bambu Studio and Elegoo Slicer. Print results from other printers and slicers are welcome.

## Piece design

Every dimension of a piece is a parameter: its length, heel width and thickness, the thickness at the point, the angles of its outline, the taper of its faces and the bevel on its edges. An optional pawn-circle constraint holds the outline to angles at which twenty pieces placed side by side close into a ring. The defaults reproduce the king of the bundled Shogi set.

Each face carries its own inscription, typically a piece's name on the front and its promoted name on the back. Any installed font that contains the required characters can be used. Size, spacing, position and proportions are set independently for each face, with further adjustment of individual characters, and stroke expansion thickens or thins the strokes of the chosen font. Lettering can be recessed into the face, raised from it, or inlaid level with it in a second material, and a maker's signature can be inscribed on the heel.

Inspection views in OpenSCAD mark the safe lettering region of each face, highlight lettering that overflows it, and show strokes and gaps too fine for the printer to reproduce. Designs are stored as named Customizer presets for reuse and sharing.

## Complete sets and multicolor export

The bundled Shogi and Minishogi sets are built from one shared definition per piece, so a change to a piece applies to every game that uses it. The command-line tool, `komascad.py`, exports a set either as one file per piece with a manifest of the quantities, or as complete layouts with the correct number of every piece arranged on the bed.

Each piece is a named object made of aligned parts for the body, the front lettering, the back lettering and, where present, the signature. Every part is assigned a filament slot, which Bambu Studio, OrcaSlicer and Elegoo Slicer use to assign the filaments without manual painting. The colors are also stored as standard 3MF properties for other software.

Before exporting, the tool measures the lettering of every piece against the printer's line width and stops if strokes would disappear or gaps would fill. A [print test page](docs/print-test-page.md) of 59 reference pieces measures what a given printer, filament and slicer profile can reproduce, and the [print guide](docs/printing/print-guide.md) records the slicer settings used for the bundled sets.

## Learner pieces and movement diagrams

<!-- Photo to add: one learner piece, close up, showing its movement diagram. -->

The learner sets add a diagram of each piece's moves below its characters, with the moves after promotion on the back. Diagrams are written as a small text grid that maps square by square onto the movement diagrams used on Wikipedia, and cover steps, jumps, ranging moves, flying moves, hook moves, igui and the lion's area move. This makes them suitable for variant pieces as well as standard Shogi; the repository includes Chu Shogi examples.

Every mark is built from a line width and a gap that the printer can reproduce, and the generator places the marks as close together as those sizes allow. A diagram that cannot fit on its piece stops the generator with a message rather than being reduced below a printable size.

The movement diagram editor, `move-editor.html`, runs in a web browser with nothing to install. It draws the grid, previews the complete piece, identifies marks that collide, suggests the smallest change that makes a diagram fit, and produces the settings for a piece file. The notation is described in [movement diagrams](docs/move-diagrams.md).

## Documentation

KomaSCAD requires OpenSCAD 2021.01 and, for the command-line tool, Python 3.8 or later; the tool uses only the Python standard library. New users should start with [getting started](docs/getting-started.md).

| Guide | Contents |
| --- | --- |
| [Getting started](docs/getting-started.md) | Installation, printing a set and designing a first piece |
| [User guide](docs/user-guide.md) | Changing the bundled sets, and adding pieces and games |
| [Design guide](docs/design-guide.md) | Designing a piece in OpenSCAD: shape, lettering, colors and signature |
| [Movement diagrams](docs/move-diagrams.md) | The diagram notation and how diagrams are sized |
| [Command reference](docs/cli.md) | Every `komascad.py` command and option |
| [Parameter reference](docs/parameters.md) | Every OpenSCAD setting, with its default value |
| [Print guide](docs/printing/print-guide.md) | Importing a color 3MF, slicer settings and printing |
| [Print test page](docs/print-test-page.md) | Measuring what a printer can reproduce |
| [Contributing](CONTRIBUTING.md) | Reporting problems, changing the code and making a release |

## Repository contents

| Path | Contents |
| --- | --- |
| `shogi_piece.scad` | The piece generator |
| `move_diagrams.scad` | The movement diagram solver used by the generator |
| `komascad.py` | The command-line tool: build, preview, check and export |
| `move-editor.html` | The movement diagram editor |
| `presets/` | Piece definitions, game definitions and generated presets |
| `docs/` | Guides and references |
| `fonts/` | Redistributable open fonts and their licenses |
| `data/` | Taikyoku piece data (CC BY-SA 4.0) |
| `models/` | Released print files |
| `tests/` | Tests for the tool, the generator and the editor |

## Contributors

[@imtrmu](https://github.com/imtrmu) gave the project its parametric approach and works on everything to do with printing it: refining printer and slicer settings, testing print orientations and plates, and suggesting the changes that make the pieces easier for others to print. See [CONTRIBUTORS.md](CONTRIBUTORS.md).

## License

The generator, the tools, the documentation, the images and the bundled Shogi and Minishogi presets are released under the [MIT License](LICENSE). The Taikyoku data and its presets are licensed under [CC BY-SA 4.0](LICENSES/CC-BY-SA-4.0.txt), and the bundled fonts under the SIL Open Font License. See [LICENSES.md](LICENSES.md) before sharing a print file.

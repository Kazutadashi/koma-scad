# KomaSCAD

KomaSCAD is a parametric generator for 3D-printed shogi equipment, written in OpenSCAD with a
Python command-line tool. It produces the pieces (koma), the board (ban), the piece stands
(komadai) and the box (komabako). Pieces are exported as multi-color 3MF files, with the
lettering printed in a second color flush with the face.

## Get a set

Ready-to-print 3MF files for the six piece sets are attached to each
[release](https://github.com/Kazutadashi/koma-scad/releases/latest). Printing them needs only a
slicer. See [Ready-made sets](docs/ready-sets.md) to choose one, and
[First print](docs/print/first-print.md) for a step-by-step guide to the slicer.

## Features

- Complete shogi and minishogi sets. A full 40-piece shogi set exports as one multi-color 3MF
  that fits on a single 256 × 256 mm build plate.
- Three piece styles: traditional two-character pieces, one-character pieces, and learner pieces
  that show each piece's moves on the front and its promoted moves on the back.
- Boards from minishogi (5 × 5) to taikyoku shogi (36 × 36), split into panels that fit common
  print beds and join with printed connectors.
- Every dimension, font and inscription is a parameter, so you can make your own sets.

## Repository layout

| Path                         | Contents                                              |
| ---------------------------- | ----------------------------------------------------- |
| [koma/](koma/)               | Piece generator, move diagrams and presets            |
| [ban/](ban/)                 | Board generator and board presets                     |
| [komadai/](komadai/)         | Piece stand                                           |
| [komabako/](komabako/)       | Piece box                                             |
| [lib/](lib/)                 | OpenSCAD code shared by the models                    |
| [komascad_lib/](komascad_lib/) | Code for the `komascad.py` command-line tool        |
| [fonts/](fonts/README.md)    | Bundled fonts and their licenses                      |
| [docs/](docs/README.md)      | Guides and reference                                  |
| [tests/](tests/)             | Test suite                                            |

## Requirements

To make your own sets, you need:

- [OpenSCAD](https://openscad.org/downloads.html) 2021.01 (the latest stable release)
- Python 3.10 or later (standard library only)
- The fonts in [fonts/](fonts/README.md), installed on your system

The stands and the box can be made in OpenSCAD alone. The pieces and boards are exported with
`komascad.py`, which needs both OpenSCAD and Python. See the [install guide](docs/install.md) for
Windows, macOS and Linux.

## Quick start

```bash
git clone https://github.com/Kazutadashi/koma-scad
cd koma-scad

python3 komascad.py list                               # available sets
python3 komascad.py check shogi-learner                # check that the lettering will print
python3 komascad.py preview shogi-learner              # render every piece to one HTML page
python3 komascad.py export shogi-learner --per-file all  # full 40-piece set in one 3MF
```

The export is written to `exports/shogi-learner/`. Run `python3 komascad.py COMMAND --help` for
the options of each command, or see the [command reference](docs/cli.md).

Boards are exported with the `ban` command:

```bash
python3 komascad.py ban                               # list board presets
python3 komascad.py ban "Shogi - 2 x 2 panels"        # export a board as color 3MF files
```

## Printing

The 3MF files open in Bambu Studio with the filament slots already assigned: slot 1 for the body,
slot 2 for the front lettering and slot 3 for the back lettering. A full set of 40 pieces fits on
a 256 × 256 mm bed. Pieces print lying on the front face, which gives the lettered face the
smooth finish of the build plate.

- [First print](docs/print/first-print.md): a step-by-step walkthrough of the slicer
- [Print guide](docs/print/print-guide.md): settings, calibration and troubleshooting
- [Board guide](docs/ban.md): printing and assembling the board

## Documentation

- [Getting started](docs/getting-started.md): design your first piece
- [User guide](docs/user-guide.md): change the sets, fonts, sizes and colors
- [Parameter reference](docs/parameters.md): every setting of the piece generator
- [How to play](docs/play/how-to-play.md): the rules of shogi
- [Full index](docs/README.md)

## Contributing

Bug reports, print results and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md)
for how to run the tests and submit changes.

## License

The code, documentation and presets are released under the [MIT license](LICENSE). The bundled
fonts are under the SIL Open Font License 1.1, and the Taikyoku shogi data is under CC BY-SA 4.0.
Prints made with KomaSCAD, including pieces lettered in the bundled fonts, may be shared and sold.
See [LICENSES.md](LICENSES.md) for details.

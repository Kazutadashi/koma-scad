# Koma (駒): the pieces

The koma are the playing pieces. This folder holds the piece generator and
everything that only the pieces use.

| Path | Contents |
| --- | --- |
| `koma.scad` | The piece generator. Open it in OpenSCAD. |
| `koma.json` | The Customizer presets of every game. `komascad.py build` makes it. |
| `move_diagrams.scad` | The movement diagram solver that `koma.scad` includes |
| `move-editor.html` | The movement diagram editor. Open it in a browser. |
| `presets/` | Piece files, game files and generated presets. See [presets/README.md](presets/README.md). |

Start with [getting started](../docs/getting-started.md).

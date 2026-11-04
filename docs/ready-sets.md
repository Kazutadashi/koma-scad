# Ready-made sets

These sets are ready to print. Each one is a single `.3mf` file with all 40
pieces of a shogi set, already laid out on one build plate, face down, with
every part on its filament slot. You don't need to install KomaSCAD to print
them.

Download the files from the
[Releases page](https://github.com/Kazutadashi/koma-scad/releases), then
follow the [first print guide](print/first-print.md).

## Choose a set

- Learner is for new players. Each piece shows a small diagram of its moves,
  and the back shows how it moves after promotion.
- Classic has two brush-style characters per piece, as on traditional wooden
  pieces.
- One character has one large character per piece, which is easier to read
  from across the board.

Each style comes in two fonts:

- Yuji Syuku, a brush-style font close to traditional carved lettering.
- LXGW WenKai Mono, a handwritten-style font with even, open strokes.

<!-- TODO(photo): one photo per set, front and promoted side, side by side.
     Save as images/sets/<game>.jpg and add a "Looks like" column. -->

## The sets

| Set | Release file | Front | Back (promoted side) | Font |
| --- | --- | --- | --- | --- |
| Learner | `komascad-VERSION-shogi-learner.3mf` | One character and a move diagram | One character and its move diagram | LXGW WenKai Mono |
| Learner, brush font | `komascad-VERSION-shogi-learner-syuku.3mf` | One character and a move diagram | One character and its move diagram | Yuji Syuku |
| Classic | `komascad-VERSION-shogi.3mf` | Two characters, such as 飛車 | One character, such as 龍 | Yuji Syuku |
| Classic, WenKai | `komascad-VERSION-shogi-wenkai.3mf` | Two characters | One character | LXGW WenKai Mono |
| One character | `komascad-VERSION-shogi-1char.3mf` | One character, such as 飛 | One character | Yuji Syuku |
| One character, WenKai | `komascad-VERSION-shogi-1char-wenkai.3mf` | One character | One character | LXGW WenKai Mono |

`VERSION` is the release number, such as `3.5`.

Every set has the same 40 pieces, the same sizes, and the same layout:

| | |
| --- | --- |
| Pieces | 2 kings (王 and 玉; 王将 and 玉将 on Classic), 2 rooks, 2 bishops, 4 golds, 4 silvers, 4 knights, 4 lances, 18 pawns |
| Plate | One plate, about 242 × 228 mm. It fits a 256 × 256 mm bed. |
| Orientation | Face down: the front (black lettering) lies on the plate. Don't flip the pieces. |
| Filament 1 | Body: a wood color |
| Filament 2 | Front lettering: black |
| Filament 3 | Promoted-side lettering: red |
| Material | PLA |
| Edge bevel | 0.3 mm on every edge, so the first layer does not leave a lip ([why](print/print-guide.md#why-the-edges-are-beveled)) |

The kings and the golds have a blank back: they cannot promote.

You can load any colors you like in the three
[filament slots](glossary.md#3d-printing), for example a dark wood body or
blue promoted sides.

Print time and filament use depend on your printer and settings. After you
slice, the slicer shows the print time and the grams of each filament.

## Each release also contains

- A `komascad-VERSION-GAME.manifest.json` for each set: the pieces in the
  file and how many of each.
- The licenses: KomaSCAD's MIT license, and the font licenses. See
  [LICENSES.md](../LICENSES.md). You may sell the pieces you print.

## Other sets and parts

- For minishogi, other fonts or colors, or your own lettering, make the set
  yourself. See [install](install.md), then the [user guide](user-guide.md).
- The board, the stands and the box are not included as ready-made files.
  See [make the whole set](whole-set.md).
- For a bed smaller than 242 × 228 mm, export the set in two files with
  `--per-file 20` (see the [command reference](cli.md#export)).

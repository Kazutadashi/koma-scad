# Licenses

KomaSCAD uses more than one license. This page explains which applies to
what, and what that means for the pieces you print. Please don't describe
the whole repository as "MIT".

## In short

- You may print, share and sell pieces, boards, stands and boxes made
  with KomaSCAD, including pieces lettered in the bundled fonts.
- If you share or sell files (the code, the presets, or exported 3MF and
  STL files), keep the license notices described below.
- Don't say or suggest that a font author, Wikipedia or a Wikipedia
  contributor endorses your product.

## What each license covers

| Material | License | When you share it |
| --- | --- | --- |
| The code (`.scad`, `.py`, `.html`), the documentation, the images and the bundled presets | [MIT](LICENSE) | Keep the MIT notice. |
| `data/taikyoku_*.csv`, `data/ATTRIBUTION.md` and `koma/presets/misc/taikyoku.json` | [CC BY-SA 4.0](LICENSES/CC-BY-SA-4.0.txt) | Keep the attribution and the license link. Share your changes under CC BY-SA 4.0. |
| `fonts/*.ttf` | SIL Open Font License 1.1 | Keep the notice from `fonts/licenses/`. Do not sell a font file by itself. |
| Exported print files (3MF, STL) | See [Print files](#print-files) | Include a license note. |

The Taikyoku data is kept apart, so the model and the shogi presets stay MIT.
CC BY-SA 4.0 permits commercial use. It needs attribution, and it needs
adaptations to use the same license.

This page explains the licenses; the full texts are elsewhere. The MIT text
is in [LICENSE](LICENSE), the CC BY-SA text in the [LICENSES/](LICENSES/)
folder, and the font licenses next to the fonts in
[fonts/licenses/](fonts/licenses/).

## Printed pieces and the bundled fonts

You can sell printed pieces, including pieces printed with the bundled fonts.

The SIL Open Font License covers the *Font Software*: the font files
themselves. The license says: "The requirement for fonts to remain under
this license does not apply to any document created using the fonts or
their derivatives." The lettering on a printed piece, and the outlines of the
characters in an exported 3MF or STL mesh, are made with the font; they are
not a copy of the font file, and a mesh cannot be installed or used as a
font. We therefore treat printed pieces and exported meshes as works created
with the fonts, which the license does not cover as Font Software.

What the license does restrict:

- Don't sell the font files by themselves. Bundling them with software,
  as this repository does, is allowed, with their license notices.
- Don't use the fonts' Reserved Font Names for a modified version of a
  font.
- Don't suggest that a font author endorses your product.

## Print files

GitHub Releases carry the ready-made print files of each version (see
[docs/dev/releasing.md](docs/dev/releasing.md)). Git does not track exported
files: keep your own in `exports/`, which Git ignores.

When you share a print file, include a short license note with it, such as a
text file with the same name and `.license` added (`king.3mf.license`). For a
shogi piece, write:

    SPDX-License-Identifier: MIT
    Copyright (c) 2026 KomaSCAD contributors
    Source preset: koma/presets/games/shogi.json / Shogi 01 - King (Osho)
    Font: Yuji Syuku Regular (SIL OFL 1.1; notice: fonts/licenses/Yuji-OFL-1.1.txt)

For a piece made from `koma/presets/misc/taikyoku.json`, write:

    SPDX-License-Identifier: CC-BY-SA-4.0
    Source preset: koma/presets/misc/taikyoku.json / <preset name>
    Attribution: Adapted from the English Wikipedia "Taikyoku shogi" table;
    https://en.wikipedia.org/wiki/Taikyoku_shogi
    History: https://en.wikipedia.org/w/index.php?title=Taikyoku_shogi&action=history
    Changes: Inscription data was transcribed, normalized, and placed on a
    KomaSCAD parametric piece; dimensions and typography are project defaults.
    License: https://creativecommons.org/licenses/by-sa/4.0/

Pieces printed from Taikyoku presets can be sold too: CC BY-SA 4.0 permits
commercial use, with attribution.

## Adding material from others

Do not add artwork, logos, photographs, fonts, scans or meshes from other
people unless you record their source and license.

This page is a project policy and our reading of the licenses. It is not
legal advice.

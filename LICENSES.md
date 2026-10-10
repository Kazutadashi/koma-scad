# Licenses

KomaSCAD uses more than one license. Do not call the whole repository "MIT".

| Material | License | When you share it |
| --- | --- | --- |
| The code (`.scad`, `.py`, `.html`), the documentation and the images | [MIT](LICENSE) | Keep the MIT notice. |
| `data/taikyoku_*.csv`, `data/ATTRIBUTION.md` and `presets/misc/taikyoku.json` | [CC BY-SA 4.0](LICENSES/CC-BY-SA-4.0.txt) | Keep the attribution and the license link. Share your changes under CC BY-SA 4.0. |
| `fonts/*.ttf` | SIL Open Font License 1.1 | Keep the notice from `fonts/licenses/`. Do not sell a font file alone. |
| Print files in `models/` | One license file for each print file | See [Print files](#print-files). |

The Taikyoku data is kept apart, so the model and the shogi presets stay MIT.
CC BY-SA 4.0 permits commercial use. It needs attribution, and it needs
adaptations to use the same license.

You can sell printed pieces in both cases. You can sell pieces printed with
the bundled fonts. Do not say or suggest that a font author, Wikipedia or a
Wikipedia contributor supports your product.

## Print files

Put only print files that you want to release in [models/](models/README.md).
Keep your own exports in `exports/`. Git ignores that folder.

Give each print file a license file with the same name and `.license` added,
for example `models/king.3mf.license`. For a shogi piece, write:

    SPDX-License-Identifier: MIT
    Copyright (c) 2026 KomaSCAD contributors
    Source preset: presets/games/shogi.json / Shogi 01 - King (Osho)
    Font: Yuji Syuku Regular (SIL OFL 1.1; notice: fonts/licenses/Yuji-OFL-1.1.txt)

For a piece made from `presets/misc/taikyoku.json`, write:

    SPDX-License-Identifier: CC-BY-SA-4.0
    Source preset: presets/misc/taikyoku.json / <preset name>
    Attribution: Adapted from the English Wikipedia "Taikyoku shogi" table;
    https://en.wikipedia.org/wiki/Taikyoku_shogi
    History: https://en.wikipedia.org/w/index.php?title=Taikyoku_shogi&action=history
    Changes: Inscription data was transcribed, normalized, and placed on a
    KomaSCAD parametric piece; dimensions and typography are project defaults.
    License: https://creativecommons.org/licenses/by-sa/4.0/

Do not add artwork, logos, photographs, fonts, scans or meshes from other
people unless you record their source and license.

This file is a project policy. It is not legal advice.

# Licensing shared STL and 3MF files

[models](../models/README.md) is for print files intentionally released to
other people. Local exports still belong in ignored exports/ or build/
directories.

Before adding a print file, add a same-named sidecar, for example
models/king.3mf.license, containing:

    SPDX-License-Identifier: MIT
    Copyright (c) 2026 KomaSCAD contributors
    Source preset: shogi_piece.json / 00 Base - King
    Font: Yuji Syuku Regular (SIL OFL 1.1; bundled notice: fonts/licenses/Yuji-OFL-1.1.txt)

For a file generated from presets/taikyoku.json, use this instead:

    SPDX-License-Identifier: CC-BY-SA-4.0
    Source preset: presets/taikyoku.json / <preset name>
    Attribution: Adapted from the English Wikipedia “Taikyoku shogi” table;
    https://en.wikipedia.org/wiki/Taikyoku_shogi
    History: https://en.wikipedia.org/w/index.php?title=Taikyoku_shogi&action=history
    Changes: Inscription data was transcribed, normalized, and placed on a
    KomaSCAD parametric piece; dimensions and typography are project defaults.
    License: https://creativecommons.org/licenses/by-sa/4.0/

Commercial sale of physical prints is permitted for both categories. The
bundled OFL fonts may be used to manufacture and sell printed objects; keep
their notices only when distributing the font files themselves. Do not state
or imply that a font author, Wikipedia, or a Wikimedia contributor endorses a
product.

This is a project release policy, not legal advice. Add no third-party artwork,
logos, photographs, fonts, scans, or downloaded meshes without recording their
source and license.

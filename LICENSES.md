# License map and release policy

KomaSCAD is a multi-license repository. The root [MIT License](LICENSE)
applies to the generator, exporter, and original project documentation unless
a path below says otherwise. Do not describe the whole repository, every
preset, or every downloadable model as “MIT” without this qualification.

| Material | License | Requirements when sharing |
| --- | --- | --- |
| Original OpenSCAD/Python code and original prose | [MIT](LICENSE) | Retain the MIT notice. |
| data/taikyoku_piece_characters.csv, data/taikyoku_size_categories.csv, data/ATTRIBUTION.md, and presets/taikyoku.json | [CC BY-SA 4.0](LICENSES/CC-BY-SA-4.0.txt) | Retain the attribution, source/history links, change notice, and CC BY-SA license link. License adapted material under CC BY-SA 4.0 or a compatible license. |
| fonts/*.ttf | SIL Open Font License 1.1 | Keep the matching notice in fonts/licenses/. Do not sell a font file by itself or imply author endorsement. |
| images/*.png | MIT | Project-created renders; retain this notice when redistributing them. |
| models/ print files | Per-file license sidecar | Every shared STL/3MF must have a matching .license file and follow [the print-file policy](docs/print-file-licenses.md). |

The Taikyoku data is kept separate so the reusable generator and ordinary
Shogi presets can remain MIT. It is commercial-use friendly, but it is not
MIT: CC BY-SA permits commercial use while requiring attribution and
ShareAlike for adaptations.

This map records copyright licensing, not trademark, patent, publicity,
privacy, cultural-heritage, safety, or jurisdiction-specific consumer-product
rules. Contributors may only add material they created or are authorized to
redistribute.

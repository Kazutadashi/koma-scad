# KomaSCAD documentation

Find the guide for your task below. Terms are defined in the [glossary](glossary.md), and
common questions are answered in the [FAQ](faq.md).

## Find a guide

| Task | Read |
| --- | --- |
| Print a ready-made set | [Ready-made sets](ready-sets.md), then [print your first set](print/first-print.md) |
| Learn to play shogi | [How to play](play/how-to-play.md) ([PDF](play/how-to-play.pdf)) |
| Change a set: font, size, colors, minishogi | [Install](install.md), then the [user guide](user-guide.md) |
| Design a piece | [Install](install.md), [getting started](getting-started.md), then the [design guide](design-guide.md) |
| Add move diagrams to a piece | [Movement diagrams](move-diagrams.md) |
| Make the board, stands and box | [Make the whole set](whole-set.md), then the [board](ban.md), [komadai](komadai.md) and [komabako](komabako.md) guides |
| Add a maker's mark | [Maker's mark](makers-mark.md), and the piece [signature](design-guide.md#add-a-signature) |
| Improve print quality | [Print guide](print/print-guide.md), then the [print test page](print/print-test-page.md) |
| Sell or share prints | [LICENSES.md](../LICENSES.md) |
| Troubleshoot | [FAQ and troubleshooting](faq.md) |
| Contribute | [CONTRIBUTING.md](../CONTRIBUTING.md) |

## Printing

| Page | Contents |
| --- | --- |
| [Print your first set](print/first-print.md) | A step-by-step guide to the slicer, from choosing filament to sorting the pieces |
| [Print guide](print/print-guide.md) | The slicer settings and the reason for each, flow ratio calibration, and test results |
| [Print test page](print/print-test-page.md) | A reference print that measures what your printer can make |
| [Bambu Studio profile](print/bambu/komascad-face-down-0.15mm-a1-0.4mm.json) | Process profile for a Bambu Lab A1 with a 0.4 mm nozzle |

## Reference

| Page | Contents |
| --- | --- |
| [Command reference](cli.md) | Every `komascad.py` command and option |
| [Parameter reference](parameters.md) | Every setting of the piece model, with its default |
| [Board guide: settings](ban.md#settings) | Every setting of the board model |
| [Komadai guide: settings](komadai.md#settings), [komabako guide: settings](komabako.md#settings) | Every setting of the stand and the box |
| [Board connector spec](ban-connector-spec.md) | Socket sizes, and screws and nuts that can replace a connector |
| [Fonts](../fonts/README.md) | The bundled fonts, and how to install them |
| [Glossary](glossary.md) | Printing, software and shogi words |

## For developers

| Page | Contents |
| --- | --- |
| [Contributing](../CONTRIBUTING.md) | How to report a problem, set up, test and send a change |
| [Architecture](dev/architecture.md) | How the code is organized; the rules for each model and module |
| [Board design notes](dev/ban-design-notes.md) | Why the board joints have their shape, what was tried, and what is left |
| [Releasing](dev/releasing.md) | The release checklist and the ready-made set files |
| [Changelog](../CHANGELOG.md) | What changed in each version |

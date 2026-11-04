# Fonts

KomaSCAD letters its pieces with installed fonts. The six fonts in this folder
are free, open fonts, and every bundled set uses one of them.

## Which fonts to install

Install all six `.ttf` files in this folder, then restart OpenSCAD. These
are the only fonts the bundled sets need, apart from the optional heel
signature below. The
[install guide](../docs/install.md#4-install-the-fonts) shows how on
Windows, macOS and Linux, and how to check that OpenSCAD sees them
(**Help → Font List**).

If you want only the minimum:

| You make | It needs |
| --- | --- |
| `shogi`, `shogi-1char`, `shogi-learner-syuku`, `minishogi`, `minishogi-1char` | Yuji Syuku |
| `shogi-learner`, `minishogi-learner`, `shogi-wenkai`, `shogi-1char-wenkai` | LXGW WenKai Mono |
| The [print test page](../docs/print/print-test-page.md) | Yuji Syuku and LXGW WenKai Mono |
| A [maker's mark](../docs/makers-mark.md) with the default font | Kaisei Tokumin ExtraBold |
| Your own designs | Any of them, or any installed font that has the characters |

The heel signature (**Signature Text**, or `--signature-text` on export)
uses Noto Sans CJK JP Black by default. It is not bundled. Install it from
[Google Fonts](https://fonts.google.com/noto/specimen/Noto+Sans+JP) or the
[Noto CJK releases](https://github.com/notofonts/noto-cjk/releases) if you
add signatures, or set **Signature Font** to a bundled font.

You don't need to install fonts to print a
[ready-made set](../docs/ready-sets.md): the lettering is already part of the
3MF file.

## About the fonts

The font files are original, unmodified upstream releases. Each is licensed
under the [SIL Open Font License 1.1](https://openfontlicense.org/), which
permits commercial and non-commercial use and redistribution when the
license notice is kept with the font. The matching notices are in
[licenses](licenses). See [LICENSES.md](../LICENSES.md) for what this
means for the pieces you print.

All bundled fonts were checked for the `王` and `将` glyphs. Font coverage
varies for less common historical characters, so confirm the full set of
characters required by a design before committing to a family.

Type the name in the second column into **Font Name** in OpenSCAD, without
quotes.

## Bundled fonts

| Font | Registered family/style name | Style | Upstream download and source | License notice |
| --- | --- | --- | --- | --- |
| Yuji Syuku | `Yuji Syuku:style=Regular` | Brush style. Used by the Classic and One character sets. | [Google Fonts](https://fonts.google.com/specimen/Yuji+Syuku) · [Yuji source](https://github.com/Kinutafontfactory/Yuji) | [Yuji OFL](licenses/Yuji-OFL-1.1.txt) |
| Yuji Mai | `Yuji Mai:style=Regular` | Flowing brush style. | [Google Fonts](https://fonts.google.com/specimen/Yuji+Mai) · [Yuji source](https://github.com/Kinutafontfactory/Yuji) | [Yuji OFL](licenses/Yuji-OFL-1.1.txt) |
| Iansui | `Iansui:style=Regular` | Brush script. Check dense characters with the printability check. | [Iansui source and releases](https://github.com/ButTaiwan/iansui) | [Iansui OFL](licenses/Iansui-OFL-1.1.txt) |
| Kaisei Tokumin ExtraBold | `Kaisei Tokumin:style=ExtraBold` | High-contrast Mincho. The default font of the maker's mark. | [Google Fonts](https://fonts.google.com/specimen/Kaisei+Tokumin) · [Google Fonts source](https://github.com/google/fonts/tree/main/ofl/kaiseitokumin) | [Kaisei Tokumin OFL](licenses/Kaisei-Tokumin-OFL-1.1.txt) |
| LXGW WenKai Mono | `LXGW WenKai Mono:style=Regular` | Handwritten style with even character width. Used by the Learner sets. | [Official releases](https://github.com/lxgw/LxgwWenKai/releases) · [source](https://github.com/lxgw/LxgwWenKai) | [LXGW WenKai OFL](licenses/LXGW-WenKai-OFL-1.1.txt) |
| DotGothic16 | `DotGothic16:style=Regular` | Pixel style. | [Google Fonts](https://fonts.google.com/specimen/DotGothic16) · [source](https://github.com/fontworks-fonts/DotGothic16) | [DotGothic16 OFL](licenses/DotGothic16-OFL-1.1.txt) |

## More fonts

[font-research.md](font-research.md) lists other open and commercial
Japanese fonts that may suit shogi pieces, with notes on their style and
licensing. Commercial fonts must not be copied into this repository.

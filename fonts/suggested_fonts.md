# KomaSCAD font collection and suggestions

The six font files beside this guide are original, unmodified upstream releases. Each is licensed under the [SIL Open Font License 1.1](https://openfontlicense.org/), which permits free commercial and non-commercial use and redistribution when the accompanying license notice is retained. The matching notices are in [licenses](licenses).

All bundled fonts were checked for the `王` and `将` glyphs. Font coverage varies for less common historical characters, so always confirm a piece in OpenSCAD before exporting a set.

## Bundled fonts

| Font | OpenSCAD `Font Name` | Best use | Upstream download and source | License notice |
| --- | --- | --- | --- | --- |
| Yuji Syuku | `Yuji Syuku:style=Regular` | Best match for traditional brush-like shogi inscriptions; used by the Professional King preset. | [Google Fonts](https://fonts.google.com/specimen/Yuji+Syuku) · [Yuji source](https://github.com/Kinutafontfactory/Yuji) | [Yuji OFL](licenses/Yuji-OFL-1.1.txt) |
| Yuji Mai | `Yuji Mai:style=Regular` | Softer, more flowing calligraphy; useful when a piece should feel hand-lettered rather than carved. | [Google Fonts](https://fonts.google.com/specimen/Yuji+Mai) · [Yuji source](https://github.com/Kinutafontfactory/Yuji) | [Yuji OFL](licenses/Yuji-OFL-1.1.txt) |
| Iansui | `Iansui:style=Regular` | Expressive brush-script option with strong personality; inspect dense characters carefully. | [Iansui source and releases](https://github.com/ButTaiwan/iansui) | [Iansui OFL](licenses/Iansui-OFL-1.1.txt) |
| Kaisei Tokumin ExtraBold | `Kaisei Tokumin:style=ExtraBold` | Formal, high-contrast display Mincho; a polished alternative when brush lettering is too informal. | [Google Fonts](https://fonts.google.com/specimen/Kaisei+Tokumin) · [Google Fonts source](https://github.com/google/fonts/tree/main/ofl/kaiseitokumin) | [Kaisei Tokumin OFL](licenses/Kaisei-Tokumin-OFL-1.1.txt) |
| LXGW WenKai Mono | `LXGW WenKai Mono:style=Regular` | Friendly handwritten structure with consistent character width; good for clear, modern experimental pieces. | [Official releases](https://github.com/lxgw/LxgwWenKai/releases) · [source](https://github.com/lxgw/LxgwWenKai) | [LXGW WenKai OFL](licenses/LXGW-WenKai-OFL-1.1.txt) |
| DotGothic16 | `DotGothic16:style=Regular` | Deliberately pixel-like modern style; excellent for technical or retro sets, not a traditional carved look. | [Google Fonts](https://fonts.google.com/specimen/DotGothic16) · [source](https://github.com/fontworks-fonts/DotGothic16) | [DotGothic16 OFL](licenses/DotGothic16-OFL-1.1.txt) |

The official LXGW download included here registers as `LXGW WenKai Mono`. Your locally installed `LXGW WenKai Mono TC:style=Regular` is a Traditional-Chinese variant; it can still be selected in OpenSCAD, but it is not represented as a separate upstream desktop release in this collection.

## Supplied fonts that are not bundled

| Font | Status | Guidance |
| --- | --- | --- |
| `A\-OTF Kaisho MCBK1 Pro:style=MCBK1` | Proprietary commercial font. | Do not copy it into this repository. Continue using it only from a properly licensed local installation. See [Morisawa Fonts](https://www.morisawa.co.jp/fonts/) for licensing and availability. |

## Additional open options

- [Noto Serif JP](https://fonts.google.com/noto/specimen/Noto+Serif+JP) is the dependable formal fallback already used by the base preset. It is clean and highly legible, though less brush-like than Yuji Syuku.
- [Klee One](https://fonts.google.com/specimen/Klee+One) is an OFL handwriting font worth testing for informal labels and maker signatures.
- [Shippori Mincho](https://fonts.google.com/specimen/Shippori+Mincho) is an OFL formal Mincho family for a quieter, book-printed appearance.

## Installing and using a font

Install the desired `.ttf` file with your operating system, then restart OpenSCAD so its font list refreshes. In Customizer, enter the exact `Font Name` from the table, including the style suffix. Use **Help → Font List** to confirm how your system registered it.

For the Professional King preset, install `YujiSyuku-Regular.ttf` and use `Yuji Syuku:style=Regular`. Keep **Protect Face Edges** on and use **Inspect front** after changing text, scale, or stroke expansion.

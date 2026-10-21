# Maker's mark

Fine shogi equipment carries the maker's name (銘). The board, the komadai and
the box can each carry a **maker's mark**, cut into the print. One mark serves
the whole set, so a name or brand looks the same on every part.

## The parts of a mark

A mark has up to three parts, stacked and centered:

1. **The emblem** (**Mark Emblem**): a koma outline with a character cut into
   it (**Mark Emblem Character**, in **Mark Emblem Font**).
2. **The main line** (**Mark Line 1**): a name or brand.
3. **The second line** (**Mark Line 2**): a smaller line under it.

Leave a part empty, or turn the emblem off, to leave it out.

**Mark Spacing 1** and **Mark Spacing 2** widen the letter spacing of each
line. OpenSCAD multiplies the width of each letter by the spacing. Thus,
tracking of +0.3 em (0.3 of a letter's width added after it) is about 1.4 for
capitals and 1.3 for Japanese characters.

## Where the mark goes

| Part | Place | Reads correctly when you |
| --- | --- | --- |
| Ban | The underside of panel 0, 0, clear of the connector sockets | Turn the board over |
| Komadai | The underside of the top, between the legs or beside the column | Turn the komadai over |
| Komabako | The underside, the lid top, or both (**Mark Place**) | Turn the box over, or look at the closed lid |

## Size: automatic, and never too small to print

With **Mark Size** at 0 (the default), the mark is as large as its room
allows: up to 80% of the free area, and a main line of at most
**Mark Max Size**. The second line is **Mark Line 2 Ratio** of the main line.

No text goes below **Mark Min Text Size**. The second line grows to it, and
the emblem grows so that its character reaches it. When the mark cannot fit
with all text at that size, the model stops and tells you why. Then:

1. Reduce the letter spacing: **Mark Spacing 1** first.
2. Shorten the second line, or leave it out.
3. Use larger panels or modules.

The Console shows the size of the mark and of each line.

## What prints: measured minimums

The mark is cut **Mark Depth** (0.4 mm) into the print. A stroke or a gap
narrower than one printed line (0.42 mm with a 0.4 mm nozzle) does not print.
These sizes were measured as for the piece lettering: at most 2.5% of the
text in strokes thinner than a line, and 5% in gaps narrower than a line.

| Font | Mark Stroke | Japanese prints from | Latin capitals print from |
| --- | --- | --- | --- |
| Kaisei Tokumin ExtraBold (bundled; the default) | 0 | 7 mm | 7 mm |
| A thin Mincho, such as Shippori Mincho SemiBold | 0 | 12 mm | 8 mm or more |
| A thin Mincho, such as Shippori Mincho SemiBold | 0.08 | 7 mm | 8 mm |
| A thin Mincho, such as Shippori Mincho SemiBold | 0.12 | 6 mm | 5 mm |
| A brush font, such as Yuji Syuku (one character) | 0.08 | 7 mm | — |

**Mark Stroke** thickens every stroke by that much on each side. It lets a
thin Mincho print at a useful size. Set **Mark Min Text Size** to the larger
of the two values for your font and stroke.

## Example

A mark with all three parts. Replace the text with your own.

| Setting | Value |
| --- | --- |
| Mark Line 1 | `KOMASCAD` |
| Mark Line 2 | `SHOGI · 将棋` |
| Mark Spacing 1 | 1.4 |
| Mark Spacing 2 | 1.3 |
| Mark Emblem | on |
| Mark Emblem Character | `王` |
| Mark Emblem Font | `Yuji Syuku:style=Regular` |

With a long wordmark and wide spacing, small rooms need tighter spacing. For
a nine-letter wordmark at **Mark Min Text Size** 6:

| Part | Fits |
| --- | --- |
| Ban, 2 x 2 panels or one piece; komadai, Flat or One leg; komabako | All three parts, spacing 1.4 and 1.3 |
| Ban, 3 x 3 panels or modules | All three parts, **Mark Spacing 1** 1.15 and **Mark Spacing 2** 1.0 |
| Komadai, Yagura | Spacing 1.0, and a second line of four Japanese characters at most |

## Keep your mark out of the project

Your mark is yours, so do not save it in the bundled preset files. Put it in
a preset file of your own, outside the project or in `ignored/`, which Git
does not track. A preset needs only the settings that it changes. Use it with
the `-p` option:

```bash
python3 komascad.py ban "My board" -p ~/my-presets/ban.json
openscad -p ~/my-presets/komabako.json -P "My box" -D 'Output_Mode="Lid"' -o lid.stl komabako/komabako.scad
```

## Fonts

The default font for both lines is **Kaisei Tokumin ExtraBold**, a Mincho
serif with Latin and Japanese characters, bundled in `fonts/`. Any installed
font works. Use a font with Japanese characters for a Japanese line: a font
without them leaves the characters out. `komascad.py ban` stops if a font of
the mark is not installed.

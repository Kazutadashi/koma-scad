# Print test page

The print test page is a fixed reference print: the same pieces, with the
same settings, every time. Print it to find:

- The piece sizes and stroke weights that your printer, filament and slicer
  profile can make.
- Whether your setup is as good as the recorded baseline.
- The thinnest line and the narrowest gap that your setup can make, in mm.

This is baseline **version 1**. `komascad.py build` makes the files in
`presets/print-test/`. Do not edit them. See
[Change the baseline](#change-the-baseline).

## What is on the page

The page is 59 pieces. They print face down: the front lies on the bed and the
promoted side faces up. Fronts are black; promoted sides and labels are red,
so the page needs three filaments. Every piece is a standard shogi king body
(32 mm long, 28.5 mm wide at 1x).

The pieces are split over three plates that each fit a 220 mm bed. Looking
down at a plate you see the red promoted sides, with row 1 at the back:

| Plate | Row | Pieces, left to right | Labels |
| --- | --- | --- | --- |
| 1 | 1 | 2x Yuji Syuku: strokes 1, 3, 5 | 1-01 to 1-03 |
| 1 | 2 | 2x LXGW WenKai Mono: strokes 1, 3, 5 | 1-04 to 1-06 |
| 1 | 3 | One character: 1.5x Yuji Syuku, 1.5x WenKai Mono, 1x Yuji Syuku, 1x WenKai Mono | 1-07 to 1-10 |
| 2 | 1 | 1.5x Yuji Syuku: strokes 1, 3, 5; then the 1x raised piece | 2-01 to 2-04 |
| 2 | 2 | 1.5x LXGW WenKai Mono: strokes 1, 3, 5; then ladder L1 | 2-05 to 2-08 |
| 2 | 3 | Ladders L2 to L6 | 2-09 to 2-13 |
| 3 | 1 | One character: 2x Yuji Syuku, 2x WenKai Mono, 0.5x Yuji Syuku, 0.5x WenKai Mono, 0.25x WenKai Mono | 3-01 to 3-05 |
| 3 | 2 | 1x Yuji Syuku: strokes 1 to 5 | 3-06 to 3-10 |
| 3 | 3 | 1x LXGW WenKai Mono: strokes 1 to 5 | 3-11 to 3-15 |
| 3 | 4 | 0.5x Yuji Syuku: strokes 1 to 5; then 0.25x Yuji Syuku: strokes 1 to 5 | 3-16 to 3-25 |
| 3 | 5 | 0.5x LXGW WenKai Mono: strokes 1 to 5; then 0.25x LXGW WenKai Mono: strokes 1 to 5; then 0.25x Yuji Syuku one character | 3-26 to 3-36 |

### Labels

Every piece has its own label, plate then place on the plate, such as `3-08`.
The same label begins the piece's name in the slicer. It is inlaid in red in
the heel, which is the side wall facing the front of the printer, and is as
tall as the heel allows: 8.3 mm on a 1x piece.

Pieces smaller than 1x cannot hold readable digits, so they carry the same
label as a dot code: six columns of square dots, each column empty, one dot or
two dots tall. A dot is 2.1 mm at 0.5x and 1.1 mm at 0.25x. Read it with the
red side up, left to right:

- Column 1 is always two dots. It marks the start and the full height.
- Column 2 is the plate: empty, one dot or two dots for plate 1, 2 or 3.
- Columns 3 to 6 are the place on the plate. Each dot is worth 27, 9, 3 and 1
  in turn, so two dots in column 5 and one in column 6 is place 7.

Neighboring dots join into one shape, so matching against this table is
quicker than counting:

| Label | Dots | Piece |
| --- | --- | --- |
| 3-03 | `█　▖` | 0.5x Yuji Syuku one character |
| 3-04 | `█　▄` | 0.5x LXGW WenKai Mono one character |
| 3-05 | `█　▟` | 0.25x LXGW WenKai Mono one character |
| 3-16 | `█▗▙` | 0.5x Yuji Syuku stroke 1 very thin |
| 3-17 | `█▗█` | 0.5x Yuji Syuku stroke 2 thin |
| 3-18 | `█▐　` | 0.5x Yuji Syuku stroke 3 normal |
| 3-19 | `█▐▗` | 0.5x Yuji Syuku stroke 4 thick |
| 3-20 | `█▐▐` | 0.5x Yuji Syuku stroke 5 very thick |
| 3-21 | `█▐▖` | 0.25x Yuji Syuku stroke 1 very thin |
| 3-22 | `█▐▄` | 0.25x Yuji Syuku stroke 2 thin |
| 3-23 | `█▐▟` | 0.25x Yuji Syuku stroke 3 normal |
| 3-24 | `█▐▌` | 0.25x Yuji Syuku stroke 4 thick |
| 3-25 | `█▐▙` | 0.25x Yuji Syuku stroke 5 very thick |
| 3-26 | `█▐█` | 0.5x LXGW WenKai Mono stroke 1 very thin |
| 3-27 | `█▖　` | 0.5x LXGW WenKai Mono stroke 2 thin |
| 3-28 | `█▖▗` | 0.5x LXGW WenKai Mono stroke 3 normal |
| 3-29 | `█▖▐` | 0.5x LXGW WenKai Mono stroke 4 thick |
| 3-30 | `█▖▖` | 0.5x LXGW WenKai Mono stroke 5 very thick |
| 3-31 | `█▖▄` | 0.25x LXGW WenKai Mono stroke 1 very thin |
| 3-32 | `█▖▟` | 0.25x LXGW WenKai Mono stroke 2 thin |
| 3-33 | `█▖▌` | 0.25x LXGW WenKai Mono stroke 3 normal |
| 3-34 | `█▖▙` | 0.25x LXGW WenKai Mono stroke 4 thick |
| 3-35 | `█▖█` | 0.25x LXGW WenKai Mono stroke 5 very thick |
| 3-36 | `█▄　` | 0.25x Yuji Syuku one character |

If a label does not survive, the position on the plate still identifies the
piece: photograph each plate before removing anything.

**The stroke sweep** is 42 of the 59 pieces. The front is 麒麟 (Kirin), the
densest two-character piece name both fonts can draw, and the reverse is its
promotion 獅子 (Lion). Within a sweep only the stroke expansion changes, on
both faces:

| Stroke | Name | Expansion |
| --- | --- | --- |
| 1 | very thin | -0.10 mm |
| 2 | thin | -0.03 mm |
| 3 | normal, as the bundled sets ship | 0.04 mm |
| 4 | thick | 0.11 mm |
| 5 | very thick | 0.18 mm |

Thin strokes fail by disappearing; thick strokes fail by closing the spaces
between them. The values are measured before scaling, so a 2x piece doubles
them and a 0.25x piece quarters them: the design keeps its proportions and
only the printer's resolution changes. The 1x, 0.5x and 0.25x sizes have all
five strokes. The 1.5x and 2x sizes have the two extremes and normal only,
because large pieces are the least likely to fail and the most expensive to
print.

The two faces are different tests. The front is formed by the first layers
against the bed; the reverse is formed by the last layers on a gently sloping
top surface.

**The variants**, all at normal stroke:

- *One character*, in both fonts at all five sizes: 驢 on the front, the
  densest single character in the data, and 獅 on the reverse. This is the
  layout of one-character sets, and the best case for a very small piece.
- *Raised* at 1x: 獅子 standing proud of the reverse instead of inlaid. Its
  front is blank.

**Six ladders**, always full size, so their widths are true millimeters: 0.6,
0.5, 0.4, 0.3, 0.25, 0.2, 0.15 and 0.1. *Lines* are single strokes of those
widths. *Gaps* are 1.2 mm bars separated by spaces of those widths. Each
pattern has one group running across the piece (widest nearest the heel) and
one running heel to point (widest at one side), so both bed axes are measured.

| Ladder | Label | Lettering | Bed face | Top face |
| --- | --- | --- | --- | --- |
| L1 | 2-08 | Flush inlay, as the bundled sets print | lines | gaps |
| L2 | 2-09 | Flush inlay | gaps | lines |
| L3 | 2-10 | Indented: open 0.35 mm grooves with a colored floor | lines | gaps |
| L4 | 2-11 | Indented | gaps | lines |
| L5 | 2-12 | Raised | blank | lines |
| L6 | 2-13 | Raised | blank | gaps |

## Export

Install the two bundled fonts first: Yuji Syuku and LXGW WenKai Mono, from
[fonts/](../fonts/suggested_fonts.md). The export stops if a font is missing.

```bash
for plate in 1 2 3; do
  python3 komascad.py export presets/print-test/print-test-plate-$plate.json --per-file all --jobs 8 --no-print-check --name "KomaSCAD Print Test v1 - Plate $plate" -o exports/print-test/plate-$plate
done
```

This writes one 3MF for each plate, in the rows above. Each plate file has a
`layoutRows` plan for the export. The page has pieces that cannot print, on
purpose, so the command needs `--no-print-check`. Dense characters are slow
to render. `--jobs 8` renders eight pieces at the same time and needs about
1 GB of memory for each. Allow about 15 minutes. Without `--jobs`, it takes
more than one hour.

| Plate | Pieces | Footprint | Height |
| --- | --- | --- | --- |
| 1 | 10 | 183 × 191 mm | 19.5 mm |
| 2 | 13 | 175 × 142 mm | 14.6 mm |
| 3 | 36 | 174 × 187 mm | 19.5 mm |

## Print

Hold these fixed, because they are part of the baseline:

- Face down, exactly as exported. Do not scale, rotate or rearrange the
  pieces.
- No supports. Add a brim only if the smallest pieces will not stay down, and
  record it.
- Body in the light filament, fronts in black, promoted sides and labels in
  red.

Everything else is what you are testing. Before printing, look at the sliced
preview: a slicer drops lines thinner than it can extrude, and that is a
result worth recording on its own.

## Score

Score both faces of each of the 53 lettered pieces, at reading distance and
under a loupe if you have one. The raised piece has one face, so there are 105
scores:

| Score | Meaning |
| --- | --- |
| 3 | Clean. Every stroke is present, every enclosed space is open, edges are crisp. |
| 2 | Legible. Reads correctly at arm's length; a hairline has thinned or a small space has partly filled. |
| 1 | Degraded. Recognizable only if you know the character; strokes are merged or missing. |
| 0 | Failed. Unreadable, or the piece did not survive. |

For each ladder face, count along each group from the widest and write down
the last width that is complete along its whole length. *Lines* give the
thinnest stroke the setup can make; *gaps* give the narrowest space it keeps
open. Record them separately for the bed face and the top face.

These numbers transfer to any font or size. A piece is safe to print when its
thinnest stroke and narrowest space, at final size, are both wider than the
ladder result for that face and lettering style.

## Record

Copy this block for every print and keep it with a photograph of each plate.
Write each score as front/reverse.

```text
Baseline version: 1
Date:                        Printer:                      Nozzle:
Slicer and profile:          Layer height:                 Line width:
Body filament:               Black filament:               Red filament:
Flow / pressure advance:
Changes from the reference setup:

Stroke sweep (front/reverse)   1 very thin   2 thin   3 normal   4 thick   5 very thick
2x     Yuji Syuku              /             -        /          -         /
2x     WenKai Mono             /             -        /          -         /
1.5x   Yuji Syuku              /             -        /          -         /
1.5x   WenKai Mono             /             -        /          -         /
1x     Yuji Syuku              /             /        /          /         /
1x     WenKai Mono             /             /        /          /         /
0.5x   Yuji Syuku              /             /        /          /         /
0.5x   WenKai Mono             /             /        /          /         /
0.25x  Yuji Syuku              /             /        /          /         /
0.25x  WenKai Mono             /             /        /          /         /

One character (front/reverse)   2x   1.5x   1x   0.5x   0.25x
Yuji Syuku                      /    /      /    /      /
WenKai Mono                     /    /      /    /      /

1x raised reverse:

Ladders (last complete width, mm)      across   along
L1 inlaid    bed face, lines
L1 inlaid    top face, gaps
L2 inlaid    bed face, gaps
L2 inlaid    top face, lines
L3 indented  bed face, lines
L3 indented  top face, gaps
L4 indented  bed face, gaps
L4 indented  top face, lines
L5 raised    top face, lines
L6 raised    top face, gaps

Total of the 105 scores (maximum 315):
Notes:
```

The first complete record from the project's reference printer is the
baseline. Later prints are compared with it cell by cell: the total says
whether a setup is better or worse overall, and the cells say where.

## What the page does not cover

- **Every character in every font.** Yuji Syuku has no glyph for 䳇, 䳲, 歬 or
  𠵇, which some Taikyoku pieces need; LXGW WenKai Mono has all of them. A few
  Taikyoku pieces use characters with no code point at all and need custom
  artwork in any font.
- **Other orientations.** Upright pieces form their lettering on a side wall
  and behave differently. Exporting a plate with `--orientation` gives a
  different test, not this baseline.
- **Three-character names.** They carry the smallest lettering of any piece;
  the 0.5x and 0.25x sweeps are the closest stand-in.
- **Fit and feel.** The page checks lettering, not how a piece handles on a
  board.

## Change the baseline

The print test page section of `komascad.py` holds every setting of every
piece. It does not read `presets/pieces/`, so a change to the game sets does
not change the reference. The `build` command writes the plate files with the
game presets:

```bash
python3 komascad.py build           # rebuild the plate files
python3 komascad.py build --check   # report stale files, change nothing
```

A change to what prints makes the earlier records useless for comparison.
This includes a change in that section, or in how `shogi_piece.scad` draws
these presets. If you must make such a change:

1. Increase `TEST_PAGE_VERSION` in `komascad.py`.
2. Run `python3 komascad.py build`.
3. Change the version at the top of this page.
4. Print a new baseline.

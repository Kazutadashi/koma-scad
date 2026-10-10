# Movement diagrams

A movement diagram is a small picture of how a piece moves. It is engraved
below or above the characters, in the same color. The learner sets have one
on each face: the front shows the moves before promotion, the back the moves
after promotion.

## Draw a diagram

The easiest way is the move editor:

1. Open `move-editor.html` in a browser. It works without a network.
2. Type the characters for the front.
3. Select a mark, then click the squares around the piece.
4. Select the **Back** tab. Draw the moves after promotion.
5. Look at the preview. It shows the full piece and tells you if the diagram
   does not fit.
6. Copy the result into a piece file, or into the Customizer.

The editor keeps your piece between visits.

## The grid

A diagram is a grid of the squares around the piece. Rows go from the point
(forward) to the heel. A `/` separates the rows. Spaces are ignored. Put the
grid in **Front Moves** or **Back Moves**.

| Symbol | Meaning | Drawn as |
| --- | --- | --- |
| `@` | The piece | A small pentagon that points forward |
| `o` | Moves to this square | A line from the piece to a dot |
| `x` | Jumps to this square, over any piece between | A ring, with a dashed line from the piece |
| `!` | Captures on this square without moving (igui). Next to the `@` only. | An upright "!", with no line |
| `#` | Slides any distance in this direction | A line with an arrowhead |
| `=` | Flies over any number of pieces in this direction, and captures them | A line with a double arrowhead |
| `L` | Slides in this direction, and can turn 90° one time (hook move) | A line with a crossbar near its end |
| `2` | Moves up to 2 squares in this direction. Next to the `@` only. | Two dots |
| `3` to `7` | Moves up to that many squares in this direction. Next to the `@` only. | A line to the number |
| `.` | Nothing | Nothing |

Put `#`, `=` and `L` on a square that is straight or diagonal from the `@`.

A `#`, `=`, `L` or `o` beyond an `x` on the same line continues from the jump.
For example, `#/x/x/./@` jumps 2 or 3 squares and can then slide on.
`o/x/./@` jumps 2 squares and can then step 1 more.

When a piece can reach every square within two steps (a lion), the diagram
shows a square frame around the piece. The frame replaces 24 marks that could
not print apart.

### Examples

| Piece | Grid |
| --- | --- |
| Pawn | `o/@` |
| Lance | `#/@` |
| Knight | `x.x/.../.@.` |
| Gold | `ooo/o@o/.o.` |
| Rook | `.#./#@#/.#.` |
| Dragon (promoted rook) | `o#o/#@#/o#o` |
| Chu shogi horned falcon | `.x./#!#/#@#/###` |
| Lion | `xxxxx/xooox/xo@ox/xooox/xxxxx` |
| Taikyoku great dragon | `#3#/.@./#3#` |
| Taikyoku great general | `===/=@=/===` |
| Taikyoku hook mover | `.L./L@L/.L.` |

## From a Wikipedia diagram

Wikipedia's movement diagrams for shogi variants use the same grid: the piece
in the center, forward up. Copy them square by square:

| Wikipedia | Meaning | Grid |
| --- | --- | --- |
| ○ (blue) | Steps to this square. Several in a line are a limited range. | `o` |
| │ ─ ╲ ╱ (red) | Ranges along the line | `#` on the first square of the line |
| ╳ ┼ (red) | Can turn 90° | `L` on the first square of the line |
| ☆ (yellow) | Jumps to this square | `x` |
| ○ or lines (yellow) | Steps or ranges on after a ☆ | `o` or `#` beyond the `x` |
| 3 (yellow) | Jumps up to 3 squares, then can range. Wikipedia says that this meaning is not certain. | `x` on squares 1 to 3, `#` on square 4 |
| ☆ (green) | Jumps there, or gets there in two steps | `x`. A full lion becomes a frame. |
| ! (green) | Igui | `!` |
| │ ─ ╲ ╱ (orange) | Flies over pieces of lower rank, and captures them | `=`. The rank rule is not drawn. |

A diagram cannot show everything. It does not show the two moves of a lion
step by step. Burning, and pieces that capture differently from how they
move, need a rules sheet.

## Sizes

Two settings set the size of every mark:

- **Move Stroke**: the thinnest line.
- **Move Gap**: the smallest space between marks.

Both are in final mm, after **Model Scale**, so a small piece keeps printable
marks. Get them from the line and gap ladders of the
[print test page](print-test-page.md). Neither can be less than
**Print Line Width**.

The model puts the squares as close as these two sizes allow. With
**Move Pitch** at 0, it then makes the diagram larger, up to about one
character, if the face has space. Arrowheads are never shorter than 2.4 mm: a
slicer makes a shorter head into a dot.

### Sets

Give every piece of a set the same **Move Stroke**, **Move Gap** and
**Move Pitch**. Then each mark has the same size on every piece. With **Move
Pitch** above 0, **Center Fraction** places the characters, and the diagram
goes below them. The characters then line up on every piece.

The learner sets use these values (in `presets/pieces/_defaults.json`):

| Setting | Value |
| --- | --- |
| Font | LXGW WenKai Mono, Stroke Expansion 0.08 mm |
| Character size | 0.32 × the piece length |
| Center Fraction | 0.73 |
| Spacing Scale | 0.96 (about 3 mm between the character and its diagram) |
| Move Stroke, Move Gap | 0.6 mm |
| Move Pitch | 3.75 mm |

Every learner piece still fits when the characters move 0.01 of the face up
or down.

## When a diagram does not fit

The model does not make a diagram smaller than it can print. If the
characters and the diagram are too long or too wide for the face, the model
stops with a message. Do one of these:

- Make the squares closer: decrease **Move Pitch**.
- Make the marks thinner: decrease **Move Stroke** and **Move Gap**, not
  below **Print Line Width**.
- Make the piece larger: increase **Model Scale**.
- Use fewer characters.
- Bring the farthest marks nearer the piece. A grid that reaches N squares
  out is 2N + 1 squares wide.

The move editor tries these changes for you, in this order, and shows the
smallest change that fits.

Dense characters are often the real limit. The diagram always prints, but
the characters may not: 鷹 has 24 strokes and needs about three times the
size of と. Run `python3 komascad.py check` on the preset file. One character
and a diagram fit a standard piece with a 0.4 mm nozzle. Two dense characters
and a diagram usually do not.

Fonts are different too. Yuji Syuku cannot print 鷹 at any size. LXGW WenKai
Mono prints it with Stroke Expansion 0. Thus the chu shogi example in
`presets/misc/chu-shogi-learner.json` uses LXGW WenKai Mono with no stroke
expansion, at 1.4 × size.

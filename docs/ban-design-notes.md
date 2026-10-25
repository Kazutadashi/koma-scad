# Ban design notes

These notes are for contributors. They tell why the board joints have their
shape, what printed trials showed, and what is not yet done. The
[board guide](ban.md) tells you how to make and print a board.

## The rules for a joint

1. Each panel is one print. A joint has no loose parts, hardware, glue or
   work after printing.
2. The joint holds the panels together and in line. It does not set their
   height. The table does.
3. Each panel goes in by a straight drop. Only that motion lets the last
   panel of a closed grid go in.

A joint that grips can hold a panel above the table. Then the playing
surfaces are not level. Thus every joint has a slip fit, and no part of a
joint touches anything above or below it.

## What was tried

| Joint | Result |
| --- | --- |
| Interlocking lap | Could not close a 2 x 2 grid: a seam only engaged when one panel slid across it. |
| Drop-in dovetail with crush ribs (2026-09-24) | The test print failed. The ribs made a press fit, which grips in every direction and could hold a panel at any height. |
| Drop-in dovetail, slip fit | The current Dovetail. No ribs, 45 degree sides, two tabs or more on each seam, 1 mm gaps above and below each tab. |
| T-hook, 0.30 mm fit, 4 mm reach (2026-09-25) | Good shape and height. The fit was too tight, and the hook too short. |
| T-hook, 0.45 mm fit, 6 mm reach (2026-09-26) | The head fit well, but the necks pinched near the seam. |
| T-hook, 0.40 mm fit, 0.35 mm neck relief, 0.8 mm underside bevel (2026-09-28) | The current minishogi preset. This revision needs a print check. |

The T-hook also changed in these ways during the trials:

- The socket roof is flat, 1 mm above the highest point of the tab.
  Sideways play therefore cannot push the panel up.
- The socket mouth flares by 1.0 mm, so that its slope is not on the
  underside bevel.
- The two far corners of the head are clipped. Without the clip, they become
  very thin where the sloped roof meets the underside bevel.
- T-hook panels are rendered before the preview. Without this, OpenSCAD's
  preview can show a tab as see-through.

## Clearances of the minishogi T-hook

These are model values. They are not measured on a print.

| Place | Clearance on each side |
| --- | --- |
| Head, across the seam | 0.40 mm |
| Head, along the seam, first socket | 0.40 mm |
| Head, along the seam, other sockets | 0.80 mm (0.40 + **T Spacing Relief**) |
| Neck, first socket | 0.75 mm (0.40 + **T Neck Relief**) |
| Above the tab at the seam | 1.00 mm, more toward the tip |
| Below the tab | 1.00 mm, to the table |

The neck relief still leaves at least 1.35 mm of shoulder on each side at
the other sockets.

The clearance has a cost. When you pull a board apart, each seam opens by
about 0.4 mm. Across the eight seams of a 9 x 9 board, that is about 3.6 mm.
If that is too much, the next step is a frame around the flat panels. Do not
make the joints tighter.

## Tests for a printed board

Do these tests before you call a joint ready. They are targets, not results.

| Test | Pass |
| --- | --- |
| Before you join the panels | Each panel sits on the table without rocking. Record any bend. |
| After you join the panels | No new rocking and no raised corner, also after the last panel. |
| Step at a seam | 0.10 mm or less, and no step from the joint itself. |
| Play | Slide a piece slowly across each seam in every direction. It does not catch. |
| Bump | A sideways push does not separate a panel. All panels settle back onto the table. |
| Fit | Each panel goes in and comes out by hand, without force or sanding. |
| Reuse | Assemble and store the board 20 times. Look for wear, cracks, more play and raised seams. |
| Size | Do the tests again with a 3 x 3 board at full size. |

If a joined panel sits high but lies flat alone, the joint fails. Do not
push harder. Look for contact at the sides, and check the gaps above and
below the tab.

## Flatness options added after the joint research

Research into flush joints for printed parts (see the project's research
notes) led to three options. They are model values, not yet printed:

- **Seam Reveal** (default on): a 45 degree bevel on both edges of each seam,
  so that a small step does not catch a piece.
- **Underside Relief** (default 0.3 mm): each panel stands on a band near its
  edges, so that both sides of a seam take their height from nearly the same
  part of the table.
- **Keys**: face-down assembly with butterfly keys (契り). The table sets the
  playing faces in one plane before the keys grip, so panel thickness does
  not matter. The keys are loose parts, which breaks rule 1 above, so the
  T-hook stays the default until a Keys board is printed and measured.

Not added: tapered sliding rails (the last panel of a closed grid would have
to slide along two seams at once), zipper joints (made for 2 mm tiles), and
leaf springs in the T-hook socket (its 2 mm shoulders leave no room for a
printable leaf).

## Connectors: repair and modularity

Integral tabs have two problems. A tab snapped off ruins a whole panel. And
each panel has a fixed role, so panels cannot be rearranged. Thus the default
joint is now **Connectors**:

- Panels have sockets only. The separate double-T connector is the weak link,
  so a hard pull breaks a connector, not a panel.
- The socket takes an M4 or #8-32 screw and nut, so a lost connector can be
  bought anywhere. See the [connector spec](ban-connector-spec.md).
- Every seam edge has the same socket half, and the connector rests on the
  table, so the table still sets every panel's height. Lifting a panel
  straight up always frees it.
- The panel shoulders that hold a connector are 7 mm thick. The T-hook's are
  2 mm.

This breaks rule 1 above (no loose parts) on purpose: repair and modularity
are worth more. Connectors are model values, not yet printed; the T-hook
preset stays for comparison.

For modularity, **Seam Lines = Split** first put half of each seam line on each
panel, so every panel edge was the same. It is no longer the default; see
[Seam lines on one side](#seam-lines-on-one-side). **Panel Layout = Modules** cuts the
board into N x N-square modules, and connector sockets sit at the middles of
squares. Thus a center module is the same, to the vertex, on a 9 x 9 and a
12 x 12 board; a test checks this.

Border strips were not made. The traditional border is 7.5 mm wide, but a
connector socket needs about 18 mm of panel on each side of its seam, so a
separate strip cannot hold one. The edge and corner modules carry the border
instead.

## Seam underside bevel

Printed boards showed that the underside, the last layers of a face-down
print, can end with uneven edges. At a seam, such an edge lifted the panel
off the table. The T-hook panels already had an underside bevel; now every
joint style has a 0.8 mm bevel on the bottom of each seam edge, on both
panels (**Seam Underside Bevel**). A test checks that the underside stops the
bevel short of each seam, for every joint style.

## Catching at a seam, and connector tolerances

A sliding piece catches on a step at a seam, not on a gap: a gap of 0.4 mm
or less stays inside the black grid line, and a piece is too wide to drop
into it. The connectors do not hold the panels at the same height (they
stand 1.3 mm below the socket roof), so on a cloth or an uneven table one
panel can sink below its neighbor.

- **Seam tongues** (Connectors and Keys): a 45 degree tongue on each right
  and back seam edge, in a groove in the neighbor. Assembly is face down and
  sideways for these styles, so the tongue engages when the panels are pushed
  together. A T-hook or a Dovetail panel goes in straight down, which a tongue
  would block, so those styles have none.
- **Seam Bevel** went from 0.3 to 0.4 mm: a step of up to 0.4 mm is a slope.
  It must stay under half of Grid Groove Width with split lines.
- **Pieces** got a 0.3 mm edge bevel by default.

Connector fits come from published PLA tests: 0.05 to 0.1 mm per side fused
or would not move, 0.15 moved with friction, 0.2 to 0.25 moved freely, 0.3
was loose. Printed outer walls run 0.05 to 0.15 mm large and pockets small.

## The wedge connector, and what is left

A connector with space at its ends can only limit play, never remove it:
Slip let a pulled seam open 0.4 mm, a step reach about 0.6 mm, and the panels
shift 0.6 mm along the seam. Gaps and steps are not acceptable on a board, so
the joint was changed to remove the play:

- **Across the seam:** the shoulders lean at 1:6.7 (8.5 degrees), and so do
  the connector's ends. A pressed connector pulls the seam faces together.
  The angle is below PLA's friction angle, so the connector stays in. Print
  error changes only the depth: 0.1 mm on a face moves it 0.67 mm. Panels and
  connectors both print large, which stops the connector nearer the table, so
  a Standard connector seats 2.3 mm above the table: room for 0.35 mm of
  such error on each face, and 0.15 mm the other way. Narrow and Wide move it
  0.67 mm each way.
- **Height:** the tongue, with 0.1 mm of space on each side. The seam faces,
  not the tongue, stop the seam, so the tongue cannot hold a seam open. The
  step is at most about 0.14 mm, less when the tongue prints large.
- **Along the seam:** a nub on the tongue, in a notch, with the same space.

Lifting a panel moves its shoulders down the taper, so the wedge lets go.

Choices that were not taken:

- **The tongue as the stop, not the seam faces.** No step, but a gap of up to
  about 0.2 mm wherever the tongue prints large.
- **A quarter-turn cam.** Easier to take apart, but a complex part, short
  bridged undercuts in the socket, and no screw and nut.
- **Crush ribs** on the tongue, to take up its space. The wedge force from a
  thumb may not crush PLA, and a crushed rib fits only its first neighbor.

## Seam lines on one side

Printed boards showed the seam down the middle of each black line: Split
puts 0.45 mm of the line on each panel, about one printed line, so each half
prints thin and uneven, and the seam reads as a crack that splits the line.
**Seam Lines = One side** is now the default for every preset. The left or
front panel carries the whole 0.9 mm line (two printed lines), and the seam
runs along the line's right or back edge, where the color changes, so the eye
reads it as the edge of the line.

Modules still work: every center module carries the lines on its right and
back edges, so center modules stay interchangeable, and the edge and corner
modules differ already, because they carry the border. A camp dot on a seam
stays whole on a plug, with a notch in the neighbor.

## Connector strength and fit

Printed connectors snapped at the neck, and were hard to press in.

- **The neck did not reach the ends.** It was 15 mm long, but each end's
  inner face leans away from the seam, from 7.2 mm at the bottom to 8.2 mm at
  the top. Above the bottom 1.7 mm, a wedge-shaped gap cut each end off the
  neck, and the chamfers left a hairline. The neck now runs through both
  ends, so each end is joined over the full 4.2 x 6 mm neck section.
- **Too tight.** A Standard connector seated 1.6 mm above the table, which
  left room for only 0.24 mm of oversize on each face (0.1 mm moves it
  0.67 mm). Printed connectors run large and pockets small, so it stopped
  short and had to be forced. It now seats 2.3 mm above the table: 0.35 mm
  of room. The connector is 0.6 mm thinner (6.0 mm), so a Wide one still
  clears the socket roof. The socket (spec v1) is unchanged.

## Open work

- **One panel only.** `komascad.py ban` renders every panel. It cannot yet
  render only one panel again.
- **Board sizing.** Offer "fit my pieces" next to "exact square size".
- **Legged board.** Thin playing panels in a printed hollow base (盤台) with a
  rim that holds them, octagonal クチナシ legs and an 音受け hollow. The rim
  would also stop the seams from opening. The legged komadai styles are
  ready for it.
- **Legged komadai taller than the printer.** Beside a full legged board, a
  yagura komadai is about 275 mm tall. Separate legs printed lying down need
  a tenon that prints without supports.
- **Line width of a real board.** Measure the lacquer lines of a fine board,
  and set **Grid Groove Width** from it.
- **Surface.** Test the face-down print of the flush markings on smooth and
  textured plates, a raised-line board printed face up, and a painted-groove
  board.
- **Sound.** Print coupons with different solid layers and infill, put the
  same piece on each, and choose the slicer settings by ear.
- **Seams.** Measure how well a seam hides next to its grid line after
  assembly, and test camp dots at a seam.
- **Wedge, tongue and nub.** Print the Joint test. Record which connector
  fit seats inside the socket and closes the seam. Measure the gap and the
  step at a seam with feeler gauges, on a hard table and on a cloth, and
  slide pieces across every seam, most of all at an inner corner. Check that
  the connectors stay in after a day, and after the board is carried.
- **Plates.** Open a Whole board file in the Bambu Studio and OrcaSlicer
  apps: the command lines of Bambu Studio 2.8.2 and Elegoo Slicer keep the
  plates, but the apps were not tested. Test PrusaSlicer's Arrange.
- **Slicers.** Write down the tested slicer steps, as the print guide does
  for pieces.
- **Bambu Studio 2.8.2.61.** A user saw a crash when Bambu Studio opened a
  board 3MF at launch. The old board exporter left out the 3MF color groups,
  because the crash seemed to come from Bambu Studio's color-matching dialog.
  This was not reproduced. `komascad.py ban` uses the same 3MF writer as the
  pieces, which writes color groups. If the crash comes back, test the file
  without color groups first.

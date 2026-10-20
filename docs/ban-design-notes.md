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

## Open work

- **Bed size.** The model does not measure each panel with its tabs against a
  print bed. A check should name the panel that is too large and what to
  change.
- **One panel only.** `komascad.py ban` renders every panel. It cannot yet
  render only one panel again.
- **Board sizing.** Offer "fit my pieces" next to "exact square size".
- **Surface.** Test the face-down print of the recessed markings, and test a
  painted-groove board.
- **Seams.** Measure how well a seam hides next to its grid line after
  assembly, and test camp dots at a seam.
- **Slicers.** Write down the tested slicer steps, as the print guide does
  for pieces.
- **Bambu Studio 2.8.2.61.** A user saw a crash when Bambu Studio opened a
  board 3MF at launch. The old board exporter left out the 3MF color groups,
  because the crash seemed to come from Bambu Studio's color-matching dialog.
  This was not reproduced. `komascad.py ban` uses the same 3MF writer as the
  pieces, which writes color groups. If the crash comes back, test the file
  without color groups first.

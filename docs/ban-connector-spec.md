# Ban connector spec, version 1

This page fixes the shape of the connector socket and the seam tongue of a
KomaSCAD board, so that a connector fits every board and any two panels with
the same squares fit together. You do not need parts from KomaSCAD. Print a
connector, buy a screw and nut, or make your own to this spec.

The values are in the `[Hidden]` section of `ban/ban.scad`, named `spec_...`.
Do not change them. A change makes a new version of this spec, and old
connectors would no longer fit.

## How a seam closes

Three parts work together:

- **The connector pulls the seam closed.** Each pocket's face on the seam
  side (the shoulder) leans away from the seam as it goes deeper. The
  connector's ends lean the same way. When you press a connector in, it
  slides up the leaning shoulders until it pulls them together. The seam
  faces then touch: there is no gap.
- **The tongue holds the height.** It is centered on the board's thickness,
  so both playing surfaces are at the same height at the seam.
- **The nub lines the panels up along the seam.** It sits in a notch in the
  groove, so the grid lines meet.

A printer makes parts a little larger or smaller than the model. That
changes only how deep the connector goes, not how well the seam closes.

## Replacement hardware

Each connector can be one screw with one nut. Hardware stores and hobby
shops sell both.

| System | Screw | Nut |
| --- | --- | --- |
| Metric | M4 socket head cap screw (ISO 4762, DIN 912), 20 to 25 mm long; 22 mm is best | M4 hex nut (ISO 4032, DIN 934) |
| US | #8-32 socket head cap screw, 7/8 to 1 inch long; 7/8 inch is best | #8-32 hex nut |

A shorter screw leaves too little thread for the nut. A longer one does not
fit the socket. Use steel or nylon. To fit one:

1. Turn the nut onto the screw, until the gap between the head and the nut
   is a little over 16.5 mm.
2. Lay the screw flat in the socket, with the head in the pocket on one side
   of the seam and the nut, flat side down, in the pocket on the other.
3. If it does not drop in, turn the nut back a little. Use the smallest gap
   that still drops in. A quarter turn of an M4 nut moves it about 0.18 mm.

A screw holds the seam, but it is not a wedge: a pulled seam can open about
0.3 to 0.5 mm. Use it to replace a lost connector until you print a new one.

A screw in a socket, seen from below. Panel A is on the left of the seam
and panel B on the right. Sizes are in mm, at the socket mouth.

```text
                  PANEL A           │           PANEL B
                                    │ seam
                                    │
              pocket                │                pocket
             ┌──────┐               │               ┌──────┐
             │ ▓▓▓▓ │               │               │ ╔══╗ │
   tail      │ ▓▓▓▓ │     neck slot │               │ ║  ║ │      tail
 ┌───────────┤ ▓▓▓▓ ├───────────────┼───────────────┤ ║  ║ ├───────────┐
 │           │ ▓▓▓▓ ════════════════╪════════════════╪═║══║═╪═══╸       │
 └───────────┤ ▓▓▓▓ ├───────────────┼───────────────┤ ║  ║ ├───────────┘
             │ ▓▓▓▓ │               │               │ ║  ║ │
             │ ▓▓▓▓ │               │               │ ╚══╝ │
             └──────┘               │               └──────┘
               HEAD  ◄── shoulder ──┼── shoulder ──►  NUT      tip
                         (7 mm)     │    (7 mm)
                                    │
   ◄── 5 ──► ◄ 5.8 ►◄───── 7 ──────►│◄───── 7 ──────►◄ 5.8 ► ◄── 5 ──►
```

| Symbol | Part |
| --- | --- |
| `▓▓▓▓` | The screw head, in the pocket on one side |
| `═════` | The screw shank, flat in the neck slot, across the seam |
| `╔══╗` | The hex nut, flat side down, in the pocket on the other side |
| `╸` | The screw tip, in the tail beyond the nut |

When the panels are pulled apart, the head pushes on the shoulder of panel
A, and the nut pushes on the shoulder of panel B.

A steel screw is much stronger than a printed connector. If a seam with a
steel screw is pulled very hard, the panel can break instead of the screw.
Pull panels apart gently, or lift them straight up.

## The socket

Every socket is centered on its seam, half in each panel. It is open through
the underside of the panels, and has a flat roof.

| Value | mm | Meaning |
| --- | --- | --- |
| `spec_neck_width` | 4.8 | Width of the slot across the seam, for the screw shank |
| `spec_shoulder` | 7 | From the seam to each head or nut pocket, at the socket mouth |
| `spec_taper` | 0.15 | How far each shoulder face leans away from the seam, for each mm of depth (8.5 degrees) |
| `spec_end_length` | 5.8 | Length of each head or nut pocket, across the seam, at the socket mouth |
| `spec_end_width` | 10.6 | Width of each head or nut pocket, along the seam |
| `spec_tail` | 5 | Slot beyond each pocket, for the screw's tip |
| `spec_height` | 9.3 | Height of the socket roof above the underside |
| `spec_lead_in` | 0.4 | 45 degree chamfer round the socket mouth on the underside |

At the roof, the shoulders are 7 + 0.15 × 9.3 = 8.4 mm from the seam. Each
half of a socket is the same, so a screw can go either way round.

A board needs **Board Thickness** of 11 mm or more for connectors: the socket,
the grid groove, and 1 mm between them.

## The printed connector

A flat double-T, printed flat. Its end faces on the seam side lean like the
shoulders. Seated, a Standard connector's bottom is 1.6 mm above the table and
its top 1.1 mm below the socket roof. It never touches the table or the roof,
so the table sets every panel's height, and the table keeps the connector
from falling out.

| Part | Size (mm) |
| --- | --- |
| Neck | 4.2 wide (the slot, less 0.3 mm each side) |
| Each end | 10.0 wide, along the seam. Its inner face is 7 + 0.15 × (1.6 + height above its bottom) from the seam, less the fit. Its outer face is 12.2 from the seam. |
| Thickness | 6.6 |
| Fit | Narrow: inner faces 0.1 mm nearer the seam (seats 0.67 mm higher). Standard: as above. Wide: 0.1 mm further (seats 0.67 mm deeper). |
| Edges | 0.4 mm chamfer at 45 degrees, top and bottom |
| Fit dots | 1, 2 or 3 dots on the top of one end: Narrow, Standard or Wide |

The shoulders lean at 8.5 degrees. That is less than the angle at which PLA
slips on PLA, so a pressed connector stays in. **Output Mode** **Loose parts**
prints every connector of a board and its spares. You can make a connector of
any material to this shape.

## The seam tongue

Panels of Connectors and Keys boards also meet tongue to groove, so the
tongue has a fixed shape too. Each right and back seam edge has a tongue, and
each left and front seam edge a groove.

| Value | mm | Meaning |
| --- | --- | --- |
| `spec_tongue_depth` | 1.2 | How far the tongue reaches past the seam. Its sides are at 45 degrees. |
| `spec_tongue_half_height` | 2 | Half the tongue's height at the seam. The tongue is centered on the board's thickness. |
| `spec_tongue_clearance` | 0.1 | Space between the tongue and its groove, on each side |
| `spec_tongue_tip_space` | 0.3 | Space past the tongue tip, so that the seam faces meet first |
| `spec_tongue_margin` | 6 | From each end of a seam edge to the tongue |
| `spec_groove_margin` | 3 | From each end of a seam edge to the groove |
| `spec_nub_reach` | 0.6 | How far the nub reaches past the tongue. Its sides are at 45 degrees, also seen from above. |

The nub is on the grid line nearest the middle of each seam edge, between two
sockets. An edge one square long has no nub. The groove is longer than the
tongue, so that a panel can go in at an angle, toward two neighbors at once.

## Where the sockets go

A socket goes at the middle of each square along a seam. Two places are
skipped:

- **Near an inner corner**, where four panels meet: a socket whose middle is
  closer than 23.9 mm to the corner would meet the socket of the crossing
  seam.
- **Near the outer edge of the board**: a socket closer than 7.7 mm to the
  edge would run off the board.

The places depend only on the squares (**Cell Width** and **Cell Depth**),
so any two panels with the same squares meet socket to socket. This is what
lets modules move between boards.

## Versions

| Version | Change |
| --- | --- |
| 1 | First version: the tapered socket for a wedge connector or an M4 or #8-32 screw and nut, the printed wedge connector, socket places at square middles, and the seam tongue with its nub. |

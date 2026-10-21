# Ban connector spec, version 1

This page fixes the shape of the connector socket of a KomaSCAD board, so
that a connector fits every board. You do not need parts from KomaSCAD. Print
a connector, buy a screw and nut, or make your own to this spec.

The values are in the `[Hidden]` section of `ban/ban.scad`, named `spec_...`.
Do not change them. A change makes a new version of this spec, and old
connectors would no longer fit.

## Replacement hardware

Each connector can be one screw with one nut. Hardware stores and hobby
shops sell both.

| System | Screw | Nut |
| --- | --- | --- |
| Metric | M4 socket head cap screw (ISO 4762, DIN 912), 18 to 22 mm long; 20 mm is best | M4 hex nut (ISO 4032, DIN 934) |
| US | #8-32 socket head cap screw, 3/4 to 7/8 inch long; 3/4 inch is best | #8-32 hex nut |

A shorter screw leaves too little thread for the nut. A longer one does not
fit the socket. Use steel or nylon. To fit one:

1. Turn the nut onto the screw, until the gap between the head and the nut
   is a little over 14 mm.
2. Lay the screw flat in the socket, with the head in the pocket on one side
   of the seam and the nut, flat side down, in the pocket on the other.
3. If it does not drop in, turn the nut back a little. Use the smallest gap
   that still drops in: each extra 0.1 mm lets the seam open 0.1 mm more.
   A quarter turn of an M4 nut moves it about 0.18 mm.

A screw in a socket, seen from below. Panel A is on the left of the seam
and panel B on the right. Sizes are in mm.

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
   ◄── 6 ──► ◄ 4.8 ►◄───── 7 ──────►│◄───── 7 ──────►◄ 4.8 ► ◄── 6 ──►
```

| Symbol | Part |
| --- | --- |
| `▓▓▓▓` | The screw head, in the pocket on one side |
| `═════` | The screw shank, flat in the neck slot, across the seam |
| `╔══╗` | The hex nut, flat side down, in the pocket on the other side |
| `╸` | The screw tip, in the tail beyond the nut |

When the panels are pulled apart, the head pushes on the shoulder of panel
A, and the nut pushes on the shoulder of panel B. The seam can open only by
the gap that you set in step 1.

A steel screw is much stronger than a printed connector. If a seam with a
steel screw is pulled very hard, the panel can break instead of the screw.
Pull panels apart gently, or lift them straight up.

## The socket

Every socket is centered on its seam, half in each panel. It is open through
the underside of the panels, and has a flat roof.

| Value | mm | Meaning |
| --- | --- | --- |
| `spec_neck_width` | 4.8 | Width of the slot across the seam, for the screw shank |
| `spec_shoulder` | 7 | From the seam to each head or nut pocket |
| `spec_end_length` | 4.8 | Length of each head or nut pocket, across the seam |
| `spec_end_width` | 10.6 | Width of each head or nut pocket, along the seam |
| `spec_tail` | 6 | Slot beyond each pocket, for the screw's tip |
| `spec_height` | 9.3 | Height of the socket roof above the underside |
| `spec_lead_in` | 0.4 | 45 degree chamfer round the socket mouth on the underside |

Each half of a socket is the same, so a screw can go either way round.

A board needs **Board Thickness** of 11 mm or more for connectors: the socket,
the grid groove, and 1 mm between them.

## The printed connector

A flat double-T, printed flat. It is 8 mm thick, so it stands 1.3 mm below the
socket roof and never touches it. The table sets every panel's height.

| Part | Size (mm) |
| --- | --- |
| Neck | 4.2 wide (the slot, less 0.3 mm each side) |
| Each end | 10.0 wide, along the seam; its inner face is 7 mm + the fit from the seam |
| Fit across the seam | Slip: 0.2 mm at each end (a pulled seam opens 0.4 mm). Snug: 0.1 mm (0.2 mm). |

**Output Mode** **Loose parts** prints every connector of a board and its
spares. You can make a connector of any material that fits this envelope.

## Where the sockets go

A socket goes at the middle of each square along a seam. Two places are
skipped:

- **Near an inner corner**, where four panels meet: a socket whose middle is
  closer than 23.5 mm to the corner would meet the socket of the crossing
  seam.
- **Near the outer edge of the board**: a socket closer than 7.7 mm to the
  edge would run off the board.

The places depend only on the squares (**Cell Width** and **Cell Depth**),
so any two panels with the same squares meet socket to socket. This is what
lets modules move between boards.

## Versions

| Version | Change |
| --- | --- |
| 1 | First version: socket for M4 or #8-32 screw and nut, the printed double-T connector, and socket places at square middles. |

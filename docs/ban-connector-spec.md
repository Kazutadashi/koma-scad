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

On every seam, at the positions of **Joint Spacing** and
**Joint Edge Margin**: at least two on each seam, kept away from the corners.
Version 1 fixes the socket shape and the hardware. It does not yet fix the
socket positions: two boards fit together only if their seams have the same
length and the same settings.

## Versions

| Version | Change |
| --- | --- |
| 1 | First version: socket for M4 or #8-32 screw and nut, and the printed double-T connector. |

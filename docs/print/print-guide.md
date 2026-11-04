# Print guide

This is the reference for printing KomaSCAD pieces: every slicer setting we
changed, and why. If you are printing for the first time, start with
[print your first set](first-print.md), which walks through the slicer
step by step. Words in *italics* are in the [glossary](../glossary.md).

## The minimum you must do

1. Use a printer that prints three colors by itself (such as one with an
   AMS). A manual filament swap does not work for these pieces.
2. Load wood, black and red as filaments 1, 2 and 3.
3. Print face down on a smooth PEI plate. Don't flip or rearrange the
   pieces; the files already lie that way.
4. Print the body first on layer 1 (plate settings:
   [first layer filament sequence](#plate-setup)).
5. Print one king and one pawn before the full set, and look at the face.

Everything else on this page improves the result, but is optional for a
first try. The biggest improvement is a calibrated
[flow ratio](#calibrate-the-flow-ratio-first): do it if the test pieces show
grooves or blobs in the letters.

## Why face down

We get the best results with the pieces flat, the front face on a smooth PEI
plate. The face then copies the smooth plate, and the first layer draws the
lettering. The bundled sets and the ready-made downloads are face down.

Upright pieces also print. But a single-nozzle printer then changes filament
on every layer: this wastes much more filament, and the lettering is less
sharp. Flat pieces change filament only on the first and last layers. For
your own presets, export with `--orientation front-down` (see the
[command reference](../cli.md#print-orientation)).

## Why the edges are beveled

Every bundled set has a 0.3 mm × 0.3 mm bevel on all edges (**Bevel Width**
and **Bevel Depth**). The first layer is pressed against the plate and
spreads a little wider than the layers above it: this is *elephant's foot*,
and on a flat piece it leaves a thin lip around the face. The bevel moves the
face edge inward, so the spread fills the bevel instead. Test prints of the
learner set confirmed this. The bevel also lets a piece slide over a
board seam without catching.

Because the bevel handles it, don't turn on the slicer's elephant foot
compensation for pieces. It can open gaps between the colors of the face
(see [also tried](#also-tried)). The board is different: its joints need
exact first-layer sizes, so the [board guide](../ban.md#print) recommends
compensation for the board.

## What we tested

We print on a Bambu Lab A1 (AMS lite, 0.4 mm nozzle) with Bambu Studio 2.8.
Your printer can be different. Use these settings as a start, and please
[send a print report](https://github.com/Kazutadashi/koma-scad/issues/new?template=print-report.yml)
so we can add yours.

| Slicer | Opens the color 3MF with the right filament slots | Process profile | Printed by us |
| --- | --- | --- | --- |
| Bambu Studio 2.8 | Yes | [Yes](bambu/) | Yes |
| Elegoo Slicer | Yes (opened, not printed) | No: copy the [settings table](#changes-from-016mm-optimal-bbl-a1) | No |
| OrcaSlicer | Expected to work (Elegoo Slicer is built on it and reads the same slots), but not tested | No: copy the settings table | No |
| Other slicers | Unknown. The file holds standard 3MF colors, but you may have to set each part's filament yourself. | No | No |

## Import a color 3MF

1. Open the 3MF in your slicer. Keep the parts of each piece together: do not
   split them into separate objects.
2. Load the filaments in the slots that the file uses. For the bundled sets:

   | Slot | Filament | Part |
   | --- | --- | --- |
   | 1 | Wood | Body |
   | 2 | Black | Front text |
   | 3 | Red | Back text |

3. Make sure that each part shows the correct color.

Each part has a name such as **Front | Black**. The slots follow the order in
which each material first appears: the body, then the front, then the back.
See [filament slot](../glossary.md#3d-printing) in the glossary.

The file holds the standard 3MF colors. It also holds the filament slot of
each part, because OrcaSlicer and its forks (such as Elegoo Slicer) ignore
the standard colors. Bambu Studio reads the slots too. We tested the same
file in the Bambu Studio and Elegoo Slicer apps.

- Bambu Studio 2.8's command line stops on the filament slots. For that tool,
  export with `--plain`.
- Bambu Studio 2.8.2.60 can show "The 3mf file has invalid config, load
  geometry data only". Close the message. The parts still load. See
  [Bambu Studio issue #11927](https://github.com/bambulab/BambuStudio/issues/11927).
- The file has no printer, filament or process settings. Set these in your
  slicer.

## Calibrate the flow ratio first

> A correct flow ratio for each filament is the most important setting. No
> other setting on this page can correct a wrong flow ratio.

The *flow ratio* scales how much plastic the printer pushes out. Every spool
is a little different, so the right value differs from the slicer's default
by a few percent. Calibrating means printing a small test with a range of
values, picking the best-looking one, and saving it in the filament's
settings. It takes one or two short prints per filament.

The face is one layer of small strokes that are close together:

- A few percent too little flow leaves grooves and holes between the lines.
- A few percent too much flow is worse. Plastic collects in blobs where
  strokes meet. The nozzle then hits the blobs, and moves or removes small
  details.

In our test prints the calibrated values were 0.9575 for a SUNLU wood PLA
and 1.02 for Bambu PLA Matte.

We recommend
[Improved Flow Ratio Calibration v3](https://makerworld.com/models/189543)
(jimcorner, MakerWorld). We found Bambu Studio's own flow calibration hard to
read.

1. In Bambu Studio, turn on **developer mode** (in the preferences). Each
   test piece has its own flow ratio, and only developer mode keeps it.
2. Print a rough test at flow 1.0.
3. Print a fine test around the best rough result.
4. Save the result in the filament preset.
5. Calibrate each filament. Calibrate each color of the same product too.

<!-- TODO(photo): a piece face before flow calibration, and the same face after it. Save as images/print/flow-before-after.jpg. -->

## Before you print

- Dry the filament. Wet filament spits, which makes gaps and blobs in the
  lettering. Wood-filled PLA is very sensitive.
- Clean the plate with dish soap and hot water, and rinse it. Do not touch
  the print area. Isopropyl alcohol alone spreads oil around instead of
  removing it.
- Do not print on scratched or worn areas. The face copies the plate surface.

## Profiles

The only process profile so far is for Bambu Studio and the A1 with a
0.4 mm nozzle: [bambu/komascad-face-down-0.15mm-a1-0.4mm.json](bambu/komascad-face-down-0.15mm-a1-0.4mm.json).
[Step 2 of the first print guide](first-print.md#2-import-the-komascad-print-profile)
shows how to import it. For another printer, copy the values in the next
table into your own preset. Profiles for other printers and slicers are
welcome as pull requests.

There are no filament presets. Their only change would be the flow ratio,
which you calibrate for your own filament.

## Changes from 0.16mm Optimal @BBL A1

| Setting | Default | Ours | Why |
| --- | --- | --- | --- |
| Layer height | 0.16 mm | 0.15 mm | Balances the steps on the back with the number of color-change layers |
| First layer speed | 50 mm/s | 30 mm/s | Small strokes bond and flatten before the nozzle moves on |
| First layer infill speed | 105 mm/s | 30 mm/s | The same. The face is mostly first-layer infill. |
| Bottom surface pattern | Monotonic | Monotonic line | Separate straight lines, with no turns inside small strokes |
| Infill direction | 45° | 0° | A smoother face with fewer defects. It matches the steps on the back. |
| Only one wall on first layer | Off | On | Fewer small wall loops in thin strokes. Strokes fill with straight lines. |
| Wall generator | Classic | Arachne | Variable line width fills strokes without gap-fill lines |
| Wall distribution count | 1 | 2 | Spreads width changes over two walls. Smoother strokes. |
| Wall transitioning filter margin | 25% | 30% | Fewer sudden width changes at junctions |
| Minimum wall width | 85% | 55% | Keeps thin strokes |
| Minimum feature size | 25% | 15% | Keeps small details and narrow gaps between strokes |
| Slice gap closing radius | 0.049 mm | 0.01 mm | The slicer does not close narrow gaps between strokes |
| Resolution | 0.012 mm | 0.003 mm | Keeps fine character outlines |
| Arc fitting | On | Off | Keeps the outlines as sliced |
| Top solid infill flow ratio | 1.0 | 1.025 | Closes small gaps on the top (back) surface |
| Skirt loops | 0 | 6 | Primes the nozzle and makes the flow stable before the first detailed layer |
| Sparse infill pattern | Grid | Gyroid | Inside only. No effect on the face. |

All other settings are the Bambu defaults. This includes the first layer
height (0.2 mm) and the first layer line width (0.5 mm).

## Plate setup

Print the body color first on the first layer. In Bambu Studio, set this in
the plate settings, under **First layer filament sequence**. The lettering then
fills the spaces in the body, and the characters are much clearer.

## Pressure advance

Pressure advance calibration can correct some small surface defects. In our
tests it had much less effect than the flow ratio. We did a manual
calibration for the wood PLA, and Bambu's automatic calibration for PLA Matte.

## Nozzle size

A smaller nozzle, such as 0.2 mm, makes a better face. But it prints much
more slowly and wastes more filament on color changes. Wood-filled PLA cannot
use it, because the particles block small nozzles. Our settings are for a 0.4 mm
nozzle.

## Also tried

These did not help alone. They are here so that you can skip them, or try
them again.

| Tried | Result |
| --- | --- |
| First layer line width 0.42 mm | Worse than 0.5 mm. Less adhesion and less merging. |
| First layer height 0.24 mm | Rounder lines, and grooves that you can see |
| Elephant foot compensation 0–0.1 mm | Can open gaps between colors on the face. Small benefit. The 0.3 mm edge bevel handles elephant's foot instead. |
| Classic walls; Arachne minimums down to 10% / 60% | Classic is worse. Very low minimums gave thin, blobby lines. |
| Lettering first on layer 1 | Blobs where the body pushed in around the strokes. Body first is better. |
| Bambu flow-rate calibration | Hard to read. We use the MakerWorld test. |
| First-layer flow ratio 0.95–1.05 (developer mode) | Little difference after the flow ratio was calibrated |
| Bed 65 °C first layer, 55 °C after | Less elephant foot on long prints. No effect on the face. |


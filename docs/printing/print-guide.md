# Print guide

This guide tells you how to import a color 3MF and how we print the pieces.
We get the best results with the pieces flat, an inscribed face on a smooth
PEI plate. The first layer then makes the lettering.

Upright pieces also print. But a single-nozzle printer then changes filament
on every layer: this wastes much more filament, and the lettering is less
sharp. Flat pieces change filament only on the first and last layers. Export
them with `--orientation front-down` (see the
[command reference](../cli.md#print-orientation)).

We tested on a Bambu Lab A1 (AMS lite, 0.4 mm nozzle) with Bambu Studio 2.8.
Your printer can be different. Use these settings as a start.

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
A slot is a number, not a color. Thus load the matching filament in each slot.

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

> **IMPORTANT:** A correct flow ratio for each filament is the most
> important setting. No setting below can correct a wrong flow ratio.

The face is one layer of small strokes that are close together:

- A few percent too little flow leaves grooves and holes between the lines.
- A few percent too much flow is worse. Plastic collects in blobs where
  strokes meet. The nozzle then hits the blobs, and moves or removes small
  details.

Our values are far from the defaults: 0.9575 for a SUNLU wood PLA, and 1.02
for Bambu PLA Matte.

We recommend
[Improved Flow Ratio Calibration v3](https://makerworld.com/models/189543)
(jimcorner, MakerWorld). We found Bambu Studio's own flow calibration hard to
read.

1. In Bambu Studio, turn on **developer mode**. Each test piece has its own
   flow ratio, and only developer mode keeps it.
2. Print a rough test at flow 1.0.
3. Print a fine test around the best rough result.
4. Save the result in the filament preset.
5. Calibrate each filament. Calibrate each color of the same product too.

*Photo to come: a face before flow calibration, and a face after it.*

## Before you print

- **Dry the filament.** Wet filament spits, which makes gaps and blobs in the
  lettering. Wood-filled PLA is very sensitive.
- **Clean the plate with dish soap and hot water.** Rinse it. Do not touch
  the print area. Isopropyl alcohol alone spreads oil: it does not remove it.
- Do not print on scratched or worn areas. The face copies the plate surface.

## Profiles

The slicer presets are next to this guide, one folder for each slicer:

| Slicer | Folder | Status |
| --- | --- | --- |
| Bambu Studio | [bambu](bambu/) | Available |
| OrcaSlicer | `orca` | To come |
| Elegoo Slicer | `elegoo` | To come |

In Bambu Studio, select **File → Import → Import Configs**. The preset is
based on **0.16mm Optimal @BBL A1**. For another printer, copy the values in
the next table into your own preset. There are no filament presets: their
only change is the flow ratio, and you must calibrate it yourself.

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

**Print the body color first on the first layer.** In Bambu Studio, set this
in the plate settings: **First layer filament sequence**. The lettering then
fills the spaces in the body, and the characters are much clearer.

## Pressure advance

Pressure advance calibration can correct some small surface defects. In our
tests it had much less effect than the flow ratio. We did a manual
calibration for the wood PLA, and Bambu's automatic calibration for PLA Matte.

## Nozzle size

A smaller nozzle, such as 0.2 mm, makes a better face. But it prints much
more slowly and wastes more filament on color changes. Wood-filled PLA cannot
use it: the particles block small nozzles. Our settings are for a 0.4 mm
nozzle.

## Also tried

These did not help alone. They are here so that you can skip them, or try
them again.

| Tried | Result |
| --- | --- |
| First layer line width 0.42 mm | Worse than 0.5 mm. Less adhesion and less merging. |
| First layer height 0.24 mm | Rounder lines, and grooves that you can see |
| Elephant foot compensation 0–0.1 mm | Can open gaps between colors on the face. Small benefit. |
| Classic walls; Arachne minimums down to 10% / 60% | Classic is worse. Very low minimums gave thin, blobby lines. |
| Lettering first on layer 1 | Blobs where the body pushed in around the strokes. Body first is better. |
| Bambu flow-rate calibration | Hard to read. We use the MakerWorld test. |
| First-layer flow ratio 0.95–1.05 (developer mode) | Little difference after the flow ratio was calibrated |
| Bed 65 °C first layer, 55 °C after | Less elephant foot on long prints. No effect on the face. |

## Checklist

1. Calibrate the flow ratio of each filament.
2. Dry the filament. Wash the plate.
3. Export the pieces flat, with the lettering face down.
4. Import the profile, or copy the table into your own preset.
5. Set the body color to print first on layer 1.
6. Look at layer 1 in the slicer preview. Look for gaps in the strokes.
7. Print one king and one pawn before you print a set.

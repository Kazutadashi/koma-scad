# Print guide: lettering on the bed

How we print multicolour KomaSCAD pieces. We got our best results with the
pieces lying flat and an inscribed face on a smooth PEI plate, so the
lettering is formed by the first layer, and tuned our slicer settings for that.
Upright pieces still work, but with a single-nozzle printer every layer needs
colour swaps (much more purge waste), and the lettering picks up a fuzzier
finish from the layer lines. Lying flat, the swaps are limited to the first and
last few layers. See [batch export](../batch-export.md#print-orientation) for the
`--orientation` options.

Tested on a Bambu Lab A1 (AMS lite, 0.4 mm nozzle) with Bambu Studio 2.8.
Results vary between printers; treat these settings as a starting point.

> [!IMPORTANT]
> **The most important "setting" is a correctly tuned flow ratio for each
> filament.** The face is a single layer of small, closely spaced strokes.
> A few percent too little flow leaves grooves and pits between lines. A few
> percent too much is worse: excess plastic piles into blobs where strokes
> meet, and the nozzle catches on the raised material, dislodging, moving or
> removing small details. No process setting below compensates for a wrong
> flow ratio. Our calibrated values
> ended up well away from the defaults (0.9575 for a SUNLU wood PLA, 1.02 for
> Bambu PLA Matte), so don't skip this.
>
> We recommend
> [Improved Flow Ratio Calibration v3](https://makerworld.com/models/189543)
> (jimcorner, MakerWorld) over Bambu Studio's built-in flow calibration, which
> we found hard to read. In Bambu Studio it needs **developer mode** enabled,
> because each test piece carries its own flow-ratio multiplier. Follow the
> model's instructions: a rough pass at flow 1.0, then a fine pass around the
> rough result. Save the final value in the filament preset, and calibrate
> every filament separately, including different colours of the same product.

*Photo coming soon: a face printed before flow tuning next to one printed after.*

## Before you print

- **Dry the filament.** Moist filament sputters, which shows up as random gaps
  and blobs in the lettering. Wood-filled PLA is especially sensitive.
- **Clean the plate with dish soap and hot water**, rinse, and don't touch the
  print area. Isopropyl alcohol alone spreads oils rather than removing them.
  The plate surface is copied onto the face, so avoid scratched or worn areas.

## Profiles

Slicer presets are next to this guide, one folder per slicer:

| Slicer | Folder | Status |
| --- | --- | --- |
| Bambu Studio | [bambu](bambu/) | Available |
| OrcaSlicer | `orca` | Coming soon |
| Elegoo Slicer | `elegoo` | Coming soon |

In Bambu Studio, import with **File → Import → Import Configs**. The Bambu
preset inherits **0.16mm Optimal @BBL A1**; for another printer, copy the
values from the table below into your own preset. Filament presets are not
included: their only change is the flow ratio, which must be calibrated for
your own printer and spool.

## Changes from 0.16mm Optimal @BBL A1

| Setting | Default | Ours | Why |
| --- | --- | --- | --- |
| Layer height | 0.16 mm | 0.15 mm | Good balance between stair-stepping on the back and the number of colour-swap layers |
| First layer speed | 50 mm/s | 30 mm/s | Small strokes bond and flatten before the nozzle moves on |
| First layer infill speed | 105 mm/s | 30 mm/s | Same; the face is mostly first-layer infill |
| Bottom surface pattern | Monotonic | Monotonic line | Separate straight lines, no connecting turns inside small strokes |
| Infill direction | 45° | 0° | More consistent, smoother face with fewer extrusion defects; matches the stair-stepped lines on the back |
| Only one wall on first layer | Off | On | Fewer tiny wall loops in thin strokes; strokes fill with straight lines |
| Wall generator | Classic | Arachne | Variable line width fills strokes without gap-fill scribbles |
| Wall distribution count | 1 | 2 | Spreads width changes over two walls; smoother strokes |
| Wall transitioning filter margin | 25% | 30% | Fewer abrupt width changes at junctions |
| Minimum wall width | 85% | 55% | Keeps thin strokes instead of dropping them |
| Minimum feature size | 25% | 15% | Keeps small details and narrow gaps between strokes |
| Slice gap closing radius | 0.049 mm | 0.01 mm | Stops the slicer closing narrow gaps between strokes |
| Resolution | 0.012 mm | 0.003 mm | Keeps fine character outlines instead of simplifying them |
| Arc fitting | On | Off | Outlines stay as sliced, not approximated by arcs |
| Top solid infill flow ratio | 1.0 | 1.025 | Closes small gaps on the top (back) surface |
| Skirt loops | 0 | 6 | Primes the nozzle, purging it further and stabilising flow before the first detailed layer |
| Sparse infill pattern | Grid | Gyroid | Interior only; no effect on the face |

Everything else is the Bambu default, including first layer height (0.2 mm)
and first layer line width (0.5 mm).

## Plate setup

**Print the body colour first on the first layer** (Bambu Studio: plate
settings → first layer filament sequence). The lettering then squeezes into
the voids left in the body, which made the characters much clearer.

## Pressure advance

Calibrating pressure advance may fix some remaining surface imperfections, but
in our testing it was far less impactful than flow ratio. We used a manual
calibration for the wood PLA and Bambu's automatic calibration for PLA Matte.

## Nozzle size

A smaller nozzle (for example 0.2 mm) improves face quality further, but
prints much more slowly, wastes more filament on colour swaps, and cannot be
used with wood-filled PLA, whose particles clog fine nozzles. Our settings are
for a 0.4 mm nozzle.

## Also tried

None of these helped on their own. Listed so others can skip them or revisit
them.

| Tried | Result |
| --- | --- |
| First layer line width 0.42 mm | Worse than the 0.5 mm default; less adhesion and merging |
| First layer height 0.24 mm | Rounder lines, visible grooves |
| Elephant foot compensation 0–0.1 mm | Can open gaps between colours on the face; little benefit |
| Classic walls; Arachne minimums down to 10% / 60% | Classic worse; very low minimums gave starved, blobby lines |
| Lettering first on layer 1 | Blobs where the body squeezed in around the strokes; body first is better |
| Bambu flow-rate calibration | Hard to read; replaced by the MakerWorld test above |
| First-layer flow ratio 0.95–1.05 (developer mode) | Hard to see a difference once flow ratio was calibrated |
| Bed 65 °C first layer / 55 °C after | Reduces elephant foot on long prints; no effect on face quality |

## Checklist

1. Calibrate flow for each filament (above).
2. Dry the filament; wash the plate.
3. Export the pieces lying flat with the lettering face down.
4. Import the profile, or apply the table to your own preset.
5. Set the body colour to print first on layer 1.
6. Check layer 1 in the slicer preview for gaps in strokes.
7. Print one king and one pawn before committing to a set.

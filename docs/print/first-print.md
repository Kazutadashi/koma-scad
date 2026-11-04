# Print your first set

This guide takes you from a downloaded `.3mf` file to 40 finished pieces. It
assumes you have never used a slicer before. If you have, read the short
version below and the notes marked "Why:" in each step.

We print on a Bambu Lab A1 with an AMS lite and a 0.4 mm nozzle, in Bambu
Studio. The menu names below are Bambu Studio's. Other slicers have the same
settings under similar names. Words in *italics* are in the
[glossary](../glossary.md).

In short: load wood, black and red as filaments 1, 2 and 3, print
on a smooth PEI plate, don't move or flip anything, set the body to print
first on layer 1, and print one king and one pawn before the full set.

## 0. Before you start: what you need

You need:

- A printer that can print three colors in one print.
- A bed of at least 256 × 256 mm.
- Three PLA filaments.
- A smooth, clean build plate.
- Dry filament.

### Printer

The letters share their layers with the body, side by side, so the printer
must switch filament by itself in the middle of a layer. Any of these work:

- A Bambu Lab printer with an *AMS* or AMS lite.
- Another printer with an automatic multi-material unit or a *toolchanger*.
- A two-color printer: load black for both lettering colors (see
  [FAQ](../faq.md#my-printer-has-only-two-colors)).

A "pause and swap filament by hand" print does not work for these
pieces. The letters and the body share the same layers, so there is no one
moment to swap. If you have a one-color printer, see the
[FAQ](../faq.md#i-only-have-a-one-color-printer).

### Bed

The one-plate set is about 242 × 228 mm, which fits a
256 × 256 mm bed (Bambu Lab A1, P1 and X1). For a smaller bed, see
[it doesn't fit my bed](../faq.md#the-set-doesnt-fit-my-bed).

### Filament

| Slot | Color | For | What we use |
| --- | --- | --- | --- |
| 1 | Wood (beige or tan) | The body of each piece | SUNLU wood-filled PLA, or Bambu PLA Matte |
| 2 | Black | The front lettering | Bambu PLA Matte |
| 3 | Red | The lettering on the promoted side | Bambu PLA Matte |

Matte PLA hides layer lines and looks more like wood than shiny PLA. A
wood-filled PLA (PLA with real wood fiber) looks even better, and prints fine
with a 0.4 mm nozzle; don't use it in a smaller nozzle, as the fibers clog
it. Step 9 shows how to read the grams of each filament that the set uses.

### Build plate

The face of each piece copies the plate's surface.
A smooth PEI plate gives a satin face; a textured PEI plate prints its
texture into the face. Both work, but the letters are sharpest on smooth.

Damp filament spits and leaves gaps in the letters.
Wood-filled PLA picks up moisture quickly. If a spool has been open for
weeks, dry it first (in a filament dryer, or as your printer's maker
recommends).

Wash the plate with dish soap and hot water, rinse it, and let it
dry. Don't touch the print area with your fingers afterwards.

## 1. Install the slicer and choose your printer

A *slicer* turns the 3D file into instructions (*G-code*) for your printer.

1. Install [Bambu Studio](https://bambulab.com/en/download/studio) (or the
   slicer your printer's maker recommends).
2. On first start, pick your printer and its nozzle: **0.4 mm**.
3. Pick the build plate type you will use. In Bambu Studio it is the
   **Plate type** setting on the left, near the top. Choose your smooth PEI
   plate.

## 2. Import the KomaSCAD print profile

A *process profile* is a saved group of slicer settings. The KomaSCAD
profile is tuned for small, sharp letters on the first layer.

If you have a Bambu Lab A1 with a 0.4 mm nozzle:

1. Download
   [`komascad-face-down-0.15mm-a1-0.4mm.json`](bambu/komascad-face-down-0.15mm-a1-0.4mm.json)
   (on GitHub, click **Download raw file**).
2. In Bambu Studio, select **File → Import → Import Configs** and choose the
   file.
3. In the **Process** list on the left, select
   **KomaSCAD face-down 0.15mm A1 0.4**.

For any other printer, start from your printer's standard 0.16 mm
profile, and copy the settings from the
[table in the print guide](print-guide.md#changes-from-016mm-optimal-bbl-a1)
into it. Save it under a new name. The profile is built on Bambu's
**0.16mm Optimal @BBL A1**, so it only appears when the A1 is selected.

## 3. Open the set

1. Select **File → Open Project** (or drag the `.3mf` onto the window).
2. If a message says **"The 3mf file has invalid config, load geometry data
   only"**, click it away. It is harmless: the pieces load correctly. (It is
   a [Bambu Studio quirk](https://github.com/bambulab/BambuStudio/issues/11927).)

You should see 40 pieces in neat rows, back side up: wood-colored
bodies with red letters (the kings and golds have a blank back). In the
object list on the right, each piece is one object, named like
**Shogi Learner 09 - Pawn**. Open one to see its parts:
**Body | Wood**, **Front | Black**, and (on pieces that promote)
**Back | Red**.

Leave the layout as it is:

- Don't press **Arrange** (A) or drag pieces around. The layout is already
  planned to fit the plate.
- Don't split objects into parts. Each piece's parts must stay together, or
  the letters separate from the body.
- Don't flip the pieces. They lie face down on purpose (step 6).

## 4. Match filaments to slots

Each part already has its *filament slot*. The slot number is a position in
the slicer; whatever you load in slot 1 is used for every body.

1. In the **Filament** list on the left, make sure there are at least three
   filaments. Click **+** to add one if needed.
2. Set filament 1 to your wood-colored PLA, 2 to black and 3 to red. Pick the
   matching filament type (for example, Bambu PLA Matte) so the slicer uses
   the right temperatures.
3. With an AMS, you can match the filaments to the AMS trays now (Bambu
   Studio has a sync button by the filament list), or when you send the
   print (step 11).
4. Check the 3D view: wood bodies with red letters on top. The black front
   letters are underneath; tilt the view to see them.

If everything shows in one color, see
[the slicer shows one color](../faq.md#the-slicer-shows-everything-in-one-color).

## 5. Plate settings: body first

> Why: this setting makes the letters much clearer.

The first layer holds both the body and the letters. Print the body first,
and the letters then fill the spaces that the body leaves.

1. Open the plate's settings. In Bambu Studio, click the small settings icon
   on the plate's tab in the 3D view, or right-click the plate.
2. Set **First layer filament sequence** to customize, and put filament 1
   (the body) first.

If the set is split over several plates (for a smaller bed), do this for
each plate.

## 6. Orientation: face down on purpose

The pieces arrive lying on their front face. That face prints
first, flat against the smooth plate, so it comes out as smooth as the plate
and the first layer draws the letters. Don't flip them.

The edges of every piece have a small 0.3 mm bevel. The first layer is
always squashed a little wider than the rest (*elephant's foot*); the bevel
gives it room, so no lip sticks out around the face.

## 7. Supports, brim, skirt and prime tower

| Setting | Set it to | Why |
| --- | --- | --- |
| **Supports** | Off | The pieces lie flat. Nothing hangs in the air. |
| **Brim** | None needed | Each piece lies on its whole face, which holds well. If the slicer adds a small brim by itself, that's fine: peel it off after. |
| **Skirt** | 6 loops (the profile sets it) | The lines around the pieces prime the nozzle, so the flow is steady before it draws the letters. Peel it off after. |
| **Prime tower** | On (the default for multi-color prints) | It cleans the nozzle at each filament change. Some filament is always wasted on multi-color prints; the slicer shows how much. |

## 8. Layer height

Leave it as the profile sets it: **0.15 mm** layers, with the printer's usual
first layer (0.2 mm on the A1). Don't change the first layer height or line
width: we tried, and the default is better (see
[also tried](print-guide.md#also-tried)).

## 9. Slice and check the preview

1. Click **Slice plate** (top right).
2. In the **Preview**, drag the layer slider on the right all the way down
   to layer 1. Zoom in on a few pieces.
3. Look at the letters. Each stroke should be a solid line of black (or
   red on the last layers). Look for:
   - Missing or broken strokes, or gaps in a stroke: the line is too thin
     for the nozzle. With the bundled sets this should not happen. If it
     does, check that you used the KomaSCAD profile and a 0.4 mm nozzle.
   - Strokes that run together: the gaps between them are too narrow.
4. Read the summary: the print time, the grams of each filament and the
   number of filament changes. Multi-color prints take many hours.

## 10. Print a test pair first

Before you spend hours on 40 pieces, print one king and one pawn. They are
quick, and they show almost every problem a full set would.

1. In the object list, select every piece except one king and one pawn, and
   press **Delete**. Slice.
2. Print them (step 11) and look at them (step 12).
3. For the full set, open the downloaded `.3mf` again. (If you save the test
   project, use **Save Project As** with a new name, so the original file
   stays complete.)

You don't have to calibrate first. Try the test pair with your
filament's standard settings. Look at the face:

- Clean, filled strokes: carry on with the full set.
- Fine grooves or holes between the lines of a stroke: too little flow.
- Blobs where strokes meet, or small details pushed out of place: too much
  flow.

If you see either, calibrate the *flow ratio* of that filament. A wrong flow
ratio causes most problems with these faces. The
[print guide](print-guide.md#calibrate-the-flow-ratio-first) explains how,
and lists the values from our test prints.

## 11. Send the print and watch the first layer

1. Click **Print plate**.
2. Bambu Studio shows each filament and which AMS tray it will use. Make
   sure 1 is the wood color, 2 black, 3 red.
3. Leave **Bed leveling** on. If the dialog offers **Flow dynamics
   calibration**, leaving it on is fine.
4. Watch the first layer. The skirt should be a smooth, even line. The
   bodies go down first, then the letters fill in. If the first layer
   doesn't stick or looks rough, stop the print, clean the plate and try
   again.

## 12. After the print

1. Let the plate cool to room temperature. The pieces often release by
   themselves.
2. Take the flexible plate off the printer and flex it gently. The pieces
   pop off. Don't pry them with a metal scraper: it can scratch the faces.
3. Peel off the skirt and throw it away.
4. Look at each face. A soft fingernail removes a stray string. A blob
   or a gap in a stroke is a flow problem (step 10).
5. Sort the pieces and count them. Each player gets half:

   | Piece | In the set | Each player |
   | --- | --- | --- |
   | King (王 / 玉) | 2 | 1 |
   | Rook (飛) | 2 | 1 |
   | Bishop (角) | 2 | 1 |
   | Gold (金) | 4 | 2 |
   | Silver (銀) | 4 | 2 |
   | Knight (桂) | 4 | 2 |
   | Lance (香) | 4 | 2 |
   | Pawn (歩) | 18 | 9 |

   The release's `.manifest.json` file lists the same counts.

Now [learn to play](../play/how-to-play.md), and make a
[board, stands and a box](../whole-set.md) when you are ready.

## Troubleshooting

| What you see | Likely cause | What to do |
| --- | --- | --- |
| Grooves or holes between the lines of a stroke | Flow too low | [Calibrate the flow ratio](print-guide.md#calibrate-the-flow-ratio-first) |
| Blobs where strokes meet; small details dragged away | Flow too high | Calibrate the flow ratio |
| Gaps and bubbles, popping sounds | Damp filament | Dry the filament |
| Blobs around the letters, where the body pushed in | Letters printed before the body on layer 1 | Put the body first ([step 5](#5-plate-settings-body-first)) |
| A lip around the face | Elephant's foot | The 0.3 mm bevel should hide it. On long prints, a 65 °C bed for the first layer and 55 °C after reduced it in our tests. Don't use the slicer's elephant foot compensation on pieces: it can open gaps between the colors. |
| Face is dull or patterned | Textured or worn plate | Use a smooth PEI plate, and avoid scratched areas |
| A piece came loose during the print | Oily plate | Wash the plate with dish soap and hot water |
| Everything is one color | Filaments not set up | [FAQ](../faq.md#the-slicer-shows-everything-in-one-color) |
| The pieces stand upright | A file exported from your own preset with a different orientation | Export again with `--orientation front-down` |

Still stuck? [Open a print report](https://github.com/Kazutadashi/koma-scad/issues/new?template=print-report.yml)
with a photo of the face. More answers are in the [FAQ](../faq.md).

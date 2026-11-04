# FAQ and troubleshooting

Answers to common questions. Words in *italics* are in the
[glossary](glossary.md).

- [Getting a set](#getting-a-set)
- [Printers and filament](#printers-and-filament)
- [In the slicer](#in-the-slicer)
- [The printed pieces](#the-printed-pieces)
- [The tools](#the-tools)
- [Sharing and selling](#sharing-and-selling)

## Getting a set

### Do I need to install anything?

Not to print a ready-made set. Download the `.3mf` from the
[Releases page](https://github.com/Kazutadashi/koma-scad/releases) and open
it in your *slicer*. You only need OpenSCAD and Python to make your own
pieces, or the board, the stands and the box. See [install](install.md).

### Which set should I print?

Learner, if you or the people you play with are new to shogi, because each
piece shows how it moves. Otherwise, pick by looks. See
[ready-made sets](ready-sets.md).

### Is there a board?

Yes, but it is not part of the ready-made downloads. You make it with the
free tools: see [make the whole set](whole-set.md).

## Printers and filament

### Do I need a multi-color printer?

For the ready-made sets, yes: the letters are printed in a different color,
side by side with the body in the same layers, so the printer must change
filament by itself. A Bambu Lab printer with an *AMS*, another printer with
an automatic multi-material unit, or a *toolchanger* works.

### I only have a one-color printer

Print the pieces in one color with recessed (carved) letters, then fill the
letters with paint. This is how many traditional pieces are made. It needs
OpenSCAD ([install](install.md#2-install-openscad)), but not Python:

1. Open `koma/koma.scad` in OpenSCAD.
2. Pick a piece's preset, such as **Shogi Learner 09 - Pawn**.
3. Press **F6**, wait for the render, then select **File → Export → Export
   as STL**.
4. Do this for each of the 9 different pieces, and print each as many times
   as [the set needs](print/first-print.md#12-after-the-print).
5. Fill the letters with acrylic paint, and wipe the face clean before it
   dries.

A pause-and-swap filament change does not work: the letters and the body
share the same layers. Also, don't print a color 3MF on a one-color printer
with every part on one filament. The letters are level with the face, so
they disappear.

### My printer has only two colors

In the slicer, set the parts on filament 3 (the red promoted-side letters)
to filament 2. The promoted sides then have black letters. Everything else
is the same.

### Can I use other colors?

Yes. Load any color in each [filament slot](glossary.md#3d-printing), for
example a dark body, white letters and blue promoted sides. Keep good contrast between
the body and the letters.

### What filament should I buy?

PLA, in three colors: a wood color (beige or tan) for the bodies, black and
red. Matte PLA looks best. A wood-filled PLA looks even more like wood and
works with a 0.4 mm nozzle. See [what you need](print/first-print.md#0-before-you-start-what-you-need).

### How long does a set take to print, and how much filament?

It depends on your printer and settings. Slice the file and read the
summary: it shows the print time and the grams of each filament.

### The set doesn't fit my bed

The one-plate set is about 242 × 228 mm. For a smaller bed:

- With the free tools, export the set in files of at most 20 pieces,
  with `python3 komascad.py export shogi-learner --per-file 20` (or another
  number). Use as many plates as it needs.
- In the slicer, you can move some pieces to a second plate by hand. Move
  whole pieces only; never split a piece into its parts.

### Can a print service print it?

Only one that prints multi-color FDM. Many services print one color (and
resin or nylon powder prints are one color too), so the letters would
disappear. If you find a multi-color FDM service, or a friend with an AMS,
send them the `.3mf` and the
[print guide](print/print-guide.md#the-minimum-you-must-do), and ask for:
PLA, 0.4 mm nozzle, smooth PEI plate, the file's layout unchanged,
wood/black/red in filaments 1/2/3, and the body printed first on layer 1.

## In the slicer

### Do I have to calibrate the flow ratio?

Not for a first try. Print one king and one pawn with your filament's
standard settings. If the strokes are clean, print the set. If you see
grooves or blobs in the letters, calibrate: see
[print a test pair first](print/first-print.md#10-print-a-test-pair-first).

### The slicer shows everything in one color

- Make sure the slicer has at least three filaments in its filament
  list, set to different colors. Add filaments with **+**.
- Open a piece in the object list. Its parts (**Body | Wood**,
  **Front | Black**, **Back | Red**) should show filaments 1, 2 and 3. If
  they all show 1, your slicer did not read the slots. Set each part's
  filament by hand, or use Bambu Studio (tested) or Elegoo Slicer.
  OrcaSlicer is expected to work but is not tested yet.
- Look underneath. The pieces lie face down, so the black fronts are under
  the pieces. From above you see the red promoted sides, and the kings and
  golds have blank backs.

### A message says "The 3mf file has invalid config"

In Bambu Studio this is harmless. Close it: the pieces load correctly.

### The pieces split into separate parts

Undo. Don't use **Split to objects** or **Split to parts**, and don't
**Arrange**. Each piece must stay one object, with its parts aligned.

### Should I flip the pieces over?

No. They lie on their front face on purpose. That face prints against the
smooth plate, so it comes out smooth, and the first layer draws the
letters.

## The printed pieces

### There is a thin lip around the face

That is *elephant's foot*. The 0.3 mm bevel on every edge should hide it.
Don't use the slicer's elephant foot compensation on pieces: it can open
gaps between the colors. See
[why the edges are beveled](print/print-guide.md#why-the-edges-are-beveled).

### The letters have gaps, grooves or blobs

That is almost always the flow ratio, or damp filament. See the
[troubleshooting table](print/first-print.md#troubleshooting).

### The face is rough or patterned

The face copies the plate. Use a smooth PEI plate, clean it with dish soap
and hot water, and avoid scratched areas.

## The tools

### "cannot find OpenSCAD", or "[WinError 2] The system cannot find the file specified"

The tool cannot start OpenSCAD. KomaSCAD looks for it in the default install
folder (`C:\Program Files\OpenSCAD\` on Windows, **Applications** on
macOS) and on the *PATH*. If it is installed somewhere else, give its
location with `--openscad`, or
[add it to the PATH](install.md#optional-add-openscad-to-the-path). See
[install](install.md#2-install-openscad).

`[WinError 2]` comes from older copies of KomaSCAD, which did not look in
the default folder. Download the latest files, or add
`--openscad "C:\Program Files\OpenSCAD\openscad.com"` to the command.

### "No piece matches 'My piece'"

The name is not in the preset file. Check the spelling with
`python3 komascad.py list koma/koma.json`, which shows every saved name. A
preset you made in OpenSCAD is only in `koma/koma.json` after you save it in
the Customizer.

### The characters show as boxes, or the wrong font

The font is not installed, or OpenSCAD was open while you installed it.
Install the fonts from [fonts/](../fonts/README.md), then restart OpenSCAD.
Check with **Help → Font List**.

### `python3` is not found (Windows)

On Windows, type `py` instead of `python3`.

### The export says "Skipping existing"

The file is already there, so the tool kept it. Add `-f` to write it again.
Use `-n` first to see which files exist.

More problems with your own designs: see the troubleshooting tables in the
[user guide](user-guide.md#troubleshooting) and the
[design guide](design-guide.md#troubleshooting).

## Sharing and selling

### Can I sell pieces I print?

Yes, including pieces lettered in the bundled fonts. See
[LICENSES.md](../LICENSES.md) for the few conditions, such as not
suggesting that a font author endorses your product.

### Can I put my name on them?

Yes. You can add a signature on each piece's heel (see the
[design guide](design-guide.md#add-a-signature)), and a
[maker's mark](makers-mark.md) under the board, the stands and the box.

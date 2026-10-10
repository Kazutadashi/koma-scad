# Design guide: a piece in OpenSCAD

This guide tells you how to design one piece in the OpenSCAD Customizer. For
full sets, see the [user guide](user-guide.md). The
[parameter reference](parameters.md) gives every setting.

## Start

1. Open `shogi_piece.scad` in OpenSCAD 2021.01.
2. If you cannot see the Customizer, clear **Window → Hide Customizer**.
3. Turn on **Design → Automatic Preview**. The preview then changes when you
   change a setting. If it is off, press F5.
4. Select a preset at the top of the Customizer. You can also start from the
   default settings: they make a king.
5. Select **Show Details** at the top of the Customizer. Each setting then
   shows its description and its unit.

All lengths are in mm, before **Model Scale**, unless the description says
"after Model Scale".

## Output modes

| Output Mode | Shows | Export |
| --- | --- | --- |
| Model | The piece in its colors | F6, then STL (one color) |
| Blank | The body without text | F6, then STL |
| Inspect front, Inspect back | One face, flat. Red text is outside the safe area. | None |
| Inspect printability | Strokes too thin to print (yellow) and gaps too narrow (blue) | None |
| Inspect signature | The heel mark, flat | None |
| Inspect pawn circle | 20 outlines in a ring | None |

The Inspect modes work with F5 only.

## Shape the body

Set the size in **02 - Piece dimensions**:

- **Piece Length**: from the heel to the point.
- **Base Width**: at the heel.
- **Rear Thickness**: at the heel.
- **Tip Thickness**: at the point, before the bevel.

The front and back faces slope equally from the heel to the point. To give
each face its own slope, set **Taper Mode** to **Reference side angles**, then
set the two side angles in **10 - Advanced shape angles**.

**Bevel Width** and **Bevel Depth** cut a small chamfer on all edges. Set
either to 0 for sharp edges.

### Outline angles

The outline has five angles: two at the heel ("base"), two at the shoulders
and one at the point. They must add up: 2 × base + 2 × shoulder + tip =
540°. **Angle Mode** selects the angle that the model calculates from the
other two.

### Pawn circle

Twenty pieces with a base angle of 81° fit side by side in a closed ring.
Turn on **Pawn Circle** to make the model use 81°. Then set **Output Mode**
to **Inspect pawn circle** to see the ring. The Console shows the ring
diameters.

## Add the text

1. Type the characters in **Front Characters** and **Back Characters**. The
   first character is nearest the point. Leave **Back Characters** empty for
   a blank back.
2. Type an installed font in **Font Name**. Find the exact name in
   **Help → Font List**. Do not type quotes.
3. Set **Output Mode** to **Inspect front**. Red text is outside the safe
   area. **Protect Face Edges** cuts the red part off: it does not make the
   text smaller.
4. Change the text until no red shows. Do the same with **Inspect back**.

### Text settings

Change the text in this order: position, size, spacing, single characters,
then stroke weight.

| To | Set |
| --- | --- |
| Make all text 10% larger | **Front Text Scale** = 1.1 |
| Use a fixed text size | **Front Font Size** above 0 (0 = automatic) |
| Make the text wider, with the same height | **Front Width Scale** = 1.1 |
| Make only the first character larger | **Front Glyph Size** = [1.1, 1, 1] |
| Make only the second character taller | **Front Glyph Height** = [1, 1.1, 1] |
| Move the second character 0.5 mm toward the heel | **Front Glyph Y** = [0, -0.5, 0] |
| Move all text toward the point | **Front Text Y** above 0, or a larger **Front Center Fraction** |
| Put more space between characters | **Front Spacing Scale** above 1, or **Front Character Spacing** above 0 |
| Turn one character | **Front Glyph Rotation** = [2, 0, 0] |
| Make the strokes thicker | **Front Stroke Expansion** above 0 |
| Use another font on one face | **Front Font Override** or **Back Font Override** |
| Remove the text from a face | **Front Text Style** = None |

The back has the same settings. Each list has three values: the first,
second and third character, from the point. X is always to the right as you
look at that face. Y is always toward the point. Do not mirror the back text:
the model turns it for you.

Font size is the typographic size. It is not the height of the glyph that you
see. Fonts of the same size can look very different.

**Stroke Expansion** makes every stroke wider by that many mm on each side. It
also makes the spaces between strokes narrower. Check the result with
**Inspect printability**.

### Mirror Front Settings

Turn on **Mirror Front Settings** to use the front layout on the back. The
back then uses the front text size, spacing, position, per-character
settings, text style, depth and stroke expansion. The back characters and
color stay separate. The back settings stay saved: turn the option off to use
them again.

Automatic text size still depends on the number of characters on each face.
For the same size on both faces, set **Front Font Size** above 0.

## Choose the colors

In **07 - Filament colors**, select a color for the body, the front text and
the back text. The preview shows them.

- The colors name the materials in the color 3MF. The slicer shows these
  names.
- **Same as body** and **Same as front** use the same material as that part.
- **Filament 1**, **2** and **3** are names for any filament.
- **Custom** uses the color in **11 - Inspection and quality**.
- Metallic and glitter finishes come from the filament. The 3MF only gives a
  flat color.

### How the text gets its color

**Text Color Treatment** in **08 - Engraving and stroke weight** selects how
the color part fills the text:

| Treatment | Result |
| --- | --- |
| Face only | The groove floor has the text color. The groove walls have the body color. |
| Painted grooves | The groove floor and walls have the text color. |
| Flush filled | The text color fills the groove, level with the face. The bundled sets use this. |

The color part continues 0.8 mm into the piece behind the visible surface. A
0.4 mm nozzle cannot print a thinner part. This does not change the outside
shape or the groove depth.

**Raised** text stands up from the face. Use **Face only** or **Painted
grooves** with it. Raised text cannot be on the face that touches the bed.

## Add a signature

Put a maker's mark on the heel (the wide bottom edge):

1. Open **12 - Maker signature on heel**.
2. Turn on **Signature Enabled**.
3. Type the mark in **Signature Text**.
4. Set **Output Mode** to **Inspect signature**. Red text is outside the safe
   area. Make it smaller, or move it.

The mark reads left to right when you look at the heel with the front up. It
uses **Font Name** unless you set **Signature Font**. **Signature Filament**
selects its color. When the piece stands on its heel to print, the mark is on
the bed. Check its first layers in the slicer.

## Export

### One color: STL

1. Set **Output Mode** to **Model**.
2. Select the **Print Orientation**.
3. Press F6. A large piece can take some minutes.
4. Select **File → Export → Export as STL**.

### Several colors: 3MF

1. Save your settings as a preset: select **+** and type a name.
2. Open a terminal in the repository folder.
3. Export the preset:

   ```bash
   python3 komascad.py export shogi_piece.json "My piece" --orientation front-down
   ```

4. Open `exports/shogi_piece/My piece.3mf` in your slicer. See the
   [print guide](printing/print-guide.md).

The exporter reads saved presets only. Save your changes before you export.

> **WARNING:** Do not use **File → Export → Export as 3MF** for a color
> piece. OpenSCAD 2021.01 puts all colors into one part.

### Share a preset

`komascad.py build` writes `shogi_piece.json` again. The build stops if the
file has presets that are not in the piece files. To keep your own presets
apart, copy `shogi_piece.json` to a new file and save your presets there.

When you share a preset, also give the KomaSCAD version and the font name.
Keep `"fileFormatVersion": "1"` in the file.

## Troubleshooting

| Problem | Do this |
| --- | --- |
| The preview is empty | Turn on **Design → Automatic Preview**, then select the preset again. Use **View → View All**. |
| The characters are boxes, or the font is wrong | Make sure that the font name is the same as in **Help → Font List**. Restart OpenSCAD after you install a font. |
| Text is red in Inspect front or back | Make the text smaller, or move it. |
| The strokes are too heavy | Decrease **Stroke Expansion**. |
| The back settings do nothing | Turn off **Mirror Front Settings**. |
| Pawn Circle stops the model | Read the Console. The base angle must be 81°. |
| A diagram "runs off the face" | See [movement diagrams](move-diagrams.md#when-a-diagram-does-not-fit). |
| F6 shows a CGAL error | Keep the preset and the full Console output. Report it as [CONTRIBUTING.md](../CONTRIBUTING.md) tells you. |
| The preview is slow | Set **Text Curve Resolution** to 24 while you work. Set it to 48 or more before you export. |

## Limits

- The model uses installed fonts. It cannot use drawn calligraphy files.
- Automatic text size is an estimate. It does not measure the glyphs.
- A closed mesh does not guarantee that thin strokes print. Check the
  slicer preview, and print one piece before a set.

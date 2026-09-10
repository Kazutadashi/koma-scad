# Model parameters

Open `shogi_piece.scad` in OpenSCAD and edit the Customizer controls. Dimensions are millimeters before `model_scale`; angles are degrees.

## Body and scale

`category` selects a size profile. Choose `Custom` to use `piece_length`, `base_width`, and `rear_thickness` directly. The console reports the resolved body dimensions. Size profiles are listed in [the preset guide](../PRESETS.md).

`model_scale` multiplies the complete model, including lettering and depth. It does not increase print resolution. Choose the final dimensions in OpenSCAD before painting the model in the slicer.

`bezel_width` controls the in-plane edge bevel width; `bezel_depth` controls the rim drop. Setting either to zero gives a square-edged body.

The five angle controls change the outline and the two inscription-face slopes. The symmetric pentagon requires `2*face_base_angle + 2*face_shoulder_angle + face_tip_angle = 540`. `angle_mode` can validate those values or derive one angle. The default angles already form a valid piece.

## Inscriptions

| Parameter | Purpose |
| --- | --- |
| `front_characters`, `back_characters` | Vertically stacked text; an empty string leaves the face blank |
| `font_name` | Installed font family, optionally including a style |
| `auto_text_layout` | Fits a conservative text stack to the body |
| `front_font_size`, `back_font_size` | Manual character size |
| `front_character_spacing`, `back_character_spacing` | Manual distance between character centers |
| `front_text_center`, `back_text_center` | Manual stack center measured from the broad base |
| `front_text_x`, `back_text_x` | Manual sideways offset |
| `stroke_expansion` | Expands strokes; too much can close small openings |

Automatic layout overrides the manual size, spacing, center, and sideways offset. Check both faces after selecting a font. Text can cross the rim; raised lettering must overlap the body to remain attached.

## Text relief

| Parameter | Purpose |
| --- | --- |
| `front_text_style`, `back_text_style` | `Recessed` or `Raised` per face |
| `front_engraving_depth`, `back_engraving_depth` | Perpendicular recess depth or raised height; 0 disables relief on that face |
| `text_edge_radius` | 0 for sharp edges; positive values round raised tops, recessed bottoms, and outline corners |
| `text_curve_resolution` | Glyph curve resolution, 16–128 |
| `text_rounding_steps` | Number of thin layers approximating rounding, 2–12 |

The depth parameter names also apply to raised text. Recessed text removes material; raised text adds material. The model checks that recesses leave material between the two faces. Deep engraving may require a thicker body.

Rounding uses 2D offsets and overlapping extrusions. At radius 0.10 mm and 6 steps, the approximate curved profile has steps about 0.017 mm tall before scaling. Increase the step count if stepping is visible on a large display piece. Radius is capped at half the selected depth or height. Fine strokes narrower than twice the radius may disappear, so start small.

Recessed groove mouths are not filleted into the surrounding face. Set radius to 0 to skip rounding entirely and use the simplest export geometry.

## Output and orientation

- `Printable engraved`: the printable model, including whichever recessed/raised styles you selected. The option name is retained for preset compatibility.
- `Printable blank`: the body alone.
- `Clean inspection`: floating colored decals for text placement only. It does not preview actual depth or rounding and is not a printable relief model.

`Upright` puts the broad rear edge on the build plate. `Design coordinates` preserves the modeling coordinates; it does not make a sloped inscription face bed-flat.

`body_colour`, `inscription_colour`, and the inspection-decal controls affect visualization. STL exports do not preserve filament assignments. Assign those in your slicer.

## Preset compatibility

The bundled presets retain their existing values. Recent text-style and rounding controls are not stored in those files, and obsolete bezel-protection keys are ignored. Check recent controls after changing presets: OpenSCAD can retain parameters omitted by a preset.

## Rendering and printing status

Local OpenSCAD 2021.01 checks cover sharp text, rounded text, raised/recessed combinations, deeper recesses with a thicker body, and zero-depth faces. Sample STLs passed closed-mesh checks. A bundled Shogi Rook preset also loaded without warnings after the text-control changes.

These checks do not establish physical print quality or web-viewer compatibility. Japanese glyph appearance and the two-filament workflow still need verification with the selected font, slicer, and printer.

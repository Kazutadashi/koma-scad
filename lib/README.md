# Shared OpenSCAD code

This folder holds OpenSCAD code that more than one module uses. Load a file
with `include <../lib/FILE.scad>` from a module folder.

| File | Contents | Used by |
| --- | --- | --- |
| `filaments.scad` | The named filaments and `filament_rgba()` | koma, ban, komadai, komabako |
| `shapes.scad` | Rounded rectangles, slabs and rings | ban, komadai, komabako |

Move code here only when a second module needs it.

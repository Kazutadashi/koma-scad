# Shared OpenSCAD code

This folder is for OpenSCAD code that more than one module uses, for example
the piece sizes that the board, the stand and the box must fit.

It is empty now. Move code here only when a second module needs it. Load a
file with `use <../lib/FILE.scad>` from a module folder.

# Changelog

All notable changes to KomaSCAD are listed here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). The version is the
`VERSION` in `komascad_lib/project.py`, which every model shares.

## [Unreleased]

The first public release will be 3.5.

### Added

- The board (`ban/`): any number of squares, as one print or as panels. Panels
  join with printed spring connectors (an M4 or #8-32 screw and nut also fit),
  T-hooks, dovetails or butterfly keys, with tongues along the seams. Lines can
  be flush or raised. Presets cover minishogi, shogi and chu shogi.
- The piece stand (`komadai/`) and the piece box (`komabako/`).
- A maker's mark for the board, the stands and the box.
- Learner pieces that show each piece's moves, and a browser-based editor for
  the movement diagrams.
- Shogi and minishogi sets in three styles (two characters, one character and
  learner), in the Yuji Syuku and LXGW WenKai Mono fonts.
- The `komascad.py` tool, with the commands `list`, `build`, `preview`,
  `check`, `export`, `set` and `ban`. It writes color 3MF files with their
  filament slots set.
- A printability check that measures the lettering against the printer's line
  width.
- A print test page and a bed consistency test.
- A Bambu Studio process profile, a print guide and a first-print walkthrough.
- A guide to the rules of shogi, with diagrams and a PDF.
- A `komascad` command (`pip install -e .`), and `python3 -m komascad_lib`.

### Changed

- Every bundled set has a 0.3 mm edge bevel, which hides elephant's foot on the
  face that prints against the bed.
- The bundled sets now export lying front face down. `--orientation` still
  overrides it.
- `export -n` shows the print orientation, and marks files that exist and will
  be skipped.
- Clear error messages when OpenSCAD cannot be found, when Python is older than
  3.10 (when run as `komascad.py`), and when the tool is installed without the
  models next to it.

Earlier versions (3.0 to 3.4) were developed before this changelog. See the git
history.

[Unreleased]: https://github.com/Kazutadashi/koma-scad/commits/main

# Release checklist

Run these from the repository root before tagging a release.

1. **Tests.** They need Python only, not OpenSCAD:

   ```bash
   python3 -m unittest discover tests
   ```

2. **Generated presets are current.** This exits with status 1 and names the
   stale files otherwise:

   ```bash
   python3 komascad.py build --check
   ```

3. **A complete set exports.** This renders every piece through OpenSCAD and
   checks each material mesh is closed before packaging it:

   ```bash
   python3 komascad.py export shogi --per-file all -o /tmp/komascad-release
   ```

4. **The set looks right.** Open the page this writes and check every face:

   ```bash
   python3 komascad.py preview shogi
   ```

5. **The 3MF loads in a slicer** as named pieces with body, front and back
   parts in their colors.

6. **Licensing.** [LICENSES.md](../LICENSES.md) covers every shipped category;
   each bundled font has its notice in `fonts/licenses/`; Taikyoku data stays
   in `data/` and `presets/misc/taikyoku.json`; any file in `models/` has the
   sidecar required by [print-file licensing](print-file-licenses.md).

7. **Version.** `VERSION` in `komascad.py` matches the revision in the first
   line of `shogi_piece.scad` and the version echo inside it.

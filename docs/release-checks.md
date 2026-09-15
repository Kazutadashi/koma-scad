# Release 3.3.1 packaging checks

- All 88 public SCAD defaults match the complete base preset.
- All relative Markdown links in the distribution resolve to included files.
- The exporter passes Python compilation.
- OpenSCAD 2021.01 rendered an STL with front/back text, linked settings, heel signature and Pawn Circle enabled.
- The same test settings exported a four-part 3MF (body/front/back/signature) through the supplied exporter. It validated the individual material meshes before packaging.
- The fresh integration test used DejaVu Sans with ASCII A/B/K to avoid relying on an installed Japanese font; bundled kanji examples retain the prior geometry checks documented in the guide.

No physical print or slicer-specific material mapping was performed as part of this packaging check. No GitHub checkout or remote was modified.

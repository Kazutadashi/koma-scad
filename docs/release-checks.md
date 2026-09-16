# Release 3.4 packaging checks

- All 92 public SCAD defaults match the complete base preset.
- All relative Markdown links in the distribution resolve to included files.
- The exporter passes Python compilation.
- Colour assembly renders the exact Print exterior once in F5 and uses surface-only colour overlays; exact closed material-volume rendering is deferred to the exporter.
- OpenSCAD 2021.01 rendered an STL with front/back text, linked settings, heel signature and Pawn Circle enabled.
- The same test settings exported a four-part 3MF (body/front/back/signature) in one cache-preserving OpenSCAD batch. It validated the individual material meshes before packaging.
- The Taikyoku Fire Demon 3MF loads through lib3mf 2.5.0, the 3MF Consortium's open-source reference implementation, with zero warnings, three mesh resources, and one component build item.
- The default Face only Fire Demon exported three closed meshes: Body, Front and Back. Their volumes summed to the Print solid within 0.000001 cubic millimetres.
- Painted grooves and Flush filled remain optional treatments; their individual material outputs passed the same closed-mesh validation.
- The fresh integration test used DejaVu Sans with ASCII A/B/K to avoid relying on an installed Japanese font; bundled kanji examples retain the prior geometry checks documented in the guide.

No physical print or slicer-specific material mapping was performed as part of this packaging check. No GitHub checkout or remote was modified.

# Release 3.4 packaging checks

- All 92 public SCAD defaults match the complete base preset.
- All relative Markdown links in the distribution resolve to included files.
- The exporter passes Python compilation.
- Print and Colour assembly use an open-face shell in F5; exact solid geometry is deferred to F6 or the exporter. Every bundled Print preset produced one body shell plus face skins, narrow walls, and floors at the selected face/signature recess depths. The only preview differences are inside 2D extrusions; there is no transformed-text 3D subtraction or union.
- OpenSCAD 2021.01 rendered an STL with front/back text, linked settings, heel signature and Pawn Circle enabled.
- The same test settings exported a four-part 3MF (body/front/back/signature) in one cache-preserving OpenSCAD batch. It validated the individual material meshes before packaging.
- The portable package assigns every part an open-standard 3MF Materials and Properties colour group as well as retaining named Core base materials. No proprietary slicer project or printer profile is embedded.
- The Taikyoku Fire Demon 3MF loads through lib3mf 2.5.0, the 3MF Consortium's open-source reference implementation, with zero warnings, three mesh resources, and one component build item.
- Core material swatches and Materials and Properties colour groups store explicit opaque alpha. F3D 3.5.0 renders the Fire Demon package visibly, and Assimp 6.0 imports all three colours with alpha 1.0.
- The default Face only Fire Demon exported three closed meshes: Body, Front and Back. Their volumes summed to the Print solid within 0.000002 cubic millimetres.
- The detailed Right Eagle preset prepared its Colour assembly CSG in 0.05 seconds and exported a four-part Face only 3MF in 39.6 seconds on OpenSCAD 2021.01. Its material volumes summed to Print within 0.000003 cubic millimetres; lib3mf reported zero warnings and Assimp imported all four meshes.
- Painted grooves and Flush filled remain optional treatments; their individual material outputs passed the same closed-mesh validation.
- The fresh integration test used DejaVu Sans with ASCII A/B/K to avoid relying on an installed Japanese font; bundled kanji examples retain the prior geometry checks documented in the guide.

No physical print or physical-spool mapping was performed as part of this packaging check. No GitHub checkout or remote was modified.

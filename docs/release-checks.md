# Release 3.4 packaging checks

- LICENSES.md maps every shipped code, data, font, image, preset, and print-file
  category to its license. All bundled font binaries have their upstream OFL
  notice in fonts/licenses/.
- Wikipedia-derived Taikyoku data and presets are isolated under CC BY-SA 4.0;
  the main shogi_piece.json contains no Taikyoku inscription data.
- Every intentionally released STL or 3MF belongs in models/ and has the
  sidecar required by [print-file licensing](print-file-licenses.md).
- Preview images are declared original project renders in images/NOTICE.md.
- All 89 public SCAD defaults match the complete base preset.
- All relative Markdown links in the distribution resolve to included files.
- The exporter passes Python compilation.
- Model combines geometry and selected materials in one open-face F5 preview; exact solid geometry is deferred to F6 or the exporter. Every bundled Model preset produced one body shell plus face skins, narrow walls, and material-coloured floors at the selected face/signature recess depths. The only preview differences are inside 2D extrusions; there is no transformed-text 3D subtraction or union.
- OpenSCAD 2021.01 rendered an STL with front/back text, linked settings, heel signature and Pawn Circle enabled.
- The same test settings exported a four-part 3MF (body/front/back/signature) in one cache-preserving OpenSCAD batch. It validated the individual material meshes before packaging.
- The portable package assigns every part an open-standard 3MF Materials and Properties colour group as well as retaining named Core base materials. No proprietary slicer project or printer profile is embedded.
- The Taikyoku Fire Demon 3MF loads through lib3mf 2.5.0, the 3MF Consortium's open-source reference implementation, with zero warnings, three mesh resources, and one component build item.
- Core material swatches and Materials and Properties colour groups store explicit opaque alpha. F3D 3.5.0 renders the Fire Demon package visibly, and Assimp 6.0 imports all three colours with alpha 1.0.
- The default Face only Fire Demon exported three closed meshes: Body, Front and Back. Front/back backing measured 0.800001 mm along the face normals, and volumes summed to Model within 0.000002 cubic millimetres.
- The detailed Right Eagle exported a four-part Face only 3MF in 53 seconds on OpenSCAD 2021.01. Its signature backing measured 0.800000 mm in build Z, and material volumes summed to Model within 0.000003 cubic millimetres.
- A secondary interoperability check loaded the standards-based Fire Demon file into Bambu Studio 2.8.2.61's CLI with its ordinary A1 0.4 mm / 0.20 mm profile and generated 157 layers of G-code successfully. This test added no Bambu configuration to the source 3MF; physical slot mapping was intentionally outside its scope.
- Painted grooves and Flush filled remain optional treatments; their individual material outputs passed the same closed-mesh validation.
- The fresh integration test used DejaVu Sans with ASCII A/B/K to avoid relying on an installed Japanese font; bundled kanji examples retain the prior geometry checks documented in the guide.

No physical print or physical-spool mapping was performed as part of this packaging check. No GitHub checkout or remote was modified.

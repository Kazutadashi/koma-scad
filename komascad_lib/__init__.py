"""KomaSCAD: build, check, preview and export 3D-printable shogi pieces and boards.

Run the tool with ``python3 komascad.py`` from the repository folder, with
``python3 -m komascad_lib``, or, after ``pip install -e .``, with ``komascad``.
The modules are:

    project           where the project's files are, the version, and KomaError
    presets           building game presets from the piece files; finding and reading presets
    print_test_page   the fixed reference print
    openscad          running OpenSCAD: preset values, rendered parts, STL reading
    printability      measuring lettering that is too fine to print
    threemf           writing multipart color 3MF files
    export            planning and writing an export
    preview           the HTML preview page
    ban               the board: its panels, 3MF files and manifest
    cli               the commands and their options
"""

from .project import VERSION

__all__ = ["VERSION"]

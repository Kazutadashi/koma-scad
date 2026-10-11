"""KomaSCAD: build, check, preview and export 3D-printable shogi pieces.

Run the tool with ``python3 komascad.py``. The modules are:

    project           where the project's files are, the version, and KomaError
    presets           building game presets from the piece files; finding and reading presets
    print_test_page   the fixed reference print
    openscad          running OpenSCAD: preset values, rendered parts, STL reading
    printability      measuring lettering that is too fine to print
    threemf           writing multipart color 3MF files
    export            planning and writing an export
    preview           the HTML preview page
    cli               the commands and their options
"""

from .project import VERSION

__all__ = ["VERSION"]

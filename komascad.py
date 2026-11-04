#!/usr/bin/env python3
"""KomaSCAD command-line tool. Run it with --help, or COMMAND --help.

Python 3.10 or later, standard library only. preview, check, export and ban
also need OpenSCAD (tested with 2021.01), on the PATH or given with --openscad.
The code is in komascad_lib/. Installation: docs/install.md.
"""

import sys

# Checked before the import, so that an old Python gets this message instead of
# a syntax error from the code in komascad_lib/.
MINIMUM_PYTHON = (3, 10)
if sys.version_info < MINIMUM_PYTHON:
    sys.exit("KomaSCAD needs Python 3.10 or later; this is Python " + sys.version.split()[0])

from komascad_lib.cli import main  # noqa: E402

if __name__ == "__main__":
    sys.exit(main())

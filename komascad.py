#!/usr/bin/env python3
"""KomaSCAD command-line tool. Run it with --help, or COMMAND --help.

Python 3.10 or later, standard library only. preview, check, export and ban
also need OpenSCAD 2021.01 or later on the PATH. The code is in komascad_lib/.
"""

import sys

from komascad_lib.cli import main

if __name__ == "__main__":
    sys.exit(main())

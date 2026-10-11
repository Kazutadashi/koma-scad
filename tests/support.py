"""Shared helpers for the tests."""

import contextlib
import io

from komascad_lib import cli
from komascad_lib.openscad import Part

TRIANGLE = [(0.0, 0.0, 0.0), (10.0, 0.0, 0.0), (0.0, 10.0, 0.0)]


def part(role="body", material="PLA", rgba=(0.0, 0.0, 0.0, 1.0)):
    """A one-triangle part: enough to package, without rendering."""
    return Part(role, material, rgba, TRIANGLE, [(0, 1, 2)])


PARTS = [part()]


def run(*arguments):
    """Run one command quietly. Returns (exit status, stdout, stderr)."""
    out, err = io.StringIO(), io.StringIO()
    with contextlib.redirect_stdout(out), contextlib.redirect_stderr(err):
        status = cli.main([str(argument) for argument in arguments])
    return status, out.getvalue(), err.getvalue()

"""Measure lettering that is too fine to print.

For each face, the model draws three 2D layers (Output_Mode "Printability
<face> <layer>"):

    ink    the lettering itself
    thin   the parts of strokes that are thinner than one printed line
    gaps   the parts of gaps that are narrower than one printed line

The area of each layer, as a share of the ink, is compared with the limits below.
"""

from __future__ import annotations

import functools
import os
import re
import tempfile
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from . import openscad
from .project import SCAD, KomaError

# The limits, in percent of the lettering. The bundled shogi and minishogi
# sets, which print cleanly, measure at most 1.4% thin strokes and 2.4% narrow
# gaps; the limits leave room above them.
THIN_LIMIT = 2.5
GAP_LIMIT = 5.0

# How much of OpenSCAD's output an error message shows.
LOG_TAIL = 4000

PERCENT = 100

# face -> (thin strokes %, narrow gaps %)
Measurement = dict[str, tuple[float, float]]

# A number in an SVG path, such as "-1.5" or "2e-05".
_NUMBER = r"(-?[\d.]+(?:e-?\d+)?)"


def svg_area(path: Path) -> float:
    """Measures the filled area of an OpenSCAD 2D SVG export.

    Args:
        path: The SVG file. OpenSCAD writes no file for an empty layer, so a
            missing file has no area.

    Returns:
        The area in mm²: outlines minus holes.
    """
    if not path.exists():
        return 0.0

    total = 0.0
    svg = path.read_text(encoding="utf-8")
    for path_data in re.findall(r'\bd="([^"]*)"', svg):
        # Each "M" (move to) starts a new closed outline.
        for outline in re.split(r"[Mm]", path_data)[1:]:
            pairs = re.findall(_NUMBER + "[ ,]" + _NUMBER, outline)
            points = [(float(x), float(y)) for x, y in pairs]
            if len(points) > 2:
                total += _signed_area(points)
    return abs(total)


def _signed_area(points: list[tuple[float, float]]) -> float:
    """Measures the area inside a closed outline (the shoelace formula).

    Args:
        points: The corners of the outline, in order.

    Returns:
        The area. Its sign follows the winding, so holes, which wind the other
        way, subtract from the outlines around them.
    """
    following = points[1:] + points[:1]
    # Each edge adds the area of the triangle it makes with the origin (doubled).
    # sum() adds floats more accurately than a plain loop.
    twice_area = sum(
        x1 * y2 - x2 * y1 for (x1, y1), (x2, y2) in zip(points, following, strict=True)
    )
    return twice_area / 2


def check_printability(executable: str, definitions: list[str]) -> Measurement:
    """Measures each face of one piece that carries characters.

    Args:
        executable: The OpenSCAD program.
        definitions: The -D arguments of the piece.

    Returns:
        For each face with characters: the percentage of thin strokes and of
        narrow gaps.

    Raises:
        KomaError: OpenSCAD cannot draw the lettering.
    """
    result = {}
    with tempfile.TemporaryDirectory(prefix="komascad-") as temporary:
        for face in ("front", "back"):
            areas = {}
            for layer in ("ink", "thin", "gaps"):
                output = Path(temporary) / f"{face}-{layer}.svg"
                mode = f'Output_Mode="Printability {face} {layer}"'
                command = [executable, "-o", str(output)] + definitions + ["-D", mode, str(SCAD)]

                status, log = openscad.run_openscad(command)
                # An empty layer is the good case. An error is not: the piece itself is invalid.
                if "ERROR:" in log:
                    raise KomaError("OpenSCAD could not draw the lettering:\n" + log[-LOG_TAIL:])
                areas[layer] = svg_area(output)

            if areas["ink"] > 0:
                thin_percent = PERCENT * areas["thin"] / areas["ink"]
                gap_percent = PERCENT * areas["gaps"] / areas["ink"]
                result[face] = (thin_percent, gap_percent)
    return result


def printability_problems(measured: Measurement) -> list[str]:
    """Describes the faces that are over the limits.

    Args:
        measured: The result of check_printability().

    Returns:
        One line for each face over a limit. Empty when the piece passes.
    """
    problems = []
    for face, (thin, gaps) in measured.items():
        if thin <= THIN_LIMIT and gaps <= GAP_LIMIT:
            continue
        thin_text = f"{thin:.1f}% of strokes thinner than a printed line (limit {THIN_LIMIT:.1f}%)"
        gaps_text = f"{gaps:.1f}% narrow gaps (limit {GAP_LIMIT:.1f}%)"
        problems.append(f"{face}: {thin_text}, {gaps_text}")
    return problems


def measure_presets(
    executable: str, presets: dict[str, dict], names: list[str], overrides: dict
) -> dict[str, Measurement]:
    """Measures many presets at the same time.

    The 2D layers are light to draw, so this uses every processor core.

    Args:
        executable: The OpenSCAD program.
        presets: The settings of each preset, by name.
        names: The presets to measure.
        overrides: Settings that replace the saved ones in every preset.

    Returns:
        The measurement of each preset, by name.
    """
    definitions = [openscad.scad_definitions(name, presets[name], overrides) for name in names]
    measure = functools.partial(check_printability, executable)
    workers = os.cpu_count() or 1

    with ThreadPoolExecutor(max_workers=workers) as pool:
        measured = list(pool.map(measure, definitions))
    return dict(zip(names, measured, strict=True))

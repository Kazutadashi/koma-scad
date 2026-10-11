"""Render every piece of a preset file, front and back, onto one HTML page."""

from __future__ import annotations

import functools
import html
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from . import openscad
from .project import SCAD, KomaError

# OpenSCAD cameras that look straight at each face, with orthographic
# projection. The same distance for every piece gives every piece one scale.
# Each is "x,y,z,rotate x,rotate y,rotate z,distance" for --camera.
VIEWS = {
    "front": "0,0,16,90,0,0,120",
    "back": "0,0,16,90,0,180,120",
}
IMAGE_SIZE = "360,400"  # width,height in pixels

STYLE = """
    body { font-family: sans-serif; margin: 16px; background: #fffde7; }
    main { display: flex; flex-wrap: wrap; gap: 8px; }
    figure { margin: 0; text-align: center; }
    img { display: block; width: 180px; }
    figcaption { font-size: 13px; padding: 4px; }
"""


def page_html(title: str, figures: str) -> str:
    """Makes the preview page.

    Args:
        title: The page title, already HTML-escaped.
        figures: One <figure> for each piece.

    Returns:
        The page.
    """
    head = f'<!doctype html><meta charset="utf-8"><title>{title}</title><style>{STYLE}</style>'
    note = "<p>Front above, back below. All pieces share one scale.</p>"
    return f"{head}<h1>{title}</h1>{note}<main>{figures}</main>"


def figure_html(number: int, name: str) -> str:
    """Makes the figure of one piece: its front and back images, and its name.

    Args:
        number: The place of the piece in the file, from 1. It names the images.
        name: The preset name.

    Returns:
        The <figure> element.
    """
    front = f'<img src="{number:02d}-front.png" alt="">'
    back = f'<img src="{number:02d}-back.png" alt="">'
    caption = f"<figcaption>{html.escape(name)}</figcaption>"
    return f"<figure>{front}{back}{caption}</figure>"


def _render_view(executable: str, preset_file: Path, job: tuple[str, str, Path]) -> str | None:
    """Renders one face of one preset to a PNG.

    Args:
        executable: The OpenSCAD program.
        preset_file: The preset file.
        job: (preset name, "front" or "back", the image to write).

    Returns:
        An error message, or None when the image was made.
    """
    name, view, image = job
    command = [executable, "-o", str(image)]
    command += ["--imgsize=" + IMAGE_SIZE, "--projection=o", "--camera=" + VIEWS[view]]
    command += ["-p", str(preset_file), "-P", name, str(SCAD)]

    status, log = openscad.run_openscad(command)
    if status == 0 and image.exists():
        return None

    output_lines = log.strip().splitlines()
    last_line = output_lines[-1] if output_lines else "no output"
    return f"{name} ({view}): {last_line}"


def write_preview(executable: str, preset_file: Path, names: list[str], folder: Path) -> Path:
    """Renders the named presets and writes the preview page.

    Args:
        executable: The OpenSCAD program.
        preset_file: The preset file.
        names: The presets to show, in order.
        folder: The folder for the images and index.html. It is made if needed.

    Returns:
        The path of index.html.

    Raises:
        KomaError: OpenSCAD could not render one or more views.
    """
    folder.mkdir(parents=True, exist_ok=True)

    jobs = []
    for number, name in enumerate(names, start=1):
        for view in VIEWS:
            jobs.append((name, view, folder / f"{number:02d}-{view}.png"))

    render = functools.partial(_render_view, executable, preset_file)
    with ThreadPoolExecutor() as pool:
        results = list(pool.map(render, jobs))

    errors = [error for error in results if error]
    if errors:
        raise KomaError("Render failed:\n  " + "\n  ".join(errors))

    figures = "".join(figure_html(number, name) for number, name in enumerate(names, start=1))
    page = folder / "index.html"
    page.write_text(page_html(html.escape(preset_file.stem), figures), encoding="utf-8")
    return page

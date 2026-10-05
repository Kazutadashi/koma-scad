#!/usr/bin/env python3
"""Render every piece of one game, front and back, onto a single preview page.

Python 3.8+; standard library only. Needs OpenSCAD on PATH.

The Customizer shows one preset at a time. This renders each preset of a game
file at the same scale and writes an HTML page showing them side by side, so
a whole set can be checked before exporting 3MF files.

Usage:
    python3 scripts/preview_game.py minishogi-1char
    python3 scripts/preview_game.py presets/games/shogi.json --out exports/preview

Open the printed index.html in a browser.
"""

import argparse
import html
import json
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCAD = ROOT / "shogi_piece.scad"
GAMES = ROOT / "presets" / "games"
# Orthographic views square onto each face; the distance fixes a shared scale.
VIEWS = {"front": "0,0,16,90,0,0,120", "back": "0,0,16,90,0,180,120"}
SIZE = "360,400"


def render(job):
    """Render one face of one preset to a PNG; return an error message or None."""
    preset_file, name, view, target = job
    result = subprocess.run(
        ["openscad", "-o", str(target), "--imgsize=" + SIZE, "--projection=o",
         "--camera=" + VIEWS[view], "-p", str(preset_file), "-P", name, str(SCAD)],
        capture_output=True, text=True,
    )
    if result.returncode != 0 or not target.exists():
        return "%s (%s): %s" % (name, view, result.stderr.strip().splitlines()[-1:] or "no output")
    return None


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("game", help="game name in presets/games (e.g. minishogi-1char) or a preset JSON path")
    parser.add_argument("--out", type=Path, default=None,
                        help="output folder (default: exports/preview/<game>)")
    args = parser.parse_args()

    preset_file = Path(args.game)
    if not preset_file.exists():
        preset_file = GAMES / (args.game + ".json")
    if not preset_file.exists():
        available = ", ".join(sorted(path.stem for path in GAMES.glob("*.json")))
        sys.exit("Unknown game %r. Available: %s" % (args.game, available))
    preset_file = preset_file.resolve()
    names = list(json.loads(preset_file.read_text(encoding="utf-8"))["parameterSets"])
    out = (args.out or ROOT / "exports" / "preview" / preset_file.stem).resolve()
    out.mkdir(parents=True, exist_ok=True)

    jobs = [(preset_file, name, view, out / ("%02d-%s.png" % (index, view)))
            for index, name in enumerate(names, 1) for view in VIEWS]
    print("Rendering %d pieces from %s ..." % (len(names), preset_file.name), flush=True)
    with ThreadPoolExecutor() as pool:
        errors = [error for error in pool.map(render, jobs) if error]
    if errors:
        sys.exit("Render failed:\n  " + "\n  ".join(errors))

    cells = "".join(
        '<figure><img src="%02d-front.png" alt=""><img src="%02d-back.png" alt="">'
        "<figcaption>%s</figcaption></figure>" % (index, index, html.escape(name))
        for index, name in enumerate(names, 1)
    )
    page = (
        '<!doctype html><meta charset="utf-8"><title>%s</title>'
        "<style>body{font-family:sans-serif;margin:16px;background:#fffde7}"
        "main{display:flex;flex-wrap:wrap;gap:8px}figure{margin:0;text-align:center}"
        "img{display:block;width:180px}figcaption{font-size:13px;padding:4px}</style>"
        "<h1>%s</h1><p>Front above, back below. All pieces share one scale.</p><main>%s</main>"
    ) % (html.escape(preset_file.stem), html.escape(preset_file.stem), cells)
    index = out / "index.html"
    index.write_text(page, encoding="utf-8")
    print("Preview: " + str(index))


if __name__ == "__main__":
    main()

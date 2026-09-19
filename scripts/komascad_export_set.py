#!/usr/bin/env python3
"""Export many KomaSCAD presets as a print-ready folder of 3MF files.

This script deliberately delegates every piece to ``komascad_export.py``.
It selects presets, gives their files stable names, and publishes the set as a
folder only after all individual exports succeed. It does not reproduce any
geometry, mesh, material, or 3MF logic from the single-piece exporter.

Examples:
    Export every preset from the Taikyoku collection::

        python3 scripts/komascad_export_set.py \\
            --parameters presets/taikyoku.json \\
            --set-name "Taikyoku Shogi"

    Export only the Professional King grid-search presets::

        python3 scripts/komascad_export_set.py \\
            --parameters shogi_piece.json \\
            --include "King - Professional Grid *" \\
            --set-name "Professional King Grid Search"

    Preview an explicit two-piece set without invoking OpenSCAD::

        python3 scripts/komascad_export_set.py \\
            --preset "00 Base - King" \\
            --preset "King - Professional Yuji Syuku" \\
            --set-name "Small Test Set" \\
            --dry-run
"""

import argparse
import fnmatch
import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence


@dataclass(frozen=True)
class ExportJob:
    """Describe one preset-to-file export in a batch.

    Attributes:
        preset: Exact, case-sensitive preset name from ``parameterSets``.
        filename: Filesystem-safe output filename ending in ``.3mf``.

    Examples:
        >>> job = ExportJob("30 Taikyoku - Fire Demon", "30 Taikyoku - Fire Demon.3mf")
        >>> job.filename
        '30 Taikyoku - Fire Demon.3mf'
    """

    preset: str
    filename: str


def default_target() -> Path:
    """Return the project directory containing this script's directory.

    Returns:
        The parent of ``scripts`` when installed in the repository layout.

    Examples:
        >>> default_target().is_absolute()
        True
    """
    script_directory = Path(__file__).resolve().parent
    return script_directory.parent if script_directory.name == "scripts" else script_directory


def resolve_path(path: Path, base: Path) -> Path:
    """Resolve an absolute path or a path relative to a base directory.

    Args:
        path: Absolute path or relative path supplied by the user.
        base: Directory used to resolve a relative ``path``.

    Returns:
        An absolute, normalized path.

    Examples:
        >>> resolve_path(Path("presets/set.json"), Path("/project"))
        PosixPath('/project/presets/set.json')
    """
    return (path if path.is_absolute() else base / path).resolve()


def load_parameter_sets(path: Path) -> Dict[str, object]:
    """Load the named parameter sets from an OpenSCAD preset JSON file.

    Args:
        path: JSON file containing a top-level ``parameterSets`` object.

    Returns:
        A dictionary retaining the source file's preset order.

    Raises:
        ValueError: The file is malformed or has no nonempty parameter sets.

    Examples:
        >>> import tempfile
        >>> folder = Path(tempfile.mkdtemp())
        >>> sample = folder / "sample.json"
        >>> _ = sample.write_text('{"parameterSets":{"Pawn":{}}}', encoding="utf-8")
        >>> list(load_parameter_sets(sample))
        ['Pawn']
    """
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        raise ValueError("Could not read preset JSON %s: %s" % (path, error))
    parameter_sets = document.get("parameterSets") if isinstance(document, dict) else None
    if not isinstance(parameter_sets, dict) or not parameter_sets:
        raise ValueError("Preset JSON has no nonempty parameterSets object: " + str(path))
    if not all(isinstance(name, str) and name for name in parameter_sets):
        raise ValueError("Every preset name must be a nonempty string: " + str(path))
    if not all(isinstance(values, dict) for values in parameter_sets.values()):
        raise ValueError("Every parameter set must be a JSON object: " + str(path))
    return parameter_sets


def matches_any(name: str, patterns: Sequence[str]) -> bool:
    """Return whether a name matches at least one case-sensitive glob.

    Args:
        name: Preset name to test.
        patterns: Shell-style patterns such as ``King - Grid *``.

    Returns:
        ``True`` when at least one pattern matches; otherwise ``False``.

    Examples:
        >>> matches_any("King - Grid 01", ["King - Grid *"])
        True
    """
    return any(fnmatch.fnmatchcase(name, pattern) for pattern in patterns)


def select_presets(
        available: Iterable[str], explicit: Sequence[str],
        includes: Sequence[str], excludes: Sequence[str]) -> List[str]:
    """Select ordered preset names using explicit names or glob filters.

    Explicit ``--preset`` values preserve command-line order. Otherwise,
    ``--include`` patterns filter the source JSON order, and no include pattern
    means all presets. Excludes are applied last in both modes.

    Args:
        available: Preset names in their desired source order.
        explicit: Exact preset names requested by the user.
        includes: Case-sensitive glob patterns to include.
        excludes: Case-sensitive glob patterns to remove.

    Returns:
        Selected preset names in deterministic order.

    Raises:
        ValueError: An explicit name is missing, duplicated, or selection is empty.

    Examples:
        >>> names = ["Pawn", "Grid 01", "Grid 02"]
        >>> select_presets(names, [], ["Grid *"], ["*02"])
        ['Grid 01']
    """
    ordered = list(available)
    available_names = set(ordered)
    if explicit:
        missing = [name for name in explicit if name not in available_names]
        if missing:
            raise ValueError("Unknown preset(s): " + ", ".join(missing))
        if len(set(explicit)) != len(explicit):
            raise ValueError("Each explicit --preset may be listed only once")
        selected = list(explicit)
    else:
        selected = [
            name for name in ordered
            if not includes or matches_any(name, includes)
        ]
    if excludes:
        selected = [name for name in selected if not matches_any(name, excludes)]
    if not selected:
        raise ValueError("No presets matched the requested selection")
    return selected


def safe_name(name: str) -> str:
    """Convert a human name into a safe cross-platform file component.

    Unicode letters and numbers are retained. Reserved punctuation, control
    characters, repeated whitespace, and trailing Windows separators are
    normalized without obscuring the original preset name.

    Args:
        name: Human-readable preset or set name.

    Returns:
        A safe filename component.

    Raises:
        ValueError: Normalization would produce an empty or reserved name.

    Examples:
        >>> safe_name('Chu Shogi: Lion / Kirin')
        'Chu Shogi - Lion - Kirin'
    """
    cleaned = re.sub(r'[<>:"/\\|?*\x00-\x1f]', " - ", name)
    cleaned = re.sub(r"\s+", " ", cleaned).strip(" .")
    cleaned = re.sub(r"(?:\s*-\s*){2,}", " - ", cleaned)
    reserved = {
        "con", "prn", "aux", "nul",
        *("com%d" % number for number in range(1, 10)),
        *("lpt%d" % number for number in range(1, 10)),
    }
    if not cleaned or cleaned.casefold() in reserved:
        raise ValueError("Name cannot be converted to a safe filename: " + repr(name))
    return cleaned


def plan_exports(presets: Sequence[str]) -> List[ExportJob]:
    """Create one collision-free 3MF export job per preset.

    Args:
        presets: Ordered preset names selected for the set.

    Returns:
        Export jobs whose filenames preserve the human-readable preset names.

    Raises:
        ValueError: Two preset names normalize to the same filename.

    Examples:
        >>> plan_exports(["Chu - Lion"])
        [ExportJob(preset='Chu - Lion', filename='Chu - Lion.3mf')]
    """
    jobs = [ExportJob(preset, safe_name(preset) + ".3mf") for preset in presets]
    folded_names = [job.filename.casefold() for job in jobs]
    collisions = sorted({name for name in folded_names if folded_names.count(name) > 1})
    if collisions:
        raise ValueError("Preset names produce colliding filenames: " + ", ".join(collisions))
    return jobs


def build_export_command(
        python: str, exporter: Path, target: Path, scad: Path,
        parameters: Path, openscad: str, job: ExportJob, output: Path) -> List[str]:
    """Build the single-piece exporter command for one batch job.

    Args:
        python: Python interpreter used to launch the exporter.
        exporter: Path to ``komascad_export.py``.
        target: KomaSCAD project directory.
        scad: SCAD source path.
        parameters: Preset JSON path.
        openscad: OpenSCAD executable name or path.
        job: Preset and filename being exported.
        output: Destination 3MF path for this job.

    Returns:
        Argument vector suitable for ``subprocess.run``.

    Examples:
        >>> job = ExportJob("Pawn", "Pawn.3mf")
        >>> command = build_export_command(
        ...     "python3", Path("export.py"), Path("/p"), Path("/p/a.scad"),
        ...     Path("/p/a.json"), "openscad", job, Path("/tmp/Pawn.3mf"),
        ... )
        >>> command[-4:]
        ['--output', '/tmp/Pawn.3mf', '--openscad', 'openscad']
    """
    return [
        python, str(exporter),
        "--target", str(target),
        "--scad", str(scad),
        "--parameters", str(parameters),
        "--preset", job.preset,
        "--output", str(output),
        "--openscad", openscad,
    ]


def run_export(command: Sequence[str], preset: str) -> None:
    """Run one single-piece export and turn failure into batch context.

    Args:
        command: Argument vector produced by ``build_export_command``.
        preset: Human-readable preset name used in an error message.

    Raises:
        RuntimeError: The single-piece exporter exits unsuccessfully.

    Examples:
        ``run_export([sys.executable, "scripts/komascad_export.py", ...],
        "Chu - Lion")`` delegates one piece to the existing exporter.
    """
    result = subprocess.run(command)
    if result.returncode:
        raise RuntimeError(
            "Single-piece export failed for %r with exit code %d"
            % (preset, result.returncode)
        )


def sha256_file(path: Path) -> str:
    """Calculate a SHA-256 checksum without loading a whole 3MF into memory.

    Args:
        path: File whose contents should be hashed.

    Returns:
        Lowercase hexadecimal SHA-256 digest.

    Examples:
        >>> import tempfile
        >>> sample = Path(tempfile.mkstemp()[1])
        >>> _ = sample.write_bytes(b"KomaSCAD")
        >>> len(sha256_file(sample))
        64
    """
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def write_set_manifest(
        path: Path, set_name: str, parameters: Path,
        scad: Path, jobs: Sequence[ExportJob]) -> None:
    """Write provenance, filenames, sizes, and checksums for a completed set.

    Args:
        path: Destination JSON path inside the staged set folder.
        set_name: Human-readable collection name.
        parameters: Source preset JSON path.
        scad: Source model path.
        jobs: Successfully completed exports.

    Examples:
        ``write_set_manifest(folder / "manifest.json", "Chu Shogi",
        presets, model, jobs)`` records every file delivered with the set.
    """
    files = []
    for job in jobs:
        exported = path.parent / job.filename
        files.append({
            "preset": job.preset,
            "file": job.filename,
            "bytes": exported.stat().st_size,
            "sha256": sha256_file(exported),
        })
    document = {
        "format_version": 1,
        "set_name": set_name,
        "source_parameters": str(parameters),
        "source_scad": str(scad),
        "piece_count": len(jobs),
        "files": files,
    }
    path.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def publish_set(staging: Path, destination: Path, replace: bool) -> None:
    """Publish a complete staged set folder at its final destination.

    Args:
        staging: Temporary folder containing only successful exports.
        destination: Final human-readable set folder.
        replace: Whether an existing destination may be removed.

    Raises:
        FileExistsError: The destination exists and ``replace`` is false.

    Examples:
        ``publish_set(staging, Path("exports/Chu Shogi"), False)`` performs
        a same-filesystem rename after every piece has exported successfully.
    """
    if destination.exists():
        if not replace:
            raise FileExistsError(
                "Output folder already exists; choose another --set-name or use --replace: "
                + str(destination)
            )
        if destination.is_dir():
            shutil.rmtree(destination)
        else:
            destination.unlink()
    os.replace(staging, destination)


def build_parser() -> argparse.ArgumentParser:
    """Create the command-line parser for set selection and export options.

    Returns:
        Configured argument parser.

    Examples:
        >>> parser = build_parser()
        >>> parser.parse_args(["--set-name", "Chu Shogi", "--dry-run"]).set_name
        'Chu Shogi'
    """
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--target", type=Path, default=default_target(),
                        help="KomaSCAD project directory")
    parser.add_argument("--scad", type=Path, default=Path("shogi_piece.scad"),
                        help="SCAD source, relative to --target unless absolute")
    parser.add_argument("--parameters", type=Path,
                        help="Preset JSON (default: same stem as --scad)")
    parser.add_argument("--set-name",
                        help="Output folder name (default: preset filename in title case)")
    parser.add_argument("--output-root", type=Path, default=Path("exports"),
                        help="Parent directory for the completed set folder")
    parser.add_argument("--preset", action="append", default=[],
                        help="Exact preset to export; repeat to select multiple presets")
    parser.add_argument("--include", action="append", default=[],
                        help="Case-sensitive preset glob to include; repeat as needed")
    parser.add_argument("--exclude", action="append", default=[],
                        help="Case-sensitive preset glob to exclude; repeat as needed")
    parser.add_argument("--exporter", type=Path,
                        default=Path(__file__).with_name("komascad_export.py"),
                        help="Single-piece exporter script")
    parser.add_argument("--openscad", default="openscad", help="OpenSCAD executable")
    parser.add_argument("--replace", action="store_true",
                        help="Replace an existing completed set folder after success")
    parser.add_argument("--list", action="store_true",
                        help="Print matching preset names and exit")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print planned output paths without exporting")
    return parser


def main(argv: Optional[Sequence[str]] = None) -> int:
    """Validate arguments and export the selected presets as one folder.

    Args:
        argv: Optional argument sequence; ``None`` reads ``sys.argv``.

    Returns:
        Process exit code: zero on success and nonzero on validation or export
        failure.

    Examples:
        >>> main(["--set-name", "Grid", "--include", "No such preset", "--list"])
        1
    """
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        target = args.target.resolve()
        scad = resolve_path(args.scad, target)
        parameters = (
            resolve_path(args.parameters, target)
            if args.parameters else scad.with_suffix(".json")
        )
        exporter = resolve_path(args.exporter, Path.cwd())
        if not scad.is_file():
            raise ValueError("SCAD file not found: " + str(scad))
        if not parameters.is_file():
            raise ValueError("Preset JSON not found: " + str(parameters))
        if not exporter.is_file():
            raise ValueError("Single-piece exporter not found: " + str(exporter))
        if args.preset and args.include:
            raise ValueError("Use either --preset or --include, not both")

        parameter_sets = load_parameter_sets(parameters)
        selected = select_presets(
            parameter_sets.keys(), args.preset, args.include, args.exclude,
        )
        jobs = plan_exports(selected)

        if args.list:
            for job in jobs:
                print(job.preset)
            return 0

        default_name = parameters.stem.replace("_", " ").replace("-", " ").title()
        set_name = args.set_name or default_name
        output_root = args.output_root.resolve()
        destination = output_root / safe_name(set_name)

        if args.dry_run:
            print("Set: " + set_name)
            print("Folder: " + str(destination))
            for job in jobs:
                print("  " + job.preset + " -> " + job.filename)
            return 0

        if destination.exists() and not args.replace:
            raise FileExistsError(
                "Output folder already exists; choose another --set-name or use --replace: "
                + str(destination)
            )

        output_root.mkdir(parents=True, exist_ok=True)
        staging = Path(tempfile.mkdtemp(prefix=".komascad-set-", dir=str(output_root)))
        try:
            total = len(jobs)
            for index, job in enumerate(jobs, 1):
                print("[%d/%d] Exporting %s" % (index, total, job.preset), flush=True)
                output = staging / job.filename
                command = build_export_command(
                    sys.executable, exporter, target, scad, parameters,
                    args.openscad, job, output,
                )
                run_export(command, job.preset)
                if not output.is_file():
                    raise RuntimeError(
                        "Exporter reported success but created no file for " + repr(job.preset)
                    )
            write_set_manifest(staging / "manifest.json", set_name, parameters, scad, jobs)
            publish_set(staging, destination, args.replace)
        finally:
            if staging.exists():
                shutil.rmtree(staging)

        print("Saved %d printable 3MF files to %s" % (len(jobs), destination))
        print("Set manifest: " + str(destination / "manifest.json"))
        return 0
    except (OSError, ValueError, RuntimeError) as error:
        print("Set export failed: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())

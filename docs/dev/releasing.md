# Releasing

The maintainer's checklist for a new version. A release is a git tag plus a
GitHub Release with the ready-made print files attached. Print files are
never committed to git.

## 1. Check the code

Run these from the repository folder. All must pass.

```bash
python3 -m unittest discover -t . -s tests
uvx ruff format --check
uvx ruff check
npx prettier --check .
python3 komascad.py build --check
```

Make sure OpenSCAD, `node` and the fonts are installed, so that no test is
skipped except the ones you expect.

## 2. Set the version

1. Set `VERSION` in `komascad_lib/project.py`. `pyproject.toml` reads it from
   there.
2. Set `version` in each model: `koma/koma.scad`, `ban/ban.scad`,
   `komadai/komadai.scad` and `komabako/komabako.scad`. A test checks that
   they all match.
3. In [CHANGELOG.md](../../CHANGELOG.md), rename **Unreleased** to the new
   version and date, and start a new empty **Unreleased** section.
4. Run the tests again.

## 3. Export the ready-made sets

Export each set into a clean folder. `-n` first shows what will be written:
every line must say `Front face down`, and no file may be marked as
existing.

```bash
VERSION=3.5
OUT=/tmp/komascad-release-$VERSION
for GAME in shogi-learner shogi-learner-syuku shogi shogi-wenkai shogi-1char shogi-1char-wenkai; do
    python3 komascad.py export "$GAME" --per-file all -o "$OUT/$GAME" -n
    python3 komascad.py export "$GAME" --per-file all -o "$OUT/$GAME" -j 4
done
```

Each folder now holds one `... - Layout 01.3mf` and a `manifest.json`. Rename
them for upload:

| Exported file | Release asset |
| --- | --- |
| `shogi-learner/Shogi Learner - Layout 01.3mf` | `komascad-VERSION-shogi-learner.3mf` |
| `shogi-learner-syuku/Shogi Learner Syuku - Layout 01.3mf` | `komascad-VERSION-shogi-learner-syuku.3mf` |
| `shogi/Shogi - Layout 01.3mf` | `komascad-VERSION-shogi.3mf` |
| `shogi-wenkai/Shogi Wenkai - Layout 01.3mf` | `komascad-VERSION-shogi-wenkai.3mf` |
| `shogi-1char/Shogi 1Char - Layout 01.3mf` | `komascad-VERSION-shogi-1char.3mf` |
| `shogi-1char-wenkai/Shogi 1Char Wenkai - Layout 01.3mf` | `komascad-VERSION-shogi-1char-wenkai.3mf` |
| each `manifest.json` | `komascad-VERSION-GAME.manifest.json` |

The exported names come from the game name, title-cased (`--name` sets
another). The `-n` line shows each one.

Also make the licenses archive, `komascad-VERSION-licenses.zip`, with
`LICENSE`, `LICENSES.md`, `LICENSES/` and `fonts/licenses/`.

<!-- TODO(release): consider also attaching a one-color STL set (for printers
     without multi-color; see docs/faq.md) and a two-file `--per-file 20`
     version of each set for beds smaller than 242 x 228 mm. Measure the
     two-file layouts before promising a bed size. -->

## 4. Test the files in a slicer

For each set:

1. Open the 3MF in Bambu Studio. Each piece must be one object, with its
   **Body**, **Front** and (where it promotes) **Back** parts on filaments 1,
   2 and 3.
2. The pieces lie face down and fit one plate.
3. Slice with the KomaSCAD profile. On layer 1, look for missing strokes.
4. Note the print time and the grams of each filament for the release notes,
   with the printer and profile they are for.

For at least the Learner set, print one king and one pawn, and check the
face.

## 5. Export the board (optional asset)

```bash
python3 komascad.py ban "Shogi - 2 x 2 panels" -o "$OUT/ban"
```

Open `... - Whole board.3mf` in the slicer, and check that it lines up with
the bed. Attach it as `komascad-VERSION-ban-2x2.3mf` only after a printed
board has passed the joint tests in the [board guide](../ban.md#print).

## 6. Publish

1. Commit, and tag the commit `vVERSION` (for example `v3.5`).
2. Create a GitHub Release from the tag, titled `KomaSCAD VERSION`.
3. Attach the assets from step 3.
4. Paste the release notes: the changelog section, then this table:

   ```markdown
   | File | Set | Font |
   | --- | --- | --- |
   | komascad-VERSION-shogi-learner.3mf | Learner (best for beginners) | LXGW WenKai Mono |
   | komascad-VERSION-shogi-learner-syuku.3mf | Learner, brush font | Yuji Syuku |
   | komascad-VERSION-shogi.3mf | Classic, two characters | Yuji Syuku |
   | komascad-VERSION-shogi-wenkai.3mf | Classic, two characters | LXGW WenKai Mono |
   | komascad-VERSION-shogi-1char.3mf | One character | Yuji Syuku |
   | komascad-VERSION-shogi-1char-wenkai.3mf | One character | LXGW WenKai Mono |

   Each file: 40 pieces on one plate (about 242 × 228 mm), face down, PLA.
   Filament 1 wood (body), 2 black (front), 3 red (promoted side).
   How to print: https://github.com/Kazutadashi/koma-scad/blob/main/docs/print/first-print.md
   ```

5. Open the Releases page logged out, and check that the README's "Get a
   set" link reaches the release and its files.

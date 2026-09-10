# Taikyoku Shogi Character Data — Attribution and License

`taikyoku_piece_characters.csv` is an adapted, machine-readable transcription of the Taikyoku shogi piece table from English Wikipedia.

## Source

- Article: **Taikyoku shogi**
- Source URL: https://en.wikipedia.org/wiki/Taikyoku_shogi
- Page history / contributors: https://en.wikipedia.org/w/index.php?title=Taikyoku_shogi&action=history
- Accessed: **2026-09-10**

## Changes made

The source table was transformed for use by the 3D-printing project:

- Kept the English piece name and front inscription.
- Kept the promotion target and promoted/back inscription.
- Omitted the romanization columns because they are not required to generate engraved geometry.
- Converted Wikipedia's leading `*` marker for promotion-only forms into the Boolean `promotion_only_target` field.
- Stored the two king inscriptions as `front_characters` and `alternate_front_characters` in one row.
- Preserved left/right entries where the source distinguishes them.
- Added short rendering notes for rare glyphs.
- Represented nonstandard historical characters described by Wikipedia through Ideographic Description Sequences (IDS) instead of replacing them with unverified modern glyphs.
- Reordered and renamed fields for machine-readable use.

No claim is made that Wikipedia is the only historical authority for Taikyoku shogi. The CSV records the cited Wikipedia table so that the project's engraving inputs are explicit, reproducible, and attributable.

## License

Wikipedia text is available under the **Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)**, subject to the applicable Wikipedia/Wikimedia terms.

This adapted CSV is distributed under **CC BY-SA 4.0**.

License: https://creativecommons.org/licenses/by-sa/4.0/

When redistributing or adapting this dataset, retain appropriate attribution, indicate changes, link to the license, and distribute adaptations under the same or a compatible ShareAlike license as required by CC BY-SA 4.0.

The MIT license in the repository root applies to the project's own code and original documentation; it does **not** replace the CC BY-SA 4.0 terms for this Wikipedia-derived dataset.

## Generated preset adaptations

`../presets/taikyoku.json` and `../shogi_piece.json` include this adapted character data and are distributed under CC BY-SA 4.0. Preset names normalize hyphens and capitalization; IDS entries are omitted. Size assignments and typography are new project defaults, not source measurements.

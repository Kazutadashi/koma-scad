"""Rebuild bundled OpenSCAD presets. Python 3; no dependencies.
Generated Taikyoku inscriptions retain data/ATTRIBUTION.md's CC BY-SA 4.0 terms.
"""
from pathlib import Path
import csv, json, re
ROOT = Path(__file__).resolve().parents[1]

def main():
    source = (ROOT / "shogi_piece.scad").read_text().split("/* [Hidden] */")[0]
    defaults = dict(re.findall(r'^([a-z_]+) = (.*?);', source, re.M))
    defaults = {k: v[1:-1] if v.startswith('"') else v for k,v in defaults.items()}
    def preset(category, front, back):
        return dict(defaults, category=category, front_characters=front,
                    back_characters=back, auto_text_layout="true", font_name="Noto Sans CJK JP")
    def write(path, sets):
        path.write_text(json.dumps({"parameterSets":sets,"fileFormatVersion":"1"},ensure_ascii=False,indent=2)+"\n")
    shogi = {}
    for name, front, back in [
        ("Pawn","歩兵","と"), ("Lance","香車","成香"), ("Knight","桂馬","成桂"),
        ("Silver","銀将","成銀"), ("Gold","金将",""), ("Bishop","角行","龍馬"),
        ("Rook","飛車","龍王"), ("King","王将","")]:
        shogi["Shogi " + name] = preset("Shogi " + name.lower(),front,back)
    shogi["Shogi Jeweled King"] = preset("Shogi king","玉将","")
    categories = {r["piece_name"]:r["category"] for r in csv.DictReader((ROOT/"data/taikyoku_size_categories.csv").open())}
    taikyoku, skipped = {}, []
    for row in csv.DictReader((ROOT/"data/taikyoku_piece_characters.csv").open()):
        # IDS describe one missing glyph with multiple code points; never engrave as separate characters.
        if any(0x2ff0 <= ord(c) <= 0x2fff for c in row["front_characters"]+row["back_characters"]):
            skipped.append(row["piece_name"]); continue
        name = "Taikyoku " + row["piece_name"].replace("-", " ").title()
        taikyoku[name] = preset(categories[row["piece_name"]], row["front_characters"], row["back_characters"])
    write(ROOT/"presets/shogi.json",shogi)
    write(ROOT/"presets/taikyoku.json",taikyoku)
    write(ROOT/"shogi_piece.json",{**shogi,**taikyoku})
    (ROOT/"presets/omitted-pieces.txt").write_text("Require custom glyph artwork (IDS in source front or back):\n"+"\n".join(skipped)+"\n")
    print(f"Generated {len(shogi)} Shogi and {len(taikyoku)} Taikyoku presets; {len(skipped)} IDS entries omitted.")

if __name__ == "__main__":
    main()

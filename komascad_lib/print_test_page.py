"""The print test page: the project's fixed reference print.

The page has the same pieces with the same settings every time, so results
from different printers, filaments and slicer profiles can be compared. Every
value is therefore written out here instead of following presets/pieces/.
A change that alters what prints starts a new baseline: raise
TEST_PAGE_VERSION and say so in docs/print-test-page.md.

The 59 pieces are split over three plates that each fit a 220 mm bed.
"""

from __future__ import annotations

from collections.abc import Iterable, Sequence

TEST_PAGE_VERSION = 1

# (family, registered font name).
TEST_FONTS = [
    ("Yuji Syuku", "Yuji Syuku:style=Regular"),
    ("LXGW WenKai Mono", "LXGW WenKai Mono:style=Regular"),
]
LABEL_FONT = "LXGW WenKai Mono:style=Regular"

# (name, Stroke_Expansion in mm before Model_Scale). Level 3 is the value the
# bundled game presets ship with.
STROKES = [
    ("very thin", -0.10),
    ("thin", -0.03),
    ("normal", 0.04),
    ("thick", 0.11),
    ("very thick", 0.18),
]
NORMAL = STROKES[2][1]

# Line and gap widths of the ladder coupon, in final mm, widest first.
LADDER_WIDTHS = [0.6, 0.5, 0.4, 0.3, 0.25, 0.2, 0.15, 0.1]
# Where the ladder groups sit on the face, in mm: x across from the centerline,
# y along the face from the heel. Each pattern has one group across the piece
# (near the heel) and one group along it (near the point).
LADDER_BAR = 1.2  # width of a gap bar; also the space between line strokes along the piece
ACROSS_LENGTH = 12  # length of every stroke and bar that runs across the piece
LINES_ACROSS_START = 3.0  # y where the first line stroke across the piece starts
LINES_ACROSS_SPACE = 1.0  # space between line strokes across the piece
LINES_ALONG_Y = 19.5  # center y of the line strokes along the piece
LINES_ALONG_LENGTH = 9
GAPS_ACROSS_START = 2.5  # y where the first gap bar across the piece starts
GAPS_ALONG_Y = 21.5  # center y of the gap bars along the piece
GAPS_ALONG_LENGTH = 8

# Everything a piece does not override. Frozen copy of the engraving, color
# and shape settings the bundled shogi set used when this baseline was made.
TEST_BASE = {
    "Angle_Mode": "Derive shoulder",
    "Back_Center_Fraction": "0.42",
    "Back_Character_Spacing": "0",
    "Back_Characters": "",
    "Back_Filament": "Red",
    "Back_Font_Override": "",
    "Back_Font_Size": "0",
    "Back_Glyph_Height": "[1, 1, 1]",
    "Back_Glyph_Rotation": "[0, 0, 0]",
    "Back_Glyph_Size": "[1, 1, 1]",
    "Back_Glyph_Width": "[1, 1, 1]",
    "Back_Glyph_X": "[0, 0, 0]",
    "Back_Glyph_Y": "[0, 0, 0]",
    "Back_Height_Scale": "1",
    "Back_Inscription_Color": "[0.025, 0.02, 0.015, 1]",
    "Back_Relief_Depth": "0.35",
    "Back_Side_Base_Angle": "81",
    "Back_Spacing_Scale": "1",
    "Back_Stroke_Expansion": "0.04",
    "Back_Text_Rotation": "0",
    "Back_Text_Scale": "1",
    "Back_Text_Style": "Recessed",
    "Back_Text_X": "0",
    "Back_Text_Y": "0",
    "Back_Width_Scale": "1",
    "Base_Width": "28.5",
    "Bevel_Depth": "0",
    "Bevel_Width": "0",
    "Body_Color": "[0.82, 0.68, 0.43, 1]",
    "Body_Filament": "Wood",
    "Face_Base_Angle": "81",
    "Face_Shoulder_Angle": "117",
    "Face_Tip_Angle": "144",
    "Front_Center_Fraction": "0.455",
    "Front_Character_Spacing": "0",
    "Front_Characters": "",
    "Front_Filament": "Black",
    "Front_Font_Override": "",
    "Front_Font_Size": "0",
    "Front_Glyph_Height": "[1, 1, 1]",
    "Front_Glyph_Rotation": "[0, 0, 0]",
    "Front_Glyph_Size": "[1, 1, 1]",
    "Front_Glyph_Width": "[1, 1, 1]",
    "Front_Glyph_X": "[0, 0, 0]",
    "Front_Glyph_Y": "[0, 0, 0]",
    "Front_Height_Scale": "1",
    "Front_Inscription_Color": "[0.025, 0.02, 0.015, 1]",
    "Front_Relief_Depth": "0.35",
    "Front_Side_Base_Angle": "85",
    "Front_Spacing_Scale": "1",
    "Front_Stroke_Expansion": "0.04",
    "Front_Text_Rotation": "0",
    "Front_Text_Scale": "1",
    "Front_Text_Style": "Recessed",
    "Front_Text_X": "0",
    "Front_Text_Y": "0",
    "Front_Width_Scale": "1",
    # The bundled sets use 1.2 mm. A quarter-scale point is thinner than that
    # by design, so the page lowers the guard instead of skipping the size.
    "Minimum_Web": "0.4",
    "Mirror_Front_Settings": "false",
    "Output_Mode": "Model",
    "Pawn_Circle": "true",
    "Piece_Length": "32",
    # Front on the bed, promoted side up.
    "Print_Orientation": "Front face down",
    "Protect_Face_Edges": "true",
    "Rear_Thickness": "9.8",
    "Show_Layout_Guides": "true",
    "Signature_Color": "[0.025, 0.02, 0.015, 1]",
    "Signature_Depth": "0.2",
    "Signature_Enabled": "false",
    # Red, like the reverse printed just before it, to save a filament change.
    "Signature_Filament": "Red",
    "Signature_Font": "",
    "Signature_Font_Size": "5",
    "Signature_Letter_Spacing": "1",
    "Signature_Margin": "0.6",
    "Signature_Rotation": "0",
    "Signature_Text": "",
    "Signature_X": "0",
    "Signature_Y": "0",
    "Taper_Mode": "Tip thickness",
    "Text_Color_Treatment": "Flush filled",
    "Text_Curve_Resolution": "64",
    "Text_Edge_Radius": "0",
    "Text_Margin": "0.9",
    "Text_Rounding_Steps": "6",
    "Tip_Thickness": "3.2",
}

# Layouts on the king body, as the bundled shogi king uses them. A kirin
# promotes to a lion, so the reverse of 麒麟 is 獅子.
TWO_CHARACTERS = {
    "Characters": ("麒麟", "獅子"),
    "Font_Size": "10.4",
    "Character_Spacing": "10.5",
    "Center_Fraction": "0.455",
    "Glyph_Width": "[1, 1.4, 1]",
    "Glyph_Y": "[2, -1, 0]",
    "Height_Scale": "1.06",
}
ONE_CHARACTER = {
    "Characters": ("驢", "獅"),
    "Font_Size": "15.5",
    "Center_Fraction": "0.42",
    "Glyph_Y": "[1, 0, 0]",
}
# Flush filled cannot be raised. Raised pieces use Painted grooves, as they did
# when baseline 1 was printed. Only the reverse can be raised: the front lies
# on the bed. The raised lettered piece has a blank front because a dense
# Painted grooves front takes many times longer to build.
RAISED = {"Back_Text_Style": "Raised", "Text_Color_Treatment": "Painted grooves"}
INDENTED = {"Text_Color_Treatment": "Face only"}

# OpenSCAD draws U+2588 FULL BLOCK as a square 100/72 of the text size, a
# little off the text origin. At size 0.72 that square is exactly 1 mm, so a
# glyph's width and height multipliers are its size in mm. The ladder is built
# from these so it passes through the same text path as real lettering.
BLOCK = "█"
BLOCK_SIZE = 0.72
BLOCK_CENTER = (0.0117191, 0.0091022)  # of a 1 mm block, in mm

# Quadrant block characters by (upper left, upper right, lower left, lower
# right). U+3000 is the empty cell: it is as wide as the others.
QUADRANTS = {
    (0, 0, 0, 0): "　",
    (1, 0, 0, 0): "▘",
    (0, 1, 0, 0): "▝",
    (0, 0, 1, 0): "▖",
    (0, 0, 0, 1): "▗",
    (1, 1, 0, 0): "▀",
    (0, 0, 1, 1): "▄",
    (1, 0, 1, 0): "▌",
    (0, 1, 0, 1): "▐",
    (1, 0, 0, 1): "▚",
    (0, 1, 1, 0): "▞",
    (1, 1, 1, 0): "▛",
    (1, 1, 0, 1): "▜",
    (1, 0, 1, 1): "▙",
    (0, 1, 1, 1): "▟",
    (1, 1, 1, 1): "█",
}

Settings = dict[str, str]
Rectangle = tuple[float, float, float, float]  # x, y, width, height in mm

# The Customizer saves numbers with up to this many decimals.
CUSTOMIZER_DECIMALS = 5

# Piece sizes on the page, by label. Each is a Model Scale.
SIZES = {"2x": 2, "1.5x": 1.5, "1x": 1, "0.5x": 0.5, "0.25x": 0.25}

# Stroke levels (indexes into STROKES) that a sweep prints.
EXTREMES = (0, 2, 4)  # very thin, normal and very thick
ALL_STROKES = range(len(STROKES))

# The heel label. Text is 8.3 mm tall and each dot of a dot code is 4.2 mm
# square, before scaling: the most that the 8.6 mm of usable heel holds.
LABEL_TEXT_SIZE = "8.2"
LABEL_DOT_SIZE = "6"
LABEL_ROTATION = "180"  # reads from the front of the printer when the piece lies face down

# A dot code writes the piece number in base three: each column holds 0, 1 or
# 2 dots, and the four number columns are worth this much per dot.
DOT_CODE_BASE = 3
DOT_CODE_WEIGHTS = (27, 9, 3, 1)
FULL_COLUMN = 2  # dots in a full column


def customizer_number(value: float) -> str:
    """Formats a number the way the Customizer saves it.

    Args:
        value: The number.

    Returns:
        The number as text, such as "0.04" or "15".
    """
    rounded = round(value, CUSTOMIZER_DECIMALS)
    return f"{rounded:g}"


def customizer_vector(values: Iterable[float]) -> str:
    """Formats a list of numbers the way the Customizer saves it.

    Args:
        values: The numbers.

    Returns:
        The list as text, such as "[1, 1.4, 1]".
    """
    texts = [customizer_number(value) for value in values]
    return "[" + ", ".join(texts) + "]"


def lettering(layout: dict, expansion: float = NORMAL) -> Settings:
    """Puts the same layout and stroke on both faces: the front name and its promoted back.

    Args:
        layout: Settings without the Front_ or Back_ prefix, such as TWO_CHARACTERS.
            "Characters" holds a (front, back) pair; every other value is shared.
        expansion: The stroke expansion of both faces, in mm.

    Returns:
        The Front_ and Back_ settings.
    """
    settings = {}
    for index, side in enumerate(("Front", "Back")):
        for key, value in layout.items():
            if key == "Characters":
                value = value[index]
            settings[f"{side}_{key}"] = value
        settings[side + "_Stroke_Expansion"] = customizer_number(expansion)
    return settings


def dot_code(plate: int, piece: int) -> str:
    """Encodes a piece label as six columns of square dots, two dots high.

    Each column is empty, one dot or two dots tall, standing on the bottom
    row. The first column is always two dots: it marks the start. The second
    is the plate: empty, one or two dots for plate 1, 2 or 3. The last four
    are the piece number in base three (see DOT_CODE_WEIGHTS).

    Columns never hang from the top row, so no two dots meet only at a
    corner: OpenSCAD cannot extrude outlines that do.

    Args:
        plate: The plate number, 1 to 3.
        piece: The place of the piece on its plate, from 1.

    Returns:
        Three quadrant block characters; each holds two columns.
    """
    start_column = FULL_COLUMN
    plate_column = plate - 1
    heights = [start_column, plate_column]
    for weight in DOT_CODE_WEIGHTS:
        heights.append(piece // weight % DOT_CODE_BASE)

    # Each column has a top dot and a bottom dot; a dot is 1, no dot is 0.
    top = [1 if height == FULL_COLUMN else 0 for height in heights]
    bottom = [1 if height >= 1 else 0 for height in heights]

    # Each quadrant block character holds two columns side by side.
    characters = []
    for left in range(0, len(heights), 2):
        right = left + 1
        characters.append(QUADRANTS[top[left], top[right], bottom[left], bottom[right]])
    return "".join(characters)


def heel_label(plate: int, piece: int, scale: float) -> Settings:
    """Makes the label on the heel, as large as the heel allows.

    The heel is a side wall of a face-down print. Below full size, label text
    would have strokes thinner than a 0.4 mm nozzle, so those pieces carry a
    dot code instead.

    Args:
        plate: The plate number.
        piece: The place of the piece on its plate.
        scale: The Model Scale of the piece.

    Returns:
        The signature settings that draw the label.
    """
    readable = scale >= 1
    if readable:
        text, size = f"{plate}-{piece:02d}", LABEL_TEXT_SIZE
    else:
        text, size = dot_code(plate, piece), LABEL_DOT_SIZE

    return {
        "Signature_Enabled": "true",
        "Signature_Text": text,
        "Signature_Font": LABEL_FONT,
        "Signature_Font_Size": size,
        "Signature_Rotation": LABEL_ROTATION,
    }


def stack(sizes: Iterable[float], gap: float, start: float) -> list[float]:
    """Lays items end to end, with a gap between them.

    Args:
        sizes: The length of each item.
        gap: The space between two items.
        start: Where the first item starts.

    Returns:
        The center of each item.
    """
    centers = []
    edge = start
    for size in sizes:
        centers.append(edge + size / 2)
        edge += size + gap
    return centers


def blocks(side: str, rectangles: Sequence[Rectangle]) -> Settings:
    """Makes the settings that draw rectangles on one face.

    Each rectangle is one FULL BLOCK character, stretched to its size.

    Args:
        side: "Front" or "Back".
        rectangles: (x, y, width, height) in mm. x is across the piece from its
            centerline; y is along the face from the heel.

    Returns:
        The settings of that face.
    """
    count = len(rectangles)
    xs = []
    ys = []
    for index, (x, y, width, height) in enumerate(rectangles):
        xs.append(x - BLOCK_CENTER[0] * width)
        # The model puts its characters one spacing apart, centered on the
        # face. With spacing 1, character `index` sits this far from the center.
        row_offset = (count - 1 - 2 * index) / 2
        ys.append(y - BLOCK_CENTER[1] * height - row_offset)

    widths = [width for _, _, width, _ in rectangles]
    heights = [height for _, _, _, height in rectangles]
    return {
        side + "_Characters": BLOCK * count,
        side + "_Font_Override": LABEL_FONT,
        side + "_Font_Size": customizer_number(BLOCK_SIZE),
        side + "_Character_Spacing": "1",
        side + "_Center_Fraction": "0",
        side + "_Stroke_Expansion": "0",
        side + "_Height_Scale": "1",
        side + "_Glyph_Width": customizer_vector(widths),
        side + "_Glyph_Height": customizer_vector(heights),
        side + "_Glyph_X": customizer_vector(xs),
        side + "_Glyph_Y": customizer_vector(ys),
    }


def ladder_lines() -> list[Rectangle]:
    """One stroke of each ladder width, across the piece and then along it.

    Returns:
        The strokes, as (x, y, width, height) in mm.
    """
    widths = LADDER_WIDTHS

    across = stack(widths, LINES_ACROSS_SPACE, LINES_ACROSS_START)
    lines: list[Rectangle] = []
    for y, width in zip(across, widths, strict=True):
        lines.append((0, y, ACROSS_LENGTH, width))

    along_span = sum(widths) + LADDER_BAR * (len(widths) - 1)
    along = stack(widths, LADDER_BAR, -along_span / 2)
    for x, width in zip(along, widths, strict=True):
        lines.append((x, LINES_ALONG_Y, width, LINES_ALONG_LENGTH))
    return lines


def ladder_gaps() -> list[Rectangle]:
    """Nine bars with a space of each ladder width between them, across the piece and along it.

    Returns:
        The bars, as (x, y, width, height) in mm.
    """
    widths = LADDER_WIDTHS

    # A cell is one bar plus the space after it. The last bar has no space.
    spaces = widths + [0]
    cell_lengths = [LADDER_BAR + width for width in widths] + [LADDER_BAR]
    cells = stack(cell_lengths, 0, 0)
    bars_span = LADDER_BAR * (len(widths) + 1) + sum(widths)

    gaps: list[Rectangle] = []
    for cell, space in zip(cells, spaces, strict=True):
        gaps.append((0, GAPS_ACROSS_START + cell - space / 2, ACROSS_LENGTH, LADDER_BAR))
    for cell, space in zip(cells, spaces, strict=True):
        gaps.append((cell - space / 2 - bars_span / 2, GAPS_ALONG_Y, LADDER_BAR, GAPS_ALONG_LENGTH))
    return gaps


def ladder(front: str | None, back: str | None) -> Settings:
    """Makes the faces of a ladder coupon.

    Args:
        front: "lines", "gaps" or None for a blank front.
        back: "lines", "gaps" or None for a blank back.

    Returns:
        The settings of both faces.
    """
    patterns = {"lines": ladder_lines(), "gaps": ladder_gaps()}

    settings = {}
    if front:
        settings.update(blocks("Front", patterns[front]))
    if back:
        settings.update(blocks("Back", patterns[back]))
    return settings


class Plate:
    """One plate of the test page: its presets in bed order, and its rows.

    A piece is named by its plate and its place on the plate, such as
    "3-07". Rows run from the back of the bed to the front.

    Attributes:
        number: The plate number, from 1.
        presets: The settings of each piece, by preset name, in bed order.
        rows: The number of pieces in each finished row.
    """

    def __init__(self, number: int):
        """Starts an empty plate.

        Args:
            number: The plate number, from 1.
        """
        self.number = number
        self.presets: dict[str, Settings] = {}
        self.rows: list[int] = []

    @property
    def filename(self) -> str:
        """The name of the plate's preset file, such as "print-test-plate-1.json"."""
        return f"print-test-plate-{self.number}.json"

    def add(self, description: str, font: str, size: str, *layers: Settings) -> None:
        """Adds one piece: the shared base, then each layer of settings, then its label.

        Args:
            description: Ends the preset name, such as "1x Yuji Syuku one character".
            font: The registered font name.
            size: A key of SIZES, such as "1x".
            *layers: Settings to apply in order; a later layer wins.
        """
        piece = len(self.presets) + 1
        scale = SIZES[size]
        title = f"Print test v{TEST_PAGE_VERSION}"

        preset = dict(TEST_BASE)
        preset["Font_Name"] = font
        preset["Model_Scale"] = customizer_number(scale)
        preset["Category"] = f"{title} / {description}"
        for layer in layers:
            preset.update(layer)
        preset.update(heel_label(self.number, piece, scale))

        self.presets[f"{title} - {self.number}-{piece:02d} {description}"] = preset

    def sweep(self, font_entry: tuple[str, str], size: str, levels: Iterable[int]) -> None:
        """Adds the two-character piece at each of the given stroke levels.

        Args:
            font_entry: (family, registered font name), from TEST_FONTS.
            size: A key of SIZES.
            levels: Indexes into STROKES.
        """
        family, font = font_entry
        for level in levels:
            stroke_name, expansion = STROKES[level]
            description = f"{size} {family} stroke {level + 1} {stroke_name}"
            self.add(description, font, size, lettering(TWO_CHARACTERS, expansion))

    def single(self, font_entry: tuple[str, str], size: str) -> None:
        """Adds the one-character piece.

        Args:
            font_entry: (family, registered font name), from TEST_FONTS.
            size: A key of SIZES.
        """
        family, font = font_entry
        self.add(f"{size} {family} one character", font, size, lettering(ONE_CHARACTER))

    def end_row(self) -> None:
        """Ends the current row: the pieces added since the last row form it."""
        pieces_so_far = len(self.presets)
        self.rows.append(pieces_so_far - sum(self.rows))


def build_test_page() -> list[Plate]:
    """Builds the three plates of the test page.

    Returns:
        The plates, in order.
    """
    return [_large_plate(), _ladder_plate(), _small_plate()]


def _large_plate() -> Plate:
    """Plate 1: the large sizes.

    Large sizes print easily, so they get only the two extremes and the normal stroke.
    """
    plate = Plate(1)
    for font_entry in TEST_FONTS:
        plate.sweep(font_entry, "2x", EXTREMES)
        plate.end_row()

    for size in ("1.5x", "1x"):
        for font_entry in TEST_FONTS:
            plate.single(font_entry, size)
    plate.end_row()
    return plate


def _ladder_plate() -> Plate:
    """Plate 2: the 1.5x sweeps, the raised piece and the six ladder coupons.

    Ladders are in final mm, so they are always full size. Each pattern is on
    the bed face of one coupon and on the top face of another.
    """
    syuku, wenkai = TEST_FONTS
    syuku_font = syuku[1]
    coupons = [
        ("L1 inlaid, lines down", ladder("lines", "gaps")),
        ("L2 inlaid, gaps down", ladder("gaps", "lines")),
        ("L3 indented, lines down", dict(ladder("lines", "gaps"), **INDENTED)),
        ("L4 indented, gaps down", dict(ladder("gaps", "lines"), **INDENTED)),
        ("L5 raised lines", dict(ladder(None, "lines"), **RAISED)),
        ("L6 raised gaps", dict(ladder(None, "gaps"), **RAISED)),
    ]
    first_coupon = coupons[0]
    other_coupons = coupons[1:]

    plate = Plate(2)
    plate.sweep(syuku, "1.5x", EXTREMES)
    blank_front = {"Front_Characters": ""}
    raised_piece = [lettering(TWO_CHARACTERS), RAISED, blank_front]
    plate.add("1x Yuji Syuku raised reverse", syuku_font, "1x", *raised_piece)
    plate.end_row()

    plate.sweep(wenkai, "1.5x", EXTREMES)
    description, settings = first_coupon
    plate.add("Ladder " + description, syuku_font, "1x", settings)
    plate.end_row()

    for description, settings in other_coupons:
        plate.add("Ladder " + description, syuku_font, "1x", settings)
    plate.end_row()
    return plate


def _small_plate() -> Plate:
    """Plate 3: the small sizes, which get every stroke level."""
    syuku, wenkai = TEST_FONTS

    plate = Plate(3)
    for font_entry in TEST_FONTS:
        plate.single(font_entry, "2x")
    for font_entry in TEST_FONTS:
        plate.single(font_entry, "0.5x")
    plate.single(wenkai, "0.25x")
    plate.end_row()

    for font_entry in TEST_FONTS:
        plate.sweep(font_entry, "1x", ALL_STROKES)
        plate.end_row()

    plate.sweep(syuku, "0.5x", ALL_STROKES)
    plate.sweep(syuku, "0.25x", ALL_STROKES)
    plate.end_row()

    plate.sweep(wenkai, "0.5x", ALL_STROKES)
    plate.sweep(wenkai, "0.25x", ALL_STROKES)
    plate.single(syuku, "0.25x")
    plate.end_row()
    return plate

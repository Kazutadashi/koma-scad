// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// The maker's mark (銘) of the ban, komadai and komabako. Include this file:
//     include <../lib/maker_mark.scad>
// A mark is up to three parts, stacked and centered: an emblem (a koma with a
// character on it), a main line, and a smaller second line. Each line can
// have wide letter spacing, as in a wordmark.
//
// Sizes: size_1 is the main line's text size and size_2 the second line's,
// in mm. maker_mark_sizes() picks them: as large as the room allows, with no
// text below a printable minimum (min_size).

// The emblem's proportions: a koma 1.6 times the main text size tall, as
// wide as a shogi king is for its length.
mark_emblem_height = 1.6;      // times the main text size
mark_emblem_aspect = 0.89;     // width / height
mark_emblem_shoulder = 0.72;   // the shoulders, as a fraction of the height
mark_emblem_inset = 0.37;      // the half-width at the shoulders, as a fraction of the height
mark_emblem_character = 0.5;   // the character's size, as a fraction of the emblem's height
mark_line_gap = 0.55;          // space between the parts, times the main text size
mark_fill = 0.8;               // an automatic mark uses at most this much of its room

// The approximate width of one character, in text sizes. Text has no
// measured width in OpenSCAD 2021, so the mark's size is planned from these.
// OpenSCAD's text size is about the height of a capital, so a character is
// wider than its size: measured in Shippori Mincho and Kaisei Tokumin, a
// Japanese character (from U+2E80) is about 1.35 wide and 1.3 tall, a Latin
// capital about 1 wide (up to 1.2), lower case 0.75, a space 0.35.
function mark_character_width(character) =
    let(code = ord(character))
    code >= 11904 ? 1.35
    : character == " " ? 0.35
    : code >= 65 && code <= 90 ? 1
    : code >= 97 && code <= 122 ? 0.75
    : 0.5;
function mark_text_width(line, i=0) = i >= len(line) ? 0 : mark_character_width(line[i]) + mark_text_width(line, i + 1);
function maker_mark_has_kanji(line) = len([for (character = line) if (ord(character) >= 11904) 1]) > 0;
// The height of a line, in text sizes: taller with Japanese characters.
function mark_line_height(line) = maker_mark_has_kanji(line) ? 1.35 : 1.1;

// The emblem's height: 1.6 times the main text size, but tall enough that its
// character is at least min_size.
function mark_emblem_size(size_1, min_size) = max(size_1*mark_emblem_height, min_size/mark_emblem_character);

// A koma outline, its heel on y = 0 and centered on x = 0.
module mark_koma_2d(height) {
    half = height*mark_emblem_aspect/2;
    polygon([[-half, 0], [half, 0], [height*mark_emblem_inset, height*mark_emblem_shoulder],
             [0, height], [-height*mark_emblem_inset, height*mark_emblem_shoulder]]);
}

// The 2D mark, centered on the origin at the middle of the main line's
// baseline. Empty lines are left out. stroke thickens every stroke by that
// much on each side, so that thin strokes print. min_size keeps the emblem's
// character at least that size.
module maker_mark_2d(line_1, line_2, size_1, size_2, font_1, font_2, spacing_1=1, spacing_2=1,
                     emblem=false, emblem_character="", emblem_font="", stroke=0, min_size=0) {
    gap = size_1*mark_line_gap;
    if (line_1 != "")
        offset(delta=stroke)
            text(line_1, size=size_1, font=font_1, spacing=spacing_1, halign="center", valign="baseline");
    if (line_2 != "")
        translate([0, -gap]) offset(delta=stroke)
            text(line_2, size=size_2, font=font_2, spacing=spacing_2, halign="center", valign="top");
    if (emblem) {
        height = mark_emblem_size(size_1, min_size);
        // The main line's capitals stand about one text size above the baseline.
        translate([0, size_1 + gap]) difference() {
            mark_koma_2d(height);
            if (emblem_character != "")
                translate([0, height*0.42]) offset(delta=stroke)
                    text(emblem_character, size=height*mark_emblem_character,
                         font=emblem_font == "" ? font_1 : emblem_font, halign="center", valign="center");
        }
    }
}

// The space above and below the main line's baseline. Letters stand about
// 1.1 sizes above it and reach about 0.2 below.
function mark_above(size_1, emblem, min_size=0) =
    size_1*1.1 + (emblem ? size_1*mark_line_gap + mark_emblem_size(size_1, min_size) : 0);
function mark_below(line_2, size_1, size_2) =
    size_1*0.2 + (line_2 == "" ? 0 : size_1*mark_line_gap + size_2*mark_line_height(line_2));

// The same mark, with its whole height centered on the origin.
module maker_mark_centered_2d(line_1, line_2, size_1, size_2, font_1, font_2, spacing_1=1, spacing_2=1,
                              emblem=false, emblem_character="", emblem_font="", stroke=0, min_size=0) {
    translate([0, (mark_below(line_2, size_1, size_2) - mark_above(size_1, emblem, min_size))/2])
        maker_mark_2d(line_1, line_2, size_1, size_2, font_1, font_2, spacing_1, spacing_2,
                      emblem, emblem_character, emblem_font, stroke, min_size);
}

// The mark's approximate [width, height] in mm, for fit checks.
function maker_mark_extent(line_1, line_2, size_1, size_2, spacing_1=1, spacing_2=1, emblem=false, min_size=0) =
    [max(mark_text_width(line_1)*size_1*spacing_1, mark_text_width(line_2)*size_2*spacing_2,
         emblem ? mark_emblem_size(size_1, min_size)*mark_emblem_aspect : 0),
     mark_above(size_1, emblem, min_size) + mark_below(line_2, size_1, size_2)];

// The text sizes [size_1, size_2] of a mark. size > 0 sets the main line;
// size = 0 makes it as large as fits mark_fill of room ([width, depth]), up to
// max_size. The second line is ratio times the main line, but never smaller
// than min_size.
function maker_mark_sizes(line_1, line_2, size, ratio, min_size, max_size, spacing_1, spacing_2, emblem, room) =
    let(width_1 = mark_text_width(line_1)*spacing_1,
        width_2 = mark_text_width(line_2)*spacing_2*ratio,
        height = 1.3 + (emblem ? mark_line_gap + mark_emblem_height : 0)
                 + (line_2 == "" ? 0 : mark_line_gap + ratio*mark_line_height(line_2)),
        by_width = room[0]*mark_fill/max(width_1, width_2, emblem ? mark_emblem_height*mark_emblem_aspect : 0, 0.01),
        by_height = room[1]*mark_fill/height,
        size_1 = size > 0 ? size : min(max_size, by_width, by_height),
        size_2 = max(size_1*ratio, min_size))
    [size_1, size_2];

// The size of the smallest text in the lines, or a large number when both are
// empty. The emblem's character grows to min_size by itself.
function maker_mark_smallest_text(line_1, line_2, sizes) =
    min(concat(line_1 != "" ? [sizes[0]] : [], line_2 != "" ? [sizes[1]] : [], [1000]));

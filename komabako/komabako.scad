// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD komabako: a box with a lid for a set of pieces. Tested with OpenSCAD 2021.01.
// The default settings make an inro-lid box for the 40 pieces of a shogi set.
// Units are mm unless a comment says otherwise.
// Guide and every setting: docs/komabako.md.
// Keep ../lib/ next to this file's folder.

/* [01 - Start here] */
// Box and Lid are one part each. Box and lid puts both on one bed. Closed shows the lid in place (F5 only).
Output_Mode = "Box and lid"; // [Box and lid,Box,Lid,Closed]
// Inro: the lid sits on a step, and its sides are flush with the box (印籠). Cap: the lid fits over the outside of the box.
Lid_Style = "Inro"; // [Inro,Cap]

/* [02 - Pieces] */
// How many pieces the box holds.
Piece_Count = 40; // [1:1:500]
// mm. Length of the largest piece, from the heel to the point.
Piece_Length = 32; // [10:0.1:100]
// mm. Width of the largest piece at the heel.
Base_Width = 28.5; // [10:0.1:100]
// mm. Thickness of the largest piece at the heel.
Rear_Thickness = 9.8; // [3:0.1:30]

/* [03 - Inside size] */
// How many pieces lie flat in one layer. The automatic height counts the layers.
Pieces_Per_Layer = 10; // [1:1:100]
// Fraction of a piece's thickness that one loose layer adds. Below 1 because loose pieces nest.
Packing_Factor = 0.76; // [0.5:0.01:1.2]
// mm. Space above the top layer.
Headroom = 5; // [1:0.5:20]
// mm. Inside width. 0 = automatic, from the largest piece.
Inner_Width = 0; // [0:1:400]
// mm. Inside depth. 0 = automatic, from the largest piece.
Inner_Depth = 0; // [0:1:400]
// mm. Inside height, from the floor to the top of the box. 0 = automatic, from the layers.
Inner_Height = 0; // [0:1:300]

/* [04 - Box] */
// mm. Thickness of the side walls. An Inro lid takes part of it for its step.
Wall_Thickness = 4; // [1.2:0.2:10]
// mm. Thickness of the bottom.
Bottom_Thickness = 3; // [1.2:0.2:8]
// mm. Radius of the outside corners (隅丸).
Corner_Radius = 4; // [0:0.5:15]
// mm. 45 degree chamfer (面取り) on the outside edges of the box and the lid.
Edge_Chamfer = 0.8; // [0:0.1:3]

/* [05 - Lid] */
// mm. Space on each side between the box and the lid. Raise it if the lid is tight.
Lid_Clearance = 0.25; // [0.05:0.05:1]
// mm. Thickness of the lid walls.
Lid_Skirt_Thickness = 2; // [1.2:0.2:6]
// mm. How far the lid walls come down the box.
Lid_Skirt_Height = 12; // [3:0.5:30]
// mm. Thickness of the lid top.
Lid_Roof_Thickness = 3; // [1.2:0.2:8]

/* [06 - Maker's mark] */
// Where the mark goes: under the box, on top of the lid, or both.
Mark_Place = "Underside"; // [Underside,Lid top,Both]
// The main line of the mark (銘), on the box: your name or brand. Empty = no mark.
Mark_Line_1 = "";
// A smaller line under it, such as SHOGI · 将棋. Empty = none.
Mark_Line_2 = "";
// mm. Text size of the main line. The second line and the emblem follow it. 0 = automatic: as large as the room allows, up to Mark Max Size.
Mark_Size = 0; // [0:0.1:40]
// mm. Automatic only: the largest text size of the main line.
Mark_Max_Size = 14; // [4:0.5:40]
// Size of the second line, as a fraction of the main line. Keep Japanese characters 3 mm or larger.
Mark_Line_2_Ratio = 0.42; // [0.2:0.01:1]
// mm. Smallest size of any text in the mark, and of the emblem's character, so that it prints. The second line and the emblem grow to it. See docs/makers-mark.md for measured values.
Mark_Min_Text_Size = 7; // [3:0.5:20]
// mm. Thickens every stroke of the mark by this much on each side, so that thin strokes print. 0.12 for a thin Mincho.
Mark_Stroke = 0; // [0:0.01:0.3]
// Letter spacing of the main line. 1 = normal. About 1.7 gives a wide-spaced wordmark.
Mark_Spacing_1 = 1; // [0.8:0.05:3]
// Letter spacing of the second line.
Mark_Spacing_2 = 1; // [0.8:0.05:3]
// An installed font for the main line. Find its exact name in Help > Font List.
Mark_Font_1 = "Kaisei Tokumin:style=ExtraBold";
// An installed font for the second line. Use one with Japanese characters for Japanese text.
Mark_Font_2 = "Kaisei Tokumin:style=ExtraBold";
// A koma above the text, with a character cut into it.
Mark_Emblem = false;
// The character on the emblem, such as 王.
Mark_Emblem_Character = "";
// An installed font for the emblem's character, such as a brush font. Empty = Mark Font 1.
Mark_Emblem_Font = "";
// mm. Depth of the mark.
Mark_Depth = 0.4; // [0.2:0.1:1]

/* [07 - Filament colors and layout] */
// Box color. Kuwa is the island mulberry of fine boxes. Custom uses Box Color.
Box_Filament = "Kuwa"; // [Kuwa,Kurogaki,Kaya,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Lid color. Custom uses Lid Color.
Lid_Filament = "Kuwa"; // [Kuwa,Kurogaki,Kaya,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Box Filament is Custom.
Box_Color = [0.48, 0.23, 0.11, 1];
// [red, green, blue, opacity], 0 to 1. Used when Lid Filament is Custom.
Lid_Color = [0.62, 0.36, 0.17, 1];
// mm. Space between the box and the lid in Box and lid.
Print_Layout_Gap = 10; // [3:1:30]

/* [Hidden] */
version = "3.5";   // the same as VERSION in komascad.py; a test checks this
$fn = 40;
epsilon = 0.02;   // overlap that keeps boolean operations clean

include <../lib/filaments.scad>
include <../lib/shapes.scad>
include <../lib/maker_mark.scad>


// ===== 1. Sizes ===============================================================

layer_count = ceil(Piece_Count/Pieces_Per_Layer);
// The automatic floor fits about ten loose pieces side by side.
automatic_inside = max(Base_Width*3.3, Piece_Length*3);
inner_width = Inner_Width > 0 ? Inner_Width : automatic_inside;
inner_depth = Inner_Depth > 0 ? Inner_Depth : automatic_inside;
inner_height = Inner_Height > 0 ? Inner_Height : layer_count*Rear_Thickness*Packing_Factor + Headroom;
outer_width = inner_width + 2*Wall_Thickness;
outer_depth = inner_depth + 2*Wall_Thickness;
inro = Lid_Style == "Inro";

// Inro: the outer wall stops at the shoulder, and a thinner collar rises
// inside it. The lid sits on the shoulder, with its sides flush with the box.
collar_thickness = Wall_Thickness - Lid_Skirt_Thickness - Lid_Clearance;
lid_seat_gap = 0.5;   // mm between the collar top and the lid roof, so the lid rests on the shoulder
collar_height = Lid_Skirt_Height - lid_seat_gap;
box_height = Bottom_Thickness + inner_height;   // to the top of the box (the collar, for Inro)
shoulder_height = inro ? box_height - collar_height : box_height;

// The lid. Inro: the same footprint as the box. Cap: larger, around the box.
lid_opening = inro ? [outer_width, outer_depth] - 2*[Lid_Skirt_Thickness, Lid_Skirt_Thickness]
                   : [outer_width, outer_depth] + 2*[Lid_Clearance, Lid_Clearance];
lid_width = lid_opening[0] + 2*Lid_Skirt_Thickness;
lid_depth = lid_opening[1] + 2*Lid_Skirt_Thickness;
lid_height = Lid_Roof_Thickness + Lid_Skirt_Height;
lid_radius = inro ? Corner_Radius : Corner_Radius + Lid_Skirt_Thickness + Lid_Clearance;
// A cap rests its roof on the rim of the box.
closed_height = inro ? shoulder_height + lid_height : box_height + Lid_Roof_Thickness;


// The room for the mark: 3 mm in from the chamfered edges.
mark_room = [outer_width, outer_depth] - 2*[Edge_Chamfer + 3, Edge_Chamfer + 3];

// The maker's mark, from lib/maker_mark.scad: its text sizes, as large as its
// room allows, and no text below Mark Min Text Size.
mark_on = Mark_Line_1 != "" || Mark_Line_2 != "" || Mark_Emblem;
mark_sizes = maker_mark_sizes(Mark_Line_1, Mark_Line_2, Mark_Size, Mark_Line_2_Ratio, Mark_Min_Text_Size,
                              Mark_Max_Size, Mark_Spacing_1, Mark_Spacing_2, Mark_Emblem, mark_room);
mark_extent = maker_mark_extent(Mark_Line_1, Mark_Line_2, mark_sizes[0], mark_sizes[1], Mark_Spacing_1,
                                Mark_Spacing_2, Mark_Emblem, Mark_Min_Text_Size);
mark_smallest_text = maker_mark_smallest_text(Mark_Line_1, Mark_Line_2, mark_sizes);
module mark_2d() {
    maker_mark_centered_2d(Mark_Line_1, Mark_Line_2, mark_sizes[0], mark_sizes[1], Mark_Font_1, Mark_Font_2,
                           Mark_Spacing_1, Mark_Spacing_2, Mark_Emblem, Mark_Emblem_Character, Mark_Emblem_Font,
                           Mark_Stroke, Mark_Min_Text_Size);
}
mark_under = mark_on && Mark_Place != "Lid top";
mark_on_lid = mark_on && Mark_Place != "Underside";


// ===== 2. Box and lid =========================================================

// The mark on the underside, mirrored so that it reads from below.
module signature_cut() {
    if (mark_under)
        translate([outer_width/2, outer_depth/2, -epsilon]) linear_extrude(Mark_Depth + epsilon, convexity=20)
            mirror([1, 0, 0]) mark_2d();
}

// The mark on the lid top. The lid prints top down and turns over onto the
// box, so the mark is mirrored front to back, and reads from above when closed.
module lid_mark_cut() {
    if (mark_on_lid)
        translate([lid_width/2, lid_depth/2, -epsilon]) linear_extrude(Mark_Depth + epsilon, convexity=20)
            mirror([0, 1, 0]) mark_2d();
}

module box() {
    inner_radius = max(0, Corner_Radius - Wall_Thickness);
    difference() {
        union() {
            chamfered_slab([outer_width, outer_depth, shoulder_height], Corner_Radius, Edge_Chamfer, Edge_Chamfer);
            if (inro) {
                inset = Lid_Skirt_Thickness + Lid_Clearance;
                translate([inset, inset, shoulder_height - epsilon])
                    rounded_slab([outer_width - 2*inset, outer_depth - 2*inset, collar_height + epsilon],
                                 max(0, Corner_Radius - inset));
            }
        }
        translate([Wall_Thickness, Wall_Thickness, Bottom_Thickness])
            rounded_slab([inner_width, inner_depth, inner_height + epsilon], inner_radius);
        signature_cut();
    }
}

// The lid is drawn top down, so that it prints without supports.
module lid() {
    difference() {
        chamfered_slab([lid_width, lid_depth, lid_height], lid_radius, Edge_Chamfer, Edge_Chamfer);
        lid_mark_cut();
        translate([Lid_Skirt_Thickness, Lid_Skirt_Thickness, Lid_Roof_Thickness])
            rounded_slab([lid_opening[0], lid_opening[1], Lid_Skirt_Height + epsilon],
                         max(0, lid_radius - Lid_Skirt_Thickness));
    }
}

module closed_box() {
    color(filament_rgba(Box_Filament, Box_Color)) box();
    // Turn the lid over and lower it onto the box.
    lid_offset = inro ? 0 : Lid_Skirt_Thickness + Lid_Clearance;
    color(filament_rgba(Lid_Filament, Lid_Color))
        translate([-lid_offset, outer_depth + lid_offset, closed_height]) rotate([180, 0, 0]) lid();
}


// ===== 3. Checks ==============================================================

assert(inner_width > Base_Width && inner_depth > Piece_Length,
    "The inside must be larger than the largest piece. Raise Inner Width and Inner Depth, or set them to 0.");
assert(inner_height > Rear_Thickness, "The inside must be taller than the largest piece. Raise Inner Height, or set it to 0.");
assert(!inro || collar_thickness >= 1.2,
    str("The Inro step leaves a collar only ", collar_thickness, " mm thick. Raise Wall Thickness, ",
        "or reduce Lid Skirt Thickness."));
assert(!inro || shoulder_height > Bottom_Thickness + 2*Edge_Chamfer,
    "The lid comes down below the floor of the box. Reduce Lid Skirt Height.");
assert(2*Edge_Chamfer < min(Lid_Skirt_Thickness, Wall_Thickness) + Lid_Roof_Thickness,
    "Edge Chamfer is too large.");
assert(!mark_on || Mark_Depth < min(Bottom_Thickness, Lid_Roof_Thickness) - 0.6,
    "The mark is too deep for the bottom or the lid. Reduce Mark Depth.");
assert(!mark_on || (mark_extent[0] < mark_room[0] && mark_extent[1] < mark_room[1]),
    str("The maker's mark (about ", mark_extent[0], " x ", mark_extent[1], " mm) does not fit on the box (",
        mark_room[0], " x ", mark_room[1], " mm). Set Mark Size to 0 (automatic), reduce the letter spacing, or shorten the lines."));
assert(!mark_on || mark_smallest_text >= Mark_Min_Text_Size - 0.001,
    str("The maker's mark text would be ", round(mark_smallest_text*10)/10, " mm, smaller than Mark Min Text Size (",
        Mark_Min_Text_Size, " mm), and would not print. Set Mark Size to 0 (automatic) or larger, ",
        "reduce the letter spacing, or shorten the main line."));
assert(Output_Mode != "Closed" || $preview, "Closed is F5 only. Select Box, Lid, or Box and lid to export an STL.");

// Information in the Console.
if (mark_on)
    echo(str("Maker's mark: about ", round(mark_extent[0]), " x ", round(mark_extent[1]), " mm. Main line ",
             round(mark_sizes[0]*10)/10, " mm, second line ", round(mark_sizes[1]*10)/10, " mm."));
echo(str("KomaSCAD komabako ", version, ". Closed: ", outer_width, " x ", outer_depth, " x ", closed_height,
         " mm. Inside: ", inner_width, " x ", inner_depth, " x ", inner_height, " mm. Layers: ", layer_count, "."));


// ===== 4. Output ==============================================================

if (Output_Mode == "Box") color(filament_rgba(Box_Filament, Box_Color)) box();
else if (Output_Mode == "Lid") color(filament_rgba(Lid_Filament, Lid_Color)) lid();
else if (Output_Mode == "Closed") closed_box();
else {
    color(filament_rgba(Box_Filament, Box_Color)) box();
    translate([outer_width + Print_Layout_Gap, 0, 0]) color(filament_rgba(Lid_Filament, Lid_Color)) lid();
}

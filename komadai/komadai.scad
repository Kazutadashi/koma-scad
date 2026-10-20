// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD komadai: a stand for captured pieces. Tested with OpenSCAD 2021.01.
// The default settings make a low komadai for a 12 mm tabletop board.
// Units are mm unless a comment says otherwise.
// Guide and every setting: docs/komadai.md.
// Keep ../lib/ next to this file's folder.

/* [01 - Start here] */
// One komadai, or two side by side for one print.
Output_Mode = "One komadai"; // [One komadai,Pair]
// Low: a slab beside a tabletop board. Pedestal: a raised top on a tapered column.
Table_Style = "Low"; // [Low,Pedestal]

/* [02 - Largest piece] */
// mm. Length of the largest piece, from the heel to the point. The automatic top size follows it.
Piece_Length = 32; // [10:0.1:100]
// mm. Width of the largest piece at the heel.
Base_Width = 28.5; // [10:0.1:100]

/* [03 - Size] */
// mm. Width of the top. 0 = automatic, from the largest piece.
Top_Width = 0; // [0:1:300]
// mm. Depth of the top. 0 = automatic, from the largest piece.
Top_Depth = 0; // [0:1:300]
// mm. Height of the playing surface of the board. A Low komadai is this tall when Overall Height is 0.
Board_Surface_Height = 12; // [4:0.5:100]
// mm. From the table to the top surface. 0 = Board Surface Height for Low, 70 for Pedestal.
Overall_Height = 0; // [0:1:200]

/* [04 - Top] */
// mm. Thickness of the top. A Low komadai is solid, so this applies to Pedestal only.
Top_Thickness = 6; // [2:0.5:15]
// mm. Radius of the four corners.
Corner_Radius = 5; // [0:0.5:20]
// A shallow groove around the top surface, inside the edge.
Surface_Border_Groove = true;
// mm. Distance from the edge to the groove.
Groove_Inset = 7; // [2:0.5:20]
// mm. Width of the groove.
Groove_Width = 0.7; // [0.3:0.1:2]
// mm. Depth of the groove.
Groove_Depth = 0.4; // [0.1:0.1:1.5]
// mm. Height of a raised rim around the top. 0 = no rim, so that pieces slide on and off.
Edge_Lip_Height = 0; // [0:0.5:5]
// mm. Width of the rim.
Edge_Lip_Width = 2; // [1:0.5:6]

/* [05 - Pedestal] */
// mm. Thickness of the foot.
Foot_Thickness = 5; // [2:0.5:12]
// Size of the foot, as a fraction of the top.
Foot_Size_Ratio = 0.76; // [0.5:0.01:1]
// Size of the column at the foot, as a fraction of the top.
Column_Bottom_Ratio = 0.58; // [0.3:0.01:0.9]
// Size of the column under the top, as a fraction of the top.
Column_Top_Ratio = 0.48; // [0.3:0.01:0.9]

/* [06 - Filament color and layout] */
// Preview color. Custom uses Komadai Color.
Komadai_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Komadai Filament is Custom.
Komadai_Color = [0.74, 0.5, 0.24, 1];
// mm. Space between the two komadai of a Pair.
Pair_Gap = 12; // [3:1:30]

/* [Hidden] */
version = "3.5";   // the same as VERSION in komascad.py; a test checks this
$fn = 40;
epsilon = 0.02;   // overlap that keeps boolean operations clean

include <../lib/filaments.scad>
include <../lib/shapes.scad>


// ===== 1. Sizes ===============================================================

// The automatic top holds a few rows of captured pieces with room between them.
automatic_top = max(Base_Width*3.6, Piece_Length*3.2);
top_width = Top_Width > 0 ? Top_Width : automatic_top;
top_depth = Top_Depth > 0 ? Top_Depth : automatic_top;
pedestal_height = 70;   // mm. A pedestal komadai for a raised board on the floor.
overall_height = Overall_Height > 0 ? Overall_Height
    : Table_Style == "Pedestal" ? pedestal_height : Board_Surface_Height;


// ===== 2. The komadai =========================================================

module pedestal_base() {
    foot = [top_width, top_depth]*Foot_Size_Ratio;
    column_bottom = [top_width, top_depth]*Column_Bottom_Ratio;
    column_top = [top_width, top_depth]*Column_Top_Ratio;

    translate([(top_width - foot[0])/2, (top_depth - foot[1])/2, 0])
        rounded_slab([foot[0], foot[1], Foot_Thickness], min(Corner_Radius, foot[0]/8));
    // The column tapers from the foot to the top.
    hull() {
        translate([(top_width - column_bottom[0])/2, (top_depth - column_bottom[1])/2, Foot_Thickness - epsilon])
            rounded_slab([column_bottom[0], column_bottom[1], 2*epsilon], min(Corner_Radius, column_bottom[0]/8));
        translate([(top_width - column_top[0])/2, (top_depth - column_top[1])/2, overall_height - Top_Thickness - epsilon])
            rounded_slab([column_top[0], column_top[1], 2*epsilon], min(Corner_Radius, column_top[0]/8));
    }
}

module plain_komadai() {
    if (Table_Style == "Pedestal") {
        pedestal_base();
        translate([0, 0, overall_height - Top_Thickness])
            rounded_slab([top_width, top_depth, Top_Thickness], Corner_Radius);
    }
    else rounded_slab([top_width, top_depth, overall_height], Corner_Radius);
}

module surface_groove() {
    translate([Groove_Inset, Groove_Inset, overall_height - Groove_Depth]) linear_extrude(Groove_Depth + epsilon)
        rounded_ring_2d([top_width - 2*Groove_Inset, top_depth - 2*Groove_Inset], Groove_Width,
                        max(0, Corner_Radius - Groove_Inset/2));
}

module edge_lip() {
    translate([0, 0, overall_height - epsilon]) linear_extrude(Edge_Lip_Height + epsilon)
        rounded_ring_2d([top_width, top_depth], Edge_Lip_Width, Corner_Radius);
}

module komadai() {
    difference() {
        plain_komadai();
        if (Surface_Border_Groove) surface_groove();
    }
    if (Edge_Lip_Height > 0) edge_lip();
}


// ===== 3. Checks ==============================================================

assert(top_width > 2*Base_Width && top_depth > 2*Piece_Length,
    "The top must hold more than one piece in each direction. Raise Top Width and Top Depth, or set them to 0.");
assert(overall_height >= Top_Thickness, "Overall Height must be at least Top Thickness.");
assert(Table_Style != "Pedestal" || overall_height - Top_Thickness - Foot_Thickness > 1,
    "The pedestal leaves no room for a column between the foot and the top. Raise Overall Height.");
assert(!Surface_Border_Groove || Groove_Depth < Top_Thickness, "Groove Depth must be less than Top Thickness.");
assert(!Surface_Border_Groove || (Groove_Inset > Edge_Lip_Width && 2*Groove_Inset < min(top_width, top_depth)),
    "The groove does not fit on the top. Change Groove Inset.");

// Information in the Console.
echo(str("KomaSCAD komadai ", version, ". Top: ", top_width, " x ", top_depth, " mm. Height: ", overall_height, " mm."));


// ===== 4. Output ==============================================================

color(filament_rgba(Komadai_Filament, Komadai_Color)) {
    komadai();
    if (Output_Mode == "Pair") translate([top_width + Pair_Gap, 0, 0]) komadai();
}

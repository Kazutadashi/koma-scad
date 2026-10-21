// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD komadai: a stand for captured pieces. Tested with OpenSCAD 2021.01.
// The default settings make a pair of flat komadai for a 12 mm tabletop board.
// Units are mm unless a comment says otherwise.
// Guide and every setting: docs/komadai.md.
// Keep ../lib/ next to this file's folder.

/* [01 - Start here] */
// Display shows the pair standing, as on the table. One to print and Pair to print turn them top face down for the bed.
Output_Mode = "Display"; // [Display,One to print,Pair to print]
// Flat: a plate beside a tabletop board. Yagura: a top on four legs. One leg: a top on a column and foot. Use the legged styles beside a legged board.
Table_Style = "Flat"; // [Flat,Yagura,One leg]

/* [02 - Board and pieces] */
// mm. Height of the board's playing surface above the table. 12 = the bundled tabletop board.
Board_Surface_Height = 12; // [4:0.5:400]
// mm. Yagura and One leg: how far the top sits below the playing surface. Tradition: 10 to 20.
Height_Below_Board = 15; // [5:0.5:40]
// mm. Length of the largest piece, from the heel to the point. The automatic top size follows it.
Piece_Length = 32; // [10:0.1:100]
// mm. Width of the largest piece at the heel.
Base_Width = 28.5; // [10:0.1:100]

/* [03 - Top] */
// mm. Width of the top. 0 = automatic: about 120 for the bundled pieces.
Top_Width = 0; // [0:1:300]
// mm. Depth of the top. 0 = automatic.
Top_Depth = 0; // [0:1:300]
// mm. Flat only: thickness of the plate. Keep it below the board surface.
Flat_Thickness = 6; // [2:0.5:40]
// mm. Yagura and One leg: thickness of the top.
Top_Thickness = 12; // [4:0.5:40]
// mm. Radius of the four corners.
Corner_Radius = 1.5; // [0:0.5:20]
// mm. 45 degree chamfer (面取り) round the top and bottom edges of the top.
Edge_Chamfer = 1.2; // [0:0.1:4]
// A thin groove inside the edge of the top. Tradition: plain.
Surface_Border_Groove = false;
// mm. Distance from the edge to the groove.
Groove_Inset = 7; // [2:0.5:20]
// mm. Width of the groove.
Groove_Width = 0.9; // [0.3:0.1:2]
// mm. Depth of the groove.
Groove_Depth = 0.4; // [0.1:0.1:1.5]

/* [04 - Legs] */
// mm. Yagura: width of each square leg at the top.
Leg_Width = 16; // [8:0.5:40]
// Yagura: width of each leg at the foot, as a fraction of its width at the top.
Leg_Taper = 0.85; // [0.5:0.01:1]
// mm. Yagura: distance from the edge of the top to each leg.
Leg_Inset = 8; // [0:0.5:40]
// Yagura: stretchers (貫, nuki) that tie the legs together near the foot. They make the stand stiffer.
Stretchers = true;
// mm. Yagura: height of the stretchers above the table.
Stretcher_Height = 30; // [5:1:200]
// One leg: width of the column under the top, as a fraction of the top.
Column_Top_Ratio = 0.3; // [0.15:0.01:0.6]
// One leg: width of the column at the foot, as a fraction of the top.
Column_Bottom_Ratio = 0.36; // [0.15:0.01:0.6]
// One leg: width of the foot, as a fraction of the top.
Foot_Size_Ratio = 0.8; // [0.4:0.01:1]
// mm. One leg: thickness of the foot plate.
Foot_Thickness = 8; // [3:0.5:20]

/* [05 - Maker's mark] */
// The mark (銘), cut into the underside of the top. Empty = no mark.
Signature_Text = "";
// An installed font. Find its exact name in Help > Font List.
Signature_Font = "Liberation Sans:style=Regular";
// mm. Text size of the mark.
Signature_Font_Size = 5; // [2:0.1:12]
// mm. Depth of the mark.
Signature_Depth = 0.4; // [0.2:0.1:1]

/* [06 - Filament color and layout] */
// Color. Kaya matches the bundled board. Custom uses Komadai Color.
Komadai_Filament = "Kaya"; // [Kaya,Kuwa,Kurogaki,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Komadai Filament is Custom.
Komadai_Color = [0.74, 0.5, 0.24, 1];
// mm. Space between the two komadai of a pair.
Pair_Gap = 12; // [3:1:30]
// mm. The tallest part your printer can make. A legged komadai prints in one piece, top face down.
Print_Height = 256; // [100:1:1000]

/* [Hidden] */
version = "3.5";   // the same as VERSION in komascad.py; a test checks this
$fn = 40;
epsilon = 0.02;   // overlap that keeps boolean operations clean

include <../lib/filaments.scad>
include <../lib/shapes.scad>


// ===== 1. Sizes ===============================================================
// The komadai stands with its underside at z = 0 and its top face up.

// A traditional top is about 12 cm square: room for a few rows of captured pieces.
automatic_top = max(Base_Width*4.2, Piece_Length*3.75);
top_width = Top_Width > 0 ? Top_Width : automatic_top;
top_depth = Top_Depth > 0 ? Top_Depth : automatic_top;
flat = Table_Style == "Flat";
// A legged komadai sits a little below the playing surface, so that the
// captured pieces sit at or below the pieces on the board.
overall_height = flat ? Flat_Thickness : Board_Surface_Height - Height_Below_Board;
top_thickness = flat ? Flat_Thickness : Top_Thickness;
leg_height = overall_height - top_thickness;


// ===== 2. The komadai =========================================================

// The mark under the top, mirrored so that it reads from below. On a One leg
// komadai it goes beside the column, toward the front.
module signature_cut() {
    one_leg_offset = Table_Style == "One leg" ? -(top_depth*Column_Top_Ratio + top_depth)/4 : 0;
    if (Signature_Text != "")
        translate([top_width/2, top_depth/2 + one_leg_offset, -epsilon]) linear_extrude(Signature_Depth + epsilon)
            mirror([1, 0, 0]) text(Signature_Text, size=Signature_Font_Size, font=Signature_Font,
                                   halign="center", valign="center");
}

module top() {
    translate([0, 0, overall_height - top_thickness]) difference() {
        chamfered_slab([top_width, top_depth, top_thickness], Corner_Radius, Edge_Chamfer, Edge_Chamfer);
        signature_cut();
        if (Surface_Border_Groove)
            translate([Groove_Inset, Groove_Inset, top_thickness - Groove_Depth]) linear_extrude(Groove_Depth + epsilon)
                rounded_ring_2d([top_width - 2*Groove_Inset, top_depth - 2*Groove_Inset], Groove_Width,
                                max(0, Corner_Radius - Groove_Inset/2));
    }
}

// Four square legs that taper toward the foot.
module yagura_legs() {
    for (x = [Leg_Inset, top_width - Leg_Inset - Leg_Width], y = [Leg_Inset, top_depth - Leg_Inset - Leg_Width])
        translate([x + Leg_Width/2, y + Leg_Width/2, 0])
            linear_extrude(leg_height + epsilon, scale=1/Leg_Taper)
                square(Leg_Width*Leg_Taper, center=true);
}

// The stretchers: one beam between each pair of neighboring legs. The top of
// each beam is a 45 degree ridge, so that it grows out of the legs without
// supports when the komadai prints top face down.
module stretchers() {
    beam = Leg_Width*0.45;
    near = Leg_Inset + Leg_Width/2;
    // One beam along +x from the origin, its bottom at z = 0.
    module beam_along_x(length) {
        // Takes the profile's x across the beam (to y) and its y up (to z).
        multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 0, 1]]) linear_extrude(length)
            polygon([[-beam/2, 0], [beam/2, 0], [beam/2, beam], [0, 1.5*beam], [-beam/2, beam]]);
    }
    for (y = [near, top_depth - near])
        translate([near, y, Stretcher_Height]) beam_along_x(top_width - 2*near);
    for (x = [near, top_width - near])
        translate([x, near, Stretcher_Height]) rotate([0, 0, 90]) beam_along_x(top_depth - 2*near);
}

// A tapered column on a foot plate. The column meets the foot with a 45
// degree flare, so that the foot prints without supports when the komadai
// prints top face down.
module one_leg() {
    center = [top_width/2, top_depth/2];
    column_bottom = top_width*Column_Bottom_Ratio;
    column_top = top_width*Column_Top_Ratio;
    foot = [top_width, top_depth]*Foot_Size_Ratio;
    flare = (min(foot) - column_bottom)/2;

    translate([center[0] - foot[0]/2, center[1] - foot[1]/2, 0])
        chamfered_slab([foot[0], foot[1], Foot_Thickness], Corner_Radius, Edge_Chamfer, 0);
    hull() {
        translate([center[0], center[1], Foot_Thickness - epsilon]) linear_extrude(epsilon)
            square([foot[0] - 2*Edge_Chamfer, foot[1] - 2*Edge_Chamfer], center=true);
        translate([center[0], center[1], Foot_Thickness + flare]) linear_extrude(epsilon)
            square(column_bottom, center=true);
    }
    translate([center[0], center[1], Foot_Thickness + flare])
        linear_extrude(leg_height - Foot_Thickness - flare + epsilon, scale=column_top/column_bottom)
            square(column_bottom, center=true);
}

module komadai() {
    top();
    if (Table_Style == "Yagura") yagura_legs();
    if (Table_Style == "Yagura" && Stretchers) stretchers();
    if (Table_Style == "One leg") one_leg();
}

// Turns the komadai over, top face down, for the smoothest top.
module on_bed() { translate([0, top_depth, overall_height]) rotate([180, 0, 0]) children(); }


// ===== 3. Checks ==============================================================

assert(top_width > 2*Base_Width && top_depth > 2*Piece_Length,
    "The top must hold more than one piece in each direction. Raise Top Width and Top Depth, or set them to 0.");
assert(!flat || Flat_Thickness < Board_Surface_Height,
    "A flat komadai must be lower than the playing surface. Reduce Flat Thickness.");
assert(flat || leg_height > 10,
    str("A ", Table_Style, " komadai needs Board Surface Height at least ", Top_Thickness + Height_Below_Board + 10,
        " mm: the height of your legged board's playing surface above the table."));
assert(Output_Mode == "Display" || overall_height <= Print_Height,
    str("The komadai is ", overall_height, " mm tall, more than the ", Print_Height, " mm that your printer can make. ",
        "A taller printer is needed for this board."));
assert(Table_Style != "Yagura" || !Stretchers || Stretcher_Height + 1.5*Leg_Width*0.45 < leg_height,
    "The stretchers are higher than the legs. Lower Stretcher Height.");
assert(2*Edge_Chamfer < top_thickness, "Edge Chamfer is too large for the top.");
assert(Signature_Text == "" || Signature_Depth < top_thickness/2, "The mark is too deep for the top. Reduce Signature Depth.");
assert(!Surface_Border_Groove || (Groove_Depth < top_thickness && 2*Groove_Inset < min(top_width, top_depth)),
    "The groove does not fit on the top. Change Groove Inset or Groove Depth.");
assert(Table_Style != "Yagura" || 2*(Leg_Inset + Leg_Width) < min(top_width, top_depth),
    "The legs do not fit under the top. Reduce Leg Width or Leg Inset.");
assert(Table_Style != "One leg" || leg_height > Foot_Thickness + (min(top_width, top_depth)*(Foot_Size_Ratio - Column_Bottom_Ratio))/2,
    "The column is too short for the foot and its flare. Raise Board Surface Height, or reduce Foot Size Ratio.");

// Information in the Console.
echo(str("KomaSCAD komadai ", version, ". ", Table_Style, ". Top: ", top_width, " x ", top_depth,
         " mm. Height: ", overall_height, " mm, ", Board_Surface_Height - overall_height, " mm below the board."));


// ===== 4. Output ==============================================================

color(filament_rgba(Komadai_Filament, Komadai_Color)) {
    if (Output_Mode == "One to print") on_bed() komadai();
    else if (Output_Mode == "Pair to print") {
        on_bed() komadai();
        translate([top_width + Pair_Gap, 0, 0]) on_bed() komadai();
    }
    else {
        komadai();
        translate([top_width + Pair_Gap, 0, 0]) komadai();
    }
}

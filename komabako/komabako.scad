// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD komabako: a box with a lift-off lid for a set of pieces. Tested with OpenSCAD 2021.01.
// The default settings make a box for the 40 pieces of a shogi set.
// Units are mm unless a comment says otherwise.
// Guide and every setting: docs/komabako.md.
// Keep ../lib/ next to this file's folder.

/* [01 - Start here] */
// Box and Lid are one part each. Box and lid puts both on one bed. Closed shows the lid in place (F5 only).
Output_Mode = "Box and lid"; // [Box and lid,Box,Lid,Closed]

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
// mm. Inside height. 0 = automatic, from the layers.
Inner_Height = 0; // [0:1:300]

/* [04 - Box] */
// mm. Thickness of the side walls.
Wall_Thickness = 3; // [1.2:0.2:8]
// mm. Thickness of the bottom.
Bottom_Thickness = 3; // [1.2:0.2:8]
// mm. Radius of the outside corners.
Corner_Radius = 5; // [0:0.5:15]

/* [05 - Lid] */
// mm. Space on each side between the box and the lid. Raise it if the lid is tight.
Lid_Clearance = 0.3; // [0.05:0.05:1]
// mm. Thickness of the lid walls.
Lid_Skirt_Thickness = 2.4; // [1.2:0.2:6]
// mm. How far the lid walls come down the box.
Lid_Skirt_Height = 9; // [3:0.5:20]
// mm. Thickness of the lid top.
Lid_Roof_Thickness = 3; // [1.2:0.2:8]

/* [06 - Filament colors and layout] */
// Box color. Custom uses Box Color.
Box_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Lid color. Custom uses Lid Color.
Lid_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
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


// ===== 1. Sizes ===============================================================

layer_count = ceil(Piece_Count/Pieces_Per_Layer);
// The automatic floor fits about ten loose pieces side by side.
automatic_inside = max(Base_Width*3.3, Piece_Length*3);
inner_width = Inner_Width > 0 ? Inner_Width : automatic_inside;
inner_depth = Inner_Depth > 0 ? Inner_Depth : automatic_inside;
inner_height = Inner_Height > 0 ? Inner_Height : layer_count*Rear_Thickness*Packing_Factor + Headroom;
outer_width = inner_width + 2*Wall_Thickness;
outer_depth = inner_depth + 2*Wall_Thickness;
box_height = inner_height + Bottom_Thickness;
lid_opening = [outer_width, outer_depth] + 2*[Lid_Clearance, Lid_Clearance];
lid_width = lid_opening[0] + 2*Lid_Skirt_Thickness;
lid_depth = lid_opening[1] + 2*Lid_Skirt_Thickness;
lid_height = Lid_Roof_Thickness + Lid_Skirt_Height;


// ===== 2. Box and lid =========================================================

module box() {
    difference() {
        rounded_slab([outer_width, outer_depth, box_height], Corner_Radius);
        translate([Wall_Thickness, Wall_Thickness, Bottom_Thickness])
            rounded_slab([inner_width, inner_depth, inner_height + epsilon], max(0, Corner_Radius - Wall_Thickness));
    }
}

// The lid is drawn top down, so that it prints without supports.
module lid() {
    difference() {
        rounded_slab([lid_width, lid_depth, lid_height], Corner_Radius + Lid_Skirt_Thickness);
        translate([Lid_Skirt_Thickness, Lid_Skirt_Thickness, Lid_Roof_Thickness])
            rounded_slab([lid_opening[0], lid_opening[1], Lid_Skirt_Height + epsilon], Corner_Radius + Lid_Clearance);
    }
}

module closed_box() {
    color(filament_rgba(Box_Filament, Box_Color)) box();
    // Turn the lid over and lower it onto the box.
    color(filament_rgba(Lid_Filament, Lid_Color))
        translate([-Lid_Skirt_Thickness - Lid_Clearance, outer_depth + Lid_Skirt_Thickness + Lid_Clearance,
                   box_height + lid_height])
            rotate([180, 0, 0]) lid();
}


// ===== 3. Checks ==============================================================

assert(inner_width > Base_Width && inner_depth > Piece_Length,
    "The inside must be larger than the largest piece. Raise Inner Width and Inner Depth, or set them to 0.");
assert(inner_height > Rear_Thickness, "The inside must be taller than the largest piece. Raise Inner Height, or set it to 0.");
assert(Output_Mode != "Closed" || $preview, "Closed is F5 only. Select Box, Lid, or Box and lid to export an STL.");

// Information in the Console.
echo(str("KomaSCAD komabako ", version, ". Box: ", outer_width, " x ", outer_depth, " x ", box_height,
         " mm. Inside: ", inner_width, " x ", inner_depth, " x ", inner_height, " mm. Layers: ", layer_count, "."));


// ===== 4. Output ==============================================================

if (Output_Mode == "Box") color(filament_rgba(Box_Filament, Box_Color)) box();
else if (Output_Mode == "Lid") color(filament_rgba(Lid_Filament, Lid_Color)) lid();
else if (Output_Mode == "Closed") closed_box();
else {
    color(filament_rgba(Box_Filament, Box_Color)) box();
    translate([outer_width + Print_Layout_Gap, 0, 0]) color(filament_rgba(Lid_Filament, Lid_Color)) lid();
}

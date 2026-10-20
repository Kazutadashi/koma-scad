// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD ban: a parametric shogi board. Tested with OpenSCAD 2021.01.
// The default settings make a one-piece 9 x 9 board with Japan Shogi Association squares.
// Units are mm and degrees unless a comment says otherwise.
// Guide and every setting: docs/ban.md.
// Keep ban.json next to this file, and ../lib/ next to its folder.

/* [01 - Start here] */
// A label for your own use. It does not change the board.
Category = "Shogi";
// Assembled board shows every panel in place. One panel and All panels show the parts to print. Use komascad.py ban for a color 3MF.
Output_Mode = "Assembled board"; // [Assembled board,One panel,All panels]
// The column of the panel that One panel shows, counted from 0 at the left.
Panel_X = 0; // [0:1:100]
// The row of the panel that One panel shows, counted from 0 at the front.
Panel_Y = 0; // [0:1:100]
// How the panels sit on the print bed. Face down gives the smoothest playing surface.
Print_Orientation = "Playing face down"; // [Playing face down,Playing face up]

/* [02 - Board] */
// Squares from left to right.
Playing_Columns = 9; // [1:1:100]
// Squares from front to back.
Playing_Rows = 9; // [1:1:100]
// mm. Width of one square. 35.4 is the Japan Shogi Association board.
Cell_Width = 35.4; // [20:0.1:100]
// mm. Depth of one square, front to back. 38.7 is the Japan Shogi Association board.
Cell_Depth = 38.7; // [20:0.1:120]
// mm. Border around the grid on each edge.
Board_Margin = 15; // [0:0.5:50]
// mm. From the underside to the playing surface.
Board_Thickness = 12; // [2:0.5:40]
// mm. Radius of the four outer corners.
Outer_Corner_Radius = 3; // [0:0.5:15]

/* [03 - Largest piece] */
// mm. Length of the largest piece that the squares must hold, from the heel to the point.
Piece_Length = 32; // [10:0.1:100]
// mm. Width of the largest piece at the heel.
Base_Width = 28.5; // [10:0.1:100]

/* [04 - Printed panels] */
// Panels from left to right. 1 x 1 is a one-piece board. Seams follow grid lines, so each panel holds whole squares.
Panel_Columns = 1; // [1:1:100]
// Panels from front to back.
Panel_Rows = 1; // [1:1:100]
// mm. Space between the panels in All panels.
Print_Layout_Gap = 10; // [2:1:30]

/* [05 - Markings] */
// mm. Width of the grid lines.
Grid_Groove_Width = 0.55; // [0.2:0.05:2]
// mm. Depth of the grid grooves.
Grid_Groove_Depth = 0.45; // [0.1:0.05:2]
// mm. How far the top of the line color sits below the playing surface.
Line_Recess = 0.08; // [0:0.02:0.3]
// Four dots where the lines one third in from each side cross.
Camp_Dots = true;
// mm. Diameter of each camp dot.
Camp_Dot_Diameter = 2.4; // [1:0.1:6]

/* [06 - Filament colors] */
// Board color. It becomes a named material in the color 3MF. Custom uses Board Color.
Board_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Color of the grid lines and camp dots. Custom uses Line Color.
Line_Filament = "Black"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Board Filament is Custom.
Board_Color = [0.82, 0.63, 0.34, 1];
// [red, green, blue, opacity], 0 to 1. Used when Line Filament is Custom.
Line_Color = [0.01, 0.01, 0.01, 1];

/* [07 - Joint fit] */
// The joint only keeps panels together and in line. The table sets their height. T-hook is for boards on a flat table.
Joint_Style = "Dovetail"; // [Dovetail,T-hook]
// mm. Space between each tab side and its socket. Each panel must drop into place under its own weight. Raise this if one does not.
Joint_Clearance = 0.3; // [0.1:0.05:1]
// mm. Gap above each tab at the seam. The T-hook socket roof is flat, so sideways play cannot close this gap.
Joint_Roof_Clearance = 1; // [0.5:0.1:3]
// mm. 45 degree bevel on the top edge of each seam. It takes up first-layer squish, so the seam closes at the playing surface.
Seam_Bevel = 0.3; // [0:0.05:1]
// mm. Space around a camp dot where a seam goes around it.
Camp_Dot_Plug_Clearance = 0.2; // [0:0.05:0.6]

/* [08 - Joint shape] */
// mm. Width of the tab neck at the seam. The T-hook head is wider by T Head Overhang on each side.
Joint_Width = 12; // [4:0.5:30]
// mm. How far a tab reaches past the seam.
Joint_Depth = 5; // [2:0.5:15]
// mm. Gap between each tab and the table. The socket is open below the tab, so nothing pushes a tab up or down.
Joint_Floor_Gap = 1; // [0.5:0.1:4]
// mm. Tab thickness at the seam. 0 = as thick as the board allows. The top falls at 45 degrees to the tip, so the tab prints without supports.
Joint_Thickness = 0; // [0:0.5:30]
// mm. Chamfer around the underside of each tab. On T-hook panels, also the bevel on every underside edge and on the socket mouth.
Joint_Bottom_Chamfer = 1; // [0:0.1:3]
// Degrees. Dovetail only: angle of each tab side from straight across the seam. More = a pulled seam opens less.
Joint_Flank_Angle = 45; // [15:1:45]
// mm. Approximate distance between tabs on a long seam. Each seam has at least two tabs.
Joint_Spacing = 60; // [25:5:150]
// mm. Preferred distance from a tab to a panel corner.
Joint_Edge_Margin = 20; // [5:1:50]
// mm. T-hook only: how far the head extends on each side of the neck.
T_Head_Overhang = 2.5; // [1:0.5:5]
// mm. T-hook only: distance from the seam to the retaining shoulders.
T_Shoulder_Length = 2; // [1:0.5:5]
// mm. T-hook only: extra clearance along the seam at each socket after the first on an edge.
T_Spacing_Relief = 0.4; // [0:0.05:1]
// mm. T-hook only: extra clearance on each side of the socket neck. The head keeps Joint Clearance.
T_Neck_Relief = 0.3; // [0:0.05:0.8]

/* [09 - Maker signature on underside] */
// The mark, cut into the underside of panel 0, 0. Empty = no mark.
Signature_Text = "";
// An installed font. Find its exact name in Help > Font List.
Signature_Font = "Liberation Sans:style=Regular";
// mm. Text size of the mark.
Signature_Font_Size = 3.5; // [2:0.1:8]
// mm. Depth of the mark into the underside.
Signature_Depth = 0.4; // [0.2:0.1:1]

/* [Hidden] */
// komascad.py sets this to read the panels, materials and fonts without making geometry.
Export_Metadata = false;

version = "3.5";   // the same as VERSION in komascad.py; a test checks this
$fn = 36;
epsilon = 0.02;   // overlap that keeps boolean operations clean

include <../lib/filaments.scad>
include <../lib/shapes.scad>


// ===== 1. Board plan ==========================================================
// x runs from left to right and y from front to back, with the origin at the
// front-left corner of the grid. A panel is addressed as (tx, ty) from 0.

columns = Playing_Columns;
rows = Playing_Rows;
play_width = columns*Cell_Width;
play_depth = rows*Cell_Depth;
board_width = play_width + 2*Board_Margin;
board_depth = play_depth + 2*Board_Margin;
panel_count = Panel_Columns*Panel_Rows;
seams_exist = panel_count > 1;
line_height = Grid_Groove_Depth - Line_Recess;
face_down = Print_Orientation == "Playing face down";

// Panel boundaries in whole squares, spread as evenly as possible.
function first_column(tx) = round(tx*columns/Panel_Columns);
function last_column(tx) = round((tx + 1)*columns/Panel_Columns);
function first_row(ty) = round(ty*rows/Panel_Rows);
function last_row(ty) = round((ty + 1)*rows/Panel_Rows);

// A seam runs along the right or back edge of a grid line, never through its
// middle. The whole line stays in one panel, and the seam gap merges into it.
function column_seam_x(column) = column*Cell_Width + Grid_Groove_Width/2;
function row_seam_y(row) = row*Cell_Depth + Grid_Groove_Width/2;
function tile_x_min(tx) = tx == 0 ? -Board_Margin : column_seam_x(first_column(tx));
function tile_x_max(tx) = tx == Panel_Columns - 1 ? play_width + Board_Margin : column_seam_x(last_column(tx));
function tile_y_min(ty) = ty == 0 ? -Board_Margin : row_seam_y(first_row(ty));
function tile_y_max(ty) = ty == Panel_Rows - 1 ? play_depth + Board_Margin : row_seam_y(last_row(ty));
function tile_width(tx) = tile_x_max(tx) - tile_x_min(tx);
function tile_depth(ty) = tile_y_max(ty) - tile_y_min(ty);

// A panel owns the grid lines inside it and the line on its right or back seam.
function owns_column(tx, column) = column <= last_column(tx) && (tx == 0 || column > first_column(tx));
function owns_row(ty, row) = row <= last_row(ty) && (ty == 0 || row > first_row(ty));

// A camp dot is wider than a line, so a seam beside the line would cut it.
// The panel that owns the dot keeps all of it on a round plug, and its
// neighbors get a matching notch: the seam goes around the dot.
camp_dots_on = Camp_Dots && columns >= 3 && rows >= 3;
camp_dots = camp_dots_on
    ? [for (x = [floor(columns/3), columns - floor(columns/3)], y = [floor(rows/3), rows - floor(rows/3)]) [x, y]]
    : [];
function owns_dot(tx, ty, dot) = owns_column(tx, dot[0]) && owns_row(ty, dot[1]);
dot_plug_clearance = seams_exist ? Camp_Dot_Plug_Clearance : 0;
seam_bevel = seams_exist ? Seam_Bevel : 0;

// The two printed parts. The color 3MF has one part for each role.
role_names = ["body", "markings"];
function material_name(role) =
    let(filament = [Board_Filament, Line_Filament][role])
    filament == "Custom" ? str("Custom ", role_names[role]) : filament;
function material_rgb(role) = filament_rgba([Board_Filament, Line_Filament][role], [Board_Color, Line_Color][role]);


// ===== 2. Joint plan ==========================================================
// Each joint closes when a panel moves straight down: only that motion lets
// the last panel of a closed grid go in. The tab sides have a slip fit, and
// the tab floats over a socket that is open below. The joint holds panels
// together and in line; the table sets their height.

socket_skin = 1;   // mm of board between a socket roof and the floor of a grid groove
tab_bottom = Joint_Floor_Gap;
tab_thickness = Joint_Thickness > 0 ? Joint_Thickness
    : Board_Thickness - Grid_Groove_Depth - socket_skin - Joint_Roof_Clearance - Joint_Floor_Gap;
// The top of the tab at the seam. The top face falls at 45 degrees from here.
tab_seam_height = tab_bottom + tab_thickness;
// The height of the vertical tip face, below the bottom chamfer.
tab_tip_height = tab_thickness - Joint_Depth - Joint_Bottom_Chamfer;
// The two far corners of a T-hook head become very thin where the sloped roof
// meets the underside chamfer. Clip only those corners, to keep 0.6 mm there.
t_tip_corner_clip = max(0, Joint_Depth + T_Head_Overhang - (tab_thickness - Joint_Bottom_Chamfer - 0.6));
socket_roof_height = tab_seam_height + Joint_Roof_Clearance;
tip_clearance = 0.4;   // mm beyond each tab tip, so the seam faces always meet first
socket_reach = Joint_Depth + tip_clearance;
socket_lead_in = 0.6;   // mm chamfer around a dovetail socket mouth, so a tab finds its socket
t_mouth_bevel = max(0.5, Joint_Bottom_Chamfer + 0.2);   // so the mouth slope is not on the underside bevel
function dovetail_half_width(x) = Joint_Width/2 + x*tan(Joint_Flank_Angle);
// How far a socket reaches along and across its seam. A tab must stay this far
// from a corner, so that it does not meet the socket on the other seam.
socket_half_width = Joint_Style == "Dovetail"
    ? dovetail_half_width(socket_reach) + Joint_Clearance + socket_lead_in
    : Joint_Width/2 + max(T_Head_Overhang, T_Neck_Relief) + Joint_Clearance + T_Spacing_Relief + t_mouth_bevel;
socket_extent = Joint_Style == "Dovetail"
    ? socket_reach + Joint_Clearance + socket_lead_in
    : Joint_Depth + Joint_Clearance + t_mouth_bevel;
// How far a seam opens when the panels are pulled apart.
seam_play = Joint_Style == "Dovetail" ? Joint_Clearance/sin(Joint_Flank_Angle) : Joint_Clearance;
function joint_margin(span) = min(Joint_Edge_Margin, span/3);
function joint_count(span) = max(2, floor((span - 2*joint_margin(span))/Joint_Spacing) + 1);
function joint_position(index, count, span) = joint_margin(span) + index*(span - 2*joint_margin(span))/(count - 1);
// The shortest seam on the board. It must still hold two tabs.
shortest_seam = min(concat(
    Panel_Columns > 1 ? [for (ty = [0:Panel_Rows - 1]) tile_depth(ty)] : [],
    Panel_Rows > 1 ? [for (tx = [0:Panel_Columns - 1]) tile_width(tx)] : [],
    [1e9]));


// ===== 3. Joints ==============================================================
// The tab and socket shapes have the seam on the y axis and reach into +x.
//
// Tabs and sockets are convex, so each is the hull of a few thin slices, not
// an intersection. OpenSCAD's preview shows hulls correctly, but shows
// intersections cut from a panel as see-through holes.

// The dovetail outline, reach mm into +x and clearance mm larger all round.
// root carries it back into its own panel, so that it always joins the panel.
module dovetail_2d(reach, clearance=0, root=1) {
    offset(delta=clearance) polygon([
        [-root, -dovetail_half_width(-root)], [reach, -dovetail_half_width(reach)],
        [reach, dovetail_half_width(reach)], [-root, dovetail_half_width(-root)]]);
}

// A thin horizontal slice of a 2D outline, with its underside at z.
module slice(z) { translate([0, 0, z]) linear_extrude(epsilon) children(); }

// The part of a dovetail behind the seam (x <= 0), where the top is level.
module behind_seam_2d(reach, clearance) {
    intersection() { dovetail_2d(reach, clearance); translate([-100, -100]) square([100, 200]); }
}
// The far edge of a dovetail, where the 45 degree top face ends.
module far_edge_2d(reach, clearance) {
    intersection() { dovetail_2d(reach, clearance); translate([reach + clearance - epsilon, -100]) square([1, 200]); }
}

// A dovetail tab. It floats Joint Floor Gap above the table, with a 45 degree
// chamfer round its underside that guides it into its socket.
module dovetail_tab() {
    hull() {
        slice(tab_bottom) offset(delta=-Joint_Bottom_Chamfer) dovetail_2d(Joint_Depth);
        slice(tab_bottom + Joint_Bottom_Chamfer) dovetail_2d(Joint_Depth);
        slice(tab_seam_height - epsilon) behind_seam_2d(Joint_Depth, 0);
        slice(tab_seam_height - Joint_Depth - epsilon) far_edge_2d(Joint_Depth, 0);
    }
}

// A dovetail socket, cut from the panel at x > 0. It is open through the
// underside, and its roof follows the tab's top face Joint Roof Clearance higher.
module dovetail_socket(clearance=Joint_Clearance) {
    far = socket_reach + clearance;
    hull() {
        slice(-epsilon) dovetail_2d(socket_reach, clearance);
        slice(socket_roof_height - epsilon) behind_seam_2d(socket_reach, clearance);
        slice(socket_roof_height - far - epsilon) far_edge_2d(socket_reach, clearance);
    }
    hull() {
        slice(-epsilon) dovetail_2d(socket_reach, clearance + socket_lead_in);
        slice(socket_lead_in) dovetail_2d(socket_reach, clearance);
    }
}

// The T-hook is two overlapping rectangles: the neck, and the head. Its square
// shoulders hold across the seam.
module t_rectangle(head=false, clearance=0, relief=0, neck_relief=0) {
    x0 = head ? T_Shoulder_Length - clearance : -1 - clearance;
    x1 = head ? Joint_Depth + clearance : T_Shoulder_Length + clearance;
    half_width = Joint_Width/2 + (head ? T_Head_Overhang : neck_relief) + clearance + relief;
    translate([x0, -half_width]) square([x1 - x0, 2*half_width]);
}
module t_outline(clearance=0, relief=0, neck_relief=0) {
    for (head = [false, true]) t_rectangle(head, clearance, relief, neck_relief);
}

// The tab keeps the full head width at the shoulders. Only the two corners
// furthest from the seam are clipped (see t_tip_corner_clip).
module t_tab_part(head=false) {
    half_width = Joint_Width/2 + T_Head_Overhang;
    if (!head || t_tip_corner_clip <= 0) t_rectangle(head);
    else polygon([
        [T_Shoulder_Length, -half_width], [Joint_Depth - t_tip_corner_clip, -half_width],
        [Joint_Depth, -half_width + t_tip_corner_clip], [Joint_Depth, half_width - t_tip_corner_clip],
        [Joint_Depth - t_tip_corner_clip, half_width], [T_Shoulder_Length, half_width]]);
}
module t_tab_outline() { for (head = [false, true]) t_tab_part(head); }

// A 45 degree roof that prints without supports: once across the seam, and
// once along each side of the head. The socket roof stays flat.
module t_roof_wedge(top) {
    rotate([90, 0, 0]) linear_extrude(100, center=true)
        polygon([[-10, -50], [20, -50], [20, top - 20], [0, top], [-10, top]]);
}
module t_below_roof(top) {
    intersection() {
        t_roof_wedge(top);
        multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [0, -1, 1, Joint_Width/2], [0, 0, 0, 1]]) t_roof_wedge(top);
        multmatrix([[1, 0, 0, 0], [0, 1, 0, 0], [0, 1, 1, Joint_Width/2], [0, 0, 0, 1]]) t_roof_wedge(top);
    }
}

module t_tab() {
    intersection() {
        union() {
            translate([0, 0, tab_bottom + Joint_Bottom_Chamfer]) linear_extrude(Board_Thickness) t_tab_outline();
            // Chamfer the neck and the head separately, so that the shoulders stay square above the chamfer.
            for (head = [false, true]) hull() {
                translate([0, 0, tab_bottom]) linear_extrude(epsilon)
                    offset(delta=-Joint_Bottom_Chamfer) t_tab_part(head);
                translate([0, 0, tab_bottom + Joint_Bottom_Chamfer]) linear_extrude(epsilon) t_tab_part(head);
            }
        }
        t_below_roof(tab_seam_height);
    }
}

// A flat roof keeps Joint Roof Clearance at the limits of sideways play. The
// face-down playing surface under it supports it in printing.
module t_socket(relief=0) {
    translate([0, 0, -epsilon]) linear_extrude(socket_roof_height + epsilon)
        t_outline(Joint_Clearance, relief, T_Neck_Relief);
    // Flare only the open underside, below the seated tab.
    for (head = [false, true]) hull() {
        translate([0, 0, -epsilon]) linear_extrude(epsilon)
            t_rectangle(head, Joint_Clearance + t_mouth_bevel, relief, T_Neck_Relief);
        translate([0, 0, t_mouth_bevel]) linear_extrude(epsilon)
            t_rectangle(head, Joint_Clearance, relief, T_Neck_Relief);
    }
}

// One tab, or one socket. The first T-hook socket on an edge sets the panel's
// position along the seam. The others get T Spacing Relief, so that small
// spacing errors do not bind the whole edge.
module joint(socket, index=0) {
    if (Joint_Style == "T-hook") {
        if (socket) t_socket(index == 0 ? 0 : T_Spacing_Relief);
        else t_tab();
    }
    else if (socket) dovetail_socket();
    else dovetail_tab();
}

// The joints along one edge. A vertical edge runs along y at x = at, the others along x at y = at.
module edge_joints(span, at, vertical, socket) {
    count = joint_count(span);
    for (i = [0:count - 1]) {
        if (vertical) translate([at, joint_position(i, count, span), 0]) joint(socket, i);
        else translate([joint_position(i, count, span), at, 0]) rotate([0, 0, 90]) joint(socket, i);
    }
}

// A 45 degree bevel along the top of a seam: seam on the y axis, panel at
// x > 0, length mm long and centered on the origin.
module seam_bevel_cut(length, bevel=seam_bevel, top=Board_Thickness) {
    if (bevel > 0) rotate([90, 0, 0]) linear_extrude(length, center=true)
        polygon([[-epsilon, top - bevel - epsilon], [-epsilon, top + epsilon], [bevel + epsilon, top + epsilon]]);
}

// A bevel along the bottom of a panel edge, on the panel's +x side. It leaves
// room for small bulges on the first layers without opening the playing seam.
module underside_bevel_cut(length, bevel=Joint_Bottom_Chamfer) {
    if (bevel > 0) rotate([90, 0, 0]) linear_extrude(length, center=true)
        polygon([[-epsilon, -epsilon], [bevel + epsilon, -epsilon], [-epsilon, bevel + epsilon]]);
}


// ===== 4. Panels ==============================================================
// Each module draws one panel in its own coordinates: the front-left corner of
// the panel is at the origin and the underside is at z = 0.

// The mark on the underside of panel 0, 0. It is mirrored, so that it reads
// correctly when you turn the board over.
module signature_cut(tx, ty) {
    if (tx == 0 && ty == 0 && Signature_Text != "")
        translate([tile_width(tx)/2, tile_depth(ty)/2, -epsilon]) linear_extrude(Signature_Depth + epsilon)
            mirror([0, 1, 0]) text(Signature_Text, size=Signature_Font_Size, font=Signature_Font,
                                   halign="center", valign="center");
}

module at_dot(dot, x_min, y_min, z=0) {
    translate([dot[0]*Cell_Width - x_min, dot[1]*Cell_Depth - y_min, z]) children();
}

// The outline of a panel from z0 to z0 + height: its rectangle, the plugs of
// the camp dots that it owns, and notches for its neighbors' dots.
module tile_footprint(tx, ty, z0, height) {
    difference() {
        union() {
            translate([0, 0, z0]) cube([tile_width(tx), tile_depth(ty), height]);
            for (dot = camp_dots) if (owns_dot(tx, ty, dot))
                at_dot(dot, tile_x_min(tx), tile_y_min(ty), z0) cylinder(d=Camp_Dot_Diameter, h=height);
        }
        foreign_dot_notches(tx, ty, z0, height);
    }
}

module foreign_dot_notches(tx, ty, z0=0, height=Board_Thickness) {
    for (dot = camp_dots) if (!owns_dot(tx, ty, dot))
        at_dot(dot, tile_x_min(tx), tile_y_min(ty), z0 - epsilon)
            cylinder(d=Camp_Dot_Diameter + 2*dot_plug_clearance, h=height + 2*epsilon);
}

// The grid grooves and camp dots that a panel owns. A line on the panel's
// right or back seam runs epsilon past the edge, so no very thin wall is left there.
module grid_cuts(tx, ty) {
    x_min = tile_x_min(tx);
    y_min = tile_y_min(ty);
    z = Board_Thickness - Grid_Groove_Depth;
    for (column = [0:columns]) if (owns_column(tx, column)) {
        on_seam = tx < Panel_Columns - 1 && column == last_column(tx);
        translate([column*Cell_Width - x_min - Grid_Groove_Width/2, -y_min, z])
            cube([Grid_Groove_Width + (on_seam ? epsilon : 0), play_depth, Grid_Groove_Depth + epsilon]);
    }
    for (row = [0:rows]) if (owns_row(ty, row)) {
        on_seam = ty < Panel_Rows - 1 && row == last_row(ty);
        translate([-x_min, row*Cell_Depth - y_min - Grid_Groove_Width/2, z])
            cube([play_width, Grid_Groove_Width + (on_seam ? epsilon : 0), Grid_Groove_Depth + epsilon]);
    }
    for (dot = camp_dots) if (owns_dot(tx, ty, dot))
        at_dot(dot, x_min, y_min, z) cylinder(d=Camp_Dot_Diameter + 2*epsilon, h=Grid_Groove_Depth + epsilon);
}

// One printable panel, with its grid grooves cut but not filled.
module panel_body(tx, ty) {
    // OpenSCAD's preview can show a T-hook tab as see-through where its roof,
    // chamfers and socket cuts overlap. Rendering the panel first prevents it.
    if (seams_exist && Joint_Style == "T-hook") render(convexity=12) panel_body_geometry(tx, ty);
    else panel_body_geometry(tx, ty);
}

module panel_body_geometry(tx, ty) {
    width = tile_width(tx);
    depth = tile_depth(ty);
    difference() {
        union() {
            intersection() {
                tile_footprint(tx, ty, 0, Board_Thickness);
                translate([-Board_Margin - tile_x_min(tx), -Board_Margin - tile_y_min(ty), 0])
                    rounded_slab([board_width, board_depth, Board_Thickness], Outer_Corner_Radius);
            }
            // Tabs on the right and back edges. A panel only presses down over
            // the tabs of neighbors that are already in place.
            if (tx < Panel_Columns - 1) edge_joints(depth, width, true, false);
            if (ty < Panel_Rows - 1) edge_joints(width, depth, false, false);
        }
        // Sockets and bevels on the left and front edges. The neighbor owns the
        // grid line on that seam, so only this panel's edge gets the bevel.
        if (tx > 0) {
            edge_joints(depth, 0, true, true);
            translate([0, depth/2, 0]) seam_bevel_cut(depth + 2);
        }
        if (ty > 0) {
            edge_joints(width, 0, false, true);
            translate([width/2, 0, 0]) rotate([0, 0, 90]) seam_bevel_cut(width + 2);
        }
        // T-hook panels get a bevel on all four underside edges. The center of
        // the underside still sits on the table.
        if (seams_exist && Joint_Style == "T-hook") {
            translate([0, depth/2, 0]) underside_bevel_cut(depth + 2);
            translate([width, depth/2, 0]) rotate([0, 0, 180]) underside_bevel_cut(depth + 2);
            translate([width/2, 0, 0]) rotate([0, 0, 90]) underside_bevel_cut(width + 2);
            translate([width/2, depth, 0]) rotate([0, 0, -90]) underside_bevel_cut(width + 2);
        }
        // The tabs are added after the footprint's notches, so cut the notches again.
        foreign_dot_notches(tx, ty);
        grid_cuts(tx, ty);
        signature_cut(tx, ty);
    }
}


// ===== 5. Color parts for the 3MF exporter ====================================
// komascad.py renders each panel with Output_Mode "Color body" and "Color
// markings", and puts the two in one 3MF. The parts touch, but do not overlap.

// The line color: the grooves, filled to Line Recess below the playing
// surface and cut to the panel, so that each camp dot stays in its owner.
module panel_markings(tx, ty) {
    intersection() {
        grid_cuts(tx, ty);
        tile_footprint(tx, ty, Board_Thickness - Grid_Groove_Depth, line_height);
    }
}

module panel_preview(tx, ty) {
    color(material_rgb(0)) panel_body(tx, ty);
    color(material_rgb(1)) panel_markings(tx, ty);
}


// ===== 6. Layouts =============================================================

// Turns a panel over so that its playing surface is on the bed: an exact half
// turn about x, written as a matrix because rotate() leaves rounding errors.
module on_bed(depth) {
    if (face_down) multmatrix([[1, 0, 0, 0], [0, -1, 0, depth], [0, 0, -1, Board_Thickness], [0, 0, 0, 1]]) children();
    else children();
}

module assembled_board() {
    for (ty = [0:Panel_Rows - 1], tx = [0:Panel_Columns - 1])
        translate([tile_x_min(tx), tile_y_min(ty), 0]) children_of(tx, ty);
}

// The preview in F5, and the plain panel in F6.
module children_of(tx, ty) { if ($preview) panel_preview(tx, ty); else panel_body(tx, ty); }

module all_panels() {
    pitch_x = max([for (tx = [0:Panel_Columns - 1]) tile_width(tx)]) + Joint_Depth + Print_Layout_Gap;
    pitch_y = max([for (ty = [0:Panel_Rows - 1]) tile_depth(ty)]) + Joint_Depth + Print_Layout_Gap;
    for (ty = [0:Panel_Rows - 1], tx = [0:Panel_Columns - 1])
        translate([tx*pitch_x, ty*pitch_y, 0]) on_bed(tile_depth(ty)) children_of(tx, ty);
}


// ===== 7. Checks ==============================================================

assert(Cell_Width > Base_Width && Cell_Depth > Piece_Length,
    str("A square (", Cell_Width, " x ", Cell_Depth, " mm) must be larger than the largest piece (",
        Base_Width, " x ", Piece_Length, " mm)."));
assert(Panel_Columns <= columns && Panel_Rows <= rows,
    "Each panel must hold at least one square. Reduce Panel Columns or Panel Rows.");
assert(Grid_Groove_Width < min(Cell_Width, Cell_Depth)/3, "Grid Groove Width is too wide for the squares.");
assert(Grid_Groove_Depth < Board_Thickness, "Grid Groove Depth must be less than Board Thickness.");
assert(line_height > 0, "Line Recess must be less than Grid Groove Depth.");
assert(!camp_dots_on || (Camp_Dot_Diameter > Grid_Groove_Width && Camp_Dot_Diameter < min(Cell_Width, Cell_Depth)/2),
    "Camp Dot Diameter must be wider than a grid line and less than half a square.");
assert(Signature_Text == ""
    || (Signature_Depth < Board_Thickness - Grid_Groove_Depth - 1
        && len(Signature_Text)*Signature_Font_Size < tile_width(0) - 2*(Board_Margin + socket_extent)
        && 2*Signature_Font_Size < tile_depth(0) - 2*(Board_Margin + socket_extent)),
    "The signature does not fit under panel 0, 0. Shorten the text, or reduce its size or depth.");
if (seams_exist) {
    assert(!camp_dots_on || Camp_Dot_Plug_Clearance < Grid_Groove_Width,
        "Camp Dot Plug Clearance must be less than Grid Groove Width, or the seam shows around the dot.");
    assert(socket_roof_height <= Board_Thickness - Grid_Groove_Depth - socket_skin + 0.001,
        str("The sockets reach ", socket_roof_height, " mm, which leaves less than ", socket_skin,
            " mm under a grid groove. Reduce Joint Thickness, or set it to 0 for automatic."));
    assert(tab_tip_height >= 1.5,
        str("The tabs are only ", tab_tip_height, " mm tall at the tip. Make the board thicker, ",
            "or reduce Joint Depth or Joint Bottom Chamfer."));
    assert(Joint_Style != "T-hook" || T_Shoulder_Length < Joint_Depth,
        "The T-hook shoulders must start before the tip. Reduce T Shoulder Length.");
    assert(Joint_Style != "T-hook" || T_Head_Overhang > Joint_Clearance + T_Spacing_Relief + T_Neck_Relief + 1,
        "The T-hook head must hold at least 1 mm past the socket neck. Raise T Head Overhang.");
    assert(Joint_Style != "T-hook" || t_tip_corner_clip < min(Joint_Depth - T_Shoulder_Length, T_Head_Overhang),
        "The clipped T-hook corners would remove the head. Make the board thicker, or reduce Joint Depth or Joint Bottom Chamfer.");
    assert(joint_margin(shortest_seam) >= socket_half_width + socket_extent,
        str("A tab must be at least ", socket_half_width + socket_extent, " mm from a panel corner, ",
            "so that sockets on two seams do not meet. Raise Joint Edge Margin, or use fewer, larger panels."));
    assert(shortest_seam - 2*joint_margin(shortest_seam) >= 2*socket_half_width + 2,
        str("The shortest seam (", shortest_seam, " mm) is too short for two tabs. ",
            "Use fewer, larger panels, or reduce Joint Width."));
    assert(Seam_Bevel < Board_Thickness - socket_roof_height, "Seam Bevel is so deep that it reaches the sockets.");
}
assert(Output_Mode == "Assembled board" || Output_Mode == "All panels"
    || (Panel_X < Panel_Columns && Panel_Y < Panel_Rows),
    str("Panel X must be 0 to ", Panel_Columns - 1, " and Panel Y 0 to ", Panel_Rows - 1, "."));

// Information in the Console.
echo(str("KomaSCAD ban ", version, ". Board: ", board_width, " x ", board_depth, " x ", Board_Thickness,
         " mm. Panels: ", Panel_Columns, " x ", Panel_Rows, "."));
if (seams_exist)
    echo(str(Joint_Style, " joints. Tab thickness at the seam / at the tip: ", tab_thickness, " / ", tab_tip_height,
             " mm. A pulled seam opens ", seam_play, " mm."));
// komascad.py reads these lines: the fonts, the parts, and each panel's
// column, row, width, depth and offset from the front-left corner of the board.
if (Export_Metadata) {
    echo("KOMASCAD_FONTS", Signature_Text == "" ? [] : [Signature_Font]);
    echo("KOMASCAD_EXPORT", [for (role = [0:1]) [role_names[role], material_name(role), material_rgb(role), true]]);
    echo("KOMASCAD_BAN", [board_width, board_depth, Board_Thickness], [Panel_Columns, Panel_Rows],
         [for (ty = [0:Panel_Rows - 1], tx = [0:Panel_Columns - 1])
             [tx, ty, tile_width(tx), tile_depth(ty), tile_x_min(tx) + Board_Margin, tile_y_min(ty) + Board_Margin]]);
}


// ===== 8. Output ==============================================================

if (!Export_Metadata) {
    if (Output_Mode == "One panel") on_bed(tile_depth(Panel_Y)) children_of(Panel_X, Panel_Y);
    else if (Output_Mode == "All panels") all_panels();
    else if (Output_Mode == "Color body") on_bed(tile_depth(Panel_Y)) color(material_rgb(0)) panel_body(Panel_X, Panel_Y);
    else if (Output_Mode == "Color markings") on_bed(tile_depth(Panel_Y)) color(material_rgb(1)) panel_markings(Panel_X, Panel_Y);
    else assembled_board();
}

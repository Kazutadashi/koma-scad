// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD ban: a parametric shogi board. Tested with OpenSCAD 2021.01.
// The default settings make a traditional-size 9 x 9 board in 2 x 2 panels for a 256 mm print bed.
// Units are mm and degrees unless a comment says otherwise.
// Guide and every setting: docs/ban.md.
// Keep ban.json next to this file, and ../lib/ next to its folder.

/* [01 - Start here] */
// A label for your own use. It does not change the board.
Category = "Shogi";
// Assembled board shows every panel in place. One panel and All panels show the parts to print. Joint test is two small blocks, to check the fit first. Loose parts is the connectors or keys of the board. Use komascad.py ban for a color 3MF.
Output_Mode = "Assembled board"; // [Assembled board,One panel,All panels,Joint test,Loose parts]
// The column of the panel that One panel shows, counted from 0 at the left.
Panel_X = 0; // [0:1:100]
// The row of the panel that One panel shows, counted from 0 at the front.
Panel_Y = 0; // [0:1:100]
// How the panels sit on the print bed. Face down gives the smoothest playing surface. Raised lines need Playing face up.
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
// mm. Border around the grid on each edge. 7.5 with the default squares gives the traditional 1尺1寸 x 1尺2寸 board (333 x 364 mm).
Board_Margin = 7.5; // [0:0.5:50]
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
// Split board: cut the board into Panel Columns x Panel Rows panels. Modules: cut it into panels of Module Columns x Module Rows squares, which also fit other boards with the same squares.
Panel_Layout = "Split board"; // [Split board,Modules]
// Split board: panels from left to right. 1 x 1 is a one-piece board. Seams follow grid lines, so each panel holds whole squares.
Panel_Columns = 2; // [1:1:100]
// Split board: panels from front to back.
Panel_Rows = 2; // [1:1:100]
// Modules: squares from left to right in each module. Playing Columns must be a multiple of it.
Module_Columns = 3; // [1:1:36]
// Modules: squares from front to back in each module. Playing Rows must be a multiple of it.
Module_Rows = 3; // [1:1:36]
// mm. Width of your print bed. The model stops if a panel and its tabs do not fit.
Print_Bed_Width = 256; // [100:1:1000]
// mm. Depth of your print bed.
Print_Bed_Depth = 256; // [100:1:1000]
// mm. Space between the panels in All panels.
Print_Layout_Gap = 10; // [2:1:30]

/* [05 - Markings] */
// Split: each panel carries half of the grid line on a seam, so every seam edge is the same and panels fit anywhere. One side: one panel carries the whole line.
Seam_Lines = "Split"; // [Split,One side]
// Flush inlay: the lines are level with the playing surface. Raised: they stand above it, like lacquer lines, and the board prints face up.
Line_Style = "Flush inlay"; // [Flush inlay,Raised]
// mm. Width of the grid lines. Use a whole number of printed line widths: 0.9 is two lines of a 0.4 mm nozzle.
Grid_Groove_Width = 0.9; // [0.2:0.05:2]
// mm. Depth of the grid grooves.
Grid_Groove_Depth = 0.45; // [0.1:0.05:2]
// mm. Flush inlay only: how far the top of the line color sits below the playing surface. 0 = level.
Line_Recess = 0; // [0:0.02:0.3]
// mm. Raised only: how far the lines stand above the playing surface. Use whole layers, such as 0.12 or 0.16.
Line_Raise = 0.12; // [0.04:0.02:0.4]
// Four dots where the lines one third in from each side cross.
Camp_Dots = true;
// mm. Diameter of each camp dot.
Camp_Dot_Diameter = 2.4; // [1:0.1:6]

/* [06 - Filament colors] */
// Board color. It becomes a named material in the color 3MF. Custom uses Board Color.
Board_Filament = "Kaya"; // [Kaya,Kuwa,Kurogaki,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Color of the grid lines and camp dots. Custom uses Line Color.
Line_Filament = "Black"; // [Kaya,Kuwa,Kurogaki,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Board Filament is Custom.
Board_Color = [0.82, 0.63, 0.34, 1];
// [red, green, blue, opacity], 0 to 1. Used when Line Filament is Custom.
Line_Color = [0.01, 0.01, 0.01, 1];

/* [07 - Joint fit] */
// Connectors: every panel has the same sockets on every seam edge, joined by small separate connectors, which you can print or replace with an M4 or #8-32 screw and nut. A broken connector costs one connector, and panels fit anywhere. T-hook: tabs printed on the panels; drop each panel in. Dovetail: the same, with angled sides. Keys: butterfly keys (契り) pressed into the underside.
Joint_Style = "Connectors"; // [Connectors,T-hook,Dovetail,Keys]
// Connectors only: the connector is a wedge that pulls the seam closed when you press it in. A printer makes it a little larger or smaller than the model, so it seats a little higher or lower. Standard suits most printers. Use Wide if a Standard connector stands out of its socket, and Narrow if it goes in deep but the seam stays loose. Print the Joint test to choose: its connectors are marked with 1, 2 and 3 dots.
Connector_Fit = "Standard"; // [Narrow,Standard,Wide]
// Connectors only: extra connectors to print, in case one is lost or breaks.
Connector_Spares = 2; // [0:1:20]
// mm. Space between each tab side and its socket. Each panel must drop into place under its own weight. Raise this if one does not.
Joint_Clearance = 0.4; // [0.1:0.05:1]
// mm. Gap above each tab at the seam. The T-hook socket roof is flat, so sideways play cannot close this gap.
Joint_Roof_Clearance = 1; // [0.5:0.1:3]
// mm. 45 degree bevel on the top edge of each seam. It takes up first-layer squish, so the seam closes at the playing surface, and a sliding piece rides over a small step instead of catching on it.
Seam_Bevel = 0.4; // [0:0.05:1]
// Bevel both edges of each seam, not only the neighbor's. The small V hides a slight step, and a sliding piece does not catch on it.
Seam_Reveal = true;
// Connectors and Keys only: a short V-shaped tongue along each right and back seam edge, which goes into a groove in the neighbor when you push the panels together. It holds both playing surfaces at the same height, also on a cloth or an uneven table, so that a sliding piece does not catch at a seam.
Seam_Tongues = true;
// mm. 45 degree bevel along the bottom edge of each seam, on both panels. The last layers of a print (the underside) can end with an uneven edge; the bevel keeps it off the table, so that each panel sits flat. 0 = none.
Seam_Underside_Bevel = 0.8; // [0:0.1:2]
// mm. Space around a camp dot where a seam goes around it.
Camp_Dot_Plug_Clearance = 0.2; // [0:0.05:0.6]

/* [08 - Joint shape] */
// mm. Width of the tab neck at the seam. The T-hook head is wider by T Head Overhang on each side.
Joint_Width = 12; // [4:0.5:30]
// mm. How far a tab reaches past the seam.
Joint_Depth = 6; // [2:0.5:15]
// mm. Gap between each tab and the table. The socket is open below the tab, so nothing pushes a tab up or down.
Joint_Floor_Gap = 1; // [0.5:0.1:4]
// mm. Tab thickness at the seam. 0 = as thick as the board allows. The top falls at 45 degrees to the tip, so the tab prints without supports.
Joint_Thickness = 0; // [0:0.5:30]
// mm. Chamfer around the underside of each tab. On T-hook panels, also the bevel on every underside edge and on the socket mouth.
Joint_Bottom_Chamfer = 0.8; // [0:0.1:3]
// Degrees. Dovetail only: angle of each tab side from straight across the seam. More = a pulled seam opens less.
Joint_Flank_Angle = 45; // [15:1:45]
// mm. Approximate distance between tabs on a long seam. Each seam has at least two tabs.
Joint_Spacing = 60; // [25:5:150]
// mm. Preferred distance from a joint to a panel corner.
Joint_Edge_Margin = 25; // [5:1:50]
// mm. T-hook only: how far the head extends on each side of the neck.
T_Head_Overhang = 2.5; // [1:0.5:5]
// mm. T-hook only: distance from the seam to the retaining shoulders.
T_Shoulder_Length = 2; // [1:0.5:5]
// mm. T-hook only: extra clearance along the seam at each socket after the first on an edge.
T_Spacing_Relief = 0.4; // [0:0.05:1]
// mm. T-hook only: extra clearance on each side of the socket neck. The head keeps Joint Clearance.
T_Neck_Relief = 0.35; // [0:0.05:0.8]

/* [09 - Keys] */
// mm. Keys only: length of each butterfly key across the seam.
Key_Length = 22; // [12:0.5:60]
// mm. Keys only: width of each key at its ends.
Key_Width = 14; // [6:0.5:40]
// mm. Keys only: width of each key at its waist, on the seam.
Key_Waist = 7; // [3:0.5:30]
// mm. Keys only: thickness of each key, and the depth of its pocket in the underside.
Key_Thickness = 4; // [2:0.2:8]
// mm. Keys only: space on each side between a key and its pocket. A small value gives a press fit.
Key_Clearance = 0.15; // [0:0.05:0.5]
// Keys only: extra keys to print, in case one is lost.
Key_Spares = 2; // [0:1:10]

/* [10 - Underside] */
// mm. Recess the middle of each panel's underside, so that the panel stands on a band near its edges. Both sides of a seam then stand on the same part of the table. 0 = flat underside.
Underside_Relief = 0.3; // [0:0.05:1]
// mm. Width of the band that the panel stands on. It covers the sockets.
Support_Band = 25; // [8:1:40]
// Cut a bevelled frame round the mouth of each connector socket, for its look. The frame follows the outline of the socket with its inner corners filled in. It takes the first 0.4 mm of the shoulders that hold a connector, which leaves almost all of their grip.
Socket_Frame = true;

/* [11 - Maker's mark] */
// The main line of the mark (銘), cut into the underside of panel 0, 0: your name or brand. Empty = no mark.
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

/* [Hidden] */
// komascad.py sets this to read the panels, materials and fonts without making geometry.
Export_Metadata = false;

version = "3.5";   // the same as VERSION in komascad.py; a test checks this

// The connector socket, spec v1 (docs/ban-connector-spec.md). Do not change
// these values: printed connectors from any board, and the hardware that
// replaces them, must fit every board. The socket takes a printed connector,
// or an M4 x 20 to 25 socket head cap screw (ISO 4762) with an M4 hex nut
// (ISO 4032), or a #8-32 x 7/8 to 1 inch socket cap screw with a #8-32 nut,
// lying flat with the head in one panel and the nut in the other.
spec_neck_width = 4.8;      // mm. The screw shank slot: #8-32 is 4.17, M4 is 4.0.
spec_end_width = 10.6;      // mm. The head or nut pocket: a #8-32 nut is 10.1 across corners.
spec_end_length = 5.8;      // mm at the socket mouth. A cap screw head is 4.0 to 4.2 long; a nut is 3.2.
spec_shoulder = 7;          // mm from the seam to each head or nut pocket, at the socket mouth: the panel material that holds the connector.
spec_taper = 0.15;          // mm that each shoulder face leans away from the seam for each mm of depth: the wedge.
spec_tail = 5;              // mm. Room past each pocket for the screw's tip.
spec_height = 9.3;          // mm from the underside. A #8-32 nut lying on a flat is 8.73 tall.
spec_lead_in = 0.4;         // mm chamfer round the socket mouth, so a connector finds its socket.
// The seam tongue (spec v1). Panels from one board meet tongue to groove, so
// these are fixed too. The tongue is centered on the board's thickness.
spec_tongue_depth = 1.2;        // mm the tongue reaches past the seam. Its sides are at 45 degrees.
spec_tongue_half_height = 2;    // mm above and below the tongue's center line, at the seam.
spec_tongue_clearance = 0.1;    // mm between the tongue and its groove, on each side.
spec_tongue_tip_space = 0.3;    // mm past the tongue tip, so that the seam faces meet first.
spec_tongue_margin = 6;         // mm from each end of a seam edge to the tongue.
spec_groove_margin = 3;         // mm from each end of a seam edge to the groove: room to slide a panel in at an angle.
spec_nub_reach = 0.6;           // mm a nub on the tongue reaches past the tongue, with sides at 45 degrees. It sits in a notch in the groove and lines the panels up along the seam.
$fn = 36;
epsilon = 0.02;   // overlap that keeps boolean operations clean

include <../lib/filaments.scad>
include <../lib/shapes.scad>
include <../lib/maker_mark.scad>


// ===== 1. Board plan ==========================================================
// x runs from left to right and y from front to back, with the origin at the
// front-left corner of the grid. A panel is addressed as (tx, ty) from 0.

columns = Playing_Columns;
rows = Playing_Rows;
modules = Panel_Layout == "Modules";
panel_columns = modules ? columns/Module_Columns : Panel_Columns;
panel_rows = modules ? rows/Module_Rows : Panel_Rows;
split_lines = Seam_Lines == "Split";
play_width = columns*Cell_Width;
play_depth = rows*Cell_Depth;
board_width = play_width + 2*Board_Margin;
board_depth = play_depth + 2*Board_Margin;
panel_count = panel_columns*panel_rows;
seams_exist = panel_count > 1;
raised_lines = Line_Style == "Raised";
// The top of the line color, from the underside.
line_top = raised_lines ? Board_Thickness + Line_Raise : Board_Thickness - Line_Recess;
line_height = line_top - (Board_Thickness - Grid_Groove_Depth);
face_down = Print_Orientation == "Playing face down";
joint_test = Output_Mode == "Joint test";
keys = Joint_Style == "Keys";
connectors = Joint_Style == "Connectors";
// Tabs printed on the panels: the T-hook and the Dovetail.
tabs = !keys && !connectors;
// Loose parts to print: keys or connectors.
loose_parts = keys || connectors;
loose_name = keys ? "Keys" : "Connectors";
tongues = Seam_Tongues && loose_parts;
// The joint checks apply to a board in panels, and to the joint test.
joints_used = seams_exist || joint_test;

// Panel boundaries in whole squares, spread as evenly as possible.
function first_column(tx) = round(tx*columns/panel_columns);
function last_column(tx) = round((tx + 1)*columns/panel_columns);
function first_row(ty) = round(ty*rows/panel_rows);
function last_row(ty) = round((ty + 1)*rows/panel_rows);

// Split lines: a seam runs down the middle of a grid line, and each panel
// carries half of it. One side: the seam runs along the right or back edge of
// the line, and the whole line stays in one panel. Either way the seam gap
// merges into the black line.
seam_offset = split_lines ? 0 : Grid_Groove_Width/2;
function column_seam_x(column) = column*Cell_Width + seam_offset;
function row_seam_y(row) = row*Cell_Depth + seam_offset;
function tile_x_min(tx) = tx == 0 ? -Board_Margin : column_seam_x(first_column(tx));
function tile_x_max(tx) = tx == panel_columns - 1 ? play_width + Board_Margin : column_seam_x(last_column(tx));
function tile_y_min(ty) = ty == 0 ? -Board_Margin : row_seam_y(first_row(ty));
function tile_y_max(ty) = ty == panel_rows - 1 ? play_depth + Board_Margin : row_seam_y(last_row(ty));
function tile_width(tx) = tile_x_max(tx) - tile_x_min(tx);
function tile_depth(ty) = tile_y_max(ty) - tile_y_min(ty);

// A panel draws the grid lines inside it and on its edges. With split lines it
// draws half of each seam line (the panel outline cuts the other half off);
// with One side, only the line on its right or back seam.
function owns_column(tx, column) = column <= last_column(tx)
    && (tx == 0 || column > first_column(tx) || (split_lines && column == first_column(tx)));
function owns_row(ty, row) = row <= last_row(ty)
    && (ty == 0 || row > first_row(ty) || (split_lines && row == first_row(ty)));

// With split lines, a camp dot on a seam is cut with the line: each panel
// carries its part. With One side, a seam beside the line would cut the dot,
// so the panel that owns the dot keeps all of it on a round plug, and its
// neighbors get a matching notch: the seam goes around the dot.
camp_dots_on = Camp_Dots && columns >= 3 && rows >= 3;
camp_dots = camp_dots_on
    ? [for (x = [floor(columns/3), columns - floor(columns/3)], y = [floor(rows/3), rows - floor(rows/3)]) [x, y]]
    : [];
function owns_dot(tx, ty, dot) = owns_column(tx, dot[0]) && owns_row(ty, dot[1]);
dot_plugs = seams_exist && !split_lines;
dot_plug_clearance = dot_plugs ? Camp_Dot_Plug_Clearance : 0;
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
key_lead_in = 0.4;      // mm chamfer around a key pocket mouth, so a key finds its pocket
key_recess = 0.2;       // mm a seated key sits below the underside, so the panel stands on the panel
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
// How far a seam opens when the panels are pulled apart. A seated connector
// holds its seam closed. Along the seam, a connector has 0.3 mm of space on
// each side; the nub on the seam tongue lines the panels up. Along the seam, the space is looser; it does
// not open the seam.
// How far each inner face of a connector moves toward the seam, for each fit.
// 0.1 mm moves the connector 0.1/spec_taper = 0.67 mm higher or lower in its socket.
connector_fits = ["Narrow", "Standard", "Wide"];
connector_fit_values = [0.1, 0, -0.1];
function connector_fit_of(name) = connector_fit_values[search([name], connector_fits)[0]];
connector_fit = connector_fit_of(Connector_Fit);
connector_side_fit = 0.3;
seam_play = Joint_Style == "Dovetail" ? Joint_Clearance/sin(Joint_Flank_Angle)
    : keys ? Key_Clearance : connectors ? 0 : Joint_Clearance;
// The space that one joint (a socket, or a key pocket) takes along and across its seam.
connector_half_width = keys ? Key_Width/2 + Key_Clearance + key_lead_in
    : connectors ? spec_end_width/2 + spec_lead_in : socket_half_width;
connector_extent = keys ? Key_Length/2 + Key_Clearance + key_lead_in
    : connectors ? spec_shoulder + spec_end_length + spec_tail + spec_lead_in : socket_extent;
// How far a tab or a tongue reaches past each panel's right and back edges.
tab_reach = tabs ? Joint_Depth : tongues && seams_exist ? spec_tongue_depth : 0;
function joint_margin(span) = min(Joint_Edge_Margin, span/3);
function joint_count(span) = max(2, floor((span - 2*joint_margin(span))/Joint_Spacing) + 1);
function joint_position(index, count, span) = joint_margin(span) + index*(span - 2*joint_margin(span))/(count - 1);
// The shortest seam on the board. It must still hold two tabs.
shortest_seam = min(concat(
    panel_columns > 1 ? [for (ty = [0:panel_rows - 1]) tile_depth(ty)] : [],
    panel_rows > 1 ? [for (tx = [0:panel_columns - 1]) tile_width(tx)] : [],
    [1e9]));


// The part of panel 0, 0 that the mark may use: clear of the sockets on its
// right and back seams, and 3 mm from its other edges. The mark is centered in it.
mark_margin = 3;
mark_room_x = [mark_margin, tile_width(0) - (panel_columns > 1 ? connector_extent + 2 : mark_margin)];
mark_room_y = [mark_margin, tile_depth(0) - (panel_rows > 1 ? connector_extent + 2 : mark_margin)];
mark_room = [mark_room_x[1] - mark_room_x[0], mark_room_y[1] - mark_room_y[0]];

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
            translate([0, 0, tab_bottom + Joint_Bottom_Chamfer]) linear_extrude(Board_Thickness, convexity=4) t_tab_outline();
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
    translate([0, 0, -epsilon]) linear_extrude(socket_roof_height + epsilon, convexity=4)
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

// The butterfly key (契り), centered on the origin, its length across the seam
// along x. It is two convex halves, one on each side of the seam.
module key_half_2d(side, clearance=0) {
    offset(delta=clearance) polygon([
        [0, -Key_Waist/2], [side*Key_Length/2, -Key_Width/2], [side*Key_Length/2, Key_Width/2], [0, Key_Waist/2]]);
}
module key_2d(clearance=0) { for (side = [-1, 1]) key_half_2d(side, clearance); }

module key() { linear_extrude(Key_Thickness, convexity=4) key_2d(); }

// The pocket for a key, open through the underside, with a chamfered mouth.
// Its floor is a top surface when the panel prints face down.
module key_pocket() {
    depth = Key_Thickness + key_recess;
    translate([0, 0, -epsilon]) linear_extrude(depth + epsilon) key_2d(Key_Clearance);
    // One hull for each half, so that the waist stays narrow.
    for (side = [-1, 1]) hull() {
        translate([0, 0, -epsilon]) linear_extrude(epsilon) key_half_2d(side, Key_Clearance + key_lead_in);
        translate([0, 0, key_lead_in]) linear_extrude(epsilon) key_half_2d(side, Key_Clearance);
    }
}

// Half of each key pocket on each side of a seam. The seam is on the y axis.
module edge_key_pockets(span, at, vertical) {
    count = joint_count(span);
    for (i = [0:count - 1]) {
        if (vertical) translate([at, joint_position(i, count, span), 0]) key_pocket();
        else translate([joint_position(i, count, span), at, 0]) rotate([0, 0, 90]) key_pocket();
    }
}

// Connector sockets go at standard places (spec v1): the middle of each
// square along a seam, except where the socket would meet the sockets of
// the crossing seam at an inner corner, or run off the board at its edge.
// The places depend only on the grid, so any two panels with the same
// squares meet socket to socket.
corner_clear = connector_half_width + connector_extent;   // from an inner corner
end_clear = connector_half_width + 2;                     // from the outer edge of the board
function keep_places(places, span, start_inner, end_inner) =
    [for (at = places) if (at >= (start_inner ? corner_clear : end_clear)
                         && at <= span - (end_inner ? corner_clear : end_clear)) at];
// Along the seams on a panel's left and right edges (row of panels ty).
function socket_places_y(ty) = keep_places(
    [for (r = [first_row(ty):last_row(ty) - 1]) (r + 0.5)*Cell_Depth - tile_y_min(ty)],
    tile_depth(ty), ty > 0, ty < panel_rows - 1);
// Along the seams on a panel's front and back edges (column of panels tx).
function socket_places_x(tx) = keep_places(
    [for (c = [first_column(tx):last_column(tx) - 1]) (c + 0.5)*Cell_Width - tile_x_min(tx)],
    tile_width(tx), tx > 0, tx < panel_columns - 1);

// The joints that a board needs: one on each joint position of every seam.
function seam_joints_y(ty) = connectors ? len(socket_places_y(ty)) : joint_count(tile_depth(ty));
function seam_joints_x(tx) = connectors ? len(socket_places_x(tx)) : joint_count(tile_width(tx));
joint_total =
    (panel_columns > 1 ? (panel_columns - 1)*sum_list([for (ty = [0:panel_rows - 1]) seam_joints_y(ty)]) : 0)
    + (panel_rows > 1 ? (panel_rows - 1)*sum_list([for (tx = [0:panel_columns - 1]) seam_joints_x(tx)]) : 0);
function sum_list(values, i=0) = i >= len(values) ? 0 : values[i] + sum_list(values, i + 1);
key_count = keys ? joint_total : 0;
// The loose parts to print, spares included, for a board in panels.
loose_count = !loose_parts || !seams_exist ? 0 : joint_total + (keys ? Key_Spares : Connector_Spares);

// The connector socket (spec v1), centered on the seam (the y axis): a slot
// for the neck across the seam, a pocket for the head or nut on each side,
// and room for a screw tip beyond. Open through the underside, with a flat
// roof. Every panel edge has the same half, so any panel joins any other.
// The socket is three convex pieces: the slot across the seam (piece 0), and
// a head or nut pocket on each side (pieces 1 and 2). The pocket's face on
// the seam side (the shoulder) leans away from the seam by spec_taper for each
// mm of depth z: a connector pressed in wedges the two shoulders together.
module connector_socket_piece(piece, grow=0, z=0) {
    reach = spec_shoulder + spec_end_length + spec_tail;
    inner = spec_shoulder + spec_taper*z;
    outer = spec_shoulder + spec_end_length;
    offset(delta=grow) {
        if (piece == 0) square([2*reach, spec_neck_width], center=true);
        else translate([(piece == 1 ? -1 : 1)*(inner + outer)/2, 0])
            square([outer - inner, spec_end_width], center=true);
    }
}
module connector_socket_2d(grow=0) { for (piece = [0:2]) connector_socket_piece(piece, grow); }

module connector_socket() {
    for (piece = [0:2]) hull() {
        slice(-epsilon) connector_socket_piece(piece);
        slice(spec_height - epsilon) connector_socket_piece(piece, 0, spec_height);
    }
    // The chamfered mouth. With Socket_Frame, one hull of the whole outline
    // fills in its inner corners: a bevelled frame. Without it, each piece gets
    // its own hull, so that the chamfer follows the outline exactly.
    if (Socket_Frame) hull() {
        translate([0, 0, -epsilon]) linear_extrude(epsilon) connector_socket_2d(spec_lead_in);
        translate([0, 0, spec_lead_in]) linear_extrude(epsilon) connector_socket_2d();
    }
    else for (piece = [0:2]) hull() {
        translate([0, 0, -epsilon]) linear_extrude(epsilon) connector_socket_piece(piece, spec_lead_in);
        translate([0, 0, spec_lead_in]) linear_extrude(epsilon) connector_socket_piece(piece);
    }
}

// The printed connector: a flat double-T, and a wedge. Its end faces on the
// seam side lean like the shoulders. Pressed into its socket, it slides up the
// leaning shoulders until it pulls them together and closes the seam. It
// then sits connector_seat above the table, so it never sets a panel's height,
// and the table keeps it from falling out. A printer that makes it 0.1 mm
// larger or smaller moves it 0.67 mm lower or higher, and it still closes the
// seam. Its edges are chamfered, top and bottom: the chamfer takes off the
// first layer's squish, and leads the connector into its socket.
connector_seat = 1.6;       // mm from the underside to the bottom of a Standard connector, when seated
connector_height = 6.6;
connector_end_space = 0.6;  // mm between each end and the far wall of its pocket
connector_chamfer = 0.4;
connector_dot = 1.2;        // mm. The diameter of each fit dot on the top face.
// The connector is three convex pieces: the neck (piece 0) and the two ends.
// z is the height above the connector's bottom.
module connector_piece_2d(piece, fit, z=0, grow=0) {
    inner = spec_shoulder + spec_taper*(connector_seat + z) - fit;
    outer = spec_shoulder + spec_end_length - connector_end_space;
    offset(delta=grow) {
        if (piece == 0) square([2*spec_shoulder + 1, spec_neck_width - 2*connector_side_fit], center=true);
        else translate([(piece == 1 ? -1 : 1)*(inner + outer)/2, 0])
            square([outer - inner, spec_end_width - 2*connector_side_fit], center=true);
    }
}
// One connector. Dots on one end show its fit: 1 Narrow, 2 Standard, 3 Wide.
module connector(fit_name=Connector_Fit) {
    fit = connector_fit_of(fit_name);
    dots = search([fit_name], connector_fits)[0] + 1;
    top = connector_height;
    difference() {
        for (piece = [0:2]) hull() {
            slice(0) connector_piece_2d(piece, fit, 0, -connector_chamfer);
            slice(connector_chamfer) connector_piece_2d(piece, fit, connector_chamfer);
            slice(top - connector_chamfer - epsilon) connector_piece_2d(piece, fit, top - connector_chamfer);
            slice(top - epsilon) connector_piece_2d(piece, fit, top, -connector_chamfer);
        }
        dot_x = (spec_shoulder + spec_taper*(connector_seat + top) + spec_shoulder + spec_end_length
                 - connector_end_space)/2;
        for (i = [0:dots - 1])
            translate([dot_x, (i - (dots - 1)/2)*2.5, top - 0.4]) cylinder(d=connector_dot, h=1, $fn=16);
    }
}

// The sockets along one seam edge, at the given places. A vertical edge runs
// along y at x = at, the others along x at y = at.
module edge_connector_sockets(places, at, vertical) {
    for (place = places) {
        if (vertical) translate([at, place, 0]) connector_socket();
        else translate([place, at, 0]) rotate([0, 0, 90]) connector_socket();
    }
}

// Every key or connector, and the spares, in rows for one print.
module loose_layout() {
    size = keys ? [Key_Length, Key_Width]
        : [2*(spec_shoulder + spec_end_length - connector_end_space), spec_end_width];
    total = max(1, loose_count);
    pitch = size + [5, 5];
    // Long rows, as wide as the print bed: the strip fits beside the panels.
    per_row = max(1, min(total, floor((Print_Bed_Width - 10)/pitch[0])));
    for (k = [0:total - 1])
        translate([(k % per_row + 0.5)*pitch[0], (floor(k/per_row) + 0.5)*pitch[1], 0]) {
            if (keys) key(); else connector();
        }
}

// A 45 degree bevel along the top of a seam: seam on the y axis, panel at
// x > 0, length mm long and centered on the origin. The cut continues above
// the playing surface, so that it also bevels raised lines.
module seam_bevel_cut(length, bevel=seam_bevel, top=Board_Thickness) {
    if (bevel > 0) rotate([90, 0, 0]) linear_extrude(length, center=true)
        polygon([[-epsilon, top - bevel - epsilon], [-epsilon, top + 1], [bevel + 1 + epsilon, top + 1]]);
}

// The seam bevels of a panel. The left and front seam edges always get one.
// The right and back seam edges get one too with Seam Reveal, or with split
// lines, where both edges carry half a line. They cut the body and the line
// color alike.
module seam_bevels(tx, ty) {
    width = tile_width(tx);
    depth = tile_depth(ty);
    both = Seam_Reveal || split_lines;
    if (tx > 0) translate([0, depth/2, 0]) seam_bevel_cut(depth + 2);
    if (ty > 0) translate([width/2, 0, 0]) rotate([0, 0, 90]) seam_bevel_cut(width + 2);
    if (both && tx < panel_columns - 1) translate([width, depth/2, 0]) rotate([0, 0, 180]) seam_bevel_cut(depth + 2);
    if (both && ty < panel_rows - 1) translate([width/2, depth, 0]) rotate([0, 0, -90]) seam_bevel_cut(width + 2);
}

// A bevel along the bottom of a panel edge, on the panel's +x side. It leaves
// room for small bulges on the first layers without opening the playing seam.
// The underside bevel on every seam edge of a panel, for every joint style.
module underside_seam_bevels(tx, ty) {
    width = tile_width(tx);
    depth = tile_depth(ty);
    bevel = Seam_Underside_Bevel;
    if (tx > 0) translate([0, depth/2, 0]) underside_bevel_cut(depth + 2, bevel);
    if (tx < panel_columns - 1) translate([width, depth/2, 0]) rotate([0, 0, 180]) underside_bevel_cut(depth + 2, bevel);
    if (ty > 0) translate([width/2, 0, 0]) rotate([0, 0, 90]) underside_bevel_cut(width + 2, bevel);
    if (ty < panel_rows - 1) translate([width/2, depth, 0]) rotate([0, 0, -90]) underside_bevel_cut(width + 2, bevel);
}

module underside_bevel_cut(length, bevel=Joint_Bottom_Chamfer) {
    if (bevel > 0) rotate([90, 0, 0]) linear_extrude(length, center=true)
        polygon([[-epsilon, -epsilon], [bevel + epsilon, -epsilon], [-epsilon, bevel + epsilon]]);
}

// The seam tongue and its groove: seam on the y axis, length mm long and
// centered on the origin. The tongue reaches into +x from the panel at x < 0;
// the groove is cut into the panel at x > 0. Both sides are at 45 degrees, so
// each prints without supports, and the tongue holds the two playing
// surfaces at the same height. The tongue is a short, solid ridge: no part of
// it flexes, so it does not wear like a clip.
tongue_center = Board_Thickness/2;
function tongue_profile(reach) =
    let(h = spec_tongue_half_height)
    [[-1, -h - 1], [0, -h], [reach, -h + reach], [reach, h - reach], [0, h], [-1, h + 1]];
module seam_tongue(length) {
    translate([0, 0, tongue_center]) rotate([90, 0, 0]) linear_extrude(length, center=true)
        polygon(tongue_profile(spec_tongue_depth));
}
module seam_groove(length) {
    translate([0, 0, tongue_center]) rotate([90, 0, 0]) linear_extrude(length, center=true)
        offset(delta=spec_tongue_clearance) polygon(tongue_profile(spec_tongue_depth + spec_tongue_tip_space));
}
// The nub: the tongue reaches spec_nub_reach further over a short length,
// with sides at 45 degrees seen from above. extra makes the matching notch.
module tongue_slice(reach, y) {
    translate([0, y, tongue_center]) rotate([90, 0, 0]) linear_extrude(epsilon, center=true)
        polygon(tongue_profile(reach));
}
module seam_nub(extra=0) {
    hull() {
        for (y = [-1, 1]) tongue_slice(spec_tongue_depth + extra, y*spec_nub_reach);
        tongue_slice(spec_tongue_depth + spec_nub_reach + extra, 0);
    }
}
module seam_notch() {
    // The nub, grown by the clearance all round.
    minkowski() {
        seam_nub(spec_tongue_tip_space);
        sphere(r=spec_tongue_clearance, $fn=8);
    }
}
// Where the nub goes along a seam edge: on the grid line nearest the middle
// of the edge, between two sockets. None on an edge of one square.
function nub_place(first, last, cell, start) =
    let(line = round((first + last)/2))
    line > first && line < last ? [line*cell - start] : [];
function nub_places_y(ty) = nub_place(first_row(ty), last_row(ty), Cell_Depth, tile_y_min(ty));
function nub_places_x(tx) = nub_place(first_column(tx), last_column(tx), Cell_Width, tile_x_min(tx));
// The tongues on a panel's right and back seam edges.
module seam_tongues(tx, ty) {
    width = tile_width(tx);
    depth = tile_depth(ty);
    if (tx < panel_columns - 1) {
        translate([width, depth/2, 0]) seam_tongue(depth - 2*spec_tongue_margin);
        for (y = nub_places_y(ty)) translate([width, y, 0]) seam_nub();
    }
    if (ty < panel_rows - 1) {
        translate([width/2, depth, 0]) rotate([0, 0, 90]) seam_tongue(width - 2*spec_tongue_margin);
        for (x = nub_places_x(tx)) translate([x, depth, 0]) rotate([0, 0, 90]) seam_nub();
    }
}
// The grooves in a panel's left and front seam edges.
module seam_grooves(tx, ty) {
    width = tile_width(tx);
    depth = tile_depth(ty);
    if (tx > 0) {
        translate([0, depth/2, 0]) seam_groove(depth - 2*spec_groove_margin);
        for (y = nub_places_y(ty)) translate([0, y, 0]) seam_notch();
    }
    if (ty > 0) {
        translate([width/2, 0, 0]) rotate([0, 0, 90]) seam_groove(width - 2*spec_groove_margin);
        for (x = nub_places_x(tx)) translate([x, 0, 0]) rotate([0, 0, 90]) seam_notch();
    }
}


// ===== 4. Panels ==============================================================
// Each module draws one panel in its own coordinates: the front-left corner of
// the panel is at the origin and the underside is at z = 0.

// The maker's mark on the underside of panel 0, 0. It is mirrored, so that it
// reads correctly when you turn the board over. It is Mark Depth deep from the
// relief floor, and deeper where it crosses the band that the panel stands on.
module signature_cut(tx, ty) {
    if (tx == 0 && ty == 0 && mark_on)
        translate([(mark_room_x[0] + mark_room_x[1])/2, (mark_room_y[0] + mark_room_y[1])/2, -epsilon])
            linear_extrude(Underside_Relief + Mark_Depth + epsilon, convexity=20) mirror([0, 1, 0]) mark_2d();
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
            if (dot_plugs) for (dot = camp_dots) if (owns_dot(tx, ty, dot))
                at_dot(dot, tile_x_min(tx), tile_y_min(ty), z0) cylinder(d=Camp_Dot_Diameter, h=height);
        }
        foreign_dot_notches(tx, ty, z0, height);
    }
}

module foreign_dot_notches(tx, ty, z0=0, height=Board_Thickness) {
    if (dot_plugs) for (dot = camp_dots) if (!owns_dot(tx, ty, dot))
        at_dot(dot, tile_x_min(tx), tile_y_min(ty), z0 - epsilon)
            cylinder(d=Camp_Dot_Diameter + 2*dot_plug_clearance, h=height + 2*epsilon);
}

// The grid grooves and camp dots that a panel owns. A line on the panel's
// right or back seam runs epsilon past the edge, so no very thin wall is left there.
// above is how far the shapes reach above the playing surface.
module grid_cuts(tx, ty, above=epsilon) {
    x_min = tile_x_min(tx);
    y_min = tile_y_min(ty);
    z = Board_Thickness - Grid_Groove_Depth;
    for (column = [0:columns]) if (owns_column(tx, column)) {
        on_seam = tx < panel_columns - 1 && column == last_column(tx);
        translate([column*Cell_Width - x_min - Grid_Groove_Width/2, -y_min, z])
            cube([Grid_Groove_Width + (on_seam ? epsilon : 0), play_depth, Grid_Groove_Depth + above]);
    }
    for (row = [0:rows]) if (owns_row(ty, row)) {
        on_seam = ty < panel_rows - 1 && row == last_row(ty);
        translate([-x_min, row*Cell_Depth - y_min - Grid_Groove_Width/2, z])
            cube([play_width, Grid_Groove_Width + (on_seam ? epsilon : 0), Grid_Groove_Depth + above]);
    }
    for (dot = camp_dots) if (owns_dot(tx, ty, dot))
        at_dot(dot, x_min, y_min, z) cylinder(d=Camp_Dot_Diameter + 2*epsilon, h=Grid_Groove_Depth + above);
}

// The underside relief: a shallow pocket in the middle of the underside.
module underside_relief(tx, ty) {
    if (Underside_Relief > 0)
        translate([Support_Band, Support_Band, -epsilon])
            cube([tile_width(tx) - 2*Support_Band, tile_depth(ty) - 2*Support_Band, Underside_Relief + epsilon]);
}

// One printable panel, with its grid grooves cut but not filled.
module panel_body(tx, ty) {
    // OpenSCAD's preview draws concave cuts, such as T-hook roofs and the
    // sockets of keys and connectors, as see-through holes. Rendering the
    // panel first makes the preview exact.
    if (seams_exist && (Joint_Style == "T-hook" || loose_parts)) render(convexity=12) panel_body_geometry(tx, ty);
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
            if (tabs && tx < panel_columns - 1) edge_joints(depth, width, true, false);
            if (tabs && ty < panel_rows - 1) edge_joints(width, depth, false, false);
            if (tongues) seam_tongues(tx, ty);
        }
        // Sockets on the left and front edges, and the seam bevels.
        if (tabs && tx > 0) edge_joints(depth, 0, true, true);
        if (tabs && ty > 0) edge_joints(width, 0, false, true);
        seam_bevels(tx, ty);
        if (tongues) seam_grooves(tx, ty);
        // Keys and connectors: half of each pocket or socket on every seam edge.
        if (keys) {
            if (tx > 0) edge_key_pockets(depth, 0, true);
            if (tx < panel_columns - 1) edge_key_pockets(depth, width, true);
            if (ty > 0) edge_key_pockets(width, 0, false);
            if (ty < panel_rows - 1) edge_key_pockets(width, depth, false);
        }
        if (connectors) {
            if (tx > 0) edge_connector_sockets(socket_places_y(ty), 0, true);
            if (tx < panel_columns - 1) edge_connector_sockets(socket_places_y(ty), width, true);
            if (ty > 0) edge_connector_sockets(socket_places_x(tx), 0, false);
            if (ty < panel_rows - 1) edge_connector_sockets(socket_places_x(tx), depth, false);
        }
        underside_relief(tx, ty);
        // T-hook panels get a bevel on all four underside edges. The center of
        // the underside still sits on the table.
        if (seams_exist && Joint_Style == "T-hook") {
            translate([0, depth/2, 0]) underside_bevel_cut(depth + 2);
            translate([width, depth/2, 0]) rotate([0, 0, 180]) underside_bevel_cut(depth + 2);
            translate([width/2, 0, 0]) rotate([0, 0, 90]) underside_bevel_cut(width + 2);
            translate([width/2, depth, 0]) rotate([0, 0, -90]) underside_bevel_cut(width + 2);
        }
        // Every seam edge gets an underside bevel, on both panels. The top of
        // the print can end with an uneven edge, which would lift the panel
        // off the table at the seam.
        underside_seam_bevels(tx, ty);
        // The tabs are added after the footprint's notches, so cut the notches again.
        foreign_dot_notches(tx, ty);
        grid_cuts(tx, ty);
        signature_cut(tx, ty);
    }
}


// ===== 5. Color parts for the 3MF exporter ====================================
// komascad.py renders each panel with Output_Mode "Color body" and "Color
// markings", and puts the two in one 3MF. The parts touch, but do not overlap.

// The line color: the grooves, filled up to line_top and cut to the panel,
// so that each camp dot stays in its owner. Raised lines stand above the
// playing surface on the same outline as their grooves.
module panel_markings(tx, ty) {
    difference() {
        intersection() {
            grid_cuts(tx, ty, raised_lines ? Line_Raise + epsilon : epsilon);
            tile_footprint(tx, ty, Board_Thickness - Grid_Groove_Depth, line_height);
        }
        seam_bevels(tx, ty);
    }
}

module panel_preview(tx, ty) {
    color(material_rgb(0)) panel_body(tx, ty);
    // Flush lines are level with the playing surface, which the F5 preview
    // draws as flicker. Lift them a hair in the preview only.
    preview_lift = 0.01;
    color(material_rgb(1)) translate([0, 0, preview_lift]) panel_markings(tx, ty);
}


// ===== 6. Layouts =============================================================

// Turns a panel over so that its playing surface is on the bed: an exact half
// turn about x, written as a matrix because rotate() leaves rounding errors.
module on_bed(depth) {
    if (face_down) multmatrix([[1, 0, 0, 0], [0, -1, 0, depth], [0, 0, -1, Board_Thickness], [0, 0, 0, 1]]) children();
    else children();
}

module assembled_board() {
    for (ty = [0:panel_rows - 1], tx = [0:panel_columns - 1])
        translate([tile_x_min(tx), tile_y_min(ty), 0]) children_of(tx, ty);
}

// The preview in F5, and the plain panel in F6.
module children_of(tx, ty) { if ($preview) panel_preview(tx, ty); else panel_body(tx, ty); }

module all_panels() {
    pitch_x = max([for (tx = [0:panel_columns - 1]) tile_width(tx)]) + tab_reach + Print_Layout_Gap;
    pitch_y = max([for (ty = [0:panel_rows - 1]) tile_depth(ty)]) + tab_reach + Print_Layout_Gap;
    for (ty = [0:panel_rows - 1], tx = [0:panel_columns - 1])
        translate([tx*pitch_x, ty*pitch_y, 0]) on_bed(tile_depth(ty)) children_of(tx, ty);
}


// Two small blocks with one joint and one grid line at the seam, to check the
// fit and the seam before printing whole panels. The left block has the tab,
// or half of the key pocket, and the seam tongue. A Keys test also prints one
// key; a Connectors test prints one connector of each fit.
test_length = 2*connector_half_width + 16;                // mm along the seam: one connector and its walls
test_tab_block = loose_parts ? connector_extent + 15 : 30;   // mm across the seam, left block
test_socket_block = connector_extent + 15;                // mm across the seam, right block

module test_bevels(width) {
    if (Joint_Style == "T-hook") {
        translate([0, test_length/2, 0]) underside_bevel_cut(test_length + 2);
        translate([width, test_length/2, 0]) rotate([0, 0, 180]) underside_bevel_cut(test_length + 2);
        translate([width/2, 0, 0]) rotate([0, 0, 90]) underside_bevel_cut(width + 2);
        translate([width/2, test_length, 0]) rotate([0, 0, -90]) underside_bevel_cut(width + 2);
    }
}

module test_tab_block() {
    difference() {
        union() {
            cube([test_tab_block, test_length, Board_Thickness]);
            if (tabs) translate([test_tab_block, test_length/2, 0]) joint(false);
            if (tongues) translate([test_tab_block, test_length/2, 0]) seam_tongue(test_length - 2*spec_tongue_margin);
        }
        // The grid line on the seam: half on each block with split lines, all on this block with One side.
        translate([test_tab_block - Grid_Groove_Width + seam_offset, -epsilon, Board_Thickness - Grid_Groove_Depth])
            cube([Grid_Groove_Width - seam_offset + epsilon, test_length + 2*epsilon, Grid_Groove_Depth + epsilon]);
        if (keys) translate([test_tab_block, test_length/2, 0]) key_pocket();
        if (connectors) translate([test_tab_block, test_length/2, 0]) connector_socket();
        if (Seam_Reveal || split_lines)
            translate([test_tab_block, test_length/2, 0]) rotate([0, 0, 180]) seam_bevel_cut(test_length + 2, Seam_Bevel);
        translate([test_tab_block, test_length/2, 0]) rotate([0, 0, 180])
            underside_bevel_cut(test_length + 2, Seam_Underside_Bevel);
        test_bevels(test_tab_block);
    }
}

module test_socket_block() {
    difference() {
        cube([test_socket_block, test_length, Board_Thickness]);
        if (tabs) translate([0, test_length/2, 0]) joint(true, 0);
        if (keys) translate([0, test_length/2, 0]) key_pocket();
        if (connectors) translate([0, test_length/2, 0]) connector_socket();
        if (tongues) translate([0, test_length/2, 0]) seam_groove(test_length - 2*spec_groove_margin);
        if (split_lines)
            translate([-epsilon, -epsilon, Board_Thickness - Grid_Groove_Depth])
                cube([Grid_Groove_Width/2 + epsilon, test_length + 2*epsilon, Grid_Groove_Depth + epsilon]);
        translate([0, test_length/2, 0]) seam_bevel_cut(test_length + 2, Seam_Bevel);
        translate([0, test_length/2, 0]) underside_bevel_cut(test_length + 2, Seam_Underside_Bevel);
        test_bevels(test_socket_block);
    }
}

module joint_test() {
    color(material_rgb(0)) render(convexity=12) {
        on_bed(test_length) test_tab_block();
        translate([test_tab_block + tab_reach + Print_Layout_Gap, 0, 0]) on_bed(test_length) test_socket_block();
        loose_x = test_tab_block + test_socket_block + 2*Print_Layout_Gap;
        if (keys) translate([loose_x + Key_Length/2, test_length/2, 0]) key();
        if (connectors) for (i = [0:2])
            translate([loose_x + spec_shoulder + spec_end_length, test_length/2 + (i - 1)*(spec_end_width + 4), 0])
                connector(connector_fits[i]);
    }
}


// ===== 7. Checks ==============================================================

assert(Cell_Width > Base_Width && Cell_Depth > Piece_Length,
    str("A square (", Cell_Width, " x ", Cell_Depth, " mm) must be larger than the largest piece (",
        Base_Width, " x ", Piece_Length, " mm)."));
assert(!modules || (columns % Module_Columns == 0 && rows % Module_Rows == 0),
    str("Modules need Playing Columns to be a multiple of Module Columns, and Playing Rows of Module Rows (",
        columns, " x ", rows, " squares, ", Module_Columns, " x ", Module_Rows, " modules)."));
assert(panel_columns <= columns && panel_rows <= rows,
    "Each panel must hold at least one square. Reduce Panel Columns or Panel Rows.");
assert(Grid_Groove_Width < min(Cell_Width, Cell_Depth)/3, "Grid Groove Width is too wide for the squares.");
assert(Grid_Groove_Depth < Board_Thickness, "Grid Groove Depth must be less than Board Thickness.");
assert(line_height > 0, "Line Recess must be less than Grid Groove Depth.");
assert(!camp_dots_on || (Camp_Dot_Diameter > Grid_Groove_Width && Camp_Dot_Diameter < min(Cell_Width, Cell_Depth)/2),
    "Camp Dot Diameter must be wider than a grid line and less than half a square.");
assert(!mark_on
    || (Mark_Depth + Underside_Relief < Board_Thickness - Grid_Groove_Depth - 1
        && mark_extent[0] < mark_room_x[1] - mark_room_x[0]
        && mark_extent[1] < mark_room_y[1] - mark_room_y[0]),
    str("The maker's mark (about ", mark_extent[0], " x ", mark_extent[1], " mm) does not fit under panel 0, 0 (",
        mark_room_x[1] - mark_room_x[0], " x ", mark_room_y[1] - mark_room_y[0],
        " mm clear of the sockets). Set Mark Size to 0 (automatic), reduce the letter spacing, or shorten the lines."));
assert(!mark_on || mark_smallest_text >= Mark_Min_Text_Size - 0.001,
    str("The maker's mark text would be ", round(mark_smallest_text*10)/10, " mm, smaller than Mark Min Text Size (",
        Mark_Min_Text_Size, " mm), and would not print. Set Mark Size to 0 (automatic) or larger, ",
        "reduce the letter spacing, or shorten the main line."));
assert(!raised_lines || !face_down,
    "Raised lines stand above the playing surface, so the board must print face up. Set Print Orientation to Playing face up.");
// The largest panel footprint on the bed, with the tabs on its right and back edges.
function bed_width(tx) = tile_width(tx) + (tx < panel_columns - 1 ? tab_reach : 0);
function bed_depth(ty) = tile_depth(ty) + (ty < panel_rows - 1 ? tab_reach : 0);
function fits_bed(w, d) = (w <= Print_Bed_Width && d <= Print_Bed_Depth) || (w <= Print_Bed_Depth && d <= Print_Bed_Width);
too_large = [for (ty = [0:panel_rows - 1], tx = [0:panel_columns - 1])
    if (!fits_bed(bed_width(tx), bed_depth(ty))) [tx, ty, bed_width(tx), bed_depth(ty)]];
assert(len(too_large) == 0, len(too_large) == 0 ? ""
    : str("Panel ", too_large[0][0], ", ", too_large[0][1], " is ", too_large[0][2], " x ", too_large[0][3],
          " mm with its tabs, which is larger than the ", Print_Bed_Width, " x ", Print_Bed_Depth,
          " mm print bed. Use more panels, a smaller Board Margin, or a larger Print Bed."));
if (joints_used) {
    assert(!camp_dots_on || Camp_Dot_Plug_Clearance < Grid_Groove_Width,
        "Camp Dot Plug Clearance must be less than Grid Groove Width, or the seam shows around the dot.");
    assert(!tabs || socket_roof_height <= Board_Thickness - Grid_Groove_Depth - socket_skin + 0.001,
        str("The sockets reach ", socket_roof_height, " mm, which leaves less than ", socket_skin,
            " mm under a grid groove. Reduce Joint Thickness, or set it to 0 for automatic."));
    assert(!tabs || tab_tip_height >= 1.5,
        str("The tabs are only ", tab_tip_height, " mm tall at the tip. Make the board thicker, ",
            "or reduce Joint Depth or Joint Bottom Chamfer."));
    assert(Joint_Style != "T-hook" || T_Shoulder_Length < Joint_Depth,
        "The T-hook shoulders must start before the tip. Reduce T Shoulder Length.");
    assert(Joint_Style != "T-hook" || T_Head_Overhang > Joint_Clearance + T_Spacing_Relief + T_Neck_Relief + 1,
        "The T-hook head must hold at least 1 mm past the socket neck. Raise T Head Overhang.");
    assert(Joint_Style != "T-hook" || t_tip_corner_clip < min(Joint_Depth - T_Shoulder_Length, T_Head_Overhang),
        "The clipped T-hook corners would remove the head. Make the board thicker, or reduce Joint Depth or Joint Bottom Chamfer.");
    assert(connectors || joint_margin(shortest_seam) >= connector_half_width + connector_extent,
        str("A joint must be at least ", connector_half_width + connector_extent, " mm from a panel corner, ",
            "so that the joints on two seams do not meet. Raise Joint Edge Margin, use fewer, larger panels, ",
            "or use smaller keys."));
    assert(connectors || shortest_seam - 2*joint_margin(shortest_seam) >= 2*connector_half_width + 2,
        str("The shortest seam (", shortest_seam, " mm) is too short for two tabs. ",
            "Use fewer, larger panels, or reduce Joint Width."));
    assert(!tabs || Seam_Bevel < Board_Thickness - socket_roof_height, "Seam Bevel is so deep that it reaches the sockets.");
    assert(!connectors || connector_seat + connector_height < spec_height - 0.5,
        "A seated connector must stay below the socket roof.");
    assert(!connectors || spec_height <= Board_Thickness - Grid_Groove_Depth - 1,
        str("The connector sockets are ", spec_height, " mm deep, which leaves less than 1 mm under a grid groove. ",
            "Connectors need a board at least ", spec_height + Grid_Groove_Depth + 1, " mm thick."));
    assert(!keys || (Key_Waist < Key_Width && Key_Thickness + key_recess < Board_Thickness - Grid_Groove_Depth - 1),
        "The keys do not fit: Key Waist must be less than Key Width, and the pockets must stay 1 mm below the grid grooves.");
    assert(Seam_Underside_Bevel < Board_Thickness/4, "Seam Underside Bevel is too large for the board.");
    assert(!tabs || Seam_Underside_Bevel < Joint_Floor_Gap + Joint_Bottom_Chamfer,
        "Seam Underside Bevel must stay below the tabs. Reduce it, or raise Joint Floor Gap.");
    assert(!tongues || (tongue_center - spec_tongue_half_height - spec_tongue_clearance > Seam_Underside_Bevel + 0.5
                        && tongue_center + spec_tongue_half_height + spec_tongue_clearance
                           < Board_Thickness - Grid_Groove_Depth - max(Seam_Bevel, 1)),
        str("The board is too thin for seam tongues: it needs to be at least ",
            2*(spec_tongue_half_height + spec_tongue_clearance + Grid_Groove_Depth + 1), " mm thick. ",
            "Set Seam Tongues off, or make the board thicker."));
    assert(!Seam_Reveal || Seam_Bevel < Grid_Groove_Width,
        "With Seam Reveal, Seam Bevel must be less than Grid Groove Width, or the bevel cuts past the grid line.");
    assert(!split_lines || Seam_Bevel < Grid_Groove_Width/2,
        "With split lines, Seam Bevel must be less than half of Grid Groove Width, so the bevel stays inside the line.");
    assert(!connectors || min(concat([for (ty = [0:panel_rows - 1]) if (panel_columns > 1) seam_joints_y(ty)],
                                     [for (tx = [0:panel_columns - 1]) if (panel_rows > 1) seam_joints_x(tx)], [9])) >= 1,
        str("A seam is too short for a connector: each needs a square whose middle is ", corner_clear,
            " mm from an inner corner. Use larger panels or modules."));
}
assert(Underside_Relief == 0 || 2*Support_Band < min(min([for (tx = [0:panel_columns - 1]) tile_width(tx)]),
                                                         min([for (ty = [0:panel_rows - 1]) tile_depth(ty)])),
    "The support band is wider than half a panel. Reduce Support Band, or set Underside Relief to 0.");
assert(Underside_Relief == 0 || !tabs || !seams_exist || Support_Band >= connector_extent + 2,
    "The support band must cover the sockets. Raise Support Band.");
assert(Output_Mode != "Loose parts" || loose_parts,
    "Loose parts shows the connectors or keys of a board. Set Joint Style to Connectors or Keys.");
assert(Output_Mode == "Assembled board" || Output_Mode == "All panels" || joint_test || Output_Mode == "Loose parts"
    || (Panel_X < panel_columns && Panel_Y < panel_rows),
    str("Panel X must be 0 to ", panel_columns - 1, " and Panel Y 0 to ", panel_rows - 1, "."));

// Information in the Console.
echo(str("KomaSCAD ban ", version, ". Board: ", board_width, " x ", board_depth, " x ", Board_Thickness,
         " mm. Panels: ", panel_columns, " x ", panel_rows, "."));
if (mark_on)
    echo(str("Maker's mark: about ", round(mark_extent[0]), " x ", round(mark_extent[1]), " mm. Main line ",
             round(mark_sizes[0]*10)/10, " mm, second line ", round(mark_sizes[1]*10)/10, " mm."));
if (seams_exist && tabs)
    echo(str(Joint_Style, " joints. Tab thickness at the seam / at the tip: ", tab_thickness, " / ", tab_tip_height,
             " mm. A pulled seam opens ", seam_play, " mm."));
if (seams_exist && keys)
    echo(str("Keys: ", key_count, " butterfly keys, and ", Key_Spares, " spares. ",
             "Lay the panels face down, press the keys in, and turn the board over."));
if (seams_exist && connectors)
    echo(str("Connectors: ", joint_total, ", and ", Connector_Spares, " spares. Press each in until it stops: ",
             "it pulls its seam closed. Each can also be an M4 x 22 socket head screw with an M4 nut, ",
             "or a #8-32 x 7/8 inch screw and nut."));
// komascad.py reads these lines: the fonts, the parts, each panel's column,
// row, width, depth and offset from the front-left corner of the board, and
// the number and kind of loose parts to print (0 for a board without them).
if (Export_Metadata) {
    echo("KOMASCAD_FONTS", mark_on ? concat([Mark_Font_1, Mark_Font_2], Mark_Emblem_Font == "" ? [] : [Mark_Emblem_Font]) : []);
    echo("KOMASCAD_EXPORT", [for (role = [0:1]) [role_names[role], material_name(role), material_rgb(role), true]]);
    echo("KOMASCAD_BAN", [board_width, board_depth, Board_Thickness], [panel_columns, panel_rows],
         [for (ty = [0:panel_rows - 1], tx = [0:panel_columns - 1])
             [tx, ty, tile_width(tx), tile_depth(ty), tile_x_min(tx) + Board_Margin, tile_y_min(ty) + Board_Margin]],
         loose_count, loose_name);
}


// ===== 8. Output ==============================================================

if (!Export_Metadata) {
    if (Output_Mode == "One panel") on_bed(tile_depth(Panel_Y)) children_of(Panel_X, Panel_Y);
    else if (Output_Mode == "All panels") all_panels();
    else if (joint_test) joint_test();
    else if (Output_Mode == "Loose parts") color(material_rgb(0)) loose_layout();
    else if (Output_Mode == "Color body") on_bed(tile_depth(Panel_Y)) color(material_rgb(0)) panel_body(Panel_X, Panel_Y);
    else if (Output_Mode == "Color markings") on_bed(tile_depth(Panel_Y)) color(material_rgb(1)) panel_markings(Panel_X, Panel_Y);
    else assembled_board();
}

// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// KomaSCAD: a parametric shogi piece. Tested with OpenSCAD 2021.01.
// The default settings make the king of the bundled shogi set.
// Units are mm and degrees, before Model Scale, unless a comment says otherwise.
// Guides: README.md. Every setting: docs/parameters.md.
// Keep shogi_piece.json and move_diagrams.scad next to this file.

/* [01 - Start here] */
// A label for your own use. It does not change the piece.
Category = "King";
// Characters on the front, from the point to the heel.
Front_Characters = "王将";
// Characters on the back (the promoted side). Empty = blank back.
Back_Characters = "";
// An installed Japanese font. Find its exact name in Help > Font List.
Font_Name = "Yuji Syuku:style=Regular";
// Model shows the piece in its colors; press F6 for an STL. Use komascad.py export for a color 3MF.
Output_Mode = "Model"; // [Model,Blank,Inspect front,Inspect back,Inspect printability,Inspect signature,Inspect pawn circle]
// How the piece sits on the print bed. Raised text cannot touch the bed.
Print_Orientation = "Upright"; // [Upright,Front face down,Back face down]
// Multiplier for all lengths. 1 = the dimensions below.
Model_Scale = 1; // [0.25:0.05:20]

/* [02 - Piece dimensions] */
// mm. Length from the heel to the point.
Piece_Length = 32; // [15:0.1:100]
// mm. Width at the heel.
Base_Width = 28.5; // [10:0.1:100]
// mm. Thickness at the heel.
Rear_Thickness = 9.8; // [3:0.1:30]
// Tip thickness: set the thickness at the point. Reference side angles: set the slope of each face.
Taper_Mode = "Tip thickness"; // [Tip thickness,Reference side angles]
// mm. Thickness at the point, before the bevel.
Tip_Thickness = 3.2; // [1:0.1:20]

/* [03 - Front layout] */
// mm. Text size, not the measured glyph height. 0 = automatic.
Front_Font_Size = 10.4; // [0:0.1:40]
// Multiplier for the text size. 1.1 = 10% larger.
Front_Text_Scale = 1; // [0.25:0.01:2]
// mm. Distance between character centers. 0 = automatic.
Front_Character_Spacing = 10.5; // [0:0.1:40]
// Multiplier for the automatic spacing. It does not change the text size.
Front_Spacing_Scale = 1; // [0.5:0.01:2]
// Center of the text: 0 = heel, 1 = point. With Move Pitch above 0, the center of the characters only.
Front_Center_Fraction = 0.455; // [0:0.01:1]
// mm. Moves all the text. Positive = to the right.
Front_Text_X = 0; // [-20:0.1:20]
// mm. Moves all the text. Positive = toward the point.
Front_Text_Y = 0; // [-20:0.1:20]
// Multiplier for the glyph width. It does not change the spacing.
Front_Width_Scale = 1; // [0.25:0.01:2]
// Multiplier for the glyph height.
Front_Height_Scale = 1.06; // [0.25:0.01:2]
// Degrees, counterclockwise. Turns all the text around its center.
Front_Text_Rotation = 0; // [-180:1:180]

/* [04 - Back layout] */
// Use the front layout, text style, depth and stroke on the back. Back text and color stay separate.
Mirror_Front_Settings = false;
// mm. Text size, not the measured glyph height. 0 = automatic.
Back_Font_Size = 0; // [0:0.1:40]
// Multiplier for the text size. 1.1 = 10% larger.
Back_Text_Scale = 1; // [0.25:0.01:2]
// mm. Distance between character centers. 0 = automatic.
Back_Character_Spacing = 0; // [0:0.1:40]
// Multiplier for the automatic spacing. It does not change the text size.
Back_Spacing_Scale = 1; // [0.5:0.01:2]
// Center of the text: 0 = heel, 1 = point. With Move Pitch above 0, the center of the characters only.
Back_Center_Fraction = 0.42; // [0:0.01:1]
// mm. Moves all the text. Positive = to the right, seen from the back.
Back_Text_X = 0; // [-20:0.1:20]
// mm. Moves all the text. Positive = toward the point.
Back_Text_Y = 0; // [-20:0.1:20]
// Multiplier for the glyph width. It does not change the spacing.
Back_Width_Scale = 1; // [0.25:0.01:2]
// Multiplier for the glyph height.
Back_Height_Scale = 1; // [0.25:0.01:2]
// Degrees, counterclockwise. Turns all the text around its center.
Back_Text_Rotation = 0; // [-180:1:180]

/* [05 - Front character adjustments] */
// Multiplier for each character: [first, second, third], from the point. A diagram uses the entry of its slot.
Front_Glyph_Size = [1, 1, 1]; // [0.25:0.01:2]
// Multiplier for the width of each character.
Front_Glyph_Width = [1, 1.4, 1]; // [0.25:0.01:2]
// Multiplier for the height of each character.
Front_Glyph_Height = [1, 1, 1]; // [0.25:0.01:2]
// mm. Moves each character. Positive = to the right.
Front_Glyph_X = [0, 0, 0]; // [-10:0.1:10]
// mm. Moves each character. Positive = toward the point.
Front_Glyph_Y = [2, -1, 0]; // [-10:0.1:10]
// Degrees, counterclockwise. Turns each character.
Front_Glyph_Rotation = [0, 0, 0]; // [-180:1:180]

/* [06 - Back character adjustments] */
// Multiplier for each character: [first, second, third], from the point. A diagram uses the entry of its slot.
Back_Glyph_Size = [1, 1, 1]; // [0.25:0.01:2]
// Multiplier for the width of each character.
Back_Glyph_Width = [1, 1, 1]; // [0.25:0.01:2]
// Multiplier for the height of each character.
Back_Glyph_Height = [1, 1, 1]; // [0.25:0.01:2]
// mm. Moves each character. Positive = to the right, seen from the back.
Back_Glyph_X = [0, 0, 0]; // [-10:0.1:10]
// mm. Moves each character. Positive = toward the point.
Back_Glyph_Y = [1, 0, 0]; // [-10:0.1:10]
// Degrees, counterclockwise. Turns each character.
Back_Glyph_Rotation = [0, 0, 0]; // [-180:1:180]

/* [07 - Filament colors] */
// Body color. It becomes a named material in the color 3MF. Custom uses Body Color.
Body_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Front text color.
Front_Filament = "Black"; // [Same as body,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Back text color.
Back_Filament = "Red"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]

/* [08 - Engraving and stroke weight] */
// Face only: color the groove floor. Painted grooves: floor and walls. Flush filled: fill the groove.
Text_Color_Treatment = "Flush filled"; // [Face only,Painted grooves,Flush filled]
// Recessed: cut into the face. Raised: stands up from the face. None: no text.
Front_Text_Style = "Recessed"; // [Recessed,Raised,None]
// Recessed: cut into the face. Raised: stands up from the face. None: no text.
Back_Text_Style = "Recessed"; // [Recessed,Raised,None]
// mm. Depth of recessed text, or height of raised text.
Front_Relief_Depth = 0.35; // [0:0.05:3]
// mm. Depth of recessed text, or height of raised text.
Back_Relief_Depth = 0.35; // [0:0.05:3]
// mm. Makes each stroke wider (positive) or thinner (negative). Wide strokes can close small gaps.
Front_Stroke_Expansion = 0.04; // [-0.2:0.01:0.5]
// mm. Makes each stroke wider (positive) or thinner (negative). Wide strokes can close small gaps.
Back_Stroke_Expansion = 0.04; // [-0.2:0.01:0.5]
// A different font for the front. Empty = Font Name.
Front_Font_Override = "";
// A different font for the back. Empty = Font Name.
Back_Font_Override = "";
// mm. Rounds the text edges. 0 = sharp. Rounding can remove thin strokes.
Text_Edge_Radius = 0; // [0:0.01:0.5]
// Number of layers that make a rounded text edge.
Text_Rounding_Steps = 6; // [2:1:12]

/* [09 - Edges and face margin] */
// mm. Width of the edge bevel, seen from above. 0 = no bevel.
Bevel_Width = 0; // [0:0.05:3]
// mm. Depth of the edge bevel. 0 = no bevel.
Bevel_Depth = 0; // [0:0.02:2]
// mm. Smallest distance from the text to the edge of the flat face.
Text_Margin = 0.9; // [0:0.1:4]
// Cut off text that goes past the margin. Inspect front and Inspect back show it in red.
Protect_Face_Edges = true;
// mm, after Model Scale. Smallest solid thickness at the point, between the front and back recesses.
Minimum_Web = 1.2; // [0.2:0.1:5]

/* [10 - Advanced shape angles] */
// Make the outline fit 20 pieces into a ring (base angle 81 degrees). Check it with Inspect pawn circle.
Pawn_Circle = true;
// The angle to calculate from the other two: 2 x base + 2 x shoulder + tip = 540 degrees.
Angle_Mode = "Derive shoulder"; // [Derive shoulder,Derive tip,Derive base,Check all three]
// Degrees. Outline angle at the two heel corners.
Face_Base_Angle = 81;
// Degrees. Outline angle at the two shoulders.
Face_Shoulder_Angle = 117;
// Degrees. Outline angle at the point.
Face_Tip_Angle = 144;
// Degrees. Slope of the front face at the heel. Only for Reference side angles.
Front_Side_Base_Angle = 85;
// Degrees. Slope of the back face at the heel. Only for Reference side angles.
Back_Side_Base_Angle = 81;

/* [11 - Inspection and quality] */
// [red, green, blue, opacity], 0 to 1. Used when Body Filament is Custom.
Body_Color = [0.82, 0.68, 0.43, 1];
// [red, green, blue, opacity], 0 to 1. Used when Front Filament is Custom.
Front_Inscription_Color = [0.025, 0.02, 0.015, 1];
// [red, green, blue, opacity], 0 to 1. Used when Back Filament is Custom.
Back_Inscription_Color = [0.65, 0.05, 0.04, 1];
// Show the safe area and the center line in the Inspect views.
Show_Layout_Guides = true;
// Number of segments in a curve. More is smoother and slower.
Text_Curve_Resolution = 64; // [16:8:128]
// mm, after Model Scale. The line width of your printer on the face. Inspect printability and komascad.py check use it.
Print_Line_Width = 0.5; // [0.2:0.05:1.2]

/* [12 - Maker signature on heel] */
// Put a mark on the heel (the wide bottom edge).
Signature_Enabled = false;
// The mark. It reads left to right when you look at the heel with the front face up.
Signature_Text = "";
// Font of the mark. Empty = Font Name.
Signature_Font = "";
// mm. Text size of the mark.
Signature_Font_Size = 5; // [0.5:0.1:8]
// Multiplier for the letter spacing.
Signature_Letter_Spacing = 1; // [0.5:0.05:2]
// mm. Moves the mark. Positive = to the right.
Signature_X = 0; // [-12:0.1:12]
// mm. Moves the mark. Positive = toward the front face.
Signature_Y = 0; // [-5:0.1:5]
// Degrees, counterclockwise. Turns the mark.
Signature_Rotation = 0; // [-180:1:180]
// mm. Depth of the mark into the heel.
Signature_Depth = 0.2; // [0:0.05:2]
// mm. Smallest distance from the mark to the heel edges.
Signature_Margin = 0.6; // [0.1:0.1:3]
// Color of the mark.
Signature_Filament = "Same as front"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// [red, green, blue, opacity], 0 to 1. Used when Signature Filament is Custom.
Signature_Color = [0.025, 0.02, 0.015, 1];

/* [13 - Movement diagrams] */
// Movement grid, rows from point to heel, / between rows. See docs/move-diagrams.md. Empty = none.
Front_Moves = "";
// Put the diagram below or above the characters.
Front_Move_Position = "Below"; // [Below,Above]
// Movement grid for the back, after promotion. Empty = no diagram.
Back_Moves = "";
// Put the diagram below or above the characters.
Back_Move_Position = "Below"; // [Below,Above]
// mm, after Model Scale. Thinnest diagram line.
Move_Stroke = 0.6; // [0.3:0.05:2]
// mm, after Model Scale. Smallest space between diagram marks.
Move_Gap = 0.6; // [0.3:0.05:2]
// mm, after Model Scale. Distance between squares. 0 = automatic. Use one value for all pieces of a set.
Move_Pitch = 0; // [0:0.05:10]

/* [Hidden] */
// komascad.py sets this to read the materials and fonts without making geometry.
Export_Metadata = false;

// General helpers.
function in_list(x, list) = len([for (y = list) if (x == y) 1]) > 0;
function sum(v, n) = n <= 0 ? 0 : v[n-1] + sum(v, n-1);
function unit(v) = v/norm(v);
function inward(v) = [-v[1], v[0]];

version = "3.5";   // the same as VERSION in komascad.py; a test checks this
$fn = Text_Curve_Resolution;
epsilon = 0.02;   // overlap that keeps boolean operations clean


// ===== 1. Face settings ======================================================
// f is true for the front and false for the back.

function chars(f) = f ? Front_Characters : Back_Characters;
function move_grid(f) = f ? Front_Moves : Back_Moves;
function has_moves(f) = len(move_grid(f)) > 0;
function moves_above(f) = has_moves(f) && (f ? Front_Move_Position : Back_Move_Position) == "Above";

// Settings that the back takes from the front when Mirror Front Settings is on.
function pick(f, front, back) = f || Mirror_Front_Settings ? front : back;
function style(f)             = pick(f, Front_Text_Style, Back_Text_Style);
function depth(f)             = pick(f, Front_Relief_Depth, Back_Relief_Depth);
function stroke_expansion(f)  = pick(f, Front_Stroke_Expansion, Back_Stroke_Expansion);
function font_override(f)     = pick(f, Front_Font_Override, Back_Font_Override);
function font(f)              = font_override(f) == "" ? Font_Name : font_override(f);
function font_size_setting(f) = pick(f, Front_Font_Size, Back_Font_Size);
function text_scale(f)        = pick(f, Front_Text_Scale, Back_Text_Scale);
function spacing_setting(f)   = pick(f, Front_Character_Spacing, Back_Character_Spacing);
function spacing_scale(f)     = pick(f, Front_Spacing_Scale, Back_Spacing_Scale);
function center_fraction(f)   = pick(f, Front_Center_Fraction, Back_Center_Fraction);
function text_x(f)            = pick(f, Front_Text_X, Back_Text_X);
function text_y(f)            = pick(f, Front_Text_Y, Back_Text_Y);
function text_rotation(f)     = pick(f, Front_Text_Rotation, Back_Text_Rotation);

// Per-character lists. Entries after the third are neutral.
function entry(list, i, neutral) = i < len(list) ? list[i] : neutral;
function glyph_size(f, i)     = entry(pick(f, Front_Glyph_Size, Back_Glyph_Size), i, 1);
function glyph_width(f, i)    = entry(pick(f, Front_Glyph_Width, Back_Glyph_Width), i, 1)
                                * pick(f, Front_Width_Scale, Back_Width_Scale);
function glyph_height(f, i)   = entry(pick(f, Front_Glyph_Height, Back_Glyph_Height), i, 1)
                                * pick(f, Front_Height_Scale, Back_Height_Scale);
function glyph_x(f, i)        = entry(pick(f, Front_Glyph_X, Back_Glyph_X), i, 0);
function glyph_y(f, i)        = entry(pick(f, Front_Glyph_Y, Back_Glyph_Y), i, 0);
function glyph_rotation(f, i) = entry(pick(f, Front_Glyph_Rotation, Back_Glyph_Rotation), i, 0);

// A face holds its characters, plus one slot for the diagram above or below them.
function slots(f) = len(chars(f)) + (has_moves(f) ? 1 : 0);
function diagram_slot(f) = !has_moves(f) ? -1 : moves_above(f) ? 0 : slots(f) - 1;
function active(f) = slots(f) > 0 && style(f) != "None" && depth(f) > 0;
function recessed(f) = active(f) && style(f) == "Recessed";

// Each printed part has a role. The color 3MF has one part for each role.
body_role = 0;
front_role = 1;
back_role = 2;
signature_role = 3;
function face_role(f) = f ? front_role : back_role;

filament_palette = [
    ["Wood", [0.76, 0.58, 0.34, 1]],   ["Black", [0.08, 0.06, 0.04, 1]],
    ["White", [0.95, 0.95, 0.95, 1]],  ["Red", [0.65, 0.05, 0.04, 1]],
    ["Blue", [0.08, 0.25, 0.8, 1]],    ["Green", [0.08, 0.5, 0.2, 1]],
    ["Purple", [0.45, 0.15, 0.65, 1]], ["Yellow", [0.95, 0.8, 0.08, 1]],
    ["Orange", [0.95, 0.35, 0.05, 1]], ["Silver", [0.7, 0.72, 0.75, 1]],
    ["Gold", [0.8, 0.62, 0.2, 1]],     ["Glitter silver", [0.7, 0.72, 0.75, 1]],
    ["Glitter gold", [0.8, 0.62, 0.2, 1]],
    ["Filament 1", [0.5, 0.5, 0.5, 1]], ["Filament 2", [0.15, 0.5, 0.85, 1]], ["Filament 3", [0.85, 0.25, 0.5, 1]]
];
role_names = ["body", "front", "back", "signature"];
function filament(role) = [Body_Filament, Front_Filament, Back_Filament, Signature_Filament][role];
// The role whose filament this role uses: "Same as body" and "Same as front" point to another role.
function material_source(role) =
      filament(role) == "Same as body" ? body_role
    : filament(role) == "Same as front" ? material_source(front_role)
    : role;
function material_name(role) =
    let(src = material_source(role))
    filament(src) == "Custom" ? str("Custom ", role_names[src]) : filament(src);
function material_rgb(role) =
    let(src = material_source(role), name = filament(src), found = [for (p = filament_palette) if (p[0] == name) p[1]])
    name == "Custom" ? [Body_Color, Front_Inscription_Color, Back_Inscription_Color, Signature_Color][src]
    : assert(len(found) == 1, str("Unknown filament: ", name)) found[0];


// ===== 2. Piece body ==========================================================
// Plan view: x across the piece, y from the heel (y = 0) to the point.
// z is the thickness: the back face is near z = 0, the front face on top.

// The outline angles. Angle Mode selects the one that follows from the other two.
base_angle = Angle_Mode == "Derive base"
    ? (Pawn_Circle ? 81 : (540 - 2*Face_Shoulder_Angle - Face_Tip_Angle)/2)
    : Face_Base_Angle;
shoulder_angle = Angle_Mode == "Derive shoulder" ? (540 - 2*Face_Base_Angle - Face_Tip_Angle)/2 : Face_Shoulder_Angle;
tip_angle = Angle_Mode == "Derive tip" ? 540 - 2*Face_Base_Angle - 2*Face_Shoulder_Angle : Face_Tip_Angle;

// Each face drops this far in z for each mm toward the point.
front_slope = Taper_Mode == "Tip thickness"
    ? (Rear_Thickness - Tip_Thickness)/(2*Piece_Length)
    : 1/tan(Front_Side_Base_Angle);
back_slope = Taper_Mode == "Tip thickness" ? front_slope : 1/tan(Back_Side_Base_Angle);
tip_thickness = Rear_Thickness - Piece_Length*(front_slope + back_slope);

shoulder_y = (Piece_Length - Base_Width/2*tan((180 - tip_angle)/2))
             / (1 - tan(90 - base_angle)*tan((180 - tip_angle)/2));
shoulder_x = Base_Width/2 - shoulder_y*tan(90 - base_angle);
outline = [[-Base_Width/2, 0], [Base_Width/2, 0], [shoulder_x, shoulder_y],
           [0, Piece_Length], [-shoulder_x, shoulder_y]];

// Corner i of the outline, moved inward by distance from both of its edges.
function inset_point(i, distance) =
    let(p = outline[i], before = inward(unit(p - outline[(i+4)%5])), after = inward(unit(outline[(i+1)%5] - p)))
    p + distance*(before + after)/(1 + before*after);

has_bevel = Bevel_Width > 0 && Bevel_Depth > 0;
bevel_outline = [for (i = [0:4]) inset_point(i, Bevel_Width)];
flat_outline = has_bevel ? bevel_outline : outline;   // the flat face, inside the bevel
safe_inset = (has_bevel ? Bevel_Width : 0) + Text_Margin;
safe_outline = [for (i = [0:4]) inset_point(i, safe_inset)];   // the text stays inside this

function back_face_z(p) = p[1]*back_slope;
function front_face_z(p) = Rear_Thickness - p[1]*front_slope;

// The body is a stack of 5-point rings from the back face to the front face.
// Every point of a face comes from one plane equation, so each face stays flat.
body_rings = has_bevel
    ? [[for (p = bevel_outline) [p[0], p[1], back_face_z(p)]],
       [for (p = outline) [p[0], p[1], back_face_z(p) + Bevel_Depth]],
       [for (p = outline) [p[0], p[1], front_face_z(p) - Bevel_Depth]],
       [for (p = bevel_outline) [p[0], p[1], front_face_z(p)]]]
    : [[for (p = outline) [p[0], p[1], back_face_z(p)]],
       [for (p = outline) [p[0], p[1], front_face_z(p)]]];
body_points = [for (ring = body_rings, p = ring) p];
last_ring = len(body_rings) - 1;
// The faces: the back face, then the sides ring by ring, then the front face.
body_faces = concat(
    [[4, 3, 2, 1, 0]],
    [for (r = [0:last_ring-1], i = [0:4]) [5*r + i, 5*r + (i+1)%5, 5*(r+1) + (i+1)%5, 5*(r+1) + i]],
    [[for (i = [0:4]) 5*last_ring + i]]);
back_face_index = 0;
front_face_index = len(body_faces) - 1;
heel_face_index = 1 + (has_bevel ? 5 : 0);   // the side between corners 0 and 1

// Triangulate in a fixed way, so that CGAL output is the same every time.
function triangles(face) = [for (k = [1:len(face)-2]) [face[0], face[k], face[k+1]]];
module body_shell(omit=[]) {
    polyhedron(points=body_points, convexity=10,
        faces=[for (i = [0:len(body_faces)-1], t = triangles(body_faces[i]))
                   if (!in_list(i, omit)) [t[2], t[1], t[0]]]);
}
module blank() { body_shell(); }


// ===== 3. Text layout =========================================================
// Text is drawn flat in face coordinates: x across, y along the face from the
// heel, z out of the face. on_face() puts it on the sloped face.

// Automatic text size: the characters fill auto_fill of the face length, at
// auto_slot_sizes text sizes per slot, and are never wider than max_width_share
// of the heel. Each character slot is spacing_sizes text sizes long.
auto_fill = 0.72;
auto_slot_sizes = 1.35;
max_width_share = 0.43;
spacing_sizes = 1.42;
// With a diagram, the characters and the diagram fill this share of the safe face length.
move_fill = 0.9;
// Without Move Pitch, a diagram grows up to this many text sizes.
diagram_growth = 1.2;

function slope(f) = f ? front_slope : back_slope;
function cosine(f) = 1/sqrt(1 + slope(f)*slope(f));
function face_length(f) = Piece_Length/cosine(f);
function face_polygon(points, f) = [for (p = points) [p[0], p[1]/cosine(f)]];
function safe_ys(f) = [for (p = safe_outline) p[1]/cosine(f)];
function safe_length(f) = max(safe_ys(f)) - min(safe_ys(f));

// With a diagram, the characters get the face length that the smallest
// printable diagram leaves. The space above the diagram is (spacing_sizes - 1) sizes.
function auto_font_size(f) =
    let(n = len(chars(f)))
    has_moves(f) && n > 0
    ? (safe_length(f)*move_fill - min_diagram_size(f)[1]) / (spacing_sizes*spacing_scale(f)*n + spacing_sizes - 1)
    : face_length(f)*auto_fill/(auto_slot_sizes*max(1, slots(f)));
function font_size(f) =
    text_scale(f) * (font_size_setting(f) > 0 ? font_size_setting(f)
                     : min(Base_Width*max_width_share, auto_font_size(f)));
function char_spacing(f) =
    spacing_setting(f) > 0 ? spacing_setting(f) : font_size(f)*spacing_sizes*spacing_scale(f);

// Slots stack from the point to the heel. A character slot is one character
// spacing long. A diagram slot is the diagram plus the space above a character.
function slot_height(f, i) =
    i == diagram_slot(f) ? diagram_size(f)[1] + char_spacing(f) - font_size(f) : char_spacing(f);
function slot_heights(f) = [for (i = [0:slots(f)-1]) slot_height(f, i)];
function stack_height(f) = sum(slot_heights(f), slots(f));
// The center of slot i, from the center of the stack.
function slot_y(f, i) = stack_height(f)/2 - sum(slot_heights(f), i) - slot_heights(f)[i]/2;

// The center of the stack on the face.
function center_y(f) =
    let(c = face_length(f)*center_fraction(f) + text_y(f), n = len(chars(f)))
    !has_moves(f) ? c
    // With a fixed Move Pitch (a set), Center Fraction places the characters, and
    // the diagram goes beside them. The characters then line up on every piece.
    : Move_Pitch > 0 && n > 0 ? c - sum([for (i = [0:slots(f)-1]) if (i != diagram_slot(f)) slot_y(f, i)], n)/n
    // Otherwise keep the stack inside the face. The fit check stops a stack that is too long.
    : let(half = stack_height(f)/2) max(min(safe_ys(f)) + half, min(max(safe_ys(f)) - half, c));

// Face coordinates to model coordinates. The back is turned over, so that its text reads correctly.
module on_face(f) {
    s = f ? 1 : -1;
    c = cosine(f);
    multmatrix([[s, 0, 0, 0],
                [0, c, slope(f)*c, 0],
                [0, -s*slope(f)*c, s*c, f ? Rear_Thickness : 0],
                [0, 0, 0, 1]]) children();
}
module safe_face(f) { polygon(face_polygon(safe_outline, f)); }
module flat_face(f) { polygon(face_polygon(flat_outline, f)); }

// The characters and the diagram, before Protect Face Edges.
module raw_inscription(f, diagram=true) {
    if (slots(f) > 0 && style(f) != "None")
    translate([text_x(f), center_y(f)]) rotate(text_rotation(f))
    for (i = [0:slots(f)-1])
        translate([glyph_x(f, i), slot_y(f, i) + glyph_y(f, i)]) rotate(glyph_rotation(f, i))
        if (i == diagram_slot(f)) { if (diagram) move_diagram(f); }
        // Stroke expansion is for lettering only. Expand after scaling, so that it stays a true mm value.
        else offset(delta=stroke_expansion(f)) scale(glyph_size(f, i)*[glyph_width(f, i), glyph_height(f, i)])
            text(chars(f)[moves_above(f) ? i-1 : i], size=font_size(f), font=font(f),
                 halign="center", valign="center", language="ja");
}
module inscription(f) {
    if (Protect_Face_Edges) intersection() { raw_inscription(f); safe_face(f); }
    else raw_inscription(f);
}


// ===== 4. Movement diagrams ===================================================
// move_diagrams.scad reads the grids and lays out the marks. This section sizes
// the diagram of each face.

mv_w = Move_Stroke/Model_Scale;   // the thinnest line
mv_g = Move_Gap/Model_Scale;      // the smallest space between marks
mv_min_head = 2.4/Model_Scale;    // a slicer turns a shorter arrowhead into a dot
include <move_diagrams.scad>

// OpenSCAD does not cache function results, and the solver is slow. Thus each
// face's diagram is solved once here, and the functions below read the result.
front_moves = has_moves(true) ? mv_grid_moves("Front_Moves", Front_Moves) : [];
back_moves = has_moves(false) ? mv_grid_moves("Back_Moves", Back_Moves) : [];
// The smallest printable diagram. It sets how much the automatic text size shrinks.
front_min_pitch = has_moves(true) ? mv_solve(front_moves, mv_w) : 0;
back_min_pitch = has_moves(false) ? mv_solve(back_moves, mv_w) : 0;
front_min_size = has_moves(true) ? mv_size(mv_box(front_moves, front_min_pitch)) : [0, 0];
back_min_size = has_moves(false) ? mv_size(mv_box(back_moves, back_min_pitch)) : [0, 0];
function moves(f) = f ? front_moves : back_moves;
function min_pitch(f) = f ? front_min_pitch : back_min_pitch;
function min_diagram_size(f) = f ? front_min_size : back_min_size;

// The drawn pitch. A larger pitch only makes the gaps wider, so it stays
// printable. Without Move Pitch, the diagram grows to about one character, but
// only into face length that the characters leave free. A Glyph Size above 1
// for the diagram slot makes it larger.
function drawn_pitch(f) =
    Move_Pitch > 0 ? Move_Pitch/Model_Scale :
    let(size = min_diagram_size(f),
        letters = len(chars(f))*char_spacing(f) + char_spacing(f) - font_size(f),
        room = (safe_length(f)*move_fill - letters)/size[1])
    min_pitch(f) * max(1, min(diagram_growth*font_size(f)/max(size), room)) * max(1, glyph_size(f, diagram_slot(f)));
front_pitch = has_moves(true) ? drawn_pitch(true) : 0;
back_pitch = has_moves(false) ? drawn_pitch(false) : 0;
front_box = has_moves(true) ? mv_box(front_moves, front_pitch) : [[0, 0], [0, 0]];
back_box = has_moves(false) ? mv_box(back_moves, back_pitch) : [[0, 0], [0, 0]];
function pitch(f) = f ? front_pitch : back_pitch;
function diagram_box(f) = f ? front_box : back_box;
function diagram_size(f) = mv_size(diagram_box(f));

module move_diagram(f) { mv_draw(moves(f), pitch(f), diagram_box(f)); }


// ===== 5. The printed piece ===================================================

// A rounded text edge is built from thin layers; this is the outline of one layer.
module rounded_outline(f, r, expansion) {
    if (expansion > 0) offset(r=expansion) offset(delta=-r) inscription(f);
    else offset(delta=-r) inscription(f);
}
function text_radius(f) = min(Text_Edge_Radius, depth(f)/2);

// The text as a 3D cutter (Recessed) or solid (Raised), on its face.
module relief(f) {
    d = depth(f);
    raised = style(f) == "Raised";
    r = text_radius(f);
    zmin = raised ? -epsilon : -d;
    zmax = raised ? d : epsilon;
    if (active(f)) on_face(f) {
        if (r == 0) translate([0, 0, zmin]) linear_extrude(zmax - zmin, convexity=20) inscription(f);
        else {
            // A straight part, then thin layers that step in to make the rounded edge.
            translate([0, 0, raised ? zmin : zmin + r])
                linear_extrude(zmax - zmin - r, convexity=20) rounded_outline(f, r, r);
            h = r/Text_Rounding_Steps;
            overlap = min(epsilon, h/10);
            for (i = [0:Text_Rounding_Steps-1]) {
                t = (i + 0.5)/Text_Rounding_Steps;
                z = raised ? zmax - r + i*h : zmin + r - (i+1)*h;
                translate([0, 0, raised ? z - overlap : z])
                    linear_extrude(h + overlap, convexity=20) rounded_outline(f, r, r*sqrt(1 - t*t));
            }
        }
    }
}

// The maker's signature on the heel. Heel coordinates: x = model x, y = model z.
function signature_active() = Signature_Enabled && len(Signature_Text) > 0 && Signature_Depth > 0;
function signature_font() = Signature_Font == "" ? Font_Name : Signature_Font;
heel_rim = has_bevel ? Bevel_Depth : 0;
sig_half_width = Base_Width/2 - Signature_Depth*tan(90 - base_angle) - Signature_Margin;
sig_low = max(heel_rim, Signature_Depth*back_slope) + Signature_Margin - Rear_Thickness/2;
sig_high = min(Rear_Thickness - heel_rim, Rear_Thickness - Signature_Depth*front_slope)
           - Signature_Margin - Rear_Thickness/2;
module on_heel() { multmatrix([[1, 0, 0, 0], [0, 0, -1, 0], [0, 1, 0, Rear_Thickness/2], [0, 0, 0, 1]]) children(); }
module signature_safe() { translate([-sig_half_width, sig_low]) square([2*sig_half_width, sig_high - sig_low]); }
module signature_raw() {
    translate([Signature_X, Signature_Y]) rotate(Signature_Rotation)
    text(Signature_Text, size=Signature_Font_Size, font=signature_font(), spacing=Signature_Letter_Spacing,
         halign="center", valign="center");
}
module signature_outline() { intersection() { signature_raw(); signature_safe(); } }
module signature_cutter() {
    if (signature_active()) on_heel() translate([0, 0, -Signature_Depth])
        linear_extrude(Signature_Depth + epsilon, convexity=20) signature_outline();
}

// The exact piece in one material, for F6 and STL export.
module piece() {
    difference() {
        union() { blank(); for (f = [true, false]) if (style(f) == "Raised") relief(f); }
        for (f = [true, false]) if (style(f) == "Recessed") relief(f);
        signature_cutter();
    }
}


// ===== 6. Color parts for the 3MF exporter ====================================
// komascad.py renders each part with Output_Mode "Color body", "Color front",
// "Color back" or "Color signature", and puts them together in one 3MF.
// The parts touch, but do not overlap.
//
// A color part is a color volume behind the visible text surface, cut to the
// piece. The body is the piece minus all color volumes. Where two color
// volumes meet, the signature wins over the front, and the front over the back.

color_backing = 0.8;   // mm of color behind the visible surface; a 0.4 mm nozzle cannot print less
paint_wall = 0.35;     // Painted grooves: width of color beside the groove wall
paint_lip = 0.03;      // Painted grooves: body color at the top of the groove wall

color_roles = [front_role, back_role, signature_role];
function role_active(role) = role == signature_role ? signature_active() : active(role == front_role);
function role_depth(role) = role == signature_role ? Signature_Depth : depth(role == front_role);
function role_raised(role) = role != signature_role && style(role == front_role) == "Raised";
// The bottom of the color volume, and the visible text surface.
function color_floor(role) = role_raised(role) ? -color_backing : -role_depth(role) - color_backing;
function text_surface(role) = role_raised(role) ? role_depth(role) : -role_depth(role);
module role_outline(role) { if (role == signature_role) signature_outline(); else inscription(role == front_role); }
module on_role(role) { if (role == signature_role) on_heel() children(); else on_face(role == front_role) children(); }
// The outline of a role, extruded from z = bottom to z = top (z = 0 on the surface, negative inside).
module role_slab(role, bottom, top, grow=0) {
    on_role(role) translate([0, 0, bottom])
        linear_extrude(top - bottom, convexity=20) offset(delta=grow) role_outline(role);
}

// Face only can use its color volumes as they are, without the slow cut to the
// piece: with sharp text edges and wide margins, they lie fully inside the body.
face_only_fast = Text_Color_Treatment == "Face only" && Text_Edge_Radius == 0
    && Text_Margin > color_backing*max(front_slope, back_slope) + epsilon
    && (!signature_active()
        || Signature_Margin > color_backing*max(tan(90 - base_angle), front_slope, back_slope) + epsilon);

module color_volume(role) {
    treatment = Text_Color_Treatment;
    if (role_active(role)) {
        // A level inlay from the backing up through the face.
        if (treatment == "Flush filled") role_slab(role, -color_backing, epsilon);
        // Face only: the backing under the groove floor, or raised text and its backing.
        else if (treatment == "Face only") role_slab(role, color_floor(role), text_surface(role));
        // Painted grooves: also the groove walls, up to just under the face.
        else if (treatment == "Painted grooves" && !role_raised(role))
            role_slab(role, color_floor(role), -paint_lip, paint_wall);
        // Painted grooves, raised text: slightly larger than the text, so that the cut to the piece is clean.
        else role_slab(role, color_floor(role), text_surface(role) + epsilon, epsilon/2);
    }
}
// The solid that the color volumes are cut from. A flush inlay fills the groove.
module color_solid() { if (Text_Color_Treatment == "Flush filled") blank(); else piece(); }

module color_part(role) {
    difference() {
        if (face_only_fast) color_volume(role);
        else intersection() { color_solid(); color_volume(role); }
        if (role == back_role) color_volume(front_role);
        if (role != signature_role) color_volume(signature_role);
    }
}
module body_part() {
    // Fast: cut the groove and the color volume out of the plain body in one
    // step. Raised text belongs to its color part, so the body does not get it.
    if (face_only_fast) difference() {
        blank();
        for (role = color_roles) if (role_active(role)) role_slab(role, color_floor(role), epsilon);
    }
    else difference() { color_solid(); for (role = color_roles) color_volume(role); }
}


// ===== 7. Fast preview (F5) ===================================================
// On some graphics drivers, OpenSCAD 2021 shows an empty view after it
// subtracts text in F5. F5 Model therefore draws an open shell: the body
// without its text faces, each face as a thin skin with the text cut out in 2D,
// and the groove walls and floors at their true depth. F6 and the exporter use
// the exact geometry above.

module opening(f) { if (text_radius(f) == 0) inscription(f); else rounded_outline(f, text_radius(f), text_radius(f)); }
module floor_outline(f) { if (text_radius(f) == 0) inscription(f); else rounded_outline(f, text_radius(f), 0); }
// Groove walls: dark on a light body, light on a dark body, mixed with the body
// color. Light or dark is the perceived brightness (Rec. 601 weights).
function preview_wall_rgb() =
    let(body = material_rgb(body_role), mark = 0.299*body[0] + 0.587*body[1] + 0.114*body[2] > 0.45 ? 0.035 : 0.88)
    [for (i = [0:2]) (2*body[i] + mark)/3, 1];
// A thin outline of a 2D shape.
module rim(width) { difference() { offset(delta=width/2) children(); offset(delta=-width/2) children(); } }

module print_preview() {
    painted = Text_Color_Treatment == "Painted grooves";
    flush = Text_Color_Treatment == "Flush filled";
    color(material_rgb(body_role)) {
        body_shell(omit=concat(recessed(false) ? [back_face_index] : [],
                               recessed(true) ? [front_face_index] : [],
                               signature_active() ? [heel_face_index] : []));
        for (f = [true, false]) if (recessed(f))
            on_face(f) translate([0, 0, -epsilon/2]) linear_extrude(epsilon/2, convexity=20)
                difference() { flat_face(f); opening(f); }
        if (signature_active())
            on_heel() translate([0, 0, -epsilon/2]) linear_extrude(epsilon/2, convexity=20) difference() {
                translate([-Base_Width/2, -Rear_Thickness/2 + heel_rim])
                    square([Base_Width, Rear_Thickness - 2*heel_rim]);
                signature_outline();
            }
    }
    // The groove walls.
    if (!flush) {
        for (f = [true, false]) if (recessed(f))
            color(painted ? material_rgb(face_role(f)) : preview_wall_rgb())
            on_face(f) translate([0, 0, -depth(f)]) linear_extrude(depth(f), convexity=20) rim(epsilon) opening(f);
        if (signature_active())
            color(painted ? material_rgb(signature_role) : preview_wall_rgb())
            on_heel() translate([0, 0, -Signature_Depth]) linear_extrude(Signature_Depth, convexity=20)
                rim(epsilon) signature_outline();
    }
    // The colored surfaces.
    grow = painted ? paint_wall : 0;
    for (f = [true, false]) if (active(f)) color(material_rgb(face_role(f))) {
        if (style(f) == "Raised") relief(f);
        else if (flush) on_face(f) linear_extrude(epsilon/2, convexity=20) opening(f);
        else on_face(f) translate([0, 0, -depth(f)]) linear_extrude(epsilon/2, convexity=20)
            offset(delta=grow) floor_outline(f);
    }
    if (signature_active())
        color(material_rgb(signature_role)) on_heel() translate([0, 0, flush ? 0 : -Signature_Depth])
        linear_extrude(epsilon/2, convexity=20) offset(delta=grow) signature_outline();
}


// ===== 8. Inspection views (F5 only) ==========================================

guide_rgb = [0.1, 0.5, 0.9, 0.65];
module guide_line(width=0.08) { difference() { children(); offset(delta=-width) children(); } }
module preview_only() { assert($preview, "Inspect views are F5 only. Select Model or Blank to export an STL."); }

// One face, flat: the text in its color, overflow in red, the safe area in blue.
module inspect_face(f) {
    preview_only();
    color(material_rgb(body_role)) linear_extrude(0.1) polygon(face_polygon(outline, f));
    if (active(f)) {
        color(material_rgb(face_role(f))) translate([0, 0, 0.12]) linear_extrude(0.02)
            intersection() { raw_inscription(f); safe_face(f); }
        color([1, 0, 0, 1]) translate([0, 0, 0.15]) linear_extrude(0.02)
            difference() { raw_inscription(f); safe_face(f); }
    }
    if (Show_Layout_Guides) {
        color(guide_rgb) translate([0, 0, 0.11]) linear_extrude(0.005) guide_line() safe_face(f);
        color(guide_rgb) translate([-0.025, 0, 0.11]) cube([0.05, face_length(f), 0.005]);
        // One printed line at final size, beside the piece.
        color([0.1, 0.5, 0.9, 1]) translate([Base_Width/2 + 2, 2, 0])
            cube([Print_Line_Width/Model_Scale, 5/Model_Scale, 0.1]);
    }
}

module inspect_signature() {
    preview_only();
    color(material_rgb(body_role)) linear_extrude(0.1) square([Base_Width, Rear_Thickness], center=true);
    if (signature_active()) {
        color(material_rgb(signature_role)) translate([0, 0, 0.12]) linear_extrude(0.02) signature_outline();
        color([1, 0, 0, 1]) translate([0, 0, 0.15]) linear_extrude(0.02)
            difference() { signature_raw(); signature_safe(); }
    }
    if (Show_Layout_Guides)
        color(guide_rgb) translate([0, 0, 0.11]) linear_extrude(0.005) guide_line() signature_safe();
}

// Twenty outlines in a ring, in plan view, without text, taper or bevel.
pawn_circle_apothem = Base_Width/(2*tan(9));
module inspect_pawn_circle() {
    preview_only();
    assert(Pawn_Circle, "Turn on Pawn Circle first.");
    for (i = [0:19]) rotate(i*18) translate([0, -pawn_circle_apothem]) {
        color(i%2 == 0 ? material_rgb(body_role) : [0.64, 0.43, 0.22, 1]) linear_extrude(0.1) polygon(outline);
        if (Show_Layout_Guides)
            color([0.1, 0.5, 0.9, 1]) translate([0, 0, 0.11]) linear_extrude(0.005) guide_line() polygon(outline);
    }
    if (Show_Layout_Guides) color(guide_rgb) translate([0, 0, 0.11]) linear_extrude(0.005)
        rim(0.08) circle(r=Base_Width/(2*sin(9)), $fn=360);
}

// Printability. A stroke thinner than one printed line disappears under an
// opening (shrink by half a line, then grow back). A gap narrower than one line
// fills under a closing (grow, then shrink back). komascad.py check measures
// the area of each as a share of the lettering. Characters only: diagrams are
// made of lines and gaps of at least one printed line.
print_line = Print_Line_Width/Model_Scale;
module letters(f) { intersection() { raw_inscription(f, diagram=false); safe_face(f); } }
module thin_strokes(f) {
    difference() { letters(f); offset(r=print_line/2) offset(r=-print_line/2) letters(f); }
}
module narrow_gaps(f) {
    difference() { offset(r=-print_line/2) offset(r=print_line/2) letters(f); letters(f); }
}
module inspect_printability() {
    preview_only();
    for (f = [true, false]) if (active(f)) translate([(f ? -0.6 : 0.6)*Base_Width, 0, 0]) {
        color(material_rgb(body_role)) linear_extrude(0.1) flat_face(f);
        color(material_rgb(face_role(f))) translate([0, 0, 0.12]) linear_extrude(0.02) inscription(f);
        color([1, 0.85, 0, 1]) translate([0, 0, 0.16]) linear_extrude(0.02) thin_strokes(f);
        color([0.1, 0.6, 1, 1]) translate([0, 0, 0.16]) linear_extrude(0.02) narrow_gaps(f);
    }
    echo(str("Inspect printability: front left, back right. Yellow: strokes thinner than Print Line Width.",
             " Blue: gaps narrower than it."));
}
// komascad.py check exports these as 2D SVG, with Output_Mode "Printability <front|back> <ink|thin|gaps>".
module printability_layer(f, layer) {
    if (active(f) && len(chars(f)) > 0) {
        if (layer == "ink") letters(f);
        if (layer == "thin") thin_strokes(f);
        if (layer == "gaps") narrow_gaps(f);
    }
}


// ===== 9. Checks ==============================================================
// Stop with a message when the settings cannot make a piece.

assert(abs(2*base_angle + 2*shoulder_angle + tip_angle - 540) < 0.001,
    "The outline angles do not close. Choose a Derive mode, or correct the angles.");
assert(base_angle > 45 && base_angle < 90 && shoulder_angle > 90 && shoulder_angle < 180
       && tip_angle > 60 && tip_angle < 180,
    "The outline angles are outside the supported range.");
if (Pawn_Circle) {
    assert(abs(base_angle - 81) < 1e-6,
        str("Pawn Circle needs a base angle of 81 degrees; it is ", base_angle, ". Set it to 81, or use Derive base."));
    assert(Piece_Length < pawn_circle_apothem,
        str("Pawn Circle: the length must be less than ", pawn_circle_apothem, " mm at this width."));
}
if (Taper_Mode == "Tip thickness")
    assert(Tip_Thickness <= Rear_Thickness, "The tip cannot be thicker than the heel.");
else
    assert(Front_Side_Base_Angle > 60 && Front_Side_Base_Angle <= 90
           && Back_Side_Base_Angle > 60 && Back_Side_Base_Angle <= 90,
        "Side angles must be more than 60 and not more than 90 degrees.");
assert(shoulder_x > 0 && shoulder_y > 0 && shoulder_y < Piece_Length,
    "These dimensions and angles do not make a convex piece.");
assert(tip_thickness > 0, "The taper makes the point vanish. Increase the thickness, or reduce the taper.");
assert(Bevel_Width < min(Base_Width, Piece_Length)/8, "Bevel Width is too large.");
for (p = safe_outline, i = [0:4])
    assert((p - outline[i])*inward(unit(outline[(i+1)%5] - outline[i])) >= safe_inset - 0.0001
           && safe_outline[1][0] > safe_outline[0][0] && safe_outline[3][1] > safe_outline[2][1],
        "Text Margin leaves no face. Reduce the margin or the bevel, or make the piece larger.");
// The solid material at the point: the tip, less both bevels and both recesses.
function recess_z(f) = recessed(f) && Output_Mode != "Blank" ? depth(f)*sqrt(1 + pow(slope(f), 2)) : 0;
assert((tip_thickness - (has_bevel ? 2*Bevel_Depth : 0) - recess_z(true) - recess_z(false))*Model_Scale >= Minimum_Web,
    "Too little solid material at the point. Increase Tip Thickness, or reduce the recess depth or the bevel.");
for (f = [true, false])
    assert(!(style(f) == "Raised" && active(f) && Print_Orientation == (f ? "Front face down" : "Back face down")),
        str(f ? "Raised front" : "Raised back", " text would go into the bed. Choose another Print Orientation."));
if (Text_Color_Treatment == "Flush filled")
    for (f = [true, false]) assert(!active(f) || style(f) == "Recessed",
        "Flush filled needs Recessed text. Choose Face only or Painted grooves for Raised text.");
assert(Move_Stroke >= Print_Line_Width && Move_Gap >= Print_Line_Width,
    "Move Stroke and Move Gap cannot be less than Print Line Width.");
if (signature_active())
    assert(Signature_Depth < Piece_Length/4 && sig_half_width > 0 && sig_high > sig_low,
        "The signature margin and depth leave no space on the heel.");

// True when point q is inside or on the convex polygon poly.
function inside_convex(q, poly) =
    let(n = len(poly), sides = [for (i = [0:n-1]) let(a = poly[i], b = poly[(i+1)%n])
            (b[0] - a[0])*(q[1] - a[1]) - (b[1] - a[1])*(q[0] - a[0])])
    min(sides) >= -1e-6 || max(sides) <= 1e-6;

// A diagram never shrinks below printable, so a face that cannot hold it and
// its characters stops here. Inspect printability checks the characters.
for (f = [true, false]) if (has_moves(f) && active(f)) {
    name = f ? "Front" : "Back";
    ys = safe_ys(f);
    need = stack_height(f);
    assert(Move_Pitch == 0 || Move_Pitch/Model_Scale >= min_pitch(f) - 1e-6,
        str(name, " Moves need at least ", min_pitch(f)*Model_Scale, " mm between squares; Move Pitch is ",
            Move_Pitch, " mm."));
    assert(center_y(f) - need/2 >= min(ys) - 0.01 && center_y(f) + need/2 <= max(ys) + 0.01,
        Move_Pitch > 0 && len(chars(f)) > 0
        ? str(name, " characters and movement diagram run off the face. Move them with ", name,
              "_Center_Fraction, or raise Model Scale.")
        : str(name, " characters and movement diagram need ", need*Model_Scale, " mm of face length; the face has ",
              (max(ys) - min(ys))*Model_Scale, " mm. Raise Model Scale, or use fewer characters."));
    // Across the face too: Protect Face Edges would cut a wide diagram without a message.
    i = diagram_slot(f);
    size = diagram_size(f);
    at = [text_x(f) + glyph_x(f, i), center_y(f) + slot_y(f, i) + glyph_y(f, i)];
    corners_out = [for (dx = [-1, 1], dy = [-1, 1])
        if (!inside_convex(at + [dx*size[0]/2, dy*size[1]/2], face_polygon(safe_outline, f))) 1];
    assert(len(corners_out) == 0,
        str(name, " movement diagram is ", size[0]*Model_Scale, " mm wide and runs past the sides of the face.",
            " Raise Model Scale, lower Move Pitch, or move it with ", name, "_Center_Fraction."));
    // komascad.py and the tests read this line: the drawn pitch and size, then
    // the smallest printable ones, in final mm.
    echo("KOMASCAD_MOVES", name, pitch(f)*Model_Scale, diagram_size(f)*Model_Scale,
         min_pitch(f)*Model_Scale, min_diagram_size(f)*Model_Scale);
}

// Information in the Console.
echo(str("KomaSCAD ", version, ". Angles base / shoulder / point: ", base_angle, " / ", shoulder_angle, " / ",
         tip_angle, ". Tip thickness: ", tip_thickness*Model_Scale, " mm."));
for (f = [true, false]) if (slots(f) > 0)
    echo(str(f ? "Front" : "Back", " text size / spacing / center: ",
             font_size(f), " / ", char_spacing(f), " / ", center_y(f), " mm"));
if (Pawn_Circle)
    echo(str("Pawn Circle: outer diameter ", Base_Width/sin(9)*Model_Scale, " mm, inner diameter ",
             2*(pawn_circle_apothem - Piece_Length)*Model_Scale, " mm."));
// komascad.py reads these lines to name the materials and check the fonts.
if (Export_Metadata) {
    echo("KOMASCAD_FONTS", concat([for (f = [true, false]) if (active(f)) font(f)],
                                  signature_active() ? [signature_font()] : []));
    echo("KOMASCAD_EXPORT", [for (role = [0:3])
        [role_names[role], material_name(role), material_rgb(role), role == body_role || role_active(role)]]);
}


// ===== 10. Output =============================================================

module on_bed() {
    if (Print_Orientation == "Upright") translate([0, Rear_Thickness, 0]) rotate([90, 0, 0]) children();
    // Turn the piece over, make the front face level, and lift it onto the bed.
    else if (Print_Orientation == "Front face down")
        translate([0, 0, Rear_Thickness*cos(atan(front_slope))]) rotate([-atan(front_slope), 0, 0])
            rotate([0, 180, 0]) children();
    else if (Print_Orientation == "Back face down") rotate([-atan(back_slope), 0, 0]) children();
    else children();
}

printability_modes = [for (f = ["front", "back"], layer = ["ink", "thin", "gaps"]) str("Printability ", f, " ", layer)];
color_modes = ["Color body", "Color front", "Color back", "Color signature"];

if (!Export_Metadata) scale(Model_Scale) {
    if (Output_Mode == "Inspect front" || Output_Mode == "Inspect back") inspect_face(Output_Mode == "Inspect front");
    else if (Output_Mode == "Inspect printability") inspect_printability();
    else if (Output_Mode == "Inspect signature") inspect_signature();
    else if (Output_Mode == "Inspect pawn circle") inspect_pawn_circle();
    else if (in_list(Output_Mode, printability_modes)) {
        k = search([Output_Mode], printability_modes)[0];
        printability_layer(k < 3, ["ink", "thin", "gaps"][k%3]);
    }
    else on_bed() {
        if (Output_Mode == "Blank") color(material_rgb(body_role)) blank();
        else if (in_list(Output_Mode, color_modes)) {
            role = search([Output_Mode], color_modes)[0];   // the modes are in role order
            color(material_rgb(role)) render(convexity=30) if (role == body_role) body_part(); else color_part(role);
        }
        else if ($preview) print_preview();
        else color(material_rgb(body_role)) piece();
    }
}

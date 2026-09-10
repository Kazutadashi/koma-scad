// KomaSCAD — parametric shogi piece generator
// Units: millimetres and degrees. OpenSCAD 2021.01+
//
// Scaling examples:
//   Model_Scale = 1;    // normal 31.5 mm king
//   Model_Scale = 5;    // 157.5 mm display piece
//   Model_Scale = 10;   // 315 mm display piece

/* [Piece Category] */
// Project size profiles, not historical measurements. Custom uses Dimensions below.
Category = "Custom"; // [Custom,Shogi pawn,Shogi lance,Shogi knight,Shogi silver,Shogi gold,Shogi bishop,Shogi rook,Shogi king,Taikyoku small,Taikyoku medium,Taikyoku large,Taikyoku royal]

/* [Scale] */
// Uniformly scales the completed piece, including text and engraving depth.
Model_Scale = 1; // [0.25:0.25:20]

/* [Inscriptions] */
// IMPORTANT: When enabled, automatic layout overrides the manual Font Size,
// Character Spacing, Text Center, and Text X controls below.
Automatic_Text_Layout = false;

Front_Characters = "A";
Back_Characters = "B";

// Liberation Sans is normally available with OpenSCAD and in the web playground.
// Use Help > Font List in desktop OpenSCAD to find other installed font names.
Font_Name = "Liberation Sans:style=Bold";

Front_Font_Size = 12;
Back_Font_Size = 12;

// Distance between vertically stacked character centres.
Front_Character_Spacing = 13.5;
Back_Character_Spacing = 13.5;
Front_Text_Center = 15.75;
Back_Text_Center = 15.75;
Front_Text_X = 0;
Back_Text_X = 0;

/* [Text relief] */
Front_Text_Style = "Recessed"; // [Recessed,Raised]
Back_Text_Style = "Recessed"; // [Recessed,Raised]
// Depth for Recessed, height for Raised; perpendicular mm before Model_Scale.
Front_Engraving_Depth = 0.8; // [0:0.05:5]
Back_Engraving_Depth = 0.8; // [0:0.05:5]

// 0 keeps sharp edges; positive mm rounds raised tops/recessed bottoms and outline corners.
// Small strokes narrower than twice the radius can disappear. Start at 0.05-0.10 mm.
Text_Edge_Radius = 0; // [0:0.01:0.5]
// Curve tessellation for glyph outlines; higher is smoother but slower.
Text_Curve_Resolution = 48; // [16:8:128]
// Number of thin layers approximating the rounded top/bottom; bounded for web renderers.
Text_Rounding_Steps = 6; // [2:1:12]

// Expands fine strokes without changing the selected font size.
Stroke_Expansion = 0.10;


/* [Dimensions] */
// Used only when Category is Custom. All dimensions precede Model_Scale.
Piece_Length = 31.5;
Base_Width = 28;
Rear_Thickness = 9.5;

/* [Bevel / bezel] */
// "Bezel width" is the in-plane distance from the outline to the flat face.
// "Bezel depth" is how far each outer rim is dropped from its inscription face.
// Set either value to zero for a square-edged piece.
Bezel_Width = 0.35; // [0:0.05:3]
Bezel_Depth = 0.18; // [0:0.02:2]

/* [Five reference angles] */
// Side view: rear edge to front inscription face (85 degrees in reference).
Front_Side_Base_Angle = 85;
// Side view: rear edge to back inscription face (81 degrees in reference).
Back_Side_Base_Angle = 81;
// Plan view: both bottom corners.
Face_Base_Angle = 81;
// Plan view: both shoulder corners.
Face_Shoulder_Angle = 117;
// Plan view: top point.
Face_Tip_Angle = 144;

// A symmetric pentagon requires 2*base + 2*shoulder + tip = 540 degrees.
Angle_Mode = "Check all three"; // [Check all three,Derive shoulder,Derive tip,Derive base]

/* [Output] */
// Inspection uses floating decals, NOT engraving. Never print inspection mode.
// Some viewers may show shading artifacts on planar faces; validate print geometry
// with the slicer layer/toolpath preview when a viewer disagrees.
Output_Mode = "Printable engraved"; // [Printable engraved,Printable blank,Clean inspection]

// Upright puts the broad rear edge on the build plate.
Print_Orientation = "Upright"; // [Upright,Design coordinates]
Curve_Resolution = 48; // [16:128]

/* [Inspection colours] */
Body_Colour = [0.78, 0.68, 0.22, 1];
Inscription_Colour = [0.12, 0.10, 0.06, 1];
Inspection_Decal_Height = 0.02;
Inspection_Decal_Gap = 0.01;

/* [Hidden] */

// [name, length, base width, rear thickness]; editable project defaults.
category_profiles = [["Shogi pawn", 26, 21, 8.5], ["Shogi lance", 27, 22, 8.6], ["Shogi knight", 28, 23, 8.7], ["Shogi silver", 29, 24, 9], ["Shogi gold", 29.5, 25, 9.2], ["Shogi bishop", 30, 26, 9.3], ["Shogi rook", 30.5, 27, 9.4], ["Shogi king", 31.5, 28, 9.5], ["Taikyoku small", 26, 21, 8.5], ["Taikyoku medium", 28, 24, 8.8], ["Taikyoku large", 30, 27, 9.3], ["Taikyoku royal", 31.5, 28, 9.5]];
category_matches = [for (profile=category_profiles) if (profile[0] == Category) profile];
assert(Category == "Custom" || len(category_matches) == 1, "Unknown Category.");
resolved_dimensions = Category == "Custom" ? [Piece_Length, Base_Width, Rear_Thickness]
: [category_matches[0][1], category_matches[0][2], category_matches[0][3]];
resolved_length = resolved_dimensions[0];
resolved_width = resolved_dimensions[1];
resolved_thickness = resolved_dimensions[2];
echo("Category:", Category);
echo("Automatic text layout:", Automatic_Text_Layout);
// Conservative starting layout; glyph proportions still depend on the installed font.
function layout_size(chars) = min(resolved_width*0.34, resolved_length*0.66/max(1,len(chars))*0.8);
resolved_front_font_size = Automatic_Text_Layout ? layout_size(Front_Characters) : Front_Font_Size;
resolved_front_character_spacing = Automatic_Text_Layout ? resolved_front_font_size*1.2 : Front_Character_Spacing;
resolved_front_text_center = Automatic_Text_Layout ? resolved_length*0.46 : Front_Text_Center;
resolved_front_text_x = Automatic_Text_Layout ? 0 : Front_Text_X;
resolved_back_font_size = Automatic_Text_Layout ? layout_size(Back_Characters) : Back_Font_Size;
resolved_back_character_spacing = Automatic_Text_Layout ? resolved_back_font_size*1.2 : Back_Character_Spacing;
resolved_back_text_center = Automatic_Text_Layout ? resolved_length*0.46 : Back_Text_Center;
resolved_back_text_x = Automatic_Text_Layout ? 0 : Back_Text_X;

$fn = Curve_Resolution;
epsilon = 0.03;

A = Angle_Mode == "Derive base"
? (540 - 2*Face_Shoulder_Angle - Face_Tip_Angle)/2
: Face_Base_Angle;
B = Angle_Mode == "Derive shoulder"
? (540 - 2*Face_Base_Angle - Face_Tip_Angle)/2
: Face_Shoulder_Angle;
C = Angle_Mode == "Derive tip"
? 540 - 2*Face_Base_Angle - 2*Face_Shoulder_Angle
: Face_Tip_Angle;

assert((Front_Text_Style == "Recessed" || Front_Text_Style == "Raised") &&
(Back_Text_Style == "Recessed" || Back_Text_Style == "Raised"), "Unknown text style.");
assert(Text_Edge_Radius >= 0 && Text_Curve_Resolution >= 16 && Text_Curve_Resolution <= 128,
       "Text radius must be nonnegative; curve resolution must be 16 to 128.");
assert(Text_Rounding_Steps >= 2 && Text_Rounding_Steps <= 12 && floor(Text_Rounding_Steps) == Text_Rounding_Steps,
       "Text_Rounding_Steps must be an integer from 2 to 12.");
assert(Model_Scale > 0, "Model_Scale must be greater than zero.");
assert(Output_Mode == "Clean inspection" || Output_Mode == "Printable engraved" || Output_Mode == "Printable blank",
       "Unknown Output_Mode.");
assert(abs(2*A + 2*B + C - 540) < 0.001,
       "Inconsistent face angles: 2*base + 2*shoulder + tip must equal 540. Change a second angle or choose a Derive mode.");
assert(A > 45 && A < 90 && B > 90 && B < 180 && C > 60 && C < 180,
       "Face angles are outside the supported convex shogi range.");
assert(Front_Side_Base_Angle > 60 && Front_Side_Base_Angle <= 90 &&
Back_Side_Base_Angle > 60 && Back_Side_Base_Angle <= 90,
"Side angles must be greater than 60 and at most 90 degrees.");
assert(resolved_length > 0 && resolved_width > 0 && resolved_thickness > 0,
       "Dimensions must be positive.");
assert(Front_Engraving_Depth >= 0 && Back_Engraving_Depth >= 0 && Stroke_Expansion >= 0,
       "Engraving depths and stroke expansion must be nonnegative.");
assert(resolved_front_font_size > 0 && resolved_back_font_size > 0 &&
resolved_front_character_spacing > 0 && resolved_back_character_spacing > 0,
"Font sizes and character spacing must be positive.");
assert(Bezel_Width >= 0 && Bezel_Depth >= 0,
       "Bezel dimensions must be nonnegative.");

front_slope = 1/tan(Front_Side_Base_Angle);
back_slope = 1/tan(Back_Side_Base_Angle);

shoulder_y =
(resolved_length - resolved_width/2*tan((180-C)/2)) /
(1 - tan(90-A)*tan((180-C)/2));
shoulder_x = resolved_width/2 - shoulder_y*tan(90-A);

tip_thickness = resolved_thickness - resolved_length*(front_slope + back_slope);

// A vertical cutter displacement corresponding to a perpendicular engraving depth.
front_cut_height = (Output_Mode == "Printable engraved" && Front_Text_Style == "Recessed" && len(Front_Characters) > 0 ? Front_Engraving_Depth : 0)*sqrt(1 + front_slope*front_slope);
back_cut_height = (Output_Mode == "Printable engraved" && Back_Text_Style == "Recessed" && len(Back_Characters) > 0 ? Back_Engraving_Depth : 0)*sqrt(1 + back_slope*back_slope);

assert(shoulder_x > 0 && shoulder_y > 0 && shoulder_y < resolved_length,
       "Length, width, and angles do not form a valid convex shogi outline.");
assert(tip_thickness > front_cut_height + back_cut_height + 0.1,
       "Piece is too thin for these engravings. Increase resolved_thickness or side angles, shorten the piece, or reduce engraving depth.");
assert(Bezel_Width < min(resolved_width/8, resolved_length/8),
       "Bezel_Width is too large for this outline.");
assert(2*Bezel_Depth < tip_thickness - 0.05,
       "Bezel_Depth removes too much thickness at the tip.");

echo("Resolved face angles (base, shoulder, tip):", A, B, C);
echo("Tip thickness before bevel, mm:", tip_thickness);
echo("Final overall dimensions, mm (width, length, rear thickness):",
     resolved_width*Model_Scale, resolved_length*Model_Scale, resolved_thickness*Model_Scale);

outline = [
    [-resolved_width/2, 0],
[ resolved_width/2, 0],
[ shoulder_x, shoulder_y],
[ 0, resolved_length],
[-shoulder_x, shoulder_y]
];

function unit(v) = v/norm(v);
function inward(v) = [-v[1], v[0]];

// Intersection of the two inward-offset lines adjacent to outline vertex i.
function inset_point(i, distance) =
let(
    p = outline[i],
    previous_normal = inward(unit(p - outline[(i+4)%5])),
    next_normal = inward(unit(outline[(i+1)%5] - p))
)
p + distance*(previous_normal + next_normal) /
(1 + previous_normal*next_normal);

inner_outline = [for (i=[0:4]) inset_point(i, Bezel_Width)];
has_bezel = Bezel_Width > 0 && Bezel_Depth > 0;


// Every point on a given inscription face is evaluated from one plane equation.
// This keeps all vertices exactly coplanar and avoids warped-face triangulation.
function back_face_z(p) = p[1]*back_slope;
function front_face_z(p) = resolved_thickness - p[1]*front_slope;

// Ring order when a bezel is present:
//   0: back central face, 1: back outer rim,
//   2: front outer rim, 3: front central face.
bezel_vertices = concat(
    [for (p=inner_outline) [p[0], p[1], back_face_z(p)]],
                        [for (p=outline) [p[0], p[1], back_face_z(p) + Bezel_Depth]],
                        [for (p=outline) [p[0], p[1], front_face_z(p) - Bezel_Depth]],
                        [for (p=inner_outline) [p[0], p[1], front_face_z(p)]]
);

bezel_faces = concat(
    [[4,3,2,1,0]],
    [for (ring=[0:2], i=[0:4])
    [5*ring+i, 5*ring+(i+1)%5,
                     5*(ring+1)+(i+1)%5, 5*(ring+1)+i]],
                     [[15,16,17,18,19]]
);

plain_vertices = concat(
    [for (p=outline) [p[0], p[1], back_face_z(p)]],
                        [for (p=outline) [p[0], p[1], front_face_z(p)]]
);

plain_faces = concat(
    [[4,3,2,1,0]],
    [for (i=[0:4]) [i, (i+1)%5, (i+1)%5+5, i+5]],
                     [[5,6,7,8,9]]
);

// Triangulating explicitly makes CGAL output deterministic and keeps the
// central inscription faces planar after boolean subtraction.
function triangulate(face) =
[for (k=[1:len(face)-2]) [face[0], face[k], face[k+1]]];

module blank() {
    if (has_bezel)
        polyhedron(
            points=bezel_vertices,
            faces=[for (face=bezel_faces, triangle=triangulate(face)) triangle],
                   convexity=10
        );
    else
        polyhedron(
            points=plain_vertices,
            faces=[for (face=plain_faces, triangle=triangulate(face)) triangle],
                   convexity=10
        );
}

module inscription(characters, size, spacing, center_y, x_shift) {
    $fn = Text_Curve_Resolution;
    if (len(characters) > 0)
        for (i=[0:len(characters)-1])
            translate([
                x_shift,
                center_y + ((len(characters)-1)/2-i)*spacing
            ])
            offset(delta=Stroke_Expansion)
            text(
                characters[i],
                 size=size,
                 font=Font_Name,
                 halign="center",
                 valign="center",
                 spacing=1
            );
}

// All rounding is 2D offset + bounded thin extrusions: no 3D Minkowski sum.
// A quarter-circle profile is sampled in overlapping layers. This approximates
// a fillet without the large 3D convolution used in the previous implementation.
module rounded_text_outline(characters, size, spacing, center_y, x_shift, r, expansion) {
    $fn = Text_Curve_Resolution;
    if (expansion > 0)
        offset(r=expansion)
        offset(delta=-r)
        inscription(characters, size, spacing, center_y, x_shift);
    else
        offset(delta=-r)
        inscription(characters, size, spacing, center_y, x_shift);
}

// Local Z points outward. The visible extent remains exactly depth/height.
module text_relief(characters, size, spacing, center_y, x_shift, depth, style) {
    r = min(Text_Edge_Radius, depth/2);
    raised = style == "Raised";
    z_min = raised ? -epsilon : -depth;
    z_max = raised ? depth : epsilon;
    if (r == 0)
        translate([0, 0, z_min])
        linear_extrude(height=z_max-z_min, convexity=20)
        inscription(characters, size, spacing, center_y, x_shift);
    else {
        // Straight walls occupy the non-rounded portion.
        translate([0, 0, raised ? z_min : z_min+r])
        linear_extrude(height=z_max-z_min-r, convexity=20)
        rounded_text_outline(characters, size, spacing, center_y, x_shift, r, r);
        // Midpoint samples of a circular arc. Tiny inward overlaps avoid seams;
        // overlaps never extend the visible height or deepest engraved point.
        step_height = r/Text_Rounding_Steps;
        overlap = min(epsilon, step_height/10);
        for (i=[0:Text_Rounding_Steps-1]) {
            t = (i+0.5)/Text_Rounding_Steps;
            expansion = r*sqrt(1-t*t);
            z = raised ? z_max-r+i*step_height : z_min+r-(i+1)*step_height;
            translate([0, 0, raised ? z-overlap : z])
            linear_extrude(height=step_height+overlap, convexity=20)
            rounded_text_outline(characters, size, spacing, center_y, x_shift, r, expansion);
        }
    }
}

module inscription_decal(characters, size, spacing, center_y, x_shift) {
    translate([0, 0, Inspection_Decal_Gap])
    linear_extrude(height=Inspection_Decal_Height, convexity=20)
    inscription(characters, size, spacing, center_y, x_shift);
}

module face_relief(front) {
    chars = front ? Front_Characters : Back_Characters;
    depth = front ? Front_Engraving_Depth : Back_Engraving_Depth;
    style = front ? Front_Text_Style : Back_Text_Style;
    slope = front ? front_slope : back_slope;
    sign = front ? 1 : -1;
    if (depth > 0 && len(chars) > 0)
        multmatrix([
            [sign, 0, 0, 0],
            [0, 1, slope/sqrt(1+slope*slope), 0],
                   [0, -sign*slope, sign/sqrt(1+slope*slope), front ? resolved_thickness : 0],
                   [0, 0, 0, 1]
        ])
        text_relief(chars,
                    front ? resolved_front_font_size : resolved_back_font_size,
                    front ? resolved_front_character_spacing : resolved_back_character_spacing,
                    front ? resolved_front_text_center : resolved_back_text_center,
                    front ? resolved_front_text_x : resolved_back_text_x,
                    depth, style);
}

module unscaled_piece() {
    union() {
        difference() {
            blank();
            if (Front_Text_Style == "Recessed") face_relief(true);
            if (Back_Text_Style == "Recessed") face_relief(false);
        }
        if (Front_Text_Style == "Raised") face_relief(true);
        if (Back_Text_Style == "Raised") face_relief(false);
    }
}

module clean_inspection_model() {
    color(Body_Colour)
    blank();

    if (len(Front_Characters) > 0)
        color(Inscription_Colour)
        multmatrix([
            [1, 0, 0, 0],
            [0, 1, front_slope/sqrt(1+front_slope*front_slope), 0],
                   [0, -front_slope, 1/sqrt(1+front_slope*front_slope),
                   resolved_thickness],
                   [0, 0, 0, 1]
        ])
        inscription_decal(
            Front_Characters,
            resolved_front_font_size,
            resolved_front_character_spacing,
            resolved_front_text_center,
            resolved_front_text_x
        );

        if (len(Back_Characters) > 0)
            color(Inscription_Colour)
            multmatrix([
                [-1, 0, 0, 0],
                [0, 1, back_slope/sqrt(1+back_slope*back_slope), 0],
                       [0, back_slope, -1/sqrt(1+back_slope*back_slope), 0],
                       [0, 0, 0, 1]
            ])
            inscription_decal(
                Back_Characters,
                resolved_back_font_size,
                resolved_back_character_spacing,
                resolved_back_text_center,
                resolved_back_text_x
            );
}

module shogi_piece() {
    scale([Model_Scale, Model_Scale, Model_Scale])
    if (Output_Mode == "Printable engraved") {
        echo("EXPORT MODE: printable text relief enabled.");
        // Applying one opaque colour after the boolean also avoids colour
        // inheritance defects in Manifold-based renderers.
        color(Body_Colour)
        render(convexity=30)
        unscaled_piece();
    } else if (Output_Mode == "Printable blank") {
        color(Body_Colour) blank();
    } else {
        echo("INSPECTION MODE ONLY: switch Output_Mode to Printable engraved before exporting.");
        clean_inspection_model();
    }
}

if (Print_Orientation == "Upright")
    // After the rotation, the broad rear edge lies on Z=0.
    translate([0, resolved_thickness*Model_Scale, 0])
    rotate([90, 0, 0])
    shogi_piece();
else
    shogi_piece();

// KomaSCAD — parametric shogi piece generator
// Units: millimetres and degrees. OpenSCAD 2021.01+
//
// Scaling examples:
//   model_scale = 1;    // normal 31.5 mm king
//   model_scale = 5;    // 157.5 mm display piece
//   model_scale = 10;   // 315 mm display piece

/* [Piece category] */
// Project size profiles, not historical measurements. Custom uses Dimensions below.
category = "Custom"; // [Custom,Shogi pawn,Shogi lance,Shogi knight,Shogi silver,Shogi gold,Shogi bishop,Shogi rook,Shogi king,Taikyoku small,Taikyoku medium,Taikyoku large,Taikyoku royal]
// Automatically place 1-3 characters per face; disable for manual typography.
auto_text_layout = false;

/* [Scale] */
// Uniformly scales the completed piece, including text and engraving depth.
model_scale = 1; // [0.25:0.25:20]

/* [Inscriptions] */
front_characters = "A";
back_characters = "B";

// Liberation Sans is normally available with OpenSCAD and in the web playground.
// Use Help > Font List in desktop OpenSCAD to find other installed font names.
font_name = "Liberation Sans:style=Bold";

front_font_size = 12;
back_font_size = 12;

// Distance between vertically stacked character centres.
front_character_spacing = 13.5;
back_character_spacing = 13.5;
front_text_center = 15.75;
back_text_center = 15.75;
front_text_x = 0;
back_text_x = 0;

/* [Text relief] */
front_text_style = "Recessed"; // [Recessed,Raised]
back_text_style = "Recessed"; // [Recessed,Raised]
// Depth for Recessed, height for Raised; perpendicular mm before model_scale.
// Existing parameter names retained for compatibility with preset files.
front_engraving_depth = 0.8; // [0:0.05:5]
back_engraving_depth = 0.8; // [0:0.05:5]

// 0 keeps sharp edges; positive mm rounds raised tops/recessed bottoms and outline corners.
// Small strokes narrower than twice the radius can disappear. Start at 0.05-0.10 mm.
text_edge_radius = 0; // [0:0.01:0.5]
// Curve tessellation for glyph outlines; higher is smoother but slower.
text_curve_resolution = 48; // [16:8:128]
// Number of thin layers approximating the rounded top/bottom; bounded for web renderers.
text_rounding_steps = 6; // [2:1:12]

// Expands fine strokes without changing the selected font size.
stroke_expansion = 0.10;


/* [Dimensions] */
// Used only when category is Custom. All dimensions precede model_scale.
piece_length = 31.5;
base_width = 28;
rear_thickness = 9.5;

/* [Bevel / bezel] */
// "Bezel width" is the in-plane distance from the outline to the flat face.
// "Bezel depth" is how far each outer rim is dropped from its inscription face.
// Set either value to zero for a square-edged piece.
bezel_width = 0.35; // [0:0.05:3]
bezel_depth = 0.18; // [0:0.02:2]

/* [Five reference angles] */
// Side view: rear edge to front inscription face (85 degrees in reference).
front_side_base_angle = 85;
// Side view: rear edge to back inscription face (81 degrees in reference).
back_side_base_angle = 81;
// Plan view: both bottom corners.
face_base_angle = 81;
// Plan view: both shoulder corners.
face_shoulder_angle = 117;
// Plan view: top point.
face_tip_angle = 144;

// A symmetric pentagon requires 2*base + 2*shoulder + tip = 540 degrees.
angle_mode = "Check all three"; // [Check all three,Derive shoulder,Derive tip,Derive base]

/* [Output] */
// Inspection uses floating decals, NOT engraving. Never print inspection mode.
// Some viewers may show shading artifacts on planar faces; validate print geometry
// with the slicer layer/toolpath preview when a viewer disagrees.
output_mode = "Printable engraved"; // [Printable engraved,Printable blank,Clean inspection]

// Upright puts the broad rear edge on the build plate.
print_orientation = "Upright"; // [Upright,Design coordinates]
curve_resolution = 48; // [16:128]

/* [Inspection colours] */
body_colour = [0.78, 0.68, 0.22, 1];
inscription_colour = [0.12, 0.10, 0.06, 1];
inspection_decal_height = 0.02;
inspection_decal_gap = 0.01;

/* [Hidden] */

// [name, length, base width, rear thickness]; editable project defaults.
category_profiles = [["Shogi pawn", 26, 21, 8.5], ["Shogi lance", 27, 22, 8.6], ["Shogi knight", 28, 23, 8.7], ["Shogi silver", 29, 24, 9], ["Shogi gold", 29.5, 25, 9.2], ["Shogi bishop", 30, 26, 9.3], ["Shogi rook", 30.5, 27, 9.4], ["Shogi king", 31.5, 28, 9.5], ["Taikyoku small", 26, 21, 8.5], ["Taikyoku medium", 28, 24, 8.8], ["Taikyoku large", 30, 27, 9.3], ["Taikyoku royal", 31.5, 28, 9.5]];
category_matches = [for (profile=category_profiles) if (profile[0] == category) profile];
assert(category == "Custom" || len(category_matches) == 1, "Unknown category.");
resolved_dimensions = category == "Custom" ? [piece_length, base_width, rear_thickness]
    : [category_matches[0][1], category_matches[0][2], category_matches[0][3]];
resolved_length = resolved_dimensions[0];
resolved_width = resolved_dimensions[1];
resolved_thickness = resolved_dimensions[2];
echo("Category:", category);
// Conservative starting layout; glyph proportions still depend on the installed font.
function layout_size(chars) = min(resolved_width*0.34, resolved_length*0.66/max(1,len(chars))*0.8);
resolved_front_font_size = auto_text_layout ? layout_size(front_characters) : front_font_size;
resolved_front_character_spacing = auto_text_layout ? resolved_front_font_size*1.2 : front_character_spacing;
resolved_front_text_center = auto_text_layout ? resolved_length*0.46 : front_text_center;
resolved_front_text_x = auto_text_layout ? 0 : front_text_x;
resolved_back_font_size = auto_text_layout ? layout_size(back_characters) : back_font_size;
resolved_back_character_spacing = auto_text_layout ? resolved_back_font_size*1.2 : back_character_spacing;
resolved_back_text_center = auto_text_layout ? resolved_length*0.46 : back_text_center;
resolved_back_text_x = auto_text_layout ? 0 : back_text_x;

$fn = curve_resolution;
epsilon = 0.03;

A = angle_mode == "Derive base"
    ? (540 - 2*face_shoulder_angle - face_tip_angle)/2
    : face_base_angle;
B = angle_mode == "Derive shoulder"
    ? (540 - 2*face_base_angle - face_tip_angle)/2
    : face_shoulder_angle;
C = angle_mode == "Derive tip"
    ? 540 - 2*face_base_angle - 2*face_shoulder_angle
    : face_tip_angle;

assert((front_text_style == "Recessed" || front_text_style == "Raised") &&
       (back_text_style == "Recessed" || back_text_style == "Raised"), "Unknown text style.");
assert(text_edge_radius >= 0 && text_curve_resolution >= 16 && text_curve_resolution <= 128,
    "Text radius must be nonnegative; curve resolution must be 16 to 128.");
assert(text_rounding_steps >= 2 && text_rounding_steps <= 12 && floor(text_rounding_steps) == text_rounding_steps,
    "text_rounding_steps must be an integer from 2 to 12.");
assert(model_scale > 0, "model_scale must be greater than zero.");
assert(output_mode == "Clean inspection" || output_mode == "Printable engraved" || output_mode == "Printable blank",
    "Unknown output_mode.");
assert(abs(2*A + 2*B + C - 540) < 0.001,
    "Inconsistent face angles: 2*base + 2*shoulder + tip must equal 540. Change a second angle or choose a Derive mode.");
assert(A > 45 && A < 90 && B > 90 && B < 180 && C > 60 && C < 180,
    "Face angles are outside the supported convex shogi range.");
assert(front_side_base_angle > 60 && front_side_base_angle <= 90 &&
       back_side_base_angle > 60 && back_side_base_angle <= 90,
    "Side angles must be greater than 60 and at most 90 degrees.");
assert(resolved_length > 0 && resolved_width > 0 && resolved_thickness > 0,
    "Dimensions must be positive.");
assert(front_engraving_depth >= 0 && back_engraving_depth >= 0 && stroke_expansion >= 0,
    "Engraving depths and stroke expansion must be nonnegative.");
assert(resolved_front_font_size > 0 && resolved_back_font_size > 0 &&
       resolved_front_character_spacing > 0 && resolved_back_character_spacing > 0,
    "Font sizes and character spacing must be positive.");
assert(bezel_width >= 0 && bezel_depth >= 0,
    "Bezel dimensions must be nonnegative.");

front_slope = 1/tan(front_side_base_angle);
back_slope = 1/tan(back_side_base_angle);

shoulder_y =
    (resolved_length - resolved_width/2*tan((180-C)/2)) /
    (1 - tan(90-A)*tan((180-C)/2));
shoulder_x = resolved_width/2 - shoulder_y*tan(90-A);

tip_thickness = resolved_thickness - resolved_length*(front_slope + back_slope);

// A vertical cutter displacement corresponding to a perpendicular engraving depth.
front_cut_height = (output_mode == "Printable engraved" && front_text_style == "Recessed" && len(front_characters) > 0 ? front_engraving_depth : 0)*sqrt(1 + front_slope*front_slope);
back_cut_height = (output_mode == "Printable engraved" && back_text_style == "Recessed" && len(back_characters) > 0 ? back_engraving_depth : 0)*sqrt(1 + back_slope*back_slope);

assert(shoulder_x > 0 && shoulder_y > 0 && shoulder_y < resolved_length,
    "Length, width, and angles do not form a valid convex shogi outline.");
assert(tip_thickness > front_cut_height + back_cut_height + 0.1,
    "Piece is too thin for these engravings. Increase resolved_thickness or side angles, shorten the piece, or reduce engraving depth.");
assert(bezel_width < min(resolved_width/8, resolved_length/8),
    "bezel_width is too large for this outline.");
assert(2*bezel_depth < tip_thickness - 0.05,
    "bezel_depth removes too much thickness at the tip.");

echo("Resolved face angles (base, shoulder, tip):", A, B, C);
echo("Tip thickness before bevel, mm:", tip_thickness);
echo("Final overall dimensions, mm (width, length, rear thickness):",
     resolved_width*model_scale, resolved_length*model_scale, resolved_thickness*model_scale);

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

inner_outline = [for (i=[0:4]) inset_point(i, bezel_width)];
has_bezel = bezel_width > 0 && bezel_depth > 0;


// Every point on a given inscription face is evaluated from one plane equation.
// This keeps all vertices exactly coplanar and avoids warped-face triangulation.
function back_face_z(p) = p[1]*back_slope;
function front_face_z(p) = resolved_thickness - p[1]*front_slope;

// Ring order when a bezel is present:
//   0: back central face, 1: back outer rim,
//   2: front outer rim, 3: front central face.
bezel_vertices = concat(
    [for (p=inner_outline) [p[0], p[1], back_face_z(p)]],
    [for (p=outline) [p[0], p[1], back_face_z(p) + bezel_depth]],
    [for (p=outline) [p[0], p[1], front_face_z(p) - bezel_depth]],
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
    $fn = text_curve_resolution;
    if (len(characters) > 0)
        for (i=[0:len(characters)-1])
            translate([
                x_shift,
                center_y + ((len(characters)-1)/2-i)*spacing
            ])
                offset(delta=stroke_expansion)
                    text(
                        characters[i],
                        size=size,
                        font=font_name,
                        halign="center",
                        valign="center",
                        spacing=1
                    );
}

// All rounding is 2D offset + bounded thin extrusions: no 3D Minkowski sum.
// A quarter-circle profile is sampled in overlapping layers. This approximates
// a fillet without the large 3D convolution used in the previous implementation.
module rounded_text_outline(characters, size, spacing, center_y, x_shift, r, expansion) {
    $fn = text_curve_resolution;
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
    r = min(text_edge_radius, depth/2);
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
        step_height = r/text_rounding_steps;
        overlap = min(epsilon, step_height/10);
        for (i=[0:text_rounding_steps-1]) {
            t = (i+0.5)/text_rounding_steps;
            expansion = r*sqrt(1-t*t);
            z = raised ? z_max-r+i*step_height : z_min+r-(i+1)*step_height;
            translate([0, 0, raised ? z-overlap : z])
                linear_extrude(height=step_height+overlap, convexity=20)
                    rounded_text_outline(characters, size, spacing, center_y, x_shift, r, expansion);
        }
    }
}

module inscription_decal(characters, size, spacing, center_y, x_shift) {
    translate([0, 0, inspection_decal_gap])
        linear_extrude(height=inspection_decal_height, convexity=20)
            inscription(characters, size, spacing, center_y, x_shift);
}

module face_relief(front) {
    chars = front ? front_characters : back_characters;
    depth = front ? front_engraving_depth : back_engraving_depth;
    style = front ? front_text_style : back_text_style;
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
            if (front_text_style == "Recessed") face_relief(true);
            if (back_text_style == "Recessed") face_relief(false);
        }
        if (front_text_style == "Raised") face_relief(true);
        if (back_text_style == "Raised") face_relief(false);
    }
}

module clean_inspection_model() {
    color(body_colour)
        blank();

    if (len(front_characters) > 0)
        color(inscription_colour)
            multmatrix([
                [1, 0, 0, 0],
                [0, 1, front_slope/sqrt(1+front_slope*front_slope), 0],
                [0, -front_slope, 1/sqrt(1+front_slope*front_slope),
                    resolved_thickness],
                [0, 0, 0, 1]
            ])
                inscription_decal(
                    front_characters,
                    resolved_front_font_size,
                    resolved_front_character_spacing,
                    resolved_front_text_center,
                    resolved_front_text_x
                );

    if (len(back_characters) > 0)
        color(inscription_colour)
            multmatrix([
                [-1, 0, 0, 0],
                [0, 1, back_slope/sqrt(1+back_slope*back_slope), 0],
                [0, back_slope, -1/sqrt(1+back_slope*back_slope), 0],
                [0, 0, 0, 1]
            ])
                inscription_decal(
                    back_characters,
                    resolved_back_font_size,
                    resolved_back_character_spacing,
                    resolved_back_text_center,
                    resolved_back_text_x
                );
}

module shogi_piece() {
    scale([model_scale, model_scale, model_scale])
        if (output_mode == "Printable engraved") {
            echo("EXPORT MODE: printable text relief enabled.");
            // Applying one opaque colour after the boolean also avoids colour
            // inheritance defects in Manifold-based renderers.
            color(body_colour)
                render(convexity=30)
                    unscaled_piece();
        } else if (output_mode == "Printable blank") {
            color(body_colour) blank();
        } else {
            echo("INSPECTION MODE ONLY: switch output_mode to Printable engraved before exporting.");
            clean_inspection_model();
        }
}

if (print_orientation == "Upright")
    // After the rotation, the broad rear edge lies on Z=0.
    translate([0, resolved_thickness*model_scale, 0])
        rotate([90, 0, 0])
            shogi_piece();
else
    shogi_piece();

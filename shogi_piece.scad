// KomaSCAD — community base, revision 2.2
// OpenSCAD 2021.01. Units: mm / degrees, BEFORE Model_Scale.
// Start: choose inscriptions, dimensions, font; inspect both faces; F6; export STL.
// Keep shogi_piece.json beside this file. Select 00 Base - King in Customizer.
// Font sizes are OpenSCAD typographic sizes, NOT measured glyph heights.
// No proprietary printer, multi-material hardware, or development build required.

/* [01 - Start here] */
// Informational label ONLY. Dimensions below are always authoritative.
Category = "Base / King";
Front_Characters = "王将";
// Empty string makes a blank reverse. Characters are stacked from tip to heel.
Back_Characters = "";
// Install this font or select an installed Japanese font via Help > Font List.
Font_Name = "Noto Serif CJK JP:style=SemiBold";
// Print produces actual recesses/relief. Inspect views show ink and red overflow.
Output_Mode = "Print"; // [Print,Blank,Inspect front,Inspect back]
// Upright: broad heel on bed. Back face down: usually unsuitable for an engraved reverse.
Print_Orientation = "Upright"; // [Upright,Back face down,Design coordinates]
Model_Scale = 1; // [0.25:0.05:20]

/* [02 - Piece dimensions] */
Piece_Length = 31.5; // [15:0.1:100]
Base_Width = 28; // [10:0.1:100]
// Thickness at the broad heel; not the thickness near the point.
Rear_Thickness = 9.5; // [3:0.1:30]
// Simple taper controls the actual thickness at the point; faces taper equally.
Taper_Mode = "Tip thickness"; // [Tip thickness,Reference side angles]
Tip_Thickness = 3; // [1:0.1:20]

/* [03 - Front layout] */
// 0 selects a size based on piece dimensions and character count; positive mm overrides it.
Front_Font_Size = 0; // [0:0.1:40]
// Multiplies automatic OR explicit font size. All adjustments remain active.
Front_Text_Scale = 1; // [0.25:0.01:2]
// 0 selects centre-to-centre spacing automatically; positive mm overrides it.
Front_Character_Spacing = 0; // [0:0.1:40]
// In auto spacing, multiply the nominal spacing; does not resize characters.
Front_Spacing_Scale = 1; // [0.5:0.01:2]
// Fraction of face length from broad heel to point. 0.46 is slightly below centre.
Front_Center_Fraction = 0.46; // [0:0.01:1]
// Positive X = viewer's right; positive Y = toward the point, measured along the face.
Front_Text_X = 0; // [-20:0.1:20]
Front_Text_Y = 0; // [-20:0.1:20]
// Width changes glyph width only; it never changes font size or spacing.
Front_Width_Scale = 1; // [0.25:0.01:2]
Front_Height_Scale = 1; // [0.25:0.01:2]
// Rotation in degrees about the inscription centre, counterclockwise as viewed.
Front_Text_Rotation = 0; // [-180:1:180]

/* [04 - Back layout] */
Back_Font_Size = 0; // [0:0.1:40]
Back_Text_Scale = 1; // [0.25:0.01:2]
Back_Character_Spacing = 0; // [0:0.1:40]
Back_Spacing_Scale = 1; // [0.5:0.01:2]
Back_Center_Fraction = 0.46; // [0:0.01:1]
// Coordinates are seen from the reverse. Do not mirror the characters manually.
Back_Text_X = 0; // [-20:0.1:20]
Back_Text_Y = 0; // [-20:0.1:20]
Back_Width_Scale = 1; // [0.25:0.01:2]
Back_Height_Scale = 1; // [0.25:0.01:2]
Back_Text_Rotation = 0; // [-180:1:180]

/* [05 - Front character adjustments] */
// Each pair is [first / upper, second / lower]. Single-character text uses the FIRST entry.
// Additional characters use neutral values. Extend these lists in source for larger variants.
Front_Glyph_Size = [1, 1]; // [0.25:0.01:2]
Front_Glyph_Width = [1, 1]; // [0.25:0.01:2]
Front_Glyph_Height = [1, 1]; // [0.25:0.01:2]
// Independent offsets in face mm; positive Y moves toward the point.
Front_Glyph_X = [0, 0]; // [-10:0.1:10]
Front_Glyph_Y = [0, 0]; // [-10:0.1:10]
Front_Glyph_Rotation = [0, 0]; // [-180:1:180]

/* [06 - Back character adjustments] */
Back_Glyph_Size = [1, 1]; // [0.25:0.01:2]
Back_Glyph_Width = [1, 1]; // [0.25:0.01:2]
Back_Glyph_Height = [1, 1]; // [0.25:0.01:2]
Back_Glyph_X = [0, 0]; // [-10:0.1:10]
Back_Glyph_Y = [0, 0]; // [-10:0.1:10]
Back_Glyph_Rotation = [0, 0]; // [-180:1:180]

/* [07 - Engraving and stroke weight] */
Front_Text_Style = "Recessed"; // [Recessed,Raised,None]
Back_Text_Style = "Recessed"; // [Recessed,Raised,None]
// Recess depth OR raised height, perpendicular to face; independent of print orientation.
Front_Relief_Depth = 0.8; // [0:0.05:3]
Back_Relief_Depth = 0.8; // [0:0.05:3]
// Positive values thicken every outline. They also close small counters: inspect before printing.
Front_Stroke_Expansion = 0.12; // [-0.2:0.01:0.5]
Back_Stroke_Expansion = 0.12; // [-0.2:0.01:0.5]
// Blank uses Font_Name. Override only when the reverse needs another typeface.
Front_Font_Override = "";
Back_Font_Override = "";
// 0 keeps details sharp; rounding can remove narrow strokes. Radius is capped at half relief depth.
Text_Edge_Radius = 0; // [0:0.01:0.5]
Text_Rounding_Steps = 6; // [2:1:12]

/* [08 - Edges and face margin] */
// Chamfer width measured in plan view; depth measured in model Z. Either zero disables it.
Bevel_Width = 0.35; // [0:0.05:3]
Bevel_Depth = 0.18; // [0:0.02:2]
// Additional plan-view inset beyond the flat face edge. Applies to both faces.
Text_Margin = 0.8; // [0:0.1:4]
// Protect trims lettering at the safe boundary. Inspect red overflow and correct it before export.
Protect_Face_Edges = true;
// Conservative minimum solid web, measured in model Z, AFTER scaling.
Minimum_Web = 1; // [0.2:0.1:5]

/* [09 - Advanced shape angles] */
// Pentagon closure: 2*base + 2*shoulder + tip = 540 degrees.
// In a derive mode the named angle below is ignored; the Console reports resolved angles.
Angle_Mode = "Derive shoulder"; // [Derive shoulder,Derive tip,Derive base,Check all three]
Face_Base_Angle = 81;
Face_Shoulder_Angle = 117;
Face_Tip_Angle = 144;
// Used ONLY in Reference side angles mode. Tip_Thickness is then ignored.
Front_Side_Base_Angle = 85;
Back_Side_Base_Angle = 81;

/* [10 - Inspection and quality] */
// These colours never create a second material or survive ordinary STL export.
Body_Colour = [0.76, 0.58, 0.34, 1];
Front_Inscription_Colour = [0.08, 0.06, 0.04, 1];
Back_Inscription_Colour = [0.65, 0.05, 0.04, 1];
Show_Layout_Guides = true;
// Effective toolpath line width, for reference guides ONLY. Does not guarantee printability.
Reference_Line_Width = 0.6; // [0.2:0.05:1.2]
Text_Curve_Resolution = 48; // [16:8:128]

/* [Hidden] */

$fn = Text_Curve_Resolution;
epsilon = 0.02;
resolved_length = Piece_Length;
resolved_width = Base_Width;
resolved_thickness = Rear_Thickness;
Bezel_Width = Bevel_Width;
Bezel_Depth = Bevel_Depth;

function valid_choice(x, choices) = len([for(c=choices) if(x==c) 1])==1;
function all_positive(a) = is_list(a) && len(a)>0 && min(a)>0;
function entry(a,i,fallback) = i<len(a) ? a[i] : fallback;
function chars(f) = f ? Front_Characters : Back_Characters;
function style(f) = f ? Front_Text_Style : Back_Text_Style;
function depth(f) = f ? Front_Relief_Depth : Back_Relief_Depth;
function active(f) = len(chars(f))>0 && style(f)!="None" && depth(f)>0;

assert(valid_choice(Output_Mode,["Print","Blank","Inspect front","Inspect back"]),"Unknown Output_Mode.");
assert(valid_choice(Print_Orientation,["Upright","Back face down","Design coordinates"]),"Unknown Print_Orientation.");
assert(valid_choice(Taper_Mode,["Tip thickness","Reference side angles"]),"Unknown Taper_Mode.");
assert(valid_choice(Angle_Mode,["Derive shoulder","Derive tip","Derive base","Check all three"]),"Unknown Angle_Mode.");
assert(Model_Scale>0 && Piece_Length>0 && Base_Width>0 && Rear_Thickness>0,"Scale and dimensions must be positive.");
assert(Bevel_Width>=0 && Bevel_Depth>=0 && Text_Margin>=0 && Minimum_Web>0,"Bevel / margin must be nonnegative; web must be positive.");
assert(Text_Curve_Resolution>=16 && Text_Curve_Resolution<=128 && floor(Text_Curve_Resolution)==Text_Curve_Resolution,"Text resolution must be an integer 16..128.");
assert(Text_Edge_Radius>=0 && Text_Rounding_Steps>=2 && Text_Rounding_Steps<=12 && floor(Text_Rounding_Steps)==Text_Rounding_Steps,"Invalid text rounding settings.");
assert(Reference_Line_Width>0,"Reference_Line_Width must be positive.");
assert(!(Output_Mode=="Print" && Print_Orientation=="Back face down" && active(false) && style(false)=="Raised"),
       "Raised reverse extends below the bed. Use Upright for this piece.");
for (f=[true,false]) {
    assert(valid_choice(style(f),["Recessed","Raised","None"]),"Unknown text style.");
    assert(depth(f)>=0,"Relief depth must be nonnegative.");
    assert((f?Front_Font_Size:Back_Font_Size)>=0 && (f?Front_Character_Spacing:Back_Character_Spacing)>=0,"Font size and spacing must be >=0; 0 means automatic.");
    assert(min(f?[Front_Text_Scale,Front_Spacing_Scale,Front_Width_Scale,Front_Height_Scale]:[Back_Text_Scale,Back_Spacing_Scale,Back_Width_Scale,Back_Height_Scale])>0,"Text scales must be positive.");
    assert((f?Front_Center_Fraction:Back_Center_Fraction)>=0 && (f?Front_Center_Fraction:Back_Center_Fraction)<=1,"Center fraction must be 0..1; use Y offset for additional movement.");
    for (a=f?[Front_Glyph_Size,Front_Glyph_Width,Front_Glyph_Height]:[Back_Glyph_Size,Back_Glyph_Width,Back_Glyph_Height])
        assert(all_positive(a),"Glyph size/width/height lists must contain positive numbers.");
    for (a=f?[Front_Glyph_X,Front_Glyph_Y,Front_Glyph_Rotation]:[Back_Glyph_X,Back_Glyph_Y,Back_Glyph_Rotation])
        assert(is_list(a),"Glyph offset/rotation settings must be lists.");
}

A = Angle_Mode=="Derive base" ? (540-2*Face_Shoulder_Angle-Face_Tip_Angle)/2 : Face_Base_Angle;
B = Angle_Mode=="Derive shoulder" ? (540-2*Face_Base_Angle-Face_Tip_Angle)/2 : Face_Shoulder_Angle;
C = Angle_Mode=="Derive tip" ? 540-2*Face_Base_Angle-2*Face_Shoulder_Angle : Face_Tip_Angle;
assert(abs(2*A+2*B+C-540)<0.001,"Face angles do not close. Choose a Derive mode or correct the angles.");
assert(A>45 && A<90 && B>90 && B<180 && C>60 && C<180,"Face angles outside supported convex range.");
if(Taper_Mode=="Tip thickness")
    assert(Tip_Thickness>0 && Tip_Thickness<=Rear_Thickness,"Tip must be positive and no thicker than the heel.");
else
    assert(Front_Side_Base_Angle>60 && Front_Side_Base_Angle<=90 && Back_Side_Base_Angle>60 && Back_Side_Base_Angle<=90,"Side angles must be >60 and <=90.");
front_slope = Taper_Mode=="Tip thickness" ? (Rear_Thickness-Tip_Thickness)/(2*Piece_Length) : 1/tan(Front_Side_Base_Angle);
back_slope = Taper_Mode=="Tip thickness" ? front_slope : 1/tan(Back_Side_Base_Angle);
shoulder_y = (Piece_Length-Base_Width/2*tan((180-C)/2))/(1-tan(90-A)*tan((180-C)/2));
shoulder_x = Base_Width/2-shoulder_y*tan(90-A);
tip_thickness = Rear_Thickness-Piece_Length*(front_slope+back_slope);
assert(shoulder_x>0 && shoulder_y>0 && shoulder_y<Piece_Length,"Dimensions and angles do not form a convex koma.");
assert(tip_thickness>0,"Taper makes the point vanish. Increase thickness or reduce taper.");
assert(Bevel_Width<min(Base_Width/8,Piece_Length/8),"Bevel width too large.");
// Conservative whole-face web bound, including both bevels and both recesses.
function cut_z(f) = active(f) && style(f)=="Recessed" && Output_Mode!="Blank" ? depth(f)*sqrt(1+pow(f?front_slope:back_slope,2)) : 0;
bevel_loss = Bevel_Width>0 && Bevel_Depth>0 ? 2*Bevel_Depth : 0;
assert((tip_thickness-bevel_loss-cut_z(true)-cut_z(false))*Model_Scale>=Minimum_Web,
       "Insufficient solid web at point. Increase tip thickness, reduce recesses/bevel, or revise Minimum_Web.");
echo("KomaSCAD v2 / category (label only):",Category);
echo("Body width, length, heel thickness after scaling:",Base_Width*Model_Scale,Piece_Length*Model_Scale,Rear_Thickness*Model_Scale);
echo("Resolved angles base / shoulder / point:",A,B,C);
echo("Tip thickness before bevel:",tip_thickness*Model_Scale);
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
            faces=[for (face=bezel_faces, triangle=triangulate(face)) [triangle[2],triangle[1],triangle[0]]],
                   convexity=10
        );
    else
        polyhedron(
            points=plain_vertices,
            faces=[for (face=plain_faces, triangle=triangulate(face)) [triangle[2],triangle[1],triangle[0]]],
                   convexity=10
        );
}


// Safe polygon must survive inset without collapsing or crossing any original edge.
safe_inset = (has_bezel ? Bevel_Width : 0)+Text_Margin;
safe_outline = [for(i=[0:4]) inset_point(i,safe_inset)];
for(p=safe_outline, i=[0:4])
    assert((p-outline[i])*inward(unit(outline[(i+1)%5]-outline[i])) >= safe_inset-0.0001,
           "Text margin collapses safe face. Reduce margin/bevel or enlarge piece.");
    assert(safe_outline[1][0]>safe_outline[0][0] && safe_outline[3][1]>safe_outline[2][1],"Safe face has collapsed.");

function slope(f) = f ? front_slope : back_slope;
function cosine(f) = 1/sqrt(1+slope(f)*slope(f));
function face_length(f) = Piece_Length/cosine(f);
function font_size(f) = let(n=max(1,len(chars(f))), override=f?Front_Font_Size:Back_Font_Size)
(override>0 ? override : min(Base_Width*0.43,face_length(f)*0.72/(1.35*n))) * (f?Front_Text_Scale:Back_Text_Scale);
function char_spacing(f) = let(override=f?Front_Character_Spacing:Back_Character_Spacing)
override>0 ? override : font_size(f)*1.42*(f?Front_Spacing_Scale:Back_Spacing_Scale);
function center_y(f) = face_length(f)*(f?Front_Center_Fraction:Back_Center_Fraction)+(f?Front_Text_Y:Back_Text_Y);
function font(f) = let(override=f?Front_Font_Override:Back_Font_Override) override=="" ? Font_Name : override;
function ink(f) = f ? Front_Inscription_Colour : Back_Inscription_Colour;

// Orthonormal basis: text does not stretch with wedge angle; local Z is outward.
// Back-face X is reversed so letters read correctly after turning the piece over.
module on_face(f) {
    s=f?1:-1;
    c=cosine(f);
    multmatrix([[s,0,0,0],[0,c,slope(f)*c,0],[0,-s*slope(f)*c,s*c,f?Rear_Thickness:0],[0,0,0,1]]) children();
}
module safe_face(f) { polygon([for(p=safe_outline) [p[0],p[1]/cosine(f)]]); }
module flat_face(f) { polygon([for(p=has_bezel?inner_outline:outline) [p[0],p[1]/cosine(f)]]); }

module raw_inscription(f) {
    n=len(chars(f));
    if(n>0 && style(f)!="None")
        translate([f?Front_Text_X:Back_Text_X, center_y(f)])
        rotate(f?Front_Text_Rotation:Back_Text_Rotation)
        for(i=[0:n-1]) {
            g=entry(f?Front_Glyph_Size:Back_Glyph_Size,i,1);
            gx=entry(f?Front_Glyph_Width:Back_Glyph_Width,i,1)*(f?Front_Width_Scale:Back_Width_Scale);
            gy=entry(f?Front_Glyph_Height:Back_Glyph_Height,i,1)*(f?Front_Height_Scale:Back_Height_Scale);
            translate([entry(f?Front_Glyph_X:Back_Glyph_X,i,0),(n-1-2*i)*char_spacing(f)/2+entry(f?Front_Glyph_Y:Back_Glyph_Y,i,0)])
            rotate(entry(f?Front_Glyph_Rotation:Back_Glyph_Rotation,i,0))
            // Expand AFTER scaling so stroke expansion remains a predictable mm value.
            offset(delta=f?Front_Stroke_Expansion:Back_Stroke_Expansion)
            scale([g*gx,g*gy])
            text(chars(f)[i],size=font_size(f),font=font(f),halign="center",valign="center",language="ja",$fn=Text_Curve_Resolution);
        }
}
module inscription(f) {
    if(Protect_Face_Edges) intersection() { raw_inscription(f); safe_face(f); }
    else raw_inscription(f);
}
module rounded_outline(f,r,expansion) {
    if(expansion>0) offset(r=expansion) offset(delta=-r) inscription(f);
    else offset(delta=-r) inscription(f);
}
module relief(f) {
    d=depth(f);
    raised=style(f)=="Raised";
    r=min(Text_Edge_Radius,d/2);
    zmin=raised?-epsilon:-d;
    zmax=raised?d:epsilon;
    if(active(f)) on_face(f)
        if(r==0)
            translate([0,0,zmin]) linear_extrude(height=zmax-zmin,convexity=20) inscription(f);
    else {
        translate([0,0,raised?zmin:zmin+r]) linear_extrude(height=zmax-zmin-r,convexity=20) rounded_outline(f,r,r);
        h=r/Text_Rounding_Steps;
        overlap=min(epsilon,h/10);
        for(i=[0:Text_Rounding_Steps-1]) {
            t=(i+0.5)/Text_Rounding_Steps;
            expansion=r*sqrt(1-t*t);
            z=raised?zmax-r+i*h:zmin+r-(i+1)*h;
            translate([0,0,raised?z-overlap:z]) linear_extrude(height=h+overlap,convexity=20) rounded_outline(f,r,expansion);
        }
    }
}
module printed_piece() {
    // Evaluate booleans through CGAL even during F5. OpenCSG can hide the
    // engraved polyhedron; STL/F6 alone does not exercise that preview path.
    color(Body_Colour) render(convexity=30) union() {
        difference() {
            blank();
            for(f=[true,false]) if(style(f)=="Recessed") relief(f);
        }
        for(f=[true,false]) if(style(f)=="Raised") relief(f);
    }
}
// Inspect is deliberately blocked at F6/export: the separate colours are not print geometry.
module inspection(f) {
    assert($preview,"Inspection is F5-only. Select Print or Blank before F6 / STL export.");
    color(Body_Colour) linear_extrude(height=0.1) polygon([for(p=outline) [p[0],p[1]/cosine(f)]]);
    if(active(f)) {
        color(ink(f)) translate([0,0,0.12]) linear_extrude(height=0.02) intersection() { raw_inscription(f); safe_face(f); }
        // Unconditionally show the original overflow, even when protection is enabled.
        color([1,0,0,1]) translate([0,0,0.15]) linear_extrude(height=0.02) difference() { raw_inscription(f); safe_face(f); }
    }
    if(Show_Layout_Guides) {
        color([0.1,0.5,0.9,0.65]) translate([0,0,0.11]) linear_extrude(height=0.005) difference() { safe_face(f); offset(delta=-0.08) safe_face(f); }
        color([0.1,0.5,0.9,0.5]) translate([-0.025,0,0.11]) cube([0.05,face_length(f),0.005]);
        // A final-size line-width reference, beside the piece, not on its printable surface.
        color([0.1,0.5,0.9,1]) translate([Base_Width/2+2,2,0]) cube([Reference_Line_Width/Model_Scale,5/Model_Scale,0.1]);
    }
}
module oriented_piece() {
    if(Print_Orientation=="Upright")
        translate([0,Rear_Thickness,0]) rotate([90,0,0]) children();
    else if(Print_Orientation=="Back face down")
        rotate([-atan(back_slope),0,0]) children();
    else children();
}
for(f=[true,false]) if(len(chars(f))>0) {
    echo(f?"Front resolved size / spacing / centre:":"Back resolved size / spacing / centre:",font_size(f),char_spacing(f),center_y(f));
    if(Text_Edge_Radius>depth(f)/2) echo("NOTE: text radius capped at half relief depth.");
}
if(Output_Mode=="Print") echo("Check both F5 Inspect views for red overflow and slicer paths for fine strokes before printing.");
if(!Protect_Face_Edges) echo("CAUTION: edge protection disabled; lettering can breach edges or form detached raised fragments.");
if(Print_Orientation=="Back face down" && active(false) && Output_Mode=="Print") echo("CAUTION: reverse relief faces the bed. Upright is the base orientation for two-sided pieces.");
scale([Model_Scale,Model_Scale,Model_Scale])
if(Output_Mode=="Inspect front" || Output_Mode=="Inspect back") inspection(Output_Mode=="Inspect front");
else oriented_piece()
    if(Output_Mode=="Blank") color(Body_Colour) blank();
    else printed_piece();

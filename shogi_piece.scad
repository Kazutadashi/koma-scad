// KomaSCAD — community base, revision 3.4
// OpenSCAD 2021.01. Units: mm / degrees, BEFORE Model_Scale.
// Start: choose inscriptions, dimensions, font; inspect both faces; F6; export STL.
// Standalone defaults already produce a piece; selecting a preset is optional.
// On opening: press F5 if OpenSCAD has not previewed yet. No preset change needed.
// Customizer: select Show Details to display units beside the controls.
// Keep shogi_piece.json beside this file only if you want the saved base preset.
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
// Print/Blank export ordinary STL. Colour assembly is a fast F5-only material preview; use scripts/komascad_export.py for coloured 3MF. Colour body/front/back export exact aligned parts.
Output_Mode = "Print"; // [Print,Blank,Inspect front,Inspect back,Inspect signature,Inspect pawn circle,Colour assembly,Colour body,Colour front,Colour back,Colour signature]
// Upright: broad heel on bed. Back face down: usually unsuitable for an engraved reverse.
Print_Orientation = "Upright"; // [Upright,Back face down,Design coordinates]
// Multiplier (unitless) — 1 = original dimensions; 2 = double all lengths.
Model_Scale = 1; // [0.25:0.05:20]

/* [02 - Piece dimensions] */
// mm — Heel-to-point length in plan view.
Piece_Length = 31.5; // [15:0.1:100]
// mm — Width across the broad heel.
Base_Width = 28; // [10:0.1:100]
// mm — Thickness at the broad heel. Thickness at the broad heel; not the thickness near the point.
Rear_Thickness = 9.5; // [3:0.1:30]
// Simple taper controls the actual thickness at the point; faces taper equally.
Taper_Mode = "Tip thickness"; // [Tip thickness,Reference side angles]
// mm — Thickness at the point before bevel.
Tip_Thickness = 3; // [1:0.1:20]

/* [03 - Front layout] */
// mm — Typographic size, not measured glyph height; 0 = automatic. 0 selects a size based on piece dimensions and character count; positive mm overrides it.
Front_Font_Size = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Multiplies automatic OR explicit font size. All adjustments remain active.
Front_Text_Scale = 1; // [0.25:0.01:2]
// mm — Centre-to-centre distance along the face; 0 = automatic. 0 selects centre-to-centre spacing automatically; positive mm overrides it.
Front_Character_Spacing = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing. In auto spacing, multiply the nominal spacing; does not resize characters.
Front_Spacing_Scale = 1; // [0.5:0.01:2]
// Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway. Fraction of face length from broad heel to point. 0.46 is slightly below centre.
Front_Center_Fraction = 0.46; // [0:0.01:1]
// mm — Whole inscription shift; positive = viewer’s right. Positive X = viewer's right; positive Y = toward the point, measured along the face.
Front_Text_X = 0; // [-20:0.1:20]
// mm — Whole inscription shift; positive = toward the point.
Front_Text_Y = 0; // [-20:0.1:20]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Width changes glyph width only; it never changes font size or spacing.
Front_Width_Scale = 1; // [0.25:0.01:2]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Front_Height_Scale = 1; // [0.25:0.01:2]
// Degrees — rotates the whole inscription counterclockwise as viewed. Rotation in degrees about the inscription centre, counterclockwise as viewed.
Front_Text_Rotation = 0; // [-180:1:180]

/* [04 - Back layout] */
// Link back typography and engraving to front settings. Back text, colour and body taper stay independent. Back controls remain visible but are unused while enabled; disable to restore them. This does not reflect the lettering.
Mirror_Front_Settings = false;
// mm — Typographic size, not measured glyph height; 0 = automatic.
Back_Font_Size = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Back_Text_Scale = 1; // [0.25:0.01:2]
// mm — Centre-to-centre distance along the face; 0 = automatic.
Back_Character_Spacing = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing.
Back_Spacing_Scale = 1; // [0.5:0.01:2]
// Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway.
Back_Center_Fraction = 0.46; // [0:0.01:1]
// mm — Whole inscription shift; positive = viewer’s right. Coordinates are seen from the reverse. Do not mirror the characters manually.
Back_Text_X = 0; // [-20:0.1:20]
// mm — Whole inscription shift; positive = toward the point.
Back_Text_Y = 0; // [-20:0.1:20]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Back_Width_Scale = 1; // [0.25:0.01:2]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Back_Height_Scale = 1; // [0.25:0.01:2]
// Degrees — rotates the whole inscription counterclockwise as viewed.
Back_Text_Rotation = 0; // [-180:1:180]

/* [05 - Front character adjustments] */
// Multipliers (unitless) — [first, second, third]; 1 = unchanged. Each pair is [first, second, third; written from point to heel]. Single-character text uses the FIRST entry. Three entries are provided. For two characters, the third is unused; further characters use neutral values.
Front_Glyph_Size = [1, 1, 1]; // [0.25:0.01:2]
// Multipliers (unitless) — [first, second, third]; 1 = unchanged.
Front_Glyph_Width = [1, 1, 1]; // [0.25:0.01:2]
// Multipliers (unitless) — [first, second, third]; 1 = unchanged.
Front_Glyph_Height = [1, 1, 1]; // [0.25:0.01:2]
// mm — Per-character lateral offsets [first, second, third]. Independent offsets in face mm; positive Y moves toward the point.
Front_Glyph_X = [0, 0, 0]; // [-10:0.1:10]
// mm — Per-character offsets toward the point [first, second, third].
Front_Glyph_Y = [0, 0, 0]; // [-10:0.1:10]
// Degrees — individual character rotations [first, second, third].
Front_Glyph_Rotation = [0, 0, 0]; // [-180:1:180]

/* [06 - Back character adjustments] */
// Multipliers (unitless) — [first, second, third]; 1 = unchanged.
Back_Glyph_Size = [1, 1, 1]; // [0.25:0.01:2]
// Multipliers (unitless) — [first, second, third]; 1 = unchanged.
Back_Glyph_Width = [1, 1, 1]; // [0.25:0.01:2]
// Multipliers (unitless) — [first, second, third]; 1 = unchanged.
Back_Glyph_Height = [1, 1, 1]; // [0.25:0.01:2]
// mm — Per-character lateral offsets [first, second, third].
Back_Glyph_X = [0, 0, 0]; // [-10:0.1:10]
// mm — Per-character offsets toward the point [first, second, third].
Back_Glyph_Y = [0, 0, 0]; // [-10:0.1:10]
// Degrees — individual character rotations [first, second, third].
Back_Glyph_Rotation = [0, 0, 0]; // [-180:1:180]

/* [07 - Filament colours] */
// Preview swatch and 3MF material label, not a printer slot. Custom uses Body Colour below.
Body_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Same as body shares its material. Metallic/glitter appearance comes from the actual filament.
Front_Filament = "Black"; // [Same as body,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Same as front shares the front material. Map these material labels to loaded spools in your slicer.
Back_Filament = "Red"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]

/* [08 - Engraving and stroke weight] */
// In Colour modes: Face only colours a thin printable region behind the visible glyph floor. Painted grooves also colours material beside the groove walls. Flush filled closes the recess.
Text_Colour_Treatment = "Face only"; // [Face only,Painted grooves,Flush filled]
// mm — Thickness of the printable colour region behind a glyph face. Also applies beneath painted grooves and the heel signature.
Paint_Floor_Thickness = 0.2; // [0.05:0.05:1.2]
// mm — Painted grooves only: colour width inside the body beside recessed walls. Small or intricate strokes still need slicer checks.
Paint_Wall_Thickness = 0.35; // [0.1:0.05:1.2]
// mm — Painted grooves only: plain body lip at the top of a recess.
Paint_Top_Lip = 0.03; // [0.01:0.01:0.2]
Front_Text_Style = "Recessed"; // [Recessed,Raised,None]
Back_Text_Style = "Recessed"; // [Recessed,Raised,None]
// mm — Recess depth or raised height, perpendicular to the face. Recess depth OR raised height, perpendicular to face; independent of print orientation.
Front_Relief_Depth = 0.2; // [0:0.05:3]
// mm — Recess depth or raised height, perpendicular to the face.
Back_Relief_Depth = 0.2; // [0:0.05:3]
// mm — Contour expansion; positive thickens strokes and narrows counters. Positive values thicken every outline. They also close small counters: inspect before printing.
Front_Stroke_Expansion = 0.12; // [-0.2:0.01:0.5]
// mm — Contour expansion; positive thickens strokes and narrows counters.
Back_Stroke_Expansion = 0.12; // [-0.2:0.01:0.5]
// Blank uses Font_Name. Override only when the reverse needs another typeface.
Front_Font_Override = "";
Back_Font_Override = "";
// mm — Text edge radius; 0 disables rounding. 0 keeps details sharp; rounding can remove narrow strokes. Radius is capped at half relief depth.
Text_Edge_Radius = 0; // [0:0.01:0.5]
// Count (integer) — layers used to approximate text rounding.
Text_Rounding_Steps = 6; // [2:1:12]

/* [09 - Edges and face margin] */
// mm — Plan-view width of the edge bevel. Chamfer width measured in plan view; depth measured in model Z. Either zero disables it.
Bevel_Width = 0.35; // [0:0.05:3]
// mm — Model-Z depth of each edge bevel.
Bevel_Depth = 0.18; // [0:0.02:2]
// mm — Extra plan-view margin beyond the flat face. Additional plan-view inset beyond the flat face edge. Applies to both faces.
Text_Margin = 0.8; // [0:0.1:4]
// Protect trims lettering at the safe boundary. Inspect red overflow and correct it before export.
Protect_Face_Edges = true;
// mm — Minimum solid web in model Z, AFTER Model Scale. Conservative minimum solid web, measured in model Z, AFTER scaling.
Minimum_Web = 1; // [0.2:0.1:5]

/* [10 - Advanced shape angles] */
// Enforce a 20-piece ring in the design plan: base angle = 81 degrees. Uses Angle Mode below; incompatible supplied angles stop rendering. Off preserves free shape design.
Pawn_Circle = false;
// Pentagon closure: 2*base + 2*shoulder + tip = 540 degrees.
// In a derive mode the named angle below is ignored; the Console reports resolved angles. With Pawn Circle, Derive base fixes base at 81 degrees and checks shoulder + tip; other modes require the supplied base to be 81 degrees.
Angle_Mode = "Derive shoulder"; // [Derive shoulder,Derive tip,Derive base,Check all three]
// Degrees — pentagon interior angle; ignored if selected for derivation.
Face_Base_Angle = 81;
// Degrees — pentagon interior angle; ignored if selected for derivation.
Face_Shoulder_Angle = 117;
// Degrees — pentagon interior angle; ignored if selected for derivation.
Face_Tip_Angle = 144;
// Degrees — used only in Reference side angles mode. Used ONLY in Reference side angles mode. Tip_Thickness is then ignored.
Front_Side_Base_Angle = 85;
// Degrees — used only in Reference side angles mode.
Back_Side_Base_Angle = 81;

/* [11 - Inspection and quality] */
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. These colours never create a second material or survive ordinary STL export.
Body_Colour = [0.76, 0.58, 0.34, 1];
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only.
Front_Inscription_Colour = [0.08, 0.06, 0.04, 1];
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only.
Back_Inscription_Colour = [0.65, 0.05, 0.04, 1];
Show_Layout_Guides = true;
// mm — Inspection reference-bar width, AFTER Model Scale. Effective toolpath line width, for reference guides ONLY. Does not guarantee printability.
Reference_Line_Width = 0.6; // [0.2:0.05:1.2]
// Count (integer) — curve tessellation segments; higher is smoother and slower.
Text_Curve_Resolution = 48; // [16:8:128]

/* [12 - Maker signature on heel] */
// Optional mark on the broad bottom edge, NOT on the reverse inscription face. Off preserves existing pieces.
Signature_Enabled = false;
// Horizontal text, read left to right while looking straight at the heel with the front face uppermost.
Signature_Text = "";
// Empty uses Font Name. Customizer font names have no surrounding quotes.
Signature_Font = "";
// mm — typographic size, not measured glyph height. Start small and use Inspect signature.
Signature_Font_Size = 2.5; // [0.5:0.1:8]
// Multiplier (unitless) — horizontal letter spacing; 1 = font default.
Signature_Letter_Spacing = 1; // [0.5:0.05:2]
// mm — horizontal shift from heel centre; positive = viewer's right.
Signature_X = 0; // [-12:0.1:12]
// mm — shift across heel thickness; positive = toward the front inscription face.
Signature_Y = 0; // [-5:0.1:5]
// Degrees — rotation about the signature centre, counterclockwise as viewed.
Signature_Rotation = 0; // [-180:1:180]
// mm — Depth into the heel. Face only colours its floor; Painted grooves can also colour material beside its walls; Flush filled closes it.
Signature_Depth = 0.4; // [0:0.05:2]
// mm — protective border around heel lettering. Overflow is clipped and shown red in Inspect signature.
Signature_Margin = 0.6; // [0.1:0.1:3]
// Colour 3MF material; Same as front reuses its filament. Ordinary Print remains single-material engraving.
Signature_Filament = "Same as front"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// RGBA (unitless, 0-1) — used only when Signature Filament is Custom; alpha is preview-only.
Signature_Colour = [0.08, 0.06, 0.04, 1];

/* [Hidden] */
// Linked values are resolved without overwriting saved independent back settings.
effective_Back_Font_Size = Mirror_Front_Settings ? Front_Font_Size : Back_Font_Size;
effective_Back_Text_Scale = Mirror_Front_Settings ? Front_Text_Scale : Back_Text_Scale;
effective_Back_Character_Spacing = Mirror_Front_Settings ? Front_Character_Spacing : Back_Character_Spacing;
effective_Back_Spacing_Scale = Mirror_Front_Settings ? Front_Spacing_Scale : Back_Spacing_Scale;
effective_Back_Center_Fraction = Mirror_Front_Settings ? Front_Center_Fraction : Back_Center_Fraction;
effective_Back_Text_X = Mirror_Front_Settings ? Front_Text_X : Back_Text_X;
effective_Back_Text_Y = Mirror_Front_Settings ? Front_Text_Y : Back_Text_Y;
effective_Back_Width_Scale = Mirror_Front_Settings ? Front_Width_Scale : Back_Width_Scale;
effective_Back_Height_Scale = Mirror_Front_Settings ? Front_Height_Scale : Back_Height_Scale;
effective_Back_Text_Rotation = Mirror_Front_Settings ? Front_Text_Rotation : Back_Text_Rotation;
effective_Back_Glyph_Size = Mirror_Front_Settings ? Front_Glyph_Size : Back_Glyph_Size;
effective_Back_Glyph_Width = Mirror_Front_Settings ? Front_Glyph_Width : Back_Glyph_Width;
effective_Back_Glyph_Height = Mirror_Front_Settings ? Front_Glyph_Height : Back_Glyph_Height;
effective_Back_Glyph_X = Mirror_Front_Settings ? Front_Glyph_X : Back_Glyph_X;
effective_Back_Glyph_Y = Mirror_Front_Settings ? Front_Glyph_Y : Back_Glyph_Y;
effective_Back_Glyph_Rotation = Mirror_Front_Settings ? Front_Glyph_Rotation : Back_Glyph_Rotation;
effective_Back_Text_Style = Mirror_Front_Settings ? Front_Text_Style : Back_Text_Style;
effective_Back_Relief_Depth = Mirror_Front_Settings ? Front_Relief_Depth : Back_Relief_Depth;
effective_Back_Stroke_Expansion = Mirror_Front_Settings ? Front_Stroke_Expansion : Back_Stroke_Expansion;
effective_Back_Font_Override = Mirror_Front_Settings ? Front_Font_Override : Back_Font_Override;
if(Mirror_Front_Settings) echo("Mirror Front Settings ON: back typography and engraving follow front. Back text/colour stay independent; disable to restore back controls. Automatic sizing still uses each face character count.");


// Exporter-only switch; no mesh is evaluated when querying material metadata.
Export_Metadata = false;
filament_palette = [
 ["Wood",[0.76,0.58,0.34,1]], ["Black",[0.08,0.06,0.04,1]],
 ["White",[0.95,0.95,0.95,1]], ["Red",[0.65,0.05,0.04,1]],
 ["Blue",[0.08,0.25,0.8,1]], ["Green",[0.08,0.5,0.2,1]],
 ["Purple",[0.45,0.15,0.65,1]], ["Yellow",[0.95,0.8,0.08,1]],
 ["Orange",[0.95,0.35,0.05,1]], ["Silver",[0.7,0.72,0.75,1]],
 ["Gold",[0.8,0.62,0.2,1]], ["Glitter silver",[0.7,0.72,0.75,1]],
 ["Glitter gold",[0.8,0.62,0.2,1]], ["Filament 1",[0.5,0.5,0.5,1]],
 ["Filament 2",[0.15,0.5,0.85,1]], ["Filament 3",[0.85,0.25,0.5,1]]
];
function filament_choice(role) = role==0 ? Body_Filament : role==1 ? Front_Filament : role==2 ? Back_Filament : Signature_Filament;
function material_source(role) = filament_choice(role)=="Same as body" ? 0 : filament_choice(role)=="Same as front" ? material_source(1) : role;
function material_name(role) = let(src=material_source(role),choice=filament_choice(src)) choice=="Custom" ? str("Custom ",["body","front","back","signature"][src]) : choice;
function material_rgb(role) = let(src=material_source(role),choice=filament_choice(src),matches=[for(p=filament_palette) if(p[0]==choice) p[1]])
 choice=="Custom" ? [Body_Colour,Front_Inscription_Colour,Back_Inscription_Colour,Signature_Colour][src] : assert(len(matches)==1,"Unknown filament colour.") matches[0];
colour_mode = len([for(m=["Colour assembly","Colour body","Colour front","Colour back","Colour signature"]) if(m==Output_Mode) 1])>0;
for(role=[0:3]) {
 assert(!(role==0 && (Body_Filament=="Same as body" || Body_Filament=="Same as front")),"Body needs its own filament choice.");
 assert(!(role==1 && Front_Filament=="Same as front"),"Front cannot reference itself.");
 assert(len(material_rgb(role))==4 && min(material_rgb(role))>=0 && max(material_rgb(role))<=1,"Custom colours need four RGBA values in 0..1.");
}
assert(valid_choice(Text_Colour_Treatment,["Face only","Painted grooves","Flush filled"]),"Unknown Text Colour Treatment.");
assert(Paint_Floor_Thickness>0 && Paint_Wall_Thickness>0 && Paint_Top_Lip>0,
 "Paint thickness and top lip must be positive.");
if(colour_mode) {
 assert(Protect_Face_Edges,"Colour geometry requires Protect Face Edges so parts stay within the face.");
 if(Text_Colour_Treatment=="Flush filled")
  for(f=[true,false]) assert(!active(f) || style(f)=="Recessed",
   "Flush filled requires Recessed or None on active faces. Select Face only or Painted grooves to retain Raised styles.");
}
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
function style(f) = f ? Front_Text_Style : effective_Back_Text_Style;
function depth(f) = f ? Front_Relief_Depth : effective_Back_Relief_Depth;
function active(f) = len(chars(f))>0 && style(f)!="None" && depth(f)>0;

assert(valid_choice(Output_Mode,["Print","Blank","Inspect front","Inspect back","Inspect signature","Inspect pawn circle","Colour assembly","Colour body","Colour front","Colour back","Colour signature"]),"Unknown Output_Mode.");
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
    assert((f?Front_Font_Size:effective_Back_Font_Size)>=0 && (f?Front_Character_Spacing:effective_Back_Character_Spacing)>=0,"Font size and spacing must be >=0; 0 means automatic.");
    assert(min(f?[Front_Text_Scale,Front_Spacing_Scale,Front_Width_Scale,Front_Height_Scale]:[effective_Back_Text_Scale,effective_Back_Spacing_Scale,effective_Back_Width_Scale,effective_Back_Height_Scale])>0,"Text scales must be positive.");
    assert((f?Front_Center_Fraction:effective_Back_Center_Fraction)>=0 && (f?Front_Center_Fraction:effective_Back_Center_Fraction)<=1,"Center fraction must be 0..1; use Y offset for additional movement.");
    for (a=f?[Front_Glyph_Size,Front_Glyph_Width,Front_Glyph_Height]:[effective_Back_Glyph_Size,effective_Back_Glyph_Width,effective_Back_Glyph_Height])
        assert(all_positive(a),"Glyph size/width/height lists must contain positive numbers.");
    for (a=f?[Front_Glyph_X,Front_Glyph_Y,Front_Glyph_Rotation]:[effective_Back_Glyph_X,effective_Back_Glyph_Y,effective_Back_Glyph_Rotation])
        assert(is_list(a),"Glyph offset/rotation settings must be lists.");
}

// Ring closure: 20 * (180 - 2*A) = 360. The named derived input is unused.
A = Angle_Mode=="Derive base" ? (Pawn_Circle ? 81 : (540-2*Face_Shoulder_Angle-Face_Tip_Angle)/2) : Face_Base_Angle;
B = Angle_Mode=="Derive shoulder" ? (540-2*Face_Base_Angle-Face_Tip_Angle)/2 : Face_Shoulder_Angle;
C = Angle_Mode=="Derive tip" ? 540-2*Face_Base_Angle-2*Face_Shoulder_Angle : Face_Tip_Angle;
if(Pawn_Circle) {
    assert(abs(A-81)<0.000001,
        str("Pawn Circle requires Face Base Angle = 81 degrees for 20 pieces; supplied ",A,
            ". Set base to 81, or choose Derive base to solve it from the ring constraint."));
    assert(abs(2*A+2*B+C-540)<0.000001,
        str("Pawn Circle: supplied shoulder/tip angles conflict. At base 81, 2*shoulder + tip must equal 378 degrees; got ",2*B+C,
            ". Use Derive shoulder or Derive tip, or correct the supplied values."));
}
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
echo("KomaSCAD v3.4 / category (label only):",Category);
echo("Body width, length, heel thickness after scaling:",Base_Width*Model_Scale,Piece_Length*Model_Scale,Rear_Thickness*Model_Scale);
echo("Resolved angles base / shoulder / point:",A,B,C);
echo("Tip thickness before bevel:",tip_thickness*Model_Scale);
// The side lines meet on the symmetry axis at circle_apothem.
// A regular 20-gon of heels closes; the pointed inner boundary is not a smooth circle.
circle_apothem = Base_Width/(2*tan(9));
if(Pawn_Circle) {
    assert(Piece_Length<circle_apothem,
        str("Pawn Circle: length must be less than ",circle_apothem,
            " mm at this width, otherwise inward tips touch or overlap at the centre."));
    echo("Pawn Circle: 20 identical pieces, 18 degrees per piece; plan-view constraint. Bevels leave intentional surface seams.");
    echo("Pawn Circle outer heel-corner diameter / inner tip-circle diameter (mm, scaled):",
        Base_Width/sin(9)*Model_Scale,2*(circle_apothem-Piece_Length)*Model_Scale);
}
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
function font_size(f) = let(n=max(1,len(chars(f))), override=f?Front_Font_Size:effective_Back_Font_Size)
    (override>0 ? override : min(Base_Width*0.43,face_length(f)*0.72/(1.35*n))) * (f?Front_Text_Scale:effective_Back_Text_Scale);
function char_spacing(f) = let(override=f?Front_Character_Spacing:effective_Back_Character_Spacing)
    override>0 ? override : font_size(f)*1.42*(f?Front_Spacing_Scale:effective_Back_Spacing_Scale);
function center_y(f) = face_length(f)*(f?Front_Center_Fraction:effective_Back_Center_Fraction)+(f?Front_Text_Y:effective_Back_Text_Y);
function font(f) = let(override=f?Front_Font_Override:effective_Back_Font_Override) override=="" ? Font_Name : override;
function ink(f) = material_rgb(f?1:2);

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
    translate([f?Front_Text_X:effective_Back_Text_X, center_y(f)])
    rotate(f?Front_Text_Rotation:effective_Back_Text_Rotation)
    for(i=[0:n-1]) {
        g=entry(f?Front_Glyph_Size:effective_Back_Glyph_Size,i,1);
        gx=entry(f?Front_Glyph_Width:effective_Back_Glyph_Width,i,1)*(f?Front_Width_Scale:effective_Back_Width_Scale);
        gy=entry(f?Front_Glyph_Height:effective_Back_Glyph_Height,i,1)*(f?Front_Height_Scale:effective_Back_Height_Scale);
        translate([entry(f?Front_Glyph_X:effective_Back_Glyph_X,i,0),(n-1-2*i)*char_spacing(f)/2+entry(f?Front_Glyph_Y:effective_Back_Glyph_Y,i,0)])
        rotate(entry(f?Front_Glyph_Rotation:effective_Back_Glyph_Rotation,i,0))
        // Expand AFTER scaling so stroke expansion remains a predictable mm value.
        offset(delta=f?Front_Stroke_Expansion:effective_Back_Stroke_Expansion)
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
module printed_geometry_raw() {
    union() {
        difference() {
            blank();
            for(f=[true,false]) if(style(f)=="Recessed") relief(f);
        }
        for(f=[true,false]) if(style(f)=="Raised") relief(f);
    }
}
// Heel coordinates: local X = model X, local Y = model Z, local Z = -model Y.
// This is a right-handed frame: the text is not mirrored. Upright puts this face on the bed.
function signature_active() = Signature_Enabled && len(Signature_Text)>0 && Signature_Depth>0;
function signature_font() = Signature_Font=="" ? Font_Name : Signature_Font;
sig_rim = has_bezel ? Bevel_Depth : 0;
sig_half_width = Base_Width/2 - Signature_Depth*tan(90-A) - Signature_Margin;
sig_low = max(sig_rim, Signature_Depth*back_slope) + Signature_Margin - Rear_Thickness/2;
sig_high = min(Rear_Thickness-sig_rim,Rear_Thickness-Signature_Depth*front_slope) - Signature_Margin - Rear_Thickness/2;
if(Signature_Enabled) {
 assert(Signature_Font_Size>0 && Signature_Letter_Spacing>0,"Signature font size and spacing must be positive.");
 assert(Signature_Depth>=0 && Signature_Margin>0,"Signature depth must be nonnegative; margin must be positive.");
 assert(Signature_Depth<Piece_Length/4,"Signature depth is too large; keep it below one quarter of piece length.");
 assert(sig_half_width>0 && sig_high>sig_low,"Signature margin/depth leaves no usable heel area.");
}
module on_heel() {
 multmatrix([[1,0,0,0],[0,0,-1,0],[0,1,0,Rear_Thickness/2],[0,0,0,1]]) children();
}
module signature_safe() {
 translate([-sig_half_width,sig_low]) square([2*sig_half_width,sig_high-sig_low]);
}
module signature_raw() {
 translate([Signature_X,Signature_Y]) rotate(Signature_Rotation)
 text(Signature_Text,size=Signature_Font_Size,font=signature_font(),spacing=Signature_Letter_Spacing,halign="center",valign="center",$fn=Text_Curve_Resolution);
}
module signature_outline() { intersection() { signature_raw(); signature_safe(); } }
module signature_cutter() {
 if(signature_active()) on_heel() translate([0,0,-Signature_Depth])
 linear_extrude(height=Signature_Depth+epsilon,convexity=20) signature_outline();
}
module signature_inlay() {
 if(signature_active()) intersection() { blank(); signature_cutter(); }
}
module printed_piece_raw() {
 difference() { printed_geometry_raw(); signature_cutter(); }
}
module printed_piece() {
 color(material_rgb(0))
 if($preview) render(convexity=30) printed_piece_raw();
 else printed_piece_raw();
}
module signature_inspection() {
 assert($preview,"Inspection is F5-only. Select Print before F6 / STL export.");
 color(material_rgb(0)) linear_extrude(height=0.1) square([Base_Width,Rear_Thickness],center=true);
 if(signature_active()) {
  color(material_rgb(3)) translate([0,0,0.12]) linear_extrude(height=0.02) signature_outline();
  color([1,0,0,1]) translate([0,0,0.15]) linear_extrude(height=0.02) difference() { signature_raw(); signature_safe(); }
 }
 if(Show_Layout_Guides) color([0.1,0.5,0.9,0.65]) translate([0,0,0.11]) linear_extrude(height=0.005)
 difference() { signature_safe(); offset(delta=-0.08) signature_safe(); }
}
// Parts are complementary sub-volumes of one selected PRINT design. Face only
// assigns material directly behind the exposed inscription surface; Painted
// grooves can also extend it beside a recessed wall. These backings remain
// inside printable geometry and never add a coating on top of the model.
module colour_inlay(f) { if(active(f)) difference() { intersection() { blank(); relief(f); } signature_cutter(); } }
// A printable surface colour cannot be zero-thickness. Face only therefore
// assigns a thin closed region immediately behind the visible recessed floor,
// without colouring the groove walls. Raised text receives a top cap.
module face_only_volume(f) {
 d=depth(f);
 if(style(f)=="Raised")
  on_face(f) translate([0,0,max(0,d-Paint_Floor_Thickness)])
   linear_extrude(height=min(d,Paint_Floor_Thickness)+epsilon,convexity=20)
   offset(delta=epsilon/2) inscription(f);
 else
  on_face(f) translate([0,0,-d-Paint_Floor_Thickness])
   linear_extrude(height=Paint_Floor_Thickness+epsilon,convexity=20)
   offset(delta=epsilon/2) inscription(f);
}
module face_only_region_raw(f) {
 if(active(f)) difference() {
  if(style(f)=="Raised") intersection() { relief(f); face_only_volume(f); }
  else if(style(f)=="Recessed") intersection() { blank(); face_only_volume(f); }
  for(g=[true,false]) if(style(g)=="Recessed") relief(g);
  signature_cutter();
 }
}
module face_only_region(f) {
 if(active(f)) difference() {
  face_only_region_raw(f);
  if(!f) face_only_region_raw(true);
  face_only_signature_region();
 }
}
module face_only_signature_region() {
 if(signature_active()) difference() {
  intersection() {
   blank();
   on_heel() translate([0,0,-Signature_Depth-Paint_Floor_Thickness])
    linear_extrude(height=Paint_Floor_Thickness+epsilon,convexity=20)
    offset(delta=epsilon/2) signature_outline();
  }
  for(g=[true,false]) if(style(g)=="Recessed") relief(g);
  signature_cutter();
 }
}
module face_only_body_region() {
 difference() { printed_piece(); face_only_region(true); face_only_region(false); face_only_signature_region(); }
}
module paint_volume(f) {
 on_face(f) translate([0,0,-depth(f)-Paint_Floor_Thickness])
  linear_extrude(height=depth(f)+Paint_Floor_Thickness-Paint_Top_Lip,convexity=20)
  offset(delta=Paint_Wall_Thickness) inscription(f);
}
module painted_face_region_raw(f) {
 if(active(f)) {
  if(style(f)=="Raised")
   difference() { relief(f); signature_cutter(); }
  else if(style(f)=="Recessed")
   difference() {
    intersection() { blank(); paint_volume(f); }
    // The painted volume is the printable solid inside the expanded local
    // paint tool. Removing all recess cutters gives the same region without
    // first evaluating and intersecting the complete printed piece.
    for(g=[true,false]) if(style(g)=="Recessed") relief(g);
    signature_cutter();
   }
 }
}
// Explicit material priority at unusual intersecting engravings:
// signature > front > back. Prevents overlapping slicer volumes.
module painted_face_region(f) {
 if(active(f)) difference() {
  painted_face_region_raw(f);
  if(!f) painted_face_region_raw(true);
  painted_signature_region();
 }
}
module painted_signature_region() {
 if(signature_active()) intersection() {
  printed_piece();
  on_heel() translate([0,0,-Signature_Depth-Paint_Floor_Thickness])
   linear_extrude(height=Signature_Depth+Paint_Floor_Thickness-Paint_Top_Lip,convexity=20)
   offset(delta=Paint_Wall_Thickness) signature_outline();
 }
}
module painted_body_region() {
 difference() { printed_piece(); painted_face_region(true); painted_face_region(false); painted_signature_region(); }
}
module flush_body_region() {
 difference() { blank(); colour_inlay(true); colour_inlay(false); signature_inlay(); }
}
// Colour assembly is a visual check, not export geometry. Draw the exact
// exterior used by Print once, then add only the exposed colour surfaces. The
// closed complementary volumes remain available in the individual Colour
// modes used by the exporter. This keeps F5 quick without changing any depth,
// bevel, relief, or exported mesh.
module preview_face_colour(f) {
 if(active(f)) {
  if(style(f)=="Raised" && Text_Colour_Treatment=="Painted grooves") relief(f);
  else if(style(f)=="Raised") intersection() {
   relief(f);
   on_face(f) translate([0,0,depth(f)-epsilon/2])
    linear_extrude(height=epsilon,convexity=20) inscription(f);
  }
  else if(Text_Colour_Treatment=="Flush filled")
   on_face(f) translate([0,0,-epsilon/2])
    linear_extrude(height=epsilon,convexity=20) inscription(f);
  else
   on_face(f) translate([0,0,-depth(f)-epsilon/2])
    linear_extrude(height=epsilon,convexity=20)
    offset(delta=Text_Colour_Treatment=="Painted grooves" ? Paint_Wall_Thickness : 0) inscription(f);
 }
}
module preview_signature_colour() {
 if(signature_active())
  on_heel() translate([0,0,
   Text_Colour_Treatment=="Flush filled" ? -epsilon/2 : -Signature_Depth-epsilon/2])
   linear_extrude(height=epsilon,convexity=20)
   offset(delta=Text_Colour_Treatment=="Painted grooves" ? Paint_Wall_Thickness : 0)
   signature_outline();
}
module colour_output() {
 // F6 implicitly unions top-level children, destroying material separation and
 // risking CGAL failures at the exactly touching body/colour interfaces.
 assert(Output_Mode!="Colour assembly" || $preview,
   "Colour assembly is F5 preview only. Use scripts/komascad_export.py for multipart colour 3MF; choose Print for engraved STL, or Colour body/front/back/signature for separate parts.");
 if(Output_Mode=="Colour assembly") {
  // The outside is exactly Print geometry. The coloured slivers are preview
  // overlays on its raised, flush, or recessed exposed surfaces only.
  color(material_rgb(0)) printed_piece();
  color(material_rgb(1)) preview_face_colour(true);
  color(material_rgb(2)) preview_face_colour(false);
  color(material_rgb(3)) preview_signature_colour();
 } else if(Text_Colour_Treatment=="Flush filled") {
   if(Output_Mode=="Colour body")
    color(material_rgb(0)) render(convexity=30) flush_body_region();
   if(Output_Mode=="Colour front")
    color(material_rgb(1)) render(convexity=30) colour_inlay(true);
   if(Output_Mode=="Colour back")
    color(material_rgb(2)) render(convexity=30) colour_inlay(false);
   if(Output_Mode=="Colour signature")
    color(material_rgb(3)) render(convexity=30) signature_inlay();
 } else if(Text_Colour_Treatment=="Face only") {
   if(Output_Mode=="Colour body")
    color(material_rgb(0)) render(convexity=30) face_only_body_region();
   if(Output_Mode=="Colour front")
    color(material_rgb(1)) render(convexity=30) face_only_region(true);
   if(Output_Mode=="Colour back")
    color(material_rgb(2)) render(convexity=30) face_only_region(false);
   if(Output_Mode=="Colour signature")
    color(material_rgb(3)) render(convexity=30) face_only_signature_region();
 } else {
   if(Output_Mode=="Colour body")
    color(material_rgb(0)) render(convexity=30) painted_body_region();
   if(Output_Mode=="Colour front")
    color(material_rgb(1)) render(convexity=30) painted_face_region(true);
   if(Output_Mode=="Colour back")
    color(material_rgb(2)) render(convexity=30) painted_face_region(false);
   if(Output_Mode=="Colour signature")
    color(material_rgb(3)) render(convexity=30) painted_signature_region();
 }
}
// Inspect is deliberately blocked at F6/export: the separate colours are not print geometry.
module inspection(f) {
    assert($preview,"Inspection is F5-only. Select Print or Blank before F6 / STL export.");
    color(material_rgb(0)) linear_extrude(height=0.1) polygon([for(p=outline) [p[0],p[1]/cosine(f)]]);
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
// Diagram in the common XY design plane; no text, taper, or bevel is projected.
// This makes nominal side contact visible without CGAL work on twenty inscriptions.
module pawn_circle_inspection() {
    assert($preview,"Inspect pawn circle is F5-only. Select Print to export a single piece.");
    assert(Pawn_Circle,"Enable Pawn Circle to validate angles before inspecting the ring.");
    for(i=[0:19]) rotate([0,0,i*18]) translate([0,-circle_apothem,0]) {
        color(i%2==0 ? material_rgb(0) : [0.64,0.43,0.22,1])
            linear_extrude(height=0.1) polygon(outline);
        if(Show_Layout_Guides) color([0.1,0.5,0.9,1]) translate([0,0,0.11])
            linear_extrude(height=0.005) difference() { polygon(outline); offset(delta=-0.08) polygon(outline); }
    }
    if(Show_Layout_Guides) color([0.1,0.5,0.9,0.7]) translate([0,0,0.11])
        linear_extrude(height=0.005) difference() {
            circle(r=Base_Width/(2*sin(9))+0.04,$fn=360);
            circle(r=Base_Width/(2*sin(9))-0.04,$fn=360);
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
if(signature_active()) echo("Signature is on the heel (bed-facing in Upright). Check Inspect signature, then check the first layers in your slicer.");
if(Output_Mode=="Print") echo("Check both F5 Inspect views for red overflow and slicer paths for fine strokes before printing.");
if(!Protect_Face_Edges) echo("CAUTION: edge protection disabled; lettering can breach edges or form detached raised fragments.");
if(Print_Orientation=="Back face down" && active(false) && Output_Mode=="Print") echo("CAUTION: reverse relief faces the bed. Upright is the base orientation for two-sided pieces.");
if(colour_mode) echo("COLOUR 3MF: use scripts/komascad_export.py; native OpenSCAD 2021 export does not retain material assignments. Treatment:",Text_Colour_Treatment);
if(Export_Metadata && Output_Mode!="Colour assembly")
 assert(false,"Export_Metadata is an internal switch; remove it from your saved preset to show geometry. The Python exporter sets it automatically.");
if(Export_Metadata) echo("KOMASCAD_FONTS", concat([for(f=[true,false]) if(active(f)) font(f)],signature_active() ? [signature_font()] : []));
if(Export_Metadata) echo("KOMASCAD_EXPORT", [for(role=[0:3]) [["body","front","back","signature"][role],material_name(role),material_rgb(role),role==0 ? true : role==3 ? signature_active() : active(role==1)]]);
if(!Export_Metadata)
scale([Model_Scale,Model_Scale,Model_Scale])
if(Output_Mode=="Inspect pawn circle") pawn_circle_inspection();
else if(Output_Mode=="Inspect signature") signature_inspection();
else if(Output_Mode=="Inspect front" || Output_Mode=="Inspect back") inspection(Output_Mode=="Inspect front");
else oriented_piece()
    if(Output_Mode=="Blank") color(material_rgb(0)) blank();
    else if(colour_mode) colour_output();
    else printed_piece();

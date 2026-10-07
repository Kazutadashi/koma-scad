// KomaSCAD — community base, revision 3.4
// Contributors and acknowledgements: see CONTRIBUTORS.md and README.md.
// OpenSCAD 2021.01. Units: mm / degrees, BEFORE Model_Scale.
// Start in Model: shape the piece, choose the font and choose colors in one live preview.
// Standalone defaults already produce a piece; selecting a preset is optional.
// All bundled presets open in Model. F5 is only a fallback if Automatic Preview is disabled.
// Customizer: select Show Details to display units beside the controls.
// Keep shogi_piece.json beside this file to get the bundled game presets.
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
// Model is the complete geometry-and-color workspace. F6 exports one ordinary single-material STL; "komascad.py export" writes the shown multipart color 3MF.
Output_Mode = "Model"; // [Model,Blank,Inspect front,Inspect back,Inspect printability,Inspect signature,Inspect pawn circle]
// Upright: broad heel on bed. Front or Back face down: lies flat with that face on the bed; a raised inscription on the bed-side face is rejected.
Print_Orientation = "Upright"; // [Upright,Front face down,Back face down,Design coordinates]
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
// mm — Center-to-center distance along the face; 0 = automatic. 0 selects center-to-center spacing automatically; positive mm overrides it.
Front_Character_Spacing = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. Used only with automatic spacing. In auto spacing, multiply the nominal spacing; does not resize characters.
Front_Spacing_Scale = 1; // [0.5:0.01:2]
// Fraction (unitless, 0–1) — position from heel to point; 0.5 = halfway. Fraction of face length from broad heel to point. 0.46 is slightly below center.
Front_Center_Fraction = 0.46; // [0:0.01:1]
// mm — Whole inscription shift; positive = viewer’s right. Positive X = viewer's right; positive Y = toward the point, measured along the face.
Front_Text_X = 0; // [-20:0.1:20]
// mm — Whole inscription shift; positive = toward the point.
Front_Text_Y = 0; // [-20:0.1:20]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%.  Width changes glyph width only; it never changes font size or spacing.
Front_Width_Scale = 1; // [0.25:0.01:2]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Front_Height_Scale = 1; // [0.25:0.01:2]
// Degrees — rotates the whole inscription counterclockwise as viewed. Rotation in degrees about the inscription center, counterclockwise as viewed.
Front_Text_Rotation = 0; // [-180:1:180]

/* [04 - Back layout] */
// Link back typography and engraving to front settings. Back text, color and body taper stay independent. Back controls remain visible but are unused while enabled; disable to restore them. This does not reflect the lettering.
Mirror_Front_Settings = false;
// mm — Typographic size, not measured glyph height; 0 = automatic.
Back_Font_Size = 0; // [0:0.1:40]
// Multiplier (unitless) — 1 = unchanged; 1.1 = 110%. 
Back_Text_Scale = 1; // [0.25:0.01:2]
// mm — Center-to-center distance along the face; 0 = automatic.
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

/* [07 - Filament colors] */
// Live Model color and standard 3MF logical material, not a physical printer slot. Custom uses Body Color below.
Body_Filament = "Wood"; // [Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Same as body shares its material. Metallic/glitter appearance comes from the actual filament.
Front_Filament = "Black"; // [Same as body,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// Same as front shares its logical filament. Confirm logical colors against loaded physical spools in your slicer.
Back_Filament = "Red"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]

/* [08 - Engraving and stroke weight] */
// Model and 3MF appearance: Face only colors a slicer-safe region behind the visible glyph floor. Painted grooves also colors the groove walls. Flush filled closes the recess.
Text_Color_Treatment = "Face only"; // [Face only,Painted grooves,Flush filled]
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
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only. These colors never create a second material or survive ordinary STL export.
Body_Color = [0.76, 0.58, 0.34, 1];
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only.
Front_Inscription_Color = [0.08, 0.06, 0.04, 1];
// RGBA (unitless, 0–1 each) — [red, green, blue, opacity]; display only.
Back_Inscription_Color = [0.65, 0.05, 0.04, 1];
Show_Layout_Guides = true;
// mm — Inspection reference-bar width, AFTER Model Scale. Effective toolpath line width, for reference guides ONLY. Does not guarantee printability.
Reference_Line_Width = 0.6; // [0.2:0.05:1.2]
// Count (integer) — curve tessellation segments; higher is smoother and slower.
Text_Curve_Resolution = 48; // [16:8:128]
// mm — your printer's line width on the face, AFTER Model Scale; 0.5 with the print guide's settings. Inspect printability marks character strokes thinner (yellow) and gaps narrower (blue) than this; the exporter refuses lettering with too much of either.
Print_Line_Width = 0.5; // [0.2:0.05:1.2]

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
// mm — horizontal shift from heel center; positive = viewer's right.
Signature_X = 0; // [-12:0.1:12]
// mm — shift across heel thickness; positive = toward the front inscription face.
Signature_Y = 0; // [-5:0.1:5]
// Degrees — rotation about the signature center, counterclockwise as viewed.
Signature_Rotation = 0; // [-180:1:180]
// mm — Depth into the heel. Face only colors its floor; Painted grooves can also color material beside its walls; Flush filled closes it.
Signature_Depth = 0.4; // [0:0.05:2]
// mm — protective border around heel lettering. Overflow is clipped and shown red in Inspect signature.
Signature_Margin = 0.6; // [0.1:0.1:3]
// Color 3MF material; Same as front reuses its filament. F6 Model remains a single-material STL.
Signature_Filament = "Same as front"; // [Same as body,Same as front,Wood,Black,White,Red,Blue,Green,Purple,Yellow,Orange,Silver,Gold,Glitter silver,Glitter gold,Filament 1,Filament 2,Filament 3,Custom]
// RGBA (unitless, 0-1) — used only when Signature Filament is Custom; alpha is preview-only.
Signature_Color = [0.08, 0.06, 0.04, 1];

/* [13 - Movement diagrams] */
// Move grid for the front, drawn below or above the characters. Rows run from the point to the heel, separated by /. @ piece; o moves there; x jumps there; ! captures there without moving (igui) or moves on; # slides; = flies over pieces, capturing them; L slides and may turn 90 degrees; 2-7 beside the @ moves up to that many squares. # = L after an x slide on from the jump. Draw one with move-editor.html. Empty = no diagram.
Front_Moves = "";
Front_Move_Position = "Below"; // [Below,Above]
// Moves after promotion, shown on the reverse. Same symbols as Front Moves.
Back_Moves = "";
Back_Move_Position = "Below"; // [Below,Above]
// mm — thinnest diagram stroke, AFTER Model Scale. Use the line ladder result from the print test page.
Move_Stroke = 0.6; // [0.3:0.05:2]
// mm — narrowest gap between diagram marks, AFTER Model Scale. Use the gap ladder result from the print test page.
Move_Gap = 0.6; // [0.3:0.05:2]
// mm — distance between squares in the diagram, AFTER Model Scale; 0 = automatic. Give every piece of a set the same value so their marks match; the model stops if a grid needs more.
Move_Pitch = 0; // [0:0.05:10]

/* [Hidden] */
// Export material regions need enough physical width for ordinary 0.4 mm
// extrusion systems. This is deliberately independent of the visible 0.2 mm
// engraving depth and is not a user-tuning requirement.
Paint_Floor_Thickness = 0.8;
Paint_Wall_Thickness = 0.35;
Paint_Top_Lip = 0.03;
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
if(Mirror_Front_Settings) echo("Mirror Front Settings ON: back typography and engraving follow front. Back text/color stay independent; disable to restore back controls. Automatic sizing still uses each face character count.");


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
 choice=="Custom" ? [Body_Color,Front_Inscription_Color,Back_Inscription_Color,Signature_Color][src] : assert(len(matches)==1,"Unknown filament color.") matches[0];
model_mode = Output_Mode=="Model" || Output_Mode=="Print"
 || (Output_Mode=="Color assembly" && !Export_Metadata); // Legacy preset aliases.
color_mode = len([for(m=["Color assembly","Color body","Color front","Color back","Color signature"]) if(m==Output_Mode) 1])>0;
for(role=[0:3]) {
 assert(!(role==0 && (Body_Filament=="Same as body" || Body_Filament=="Same as front")),"Body needs its own filament choice.");
 assert(!(role==1 && Front_Filament=="Same as front"),"Front cannot reference itself.");
 assert(len(material_rgb(role))==4 && min(material_rgb(role))>=0 && max(material_rgb(role))<=1,"Custom colors need four RGBA values in 0..1.");
}
assert(valid_choice(Text_Color_Treatment,["Face only","Painted grooves","Flush filled"]),"Unknown Text Color Treatment.");
assert(Paint_Floor_Thickness>0 && Paint_Wall_Thickness>0 && Paint_Top_Lip>0,
 "Paint thickness and top lip must be positive.");
if(color_mode) {
 assert(Protect_Face_Edges,"Color geometry requires Protect Face Edges so parts stay within the face.");
 if(Text_Color_Treatment=="Flush filled")
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
function move_grid(f) = f ? Front_Moves : Back_Moves;
function has_moves(f) = len(move_grid(f))>0;
// Characters plus the diagram, which takes one more slot below or above them.
function slots(f) = len(chars(f)) + (has_moves(f) ? 1 : 0);
function moves_above(f) = has_moves(f) && (f ? Front_Move_Position : Back_Move_Position)=="Above";
function diagram_slot(f) = has_moves(f) ? (moves_above(f) ? 0 : slots(f)-1) : -1;
function style(f) = f ? Front_Text_Style : effective_Back_Text_Style;
function depth(f) = f ? Front_Relief_Depth : effective_Back_Relief_Depth;
function active(f) = slots(f)>0 && style(f)!="None" && depth(f)>0;

assert(valid_choice(Output_Mode,concat(["Model","Print","Blank","Inspect front","Inspect back","Inspect printability","Inspect signature","Inspect pawn circle","Color assembly","Color body","Color front","Color back","Color signature"],printability_modes)),"Unknown Output_Mode.");
assert(valid_choice(Print_Orientation,["Upright","Front face down","Back face down","Design coordinates"]),"Unknown Print_Orientation.");
assert(valid_choice(Taper_Mode,["Tip thickness","Reference side angles"]),"Unknown Taper_Mode.");
assert(valid_choice(Angle_Mode,["Derive shoulder","Derive tip","Derive base","Check all three"]),"Unknown Angle_Mode.");
assert(Model_Scale>0 && Piece_Length>0 && Base_Width>0 && Rear_Thickness>0,"Scale and dimensions must be positive.");
assert(Bevel_Width>=0 && Bevel_Depth>=0 && Text_Margin>=0 && Minimum_Web>0,"Bevel / margin must be nonnegative; web must be positive.");
assert(Text_Curve_Resolution>=16 && Text_Curve_Resolution<=128 && floor(Text_Curve_Resolution)==Text_Curve_Resolution,"Text resolution must be an integer 16..128.");
assert(Text_Edge_Radius>=0 && Text_Rounding_Steps>=2 && Text_Rounding_Steps<=12 && floor(Text_Rounding_Steps)==Text_Rounding_Steps,"Invalid text rounding settings.");
assert(Reference_Line_Width>0,"Reference_Line_Width must be positive.");
assert(Move_Stroke>0 && Move_Gap>0 && Print_Line_Width>0,"Move stroke, move gap and print line width must be positive.");
assert(Move_Stroke>=Print_Line_Width && Move_Gap>=Print_Line_Width,"Move Stroke and Move Gap cannot be narrower than Print Line Width: the printer could not make them.");
for(f=[true,false]) if(has_moves(f)) let(name=f?"Front_Moves":"Back_Moves", grid=move_grid(f), rows=grid_rows(grid)) {
 assert(len([for(row=rows, c=row) if(!valid_choice(c,move_symbols)) 1])==0,
  str(name," may only use . o x ! # = L 2-7 @ and /: ",grid));
 assert(len([for(row=rows, c=row) if(c=="@") 1])==1, str(name," needs exactly one @ for the piece: ",grid));
 assert(len([for(row=rows) if(len(row)!=len(rows[0])) 1])==0, str(name," rows must all be the same length: ",grid));
 let(marks=move_marks(f)) {
  assert(len([for(m=marks) if(mv_is_direction(m[2]) && !on_line(m)) 1])==0,
   str(name,": # = and L must lie straight or diagonally from the @: ",grid));
  assert(len([for(m=marks) if((m[2]=="!" || mv_is_digit(m[2])) && mv_cheb(m)!=1) 1])==0,
   str(name,": ! and 2-7 go on a square next to the @: ",grid));
 }
}
assert(!(model_mode && Print_Orientation=="Back face down" && active(false) && style(false)=="Raised"),
    "Raised reverse extends below the bed. Use Upright for this piece.");
assert(!(model_mode && Print_Orientation=="Front face down" && active(true) && style(true)=="Raised"),
    "Raised front extends below the bed. Use Upright for this piece.");
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
            " mm at this width, otherwise inward tips touch or overlap at the center."));
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
// Usable face length, and the share of it a stack with a diagram may fill:
// the margin keeps characters out of the narrow point.
function safe_length(f) = let(ys=[for(q=safe_outline) q[1]/cosine(f)]) max(ys)-min(ys);
mv_fill = 0.9;
function font_size(f) = let(n=max(1,slots(f)), override=f?Front_Font_Size:effective_Back_Font_Size,
    // With a diagram, the characters get what the smallest printable diagram
    // leaves: each takes 1.42 sizes of spacing, plus the gap above the diagram.
    beside=len(chars(f))>0 && has_moves(f)
        ? (safe_length(f)*mv_fill-mv_min_height(f))/(1.42*(f?Front_Spacing_Scale:effective_Back_Spacing_Scale)*len(chars(f))+0.42) : 1e9)
    (override>0 ? override : min(Base_Width*0.43, beside<1e9 ? beside : face_length(f)*0.72/(1.35*n))) * (f?Front_Text_Scale:effective_Back_Text_Scale);
function char_spacing(f) = let(override=f?Front_Character_Spacing:effective_Back_Character_Spacing)
    override>0 ? override : font_size(f)*1.42*(f?Front_Spacing_Scale:effective_Back_Spacing_Scale);
function center_y(f) = let(c=face_length(f)*(f?Front_Center_Fraction:effective_Back_Center_Fraction)+(f?Front_Text_Y:effective_Back_Text_Y))
    has_moves(f) ? let(ys=[for(q=safe_outline) q[1]/cosine(f)], half=stack_height(f)/2)
        // Slide a stack that holds a diagram back inside the face; the fit check catches one too long to fit.
        max(min(ys)+half, min(max(ys)-half, c)) : c;
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

module raw_inscription(f,diagram=true) {
    n=slots(f);
    if(n>0 && style(f)!="None")
    translate([f?Front_Text_X:effective_Back_Text_X, center_y(f)])
    rotate(f?Front_Text_Rotation:effective_Back_Text_Rotation)
    for(i=[0:n-1]) {
        g=entry(f?Front_Glyph_Size:effective_Back_Glyph_Size,i,1);
        gx=entry(f?Front_Glyph_Width:effective_Back_Glyph_Width,i,1)*(f?Front_Width_Scale:effective_Back_Width_Scale);
        gy=entry(f?Front_Glyph_Height:effective_Back_Glyph_Height,i,1)*(f?Front_Height_Scale:effective_Back_Height_Scale);
        translate([entry(f?Front_Glyph_X:effective_Back_Glyph_X,i,0),slot_y(f,i)+entry(f?Front_Glyph_Y:effective_Back_Glyph_Y,i,0)])
        rotate(entry(f?Front_Glyph_Rotation:effective_Back_Glyph_Rotation,i,0))
        // Diagrams are already sized for printing; stroke expansion is for lettering.
        if(i==diagram_slot(f)) { if(diagram) move_diagram(f); }
        // Expand AFTER scaling so stroke expansion remains a predictable mm value.
        else offset(delta=f?Front_Stroke_Expansion:effective_Back_Stroke_Expansion)
        scale([g*gx,g*gy])
        text(chars(f)[moves_above(f) ? i-1 : i],size=font_size(f),font=font(f),halign="center",valign="center",language="ja",$fn=Text_Curve_Resolution);
    }
}

// Slots are stacked from the point to the heel. A character slot is one
// character spacing tall; a diagram slot is as tall as its diagram needs.
function slot_height(f,i) = i==diagram_slot(f)
    ? mv_box_size(f)[1] + (char_spacing(f)-font_size(f))
    : char_spacing(f);
function slot_y(f,i) = let(heights=[for(j=[0:slots(f)-1]) slot_height(f,j)])
    sum_to(heights,slots(f))/2 - sum_to(heights,i) - heights[i]/2;
function sum_to(v,n) = n<=0 ? 0 : v[n-1] + sum_to(v,n-1);
function stack_height(f) = sum_to([for(j=[0:slots(f)-1]) slot_height(f,j)],slots(f));

// --- Movement diagrams -------------------------------------------------------
// A grid such as ".#./#@#/.#." describes the squares around the piece: rows
// from the point to the heel, spaces ignored. Every mark is built from two
// final sizes, the thinnest stroke and the narrowest gap the printer keeps,
// so each inked shape and each gap between shapes stays printable at any
// Model Scale. Marks differ in outline, never only in size.
mvW = Move_Stroke/Model_Scale;
mvG = Move_Gap/Model_Scale;
mv_dot = 2*mvW;                         // o: a square the piece can stop on
mv_ring = 2*mvW + mvG;                  // x: a square it jumps to; the hole is one gap
mv_cross = 3*mvW;                       // !: igui, capture there without moving; notches stay one gap wide
mv_head = 2.5*mvW;                      // # and =: arrowhead length and base
mv_tee = 3.5*mvW;                       // L: bar across the end of a hook move
mv_piece = 3*mvW;                       // @: the piece, a pentagon pointing forward
mv_digit = [2*mvW+mvG, 3*mvW+2*mvG];    // 3-7: seven-segment count, width and height
move_directions = [[0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1]];
mv_slide_past = 0.5;                    // a slide's arrowhead lies this many squares past its farthest mark
move_symbols = [".","o","x","!","#","=","L","2","3","4","5","6","7","@"];

function without_spaces(s,i=0) = i>=len(s) ? "" : str(s[i]==" " ? "" : s[i], without_spaces(s,i+1));
function grid_rows(text) = let(g=without_spaces(text), n=len(g),
    cuts=concat([-1],[for(i=[0:n-1]) if(g[i]=="/") i],[n]))
    [for(r=[0:len(cuts)-2]) [for(i=[0:n-1]) if(i>cuts[r] && i<cuts[r+1]) g[i]]];
function mv_grid_ok(f) = let(rows=grid_rows(move_grid(f)))
    len([for(row=rows, c=row) if(!valid_choice(c,move_symbols)) 1])==0
    && len([for(row=rows, c=row) if(c=="@") 1])==1
    && len([for(row=rows) if(len(row)!=len(rows[0])) 1])==0;
// [dx, dy, symbol] for every mark, in squares from the @; positive dy is forward.
function move_marks(f) = let(rows=grid_rows(move_grid(f)),
    at=[for(r=[0:len(rows)-1]) for(c=[0:len(rows[r])]) if(rows[r][c]=="@") [r,c]][0])
    [for(r=[0:len(rows)-1]) for(c=[0:len(rows[r])]) if(valid_choice(rows[r][c],move_symbols) && rows[r][c]!="." && rows[r][c]!="@")
        [c-at[1], at[0]-r, rows[r][c]]];
function on_line(m) = m[0]==0 || m[1]==0 || abs(m[0])==abs(m[1]);
function mv_cheb(m) = max(abs(m[0]),abs(m[1]));
function mv_unit(m) = [sign(m[0]),sign(m[1])];
function mv_ray(u) = [for(i=[0:7]) if(move_directions[i]==u) i][0];
function mv_is_direction(c) = c=="#" || c=="=" || c=="L";
function mv_is_digit(c) = valid_choice(c,["2","3","4","5","6","7"]);
function mv_stops(c) = c=="o" || c=="x" || c=="!";
// Reaching every square within two steps is an area move (a lion): one frame
// replaces 24 marks that could never be printed apart.
function mv_area(marks) = len([for(a=[-2:2], b=[-2:2]) if(max(abs(a),abs(b))>0
    && len([for(m=marks) if(m[0]==a && m[1]==b && mv_stops(m[2])) 1])==0) 1])==0;
function mv_visible(marks,area) = [for(m=marks) if(!(area && mv_cheb(m)<=2 && mv_stops(m[2]))) m];
function mv_reach(vis,area) = max(concat([1, area ? 2 : 1],
    [for(m=vis) if(mv_stops(m[2])) mv_cheb(m)], [for(m=vis) if(mv_is_digit(m[2])) 2]));
// A slide's arrow lies past the farthest mark on its own line.
function mv_ray_reach(vis,m) = max(concat([1],[for(k=vis) if(on_line(k) && mv_unit(k)==mv_unit(m)
    && (mv_stops(k[2]) || mv_is_digit(k[2]))) mv_is_digit(k[2]) ? 2 : mv_cheb(k)]));
// A slide behind a jump on its line continues from that jump.
function mv_slide_from(vis,m) = let(rings=[for(k=vis) if(k[2]=="x" && on_line(k)
    && mv_unit(k)==mv_unit(m) && mv_cheb(k)<mv_cheb(m)) mv_cheb(k)]) len(rings)>0 ? max(rings) : 0;
function mv_starts_slide(vis,k) = len([for(m=vis) if(mv_is_direction(m[2]) && on_line(m) && on_line(k)
    && mv_unit(m)==mv_unit(k) && mv_slide_from(vis,m)==mv_cheb(k)) 1])>0;
function mv_digit_value(c) = ord(c)-ord("0");

// Layout at pitch p (mm per square): [marks, lines, frame half-size, reach].
// A mark is [kind, center, spacing radius, line it belongs to, drawing data];
// a line is [start, end, line id, visible shaft length]. Line ids are the
// direction index 0-7 or 100+ for a mark off the eight lines.
function mv_layout(f,p) = let(
    marks=move_marks(f), area=mv_area(marks), vis=mv_visible(marks,area), n=len(vis),
    R=mv_reach(vis,area),
    pieces=[["piece",[0,0],mv_piece/2,-1,0]],
    stops=[for(i=[0:1:n-1]) let(m=vis[i], c=[m[0],m[1]]*p, line=on_line(m) ? mv_ray(mv_unit(m)) : 100+i)
        if(m[2]=="o") ["dot",c,mv_dot/2,line,0]
        else if(m[2]=="!") ["cross",c,(mv_cross-mvW)/2*sqrt(2)+mvW/2,line,0]
        else if(m[2]=="x") ["ring",c,mv_ring/2,mv_starts_slide(vis,m) ? line : 100+i,0]],
    ranges=[for(m=vis) if(mv_is_digit(m[2])) let(u=mv_unit(m), nu=u/norm(u), d=mv_digit_value(m[2]),
        half=abs(nu[0])*mv_digit[0]/2+abs(nu[1])*mv_digit[1]/2)
        each (d==2 ? [["dot",u*p,mv_dot/2,mv_ray(u),0], ["dot",2*u*p,mv_dot/2,mv_ray(u),0]]
                   : [["digit",u*p+nu*(mvW/2+mvG+half),norm(mv_digit)/2,mv_ray(u),d]])],
    ends=[for(m=vis) if(mv_is_direction(m[2])) let(u=mv_unit(m), nu=u/norm(u), s=mv_slide_from(vis,m),
        tip=u*(max(mv_ray_reach(vis,m),s+1)+mv_slide_past)*p, angle=atan2(nu[1],nu[0]))
        each (m[2]=="L" ? [["tee",tip,mv_tee/2,mv_ray(u),angle]]
            : concat([["head",tip-nu*0.55*mv_head,0.55*mv_head,mv_ray(u),[tip,angle]]],
                m[2]=="=" ? [["head",tip-nu*(1.55*mv_head+mvG),0.55*mv_head,mv_ray(u),[tip-nu*(mv_head+mvG),angle]]] : []))],
    lines=concat(
        [for(i=[0:1:n-1]) let(m=vis[i]) if(m[2]=="o" || m[2]=="!")
            [[0,0],[m[0],m[1]]*p,on_line(m) ? mv_ray(mv_unit(m)) : 100+i,1e9]],
        [for(m=vis) if(mv_is_digit(m[2])) let(u=mv_unit(m))
            [[0,0],(mv_digit_value(m[2])==2 ? 2 : 1)*u*p,mv_ray(u),1e9]],
        [for(m=vis) if(mv_is_direction(m[2])) let(u=mv_unit(m), nu=u/norm(u), s=mv_slide_from(vis,m),
            tip=u*(max(mv_ray_reach(vis,m),s+1)+mv_slide_past)*p, start=s>0 ? u*s*p+nu*mv_ring/2 : [0,0],
            head=m[2]=="L" ? mvW/2 : m[2]=="=" ? 2*mv_head+mvG : mv_head)
            [start, m[2]=="L" ? tip : tip-nu*0.5*mv_head, mv_ray(u), norm(tip-start)-(s>0 ? 0 : mv_piece/2)-head]]))
    [[for(m=concat(pieces,stops,ranges,ends)) concat(m,[mv_capsules(m)])], lines, area ? 2*p : 0, R];

// A mark's outline as capsules [a, b, radius]: the spacing checks measure
// these, so an x between two diagonal lines is judged by its arms, not by a
// circle around it.
function mv_capsules(m) = let(c=m[1])
    m[0]=="cross" ? let(a=(mv_cross-mvW)/2) [[c+[-a,-a],c+[a,a],mvW/2],[c+[-a,a],c+[a,-a],mvW/2]]
    : m[0]=="tee" ? let(n=[cos(m[4]+90),sin(m[4]+90)]*(mv_tee-mvW)/2) [[c-n,c+n,mvW/2]]
    : m[0]=="digit" ? [[c-[0,(mv_digit[1]-mv_digit[0])/2],c+[0,(mv_digit[1]-mv_digit[0])/2],mv_digit[0]/2]]
    : [[c,c,m[2]]];

function mv_segment_distance(q,a,b) = let(d=b-a, t=max(0,min(1,(d*d)==0 ? 0 : ((q-a)*d)/(d*d)))) norm(q-(a+t*d));
function mv_cross2(u,v) = u[0]*v[1]-u[1]*v[0];
function mv_segments_cross(a,b,c,d) = let(d1=mv_cross2(b-a,c-a), d2=mv_cross2(b-a,d-a), d3=mv_cross2(d-c,a-c), d4=mv_cross2(d-c,b-c))
    ((d1>0 && d2<0) || (d1<0 && d2>0)) && ((d3>0 && d4<0) || (d3<0 && d4>0));
function mv_segments_distance(a,b,c,d) = mv_segments_cross(a,b,c,d) ? 0 :
    min(mv_segment_distance(a,c,d),mv_segment_distance(b,c,d),mv_segment_distance(c,a,b),mv_segment_distance(d,a,b));
// Clear space between two capsules.
function mv_clear(p,q) = mv_segments_distance(p[0],p[1],q[0],q[1])-p[2]-q[2];
function mv_marks_clear(s,t) = min([for(p=s[5], q=t[5]) mv_clear(p,q)]);
// True when every mark keeps one gap from every other mark and from every
// line it is not on, slides show a shaft, and an area frame clears its marks.
function mv_fits(f,p) = let(L=mv_layout(f,p), S=L[0], lines=L[1], frame=L[2], n=len(S))
    len([for(i=[0:n-1]) for(j=[0:n-1]) if(j>i && !(S[i][0]=="head" && S[j][0]=="head" && S[i][3]==S[j][3])
        && mv_marks_clear(S[i],S[j]) < mvG) 1])==0
    && len([for(s=S, l=lines) if(s[3]!=-1 && s[3]!=l[2] && min([for(c=s[5]) mv_clear(c,[l[0],l[1],mvW/2])]) < mvG) 1])==0
    && len([for(l=lines) if(l[3] < 2*mvW) 1])==0
    && (frame==0 || (frame-mvW/2 >= mv_piece/2+mvG
        && len([for(s=S) if(s[3]!=-1 && abs(max(abs(s[1][0]),abs(s[1][1]))-frame) < s[2]+mvW/2+mvG) 1])==0));
function mv_bisect(f,a,b,n) = n==0 ? b : let(m=(a+b)/2) mv_fits(f,m) ? mv_bisect(f,a,m,n-1) : mv_bisect(f,m,b,n-1);
// The smallest printable pitch at or above a starting size.
function mv_solve(f,start) = mv_fits(f,start) ? start : mv_bisect(f,start,start+40*mvW,24);
function mv_box(f,p) = let(L=mv_layout(f,p), frame=L[2],
    pts=concat([for(s=L[0], c=s[5]) each [[c[0],c[2]],[c[1],c[2]]]], [for(l=L[1]) each [[l[0],mvW/2],[l[1],mvW/2]]],
        frame>0 ? [[[frame,frame],mvW/2],[[-frame,-frame],mvW/2]] : []))
    [[min([for(q=pts) q[0][0]-q[1]]), min([for(q=pts) q[0][1]-q[1]])],
     [max([for(q=pts) q[0][0]+q[1]]), max([for(q=pts) q[0][1]+q[1]])]];

// Solved once per face. The smallest diagram sets how far automatic character
// sizes shrink; the drawn diagram fills about one character's space when the
// face has room, and a Glyph Size above 1 enlarges it, never below printable.
mv_front_ok = has_moves(true) && mv_grid_ok(true);
mv_back_ok = has_moves(false) && mv_grid_ok(false);
mv_front_min_pitch = mv_front_ok ? mv_solve(true,mvW) : 0;
mv_back_min_pitch = mv_back_ok ? mv_solve(false,mvW) : 0;
mv_front_min_size = mv_front_ok ? let(b=mv_box(true,mv_front_min_pitch)) b[1]-b[0] : [0,0];
mv_back_min_size = mv_back_ok ? let(b=mv_box(false,mv_back_min_pitch)) b[1]-b[0] : [0,0];
function mv_min_height(f) = (f ? mv_front_min_size : mv_back_min_size)[1];
function mv_glyph_size(f) = max(1,entry(f?Front_Glyph_Size:effective_Back_Glyph_Size,diagram_slot(f),1));
// Spreading the marks further apart only widens gaps, so scaling up the
// smallest printable pitch stays printable. The diagram grows toward about one
// character's size, but only into face length the characters leave free.
function mv_drawn_pitch(f) = Move_Pitch>0 ? Move_Pitch/Model_Scale : let(p=f ? mv_front_min_pitch : mv_back_min_pitch,
    size=f ? mv_front_min_size : mv_back_min_size,
    letters=len(chars(f))*char_spacing(f)+(char_spacing(f)-font_size(f)),
    room=(safe_length(f)*mv_fill-letters)/size[1])
    p*max(1,min(1.2*font_size(f)/max(size),room))*mv_glyph_size(f);
mv_front_pitch = mv_front_ok ? mv_drawn_pitch(true) : 0;
mv_back_pitch = mv_back_ok ? mv_drawn_pitch(false) : 0;
mv_front_box = mv_front_ok ? mv_box(true,mv_front_pitch) : [[0,0],[0,0]];
mv_back_box = mv_back_ok ? mv_box(false,mv_back_pitch) : [[0,0],[0,0]];
function mv_pitch(f) = f ? mv_front_pitch : mv_back_pitch;
function mv_box_of(f) = f ? mv_front_box : mv_back_box;
function mv_box_size(f) = mv_box_of(f)[1]-mv_box_of(f)[0];

module mv_line(a,b) { hull() { translate(a) circle(d=mvW); translate(b) circle(d=mvW); } }
module mv_head_shape() {
    hull() { translate([-mvW/2,0]) circle(d=mvW);
        translate([-mv_head,mv_head/2-mvW/2]) circle(d=mvW); translate([-mv_head,-mv_head/2+mvW/2]) circle(d=mvW); }
}
module mv_digit_shape(d) {
    w=mv_digit[0]; h=mv_digit[1]; i=mvW/2;
    // Segment ends, inset by half a stroke: middle, upper left, lower left,
    // bottom, lower right, upper right, top.
    ends=[[[i,h/2],[w-i,h/2]],[[i,h/2],[i,h-i]],[[i,i],[i,h/2]],[[i,i],[w-i,i]],
          [[w-i,i],[w-i,h/2]],[[w-i,h/2],[w-i,h-i]],[[i,h-i],[w-i,h-i]]];
    lit=[[],[],[6,5,0,2,3],[6,5,0,4,3],[1,0,5,4],[6,1,0,4,3],[6,1,2,3,4,0],[6,5,4]][d];
    translate([-w/2,-h/2]) for(k=lit) mv_line(ends[k][0],ends[k][1]);
}
module move_diagram(f) {
    L=mv_layout(f,mv_pitch(f));
    box=mv_box_of(f);
    // Center the drawn diagram in its slot.
    translate(-(box[0]+box[1])/2) {
        s=mv_piece;
        polygon([[0,0.62*s],[0.36*s,0.42*s],[0.5*s,-0.5*s],[-0.5*s,-0.5*s],[-0.36*s,0.42*s]]);
        for(l=L[1]) mv_line(l[0],l[1]);
        for(m=L[0]) {
            if(m[0]=="dot") translate(m[1]) circle(d=mv_dot);
            if(m[0]=="ring") translate(m[1]) difference() { circle(d=mv_ring); circle(d=mvG); }
            if(m[0]=="cross") translate(m[1]) for(a=[45,-45]) rotate(a)
                mv_line([-(mv_cross-mvW)/2*sqrt(2),0],[(mv_cross-mvW)/2*sqrt(2),0]);
            if(m[0]=="head") translate(m[4][0]) rotate(m[4][1]) mv_head_shape();
            if(m[0]=="tee") translate(m[1]) rotate(m[4]) mv_line([0,-(mv_tee-mvW)/2],[0,(mv_tee-mvW)/2]);
            if(m[0]=="digit") translate(m[1]) mv_digit_shape(m[4]);
        }
        if(L[2]>0) difference() { square(2*L[2]+mvW,center=true); square(2*L[2]-mvW,center=true); }
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
function raised_text_active() =
 (active(true) && style(true)=="Raised") ||
 (active(false) && style(false)=="Raised");
module recessed_piece_raw() {
 difference() {
  blank();
  for(f=[true,false]) if(style(f)=="Recessed") relief(f);
 }
}
module printed_geometry_raw() {
 // Avoid wrapping the usual all-recessed piece in a union with empty raised
 // children. Some OpenCSG drivers display that normalized tree as empty even
 // though exact CGAL export succeeds. The direct difference is equivalent and
 // appears immediately in automatic/F5 preview.
 if(raised_text_active()) union() {
  recessed_piece_raw();
  for(f=[true,false]) if(style(f)=="Raised") relief(f);
 }
 else recessed_piece_raw();
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
 if(signature_active()) intersection() {
  blank();
  on_heel() translate([0,0,-Paint_Floor_Thickness])
   linear_extrude(height=Paint_Floor_Thickness+epsilon,convexity=20)
   signature_outline();
 }
}
module printed_piece_raw() {
 // Likewise, do not emit an empty second child when the signature is off.
 if(signature_active()) difference() { printed_geometry_raw(); signature_cutter(); }
 else printed_geometry_raw();
}
// OpenSCAD 2021's OpenCSG preview can discard an otherwise valid polyhedron
// after subtracting transformed text on some graphics drivers. F5 therefore
// uses a display-only open-face shell. Its face skin gets a fast 2D cutout,
// while separate walls and a floor show the recess at its selected depth.
// F6 and every export mode still use printed_piece_raw().
function preview_mark_rgb() = let(
 body=material_rgb(0), luminance=0.299*body[0]+0.587*body[1]+0.114*body[2])
 luminance>0.45 ? [0.035,0.035,0.035,1] : [0.88,0.88,0.88,1];
function preview_wall_rgb() = let(body=material_rgb(0),mark=preview_mark_rgb())
 [(2*body[0]+mark[0])/3,(2*body[1]+mark[1])/3,
  (2*body[2]+mark[2])/3,1];
function recessed_preview_active(f) = active(f) && style(f)=="Recessed";
module preview_opening(f) {
 r=min(Text_Edge_Radius,depth(f)/2);
 if(r==0) inscription(f);
 else rounded_outline(f,r,r);
}
module preview_floor_outline(f) {
 r=min(Text_Edge_Radius,depth(f)/2);
 if(r==0) inscription(f);
 else rounded_outline(f,r,0);
}
module preview_body_shell() {
 omit_back=recessed_preview_active(false);
 omit_front=recessed_preview_active(true);
 omit_heel=signature_active();
 if(!omit_back && !omit_front && !omit_heel) blank();
 else if(has_bezel)
  polyhedron(
   points=bezel_vertices,
   faces=[for(i=[0:len(bezel_faces)-1],triangle=triangulate(bezel_faces[i]))
    if(!(omit_back && i==0) && !(omit_front && i==len(bezel_faces)-1)
       && !(omit_heel && i==6))
     [triangle[2],triangle[1],triangle[0]]],convexity=10);
 else
  polyhedron(
   points=plain_vertices,
   faces=[for(i=[0:len(plain_faces)-1],triangle=triangulate(plain_faces[i]))
    if(!(omit_back && i==0) && !(omit_front && i==len(plain_faces)-1)
       && !(omit_heel && i==1))
     [triangle[2],triangle[1],triangle[0]]],convexity=10);
}
module preview_face_skin(f) {
 if(recessed_preview_active(f)) on_face(f)
  translate([0,0,-epsilon/2]) linear_extrude(height=epsilon/2,convexity=20)
   difference() { flat_face(f); preview_opening(f); }
}
module preview_recess_wall(f) {
 if(recessed_preview_active(f)) on_face(f) translate([0,0,-depth(f)])
  linear_extrude(height=depth(f),convexity=20)
   difference() {
    offset(delta=epsilon/2) preview_opening(f);
    offset(delta=-epsilon/2) preview_opening(f);
   }
}
module preview_heel_skin() {
 if(signature_active()) on_heel() translate([0,0,-epsilon/2])
  linear_extrude(height=epsilon/2,convexity=20)
   difference() {
    translate([-Base_Width/2,-Rear_Thickness/2+(has_bezel?Bevel_Depth:0)])
     square([Base_Width,Rear_Thickness-2*(has_bezel?Bevel_Depth:0)]);
    signature_outline();
   }
}
module preview_signature_wall() {
 if(signature_active()) on_heel() translate([0,0,-Signature_Depth])
  linear_extrude(height=Signature_Depth,convexity=20)
   difference() {
    offset(delta=epsilon/2) signature_outline();
    offset(delta=-epsilon/2) signature_outline();
   }
}
module print_preview(show_colors=true) {
 color(material_rgb(0)) preview_body_shell();
 color(material_rgb(0)) preview_face_skin(true);
 color(material_rgb(0)) preview_face_skin(false);
 color(material_rgb(0)) preview_heel_skin();
 if(Text_Color_Treatment!="Flush filled") {
  color(Text_Color_Treatment=="Painted grooves" ? material_rgb(1) : preview_wall_rgb())
   preview_recess_wall(true);
  color(Text_Color_Treatment=="Painted grooves" ? material_rgb(2) : preview_wall_rgb())
   preview_recess_wall(false);
  color(Text_Color_Treatment=="Painted grooves" ? material_rgb(3) : preview_wall_rgb())
   preview_signature_wall();
 }
 if(show_colors) {
  color(material_rgb(1)) preview_face_color(true);
  color(material_rgb(2)) preview_face_color(false);
  color(material_rgb(3)) preview_signature_color();
 }
}
module printed_piece() {
 if($preview) print_preview();
 else color(material_rgb(0)) printed_piece_raw();
}
module signature_inspection() {
 assert($preview,"Inspection is F5-only. Select Model before F6 / STL export.");
 color(material_rgb(0)) linear_extrude(height=0.1) square([Base_Width,Rear_Thickness],center=true);
 if(signature_active()) {
  color(material_rgb(3)) translate([0,0,0.12]) linear_extrude(height=0.02) signature_outline();
  color([1,0,0,1]) translate([0,0,0.15]) linear_extrude(height=0.02) difference() { signature_raw(); signature_safe(); }
 }
 if(Show_Layout_Guides) color([0.1,0.5,0.9,0.65]) translate([0,0,0.11]) linear_extrude(height=0.005)
 difference() { signature_safe(); offset(delta=-0.08) signature_safe(); }
}
// Parts are complementary sub-volumes of one selected MODEL design. Face only
// assigns material directly behind the exposed inscription surface; Painted
// grooves can also extend it beside a recessed wall. These backings remain
// inside printable geometry and never add a coating on top of the model.
module color_inlay_raw(f) {
 if(active(f)) intersection() {
  blank();
  on_face(f) translate([0,0,-Paint_Floor_Thickness])
   linear_extrude(height=Paint_Floor_Thickness+epsilon,convexity=20)
   inscription(f);
 }
}
module color_inlay(f) {
 if(active(f)) difference() {
  color_inlay_raw(f);
  if(!f) color_inlay_raw(true);
  signature_inlay();
 }
}
// A printable surface color cannot be zero-thickness. Face only therefore
// assigns a closed 0.8 mm supporting region immediately behind the visible
// recessed floor, without coloring the groove walls. Raised lettering uses
// the selected material through the relief and the same inward backing.
module face_only_volume(f) {
 d=depth(f);
 if(style(f)=="Raised")
  on_face(f) translate([0,0,-Paint_Floor_Thickness])
   linear_extrude(height=d+Paint_Floor_Thickness+epsilon,convexity=20)
   offset(delta=epsilon/2) inscription(f);
 else
  on_face(f) translate([0,0,-d-Paint_Floor_Thickness])
   linear_extrude(height=Paint_Floor_Thickness+epsilon,convexity=20)
   offset(delta=epsilon/2) inscription(f);
}
// Sharp-edged Face only designs can be partitioned directly. This avoids
// reconstructing and intersecting the finished piece for every material.
// Rounded or edge-adjacent designs retain the complementary fallback below.
function fast_face_only_path() = Text_Edge_Radius==0
 && Text_Margin>Paint_Floor_Thickness*max(front_slope,back_slope)+epsilon
 && (!signature_active() || Signature_Margin>
     Paint_Floor_Thickness*max(tan(90-A),front_slope,back_slope)+epsilon);
module fast_face_only_volume(f) {
 if(active(f)) on_face(f)
  translate([0,0,style(f)=="Raised" ? -Paint_Floor_Thickness
                                    : -depth(f)-Paint_Floor_Thickness])
  linear_extrude(height=Paint_Floor_Thickness+
                        (style(f)=="Raised" ? depth(f) : 0),convexity=20)
  inscription(f);
}
module fast_face_only_cutter(f) {
 if(active(f)) on_face(f)
  translate([0,0,style(f)=="Raised" ? -Paint_Floor_Thickness
                                    : -depth(f)-Paint_Floor_Thickness])
  linear_extrude(height=Paint_Floor_Thickness+depth(f)+epsilon,convexity=20)
  inscription(f);
}
module fast_face_only_signature_volume() {
 if(signature_active()) on_heel() translate([0,0,-Signature_Depth-Paint_Floor_Thickness])
  linear_extrude(height=Paint_Floor_Thickness,convexity=20) signature_outline();
}
module fast_face_only_signature_cutter() {
 if(signature_active()) on_heel() translate([0,0,-Signature_Depth-Paint_Floor_Thickness])
  linear_extrude(height=Signature_Depth+Paint_Floor_Thickness+epsilon,convexity=20) signature_outline();
}
module face_only_region_raw(f) {
 if(active(f)) difference() {
  if(style(f)=="Raised") intersection() {
   union() { blank(); relief(f); }
   face_only_volume(f);
  }
  else if(style(f)=="Recessed") intersection() { blank(); face_only_volume(f); }
  for(g=[true,false]) if(style(g)=="Recessed") relief(g);
  signature_cutter();
 }
}
module face_only_region(f) {
 if(fast_face_only_path()) difference() {
  fast_face_only_volume(f);
  if(!f) fast_face_only_volume(true);
  fast_face_only_signature_volume();
 }
 else if(active(f)) difference() {
  face_only_region_raw(f);
  if(!f) face_only_region_raw(true);
  face_only_signature_region();
 }
}
module face_only_signature_region() {
 if(fast_face_only_path()) fast_face_only_signature_volume();
 else if(signature_active()) difference() {
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
 if(fast_face_only_path()) difference() {
  union() {
   blank();
   for(f=[true,false]) if(active(f) && style(f)=="Raised") relief(f);
  }
  fast_face_only_cutter(true);
  fast_face_only_cutter(false);
  fast_face_only_signature_cutter();
 } else difference() {
  printed_piece();
  face_only_region(true);
  face_only_region(false);
  face_only_signature_region();
 }
}
module paint_volume(f) {
 on_face(f) translate([0,0,-depth(f)-Paint_Floor_Thickness])
  linear_extrude(height=depth(f)+Paint_Floor_Thickness-Paint_Top_Lip,convexity=20)
  offset(delta=Paint_Wall_Thickness) inscription(f);
}
module painted_face_region_raw(f) {
 if(active(f)) {
  if(style(f)=="Raised")
   face_only_region_raw(f);
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
 difference() { blank(); color_inlay(true); color_inlay(false); signature_inlay(); }
}
// Material preview surfaces are shared by Model. Exact closed complementary
// volumes remain available in the hidden modes used by the exporter.
module preview_face_color(f) {
 if(active(f)) {
  if(style(f)=="Raised") relief(f);
  else if(Text_Color_Treatment=="Flush filled")
   on_face(f) translate([0,0,0])
    linear_extrude(height=epsilon/2,convexity=20) preview_opening(f);
  else
   on_face(f) translate([0,0,-depth(f)])
    linear_extrude(height=epsilon/2,convexity=20)
    offset(delta=Text_Color_Treatment=="Painted grooves" ? Paint_Wall_Thickness : 0)
    preview_floor_outline(f);
 }
}
module preview_signature_color() {
 if(signature_active())
  on_heel() translate([0,0,
   Text_Color_Treatment=="Flush filled" ? 0 : -Signature_Depth])
   linear_extrude(height=epsilon/2,convexity=20)
   offset(delta=Text_Color_Treatment=="Painted grooves" ? Paint_Wall_Thickness : 0)
   signature_outline();
}
module color_output() {
 // F6 implicitly unions top-level children, destroying material separation and
 // risking CGAL failures at the exactly touching body/color interfaces.
 assert(Output_Mode!="Color assembly" || $preview,
   "Color assembly is exporter-internal. Return to Model; use F6 for one STL or komascad.py export for multipart color 3MF.");
 if(Output_Mode=="Color assembly") {
  print_preview(true);
 } else if(Text_Color_Treatment=="Flush filled") {
   if(Output_Mode=="Color body")
    color(material_rgb(0)) render(convexity=30) flush_body_region();
   if(Output_Mode=="Color front")
    color(material_rgb(1)) render(convexity=30) color_inlay(true);
   if(Output_Mode=="Color back")
    color(material_rgb(2)) render(convexity=30) color_inlay(false);
   if(Output_Mode=="Color signature")
    color(material_rgb(3)) render(convexity=30) signature_inlay();
 } else if(Text_Color_Treatment=="Face only") {
   if(Output_Mode=="Color body")
    color(material_rgb(0)) render(convexity=30) face_only_body_region();
   if(Output_Mode=="Color front")
    color(material_rgb(1)) render(convexity=30) face_only_region(true);
   if(Output_Mode=="Color back")
    color(material_rgb(2)) render(convexity=30) face_only_region(false);
   if(Output_Mode=="Color signature")
    color(material_rgb(3)) render(convexity=30) face_only_signature_region();
 } else {
   if(Output_Mode=="Color body")
    color(material_rgb(0)) render(convexity=30) painted_body_region();
   if(Output_Mode=="Color front")
    color(material_rgb(1)) render(convexity=30) painted_face_region(true);
   if(Output_Mode=="Color back")
    color(material_rgb(2)) render(convexity=30) painted_face_region(false);
   if(Output_Mode=="Color signature")
    color(material_rgb(3)) render(convexity=30) painted_signature_region();
 }
}
// Inspect is deliberately blocked at F6/export: the separate colors are not print geometry.
module inspection(f) {
    assert($preview,"Inspection is F5-only. Select Model or Blank before F6 / STL export.");
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
    assert($preview,"Inspect pawn circle is F5-only. Select Model to export a single piece.");
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
// --- Printability -------------------------------------------------------------
// A stroke thinner than one printed line disappears under a morphological
// opening (shrink by half a line, grow back); a gap narrower than one line
// fills under a closing (grow, shrink back). The exporter measures the area
// of each against the lettering; the bundled sets lose at most about 2% to
// thin strokes and 4% to narrow gaps, and print cleanly.
printability_modes = ["Printability front ink","Printability front thin","Printability front gaps",
                      "Printability back ink","Printability back thin","Printability back gaps"];
function print_line() = Print_Line_Width/Model_Scale;
// Characters only: diagrams are built from Move Stroke and Move Gap, which
// are at least one printed line, and the wedges where their lines meet would
// read as gaps.
module letters(f) { intersection() { raw_inscription(f,false); safe_face(f); } }
module printability_layer(f,layer) {
    if(active(f) && len(chars(f))>0) {
        if(layer==0) letters(f);
        if(layer==1) difference() { letters(f); offset(r=print_line()/2) offset(r=-print_line()/2) letters(f); }
        if(layer==2) difference() { offset(r=-print_line()/2) offset(r=print_line()/2) letters(f); letters(f); }
    }
}
module printability_inspection() {
    assert($preview,"Inspection is F5-only. Select Model before F6 / STL export.");
    for(f=[true,false]) if(active(f)) translate([(f ? -0.6 : 0.6)*Base_Width,0,0]) {
        color(material_rgb(0)) linear_extrude(height=0.1) flat_face(f);
        color(ink(f)) translate([0,0,0.12]) linear_extrude(height=0.02) inscription(f);
        color([1,0.85,0,1]) translate([0,0,0.16]) linear_extrude(height=0.02) printability_layer(f,1);
        color([0.1,0.6,1,1]) translate([0,0,0.16]) linear_extrude(height=0.02) printability_layer(f,2);
    }
    echo("Inspect printability: front left, back right. Yellow strokes are thinner than Print Line Width and blue gaps narrower; both are lost in printing.");
}
module oriented_piece() {
    if(Print_Orientation=="Upright")
        translate([0,Rear_Thickness,0]) rotate([90,0,0]) children();
    else if(Print_Orientation=="Front face down")
        // Turn the piece over about its heel-to-point axis, level the front face, and lift it onto the bed.
        translate([0,0,Rear_Thickness*cos(atan(front_slope))]) rotate([-atan(front_slope),0,0]) rotate([0,180,0]) children();
    else if(Print_Orientation=="Back face down")
        rotate([-atan(back_slope),0,0]) children();
    else children();
}
// A diagram never shrinks below printable, so a face that cannot hold it and
// its characters stops here. Whether the characters themselves print is
// measured: see Inspect printability.
for(f=[true,false]) if(has_moves(f) && active(f)) let(face=f?"Front":"Back",
    ys=[for(q=safe_outline) q[1]/cosine(f)], need=stack_height(f)) {
 assert(Move_Pitch==0 || Move_Pitch/Model_Scale>=(f ? mv_front_min_pitch : mv_back_min_pitch)-1e-6,
  str(face," Moves need at least ",(f ? mv_front_min_pitch : mv_back_min_pitch)*Model_Scale,
      " mm between squares to print; Move Pitch is ",Move_Pitch," mm."));
 assert(center_y(f)-need/2>=min(ys)-0.01 && center_y(f)+need/2<=max(ys)+0.01,
  str(face," characters and movement diagram need ",need*Model_Scale," mm of face length; the face has ",
      (max(ys)-min(ys))*Model_Scale," mm. Raise Model Scale or use fewer characters."));
 // Drawn pitch and size, then the smallest printable ones, in final mm; move-editor.html shows the latter.
 echo("KOMASCAD_MOVES", face, mv_pitch(f)*Model_Scale, mv_box_size(f)*Model_Scale,
  (f ? mv_front_min_pitch : mv_back_min_pitch)*Model_Scale, (f ? mv_front_min_size : mv_back_min_size)*Model_Scale);
}
for(f=[true,false]) if(slots(f)>0) {
    echo(f?"Front resolved size / spacing / center:":"Back resolved size / spacing / center:",font_size(f),char_spacing(f),center_y(f));
    if(Text_Edge_Radius>depth(f)/2) echo("NOTE: text radius capped at half relief depth.");
}
if(signature_active()) echo("Signature is on the heel (bed-facing in Upright). Check Inspect signature, then check the first layers in your slicer.");
if(model_mode && $preview)
 echo("KOMASCAD MODEL: live geometry and selected materials; F6 makes one STL, the Python exporter makes the color 3MF.");
if(model_mode && !$preview)
 echo("Check both F5 Inspect views for red overflow and slicer paths for fine strokes before printing.");
if(!Protect_Face_Edges) echo("CAUTION: edge protection disabled; lettering can breach edges or form detached raised fragments.");
if(Print_Orientation=="Back face down" && active(false) && model_mode) echo("CAUTION: reverse relief faces the bed. Upright is the base orientation for two-sided pieces.");
if(Print_Orientation=="Front face down" && active(true) && model_mode) echo("CAUTION: front relief faces the bed. Upright is the base orientation for two-sided pieces.");
if(color_mode) echo("INTERNAL 3MF PART MODE. Return to Model for editing. Treatment:",Text_Color_Treatment);
if(Export_Metadata && Output_Mode!="Color assembly")
 assert(false,"Export_Metadata is an internal switch; remove it from your saved preset to show geometry. The Python exporter sets it automatically.");
if(Export_Metadata) echo("KOMASCAD_FONTS", concat([for(f=[true,false]) if(active(f)) font(f)],signature_active() ? [signature_font()] : []));
if(Export_Metadata) echo("KOMASCAD_EXPORT", [for(role=[0:3]) [["body","front","back","signature"][role],material_name(role),material_rgb(role),role==0 ? true : role==3 ? signature_active() : active(role==1)]]);
if(!Export_Metadata)
scale([Model_Scale,Model_Scale,Model_Scale])
if(Output_Mode=="Inspect printability") printability_inspection();
else if(valid_choice(Output_Mode,printability_modes))
    let(k=search([Output_Mode],printability_modes)[0]) printability_layer(k<3,k%3);
else if(Output_Mode=="Inspect pawn circle") pawn_circle_inspection();
else if(Output_Mode=="Inspect signature") signature_inspection();
else if(Output_Mode=="Inspect front" || Output_Mode=="Inspect back") inspection(Output_Mode=="Inspect front");
else oriented_piece()
    if(Output_Mode=="Blank") color(material_rgb(0)) blank();
    else if(model_mode) printed_piece();
    else if(color_mode) color_output();

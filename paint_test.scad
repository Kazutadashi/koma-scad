// Paint-fill coupon. Units mm. Print face upward, no supports.
// Depths left to right: 0.4, 0.6, 0.8 mm. Each column also tests fine grooves.
// ASCII works without a Japanese font; replace with your densest actual kanji.
sample_text = "A";
font_name = "Liberation Sans:style=Bold";
depths = [0.4, 0.6, 0.8];
groove_widths = [0.3, 0.5, 0.7];
$fn = 48;
difference() {
    cube([60, 26, 3]);
    for (i=[0:2]) {
        translate([10+20*i, 16, 3-depths[i]])
            linear_extrude(height=depths[i]+0.02)
                text(sample_text, size=9, font=font_name,
                     halign="center", valign="center");
        for (j=[0:2])
            translate([4+20*i, 3+j*2, 3-depths[i]])
                cube([12, groove_widths[j], depths[i]+0.02]);
    }
}

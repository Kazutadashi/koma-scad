// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// Rounded slabs and rings for the ban, komadai and komabako. Include this file:
//     include <../lib/shapes.scad>
// Every shape starts at the origin and grows into +x, +y and +z.

// A rectangle with rounded corners. The radius is limited to half the shorter side.
module rounded_rectangle_2d(size, radius) {
    assert(min(size) > 0, "A rounded rectangle needs a positive width and depth.");
    assert(radius >= 0, "A corner radius cannot be negative.");
    corner = min(radius, min(size)/2);
    if (corner == 0) square(size);
    else translate([corner, corner]) offset(r=corner) square([size[0] - 2*corner, size[1] - 2*corner]);
}

// A slab with rounded vertical corners. size is [width, depth, height].
module rounded_slab(size, radius) {
    assert(size[2] > 0, "A rounded slab needs a positive height.");
    linear_extrude(size[2]) rounded_rectangle_2d([size[0], size[1]], radius);
}

// The band between a rounded rectangle and the same shape wall mm smaller on each side.
module rounded_ring_2d(size, wall, radius) {
    assert(wall > 0 && 2*wall < min(size), "The ring wall does not fit inside the ring.");
    difference() {
        rounded_rectangle_2d(size, radius);
        translate([wall, wall]) rounded_rectangle_2d([size[0] - 2*wall, size[1] - 2*wall], max(0, radius - wall));
    }
}

// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// The named filaments of every module. Include this file:
//     include <../lib/filaments.scad>
// A Customizer list of filaments must name these entries, and can add Custom.

// [name, [red, green, blue, opacity]], each channel from 0 to 1.
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

// The color of a named filament. Custom gives custom_rgba.
function filament_rgba(name, custom_rgba) =
    let(found = [for (entry = filament_palette) if (entry[0] == name) entry[1]])
    name == "Custom" ? custom_rgba
    : assert(len(found) == 1, str("Unknown filament: ", name)) found[0];

// SPDX-License-Identifier: MIT
// Copyright (c) 2026 KomaSCAD contributors. https://github.com/Kazutadashi/koma-scad
//
// Movement diagrams for KomaSCAD: read a move grid, find the smallest printable
// spacing, and draw the diagram in 2D.
//
// Set these three values before you include this file (all in model units):
//   mv_w         the thinnest line
//   mv_g         the smallest space between two marks
//   mv_min_head  the shortest arrowhead
//
// Then:
//   moves = mv_grid_moves("Front_Moves", ".#./#@#/.#.");   // read and check a grid
//   p = mv_solve(moves, mv_w);                             // the smallest pitch that fits
//   mv_draw(moves, p, mv_box(moves, p));                   // draw it, centered
//
// A grid shows the squares around the piece. Rows go from the point to the
// heel, with / between them; spaces are ignored. docs/move-diagrams.md lists
// the symbols. Every mark is built from mv_w and mv_g. The solver finds the
// smallest distance between squares (the "pitch") at which every mark keeps
// one gap from the others.
//
// move-editor.html has the same solver in JavaScript. Change both in the same
// way: tests/test_komascad.py checks that they agree.


// --- Mark sizes ---------------------------------------------------------------

mv_dot = 2*mv_w;                                 // o: a square the piece can move to
mv_ring = 2*mv_w + mv_g;                         // x: a square it jumps to; the hole is one gap
// !: igui, an upright "!": a wedge that narrows to one line, a gap, then a dot.
// [width, height, wedge length, dot]. Short, because it sits next to the piece mark.
mv_igui = [1.7*mv_w, 2.4*mv_w + mv_g + 1.4*mv_w, 2.4*mv_w, 1.4*mv_w];
mv_head = max(2.5*mv_w, mv_min_head);            // # and =: arrowhead length
mv_tee = 3.5*mv_w;                               // L: the crossbar near the end of a hook move
mv_hook_overrun = 1.5*mv_w;                      // L: how far the line goes past the crossbar
mv_piece = 3*mv_w;                               // @: the piece, a pentagon that points forward
mv_digit = [2*mv_w + mv_g, 3*mv_w + 2*mv_g];     // 3-7: a seven-segment number, [width, height]
mv_slide_past = 0.35;                            // squares from the last mark on a line to its arrowhead
// The pitch search: from the start up to mv_search_range lines more, in mv_search_steps halvings.
mv_search_range = 40;
mv_search_steps = 24;

mv_directions = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]];
mv_symbols = [".", "o", "x", "!", "#", "=", "L", "2", "3", "4", "5", "6", "7", "@"];


// --- Reading a grid -------------------------------------------------------------
// A move is [dx, dy, symbol]: a square dx to the right and dy forward of the @.

function move_offset(m) = [m[0], m[1]];
function move_symbol(m) = m[2];

function mv_in_list(x, list) = len([for (y = list) if (x == y) 1]) > 0;
function mv_without_spaces(s, i=0) =
    i >= len(s) ? "" : str(s[i] == " " ? "" : s[i], mv_without_spaces(s, i+1));
function mv_grid_rows(text) =
    let(g = mv_without_spaces(text), n = len(g),
        cuts = concat([-1], [for (i = [0:1:n-1]) if (g[i] == "/") i], [n]))
    [for (r = [0:len(cuts)-2]) [for (i = [0:1:n-1]) if (i > cuts[r] && i < cuts[r+1]) g[i]]];

// The moves of a grid. Stops with a message when the grid is wrong.
// (Ranges are written [0:1:n-1] so that they are empty when n is 0.)
function mv_grid_moves(name, grid) =
    let(rows = mv_grid_rows(grid),
        at = [for (r = [0:len(rows)-1], c = [0:1:len(rows[r])-1]) if (rows[r][c] == "@") [r, c]],
        moves = len(at) != 1 ? [] :
            [for (r = [0:len(rows)-1], c = [0:1:len(rows[r])-1]) if (!mv_in_list(rows[r][c], [".", "@"]))
                [c - at[0][1], at[0][0] - r, rows[r][c]]])
    assert(len([for (row = rows, c = row) if (!mv_in_list(c, mv_symbols)) 1]) == 0,
        str(name, " may only use . o x ! # = L 2-7 @ and /: ", grid))
    assert(len(at) == 1, str(name, " needs exactly one @ for the piece: ", grid))
    assert(len([for (row = rows) if (len(row) != len(rows[0])) 1]) == 0,
        str(name, " rows must all be the same length: ", grid))
    assert(len([for (m = moves) if (mv_is_direction(move_symbol(m)) && !mv_on_line(m)) 1]) == 0,
        str(name, ": # = and L must be straight or diagonal from the @: ", grid))
    assert(len([for (m = moves) if ((move_symbol(m) == "!" || mv_is_digit(move_symbol(m)))
                                    && mv_distance(m) != 1) 1]) == 0,
        str(name, ": ! and 2-7 go next to the @: ", grid))
    moves;


// --- Rules for the marks, as Wikipedia's diagrams use them ----------------------

function mv_on_line(m) = m[0] == 0 || m[1] == 0 || abs(m[0]) == abs(m[1]);  // straight or diagonal
function mv_distance(m) = max(abs(m[0]), abs(m[1]));                        // squares from the @
function mv_unit(m) = [sign(m[0]), sign(m[1])];
function mv_ray(u) = [for (i = [0:7]) if (mv_directions[i] == u) i][0];     // line id 0-7
function mv_same_line(k, m) = mv_on_line(k) && mv_on_line(m) && mv_unit(k) == mv_unit(m);
function mv_is_direction(c) = c == "#" || c == "=" || c == "L";
function mv_is_digit(c) = mv_in_list(c, ["2", "3", "4", "5", "6", "7"]);
function mv_digit_value(c) = ord(c) - ord("0");
function mv_stops(c) = c == "o" || c == "x" || c == "!";
// A mark that marks a square: a stop, or a range number.
function mv_marks_square(c) = mv_stops(c) || mv_is_digit(c);

// A grid that reaches every square within two steps is a lion. One frame
// replaces 24 marks that could not print apart.
function mv_area(moves) =
    len([for (a = [-2:2], b = [-2:2]) if (max(abs(a), abs(b)) > 0
        && len([for (m = moves) if (move_offset(m) == [a, b] && mv_stops(move_symbol(m))) 1]) == 0) 1]) == 0;
function mv_visible(moves, area) =
    [for (m = moves) if (!(area && mv_distance(m) <= 2 && mv_stops(move_symbol(m)))) m];

// The farthest square marked on the line of m. A "2" range counts as 2.
function mv_ray_reach(vis, m) =
    max(concat([1], [for (k = vis) if (mv_same_line(k, m) && mv_marks_square(move_symbol(k)))
        mv_is_digit(move_symbol(k)) ? 2 : mv_distance(k)]));
// A step or slide beyond a jump on its line continues from the jump.
// Returns the squares to that jump, or 0.
function mv_slide_from(vis, m) =
    !mv_on_line(m) ? 0 :
    let(rings = [for (k = vis) if (move_symbol(k) == "x" && mv_same_line(k, m) && mv_distance(k) < mv_distance(m))
                     mv_distance(k)])
    len(rings) > 0 ? max(rings) : 0;
// True when a step or slide continues from jump k.
function mv_starts_slide(vis, k) =
    len([for (m = vis) if ((mv_is_direction(move_symbol(m)) || move_symbol(m) == "o") && mv_same_line(m, k)
        && mv_slide_from(vis, m) == mv_distance(k)) 1]) > 0;

function mv_head_length(c) = c == "L" ? mv_hook_overrun + mv_w/2 : c == "=" ? 2*mv_head + mv_g : mv_head;
// Half the size of the "!" and of a digit, in direction nu.
function mv_igui_extent(nu) = abs(nu[0])*mv_igui[0]/2 + abs(nu[1])*mv_igui[1]/2;
function mv_digit_extent(nu) = abs(nu[0])*mv_digit[0]/2 + abs(nu[1])*mv_digit[1]/2;
// Distance from the piece to the far edge of the mark of move k, along its line.
function mv_far_edge(k, p) =
    let(u = mv_unit(k), nu = u/norm(u), c = move_symbol(k))
      c == "o" ? mv_distance(k)*norm(u)*p + mv_dot/2
    : c == "x" ? mv_distance(k)*norm(u)*p + mv_ring/2
    : c == "!" ? norm(u)*p + mv_igui_extent(nu)
    : mv_digit_value(c) == 2 ? 2*norm(u)*p + mv_dot/2
    : norm(u)*p + mv_w/2 + mv_g + 2*mv_digit_extent(nu);
// The arrowhead tip of slide m: mv_slide_past squares past the farthest mark on
// its line, and never nearer than that mark's edge + a gap + a two-line shaft + the head.
function mv_tip(vis, m, p) =
    let(u = mv_unit(m), nu = u/norm(u),
        edges = concat([mv_piece/2], [for (k = vis) if (mv_marks_square(move_symbol(k)) && mv_same_line(k, m))
            mv_far_edge(k, p)]))
    nu * max((max(mv_ray_reach(vis, m), mv_slide_from(vis, m) + 1) + mv_slide_past)*p*norm(u),
             max(edges) + mv_g + mv_w/2 + 2*mv_w + mv_head_length(move_symbol(m)));
// A point on direction nu, one gap clear of the piece mark.
function mv_clear_of_piece(nu) = nu*(mv_piece/2 + mv_g + mv_w/2);
// The start of the line of m: at the jump it continues from, else past an igui
// on its line (as Wikipedia draws it), else clear of the piece mark.
function mv_line_start(vis, m, p) =
    let(u = mv_unit(m), nu = u/norm(u), s = mv_slide_from(vis, m),
        igui = mv_on_line(m) && len([for (k = vis) if (move_symbol(k) == "!" && mv_same_line(k, m)
            && mv_distance(k) < mv_distance(m)) 1]) > 0)
      s > 0 ? u*s*p + nu*mv_ring/2
    : igui ? u*p + nu*(mv_igui_extent(nu) + mv_g + mv_w/2)
    : mv_clear_of_piece(nu);


// --- Layout at pitch p ------------------------------------------------------------
// A layout is [marks, lines, frame]. Read its parts with these functions.
function layout_marks(L) = L[0];
function layout_lines(L) = L[1];
function layout_frame(L) = L[2];   // half-size of the lion frame, or 0

// A mark is [kind, center, spacing radius, line id, drawing data, capsules].
function mark_kind(m) = m[0];
function mark_center(m) = m[1];
function mark_radius(m) = m[2];
function mark_line(m) = m[3];
function mark_data(m) = m[4];
function mark_capsules(m) = m[5];

// A line is [start, end, line id, visible shaft length, dashed].
function line_start(l) = l[0];
function line_end(l) = l[1];
function line_id(l) = l[2];
function line_shaft(l) = l[3];
function line_dashed(l) = l[4];

// Line ids: 0-7 are the eight lines from the piece. A mark off those lines gets
// its own id, so that it is checked against all lines. The piece is on every line.
mv_piece_line = -1;
function mv_own_line(i) = 100 + i;
mv_no_shaft = 1e9;   // the shaft length of a line without an arrowhead: never too short

// The line id of visible move i.
function mv_line_of(vis, i) = mv_on_line(vis[i]) ? mv_ray(mv_unit(vis[i])) : mv_own_line(i);

// Marks: the piece, the stops, the range numbers and the line ends.
function mv_stop_marks(vis, p) =
    [for (i = [0:1:len(vis)-1]) let(m = vis[i], c = move_offset(m)*p, line = mv_line_of(vis, i))
        if (move_symbol(m) == "o") ["dot", c, mv_dot/2, line, 0]
        else if (move_symbol(m) == "!") ["igui", c, mv_igui[1]/2, line, 0]
        // A jump is on its line only when a step or slide continues from it.
        else if (move_symbol(m) == "x") ["ring", c, mv_ring/2, mv_starts_slide(vis, m) ? line : mv_own_line(i), 0]];

// "2" is two dots; 3 to 7 are numbers next to the piece.
function mv_range_marks(vis, p) =
    [for (m = vis) if (mv_is_digit(move_symbol(m)))
        let(u = mv_unit(m), nu = u/norm(u), d = mv_digit_value(move_symbol(m)))
        each (d == 2
            ? [["dot", u*p, mv_dot/2, mv_ray(u), 0], ["dot", 2*u*p, mv_dot/2, mv_ray(u), 0]]
            : [["digit", u*p + nu*(mv_w/2 + mv_g + mv_digit_extent(nu)), norm(mv_digit)/2, mv_ray(u), d]])];

// Arrowheads (# and =) and hook crossbars (L). A head's data is [tip, angle]. For
// the spacing checks, a head is a circle of radius 0.55 heads, 0.55 heads behind
// the tip: it covers the triangle. A fly (=) has a second head one gap behind.
function mv_end_marks(vis, p) =
    [for (m = vis) if (mv_is_direction(move_symbol(m)))
        let(u = mv_unit(m), nu = u/norm(u), tip = mv_tip(vis, m, p), angle = atan2(nu[1], nu[0]))
        each (move_symbol(m) == "L"
            ? [["tee", tip - nu*mv_hook_overrun, mv_tee/2, mv_ray(u), angle]]
            : concat([["head", tip - nu*0.55*mv_head, 0.55*mv_head, mv_ray(u), [tip, angle]]],
                move_symbol(m) == "=" ? [["head", tip - nu*(1.55*mv_head + mv_g), 0.55*mv_head, mv_ray(u),
                                          [tip - nu*(mv_head + mv_g), angle]]] : []))];

// Lines to the steps. An igui has no line: the piece captures there without moving.
function mv_step_lines(vis, p) =
    [for (i = [0:1:len(vis)-1]) let(m = vis[i]) if (move_symbol(m) == "o")
        let(d = move_offset(m))
        [mv_on_line(m) ? mv_line_start(vis, m, p) : mv_clear_of_piece(d/norm(d)), d*p,
         mv_line_of(vis, i), mv_no_shaft, false]];

// Lines to the range numbers.
function mv_range_lines(vis, p) =
    [for (m = vis) if (mv_is_digit(move_symbol(m))) let(u = mv_unit(m))
        let(reach = mv_digit_value(move_symbol(m)) == 2 ? 2 : 1)   // to the far dot, or to the number
        [mv_clear_of_piece(u/norm(u)), reach*u*p, mv_ray(u), mv_no_shaft, false]];

// Dashed leaders to the jumps: from the piece, or from the last mark before the jump on its line.
function mv_jump_lines(vis, p) =
    [for (i = [0:1:len(vis)-1]) let(m = vis[i]) if (move_symbol(m) == "x")
        let(d = move_offset(m), nu = d/norm(d),
            before = [for (k = vis) if (mv_stops(move_symbol(k)) && mv_same_line(k, m)
                                        && mv_distance(k) < mv_distance(m)) k],
            farthest = max(concat([0], [for (b = before) mv_distance(b)])),
            last = len(before) > 0 ? [for (k = before) if (mv_distance(k) == farthest) k][0] : undef,
            last_radius = last == undef ? 0
                : move_symbol(last) == "o" ? mv_dot/2 : move_symbol(last) == "x" ? mv_ring/2 : mv_igui_extent(nu),
            start = last == undef ? mv_clear_of_piece(nu) : move_offset(last)*p + nu*(last_radius + mv_g + mv_w/2),
            end = d*p - nu*(mv_ring/2 + mv_g + mv_w/2))
        if ((end - start)*nu > 0)
            [start, end, mv_starts_slide(vis, m) ? mv_line_of(vis, i) : mv_own_line(i), mv_no_shaft, true]];

// Lines of the slides, flies and hooks, up to the back of the arrowhead.
function mv_slide_lines(vis, p) =
    [for (m = vis) if (mv_is_direction(move_symbol(m)))
        let(u = mv_unit(m), nu = u/norm(u), tip = mv_tip(vis, m, p), start = mv_line_start(vis, m, p))
        [start, move_symbol(m) == "L" ? tip : tip - nu*0.5*mv_head, mv_ray(u),
         norm(tip - start) - mv_head_length(move_symbol(m)), false]];

function mv_layout(moves, p) =
    let(area = mv_area(moves),
        vis = mv_visible(moves, area),
        piece = ["piece", [0, 0], mv_piece/2, mv_piece_line, 0],
        marks = concat([piece], mv_stop_marks(vis, p), mv_range_marks(vis, p), mv_end_marks(vis, p)),
        lines = concat(mv_step_lines(vis, p), mv_range_lines(vis, p), mv_jump_lines(vis, p), mv_slide_lines(vis, p)))
    [[for (m = marks) concat(m, [mv_capsules(m)])], lines, area ? 2*p : 0];

// The outline of a mark as capsules [a, b, radius]. The spacing checks measure
// these, so a mark between two diagonal lines is judged by its real shape.
function mv_capsules(m) =
    let(c = mark_center(m))
      mark_kind(m) == "igui" ? let(w = mv_igui[0], h = mv_igui[1], bar = mv_igui[2], d = mv_igui[3])
        [[c + [0, h/2 - w/2], c + [0, h/2 - bar + w/2], w/2], [c + [0, -h/2 + d/2], c + [0, -h/2 + d/2], d/2]]
    : mark_kind(m) == "tee" ? let(n = [cos(mark_data(m) + 90), sin(mark_data(m) + 90)]*(mv_tee - mv_w)/2)
        [[c - n, c + n, mv_w/2]]
    : mark_kind(m) == "digit" ? let(h = (mv_digit[1] - mv_digit[0])/2)
        [[c - [0, h], c + [0, h], mv_digit[0]/2]]
    : [[c, c, mark_radius(m)]];


// --- Fit check ----------------------------------------------------------------------

function mv_point_segment(q, a, b) =
    let(d = b - a, t = max(0, min(1, (d*d) == 0 ? 0 : ((q - a)*d)/(d*d)))) norm(q - (a + t*d));
function mv_cross(u, v) = u[0]*v[1] - u[1]*v[0];
function mv_segments_cross(a, b, c, d) =
    let(d1 = mv_cross(b - a, c - a), d2 = mv_cross(b - a, d - a),
        d3 = mv_cross(d - c, a - c), d4 = mv_cross(d - c, b - c))
    ((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) && ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0));
function mv_segments_distance(a, b, c, d) =
    mv_segments_cross(a, b, c, d) ? 0
    : min(mv_point_segment(a, c, d), mv_point_segment(b, c, d), mv_point_segment(c, a, b), mv_point_segment(d, a, b));
// The space between two capsules.
function mv_clear(p, q) = mv_segments_distance(p[0], p[1], q[0], q[1]) - p[2] - q[2];
function mv_marks_clear(s, t) = min([for (p = mark_capsules(s), q = mark_capsules(t)) mv_clear(p, q)]);
function mv_line_capsule(l) = [line_start(l), line_end(l), mv_w/2];
// The two parts of a double arrowhead may touch.
function mv_same_head(s, t) = mark_kind(s) == "head" && mark_kind(t) == "head" && mark_line(s) == mark_line(t);

// True when every mark keeps one gap from every other mark and from every
// line it is not on, every slide shows a shaft, and a lion frame clears its marks.
function mv_fits(moves, p) =
    let(L = mv_layout(moves, p), S = layout_marks(L), lines = layout_lines(L), frame = layout_frame(L), n = len(S),
        tight = mv_g - 1e-6)
    len([for (i = [0:n-1], j = [0:n-1]) if (j > i && !mv_same_head(S[i], S[j])
        && mv_marks_clear(S[i], S[j]) < tight) 1]) == 0
    && len([for (s = S, l = lines) if (mark_line(s) != mv_piece_line && mark_line(s) != line_id(l)
        && min([for (c = mark_capsules(s)) mv_clear(c, mv_line_capsule(l))]) < tight) 1]) == 0
    && len([for (l = lines) if (line_shaft(l) < 2*mv_w - 1e-6) 1]) == 0
    && (frame == 0 || (frame - mv_w/2 >= mv_piece/2 + mv_g
        && len([for (s = S) if (mark_line(s) != mv_piece_line
            && abs(max(abs(mark_center(s)[0]), abs(mark_center(s)[1])) - frame)
               < mark_radius(s) + mv_w/2 + mv_g) 1]) == 0));

// The smallest pitch that fits, at or above start. Larger pitches only widen
// the gaps, so a bisection finds it.
function mv_bisect(moves, a, b, n) =
    n == 0 ? b : let(m = (a + b)/2) mv_fits(moves, m) ? mv_bisect(moves, a, m, n-1) : mv_bisect(moves, m, b, n-1);
function mv_solve(moves, start) =
    let(limit = start + mv_search_range*mv_w,
        p = mv_fits(moves, start) ? start : mv_bisect(moves, start, limit, mv_search_steps))
    assert(mv_fits(moves, p), "This move grid has no printable spacing. Bring its outer marks nearer the @.")
    p;

// [[min x, min y], [max x, max y]] of everything drawn at pitch p.
function mv_box(moves, p) =
    let(L = mv_layout(moves, p), frame = layout_frame(L),
        // Each point, with the radius drawn around it.
        points = concat(
            [for (s = layout_marks(L), c = mark_capsules(s)) each [[c[0], c[2]], [c[1], c[2]]]],
            [for (l = layout_lines(L)) each [[line_start(l), mv_w/2], [line_end(l), mv_w/2]]],
            frame > 0 ? [[[frame, frame], mv_w/2], [[-frame, -frame], mv_w/2]] : []))
    [[min([for (q = points) q[0][0] - q[1]]), min([for (q = points) q[0][1] - q[1]])],
     [max([for (q = points) q[0][0] + q[1]]), max([for (q = points) q[0][1] + q[1]])]];
function mv_size(box) = box[1] - box[0];


// --- Drawing ------------------------------------------------------------------------

module mv_line(a, b) { hull() { translate(a) circle(d=mv_w); translate(b) circle(d=mv_w); } }

// Dashes one line wide and two lines long, a gap apart, centered on the leader.
module mv_dashes(a, b) {
    length = norm(b - a);
    nu = (b - a)/length;
    period = 2*mv_w + mv_g;
    n = max(1, floor((length - mv_w)/period) + 1);
    start = max(0, (length - ((n - 1)*period + mv_w))/2);
    for (j = [0:n-1]) let(s = a + nu*(start + j*period)) mv_line(s, s + nu*min(mv_w, length));
}

// A pointed arrowhead, tip at the origin, pointing along +x. It is modelled
// sharp, so that the printed point stays crisp.
module mv_head_shape() { polygon([[0, 0], [-mv_head, mv_head/2], [-mv_head, -mv_head/2]]); }

// A square-ended bar from a to b.
module mv_bar(a, b) {
    d = b - a;
    n = [-d[1], d[0]]/norm(d)*mv_w/2;
    polygon([a + n, b + n, b - n, a - n]);
}

module mv_digit_shape(d) {
    w = mv_digit[0];
    h = mv_digit[1];
    i = mv_w/2;
    // Segments: middle, upper left, lower left, bottom, lower right, upper right, top.
    ends = [[[i, h/2], [w-i, h/2]], [[i, h/2], [i, h-i]], [[i, i], [i, h/2]], [[i, i], [w-i, i]],
            [[w-i, i], [w-i, h/2]], [[w-i, h/2], [w-i, h-i]], [[i, h-i], [w-i, h-i]]];
    lit = [[], [], [6,5,0,2,3], [6,5,0,4,3], [1,0,5,4], [6,1,0,4,3], [6,1,2,3,4,0], [6,5,4]][d];
    translate([-w/2, -h/2]) for (k = lit) mv_line(ends[k][0], ends[k][1]);
}

// The diagram of moves at pitch p, centered on the middle of box.
module mv_draw(moves, p, box) {
    L = mv_layout(moves, p);
    translate(-(box[0] + box[1])/2) {
        s = mv_piece;   // the piece mark: a small koma outline that points forward
        polygon([[0, 0.62*s], [0.36*s, 0.42*s], [0.5*s, -0.5*s], [-0.5*s, -0.5*s], [-0.36*s, 0.42*s]]);
        for (l = layout_lines(L))
            if (line_dashed(l)) mv_dashes(line_start(l), line_end(l));
            else mv_line(line_start(l), line_end(l));
        for (m = layout_marks(L)) {
            kind = mark_kind(m);
            if (kind == "dot") translate(mark_center(m)) circle(d=mv_dot);
            if (kind == "ring") translate(mark_center(m)) difference() { circle(d=mv_ring); circle(d=mv_g); }
            if (kind == "igui") translate(mark_center(m))
                let(w = mv_igui[0], h = mv_igui[1], bar = mv_igui[2], d = mv_igui[3]) {
                    polygon([[-w/2, h/2], [w/2, h/2], [mv_w/2, h/2 - bar], [-mv_w/2, h/2 - bar]]);
                    translate([0, -h/2 + d/2]) circle(d=d);
                }
            if (kind == "digit") translate(mark_center(m)) mv_digit_shape(mark_data(m));
            if (kind == "head") translate(mark_data(m)[0]) rotate(mark_data(m)[1]) mv_head_shape();
            if (kind == "tee") for (c = mark_capsules(m)) mv_bar(c[0], c[1]);
        }
        frame = layout_frame(L);
        if (frame > 0) difference() { square(2*frame + mv_w, center=true); square(2*frame - mv_w, center=true); }
    }
}

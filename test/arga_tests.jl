@testitem "ARGA: object extraction and rendering" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    g = [2 2 0 0;
         2 2 0 0;
         0 0 0 0;
         0 0 0 1]

    @test A.background_color(g) == 0

    objs = A.extract_objects(g)
    @test length(objs) == 2
    red = only(filter(o -> o.color == 2, objs))
    blue = only(filter(o -> o.color == 1, objs))
    @test Set(red.pixels) == Set([(1, 1), (1, 2), (2, 1), (2, 2)])
    @test Set(blue.pixels) == Set([(4, 4)])

    @test A.render(4, 4, 0, objs) == g

    # background inferred as most-common color when 0 is absent
    g2 = [3 3; 3 1]
    @test A.background_color(g2) == 3

    # 4-connectivity: diagonal same-color pixels are *not* merged
    g3 = [2 0; 0 2]
    objs3 = A.extract_objects(g3)
    @test length(objs3) == 2
end

@testitem "ARGA: scalar attributes and is_square/is_enclosed" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    square = A.ARGAObject([(1, 1), (1, 2), (2, 1), (2, 2)], 2)
    @test A.obj_size(square) == 4
    @test A.obj_width(square) == 2
    @test A.obj_height(square) == 2
    @test A.obj_row(square) == 1
    @test A.obj_column(square) == 1
    @test A.is_square(square)

    bar = A.ARGAObject([(1, 1), (1, 2), (1, 3)], 2)
    @test A.obj_width(bar) == 3
    @test A.obj_height(bar) == 1
    @test !A.is_square(bar)

    # a hollow 3x3 ring encloses its center
    ring = A.ARGAObject([(1, 1), (1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2), (3, 3)], 2)
    ctx = (objects = [ring], height = 5, width = 5, background = 0)
    @test A.is_enclosed(ring, ctx)

    # a filled 3x3 square has no interior hole
    filled = A.ARGAObject([(r, c) for r in 1:3 for c in 1:3], 2)
    ctx2 = (objects = [filled], height = 5, width = 5, background = 0)
    @test !A.is_enclosed(filled, ctx2)
end

@testitem "ARGA: neighbors and degree" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    a = A.ARGAObject([(1, 1)], 2)
    b = A.ARGAObject([(2, 2)], 3)   # diagonally touching a
    c = A.ARGAObject([(5, 5)], 4)   # far away

    ctx = (objects = [a, b, c], height = 10, width = 10, background = 0)
    @test Set(A.neighbors_of(a, ctx)) == Set([b])
    @test A.obj_degree(a, ctx) == 1
    @test A.obj_degree(c, ctx) == 0
end

@testitem "ARGA: move, move_max, extend" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    obj = A.ARGAObject([(1, 1), (1, 2)], 2)
    moved = A.move_pixels(obj, A.DOWN)
    @test Set(moved.pixels) == Set([(2, 1), (2, 2)])

    # move_max: slides until it would hit the wall (height=5)
    ctx = (objects = A.ARGAObject[], height = 5, width = 5, background = 0)
    far = A.move_max_pixels(obj, A.DOWN, A.ARGAObject[], ctx)
    @test Set(far.pixels) == Set([(5, 1), (5, 2)])

    # move_max: stops right before colliding with a blocker
    blocker = A.ARGAObject([(4, 1), (4, 2)], 3)
    blocked = A.move_max_pixels(obj, A.DOWN, [blocker], ctx)
    @test Set(blocked.pixels) == Set([(3, 1), (3, 2)])

    # extend without overlap: stops at the blocker, not into it
    single = A.ARGAObject([(1, 1)], 2)
    ext = A.extend_pixels(single, A.DOWN, false, [blocker], ctx)
    @test Set(ext.pixels) == Set([(1, 1), (2, 1), (3, 1)])

    # extend with overlap=true: only the grid edge stops it
    ext2 = A.extend_pixels(single, A.DOWN, true, [blocker], ctx)
    @test Set(ext2.pixels) == Set([(1, 1), (2, 1), (3, 1), (4, 1), (5, 1)])
end

@testitem "ARGA: rotate, flip, mirror" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # a single pixel is its own centroid, so rotation is always a no-op
    single = A.ARGAObject([(3, 3)], 2)
    @test A.rotate_pixels(single, 90).pixels == [(3, 3)]
    @test A.rotate_pixels(single, 270).pixels == [(3, 3)]

    # an L-shape: (1,1),(2,1),(2,2) rotated 90 deg clockwise about its centroid
    # (note: centroid is recomputed, floor-divided, before *each* 90-degree
    # step -- like ARCGraph.rotate_node -- so e.g. a 90-then-270 round trip
    # does *not* generally land back on the exact original pixels)
    L = A.ARGAObject([(1, 1), (2, 1), (2, 2)], 2)
    r90 = A.rotate_pixels(L, 90)
    @test Set(r90.pixels) == Set([(1, 0), (1, 1), (2, 0)])

    # a vertical domino rotated 90 deg becomes a horizontal one
    domino = A.ARGAObject([(1, 1), (2, 1)], 2)
    @test Set(A.rotate_pixels(domino, 90).pixels) == Set([(1, 0), (1, 1)])

    # flip is relative to the object's own bounding box
    bar = A.ARGAObject([(1, 1), (1, 2), (1, 3)], 2)  # 1x3 horizontal bar
    flipped_h = A.flip_pixels(bar, A.HORIZONTAL)
    @test Set(flipped_h.pixels) == Set([(1, 1), (1, 2), (1, 3)])  # symmetric, unchanged

    asym = A.ARGAObject([(1, 1), (1, 2)], 2)  # occupies cols 1-2 of row 1
    flipped = A.flip_pixels(asym, A.HORIZONTAL)
    @test Set(flipped.pixels) == Set([(1, 1), (1, 2)])  # still symmetric (2 cells)

    asym2 = A.ARGAObject([(1, 1), (1, 2), (2, 1)], 2)
    flipped2 = A.flip_pixels(asym2, A.HORIZONTAL)
    @test Set(flipped2.pixels) == Set([(1, 2), (1, 1), (2, 2)])

    # mirror is relative to the whole grid, not the object's own box
    ctx = (objects = A.ARGAObject[], height = 4, width = 4, background = 0)
    corner = A.ARGAObject([(1, 1)], 2)
    mirrored = A.mirror_pixels(corner, A.HORIZONTAL, ctx)
    @test Set(mirrored.pixels) == Set([(1, 4)])  # reflected across the grid's vertical centerline
end

@testitem "ARGA: add_border, fill_rectangle, hollow_rectangle" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    single = A.ARGAObject([(2, 2)], 2)
    border = A.add_border_pixels(single, 3, A.ARGAObject[])
    @test Set(border.pixels) == Set([
        (1, 1), (1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2), (3, 3),
    ])
    @test border.color == 3

    # an L-shaped object's bounding box has 1 missing cell to fill
    L = A.ARGAObject([(1, 1), (2, 1), (2, 2)], 2)
    fill = A.fill_rectangle_pixels(L, 4, false, A.ARGAObject[])
    @test fill !== nothing
    @test Set(fill.pixels) == Set([(1, 2)])
    @test fill.color == 4

    # a fully-filled object has nothing left to fill
    filled = A.ARGAObject([(r, c) for r in 1:2 for c in 1:2], 2)
    @test A.fill_rectangle_pixels(filled, 4, false, A.ARGAObject[]) === nothing

    # hollowing a filled 3x3 square leaves the border and exposes a 1-pixel interior
    sq = A.ARGAObject([(r, c) for r in 1:3 for c in 1:3], 2)
    (border_obj, extras) = A.hollow_rectangle_pixels(sq, 5)
    @test Set(border_obj.pixels) == Set([
        (1, 1), (1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2), (3, 3),
    ])
    @test length(extras) == 1
    @test Set(extras[1].pixels) == Set([(2, 2)])
    @test extras[1].color == 5

    # hollowing with the background color drops the interior entirely
    (_, extras_bg) = A.hollow_rectangle_pixels(sq, A.BLACK)
    @test isempty(extras_bg)
end

@testitem "ARGA: atoms and filters" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    red = A.ARGAObject([(1, 1), (1, 2)], A.RED)
    other = A.ARGAObject([(5, 5), (5, 6), (5, 7)], A.BLUE)
    ctx = (objects = [red, other], height = 10, width = 10, background = 0)

    @test A.eval_atom(A.atom_color(A.RED), red, ctx)
    @test !A.eval_atom(A.atom_color(A.BLUE), red, ctx)
    @test A.eval_atom(A.atom_size(2), red, ctx)
    @test A.eval_atom(A.atom_size(A.ARGA_MIN), red, ctx)   # red has the smaller size (2 < 3)
    @test A.eval_atom(A.atom_size(A.ARGA_MAX), other, ctx)
    @test A.eval_atom(A.atom_neighbor_color(A.BLUE), red, ctx) == false  # not actually touching
    @test A.eval_atom(A.atom_any_neighbor(), red, ctx) == false

    f = A.f_not(A.atom_color(A.RED))
    @test A.eval_filter(f, red, ctx) == false
    @test A.eval_filter(f, other, ctx) == true

    f_and = A.f_and(A.atom_color(A.RED), A.f_atom(A.atom_size(2)))
    @test A.eval_filter(f_and, red, ctx) == true
    f_and2 = A.f_and(A.atom_color(A.RED), A.f_atom(A.atom_size(99)))
    @test A.eval_filter(f_and2, red, ctx) == false

    f_or = A.f_or(A.atom_color(A.BLUE), A.f_atom(A.atom_size(2)))
    @test A.eval_filter(f_or, red, ctx) == true  # size matches even though color doesn't
end

@testitem "ARGA: apply_rule end-to-end (hand-crafted)" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    g = [2 2 0 0;
         2 2 0 0;
         0 0 0 0;
         0 0 0 1]

    # move every red object down by one
    out = A.apply_rule(g, A.f_atom(A.atom_color(A.RED)), A.mk_single(A.t_move(A.DOWN)))
    @test out == [0 0 0 0;
                  2 2 0 0;
                  2 2 0 0;
                  0 0 0 1]

    # a sequence: recolor then rotate (no-op shape change visible, but exercises sequencing)
    seq = A.mk_seq(A.t_update_color(A.GREEN), A.mk_single(A.t_noop()))
    out2 = A.apply_rule(g, A.f_atom(A.atom_color(A.RED)), seq)
    @test out2 == [3 3 0 0;
                   3 3 0 0;
                   0 0 0 0;
                   0 0 0 1]

    # move_max lets an earlier-processed object free space for a later one
    # (sequential-mutation semantics, see apply_rule's docstring)
    stacked = [2 0;
               0 0;
               3 0;
               0 0]
    out3 = A.apply_rule(stacked, A.f_not(A.atom_color(A.BLACK)), A.mk_single(A.t_move_max(A.UP)))
    @test out3 == [2 0;
                   3 0;
                   0 0;
                   0 0]
end

@testitem "ARGA: reproduces a real validated solution (problem_d2abd087, nbccg)" begin
    import HerbBenchmarks.ARC_AGI1
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # ground truth from ARGA-AAAI23's solutions/correct/solutions_d2abd087.json:
    #   rule 1: not(color == black)  => update_color(blue)
    #   rule 2: size == 6            => update_color(red)
    p = only(filter(p -> p.name == "problem_d2abd087", ARC_AGI1.ARC_AGI1_TRAINING))

    filt1 = A.f_not(A.atom_color(A.BLACK))
    trans1 = A.mk_single(A.t_update_color(A.BLUE))
    filt2 = A.f_atom(A.atom_size(6))
    trans2 = A.mk_single(A.t_update_color(A.RED))
    run(grid) = A.apply_rule(A.apply_rule(grid, filt1, trans1), filt2, trans2)

    for ex in vcat(ARC_AGI1.train_examples(p), ARC_AGI1.test_examples(p))
        @test run(ex.in[:_arg_1]) == ex.out
    end
end

@testitem "ARGA: grammar + make_interpreter matches apply_rule directly" begin
    import HerbCore: RuleNode
    import HerbBenchmarks.ARC_AGI1
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    p = only(filter(p -> p.name == "problem_d2abd087", ARC_AGI1.ARC_AGI1_TRAINING))
    ex = first(ARC_AGI1.train_examples(p))

    # rule 1 only: not(color == black) => update_color(blue)
    rn = RuleNode(1, [
        RuleNode(2, [
            RuleNode(4, [RuleNode(7, [RuleNode(20)])]),               # Filter = f_not(atom_color(BLACK))
            RuleNode(201, [RuleNode(203, [RuleNode(21)])]),            # Transforms = mk_single(t_update_color(BLUE))
        ]),
    ])

    via_interpret = A.interpret(rn, [ex])[1]
    via_direct = A.apply_rule(ex.in[:_arg_1], A.f_not(A.atom_color(A.BLACK)), A.mk_single(A.t_update_color(A.BLUE)))
    @test via_interpret == via_direct
end

@testitem "ARGA: 160-task problem subset" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    problems = A.arga_problems()
    @test length(problems) == 160
    @test length(unique(p.name for p in problems)) == 160
    @test all(p -> length(p.spec) >= 3, problems)  # at least 2 train + 1 test
end

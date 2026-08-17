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

@testitem "ARGA: neighbors and degree (line-of-sight, not Chebyshev)" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    a = A.ARGAObject([(1, 1)], 2)
    b = A.ARGAObject([(1, 3)], 3)   # same row, unobstructed -> horizontal neighbor
    c = A.ARGAObject([(5, 5)], 4)   # shares neither row nor column -> not a neighbor

    grid = A.render(10, 10, 0, [a, b, c])
    ctx = (objects = [a, b, c], height = 10, width = 10, background = 0, grid = grid)

    @test A.unobstructed_relation(a, b, grid, 0) == :horizontal
    @test A.unobstructed_relation(a, c, grid, 0) === nothing
    @test Set(A.neighbors_of(a, ctx)) == Set([b])
    @test A.obj_degree(a, ctx) == 1
    @test A.obj_degree(c, ctx) == 0

    # a blocker on the same row breaks the line of sight
    blocker = A.ARGAObject([(1, 2)], 5)
    grid2 = A.render(10, 10, 0, [a, b, blocker])
    @test A.unobstructed_relation(a, b, grid2, 0) === nothing
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

@testitem "ARGA: rotate (90/180/270, clockwise per ARCGraph.rotate_node)" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # a single pixel is its own centroid, so rotation is always a no-op
    single = A.ARGAObject([(3, 3)], 2)
    @test A.rotate_pixels(single, 90).pixels == [(3, 3)]
    @test A.rotate_pixels(single, 270).pixels == [(3, 3)]

    # an L-shape: (1,1),(2,1),(2,2) -- centroid recomputed, floor-divided,
    # before *each* 90-degree step, like ARCGraph.rotate_node.
    L = A.ARGAObject([(1, 1), (2, 1), (2, 2)], 2)
    @test Set(A.rotate_pixels(L, 90).pixels) == Set([(1, 1), (1, 2), (0, 2)])
    @test Set(A.rotate_pixels(L, 270).pixels) == Set([(1, 0), (1, 1), (2, 0)])

    # a vertical domino rotated 90 deg becomes a horizontal one
    domino = A.ARGAObject([(1, 1), (2, 1)], 2)
    @test Set(A.rotate_pixels(domino, 90).pixels) == Set([(1, 1), (1, 2)])
end

@testitem "ARGA: flip and mirror" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # flip is relative to the object's own bounding box
    bar = A.ARGAObject([(1, 1), (1, 2), (1, 3)], 2)  # 1x3 horizontal bar
    flipped_h = A.flip_pixels(bar, A.HORIZONTAL)
    @test Set(flipped_h.pixels) == Set([(1, 1), (1, 2), (1, 3)])  # symmetric, unchanged

    asym2 = A.ARGAObject([(1, 1), (1, 2), (2, 1)], 2)
    flipped2 = A.flip_pixels(asym2, A.HORIZONTAL)
    @test Set(flipped2.pixels) == Set([(1, 2), (1, 1), (2, 2)])

    # mirror's axis comes from `other`: horizontal line-of-sight -> mirror
    # about a vertical line through other's column.
    this_h = A.ARGAObject([(1, 1)], 2)
    other_h = A.ARGAObject([(1, 5)], 3)
    grid_h = A.render(10, 10, 0, [this_h, other_h])
    ctx_h = (objects = [this_h, other_h], height = 10, width = 10, background = 0, grid = grid_h)
    @test A.mirror_axis(this_h, other_h, ctx_h) == (nothing, 5)
    @test A.mirror_pixels(this_h, A.mirror_axis(this_h, other_h, ctx_h)).pixels == [(1, 9)]

    # vertical line-of-sight -> mirror about a horizontal line through other's row.
    this_v = A.ARGAObject([(1, 1)], 2)
    other_v = A.ARGAObject([(5, 1)], 3)
    grid_v = A.render(10, 10, 0, [this_v, other_v])
    ctx_v = (objects = [this_v, other_v], height = 10, width = 10, background = 0, grid = grid_v)
    @test A.mirror_axis(this_v, other_v, ctx_v) == (5, nothing)
    @test A.mirror_pixels(this_v, A.mirror_axis(this_v, other_v, ctx_v)).pixels == [(9, 1)]

    # no `other` available -> no-op
    @test A.mirror_pixels(this_h, nothing) == this_h
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
    ctx = (background = 0,)
    (border_obj, extras) = A.hollow_rectangle_pixels(sq, 5, ctx)
    @test Set(border_obj.pixels) == Set([
        (1, 1), (1, 2), (1, 3), (2, 1), (2, 3), (3, 1), (3, 2), (3, 3),
    ])
    @test length(extras) == 1
    @test Set(extras[1].pixels) == Set([(2, 2)])
    @test extras[1].color == 5

    # hollowing with the (dynamic) background color drops the interior entirely
    (_, extras_bg) = A.hollow_rectangle_pixels(sq, A.BLACK, ctx)
    @test isempty(extras_bg)
    ctx_nonzero_bg = (background = 7,)
    (_, extras_bg2) = A.hollow_rectangle_pixels(sq, 7, ctx_nonzero_bg)
    @test isempty(extras_bg2)
end

@testitem "ARGA: filter primitives and expressions" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    red = A.ARGAObject([(1, 1), (1, 2)], A.RED)
    other = A.ARGAObject([(5, 5), (5, 6), (5, 7)], A.BLUE)
    grid = A.render(10, 10, 0, [red, other])
    ctx = (objects = [red, other], height = 10, width = 10, background = 0, grid = grid)

    color_red = A.color_equals(A.color_of(A.THIS_VAR), A.RED)
    @test A.eval_filter_prim(color_red, red, nothing, ctx)
    @test !A.eval_filter_prim(A.color_equals(A.color_of(A.THIS_VAR), A.BLUE), red, nothing, ctx)

    @test A.eval_filter_prim(A.size_equals(A.size_of(A.THIS_VAR), 2), red, nothing, ctx)
    @test A.eval_filter_prim(A.size_equals(A.size_of(A.THIS_VAR), A.ARGA_MIN), red, ctx.objects[2], ctx)
    @test A.eval_filter_prim(A.size_equals(A.size_of(A.THIS_VAR), A.ARGA_MAX), other, nothing, ctx)

    # red and other share neither row nor column -> not neighbors
    @test !A.eval_filter_prim(A.neighbor_of(A.THIS_VAR, A.OTHER_VAR), red, other, ctx)

    f = A.f_not(A.f_prim(color_red))
    @test A.eval_filter(f, red, nothing, ctx) == false
    @test A.eval_filter(f, other, nothing, ctx) == true

    f_and = A.f_and(A.f_prim(color_red), A.f_prim(A.size_equals(A.size_of(A.THIS_VAR), 2)))
    @test A.eval_filter(f_and, red, nothing, ctx) == true
    f_and2 = A.f_and(A.f_prim(color_red), A.f_prim(A.size_equals(A.size_of(A.THIS_VAR), 99)))
    @test A.eval_filter(f_and2, red, nothing, ctx) == false

    f_or = A.f_or(A.f_prim(A.color_equals(A.color_of(A.THIS_VAR), A.BLUE)), A.f_prim(A.size_equals(A.size_of(A.THIS_VAR), 2)))
    @test A.eval_filter(f_or, red, nothing, ctx) == true  # size matches even though color doesn't

    # no_filter selects everything
    @test A.eval_filter(A.no_filter(), red, nothing, ctx) == true
end

@testitem "ARGA: apply_rule end-to-end (hand-crafted)" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    g = [2 2 0 0;
         2 2 0 0;
         0 0 0 0;
         0 0 0 1]

    is_red = A.has_filter(A.f_prim(A.color_equals(A.color_of(A.THIS_VAR), A.RED)))

    # move every red object down by one
    out = A.apply_rule(g, A.decl_this(), is_red, A.mk_single(A.t_move(A.DOWN)))
    @test out == [0 0 0 0;
                  2 2 0 0;
                  2 2 0 0;
                  0 0 0 1]

    # a sequence: recolor then rotate (no-op shape change visible, but exercises sequencing)
    seq = A.mk_seq(A.t_update_color(A.GREEN), A.mk_single(A.t_noop()))
    out2 = A.apply_rule(g, A.decl_this(), is_red, seq)
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
    not_bg = A.has_filter(A.f_not(A.f_prim(A.color_equals(A.color_of(A.THIS_VAR), A.BLACK))))
    out3 = A.apply_rule(stacked, A.decl_this(), not_bg, A.mk_single(A.t_move_max(A.UP)))
    @test out3 == [2 0;
                   3 0;
                   0 0;
                   0 0]
end

@testitem "ARGA: existential `other` binding" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # two same-row objects of different colors; a third, unrelated one.
    # "recolor this if it has a same-row neighbor of color BLUE" should only
    # touch the RED object (which sees the BLUE one along its row).
    g = [2 0 0 1 0;
         0 0 0 0 0;
         4 0 0 0 0]

    has_blue_neighbor = A.has_filter(A.f_and(
        A.f_prim(A.neighbor_of(A.THIS_VAR, A.OTHER_VAR)),
        A.f_prim(A.color_equals(A.color_of(A.OTHER_VAR), A.BLUE)),
    ))
    out = A.apply_rule(g, A.decl_this_other(), has_blue_neighbor, A.mk_single(A.t_update_color(A.GREEN)))
    @test out == [3 0 0 1 0;
                  0 0 0 0 0;
                  4 0 0 0 0]
end

@testitem "ARGA: reproduces a real validated solution (problem_d2abd087, nbccg)" begin
    import HerbBenchmarks.ARC_AGI1
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    # ground truth from ARGA-AAAI23's solutions/correct/solutions_d2abd087.json:
    #   rule 1: not(color == black)  => update_color(blue)
    #   rule 2: size == 6            => update_color(red)
    p = only(filter(p -> p.name == "problem_d2abd087", ARC_AGI1.ARC_AGI1_TRAINING))

    filt1 = A.has_filter(A.f_not(A.f_prim(A.color_equals(A.color_of(A.THIS_VAR), A.BLACK))))
    trans1 = A.mk_single(A.t_update_color(A.BLUE))
    filt2 = A.has_filter(A.f_prim(A.size_equals(A.size_of(A.THIS_VAR), 6)))
    trans2 = A.mk_single(A.t_update_color(A.RED))
    run(grid) = A.apply_rule(A.apply_rule(grid, A.decl_this(), filt1, trans1), A.decl_this(), filt2, trans2)

    for ex in vcat(ARC_AGI1.train_examples(p), ARC_AGI1.test_examples(p))
        @test run(ex.in[:_arg_1]) == ex.out
    end
end

@testitem "ARGA: grammar + make_interpreter matches apply_rules directly" begin
    import HerbCore: RuleNode
    import HerbBenchmarks.ARC_AGI1
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    p = only(filter(p -> p.name == "problem_d2abd087", ARC_AGI1.ARC_AGI1_TRAINING))
    ex = first(ARC_AGI1.train_examples(p))

    # rule 1 only via apply_rules cascade: (vars (this)) (filter (not (color_equals (color_of this) O)))
    #                                      (apply (update_color B))
    # indices derived from `grammar_arga.rules` (see grammar.jl):
    #   1  Start = ARGAProgram
    #   2  ARGAProgram = apply_rules(_arg_1, Rules)
    #   4  Rules = mk_rule_single(Rule)
    #   6  Rule = rule(Decl, Filter, Xforms)
    #   7  Decl = decl_this()
    #  10  Filter = has_filter(FilterExpr)        14  FilterExpr = f_not(FilterExpr)
    #  11  FilterExpr = f_prim(FilterPrim)        15  FilterPrim = color_equals(...)
    #  47  ColorExpr = color_of(Var)             138  Var = THIS_VAR
    #  37  ColorExpr = BLACK
    #  23  Xforms = mk_single(Xform)              25  Xform = t_update_color(ColorExpr)
    #  38  ColorExpr = BLUE
    rn = RuleNode(1, [
        RuleNode(2, [
            RuleNode(4, [
                RuleNode(6, [
                    RuleNode(7),
                    RuleNode(10, [RuleNode(14, [RuleNode(11, [RuleNode(15, [RuleNode(47, [RuleNode(138)]), RuleNode(37)])])])]),
                    RuleNode(23, [RuleNode(25, [RuleNode(38)])]),
                ]),
            ]),
        ]),
    ])

    via_interpret = A.interpret(rn, [ex])[1]
    via_direct = A.apply_rules(
        ex.in[:_arg_1],
        A.mk_rule_single(A.rule(
            A.decl_this(),
            A.has_filter(A.f_not(A.f_prim(A.color_equals(A.color_of(A.THIS_VAR), A.BLACK)))),
            A.mk_single(A.t_update_color(A.BLUE)),
        )),
    )
    @test via_interpret == via_direct
end

@testitem "ARGA: 160-task problem subset" begin
    import HerbBenchmarks.ARC_AGI1.ARGA as A

    problems = A.arga_problems()
    @test length(problems) == 160
    @test length(unique(p.name for p in problems)) == 160
    @test all(p -> length(p.spec) >= 3, problems)  # at least 2 train + 1 test

    by_category = [A.arga_problems(c) for c in (:augmentation, :movement, :recolor)]
    @test sum(length, by_category) == 160
    @test length(union((Set(p.name for p in ps) for ps in by_category)...)) == 160
end

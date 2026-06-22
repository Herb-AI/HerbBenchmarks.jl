#=
    ARGA / OBJECT-ARC grammar

    Mirrors hysynth's `dsl/v0_3/dsl.lark` (the grammar the ARGA paper,
    Qiu et al. "ARGA", actually specifies) directly:

        rule       -> (vars (this other?)) (filter filter_expr?) (apply xform+)
        filter_expr -> filter_prim | (and e e) | (or e e) | (not e)
        filter_prim -> color_equals(e,e) | size_equals(e,e) | height_equals(e,e)
                     | width_equals(e,e) | degree_equals(e,e) | shape_equals(e,e)
                     | column_equals(e,e) | neighbor_of(VAR,VAR)
        *_expr     -> LITERAL | *_of(VAR)
        xform      -> update_color | move_node | extend_node | move_node_max
                     | rotate_node | add_border | fill_rectangle
                     | hollow_rectangle | mirror | flip | insert | noop

    instead of the previous self-only design (one bespoke `Atom` per
    attribute, with hand-rolled `neighbor_color`/`neighbor_size`/
    `neighbor_degree` standing in for what the lark grammar expresses with
    a single bound `other` variable). See primitives.jl's file docstring
    for the few places this still deviates from the lark text (merging
    `fcolor_expr`/`color_expr`, dropping `Row`, `insert`'s object-id scheme,
    `img_pts_of`/`direction_of`'s definitions) and for two real semantic
    bugs found and fixed relative to the previous version of this grammar's
    backing primitives (`rotate_node`'s 90/270 directions were swapped;
    `hollow_rectangle`'s background check was hardcoded to black).
=#

grammar_arga = HerbGrammar.@csgrammar begin
    Start = ARGAProgram
    ARGAProgram = apply_rule(_arg_1, Decl, Filter, Xforms)

    Decl = decl_this()
    Decl = decl_this_other()

    Filter = no_filter()
    Filter = has_filter(FilterExpr)

    FilterExpr = f_prim(FilterPrim)
    FilterExpr = f_and(FilterExpr, FilterExpr)
    FilterExpr = f_or(FilterExpr, FilterExpr)
    FilterExpr = f_not(FilterExpr)

    FilterPrim = color_equals(ColorExpr, ColorExpr)
    FilterPrim = size_equals(SizeExpr, SizeExpr)
    FilterPrim = height_equals(HeightExpr, HeightExpr)
    FilterPrim = width_equals(WidthExpr, WidthExpr)
    FilterPrim = degree_equals(DegreeExpr, DegreeExpr)
    FilterPrim = shape_equals(ShapeExpr, ShapeExpr)
    FilterPrim = column_equals(ColumnExpr, ColumnExpr)
    FilterPrim = neighbor_of(Var, Var)

    Xforms = mk_single(Xform)
    Xforms = mk_seq(Xform, Xforms)

    Xform = t_update_color(ColorExpr)
    Xform = t_move(DirectionExpr)
    Xform = t_extend(DirectionExpr, Overlap)
    Xform = t_move_max(DirectionExpr)
    Xform = t_rotate(Angle)
    Xform = t_add_border(ColorExpr)
    Xform = t_fill_rectangle(ColorExpr, Overlap)
    Xform = t_hollow_rectangle(ColorExpr)
    Xform = t_mirror(Var)
    Xform = t_flip(Axis)
    Xform = t_insert(ObjectId, ImgPtsExpr, RelPos)
    Xform = t_noop()

    # fcolor_expr/color_expr merged: both are the same 10-letter token set
    # in the lark grammar, only split there for parser-technical reasons.
    ColorExpr = BLACK | BLUE | RED | GREEN | YELLOW | GREY | FUCHSIA | ORANGE | CYAN | MAROON
    ColorExpr = color_of(Var)

    SizeExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    SizeExpr = |(1:30)
    SizeExpr = size_of(Var)

    HeightExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    HeightExpr = |(1:30)
    HeightExpr = height_of(Var)

    WidthExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    WidthExpr = |(1:30)
    WidthExpr = width_of(Var)

    DegreeExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    DegreeExpr = |(0:8)
    DegreeExpr = degree_of(Var)

    ColumnExpr = ARGA_CENTER | ARGA_EVEN | ARGA_ODD
    ColumnExpr = |(1:30)
    ColumnExpr = column_of(Var)

    ShapeExpr = SQUARE | ENCLOSED
    ShapeExpr = shape_of(Var)

    DirectionExpr = UP | DOWN | LEFT | RIGHT | UPLEFT | DOWNLEFT | UPRIGHT | DOWNRIGHT
    DirectionExpr = direction_of(Var)

    ImgPtsExpr = IMG_TOP | IMG_BOTTOM | IMG_LEFT | IMG_RIGHT | IMG_TOPLEFT | IMG_TOPRIGHT | IMG_BOTTOMLEFT | IMG_BOTTOMRIGHT
    ImgPtsExpr = img_pts_of(Var)

    # mirror_expr is always `mirror_axis_of(VAR)` (no literal alternative in
    # the lark grammar), so `t_mirror` just takes the `Var` directly.
    Var = THIS_VAR | OTHER_VAR

    Axis = VERTICAL | HORIZONTAL | LEFTDIAGONAL | RIGHTDIAGONAL
    Angle = 90 | 180 | 270
    Overlap = true | false
    RelPos = REL_SOURCE | REL_TARGET | REL_MIDDLE

    # OBJECT_ID indexes into this rule's own extracted-object list (0-based,
    # raster-scan order) -- see primitives.jl's file docstring.
    ObjectId = |(0:9)
end

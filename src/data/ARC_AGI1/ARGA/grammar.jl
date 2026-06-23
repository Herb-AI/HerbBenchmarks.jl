#=
    ARGA / OBJECT-ARC grammar, mirroring the ARGA DSL (Xu, Khalil & Sanner,
    "Graphs, Constraints, and Search for the Abstraction and Reasoning
    Corpus", AAAI 2023):

        rule        -> (vars (this other?)) (filter filter_expr?) (apply xform+)
        filter_expr -> filter_prim | (and e e) | (or e e) | (not e)
        filter_prim -> color_equals(e,e) | size_equals(e,e) | height_equals(e,e)
                     | width_equals(e,e) | degree_equals(e,e) | shape_equals(e,e)
                     | column_equals(e,e) | neighbor_of(VAR,VAR)
        *_expr      -> LITERAL | *_of(VAR)
        xform       -> update_color | move_node | extend_node | move_node_max
                     | rotate_node | add_border | fill_rectangle
                     | hollow_rectangle | mirror | flip | insert | noop

    See primitives.jl's file docstring for where this deviates from the
    reference DSL (merged fcolor/color tokens, dropped `Row`, the insert
    object-id scheme, `img_pts_of`/`direction_of`'s definitions).
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

    # fcolor_expr/color_expr merged: both use the same 10-color token set.
    ColorExpr = BLACK | BLUE | RED | GREEN | YELLOW | GREY | FUCHSIA | ORANGE | CYAN | MAROON
    ColorExpr = color_of(Var)

    SizeExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    SizeExpr = |(1:9)
    SizeExpr = size_of(Var)

    HeightExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    HeightExpr = |(1:9)
    HeightExpr = height_of(Var)

    WidthExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    WidthExpr = |(1:9)
    WidthExpr = width_of(Var)

    DegreeExpr = ARGA_MIN | ARGA_MAX | ARGA_EVEN | ARGA_ODD
    DegreeExpr = |(0:8)
    DegreeExpr = degree_of(Var)

    ColumnExpr = ARGA_CENTER | ARGA_EVEN | ARGA_ODD
    ColumnExpr = |(1:9)
    ColumnExpr = column_of(Var)

    ShapeExpr = SQUARE | ENCLOSED
    ShapeExpr = shape_of(Var)

    DirectionExpr = UP | DOWN | LEFT | RIGHT | UPLEFT | DOWNLEFT | UPRIGHT | DOWNRIGHT
    DirectionExpr = direction_of(Var)

    ImgPtsExpr = IMG_TOP | IMG_BOTTOM | IMG_LEFT | IMG_RIGHT | IMG_TOPLEFT | IMG_TOPRIGHT | IMG_BOTTOMLEFT | IMG_BOTTOMRIGHT
    ImgPtsExpr = img_pts_of(Var)

    # mirror's axis is always derived from a Var (mirror_axis_of(VAR)).
    Var = THIS_VAR | OTHER_VAR

    Axis = VERTICAL | HORIZONTAL | LEFTDIAGONAL | RIGHTDIAGONAL
    Angle = 90 | 180 | 270
    Overlap = true | false
    RelPos = REL_SOURCE | REL_TARGET | REL_MIDDLE

    # Indexes into this rule's own extracted-object list (0-based, raster-scan order).
    ObjectId = |(0:9)
end

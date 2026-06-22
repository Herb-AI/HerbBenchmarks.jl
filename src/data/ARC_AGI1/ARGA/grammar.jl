#=
    ARGA / OBJECT-ARC grammar

    Matches the paper's Figure 16 grammar:

        Rule       -> if Filter then Transforms
        Transforms -> Transform | Transform ; Transforms
        Filter     -> Atom | not Atom | Atom and Filter | Atom or Filter
        Atom       -> Color =c Color | Size =s Size | Degree =d Degree
                    | Width =w Width | Height =h Height | Shape =S Shape
                    | Row =r Row | Column =C Column | is_neighbor(Obj, Obj)
        Transform  -> update_color(Color) | move(Dir) | move_max(Dir)
                    | extend(Dir, Overlap) | rotate(Angle)
                    | fill_rectangle(Color, Overlap) | hollow_rectangle(Color)
                    | mirror(Axis) | add_border(Color) | flip(Axis) | NoOp

    with the following documented adaptations (see primitives.jl for the
    semantics behind each):

    - `Obj -> self | x | y | ...` and the two-object `is_neighbor(Obj, Obj)`
      Atom are replaced by `self`-only evaluation plus concrete
      "has-a-neighbor-with-property" Atoms (`atom_neighbor_color` etc, plus
      a parameterless `atom_any_neighbor` for bare `is_neighbor`) -- this
      is what ARCGraph.py's reference implementation actually provides
      (`filter_by_neighbor_color/size/degree`), rather than a generic
      bound-variable mechanism the paper's own grammar leaves undefined.
    - `Shape =S Shape` is dropped: under `self`-only evaluation it would
      always compare `shape_of(self)` to itself, which is vacuous.
      `is_square`/`is_enclosed` (boolean, not equality-shaped) atoms take
      its place.
    - `Color =c Color` etc. only ever compares `self`'s own attribute
      against a literal or MIN/MAX aggregate, for the same `self`-only
      reason -- so `Color`/`Size`/etc. are plain value nonterminals, not
      `_of(Obj)`-parameterized ones.
    - `insert` and `Transform`'s implied multi-object pattern-copying are
      out of scope -- the paper's own Transform list (above) does not
      include `insert` either, unlike the project's lark grammar.
=#

grammar_arga = HerbGrammar.@csgrammar begin
    Start = ARGAGrid
    ARGAGrid = apply_rule(_arg_1, Filter, Transforms)

    Filter = f_atom(Atom)
    Filter = f_not(Atom)
    Filter = f_and(Atom, Filter)
    Filter = f_or(Atom, Filter)

    Atom = atom_color(Color)
    Atom = atom_size(Size)
    Atom = atom_degree(Degree)
    Atom = atom_width(Width)
    Atom = atom_height(Height)
    Atom = atom_row(Row)
    Atom = atom_column(Column)
    Atom = atom_square()
    Atom = atom_enclosed()
    Atom = atom_any_neighbor()
    Atom = atom_neighbor_color(Color)
    Atom = atom_neighbor_size(Size)
    Atom = atom_neighbor_degree(Degree)

    Color = BLACK | BLUE | RED | GREEN | YELLOW | GREY | FUCHSIA | ORANGE | CYAN | MAROON

    Size = ARGA_MIN | ARGA_MAX
    Size = |(1:30)
    Degree = ARGA_MIN | ARGA_MAX
    Degree = |(0:8)
    Width = ARGA_MIN | ARGA_MAX
    Width = |(1:30)
    Height = ARGA_MIN | ARGA_MAX
    Height = |(1:30)
    Row = ARGA_MIN | ARGA_MAX
    Row = |(1:30)
    Column = ARGA_MIN | ARGA_MAX
    Column = |(1:30)

    Transforms = mk_single(Transform)
    Transforms = mk_seq(Transform, Transforms)

    Transform = t_update_color(Color)
    Transform = t_move(Dir)
    Transform = t_move_max(Dir)
    Transform = t_extend(Dir, Overlap)
    Transform = t_rotate(Angle)
    Transform = t_fill_rectangle(Color, Overlap)
    Transform = t_hollow_rectangle(Color)
    Transform = t_mirror(Axis)
    Transform = t_add_border(Color)
    Transform = t_flip(Axis)
    Transform = t_noop()

    Dir = UP | DOWN | LEFT | RIGHT | UPLEFT | DOWNLEFT | UPRIGHT | DOWNRIGHT
    Axis = VERTICAL | HORIZONTAL | LEFTDIAGONAL | RIGHTDIAGONAL
    Angle = 90 | 180 | 270
    Overlap = true | false
end

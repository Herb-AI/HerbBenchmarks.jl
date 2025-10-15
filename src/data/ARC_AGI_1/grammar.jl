grammar_tilman = @cfgrammar begin
    Start = (state = Grid; returnState(state))
    InputGrid = initState(_arg_1)
    Return = returnState(state)

    Color = |(0:9)
    Pos = |(1:30)

    Grid = init_grid(3, 3)
    Grid = resize_grid(Grid, Pos, Pos)
    Grid = clone_grid(InputGrid)
    Grid = reset_grid(Grid)
    Grid = set_cell(Grid, Pos, Pos, Color)

    Grid = select_and_paste(Grid, Pos, Pos, Pos, Pos, Pos, Pos)
    Grid = select_and_paste(InputGrid, Pos, Pos, Pos, Pos, Grid, Pos, Pos)
    Grid = floodfill(Grid, Pos, Pos, Color)
end

grammar_hodel = @csgrammar begin
    Start = Sequence
    # Start = Grid # needs to be a grid
    # Grid = Sequence
    Sequence = Operation
    Sequence = (Operation; Sequence)
    Operation = Transformation # grid -> grid
    Transformation = vMirror() | hMirror() | hConcat() | vConcat() # concats have two arguments => indicate
end

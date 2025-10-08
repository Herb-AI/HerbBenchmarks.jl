module ARC_Tilman

using HerbCore
using HerbSpecification
using HerbGrammar

using JSON

include("arc_primitives.jl")

export Grid,
    initState,
    array_to_matrix,
    returnState,
    init_grid,
    clone_grid,
    resize_grid,
    copy_from_input,
    reset_grid,
    set_cell,
    select,
    select_and_paste,
    floodfill

end # module ARC_Tilman


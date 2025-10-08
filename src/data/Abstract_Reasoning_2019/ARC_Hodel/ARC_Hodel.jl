module ARC_Hodel

using HerbCore
using HerbSpecification
using HerbGrammar
using Herb.HerbInterpret
using JSON


include("arc_basic_primitives.jl")
include("arc_grid_operations.jl")
include("arc_index_operations.jl")
include("interpret.jl")

export add,
    subtract,
    multiply,
    divide,
    invert,
    double,
    halve,
    increment,
    decrement,
    crement,
    get_sign,
    even,
    greater,
    positive,
    toivec,
    tojvec,
    astuple,
    flip,
    both,
    either,
    asindices,
    ofcolor,
    rot90,
    rot180,
    rot270,
    downscale,
    hconcat,
    vconcat,
    hupscale,
    vupscale,
    cellwise,
    replace,
    switch,
    trim,
    tophalf,
    bottomhalf,
    lefthalf,
    righthalf,
    compress,
    canvas,
    index,
    crop,
    ulcorner,
    ulcorner,
    urcorner,
    llcorner,
    lrcorner,
    toindices,
    vmirror,
    vmirror,
    vmirror,
    hmirror,
    hmirror,
    hmirror,
    dmirror,
    dmirror,
    dmirror,
    cmirror,
    cmirror,
    vfrontier,
    hfrontier,
    interpret,
    get_relevant_tags
end # module ARC_Hodel


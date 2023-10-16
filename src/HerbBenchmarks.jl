module HerbBenchmarks

using HerbCore
using HerbData

include("../e1-robots/Robotparser.jl")
# include("../e2-strings/Stringparser.jl")
include("../e3-pixels/Pixelparser.jl")

# data
include("../data/String_transformations_2020/String_transformations_2020.jl")
# using Glob
# foreach(include, glob("*.jl", "../data/")) #Wildcard-based solution

# utils
include("benchmarks_io.jl")

export 
    # sub-modules
    String_transformations_2020,

    # utils
    parse_file,
    write_problem,
    parse_to_julia

end # module HerbBenchmarks

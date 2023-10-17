module HerbBenchmarks

using HerbCore
using HerbData

include("../e1-robots/Robotparser.jl")
# include("../e2-strings/Stringparser.jl")
include("../e3-pixels/Pixelparser.jl")

include("utils.jl")

# data
include("data/String_transformations_2020/String_transformations_2020.jl")
@make_public String_transformations_2020
# using Glob
# foreach(include, glob("*.jl", "data/")) #Wildcard-based solution

# utils
include("benchmarks_io.jl")

export 
    # utils
    parse_file,
    write_problem,
    parse_to_julia

end # module HerbBenchmarks

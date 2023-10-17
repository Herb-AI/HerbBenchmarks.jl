module HerbBenchmarks

using HerbCore
using HerbData

include("utils.jl")

# data
for (root, dirs, files) in walkdir(dirname(@__FILE__))
    for f in files
        # Check if module name starts with capital letter and <year>.jl
        if occursin(r"^[A-Z].*\d{4}\.jl$", f)
            include(joinpath(root, f))
            @eval @make_public $(Symbol(f[1:(findfirst('.', f)-1)]))
        end
    end
end

# utils
include("benchmarks_io.jl")

export 
    # utils
    parse_file,
    write_problem,
    parse_to_julia

end # module HerbBenchmarks

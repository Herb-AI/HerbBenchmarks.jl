module HerbBenchmarks

using HerbCore
using HerbData
using HerbGrammar

include("utils.jl")

# Iterate over directories in `/data/` and include all available files
for (root, dirs, files) in walkdir(dirname(@__FILE__)*"/data/")
    for f in files
        # Check if module name starts with capital letter (formerly also <year>.jl)
        # if occursin(r"^[A-Z].*\d{4}\.jl$", f)
        if occursin(r"^[A-Z].*\.jl$", f)
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
    parse_to_julia,
    append_cfgrammar,
    enumerate_problem_files,

    make_public,
    make_public_rec
end # module HerbBenchmarks

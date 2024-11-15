using PythonCall, CondaPkg
using HerbSpecification

psb2 = pyimport("psb2")

function write_psb2_problems_to_file(problems::Vector{String}=String["fizz-buzz"], edge_or_random::String="random", n_train::Int64=200, n_test::Int64=2000, format::String="psb2")
    # If no specific problem specified, get all problems in the benchmark
    if isempty(problems) 
        problems = psb2.PROBLEMS
    end
    for name in problems
        if !(name in psb2.PROBLEMS)
            throw(ArgumentError("$(name) does not exist in the psb2 problems, the names use '-' as separator, not '_'."))
        else
            # This loads the json files to the /datasets/<name> folder
            psb2.fetch_examples(dirname(@__FILE__), name, n_train, n_test, format)
            # Reset the file if it exists, so we can append the data all at once
            julia_name = replace(name, "-" => "_")
            dir = joinpath(dirname(@__FILE__), "datasets", name)
            if isfile(joinpath(dir, julia_name * "data.jl"))
                rm(joinpath(dir, julia_name * "data.jl"))
            end
            # Write contents to file
            HerbBenchmarks.parse_to_julia(dir, "$(name)-$(edge_or_random).json", parse_line_json, julia_name * "_")
        end
    end
end
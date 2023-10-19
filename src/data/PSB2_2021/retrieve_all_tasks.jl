using Conda, PyCall
using HerbData, HerbBenchmarks

Conda.pip_interop(true)
Conda.pip("install", "psb2")

psb2 = PyCall.pyimport("psb2")

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
            psb2.fetch_examples(pwd(), name, n_train, n_test, format)
            julia_name = replace(name, "-" => "_")
            # Reset the file if it exsits, so we can append the data all at once
            if isfile("$(pwd())/datasets/$(name)/$(julia_name)data.jl")
                rm("$(pwd())/datasets/$(name)/$(julia_name)data.jl")
            end
            parse_to_julia("$(pwd())/datasets/$(name)/", "$(name)-$(edge_or_random).json", PSB2_2021.parse_line_json, julia_name, "a")
        end
    end
end
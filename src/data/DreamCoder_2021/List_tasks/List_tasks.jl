module List_tasks

using HerbCore
using HerbData
using HerbGrammar

using JSON

export 
    parse_list_problem,
    all_problems,
    all_problems_large

include("data.jl")
# include("grammar.jl")

function parse_list_problem(filename::AbstractString)::Dict{String, Problem}
    parsed_list = JSON.Parser.parsefile(filename)
    return_dict = Dict{String, Problem}()

    for parsed_problem in parsed_list
        examples::Vector{Example} = Vector{Example}()
        for data_dict in parsed_problem["examples"]
            push!(examples, IOExample(Dict(:i => data_dict["i"]), data_dict["o"]))
        end
        return_dict[parsed_problem["name"]] = Problem(examples)
    end
    return return_dict
end

end # module List_tasks

module PSB2_2021
using JSON
using HerbCore
using HerbGrammar
using HerbSpecification
using HerbInterpret

using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

include("data.jl")
include("retrieve_all_tasks.jl")
include("grammar.jl")
include("program_examples.jl")

interpret_fizzbuzz = make_stateful_interpreter(grammar_fizz_buzz; target_module=PSB2_2021, cache_module=PSB2_2021)

export 
    parse_line_json,
    write_psb2_problems_to_file

"""
    parse_line_json(line::AbstractString)::IOExample

Parses a line from a file in the `strings` dataset
"""
function parse_line_json(line::AbstractString)::IOExample
    # each line is a json object with keys 'input1', ..., 'inputk' and 'output1', ..., 'outputk'
    js = JSON.parse(line)
    inputs = Dict{Symbol, Any}()
    for (k, v) in js
        if occursin("input", k)
            inputs[Symbol(replace(k, "input" => "_arg_"))] = v
        end
    end
    output = nothing
    # PSB2 has only four problem types with more than one output
    if "output2" in keys(js)
        if "output3" in keys(js)
            # This is only for the coin-sums problem
            output = (pennies=js["output1"], nickles=js["output2"], dimes=js["output3"], quarters=js["output4"])
        else
            if js["output1"] isa Vector
                # This is only for the cut-vector problem
                output = (left=js["output1"], right=js["output2"])
            elseif js["input1"] isa String
                # This is only for the mastermind problem
                output = (white=js["output1"], black=js["output2"])
            else
                # This is only for the find-pair problem
                output = (js["output1"], js["output2"])
            end
        end
    else
        output = js["output1"]
    end
    return IOExample(inputs, output)
end

end # module PSB2_2021
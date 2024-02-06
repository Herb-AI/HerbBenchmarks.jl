module PSB2_2021

using JSON
using HerbSpecification
# using HerbInterpret

include("data.jl")

export 
    parse_line_json

# interpret = HerbInterpret.interpret

"""
    parse_line_json(line::AbstractString)::IOExample

Parses a line from a file in the `strings` dataset
"""
function parse_line_json(line::AbstractString)::IOExample
    js = JSON.parse(line)
    inputs = Dict{Symbol, Any}()
    outputs = Dict{Symbol, Any}()
    for (k, v) in js
        if occursin("output", k)
            outputs[Symbol(k)] = v
        elseif occursin("input", k)
            inputs[Symbol(k)] = v
        else
            throw(KeyError("Unknown type of JSON key: no input or output"))
        end
    end
    return IOExample(inputs, outputs)
end

end # module PSB2_2021

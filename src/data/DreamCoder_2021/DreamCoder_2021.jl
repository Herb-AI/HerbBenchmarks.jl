module DreamCoder_2021

using HerbCore
using HerbData
using HerbGrammar

# include("data.jl")

export 
    parseline_primitive

"""    
Takes OCaml primitive in a single line and returns a [`Dict`](@ref) mapping from its name to a Dict of its Symbol to function
"""    
function parseline_primitive(line_primitive::AbstractString)::Dict{String, Dict{Symbol,Any}}
    match = match(r"primitive \"(\w+)\" \"?([^\" \)]+)\"? \(([^)]+)\) \(([^)]+)\);", line)
    if match !== nothing
        name = Symbol(match.captures[1])
        types = split(match.captures[3], "@> ")
        body = match.captures[4]
        result[name] = Dict(:args => args, :body => body)
    end

end

end # module DreamCoder_2021

module String_transformations_2020

using HerbData

# include("data.jl")

export 
    parseline_string_transformations

"""
    parseline_strings(line::AbstractString)::IOExample

Parses a line from a file in the `strings` dataset
"""
function parseline_string_transformations(line::AbstractString)::IOExample
    # Helper function that converts a character list string to a string
    # consisting of the characters
    # Example: "['A','B','C']" → "ABC"
    parsecharlist(x) = join([x[i] for i ∈ 3:4:length(x)])

    # Extract input and output lists using the RegEx
    matches = match(r"^[^\[\]]+(\[[^\[\]]*\])[^\[\]]+(\[[^\[\]]*\])", line)

    input = Dict(:x => parsecharlist(matches[1]))
    output = parsecharlist(matches[2])
    return IOExample(input, output)
end

end # module String_transformations_2020

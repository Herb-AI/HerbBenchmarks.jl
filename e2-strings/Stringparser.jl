module StringParser

using Data

export parseline_strings

"""
Parses a line from a file in the `strings` dataset
"""
function parseline_strings(line::AbstractString)::IOExample
    # Helper function that converts a character list string to a string 
    # consisting of the characters
    # Example: "['A','B','C']" → "ABC"
    parsecharlist(x) = join([x[i] for i ∈ 3:4:length(x)])

    # Extract input and output lists using the RegEx
    matches = match(r"^[^\[\]]+(\[[^\[\]]*\])[^\[\]]+(\[[^\[\]]*\])", line)
    
    input = parsecharlist(matches[1])
    output = parsecharlist(matches[2])
    return IOExample(input, output)
end

end # Module
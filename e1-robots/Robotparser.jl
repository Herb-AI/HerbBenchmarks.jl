export parseline_robots

"""
Parses a line from a file in the `robots` dataset
"""
function parseline_robots(line::AbstractString)::IOExample
    # Helper function that converts a string to a list of integers 
    # consisting of the characters
    # Example: "1,2,3" → [1, 2, 3]
    parseintlist(x) = map(y -> parse(Int, y), split(x, ","))

    # Remove unnecessary parts and split the input and output
    split_line = split(replace(line, "pos(w("=>"", "))."=>""), "),w(")
    
    input = parseintlist(split_line[1])
    output = parseintlist(split_line[2])
    return IOExample(input, output)
end

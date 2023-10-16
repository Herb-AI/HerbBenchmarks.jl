using FilePathsBase
using HerbData
using HerbCore

include("src/benchmarks_io.jl")
include("data/String_transformations_2020/String_transformations_2020.jl")

using .String_transformations_2020

function enumerate_files(path::String)::Vector{String}
    if !isdir(path)
        throw(ArgumentError("'$path' is not a directory."))
    end
    
    # List all files in the directory
    file_list = [string(file) for file in readdir(path)]
    
    for file in file_list
        println(file)
        parsed_file = parse_file(path*file, parseline_string_transformations)
        name = string(split(file, '.')[1])
        write_problem(path*name*"data.jl", parsed_file, name) 
    end
end

# Test
directory_path = "data/String_transformations_2020/data/"  # current directory for testing
enumerate_files(directory_path)


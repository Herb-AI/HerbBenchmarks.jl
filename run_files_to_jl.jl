using FilePathsBase
using HerbData
using HerbCore

include("src/benchmarks_io.jl")
# include("src/data/String_transformations_2020/String_transformations_2020.jl")
include("src/data/Robots_2020/Robots_2020.jl")

using .Robots_2020

function enumerate_files(input_path::String, output_path::String, line_parser::Function)
    if !isdir(input_path)
        throw(ArgumentError("'$input_path' is not a directory."))
    end
    if !isdir(output_path)
        throw(ArgumentError("'$output_path' is not a directory."))
    end
    
    # List all files in the directory
    file_list = [string(file) for file in readdir(input_path)]
    
    for file in file_list
        println(file)
        file_problem = parse_file(input_path*file, line_parser)
        name = string(split(file, '.')[1])
        write_problem(output_path*"data.jl", file_problem, name, "a") 
    end
end

# Test
input_path = "e1-robots/data/"  # current directory for testing
output_path = "src/data/Robots_2020/"  
line_parser = parseline_robots
enumerate_files(input_path, output_path, line_parser)


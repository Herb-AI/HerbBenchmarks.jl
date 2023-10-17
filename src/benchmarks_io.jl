"""

"""
function parse_file(filepath::String, line_parser::Function)::Problem
    file = open(filepath)
    examples::Vector{Example} = Vector{Example}()
    
    for line in eachline(file)
        line = strip(line)  # Remove leading/trailing whitespace
        if !isempty(line)
            parsed_example = line_parser(line)
            push!(examples, parsed_example)
        end
    end
    
    close(file)
    return Problem(examples)  
end


"""

"""
function write_problem(filepath::String, problem::Problem, name::String="")
    file = open(filepath, "w")
    write(file, "problem_$(name) = $(problem)")
    close(file)
end


"""

"""
function parse_to_julia(path::String, filename::String, line_parser::Function, prefix::String="")::Problem
    # path = "data/String_transformations_2020/"
    problem = parse_file(path*filename, line_parser)
    write_problem(path*"$(prefix)data.jl", problem, prefix) 
end

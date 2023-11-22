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
function write_problem(filepath::String, problem::Problem, name::String="", mode::String="a")
    file = open(filepath, mode)
    name = replace(name, 
                   "-" => "_",
                   "." => "_",
                   "=" => "_",
                   " " => "_",
                   "(" => "",
                   ")" => "",
                  )
    write(file, replace("problem_$(name) = $(problem)\n", "IOExample" => "\n\tIOExample", "IOPExample" => "\n\tIOPExample"))
    close(file)
end


"""

"""
function append_cfgrammar(filepath::String, name::String, grammar::Grammar)
     open(filepath, "a") do file
        if !isprobabilistic(grammar)
            println(file, "grammar_$name = @cfgrammar begin")
            for (type, rule) ∈ zip(grammar.types, grammar.rules)
                println(file, "\t$type = $rule")
            end
        else
            println(file, "grammar_$name = @pcfgrammar begin")
            for (type, rule, prob) ∈ zip(grammar.types, grammar.rules, grammar.log_probabilities)
                println(file, "\t$(ℯ^prob) : $type = $rule")
            end
        end
        println(file, "end")
    end 
end


"""

"""
function parse_to_julia(path::String, filename::String, line_parser::Function, prefix::String="")::Problem
    # path = "data/String_transformations_2020/"
    problem = parse_file(path*filename, line_parser)
    write_problem(path*"$(prefix)data.jl", problem, prefix) 
end

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
    sanitize_name(name::AbstractString)::String

Turns a raw benchmark name (typically a source filename without its extension) into a valid Julia
identifier suffix.

Every writer that emits a `problem_`/`grammar_` binding must go through this function. Problems and
grammars are paired by exact string equality on this suffix in [`get_grammar`](@ref), so any
divergence between the two call sites silently unpairs them.
"""
function sanitize_name(name::AbstractString)::String
    return replace(String(name),
        "-" => "_",
        "." => "_",
        "=" => "_",
        " " => "_",
    )
end

"""

"""
function write_problem(filepath::String, problem::Problem, name::String="", mode::String="a")
    file = open(filepath, mode)
    name = sanitize_name(name)
    write(file, replace("problem_$(name) = $(problem)\n", "IOExample" => "\n\tIOExample", "IOPExample" => "\n\tIOPExample"))
    close(file)
end


"""

"""
function append_cfgrammar(filepath::String, name::String, grammar::AbstractGrammar)
    name = sanitize_name(name)
    open(filepath, "a") do file
        if !isprobabilistic(grammar)
            println(file, "grammar_$name = @cfgrammar begin")
            for (type, rule) ∈ zip(grammar.types, grammar.rules)
                if typeof(rule) == String
                    println(file, "    $type = \"$rule\"")
                else
                    println(file, "    $type = $rule")
                end
            end
        else
            println(file, "grammar_$name = @pcfgrammar begin")
            for (type, rule, prob) ∈ zip(grammar.types, grammar.rules, grammar.log_probabilities)
                println(file, "    $(ℯ^prob) : $type = $rule")
            end
        end
        println(file, "end")
    end
end

"""
    parse_to_julia(path::String, filename::String, line_parser::Function, prefix::String="")::Problem

Parses a single problem file given a line parser and writes the Herb'ed problem to the output_path.
"""
function parse_to_julia(path::String, filename::String, line_parser::Function, prefix::String="")::Problem
    problem = parse_file(path * filename, line_parser)
    write_problem(path * "$(prefix)data.jl", problem, prefix)
end

"""
    enumerate_files(input_path::String, output_path::String, data_file_parser::Function, grammar_parser::Function)

Parses a directory for all files, parses each data file using `data_file_parser` and `grammar_parser`. Appends all data parsed to the `data.jl` in the output path by appending to that file. 

# Example

```julia
using HerbSpecification, HerbGrammar

using HerbBenchmarks

include("src/data/SyGuS/SyGuS.jl")
input_path = "../SyGuS/benchmarks/comp/2019/PBE_SLIA_Track/from_2019/"
module_path = "src/data/SyGuS/PBE_SLIA_Track_2019/"

enumerate_problem_files(input_path, module_path, parse_sygus_problem, parse_sygus_grammar)
```
"""
function enumerate_problem_files(input_path::String, output_path::String, data_file_parser::Function, grammar_parser::Function=s -> nothing)
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
        # Strip only the extension: `PRE_icfp_gen_1.15.sl` must become `PRE_icfp_gen_1_15`, not
        # `PRE_icfp_gen_1`. Splitting on the first '.' collapses 20 distinct problems onto one name.
        name = sanitize_name(first(splitext(file)))
        return_grammar = grammar_parser(input_path * file)
        if !isnothing(return_grammar)
            append_cfgrammar(output_path * "grammars.jl", name, return_grammar)
        end
        write_problem(output_path * "data.jl", data_file_parser(input_path * file), name, "a")
    end
end

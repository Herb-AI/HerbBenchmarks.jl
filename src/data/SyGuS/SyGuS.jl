module SyGuS

using Artifacts
using LazyArtifacts
using Serialization
using Pkg
using HerbSpecification
using HerbCore
using HerbGrammar
using ..HerbBenchmarks.SExpressionParser

export
    parse_sygus_grammar,
    parse_sygus_problem,
    parse_synth_fun,
    parse_example_constraint


"""
    parse_sygus_grammar(filename::AbstractString)::AbstractGrammar

Parses a SyGuS file for its grammar, by looking for the keyword 'synth-fun' within the S-Expressions. Returns the grammar if found.
"""
function parse_sygus_grammar(filename::AbstractString)::AbstractGrammar
    #@TODO this parser requires the input to be named `_arg_x`. This might not be the case for all problems
    symbol_list = SExpressionParser.parsefile(filename)

    for expr in symbol_list
        if expr.car == Symbol("synth-fun")
            return parse_synth_fun(expr)
        end
    end

    throw(ArgumentError("No grammar found in '$filename'"))
end

"""
    parse_sygus_problem(filename::AbstractString)::Problem

Parses a SyGuS file for all examples and returns them, wrapped in a [`HerbSpecification.Problem`](@ref)
"""
function parse_sygus_problem(filename::AbstractString)::Problem
    symbol_list = SExpressionParser.parsefile(filename)
    examples::Vector{IOExample} = Vector{IOExample}()

    for expr in symbol_list
        if expr[1] == Symbol("constraint") && expr[2][1] == :(=)
            push!(examples, parse_example_constraint(expr))
        end
    end
    return Problem(examples)
end

"""
    parse_synth_fun(sexpr::SExpressionParser.Cons)::AbstractGrammar

Parses a SyGuS grammar that are named `synth_fun` within SyGuS. Takes the S-Expression of the grammar and returns a [`@csgrammar`](@ref).
"""
function parse_synth_fun(sexpr::SExpressionParser.Cons)::AbstractGrammar
    return_grammar = @csgrammar begin end

    if sexpr.car !== Symbol("synth-fun")
        throw(ArgumentError("'$(sexpr.car)' is not a 'synth-fun'"))
    end

    for rule in sexpr[5]
        for val in rule[3]
            if typeof(val) == SExpressionParser.Cons || false
                add_rule!(return_grammar, Meta.parse("$(rule[1]) = $(polish_function_calls(val))"))
            else
                add_rule!(return_grammar, :($(rule[1]) = $(val)))
            end
        end
    end

    return return_grammar
end


function polish_function_calls(in::SExpressionParser.Cons)
    arguments = join(in[2:length(in)], ", ")
    new_function_call = "$(in[1])($arguments)"
    return new_function_call
end


"""
    function parse_example_constraint(sexpr::SExpressionParser.Cons)
    
Parses SyGuS example of the form (constraint (= (f arg1 arg2 ...) output)).
Returns IOExample with inputs named arg1, arg2, ...
"""
function parse_example_constraint(sexpr::SExpressionParser.Cons)
   # take the X of (constraint X)
   sexpr = sexpr[2]
   # take Function call and Output of (= FunctionCall Output)
   functionCall = sexpr[2]
   output = sexpr[3]

   inputs = Dict{Symbol,Any}()

   for arg_index in 2:length(functionCall)
        inputs[Symbol("_arg_$(arg_index-1)")] = functionCall[arg_index]
   end

   return IOExample(inputs, output)
end

function get_sygus_path()
    root_path = artifact"sygus"
    # within the root_path there should be some directory that is itself the root
    # of the git project, we want to return _that_ path
    sygus_path = only(filter(isdir, readdir(root_path; join=true)))

    return sygus_path
end

function get_bv_paths(year)
    sygus_path = get_sygus_path()
    yeardir = joinpath(sygus_path, "comp", "$year")
    
    @assert isdir(yeardir) "$yeardir doesn't exist"

    bv_path = joinpath(yeardir, "PBE_BV_Track")

    return filter(x -> splitext(x)[2] == ".sl", readdir(bv_path; join=true))
end

function get_bv_grammars(year)
    artifact_toml = find_artifacts_toml(@__FILE__)
    bv_grammars_hash = artifact_hash("bv_grammars", artifact_toml)

    if isnothing(bv_grammars_hash) || !artifact_exists(bv_grammars_hash)
        bv_grammars_hash = Pkg.Artifacts.create_artifact() do artifact_dir
            bv_paths = get_bv_paths(year)
            grammars = parse_sygus_grammar.(bv_paths[1:10])
            serialize(joinpath(artifact_dir, "bv_grammars.jls"), grammars)
        end

        Pkg.Artifacts.bind_artifact!(artifact_toml, "bv_grammars", bv_grammars_hash)
    end

    bv_grammars_path = artifact_path(bv_grammars_hash)

    return bv_grammars_path
end

end # module SyGuS

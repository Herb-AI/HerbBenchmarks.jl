module SyGuS

using HerbData
using HerbCore
using HerbGrammar

using SExpressions


export
    parse_sygus_grammar,
    parse_sygus_problem,
    parse_synth_fun,
    parse_example_constraint


function parse_sygus_grammar(filename::AbstractString)::Grammar
    symbol_list = SExpressions.Parser.parsefile(filename)
    grammar = Nothing

    for expr in symbol_list
        if expr[1] == Symbol("synth-fun")
            return parse_synth_fun(expr)
        end
    end

    throw(ArgumentError("No grammar found in '$filename'"))
end

function parse_sygus_problem(filename::AbstractString)::Problem
    symbol_list = SExpressions.Parser.parsefile(filename)
    examples::Vector{Example} = Vector{Example}()

    for expr in symbol_list
        if expr[1] == Symbol("constraint") && expr[2][1] == :(=)
            push!(examples, parse_example_constraint(expr))
        end
    end
    return Problem(examples)
end

function parse_synth_fun(sexpr::SExpressions.Lists.Cons)::Grammar
    return_grammar = @cfgrammar begin end

    if sexpr[1] !== Symbol("synth-fun")
        throw(ArgumentError("'$(sexpr[1])' is not a 'synth-fun'"))
    end

    for rule in sexpr[5]
        for val in rule[3]
            add_rule!(return_grammar, :($(rule[1]) = $(val)))
        end
    end

    return return_grammar
end


"""
    
Parses SyGuS example of the form (constraint (= (f arg1 arg2 ...) output)).
Returns IOExample with inputs named arg1, arg2, ...
"""
function parse_example_constraint(sexpr::SExpressions.Lists.Cons)
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

end # module SyGuS
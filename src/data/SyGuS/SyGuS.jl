module SyGuS

using HerbSpecification
using HerbCore
using HerbGrammar
using ..HerbBenchmarks.SExpressionParser

export
    parse_sygus_grammar,
    parse_sygus_problem,
    parse_synth_fun,
    parse_example_constraint,
    sygus_value


"""
    sygus_value(v)

Converts a raw SMT-LIB literal, as produced by [`SExpressionParser`](@ref), into its Julia value.

The parser hands back every non-string atom as a `Symbol`, so `#xb3cac86be739e234` arrives as
`Symbol("#xb3cac86be739e234")` rather than a number. Without this step the generated data would be
symbols, not the `UInt64`/`Int`/`Bool` values the interpreters expect.

Bitvector literals are fixed to `UInt64`: every `synth-fun` in the 2018 PBE_BV track declares
`(BitVec 64)` and every `#x` literal in it is 16 hex digits wide.
"""
function sygus_value(v)
    v isa Symbol || return v
    s = String(v)
    startswith(s, "#x") && return parse(UInt64, s[3:end], base=16)
    startswith(s, "#b") && return parse(UInt64, s[3:end], base=2)
    s == "true" && return true
    s == "false" && return false
    n = tryparse(Int, s)
    return isnothing(n) ? v : n
end


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
    sexpr_to_expr(sexpr, argmap::Dict{Symbol, Symbol})

Converts an S-expression into the equivalent Julia `Expr`, renaming the synthesised function's
parameters through `argmap`.

The conversion is structural rather than textual. The previous implementation rendered the call back
to a string and handed it to `Meta.parse`, which cannot represent operators in head position:
`(= ntInt ntInt)` became the string `"=(ntInt, ntInt)"` and threw a `ParseError`. That made 101 of
the 210 SLIA files unparseable. Building the `Expr` directly sidesteps the round-trip entirely; heads
that are not valid Julia identifiers (`str.++`, `=`) survive as symbols for the caller to rename.
"""
function sexpr_to_expr(sexpr, argmap::Dict{Symbol,Symbol})
    if sexpr isa SExpressionParser.Cons
        args = [sexpr_to_expr(sexpr[i], argmap) for i in 2:length(sexpr)]
        return Expr(:call, sexpr_to_expr(sexpr[1], argmap), args...)
    end
    sexpr isa Symbol && return get(argmap, sexpr, sexpr)
    return sexpr
end

"""
    synth_fun_argmap(sexpr::SExpressionParser.Cons)::Dict{Symbol, Symbol}

Maps the parameter names declared by a `synth-fun` onto the positional `_arg_1`, `_arg_2`, … names
that [`parse_example_constraint`](@ref) gives the inputs.

The declared names vary by track — the BV files call the parameter `x`, the SLIA files call it
`_arg_0` — so reading them off the signature is what keeps grammars and examples referring to the
same variable.
"""
function synth_fun_argmap(sexpr::SExpressionParser.Cons)::Dict{Symbol,Symbol}
    params = sexpr[3]
    return Dict{Symbol,Symbol}(
        params[i][1] => Symbol("_arg_$i") for i in 1:length(params)
    )
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

    argmap = synth_fun_argmap(sexpr)

    for rule in sexpr[5]
        for val in rule[3]
            add_rule!(return_grammar, Expr(:(=), rule[1], sexpr_to_expr(val, argmap)))
        end
    end

    return return_grammar
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
        inputs[Symbol("_arg_$(arg_index-1)")] = sygus_value(functionCall[arg_index])
   end

   return IOExample(inputs, sygus_value(output))
end

end # module SyGuS

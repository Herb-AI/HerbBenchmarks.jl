module PSB2_2021
using JSON
using HerbCore
using HerbGrammar
using HerbSpecification
using HerbInterpret

include("psb2_primitives.jl")
include("base_grammars.jl")
include("problem_grammars.jl")
include("grammar.jl")
include("data.jl")
include("program_examples.jl")
include("retrieve_all_tasks.jl")

export
    parse_line_json,
    write_psb2_problems_to_file,
    make_psb2_interpreter,
    get_interpreter,
    merge_grammar,
    prune_grammar,
    rule_index,
    expr_to_rulenode

"""
    make_psb2_interpreter(grammar::AbstractGrammar)

Build an interpreter for `grammar` with `HerbInterpret.make_interpreter`,
resolving the primitives of the grammar in this module. The interpreter maps a
`RuleNode` and the input dictionary of an `IOExample` to the output of the
program:

```julia
interpreter = make_psb2_interpreter(grammar_fizz_buzz)
interpreter(solution_fizz_buzz, problem_fizz_buzz.spec[1])         # "1"
interpreter(solution_fizz_buzz, problem_fizz_buzz.spec)            # all outputs
```
"""
make_psb2_interpreter(grammar::AbstractGrammar) =
    make_interpreter(grammar; target_module=PSB2_2021, cache_module=PSB2_2021)

const _INTERPRETERS = Dict{String,Any}()

"""
    get_interpreter(identifier::AbstractString)

The interpreter for the grammar of problem `identifier`, for example
`get_interpreter("fizz_buzz")`. Interpreters are built on first use and cached,
because building one generates and compiles a function.
"""
function get_interpreter(identifier::AbstractString)
    return get!(_INTERPRETERS, identifier) do
        grammar_name = Symbol("grammar_" * identifier)
        isdefined(PSB2_2021, grammar_name) ||
            throw(KeyError("No grammar found for problem $identifier"))
        make_psb2_interpreter(getfield(PSB2_2021, grammar_name))
    end
end

"""
    parse_line_json(line::AbstractString)::IOExample

Parse one line of a PSB2 json file into an `IOExample`. Inputs are named
`_arg_1, _arg_2, ...`; problems with several outputs get a `Dict` with the keys
`:output1, :output2, ...`, the same shape as the examples in `data.jl`.
"""
function parse_line_json(line::AbstractString)::IOExample
    js = JSON.parse(line)
    inputs = Dict{Symbol,Any}()
    outputs = Dict{Symbol,Any}()
    for (k, v) in js
        if startswith(k, "input")
            inputs[Symbol(replace(k, "input" => "_arg_"))] = v
        elseif startswith(k, "output")
            outputs[Symbol(k)] = v
        end
    end
    # Only four PSB2 problems have more than one output; the others return the
    # bare value instead of a one-element dictionary.
    output = length(outputs) == 1 ? outputs[:output1] : outputs
    return IOExample(inputs, output)
end

end # module PSB2_2021

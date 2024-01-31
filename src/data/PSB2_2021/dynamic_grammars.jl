### A Pluto.jl notebook ###
# v0.19.36

using Markdown
using InteractiveUtils

# ╔═╡ 55301ad1-79fa-4aa5-be52-0a370676a04a
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(temp=true)
	Pkg.add(["HerbGrammar", "HerbData", "HerbInterpret"])
	using HerbGrammar, HerbData, HerbInterpret, Pkg
	Pkg.add(PackageSpec(name="HerbSearch", rev="dev"))
	using HerbSearch
	import HerbInterpret.interpret
end

# ╔═╡ d27779de-b6ca-11ee-23ba-d7e0f026b436
g_char = @csgrammar begin
    # Start = State
    State = make_stacks()
    State = char_allfromstring(State)
    State = char_fromfloat(State)
    State = char_fromfloat(State)
    State = char_isletter(State)
    State = char_isdigit(State)
    State = char_iswhitespace(State)
    State = char_lowercase(State)
    State = char_uppercase(State)
end

# ╔═╡ 48cb4300-b021-49e1-a132-b1b0c9e69bac
g_gtm = @csgrammar begin
    State = make_stacks()
    State = init_gtm(State)
    State = ensure_instruction_map(State)
    State = load_track(State)
    State = dump_track(State)
    State = trace(State)
    State = gtm_left(State)
    State = gtm_right(State)
    State = gtm_inc_delay(State)
    State = gtm_dec_delay(State)
    State = gtm_dub1(State)
end

# ╔═╡ 2cd0fa21-625a-4be1-8130-af914781e414
function get_output_from_stack(output_id::Symbol, type_of_output::Symbol, state::Dict)
    """
    Adds the first value in the stack of the type_of_output to the output.

    For example, if the :char stack is ['a', 'b', 'c'], then the following
    call will add 'a' to the output with id `:output1`.

    `get_output_from_stack(:output1, char, state)`

    Args:
        output_id (Symbol): The output id to add the value to
        type_of_output (Symbol): The type of the output value
        state (Dict): The state of the program
    
    Returns:
        Dict: The state of the program
    """
    if length(state[type_of_output]) > 0
        state[output_id] = state[type_of_output][1]
    end
    return state
end

# ╔═╡ 0596f1db-7bea-469a-87f6-4eabf368c523
function make_input_output_grammar(e::IOExample, mod::Module) 
	grammar_input_output = @csgrammar begin end
	
	for input in e.in
		name = Symbol(input[1])
		@eval mod ($(name)) = x -> write_input_to_stack(Symbol($input[1]), $(input[2]), x)
		add_rule!(grammar_input_output, :(State = $name($(input[1]), $(input[2]), State)))
	end
	for output in e.out
		name = Symbol(output[1])
		@eval mod ($(name)) = x -> get_output_from_stack(Symbol($output[1]), $(typeof(output[2])), x)
		add_rule!(grammar_input_output, :(State = $name($(output[1]), $(typeof(output[2])), State)))
	end
	return grammar_input_output
end

# ╔═╡ 29f882d3-3a7c-412f-a332-e0b9210dfe98
function merge_grammar(gs::Vector{ContextSensitiveGrammar})
    new_grammar = @csgrammar begin end
    for g in gs
        for i in eachindex(g.rules)
            ex = :($(g.types[i]) = $(g.rules[i]))
            add_rule!(new_grammar, ex)
        end
    end
    return new_grammar
end

# ╔═╡ cd45a607-88c8-42a0-bdaf-1c60fa54f8de
e = IOExample(Dict(:input => 'a'), Dict(:output => true))

# ╔═╡ 5b015667-e498-483f-b71d-9e34812091b6
begin
	mod = Module(:GrammarImplementation)
	Base.include(mod, "grammars/custom_util.jl")
	Base.include(mod, "grammars/grammar_char.jl")
	Base.include(mod, "grammars/grammar_gtm.jl")
	# Base.include(mod, "grammars/util.jl")
	g = make_input_output_grammar(e, mod)
end

# ╔═╡ 5cdde027-15a1-4f4f-bab1-c06cb186f667
@eval mod output(char_isletter(input(make_stacks())))

# ╔═╡ d74a4f27-da1c-4968-9ff6-b91cfe0188fe
grammar_example = merge_grammar([g_char, g])

# ╔═╡ 75cd93ae-cbab-4126-94aa-be3d07b67117
tab = SymbolTable(grammar_example, mod)

# ╔═╡ 0ba60850-7311-4fa8-856f-f285cb536f5c
function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	println("Evaluating: ", expr)
	res = interpret(merge(tab, input), expr)
	println("Evaluated to: ", res)
	return res
end

# ╔═╡ e2dce1f6-d116-42b7-939a-9592a3b07632
[rulenode2expr(ex, grammar_example) for ex in get_bfs_enumerator(grammar_example, 2, 10, :State)]

# ╔═╡ fb717be5-0b4c-4899-bb6f-5b54eec290bc
sol = HerbSearch.search(grammar_example, Problem([e]), :State, max_depth=5,
	evaluator = my_evaluator,
	allow_evaluation_errors = true,
	mod = mod,
)

# ╔═╡ bc0dc1fd-89f6-4a65-882f-98185cbbc244
# ╠═╡ disabled = true
# ╠═╡ skip_as_script = true
#=╠═╡
function interpret(tab::SymbolTable, ex::Expr)
    if ex.head == :call
		println(ex.args[1])
		println(keys(tab))
        if ex.args[1] in keys(tab)
            if length(ex.args) > 1
                return @eval tab[ex.args[1]](interpret(tab, ex.args[2]))
            else
                return @eval tab[ex.args[1]](tab)
            end
        else
            throw(ArgumentError("Argument $(ex.args[1]) not present in symbol table."))
        end
    else
        throw(Error("Expression type not supported: $(ex.head)"))
    end
end
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═55301ad1-79fa-4aa5-be52-0a370676a04a
# ╠═d27779de-b6ca-11ee-23ba-d7e0f026b436
# ╠═48cb4300-b021-49e1-a132-b1b0c9e69bac
# ╟─2cd0fa21-625a-4be1-8130-af914781e414
# ╠═0596f1db-7bea-469a-87f6-4eabf368c523
# ╠═5cdde027-15a1-4f4f-bab1-c06cb186f667
# ╠═29f882d3-3a7c-412f-a332-e0b9210dfe98
# ╠═cd45a607-88c8-42a0-bdaf-1c60fa54f8de
# ╠═5b015667-e498-483f-b71d-9e34812091b6
# ╠═d74a4f27-da1c-4968-9ff6-b91cfe0188fe
# ╠═75cd93ae-cbab-4126-94aa-be3d07b67117
# ╠═0ba60850-7311-4fa8-856f-f285cb536f5c
# ╠═e2dce1f6-d116-42b7-939a-9592a3b07632
# ╠═fb717be5-0b4c-4899-bb6f-5b54eec290bc
# ╠═bc0dc1fd-89f6-4a65-882f-98185cbbc244

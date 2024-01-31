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
end;

# ╔═╡ 792e974b-4f40-42b5-8003-497a8aebb2a3
md"""
# Dynamic Grammars

The following is a small example of creating a dynamic grammar from an example we get from PSB2. An example might look like the following:
"""

# ╔═╡ c5da9f66-8796-445f-abd3-b2bd0f3cfbf9
e = IOExample(Dict(:input => 'a'), Dict(:output => true))

# ╔═╡ 90706d07-8d3f-4506-a251-d4fc7a09ed1d
md"""
We then define a grammar for the problem.
"""

# ╔═╡ d27779de-b6ca-11ee-23ba-d7e0f026b436
g_char = @csgrammar begin
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

# ╔═╡ 45b5e0db-0beb-4908-af60-7f13c492201d
md"""
Now, due to the nature of the `Push` language that the benchmark makes use of, we need to supplement this grammar with functions that push the input from the examples to the correct stack (just a vector that corresponds to the input's type) and pop from the correct stack to retrieve an output. We probably did not need to follow this pattern of `Push`, but we wanted to for the sake of ease of comparison with the orignal benchmark code.

To create the additional `input` and `output` functions for the grammar, we define `make_input_output_grammar(...)`.
"""

# ╔═╡ 0596f1db-7bea-469a-87f6-4eabf368c523
function make_input_output_grammar(e::IOExample, mod::Module) 
	grammar_input_output = @csgrammar begin end
	
	for input in e.in
		name = Symbol(input[1])
		@eval mod ($(name)) = x -> write_input_to_stack(Symbol($input[1]), $(input[2]), x)
		add_rule!(grammar_input_output, :(State = $name(State)))
	end
	for output in e.out
		name = Symbol(output[1])
		@eval mod ($(name)) = x -> get_output_from_stack(Symbol($output[1]), $(typeof(output[2])), x)
		add_rule!(grammar_input_output, :(State = $name(State)))
	end
	return grammar_input_output
end

# ╔═╡ 05839053-e82f-4db9-9776-db410b50c5ea
md"""
Now we can populate a custom module, `mod`, with the implementations for the character functions, and we can use our function defined above to add `input`/`output` functions.
"""

# ╔═╡ d83be944-e311-40dc-b822-67b623bc1ee5
md"""
Just as a sanity check, we can check that `output(char_isletter(input(make_stacks())))` evaluates successfully using the definitions for the functions supplied in mod.
"""

# ╔═╡ 3bca1c83-2d75-4707-a06e-838f29e176a6
md"""
Great! `:output => true`, so we're happy.
"""

# ╔═╡ c3919952-7bc8-4e93-9f35-50f151ff625f
md"""
One last thing before we can search. After a program is evaluated, we only want to compare against the `:output`s, not the `:string`, `:char`, etc., so we filter away all keys in the `res` `Dict` that do not contain output,
"""

# ╔═╡ 0ba60850-7311-4fa8-856f-f285cb536f5c
function my_evaluator(tab::SymbolTable, expr::Any, input::Dict)
	res = interpret(tab, expr)
    res = Dict(k => v for (k, v) in res if occursin("output", string(k)))
	return res
end

# ╔═╡ 955c1633-5a71-4307-bcbf-fa3d4e841764
md"""
and then a final check that `search(...)` actually finds what we want.
"""

# ╔═╡ d3784531-4877-425e-8a70-569681e4ffc3
md"""
As we expected, `sol == ` $(:(output(char_isletter(input(make_stacks()))))).

It works!
"""

# ╔═╡ 1dd8de38-73b9-4d9b-bcdf-a799060f780b
md"""
### Extra Stuff
"""

# ╔═╡ 2d2457f1-3f59-4f93-bb03-1ceab9765bbe
md"""
The only reason we need to use this temp package environment is to get access to the `mod` keyword for `search(...)` which isn't in the released version of `HerbSearch`.
"""

# ╔═╡ b1071747-1713-4f1e-9eb9-4c562ba221ae
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

# ╔═╡ b3275558-1559-4753-a9d1-5e846b93a747
begin
	mod = Module(:GrammarImplementation)
	Base.include(mod, "grammars/custom_util.jl")
	Base.include(mod, "grammars/grammar_char.jl")
	g = make_input_output_grammar(e, mod)
	g = merge_grammar([g_char, g])
end

# ╔═╡ 5cdde027-15a1-4f4f-bab1-c06cb186f667
@eval mod output(char_isletter(input(make_stacks())))

# ╔═╡ fb717be5-0b4c-4899-bb6f-5b54eec290bc
sol = HerbSearch.search(g, Problem([e]), :State, max_depth=5,
	evaluator = my_evaluator,
	allow_evaluation_errors = true,
	mod = mod,
)

# ╔═╡ Cell order:
# ╟─792e974b-4f40-42b5-8003-497a8aebb2a3
# ╟─c5da9f66-8796-445f-abd3-b2bd0f3cfbf9
# ╟─90706d07-8d3f-4506-a251-d4fc7a09ed1d
# ╟─d27779de-b6ca-11ee-23ba-d7e0f026b436
# ╟─45b5e0db-0beb-4908-af60-7f13c492201d
# ╠═0596f1db-7bea-469a-87f6-4eabf368c523
# ╟─05839053-e82f-4db9-9776-db410b50c5ea
# ╠═b3275558-1559-4753-a9d1-5e846b93a747
# ╟─d83be944-e311-40dc-b822-67b623bc1ee5
# ╠═5cdde027-15a1-4f4f-bab1-c06cb186f667
# ╠═3bca1c83-2d75-4707-a06e-838f29e176a6
# ╠═c3919952-7bc8-4e93-9f35-50f151ff625f
# ╠═0ba60850-7311-4fa8-856f-f285cb536f5c
# ╠═955c1633-5a71-4307-bcbf-fa3d4e841764
# ╠═fb717be5-0b4c-4899-bb6f-5b54eec290bc
# ╟─d3784531-4877-425e-8a70-569681e4ffc3
# ╟─1dd8de38-73b9-4d9b-bcdf-a799060f780b
# ╟─2d2457f1-3f59-4f93-bb03-1ceab9765bbe
# ╠═55301ad1-79fa-4aa5-be52-0a370676a04a
# ╠═b1071747-1713-4f1e-9eb9-4c562ba221ae

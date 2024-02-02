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
	include("grammar.jl")
end;

# ╔═╡ 792e974b-4f40-42b5-8003-497a8aebb2a3
md"""
# Dynamic Grammars

The following is a small example of creating a dynamic grammar from an example we get from PSB2. An example might look like the following:
"""

# ╔═╡ c5da9f66-8796-445f-abd3-b2bd0f3cfbf9
e = IOExample(Dict(:input => 'a'), Dict(:output => true))

# ╔═╡ 05839053-e82f-4db9-9776-db410b50c5ea
md"""
Now we can populate a custom module, `mod` to keep track of our scope. 
"""

mod = Module(:GrammarExample)
Base.include(mod, "grammars/custom_util.jl")
Base.include(mod, "grammars/grammar_char.jl")

# ╔═╡ 90706d07-8d3f-4506-a251-d4fc7a09ed1d
md"""
We then define a grammar for the problem, using the methods in `grammar.jl`, using our module `mod`. This will automatically also add the :input and :output symbols to our grammer based on example `e`. We will also use the character grammar
"""

# ╔═╡ d27779de-b6ca-11ee-23ba-d7e0f026b436
g = get_grammar(["char"], Problem([e]), mod)

# ╔═╡ d83be944-e311-40dc-b822-67b623bc1ee5
md"""
Just as a sanity check, we can check that `output(char_isletter(input(make_stacks())))` evaluates successfully using the definitions for the functions supplied in mod.
"""

# @eval mod output(char_isletter(input(make_stacks())))

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


# ╔═╡ fb717be5-0b4c-4899-bb6f-5b54eec290bc
sol = HerbSearch.search(g, Problem([e]), :State, max_depth=5,
	evaluator = my_evaluator,
	allow_evaluation_errors = true,
	mod = mod,
)
println(sol)

# ╔═╡ d3784531-4877-425e-8a70-569681e4ffc3
md"""
As we expected, `sol == ` $(:(output(char_isletter(input(make_stacks()))))).

It works!
"""

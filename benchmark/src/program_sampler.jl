# Random sampling of typed programs with a *prescribed* depth.
#
# `rand(RuleNode, grammar, max_depth)`-style samplers only bound the depth from
# above, which makes them useless here: the overwhelming majority of the samples
# they return are shallow, while we want to know how the interpreters behave at
# depths 5-15 specifically.
#
# The sampler below builds a tree whose depth is *exactly* `depth`. One child of
# every internal node is picked as the "spine" and is grown to `depth - 1`; the
# remaining children are grown to a shallow depth (controlled by `side_slack`).
# Without that the node count explodes doubly-exponentially in the depth and the
# programs stop resembling anything a search would ever enumerate.

"""
    DepthTable

Pre-computed reachability tables for a grammar, used by [`sample_program`](@ref).

For a nonterminal `typ`, a depth `d` and a *nesting budget* `b`:

- `exact[(typ, b)][d]` is true iff a tree with return type `typ` and depth
  exactly `d` exists that uses at most `b` rules from `limited` on any
  root-to-leaf path,
- `upto[(typ, b)][d]` is the same with depth `<= d`.

The nesting budget exists to keep loops under control: a `WHILE` nested inside
another `WHILE` multiplies the step bound of the generated interpreters
(`1000` iterations each), so a depth-15 program with four nested loops would run
for `10^12` steps. Limiting the nesting of those rules keeps the measurement
about the interpreter rather than about one pathological program.
"""
struct DepthTable
    maxdepth::Int
    nesting_limit::Int
    limited::Set{Int}
    exact::Dict{Tuple{Symbol,Int},BitVector}
    upto::Dict{Tuple{Symbol,Int},BitVector}
end

"""
    DepthTable(grammar; maxdepth, limited=Set{Int}(), nesting_limit=maxdepth)

Build the reachability tables for `grammar` by dynamic programming over depths
`1:maxdepth`.
"""
function DepthTable(
    g::AbstractGrammar;
    maxdepth::Int,
    limited::Set{Int} = Set{Int}(),
    nesting_limit::Int = maxdepth,
)
    nesting_limit = isempty(limited) ? 0 : min(nesting_limit, maxdepth)
    types = Symbol[t for t in keys(g.bytype) if t isa Symbol]

    exact = Dict{Tuple{Symbol,Int},BitVector}()
    upto = Dict{Tuple{Symbol,Int},BitVector}()
    for t in types, b in 0:nesting_limit
        exact[(t, b)] = falses(maxdepth)
        upto[(t, b)] = falses(maxdepth)
    end

    # Depths are filled in increasing order: the entry for depth `d` only ever
    # looks at entries for `d - 1`.
    for d in 1:maxdepth, t in types, b in 0:nesting_limit
        reachable = false
        for r in g.bytype[t]
            b2 = b - ((r in limited) ? 1 : 0)
            b2 < 0 && continue
            if isterminal(g, r)
                d == 1 || continue
            else
                d == 1 && continue
                ct = child_types(g, r)
                all(c -> upto[(c, b2)][d-1], ct) || continue
                any(c -> exact[(c, b2)][d-1], ct) || continue
            end
            reachable = true
            break
        end
        exact[(t, b)][d] = reachable
        upto[(t, b)][d] = reachable || (d > 1 && upto[(t, b)][d-1])
    end

    return DepthTable(maxdepth, nesting_limit, limited, exact, upto)
end

"""
    isreachable(tab::DepthTable, typ::Symbol, depth::Int)

Whether `sample_program` can produce a program of return type `typ` and the
given `depth`.
"""
function isreachable(tab::DepthTable, typ::Symbol, depth::Int)
    1 <= depth <= tab.maxdepth || return false
    key = (typ, tab.nesting_limit)
    haskey(tab.exact, key) || return false
    return tab.exact[key][depth]
end

"""
    sample_program(grammar, typ, depth, tab, rng; side_slack=1)

Sample a `RuleNode` of return type `typ` whose depth is exactly `depth`.

`side_slack` controls how bushy the tree is: non-spine children are grown to a
depth drawn from `[d_min, d_min + side_slack]`, where `d_min` is the shallowest
depth their type admits. `side_slack = 0` gives thin, spine-only programs;
larger values grow the node count quickly.
"""
function sample_program(
    g::AbstractGrammar,
    typ::Symbol,
    depth::Int,
    tab::DepthTable,
    rng::AbstractRNG;
    side_slack::Int = 1,
)
    isreachable(tab, typ, depth) || return nothing
    return _grow(g, typ, depth, tab.nesting_limit, tab, rng, side_slack)
end

function _grow(
    g::AbstractGrammar,
    typ::Symbol,
    d::Int,
    b::Int,
    tab::DepthTable,
    rng::AbstractRNG,
    slack::Int,
)
    candidates = Int[]
    for r in g.bytype[typ]
        b2 = b - ((r in tab.limited) ? 1 : 0)
        b2 < 0 && continue
        if isterminal(g, r)
            d == 1 && push!(candidates, r)
        elseif d > 1
            ct = child_types(g, r)
            all(c -> tab.upto[(c, b2)][d-1], ct) || continue
            any(c -> tab.exact[(c, b2)][d-1], ct) || continue
            push!(candidates, r)
        end
    end
    isempty(candidates) &&
        error("no rule for type $typ can produce depth $d with nesting budget $b")

    rule = candidates[rand(rng, eachindex(candidates))]
    isterminal(g, rule) && return RuleNode(rule)

    b2 = b - ((rule in tab.limited) ? 1 : 0)
    ct = child_types(g, rule)
    spine = [i for i in eachindex(ct) if tab.exact[(ct[i], b2)][d-1]]
    chosen = spine[rand(rng, eachindex(spine))]

    children = Vector{AbstractRuleNode}(undef, length(ct))
    for j in eachindex(ct)
        if j == chosen
            children[j] = _grow(g, ct[j], d - 1, b2, tab, rng, slack)
        else
            reach = tab.exact[(ct[j], b2)]
            dmin = findfirst(reach)::Int
            options = [dd for dd in dmin:min(d - 1, dmin + slack) if reach[dd]]
            target = options[rand(rng, eachindex(options))]
            children[j] = _grow(g, ct[j], target, b2, tab, rng, slack)
        end
    end
    return RuleNode(rule, children)
end

"""
    count_nodes(node::AbstractRuleNode)

Number of `RuleNode`s in the tree, i.e. the number of rule applications the
interpreter has to dispatch on.
"""
count_nodes(node::AbstractRuleNode) =
    1 + sum(count_nodes, get_children(node); init = 0)

"""
    tree_depth(node::AbstractRuleNode)

Depth of the tree, counting a leaf as depth 1.
"""
tree_depth(node::AbstractRuleNode) =
    1 + maximum(tree_depth, get_children(node); init = 0)

"""
    rules_matching(grammar, predicate) -> Set{Int}

Rule indices whose right-hand side satisfies `predicate`.
"""
rules_matching(g::AbstractGrammar, predicate) =
    Set{Int}(i for (i, rule) in pairs(g.rules) if predicate(rule))

"""
    loop_rules(grammar) -> Set{Int}

Rule indices that introduce a bounded loop, i.e. whose right-hand side is a call
to `WHILE`. These are the rules whose nesting the sampler restricts.
"""
loop_rules(g::AbstractGrammar) = rules_matching(
    g,
    rule -> rule isa Expr && rule.head === :call && rule.args[1] === :WHILE,
)

"""
    contains_rule(node, rules) -> Bool

Whether any node of the tree applies one of `rules`. Used to tell apart programs
that contain a bounded loop, since those cost orders of magnitude more to
evaluate than loop-free ones of the same size.
"""
function contains_rule(node::AbstractRuleNode, rules::Set{Int})
    get_rule(node) in rules && return true
    return any(c -> contains_rule(c, rules), get_children(node))
end

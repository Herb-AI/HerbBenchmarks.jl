using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

using HerbCore
using HerbGrammar
using HerbSpecification
using HerbInterpret: build_dispatch

# ---------------------------------------------------------------------------
# Shared helpers (same conventions as HerbInterpret.jl's make_interpret.jl)
# ---------------------------------------------------------------------------

_is_input_tag(tag, input_set) =
    tag isa Symbol && (occursin("_arg_", String(tag)) || (input_set !== nothing && (tag in input_set)))

_qualify(target_module::Module, f) = f isa Symbol ? GlobalRef(target_module, f) : f

_child(i::Int) = :( c[$i]::RuleNode )

"""
    _contains_conditional(x) -> Bool

True if `x` (a rule RHS, recursively) contains a Julia `if`/ternary
(`Expr(:if, ...)`) anywhere -- e.g. PBE_SLIA's `ntBool ? ntString : ntString`.

This is the one case the batched design below cannot handle by hoisting
children once and reusing them across all N examples: Julia's `if` (and the
ternary, which parses to the same `Expr(:if, ...)`) only evaluates its taken
branch. A plain function-call rule like PBE_BV's `im_cvc(Start, Start, Start)`
is *not* this case -- Julia already evaluates all of a function call's
arguments eagerly before the call, so the scalar interpreter is just as eager
on that rule as a batched one would be, and hoisting changes nothing. But a
genuine `Expr(:if, ...)` means hoisting-and-reusing would evaluate *both*
branches for every example regardless of which one each example actually
takes, which can raise an exception the scalar interpreter would never have
hit for that example (this is not hypothetical: `benchmark/README.md` already
documents `ite`-style short-circuiting as reducing the error rate at depth, so
it is exercised). Rules containing one are not batched at all; they delegate
to the scalar `fallback` interpreter, once per example (see
[`make_batched_interpreter`](@ref)), which preserves the exact short-circuit
behaviour by construction (it *is* the same code already doing that today).
"""
function _contains_conditional(x)
    x isa Expr || return false
    x.head === :if && return true
    return any(_contains_conditional, x.args)
end

"""
    _register_inputs!(x, input_set, names)

Walks `x` (a rule RHS, recursively) registering every input symbol (see
[`_is_input_tag`](@ref)) into `names`, in first-seen order, without
duplicates. Run for *every* rule, including ones that end up delegated to
`fallback` wholesale (see [`_contains_conditional`](@ref)) -- otherwise an
input symbol that only appears inside a delegated rule would never make it
into `names`, and the `NamedTuple` this module builds for `fallback` would be
missing a field `fallback`'s own generated code reads.
"""
function _register_inputs!(x, input_set, names::Vector{Symbol})
    if x isa Symbol
        _is_input_tag(x, input_set) && !(x in names) && push!(names, x)
    elseif x isa Expr
        foreach(a -> _register_inputs!(a, input_set, names), x.args)
    end
    return names
end

# ---------------------------------------------------------------------------
# Expression grammars: batched code generation
# ---------------------------------------------------------------------------

"""
    build_match_cases_batched(grammar, N; target_module=@__MODULE__, input_symbols=nothing)

The batched analogue of `HerbInterpret.build_match_cases`: returns
`(by_type, names)` with the same shape (one `rule_index => rhs_code` bucket
per nonterminal), but each nonterminal's generated function has signature
`(selves, fallback, prog, batched_input) -> NTuple{N,T}` instead of `(selves,
prog, input) -> T` -- it evaluates all `N` examples in one tree-walk rather
than walking the tree once per example, so the branch-dispatch cost (which of
a nonterminal's rules this node uses) is paid once per node instead of once
per node per example.

`batched_input` is a `NamedTuple` whose fields are themselves `NTuple{N}`s
(struct-of-arrays, not an array of the usual per-example `NamedTuple`s) --
field `x`'s `k`-th entry is example `k`'s value of `x`.

For a rule with no conditional anywhere in its RHS, the generated code:
1. calls each referenced child's nonterminal function *once* (`c1 = ...`,
   `c2 = ...`, ...), each returning an `NTuple{N,_}`;
2. builds the result as a tuple literal of `N` positions, each one the
   original rule's RHS expression with every child reference replaced by
   `cI[k]` and every input reference by `batched_input.x[k]`.

Critically, step 2 is `N` *literal* copies of the expression, not a single
`ntuple(k -> ..., N)` call: the latter is a closure, and constructing one
inside a plain, runtime-branching recursive function (as every nonterminal
function here is -- dispatch is still on `prog`'s *runtime* rule index, not on
`prog`'s Julia type, exactly as in `HerbInterpret.jl`) does not get optimized
away the way it would in a fully inlined, monomorphic context; measured
directly (`benchmark/README.md`'s "custom v2 (batched)" section), the
`ntuple`-closure version was over 50x slower and allocated per node, while `N`
literal copies allocate nothing and are the source of this design's whole
speed-up.

Rules containing a conditional (see [`_contains_conditional`](@ref)) are not
processed this way at all: they are collected into `pending` and, once `names`
is fully known (from *every* rule, conditional or not -- see
[`_register_inputs!`](@ref)), replaced with `N` individual calls to `fallback`
reconstructing each example's ordinary (not struct-of-arrays) `NamedTuple` on
the fly.
"""
function build_match_cases_batched(
    grammar::AbstractGrammar,
    N::Int;
    target_module::Module = @__MODULE__,
    input_symbols::Union{Nothing,AbstractVector{Symbol}} = nothing,
)
    input_set = input_symbols === nothing ? nothing : Set(input_symbols)
    names = Symbol[]

    function collect_children!(x, types_out::Vector{Symbol})
        if x isa Symbol
            x in grammar.types && push!(types_out, x)
        elseif x isa Expr
            foreach(a -> collect_children!(a, types_out), x.args)
        end
        return types_out
    end

    # Position-k copy of `x`, substituting child occurrence #i with `cI[k]`
    # and input symbol `s` with `batched_input.s[k]`.
    function emit_one(x, next_child::Base.RefValue{Int}, k::Int)
        if x isa Symbol
            if x in grammar.types
                i = next_child[]
                next_child[] += 1
                return :( $(Symbol(:c, i))[$k] )
            elseif _is_input_tag(x, input_set)
                return :( batched_input.$(x)[$k] )
            else
                return _qualify(target_module, x)
            end
        elseif x isa Expr
            return Expr(x.head, (emit_one(a, next_child, k) for a in x.args)...)
        else
            return x
        end
    end

    by_type = Dict{Symbol,Vector{Pair{Int,Any}}}()
    pending = Tuple{Int,Symbol}[]  # (rule index, nonterminal) needing fallback

    for (ind, rhs_rule) in pairs(grammar.rules)
        nt = grammar.types[ind]
        nt === nothing && continue

        _register_inputs!(rhs_rule, input_set, names)

        if _contains_conditional(rhs_rule)
            push!(pending, (ind, nt))
            continue
        end

        types_out = collect_children!(rhs_rule, Symbol[])
        hoists = [
            :( $(Symbol(:c, i)) = getfield(selves, $(QuoteNode(t)))(selves, fallback, $(_child(i)), batched_input) )
            for (i, t) in enumerate(types_out)
        ]
        copies = [emit_one(rhs_rule, Ref(1), k) for k in 1:N]
        rhs_code = isempty(hoists) ? Expr(:tuple, copies...) : Expr(:block, hoists..., Expr(:tuple, copies...))

        push!(get!(() -> Pair{Int,Any}[], by_type, nt), ind => rhs_code)
    end

    names_tuple = Tuple(names)
    for (ind, nt) in pending
        delegate_calls = [
            :( fallback(prog, NamedTuple{$(QuoteNode(names_tuple))}(($([:( batched_input.$(nm)[$k] ) for nm in names_tuple]...),))) )
            for k in 1:N
        ]
        push!(get!(() -> Pair{Int,Any}[], by_type, nt), ind => Expr(:tuple, delegate_calls...))
    end

    return by_type, names_tuple
end

"""
    GeneratedBatchedInterpreter{Selves,Fallback,Names,N}

The batched analogue of `HerbInterpret.GeneratedInterpreter`. `selves` is a
`NamedTuple{nonterminals}` of batched per-nonterminal functions (see
[`build_match_cases_batched`](@ref)); `fallback` is the ordinary (scalar,
one-example-at-a-time) interpreter for the *same* grammar, used by any rule
containing a conditional (see [`_contains_conditional`](@ref)); `types` is the
grammar's own `types` vector, as in `GeneratedInterpreter`; `Names` and `N` are
carried as type parameters for the same reason `GeneratedInterpreter` carries
`Names` -- so building the struct-of-arrays `batched_input` can be specialized
rather than discovering field names or `N` at every call.
"""
struct GeneratedBatchedInterpreter{Selves,Fallback,Names,N}
    selves::Selves
    fallback::Fallback
    types::Vector{Union{Nothing,Symbol}}
end

GeneratedBatchedInterpreter(selves::Selves, fallback::Fallback, types::AbstractVector,
        names::Tuple{Vararg{Symbol}}, n::Int) where {Selves,Fallback} =
    GeneratedBatchedInterpreter{Selves,Fallback,names,n}(selves, fallback, types)

# See `HerbInterpret._dispatch`'s docstring for why selection and call are
# fused into one `@generated` function rather than selecting into a local
# first: the same union-typed-call allocation applies here.
#
# `where {Selves,Fallback,Names,N}` names *every* type parameter of
# `GeneratedBatchedInterpreter`, not just `Selves` (which is all the generator
# body itself needs): measured, leaving `Fallback`/`Names`/`N` unconstrained
# (as `HerbInterpret._dispatch`'s analogous method can, since its
# `GeneratedStatefulInterpreter{Selves}` has no *other* parameters to leave
# unconstrained) made this function's return type infer as `Any` instead of
# the small `Union{...}` of each branch's own concrete type -- which is boxed,
# not free, exactly the allocation this fused-dispatch trick exists to avoid.
@generated function _dispatch_batched(
    gi::GeneratedBatchedInterpreter{Selves,Fallback,Names,N}, prog::HerbCore.AbstractRuleNode, batched_input,
) where {Selves,Fallback,Names,N}
    chain = :(error("No matching nonterminal for rule ", HerbCore.get_rule(prog)))
    for name in fieldnames(Selves)
        chain = :(nt === $(QuoteNode(name)) ?
            gi.selves.$(name)(gi.selves, gi.fallback, prog, batched_input) : $chain)
    end
    return quote
        nt = gi.types[HerbCore.get_rule(prog)]::Symbol
        $chain
    end
end

_one_input(ex::HerbSpecification.IOExample, x::Symbol) = ex.in[x]
_one_input(ex::AbstractDict{Symbol}, x::Symbol) = ex[x]

"""
    _as_batched_namedtuple(examples, ::Val{names}, ::Val{N}) where {names,N}

Converts a `Vector` of `N` examples (each an `IOExample` or
`AbstractDict{Symbol}`) to the struct-of-arrays `NamedTuple`
[`build_match_cases_batched`](@ref)'s generated code reads: field `x`'s `k`-th
entry is example `k`'s value of `x`. Run once per top-level call, exactly like
`HerbInterpret._as_namedtuple`.

`@generated` and fully unrolled (one `_one_input` call per `(name, position)`
pair written directly into the generated code), rather than the more obvious
`ntuple(j -> ntuple(k -> ..., N), length(names))`: measured, that nested
`ntuple`-of-closures allocated a fixed ~100-200 bytes *every top-level call*
regardless of program size, even with both lengths passed as `Val`s -- for a
shallow program (a few thousand bytes total), that is a substantial, pure-
overhead fraction of the whole call's cost. Unrolling at generation time (this
runs once per distinct `(names, N)`, not once per call) removes the closures
entirely, the same fix used for every per-node `ntuple` in this module.

(A further idea -- precomputing, once here, the `N` ordinary per-position
`NamedTuple`s a delegated/ternary node needs, instead of reconstructing them
at every delegate site reached -- was tried and measured *worse*: most
sampled programs hit zero or one such node, so paying the precompute
unconditionally on every call lost to paying reconstruction lazily, only when
a delegate site is actually reached. Reconstruction stays lazy, in
[`build_match_cases_batched`](@ref)'s `pending` loop.)
"""
@generated function _as_batched_namedtuple(examples::AbstractVector, ::Val{names}, ::Val{N}) where {names,N}
    cols = [Expr(:tuple, (:(_one_input(examples[$k], $(QuoteNode(nm)))) for k in 1:N)...) for nm in names]
    return quote
        length(examples) == $N ||
            error("this batched interpreter was built for $N examples, got $(length(examples))")
        NamedTuple{$(QuoteNode(names))}(($(cols...),))
    end
end

function (gi::GeneratedBatchedInterpreter{Selves,Fallback,Names,N})(
    prog::HerbCore.AbstractRuleNode, examples::AbstractVector,
) where {Selves,Fallback,Names,N}
    batched_input = _as_batched_namedtuple(examples, Val(Names), Val(N))
    return collect(_dispatch_batched(gi, prog, batched_input))
end

"""
    make_batched_interpreter(grammar, fallback; n_examples, input_symbols=nothing, target_module=@__MODULE__, cache_module=@__MODULE__)

Build a batched interpreter for `grammar`: evaluates a program against all
`n_examples` examples in one tree-walk rather than `n_examples` separate ones
(see [`build_match_cases_batched`](@ref) for how and why). `fallback` must be
an already-built `HerbInterpret.GeneratedInterpreter` for this *same* grammar
(and `target_module`) -- it is used, once per example, for any rule containing
a conditional, to preserve exact short-circuit behaviour.

Unlike `HerbInterpret.make_interpreter`, `n_examples` is baked into the
generated code at build time (every rule's code is written out `n_examples`
times -- see `build_match_cases_batched`'s docstring for why that is the whole
point, not an accident), so a batched interpreter only accepts example vectors
of exactly that length.
"""
function make_batched_interpreter(grammar::AbstractGrammar, fallback;
    n_examples::Int,
    input_symbols::Union{Nothing,AbstractVector{Symbol}} = nothing,
    target_module::Module = @__MODULE__,
    cache_module::Module = @__MODULE__,
)
    RuntimeGeneratedFunctions.init(cache_module)

    by_type, names = build_match_cases_batched(grammar, n_examples;
        target_module = target_module, input_symbols = input_symbols)

    nonterminals = Tuple(sort!(collect(keys(by_type))))

    cores = map(nonterminals) do nt
        # `HerbInterpret.build_dispatch` is just the flat `r == i && return
        # ...` cascade builder -- reused as-is, since the dispatch style
        # (branch on `prog`'s runtime rule index) is identical here, only the
        # branch *bodies* differ (see `build_match_cases_batched`).
        cascade = build_dispatch(by_type[nt])
        ex = :(function (selves, fallback, prog, batched_input)
            r = HerbCore.get_rule(prog)
            c = HerbCore.get_children(prog)
            $cascade
        end)
        Base.remove_linenums!(ex)
        RuntimeGeneratedFunctions.RuntimeGeneratedFunction(cache_module, target_module, ex)
    end

    selves = NamedTuple{nonterminals}(cores)
    return GeneratedBatchedInterpreter(selves, fallback, grammar.types, names, n_examples)
end

# ---------------------------------------------------------------------------
# Stateful grammars: batched code generation
# ---------------------------------------------------------------------------

"""
    build_match_cases_stateful_batched(grammar, N; target_module=@__MODULE__)

The batched analogue of `HerbInterpret.build_match_cases_stateful`. Generated
functions have signature `(selves, fallback, prog, batched_state) ->
NTuple{N,_}`, where `batched_state::NTuple{N,StateT}` (not struct-of-arrays --
states are opaque, so each position just carries its own whole state object).

Sequencing (`(Operation; Sequence)`), aliasing and 0-/n-arg primitive calls
(`moveRight()`, ...) batch exactly like the expression case: a referenced
child is called once (returning an `NTuple{N,_}`), and the rule's own
combination is written out as `N` literal copies.

`IF`/`WHILE` are *not* batched: both have exactly the same short-circuit
problem as a Julia ternary (`IF` only evaluates its taken branch; `WHILE`
iterates a *different* number of times per example, and most sampled programs'
loops exit almost immediately while a minority run the full 1000-iteration
bound -- see `benchmark/README.md` -- so forcing every example to iterate up
to whichever one happens to be slowest would be a severe regression, not just
a short-circuit correctness problem). Any `ControlStatement` rule (`IF` or
`WHILE`) delegates wholesale to `fallback`, once per example, via `prog`
itself -- `fallback`'s call convention already looks up which nonterminal
`prog` belongs to, so no special per-rule handling is needed beyond detecting
that this rule *is* one.

`state_type` is asserted (`fallback(...)::state_type`) on every delegated
call: `fallback`'s own call signature handles *any* nonterminal generically,
so without this its inferred return type is the union of everything it could
possibly return (here, `Union{Bool,state_type}`, since `Condition` rules
return `Bool`) -- even though a `ControlStatement` rule in particular always
returns `state_type`. Measured directly, that undeclared union was enough to
make the *whole* dispatch cascade's return type infer as `Any` rather than
the small, union-split-friendly `Union{NTuple{N,Bool},NTuple{N,state_type}}`
it should be, which cost a real, measurable allocation at every single node,
not just at `ControlStatement` ones -- the same class of problem `HerbCore`'s
`AbstractRuleNode` children already need a `::RuleNode` assertion for (see
`_child`'s docstring), just one level further out.
"""
function build_match_cases_stateful_batched(
    grammar::AbstractGrammar,
    N::Int;
    target_module::Module = @__MODULE__,
    state_type::Type = Any,
)
    by_type = Dict{Symbol,Vector{Pair{Int,Any}}}()

    hoisted_child(nt::Symbol, i::Int) =
        :( getfield(selves, $(QuoteNode(nt)))(selves, fallback, $(_child(i)), batched_state) )

    is_control(rhs_rule) =
        rhs_rule isa Expr && rhs_rule.head == :call && rhs_rule.args[1] in (:IF, :WHILE)

    for (ind, rhs_rule) in pairs(grammar.rules)
        nt = grammar.types[ind]
        nt === nothing && continue

        rhs_code = nothing

        if is_control(rhs_rule)
            rhs_code = Expr(:tuple, [:( fallback(prog, batched_state[$k])::$(state_type) ) for k in 1:N]...)

        elseif rhs_rule isa Expr && rhs_rule.head == :block
            a, b = rhs_rule.args[1], rhs_rule.args[2]
            rhs_code = quote
                s1 = $(hoisted_child(a, 1))
                $( :( getfield(selves, $(QuoteNode(b)))(selves, fallback, $(_child(2)), s1) ) )
            end

        elseif rhs_rule isa Expr && rhs_rule.head == :call && rhs_rule.args[1] == :(;)
            a, b = rhs_rule.args[2], rhs_rule.args[3]
            rhs_code = quote
                s1 = $(hoisted_child(a, 1))
                $( :( getfield(selves, $(QuoteNode(b)))(selves, fallback, $(_child(2)), s1) ) )
            end

        elseif rhs_rule isa Expr && rhs_rule.head == :call
            f    = rhs_rule.args[1]
            args = rhs_rule.args[2:end]

            if isempty(args)
                rhs_code = Expr(:tuple, [
                    Expr(:call, _qualify(target_module, f), :( batched_state[$k] )) for k in 1:N
                ]...)
            else
                hoists = [:( $(Symbol(:c, i)) = $(hoisted_child(args[i], i)) ) for i in eachindex(args)]
                copies = [
                    Expr(:call, _qualify(target_module, f),
                        (:( $(Symbol(:c, i))[$k] ) for i in eachindex(args))...)
                    for k in 1:N
                ]
                rhs_code = Expr(:block, hoists..., Expr(:tuple, copies...))
            end

        elseif rhs_rule isa Symbol
            if rhs_rule in grammar.types
                rhs_code = hoisted_child(rhs_rule, 1)
            else
                rhs_code = Expr(:tuple, [
                    Expr(:call, _qualify(target_module, rhs_rule), :( batched_state[$k] )) for k in 1:N
                ]...)
            end

        else
            rhs_code = Expr(:tuple, (rhs_rule for _ in 1:N)...)
        end

        push!(get!(() -> Pair{Int,Any}[], by_type, nt), ind => rhs_code)
    end

    return by_type
end

"""
    GeneratedBatchedStatefulInterpreter{Selves,Fallback,N}

The state-threading analogue of [`GeneratedBatchedInterpreter`](@ref); see
that struct and [`build_match_cases_stateful_batched`](@ref).
"""
struct GeneratedBatchedStatefulInterpreter{Selves,Fallback,N}
    selves::Selves
    fallback::Fallback
    types::Vector{Union{Nothing,Symbol}}
end

# See the expression-grammar `_dispatch_batched`'s comment just above its own
# definition for why every type parameter of `GeneratedBatchedStatefulInterpreter`
# is named here, not just `Selves`.
@generated function _dispatch_batched(
    gi::GeneratedBatchedStatefulInterpreter{Selves,Fallback,N}, prog::HerbCore.AbstractRuleNode, batched_state,
) where {Selves,Fallback,N}
    chain = :(error("No matching nonterminal for rule ", HerbCore.get_rule(prog)))
    for name in fieldnames(Selves)
        chain = :(nt === $(QuoteNode(name)) ?
            gi.selves.$(name)(gi.selves, gi.fallback, prog, batched_state) : $chain)
    end
    return quote
        nt = gi.types[HerbCore.get_rule(prog)]::Symbol
        $chain
    end
end

@generated function _as_batched_states(states::AbstractVector, ::Val{N}) where {N}
    elems = [:( states[$k] ) for k in 1:N]
    return quote
        length(states) == $N ||
            error("this batched interpreter was built for $N states, got $(length(states))")
        ($(elems...),)
    end
end

function (gi::GeneratedBatchedStatefulInterpreter{Selves,Fallback,N})(
    prog::HerbCore.AbstractRuleNode, states::AbstractVector,
) where {Selves,Fallback,N}
    batched_state = _as_batched_states(states, Val(N))
    return collect(_dispatch_batched(gi, prog, batched_state))
end

"""
    make_batched_stateful_interpreter(grammar, fallback; n_examples, target_module=@__MODULE__, cache_module=@__MODULE__)

The state-threading analogue of [`make_batched_interpreter`](@ref); see that
function and [`build_match_cases_stateful_batched`](@ref). `fallback` must be
an already-built `HerbInterpret.GeneratedStatefulInterpreter` for this same
grammar, used once per example for any `IF`/`WHILE` rule.

`state_type`, if given, is the concrete state type (e.g. `RobotState`) --
see [`build_match_cases_stateful_batched`](@ref)'s docstring for why passing
it matters, not just documents intent. There is no way to recover it from
`grammar` or `fallback` (neither carries it as a type parameter), so the
caller -- which already has a concrete state value in hand -- must supply it.
"""
function make_batched_stateful_interpreter(grammar::AbstractGrammar, fallback;
    n_examples::Int,
    target_module::Module = @__MODULE__,
    cache_module::Module = @__MODULE__,
    state_type::Type = Any,
)
    RuntimeGeneratedFunctions.init(cache_module)

    by_type = build_match_cases_stateful_batched(grammar, n_examples;
        target_module = target_module, state_type = state_type)
    nonterminals = Tuple(sort!(collect(keys(by_type))))

    cores = map(nonterminals) do nt
        cascade = build_dispatch(by_type[nt])
        ex = :(function (selves, fallback, prog, batched_state)
            r = HerbCore.get_rule(prog)
            c = HerbCore.get_children(prog)
            $cascade
        end)
        Base.remove_linenums!(ex)
        RuntimeGeneratedFunctions.RuntimeGeneratedFunction(cache_module, target_module, ex)
    end

    selves = NamedTuple{nonterminals}(cores)
    return GeneratedBatchedStatefulInterpreter{typeof(selves),typeof(fallback),n_examples}(
        selves, fallback, grammar.types)
end

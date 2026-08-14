"""
Grammars for DreamCoder's physical-law discovery domain.

Each task has its own arity and argument types, so — as in `DeepCoder_2016` —
each problem gets its own grammar: the shared core below plus one input rule
per argument, attached to the nonterminal recorded in `PROBLEM_SIGNATURES`.

`Start` admits both `Num` and `Vec` because roughly a third of the laws
(Newton's second law, Coulomb's law in vector form, momentum, ...) return a
vector while the rest return a scalar.
"""

"""
    _dreamcoder_physics_core()

The argument-agnostic core of the physics DSL: arithmetic over reals, plus the
vector algebra that DreamCoder learns during its abstraction phase.
"""
_dreamcoder_physics_core() = @cfgrammar begin
    Start = Num
    Start = Vec

    # Scalars --------------------------------------------------------------
    Num = 0.0
    Num = 1.0
    Num = 0.5
    Num = 2.0
    Num = dc_pi
    Num = dc_g
    Num = real_add(Num, Num)
    Num = real_sub(Num, Num)
    Num = real_mul(Num, Num)
    Num = real_div(Num, Num)
    Num = real_power(Num, Num)
    Num = real_sqrt(Num)
    Num = real_reciprocal(Num)
    Num = vec_norm(Vec)
    Num = vec_dot(Vec, Vec)
    Num = vec_sum_components(Vec)

    # Vectors --------------------------------------------------------------
    Vec = vec_add(Vec, Vec)
    Vec = vec_sub(Vec, Vec)
    Vec = vec_scale(Num, Vec)
    Vec = vec_cross(Vec, Vec)
    Vec = vec_unit(Vec)
    Vec = vec_zip_mul(Vec, Vec)
end

"""
    _add_list_rules!(g, nt)

Add the rules that consume a list argument. They are only added when the task
actually takes such an argument, so that no grammar carries a nonterminal it
has no way to derive.
"""
function _add_list_rules!(g::AbstractGrammar, nt::Symbol)
    if nt === :VecList
        add_rule!(g, :(Vec = vec_add_many(VecList)))
    elseif nt === :NumList
        add_rule!(g, :(Num = reals_sum(NumList)))
        add_rule!(g, :(Num = reals_reciprocal_sum(NumList)))
        add_rule!(g, :(NumList = reals_map_reciprocal(NumList)))
    end
    return g
end

"""
    dreamcoder_physics_grammar(signature::AbstractVector{Symbol})

Build a physics grammar for a task whose `i`-th argument has nonterminal
`signature[i]`; the argument becomes the rule `signature[i] = _arg_i`.
"""
function dreamcoder_physics_grammar(signature::AbstractVector{Symbol})
    g = _dreamcoder_physics_core()
    for nt in unique(signature)
        _add_list_rules!(g, nt)
    end
    for (i, nt) in enumerate(signature)
        add_rule!(g, Expr(:(=), nt, Symbol("_arg_", i)))
    end
    return g
end

# One grammar per problem, keyed off the generated signature table.
for (_ident, _sig) in PROBLEM_SIGNATURES
    @eval const $(Symbol("grammar_", _ident)) = dreamcoder_physics_grammar($_sig)
end

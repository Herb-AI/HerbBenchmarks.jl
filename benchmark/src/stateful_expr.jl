# A "stateful rulenode2expr": converts a program from a *stateful* grammar
# (Robots_2020, Pixels_2020, String_transformations_2020 -- where
# `Transformation = moveRight()` really means `moveRight(state)`, and
# `IF`/`WHILE` thread `state` through their branches) into a plain Julia `Expr`
# that threads `state` explicitly.
#
# `HerbGrammar.rulenode2expr` does not do this: applied to a stateful program it
# reproduces the grammar's zero-arg encoding verbatim (`moveRight()`), which is
# not runnable -- there is no 1-argument `moveRight()` method. The convention of
# passing `state` positionally into every primitive, and of threading it through
# `IF`/`WHILE`, is understood only by `HerbInterpret.build_match_cases_stateful`'s
# code generator. This file is the same dispatch, written as a tree-to-tree
# transform instead of inlined code generation, so that a plain `Expr` exists to
# hand to `Core.eval` and to `HerbInterpret.interpret`.

"""
    stateful_expr(node, grammar; state_sym=:state) -> Expr

The four cases mirror `build_match_cases_stateful` exactly:

- `(Operation; Sequence)` (RHS head `:block`) -> assign `state` to the
  `Operation`'s result, then continue with `Sequence`,
- `IF(cond, then, else)` -> a real `if`, all three arms reading/returning `state`,
- `WHILE(cond, body)` -> a real `while`, bounded at 1000 iterations like the
  generated interpreter,
- a primitive call -> `state` is spliced in as its (first and only) argument.

Aliases (`Start = Sequence`, `Sequence = Operation`, ...) pass through unchanged.
"""
function stateful_expr(node::AbstractRuleNode, g::AbstractGrammar; state_sym::Symbol = :state)
    rule = g.rules[get_rule(node)]
    c = get_children(node)

    if rule isa Expr && rule.head === :block
        return Expr(:block,
            Expr(:(=), state_sym, stateful_expr(c[1], g; state_sym)),
            stateful_expr(c[2], g; state_sym))

    elseif rule isa Expr && rule.head === :call && rule.args[1] === :IF
        return Expr(:if,
            stateful_expr(c[1], g; state_sym),
            stateful_expr(c[2], g; state_sym),
            stateful_expr(c[3], g; state_sym))

    elseif rule isa Expr && rule.head === :call && rule.args[1] === :WHILE
        cond = stateful_expr(c[1], g; state_sym)
        body = stateful_expr(c[2], g; state_sym)
        counter = gensym(:ctr)
        return quote
            local $counter = 1000
            while $counter > 0 && $cond
                $state_sym = $body
                $counter -= 1
            end
            $state_sym
        end

    elseif rule isa Expr && rule.head === :call
        f = rule.args[1]
        args = rule.args[2:end]
        isempty(args) && return Expr(:call, f, state_sym)
        return Expr(:call, f, (stateful_expr(ch, g; state_sym) for ch in c)...)

    elseif rule isa Symbol && rule in g.types
        return stateful_expr(c[1], g; state_sym)   # alias, e.g. Start = Sequence

    else
        error("stateful_expr: unsupported rule $(repr(rule))")
    end
end

"""
    contains_while(expr) -> Bool

Whether a [`stateful_expr`](@ref) tree contains a `while` loop.
`HerbInterpret.interpret` has no `:while` case (see `HerbInterpret.jl/src/interpreter.jl`),
so this tells the harness which programs its generic-interpreter baseline can
even attempt.
"""
contains_while(expr) = false
function contains_while(expr::Expr)
    expr.head === :while && return true
    return any(contains_while, expr.args)
end

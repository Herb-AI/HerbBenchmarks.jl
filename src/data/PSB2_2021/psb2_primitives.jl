"""
Primitives used by the PSB2 grammars, plus a few helpers to build and inspect
grammars.

# Conventions

* Inputs of a problem are `_arg_1, _arg_2, ...`, matching the keys of the
  `IOExample`s in `data.jl`. `HerbInterpret.make_interpreter` reads every
  terminal containing `_arg_` from the input dictionary.
* All primitives are *total*: dividing by zero, indexing out of bounds or
  parsing a non-number never throws. Enumerative search generates a lot of
  nonsense programs, and a benchmark that crashes on them is unusable. This
  mirrors PushGP, where such instructions are no-ops.
* Integer rules stay integer (`safe_div` floors), float rules stay float.

# Lambdas and loops

`make_interpreter` compiles every grammar rule on its own: a variable bound by
a lambda in one rule is not visible in the sub-expressions of another rule. To
still express `map`/`filter`/`while` over a variable, the variable is passed
through a small environment: the rule that introduces the lambda stores its
argument with [`bind_var!`](@ref), and the sub-expressions read it back with
[`int_var`](@ref) and friends:

```julia
List = map(x -> begin bind_var!(:x, x); IntRule end, List)
IntRule = int_var(:x)
```

Because binding happens on each call of the lambda, this evaluates correctly,
including when a `map` and a `while_loop` are nested. Two nested lambdas that
use the *same* variable name shadow each other, so the grammars use `:x`/`:y`
for element variables and `:s` for loop accumulators.
"""

# ---------------------------------------------------------------------------
# Lambda environment
# ---------------------------------------------------------------------------

"""
    PSB2_ENV

Environment holding the values of the variables bound by grammar lambdas.
See the module docstring of `psb2_primitives.jl`.
"""
const PSB2_ENV = Dict{Symbol,Any}()

"""
    bind_var!(name::Symbol, value)

Bind `name` to `value` for the duration of the enclosing grammar lambda.
"""
bind_var!(name::Symbol, value) = (PSB2_ENV[name] = value; value)

"""
    int_var(name::Symbol)
    float_var(name::Symbol)
    string_var(name::Symbol)
    list_var(name::Symbol)

Read back a variable bound by [`bind_var!`](@ref), as an integer, float, string
or list. The value is converted to that type, and an unbound variable reads as
the neutral value of the type. Search generates programs that read a lambda
variable outside of its lambda, or that read an integer variable where a string
is expected; those have to evaluate to *something* rather than throw.
"""
int_var(name::Symbol) = _to_int(get(PSB2_ENV, name, 0))
float_var(name::Symbol) = to_float(get(PSB2_ENV, name, 0.0))
string_var(name::Symbol) = string(get(PSB2_ENV, name, ""))
list_var(name::Symbol) = (v = get(PSB2_ENV, name, []); v isa AbstractVector ? v : [])

"""
    clear_vars!()

Forget all variables bound by [`bind_var!`](@ref).
"""
clear_vars!() = (empty!(PSB2_ENV); nothing)

"""
    while_loop(init, cond, body, max_steps::Int=1000)

Loop `body` over an accumulator, starting from `init`, for as long as `cond`
holds. Terminates after at most `max_steps` iterations, so that a program with
a non-terminating loop still returns a value instead of hanging the search.
"""
function while_loop(init, cond, body, max_steps::Int=1000)
    state = init
    steps = 0
    while steps < max_steps && cond(state) === true
        state = body(state)
        steps += 1
    end
    return state
end

# ---------------------------------------------------------------------------
# Total arithmetic
# ---------------------------------------------------------------------------

"""
    safe_div(a, b)

Integer division rounding towards `-Inf`. Returns `0` if `b == 0`.
"""
safe_div(a, b) = b == 0 ? 0 : Int(fld(_to_int(a), _to_int(b)))

"""
    safe_mod(a, b)

Modulo with the sign of the divisor (`mod`). Returns `0` if `b == 0`.
"""
safe_mod(a, b) = b == 0 ? 0 : Int(mod(_to_int(a), _to_int(b)))

"""
    safe_pow(a, b)

`a^b` as an integer, with a bounded exponent to avoid overflow and the
`DomainError` of a negative integer exponent. Returns `0` when the exponent is
negative.
"""
function safe_pow(a, b)
    a, b = _to_int(a), _to_int(b)
    b < 0 && return 0
    b > 32 && (b = 32)
    return a^b
end

"""
    safe_fdiv(a, b)

Float division. Returns `0.0` if `b == 0`.
"""
safe_fdiv(a, b) = b == 0 ? 0.0 : float(a) / float(b)

"""
    safe_sqrt(a)

Square root of `abs(a)`, so that it is defined for negative inputs as well.
"""
safe_sqrt(a) = sqrt(abs(float(a)))

"""
    safe_log(a, base=ℯ)

Logarithm that returns `0.0` for non-positive arguments.
"""
safe_log(a) = a <= 0 ? 0.0 : log(float(a))
safe_log(a, base) = (a <= 0 || base <= 0 || base == 1) ? 0.0 : log(float(base), float(a))

"""
    to_int(x)

Convert `x` (a number, `Bool`, `Char` or `String`) to an `Int`. Returns `0`
when the value cannot be converted, e.g. for a string that is not a number.
"""
to_int(x) = _to_int(x)

_to_int(x::Integer) = Int(x)
_to_int(x::Bool) = x ? 1 : 0
_to_int(x::AbstractFloat) = isfinite(x) ? Int(floor(x)) : 0
_to_int(x::Char) = Int(x)
_to_int(x::AbstractString) = something(tryparse(Int, strip(x)), 0)
_to_int(x) = 0

"""
    to_float(x)

Convert `x` to a `Float64`, returning `0.0` when that is not possible.
"""
to_float(x::Number) = float(x)
to_float(x::Bool) = x ? 1.0 : 0.0
to_float(x::AbstractString) = something(tryparse(Float64, strip(x)), 0.0)
to_float(x::Char) = float(Int(x))
to_float(x) = 0.0

"""
    to_bool(x)

Truthiness of `x`: numbers are true when non-zero, strings and lists when
non-empty.
"""
to_bool(x::Bool) = x
to_bool(x::Number) = x != 0
to_bool(x::AbstractString) = !isempty(x)
to_bool(x::AbstractVector) = !isempty(x)
to_bool(x) = false

# ---------------------------------------------------------------------------
# Lists
# ---------------------------------------------------------------------------

"""
    sublist(list, i, j)

`list[i:j]` with both indices clamped to the bounds of `list`, so it never
throws. Indices are 1-based.
"""
function sublist(list, i, j)
    n = length(list)
    i = clamp(_to_int(i), 1, n + 1)
    j = clamp(_to_int(j), 0, n)
    return list[i:j]
end

"""
    list_ref(list, i, default=0)

`list[i]`, returning `default` when `i` is out of bounds. 1-based.
"""
function list_ref(list, i, default=0)
    i = _to_int(i)
    return 1 <= i <= length(list) ? list[i] : default
end

"""
    list_first(list, default=0)
    list_last(list, default=0)

First/last element of `list`, or `default` if `list` is empty.
"""
list_first(list, default=0) = isempty(list) ? default : first(list)
list_last(list, default=0) = isempty(list) ? default : last(list)

"""
    map_pairs(f, a, b)

Apply `f` element-wise to two lists, stopping at the shorter one.
"""
map_pairs(f, a, b) = [f(x, y) for (x, y) in zip(a, b)]

"""
    index_of(x, list)

1-based index of the first occurrence of `x` in `list`, or `0` if absent.
"""
index_of(x, list) = something(findfirst(isequal(x), list), 0)

"""
    list_push(list, x)

Copy of `list` with `x` appended.
"""
list_push(list, x) = vcat(list, [x])

"""
    list_concat(a, b)

Concatenation of two lists.
"""
list_concat(a, b) = vcat(a, b)

"""
    list_max(list, default=0)
    list_min(list, default=0)

Maximum/minimum of `list`, or `default` if `list` is empty.
"""
list_max(list, default=0) = isempty(list) ? default : maximum(list)
list_min(list, default=0) = isempty(list) ? default : minimum(list)

"""
    list_sum(list)

Sum of `list`, `0` for an empty list.
"""
list_sum(list) = isempty(list) ? 0 : sum(list)

"""
    range_list(a, b)

The list `[a, a+1, ..., b]`, empty when `b < a`, and truncated to 10000
elements so that search cannot allocate unbounded memory.
"""
function range_list(a, b)
    a, b = _to_int(a), _to_int(b)
    b = min(b, a + 9999)
    return collect(a:b)
end

# ---------------------------------------------------------------------------
# Strings and characters
# ---------------------------------------------------------------------------

"""
    char_at(str, i, default=' ')

`i`-th character of `str` (1-based), or `default` when out of bounds.
"""
function char_at(str, i, default=' ')
    cs = collect(str)
    i = _to_int(i)
    return 1 <= i <= length(cs) ? cs[i] : default
end

"""
    char_of(i)

The ASCII character with code point `i`, clamped to the printable range so
that it is defined for every integer.
"""
char_of(i) = Char(clamp(_to_int(i), 32, 126))

"""
    substring(str, i, j)

`str[i:j]` in characters, with both indices clamped, so it never throws.
1-based and inclusive.
"""
function substring(str, i, j)
    cs = collect(str)
    n = length(cs)
    i = clamp(_to_int(i), 1, n + 1)
    j = clamp(_to_int(j), 0, n)
    return join(cs[i:j])
end

"""
    replace_in_string(str, i, char)

Copy of `str` with the character at position `i` (1-based) replaced by `char`.
Returns `str` unchanged when `i` is out of bounds.
"""
function replace_in_string(str, i, char)
    cs = collect(str)
    i = _to_int(i)
    1 <= i <= length(cs) || return String(str)
    cs[i] = char isa Char ? char : first(string(char))
    return join(cs)
end

"""
    str_index_of(haystack, needle)

1-based index of the first occurrence of `needle` in `haystack`, `0` if absent.
"""
function str_index_of(haystack, needle)
    isempty(needle) && return 0
    r = findfirst(needle, haystack)
    return r === nothing ? 0 : first(r)
end

"""
    str_count(haystack, needle)

Number of (possibly overlapping) occurrences of `needle` in `haystack`.
"""
function str_count(haystack, needle)
    isempty(needle) && return 0
    cs, ns = collect(haystack), collect(needle)
    n, m = length(cs), length(ns)
    m > n && return 0
    return count(i -> view(cs, i:i+m-1) == ns, 1:(n-m+1))
end

"""
    split_string(str, sep)

Split `str` on `sep`, dropping empty pieces.
"""
split_string(str, sep) = String.(filter(!isempty, split(str, sep)))

"""
    join_string(list, sep)

Join `list` into a single string, separated by `sep`.
"""
join_string(list, sep) = join(list, sep)

"""
    char_to_digit(c)

Digit value of a character, or `0` for a non-digit.
"""
char_to_digit(c::Char) = isdigit(c) ? Int(c) - Int('0') : 0
char_to_digit(x) = 0

"""
    string_to_chars(str)

The characters of `str` as a list.
"""
string_to_chars(str) = collect(str)

"""
    is_whitespace(c)

Whether `c` is a whitespace character. (`Base.isspace` under a name that
matches the other `is*` predicates of the grammar.)
"""
is_whitespace(c::Char) = isspace(c)
is_whitespace(x) = false

# ---------------------------------------------------------------------------
# Grammar helpers
# ---------------------------------------------------------------------------

"""
    PSB2_NONTERMINALS

The non-terminals used by the PSB2 grammars. A name in here is never a
variable, which is what lets [`prune_grammar`](@ref) tell a rule with a child
of type `Character` apart from a rule reading a variable named `Character`,
also in a grammar that has no `Character` rules at all.
"""
const PSB2_NONTERMINALS = Set{Symbol}([:Return, :IntRule, :Float, :Boolean, :Character, :String, :List])

"""
    merge_grammar(gs::Vector{<:AbstractGrammar}; start::Union{Nothing,Symbol}=nothing)

Merge several grammars into one, keeping the order of the rules and dropping
duplicated `type = rule` pairs. Duplicates would otherwise double the search
space without adding programs.

When `start` is given, the result is additionally pruned with
[`prune_grammar`](@ref). That is what makes the base grammars composable: they
may mention types (`Float`, `Character`, ...) that a given problem does not
use, and the rules that do are removed when they are merged.
"""
function merge_grammar(gs::Vector{<:AbstractGrammar}; start::Union{Nothing,Symbol}=nothing)
    merged = ContextSensitiveGrammar()
    seen = Set{Tuple{Symbol,Any}}()
    for g in gs
        for i in eachindex(g.rules)
            key = (g.types[i], g.rules[i])
            key in seen && continue
            push!(seen, key)
            add_rule!(merged, :($(g.types[i]) = $(g.rules[i])))
        end
    end
    start === nothing && return merged
    known = union(PSB2_NONTERMINALS, Set{Symbol}(t for g in gs for t in g.types))
    return prune_grammar(merged, start; known_types=known)
end

"""
    prune_grammar(grammar::AbstractGrammar, start::Symbol=:Return; known_types=Set(grammar.types))

Remove the rules that can never take part in a program derived from `start`:

1. rules that mention a non-terminal without productions (a program using them
   could never be completed), and
2. rules whose left-hand side is not reachable from `start`.

`known_types` are the names to treat as non-terminals. This matters because a
non-terminal that has no production in the grammar is indistinguishable from a
variable: `String = string(Character)` parses as a rule with a child of type
`Character` in a grammar that has `Character` rules, and as a *terminal* rule
reading a variable called `Character` in one that has not. Such a rule has to
be dropped, not kept as a terminal, which is why `merge_grammar` passes the
non-terminals of all the grammars it merges.

Returns a new grammar; `grammar` is left untouched.
"""
function prune_grammar(grammar::AbstractGrammar, start::Symbol=:Return;
    known_types::AbstractSet{Symbol}=Set{Symbol}(grammar.types))

    mentioned = [_mentioned_types(rule, known_types) for rule in grammar.rules]
    keep = trues(length(grammar.rules))

    # 1. A type is derivable if it has a rule that only mentions derivable
    #    types; iterate to a fixed point.
    derivable = Set{Symbol}()
    changed = true
    while changed
        changed = false
        for i in eachindex(grammar.rules)
            grammar.types[i] in derivable && continue
            if all(t -> t in derivable, mentioned[i])
                push!(derivable, grammar.types[i])
                changed = true
            end
        end
    end
    for i in eachindex(grammar.rules)
        keep[i] = all(t -> t in derivable, mentioned[i])
    end

    # 2. Keep only rules of types reachable from the start symbol.
    reachable = Set{Symbol}([start])
    changed = true
    while changed
        changed = false
        for i in eachindex(grammar.rules)
            keep[i] && grammar.types[i] in reachable || continue
            for t in mentioned[i]
                if !(t in reachable)
                    push!(reachable, t)
                    changed = true
                end
            end
        end
    end

    pruned = ContextSensitiveGrammar()
    for i in eachindex(grammar.rules)
        keep[i] && grammar.types[i] in reachable || continue
        add_rule!(pruned, :($(grammar.types[i]) = $(grammar.rules[i])))
    end
    return pruned
end

"""
    _mentioned_types(rule, known_types)

The non-terminals occurring anywhere in the right-hand side `rule`.
"""
function _mentioned_types(rule, known::AbstractSet{Symbol})
    types = Set{Symbol}()
    _collect_types!(types, rule, known)
    return types
end

function _collect_types!(types, x, known)
    if x isa Symbol
        x in known && push!(types, x)
    elseif x isa Expr
        for a in x.args
            _collect_types!(types, a, known)
        end
    end
    return types
end

"""
    rule_index(grammar::AbstractGrammar, rule; type::Union{Nothing,Symbol}=nothing)

Index of the production with right-hand side `rule` (and left-hand side `type`,
if given). Throws when the rule does not occur in the grammar, or when it is
ambiguous because it occurs under several types.
"""
function rule_index(grammar::AbstractGrammar, rule; type::Union{Nothing,Symbol}=nothing)
    rule = rule isa Expr ? Base.remove_linenums!(deepcopy(rule)) : rule
    hits = findall(eachindex(grammar.rules)) do i
        (type === nothing || grammar.types[i] === type) && _same_rule(grammar.rules[i], rule)
    end
    isempty(hits) && throw(ArgumentError("Rule $rule is not in the grammar"))
    length(hits) > 1 && type === nothing &&
        throw(ArgumentError("Rule $rule occurs under several types, pass `type=`"))
    return first(hits)
end

# Rules are compared including their type: `0` and `0.0`, or `1` and `true`,
# are equal under `==` but are different grammar rules.
_same_rule(a, b) = typeof(a) === typeof(b) && isequal(a, b)

"""
    expr_to_rulenode(grammar::AbstractGrammar, type::Symbol, expr)

Convert a concrete Julia expression into the `RuleNode` deriving it from
`type`. This is the inverse of `HerbGrammar.rulenode2expr` and is used to write
down the example solutions of `program_examples.jl` as plain Julia code:

```julia
expr_to_rulenode(grammar_gcd, :Return, :(safe_mod(_arg_1, _arg_2)))
```

Rules are tried from the most specific (fewest non-terminals) to the least
specific, so `IntRule = IntRule + 1` is preferred over `IntRule = IntRule +
IntRule` for the expression `x + 1`. Throws an `ArgumentError` when the
expression cannot be derived, which makes it a check that a program is inside
the grammar.
"""
function expr_to_rulenode(grammar::AbstractGrammar, type::Symbol, expr)
    expr = expr isa Expr ? Base.remove_linenums!(deepcopy(expr)) : expr
    node = _expr_to_rulenode(grammar, type, expr)
    node === nothing && throw(ArgumentError("Expression $expr cannot be derived from $type"))
    return node
end

function _expr_to_rulenode(grammar::AbstractGrammar, type::Symbol, expr, depth::Int=0)
    # Guard against unit rules of the shape `A = B`, `B = A`, which would make
    # the search for a derivation loop forever.
    depth > 32 && return nothing
    candidates = findall(i -> grammar.types[i] === type, eachindex(grammar.rules))
    sort!(candidates, by=i -> length(grammar.childtypes[i]))
    for i in candidates
        children = AbstractRuleNode[]
        if _match_rule(grammar, grammar.rules[i], expr, children, depth)
            return RuleNode(i, children)
        end
    end
    return nothing
end

_nonterminals(grammar::AbstractGrammar) = Set{Symbol}(grammar.types)

function _match_rule(grammar::AbstractGrammar, pattern, expr, children::Vector{AbstractRuleNode}, depth::Int=0)
    if pattern isa Symbol && pattern in _nonterminals(grammar)
        child = _expr_to_rulenode(grammar, pattern, expr, depth + 1)
        child === nothing && return false
        push!(children, child)
        return true
    elseif pattern isa Expr
        expr isa Expr || return false
        pattern.head === expr.head || return false
        length(pattern.args) == length(expr.args) || return false
        return all(pe -> _match_rule(grammar, pe[1], pe[2], children, depth), zip(pattern.args, expr.args))
    else
        return _same_rule(pattern, expr)
    end
end

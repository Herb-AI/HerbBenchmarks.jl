"""
Grammars for DreamCoder's list-processing domain.

DreamCoder searches a typed lambda calculus in which `map`, `filter`, `fold`
and `unfold` take arbitrary synthesised functions. A Herb grammar is
context-free over first-order Julia expressions, so the higher-order arguments
come from dedicated *function-valued* nonterminals: `NumFun` and `BoolFun`
derive combinators such as `dc_add(Num)` — which evaluates to the function
`x -> x + n` with `n` drawn from the grammar itself — and `dc_compose` keeps
that family closed under composition. The result stays genuinely higher-order
rather than collapsing to a fixed menu of specialised operators.

Every problem gets its own grammar, following `DeepCoder_2016`, so that
`get_grammar` never has to fall back to a module-wide default. The two
problems whose input is an integer rather than a list (`fibonacci` and
`range`) get the input rule at `Num` instead of `List`.
"""

"""
    _dreamcoder_list_core()

The input-agnostic core of the list DSL, mirroring `bootstrapTarget_extra()`
in `dreamcoder/domains/list/listPrimitives.py`.
"""
_dreamcoder_list_core() = @cfgrammar begin
    Start = Num
    Start = List
    Start = Bool
    Start = BoolList

    # Integers -------------------------------------------------------------
    Num = 0
    Num = 1
    Num = Num + Num
    Num = Num - Num
    Num = Num * Num
    Num = dc_mod(Num, Num)
    Num = dc_car(List)
    Num = dc_length(List)
    Num = dc_index(Num, List)
    Num = dc_fold(List, Num, NumFold)
    Num = Bool ? Num : Num

    # Booleans -------------------------------------------------------------
    Bool = dc_gt(Num, Num)
    Bool = dc_eq(Num, Num)
    Bool = dc_is_empty(List)
    Bool = dc_is_prime(Num)
    Bool = dc_is_square(Num)
    Bool = dc_all(BoolFun, List)
    Bool = dc_any(BoolFun, List)

    # Lists ----------------------------------------------------------------
    List = dc_empty
    List = dc_cons(Num, List)
    List = dc_cdr(List)
    List = dc_append(List, List)
    List = dc_range(Num)
    List = dc_map(NumFun, List)
    List = dc_filter(BoolFun, List)
    List = dc_fold(List, List, ListFold)
    List = dc_unfold(Num, BoolFun, NumFun, NumFun)
    List = Bool ? List : List

    BoolList = dc_map(BoolFun, List)

    # Function-valued nonterminals ----------------------------------------
    NumFun = dc_identity
    NumFun = dc_add(Num)
    NumFun = dc_sub(Num)
    NumFun = dc_rsub(Num)
    NumFun = dc_mul(Num)
    NumFun = dc_modulo(Num)
    NumFun = dc_const(Num)
    NumFun = dc_compose(NumFun, NumFun)

    BoolFun = dc_is_prime
    BoolFun = dc_is_square
    BoolFun = dc_greater_than(Num)
    BoolFun = dc_less_than(Num)
    BoolFun = dc_equal_to(Num)
    BoolFun = dc_divisible_by(Num)
    BoolFun = dc_negate(BoolFun)

    NumFold = dc_add2
    NumFold = dc_sub2
    NumFold = dc_mul2
    NumFold = dc_max2
    NumFold = dc_min2

    ListFold = dc_cons
    ListFold = dc_snoc
    ListFold = dc_cons_map(NumFun)
    ListFold = dc_cons_if(BoolFun)
end

"""
    dreamcoder_list_grammar(input_type::Symbol)

Build a list-domain grammar whose single input rule `_arg_1` is attached to
nonterminal `input_type` (`:List` or `:Num`).
"""
function dreamcoder_list_grammar(input_type::Symbol)
    g = _dreamcoder_list_core()
    add_rule!(g, Expr(:(=), input_type, :_arg_1))
    return g
end

"""
The two tasks in `list_tasks.json` that consume an integer rather than a list.
"""
const INT_INPUT_PROBLEMS = Set(["081_fibonacci", "155_range"])

# Bind a grammar for every problem defined in `data.jl`.
for _name in names(@__MODULE__; all=true)
    _s = string(_name)
    startswith(_s, "problem_") || continue
    _ident = _s[9:end]
    @eval const $(Symbol("grammar_", _ident)) =
        dreamcoder_list_grammar($(_ident in INT_INPUT_PROBLEMS ? QuoteNode(:Num) : QuoteNode(:List)))
end

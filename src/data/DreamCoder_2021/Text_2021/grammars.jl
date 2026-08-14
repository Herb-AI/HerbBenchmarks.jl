"""
Grammars for DreamCoder's text-editing domain.

Tasks differ in arity — most map one string to a string, some take two — and
in the string constants they need, so each problem gets its own grammar: the
shared core below, one input rule per argument, and one `Str` rule per
constant that `guessConstantStrings` recovered for that task.

Those constants matter. Tasks like "Prepend 'Alan'" cannot be solved without
the literal, and DreamCoder does not expect them to be: it hands each task its
likely constants up front, and `PROBLEM_CONSTANTS` carries the same
information here.
"""

"""
    _dreamcoder_text_core()

The arity- and constant-agnostic core of the text DSL.
"""
_dreamcoder_text_core() = @cfgrammar begin
    Start = Str

    Str = str_concat(Str, Str)
    Str = char_str(Char)

    Str = take_word(Str, Char)
    Str = drop_first_word(Str, Char)
    Str = last_word(Str, Char)
    Str = word_at(Str, Char, Int)
    Str = first_letters(Str, Char)

    Str = take_first(Str, Int)
    Str = drop_first(Str, Int)
    Str = take_last(Str, Int)
    Str = drop_last(Str, Int)

    Str = replace_character(Str, Char, Char)
    Str = str_replace(Str, Str, Str)
    Str = ensure_suffix(Str, Str)

    Str = str_lower(Str)
    Str = str_upper(Str)
    Str = str_capitalize(Str)

    # DreamCoder's delimiter constants.
    Char = '.'
    Char = ','
    Char = ' '
    Char = '('
    Char = ')'
    Char = '-'

    # The tasks count and slice at most five characters or words.
    Int = |(1:5)
end

"""
    dreamcoder_text_grammar(arity::Integer, constants::AbstractVector{<:AbstractString})

Build a text grammar with `arity` input rules (`_arg_1`, ...) and one `Str`
rule per entry of `constants`.
"""
function dreamcoder_text_grammar(arity::Integer, constants::AbstractVector{<:AbstractString})
    g = _dreamcoder_text_core()
    for c in constants
        add_rule!(g, Expr(:(=), :Str, c))
    end
    for i in 1:arity
        add_rule!(g, Expr(:(=), :Str, Symbol("_arg_", i)))
    end
    return g
end

# One grammar per problem, keyed off the generated metadata.
for (_ident, _arity) in PROBLEM_ARITIES
    @eval const $(Symbol("grammar_", _ident)) =
        dreamcoder_text_grammar($_arity, PROBLEM_CONSTANTS[$_ident])
end

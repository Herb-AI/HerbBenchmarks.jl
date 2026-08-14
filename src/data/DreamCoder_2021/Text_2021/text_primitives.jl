"""
Primitives for DreamCoder's text-editing domain.

These follow `targetTextPrimitives` in
`dreamcoder/domains/text/textPrimitives.py` — take/drop word, append,
abbreviate, last word, replace character, the delimiter constants — with one
representational change: DreamCoder models a string as a list of characters
and rebuilds it with `cons`/`car`/`cdr`, whereas here a string is a Julia
`String` and the word- and character-level operations act on it directly.
That keeps programs readable and, since the list operations only ever existed
to implement these very operations, costs no expressiveness.

Partial primitives (asking for the fourth word of a two-word string, taking
five characters from a three-character one) throw, which the search reads as
"this program does not solve the task".
"""

"""
    TEXT_DELIMITERS

The six delimiter characters DreamCoder provides as constants.
"""
const TEXT_DELIMITERS = ('.', ',', ' ', '(', ')', '-')

"""
    str_concat(a, b)

Concatenation of two strings. DreamCoder's `append`.
"""
str_concat(a::AbstractString, b::AbstractString) = string(a, b)

"""
    char_str(c)

The one-character string containing `c`, which is how a delimiter constant
enters a string-valued expression.
"""
char_str(c::AbstractChar) = string(c)

"""
    str_length(s)

Number of characters in `s`.
"""
str_length(s::AbstractString) = length(s)

"""
    take_first(s, n)

The first `n` characters of `s`. Throws if `s` is shorter than `n`.
"""
function take_first(s::AbstractString, n::Integer)
    n <= length(s) || throw(BoundsError(s, n))
    return first(s, n)
end

"""
    drop_first(s, n)

`s` without its first `n` characters. Throws if `s` is shorter than `n`.
"""
function drop_first(s::AbstractString, n::Integer)
    n <= length(s) || throw(BoundsError(s, n))
    return chop(s; head=n, tail=0)
end

"""
    take_last(s, n)

The last `n` characters of `s`. Throws if `s` is shorter than `n`.
"""
function take_last(s::AbstractString, n::Integer)
    n <= length(s) || throw(BoundsError(s, n))
    return last(s, n)
end

"""
    drop_last(s, n)

`s` without its last `n` characters. Throws if `s` is shorter than `n`.
"""
function drop_last(s::AbstractString, n::Integer)
    n <= length(s) || throw(BoundsError(s, n))
    return chop(s; head=0, tail=n)
end

"""
    word_at(s, delimiter, n)

The `n`-th `delimiter`-separated word of `s`, counting from 1. Throws if there
are fewer than `n` words.

DreamCoder indexes words from 0; this counts from 1 to match the rest of
Julia, so `x.split(d)[0]` is `word_at(x, d, 1)`.
"""
function word_at(s::AbstractString, delimiter::AbstractChar, n::Integer)
    words = split(s, delimiter)
    n <= length(words) || throw(BoundsError(words, n))
    return String(words[n])
end

"""
    last_word(s, delimiter)

The final `delimiter`-separated word of `s`. DreamCoder's `last-word`.
"""
last_word(s::AbstractString, delimiter::AbstractChar) = String(last(split(s, delimiter)))

"""
    drop_first_word(s, delimiter)

`s` with its first `delimiter`-separated word — and the delimiter after it —
removed. DreamCoder's `drop-word`.
"""
function drop_first_word(s::AbstractString, delimiter::AbstractChar)
    words = split(s, delimiter)
    return join(words[2:end], delimiter)
end

"""
    take_word(s, delimiter)

The first `delimiter`-separated word of `s`. DreamCoder's `take-word`.
"""
take_word(s::AbstractString, delimiter::AbstractChar) = String(first(split(s, delimiter)))

"""
    first_letters(s, delimiter)

The initial of every `delimiter`-separated word of `s`, concatenated: the
"Allen Newell" → "AN" transformation. Throws on an empty word.
"""
function first_letters(s::AbstractString, delimiter::AbstractChar)
    return join(first(w, 1) for w in split(s, delimiter))
end

"""
    replace_character(s, from, to)

`s` with every `from` replaced by `to`. DreamCoder's `replace-character`.
"""
replace_character(s::AbstractString, from::AbstractChar, to::AbstractChar) =
    replace(s, from => to)

"""
    str_replace(s, from, to)

`s` with every occurrence of the substring `from` replaced by `to`.
DreamCoder's `_replace`.
"""
str_replace(s::AbstractString, from::AbstractString, to::AbstractString) =
    isempty(from) ? String(s) : replace(s, from => to)

"""
    ensure_suffix(s, suffix)

`s` if it already ends in `suffix`, otherwise `s * suffix`.
"""
ensure_suffix(s::AbstractString, suffix::AbstractString) =
    endswith(s, suffix) ? String(s) : string(s, suffix)

"""
    str_lower(s)

`s` in lower case. DreamCoder's `_lower`.
"""
str_lower(s::AbstractString) = lowercase(s)

"""
    str_upper(s)

`s` in upper case. DreamCoder's `_upper`.
"""
str_upper(s::AbstractString) = uppercase(s)

"""
    str_capitalize(s)

`s` with its first letter capitalised and the rest lowered, matching Python's
`str.capitalize`. DreamCoder's `_capitalize`.
"""
str_capitalize(s::AbstractString) =
    isempty(s) ? String(s) : string(uppercase(first(s)), lowercase(chop(s; head=1, tail=0)))

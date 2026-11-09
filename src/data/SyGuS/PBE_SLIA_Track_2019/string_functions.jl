using MLStyle
# String operations used by the SyGuS PBE SLIA grammars.
# Semantics: https://smt-lib.org/theories-UnicodeStrings.shtml

## String typed
# Join the two strings in argument order.
concat_cvc(str1::String, str2::String) = str1 * str2

# Replace the first occurrence. An empty pattern matches before the first character.
function replace_cvc(mainstr::String, to_replace::String, replace_with::String)
    isempty(to_replace) && return replace_with * mainstr
    return replace(mainstr, to_replace => replace_with; count=1)
end

# Return a singleton string at a zero-based code point position, or "" if out of bounds.
at_cvc(str::String, index::Integer) = substr_cvc(str, index, 1)

# Only nonnegative integers have a decimal string representation in this theory.
int_to_str_cvc(n::Integer) = n < 0 ? "" : string(n)

# Take up to count code points from start. Invalid starts and nonpositive counts yield "".
function substr_cvc(str::String, start::Integer, count::Integer)
    len = length(str)
    (0 <= start < len && count > 0) || return ""
    first_byte = nextind(str, firstindex(str), Int(start))
    after_last = nextind(str, first_byte, Int(min(count, len - start)))
    return str[first_byte:prevind(str, after_last)]
end

# Int typed
# Count Unicode code points.
len_cvc(str::String) = length(str)

# Accept a nonempty sequence of ASCII digits, including leading zeros.
# Invalid strings yield -1. SMT-LIB integers have no fixed size.
function str_to_int_cvc(str::String)
    (isempty(str) || !all(isdigit, str)) && return -1
    value = tryparse(Int, str)
    return value === nothing ? parse(BigInt, str) : value
end

# Find the first match at or after start and return its zero-based code point position.
# An empty pattern matches at any valid start, including the end. A miss yields -1.
function indexof_cvc(str::String, substring::String, start::Integer)
    0 <= start <= length(str) || return -1
    isempty(substring) && return Int(start)
    first_byte = nextind(str, firstindex(str), Int(start))
    match = findnext(substring, str, first_byte)
    return match === nothing ? -1 : length(str, firstindex(str), first(match)) - 1
end

# Bool typed
# The first argument is the prefix or suffix being tested.
prefixof_cvc(prefix::String, str::String) = startswith(str, prefix)

suffixof_cvc(suffix::String, str::String) = endswith(str, suffix)

contains_cvc(str::String, contained::String) = contains(str, contained)

# Lexicographic ordering uses the numeric order of Unicode code points.
lt_cvc(str1::String, str2::String) = cmp(str1, str2) < 0

leq_cvc(str1::String, str2::String) = cmp(str1, str2) <= 0

# A digit is a singleton string containing an ASCII decimal digit.
isdigit_cvc(str::String) = length(str) == 1 && isdigit(first(str))

"""
Gets the relevant symbol to easily match grammar rules to operations in `interpret` function
"""
function get_relevant_tags(grammar::ContextSensitiveGrammar)
        tags = Dict{Int,Any}()
        for (ind, r) in pairs(grammar.rules)
                tags[ind] = if typeof(r) != Expr
                        r
                else
                        @match r.head begin
                                :block => :OpSeq
                                :call => r.args[1]
                                :if => :IF
                        end
                end
        end
        return tags
end

function interpret_sygus(prog::AbstractRuleNode, grammar_tags::Dict{Int,Any})
    r = get_rule(prog)
    c = get_children(prog)

    MLStyle.@match grammar_tags[r] begin
        :concat_cvc => concat_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :replace_cvc => replace_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags), interpret_sygus(c[3], grammar_tags))
        :at_cvc => at_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :int_to_str_cvc => int_to_str_cvc(interpret_sygus(c[1], grammar_tags))
        :substr_cvc => substr_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags), interpret_sygus(c[3], grammar_tags))
        :len_cvc => len_cvc(interpret_sygus(c[1], grammar_tags))
        :str_to_int_cvc => str_to_int_cvc(interpret_sygus(c[1], grammar_tags))
        :indexof_cvc => indexof_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags), interpret_sygus(c[3], grammar_tags))
        :prefixof_cvc => prefixof_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :suffixof_cvc => suffixof_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :contains_cvc => contains_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :lt_cvc => lt_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :leq_cvc => leq_cvc(interpret_sygus(c[1], grammar_tags), interpret_sygus(c[2], grammar_tags))
        :isdigit_cvc => isdigit_cvc(interpret_sygus(c[1], grammar_tags))

        :+ => interpret_sygus(c[1], grammar_tags) + interpret_sygus(c[2], grammar_tags)
        :- => interpret_sygus(c[1], grammar_tags) - interpret_sygus(c[2], grammar_tags)
        :(==) => interpret_sygus(c[1], grammar_tags) == interpret_sygus(c[2], grammar_tags)

        :IF => interpret_sygus(c[1], grammar_tags) ? interpret_sygus(c[2], grammar_tags) : interpret_sygus(c[3], grammar_tags)

        _ => grammar_tags[r]
    end
end

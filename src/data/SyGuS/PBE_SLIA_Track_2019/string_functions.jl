using MLStyle
# CVC5 functions

## String typed
concat_cvc(str1::String, str2::String) = str1 * str2

replace_cvc(mainstr::String, to_replace::String, replace_with::String) = replace(mainstr, to_replace => replace_with)

# at_cvc(str::String, index::Int) = string(str[index])
at_cvc(str, index::Int) = checkbounds(Bool, str, index) ? str[index:index] : nothing

int_to_str_cvc(n::Int) = "$n"

# substr_cvc(str::String, start_index::Int, end_index::Int) = str[start_index:end_index]
substr_cvc(str, start_index::Int, end_index::Int) = checkbounds(Bool, str, start_index) && checkbounds(Bool, str, end_index) ? str[start_index:end_index] : nothing

# Int typed
len_cvc(str::String) = length(str)

# str_to_int_cvc(str::String) = parse(Int64, str)
str_to_int_cvc(str::String) = tryparse(Int64, str)

# indexof_cvc(str::String, substring::String, index::Int) = (n = findfirst(substring, str); n == nothing ? -1 : (n[1] >= index ? n[1] : -1))
function indexof_cvc(str, substring, index::Int)
        if !checkbounds(Bool, str, index) 
                return nothing
        end

        n = findnext(substring, str, index)
        return isnothing(n) ? -1 : first(n)
end

# Bool typed
prefixof_cvc(prefix::String, str::String) = startswith(str, prefix)

suffixof_cvc(suffix::String, str::String) = endswith(str, suffix)

contains_cvc(str::String, contained::String) = contains(str, contained)

lt_cvc(str1::String, str2::String) = cmp(str1, str2) < 0

leq_cvc(str1::String, str2::String) = cmp(str1, str2) <= 0

isdigit_cvc(str::String) = tryparse(Int, str) !== nothing

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

        :+ => interpret_sygus(c[1], grammar_tags) + interpret_sygus(c[2], grammar_tags)
        :- => interpret_sygus(c[1], grammar_tags) - interpret_sygus(c[2], grammar_tags)
        :(==) => interpret_sygus(c[1], grammar_tags) == interpret_sygus(c[2], grammar_tags)

        :IF => interpret_sygus(c[1], grammar_tags) ? interpret_sygus(c[2], grammar_tags) : interpret_sygus(c[3], grammar_tags)

        _ => grammar_tags[r]
    end
end




# ------------------------------------------------------------------
# String-producing functions
# ------------------------------------------------------------------

function sandwich(s1::AbstractString, s2::AbstractString)
    mid = length(s1) ÷ 2
    return s1[1:mid] * s2 * s1[mid+1:end]
end

function rotate_left(s::AbstractString, n::Integer)
    isempty(s) && return s
    chars = collect(s)
    k = mod(n, length(chars))
    return join(vcat(chars[k+1:end], chars[1:k]))
end

function rotate_right(s::AbstractString, n::Integer)
    isempty(s) && return s
    chars = collect(s)
    k = mod(n, length(chars))
    return join(vcat(chars[end-k+1:end], chars[1:end-k]))
end

mirror_concat(s::AbstractString) =
    s * reverse(s)

function every_other(s::AbstractString)
    chars = collect(s)
    return join(chars[1:2:end])
end

function drop_middle(s::AbstractString)
    chars = collect(s)
    isempty(chars) && return s
    mid = (length(chars) + 1) ÷ 2
    deleteat!(chars, mid)
    return join(chars)
end

function duplicate_middle(s::AbstractString)
    chars = collect(s)
    isempty(chars) && return s
    mid = (length(chars) + 1) ÷ 2
    insert!(chars, mid, chars[mid])
    return join(chars)
end

function reverse_halves(s::AbstractString)
    chars = collect(s)
    mid = length(chars) ÷ 2
    return join(vcat(chars[mid+1:end], chars[1:mid]))
end

function interleave(s1::AbstractString, s2::AbstractString)
    a = collect(s1)
    b = collect(s2)

    out = Char[]
    n = min(length(a), length(b))

    for i in 1:n
        push!(out, a[i])
        push!(out, b[i])
    end

    append!(out, a[n+1:end])
    append!(out, b[n+1:end])

    return join(out)
end

function zip_reverse(s1::AbstractString, s2::AbstractString)
    interleave(s1, reverse(s2))
end

function sort_chars(s::AbstractString)
    join(sort(collect(s)))
end

function alternating_case(s::AbstractString)
    chars = collect(lowercase(s))

    for i in eachindex(chars)
        if isodd(i)
            chars[i] = uppercase(string(chars[i]))[1]
        end
    end

    return join(chars)
end

function surround_with_length(s::AbstractString)
    n = string(length(s))
    return n * s * n
end


# ------------------------------------------------------------------
# Integer statistics
# ------------------------------------------------------------------

function ascii_sum(s::AbstractString)
    sum(Int(c) for c in s; init=0)
end

function first_char_code(s::AbstractString)
    isempty(s) && return 0
    Int(first(s))
end

function last_char_code(s::AbstractString)
    isempty(s) && return 0
    Int(last(s))
end

function middle_char_code(s::AbstractString)
    chars = collect(s)
    isempty(chars) && return 0
    Int(chars[(length(chars) + 1) ÷ 2])
end

function num_runs(s::AbstractString)
    isempty(s) && return 0

    chars = collect(s)
    runs = 1

    for i in 2:length(chars)
        runs += chars[i] != chars[i-1]
    end

    runs
end

function palindrome_score(s::AbstractString)
    chars = collect(s)
    n = length(chars)

    score = 0
    for i in 1:(n ÷ 2)
        score += chars[i] == chars[n - i + 1]
    end

    score
end

hash_mod_17(s::AbstractString) = mod(hash(s), 17)
hash_mod_31(s::AbstractString) = mod(hash(s), 31)

ascii_sum_mod_7(s::AbstractString) =
    mod(ascii_sum(s), 7)


# ------------------------------------------------------------------
# Boolean predicates
# ------------------------------------------------------------------

function even_ascii_sum(s::AbstractString)
    iseven(ascii_sum(s))
end

function vowel_count_equals_digit_count(s::AbstractString)
    vowels = count(c -> lowercase(c) in ['a','e','i','o','u'], s)
    digits = count(isdigit, s)
    vowels == digits
end


# =========================================================
# String-aware deterministic mixing
# =========================================================

"""
Stable string hash (no Julia `hash` randomness)
"""
function stable_hash(s::AbstractString)
    acc = 0
    for (i, c) in enumerate(s)
        acc = acc * 131 + Int(c) + i * 17
    end
    return acc
end


"""
Combine seed + string into a single deterministic value
"""
function mix_seed(s::AbstractString, seed::Integer)
    return seed * 1315423911 ⊻ stable_hash(s)
end


# =========================================================
# Random-ish string operations (NOW input-dependent)
# =========================================================

"""
Deterministic shuffle influenced by BOTH string and seed
"""
function random_shuffle(s::AbstractString, seed::Integer)
    chars = collect(s)
    n = length(chars)
    n ≤ 1 && return s

    mixed = mix_seed(s, seed)

    for i in 1:n
        j = mod(mixed * (i + 17) + stable_hash(join(chars)), n) + 1
        chars[i], chars[j] = chars[j], chars[i]
    end

    return join(chars)
end


"""
Return a deterministic pseudo-random character from the input string
based on string content + seed.
"""
function random_character(s::AbstractString, seed::Integer)
    chars = collect(s)
    n = length(chars)
    n == 0 && return '\0'   # or error("empty string")

    mixed = mix_seed(s, seed)

    idx = mod(mixed * 131 + 7, n) + 1
    return chars[idx]
end


"""
Substring influenced by both string content and seed
"""
function random_substring(s::AbstractString, seed::Integer)
    chars = collect(s)
    n = length(chars)
    n == 0 && return s

    mixed = mix_seed(s, seed)

    i = mod(mixed * 3 + 5, n) + 1
    j = mod(mixed * 7 + 11 + stable_hash(s), n) + 1

    lo = min(i, j)
    hi = max(i, j)

    return join(chars[lo:hi])
end

# =========================================================
# Integer helper (modulo hash)
# =========================================================

"""
Deterministic hash modulo n (no Julia hash randomness).
"""
function hash_mod_n(s::AbstractString, n::Integer)
    n == 0 && return 0

    acc = 0
    for (i, c) in enumerate(s)
        acc = (acc * 131 + Int(c) + i) % n
    end

    return acc
end


# =========================================================
# Boolean predicate
# =========================================================

"""
Check if hash(s) mod n equals a.
"""
function hash_mod_n_equals(s::AbstractString, n::Integer, a::Integer)
    return hash_mod_n(s, n) == a
end
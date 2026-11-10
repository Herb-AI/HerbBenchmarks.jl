# CVC5 functions

"""
    SLIAOperatorError <: Exception

`at_cvc(str, 99)` and `str_to_int_cvc("abc")` are out of range / malformed.
`-1` and `""` are not safe values to return for that: a program can also
produce `-1` or `""` as its actual, correct answer to a benchmark problem, so
those values can't be told apart from a failure. `SLIAOperatorError` is its
own type, so `result isa SLIAOperatorError` is unambiguous.

It is returned, not thrown: constructing and returning a value is cheap,
while `throw`/`catch` is not (see the runtime comparison in the git history
for this file). Since it's still an `Exception`, code that wants Julia's
usual exception handling (e.g. HerbSearch's `evaluate`) can `throw` it itself.
"""
struct SLIAOperatorError <: Exception
    op::Symbol
    args::Tuple
end

Base.showerror(io::IO, e::SLIAOperatorError) = print(io, "SLIA operator ", e.op, " failed on arguments ", e.args)

const StringOrError = Union{String,SLIAOperatorError}
const IntOrError = Union{Int,SLIAOperatorError}

"""
    _first_error(args...) -> Union{SLIAOperatorError,Nothing}

`concat_cvc(at_cvc(str, 99), "US")` must not run `*` on an `SLIAOperatorError`
and a `String`: that would throw a `MethodError`, which is exactly the
exception-throwing behavior this file avoids. Every operator below calls this
first and, if any argument already failed, returns that failure immediately
instead of touching it.
"""
function _first_error(args...)
    for a in args
        a isa SLIAOperatorError && return a
    end
    return nothing
end

## String typed
function concat_cvc(str1::StringOrError, str2::StringOrError)::StringOrError
    err = _first_error(str1, str2)
    err !== nothing && return err
    return str1 * str2
end

function replace_cvc(mainstr::StringOrError, to_replace::StringOrError, replace_with::StringOrError)::StringOrError
    err = _first_error(mainstr, to_replace, replace_with)
    err !== nothing && return err
    isempty(to_replace) && return replace_with * mainstr
    range = findfirst(to_replace, mainstr)
    range === nothing && return mainstr
    return mainstr[1:prevind(mainstr, first(range))] * replace_with * mainstr[nextind(mainstr, last(range)):end]
end

function at_cvc(str::StringOrError, index::IntOrError)::StringOrError
    err = _first_error(str, index)
    err !== nothing && return err
    return isvalid(str, index) ? string(str[index]) : SLIAOperatorError(:at_cvc, (str, index))
end

function int_to_str_cvc(n::IntOrError)::StringOrError
    err = _first_error(n)
    err !== nothing && return err
    return "$n"
end

function substr_cvc(str::StringOrError, start_index::IntOrError, end_index::IntOrError)::StringOrError
    err = _first_error(str, start_index, end_index)
    err !== nothing && return err
    (end_index >= start_index && isvalid(str, start_index) && isvalid(str, end_index)) ||
        return SLIAOperatorError(:substr_cvc, (str, start_index, end_index))
    return str[start_index:end_index]
end

# Int typed
function len_cvc(str::StringOrError)::IntOrError
    err = _first_error(str)
    err !== nothing && return err
    return length(str)
end

function str_to_int_cvc(str::StringOrError)::IntOrError
    err = _first_error(str)
    err !== nothing && return err
    (isempty(str) || !all(c -> '0' <= c <= '9', str)) && return SLIAOperatorError(:str_to_int_cvc, (str,))
    return parse(Int, str)
end

function indexof_cvc(str::StringOrError, substring::StringOrError, index::IntOrError)::IntOrError
    err = _first_error(str, substring, index)
    err !== nothing && return err
    n = findfirst(substring, str)
    return n === nothing ? -1 : (n[1] >= index ? n[1] : -1)
end

# Bool typed
function prefixof_cvc(prefix::StringOrError, str::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(prefix, str)
    err !== nothing && return err
    return startswith(str, prefix)
end

function suffixof_cvc(suffix::StringOrError, str::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(suffix, str)
    err !== nothing && return err
    return endswith(str, suffix)
end

function contains_cvc(str::StringOrError, contained::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(str, contained)
    err !== nothing && return err
    return contains(str, contained)
end

function lt_cvc(str1::StringOrError, str2::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(str1, str2)
    err !== nothing && return err
    return cmp(str1, str2) < 0
end

function leq_cvc(str1::StringOrError, str2::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(str1, str2)
    err !== nothing && return err
    return cmp(str1, str2) <= 0
end

function isdigit_cvc(str::StringOrError)::Union{Bool,SLIAOperatorError}
    err = _first_error(str)
    err !== nothing && return err
    return tryparse(Int, str) !== nothing
end

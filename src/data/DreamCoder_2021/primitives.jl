primitive_empty_string = :(TString = "")
primitive_uppercase = :(TChar = uppercase(TChar))
primitive_strip = :(TString = strip(TString)) # Julia's strip function is now called `strip` in recent versions.
primitive_lowercase = :(TChar = lowercase(TChar))
primitive_character_equal = :(TBool = ==(TChar, TChar))
primitive_character_uppercase = :(TBool = isuppercase(TChar))
primitive_string_equal = :(TBool = ==(TList(TChar), TList(TChar)))
primitive_capitalize = :(TString = titlecase(TString)) # Julia's capitalize function applies to the first character of a string.
primitive_concatenate = :(TString = TString * TString) # In Julia, string concatenation is done with the * operator.

primitive_comma = :(TChar = ',')
primitive_period = :(TChar = '.')
primitive_at = :(TChar = '@')
primitive_space = :(TChar = ' ')
primitive_less_than = :(TChar = '<')
primitive_greater_than = :(TChar = '>')
primitive_slash = :(TChar = '/')
primitive_pipe = :(TChar = '|')
primitive_dash = :(TChar = '-')
primitive_lparen = :(TChar = '(')
primitive_rparen = :(TChar = ')')
primitive_constant_strings = primitive_constants = [
    primitive_comma,
    primitive_period,
    primitive_at,
    primitive_space,
    primitive_less_than,
    primitive_greater_than,
    primitive_slash,
    primitive_pipe,
    primitive_dash,
    primitive_lparen,
    primitive_rparen
]

primitive_slice_string = :(TString = slice_string(TInt, TInt, TString))

slice_string(i::Int, j::Int, s::String) = begin
    i += i < 0 ? length(s) : 0
    j += j < 0 ? 1 + length(s) : 0
    return string(s[i+1:min(i+j, end)])
end

primitive_nth_string = :(TString = nth_string(TInt, TList{TString}))
function nth_string(n::Int, words::List{String})
    n += n < 0 ? length(words) : 0S
    return words[n+1]

end


primitive_map_string = [:(TList{TString} = map(TFunction{TString, TString}, TList{TString})), :(TList{TString} = map(TFunction{TChar, TChar}, TList{TString}))]
primitive_string_split = :(TList{TString} = split(TString, TChar))
primitive_string_join = :(TString = join_strings(TList{TString}, TString))
primitive_character_to_string = :(TString = string(TChar))

# Integer primitives
primitive_0 = :(TInt = 0)
primitive_1 = :(TInt = 1)
primitive_n1 = :(TInt = -1)
primitive_2 = :(TInt = 2)
primitive_3 = :(TInt = 3)
primitive_4 = :(TInt = 4)
primitive_5 = :(TInt = 5)
primitive_6 = :(TInt = 6)
primitive_7 = :(TInt = 7)
primitive_8 = :(TInt = 8)
primitive_9 = :(TInt = 9)
primitive_20 = :(TInt = 20)

primitive_addition = :(TInt = TInt + TInt)
primitive_subtraction = :(TInt = TInt - TInt)
primitive_increment = :(TInt = TInt + 1)
primitive_decrement = :(TInt = TInt - 1)
primitive_negation = :(TInt = -TInt)
primitive_multiplication = :(TInt = TInt * TInt)
primitive_modulus = :(TInt = TInt % TInt)

primitive_apply = :(T0 = TFunction{T1, T0}(T1))

primitive_true = :(TBoolean = true)
primitive_false = :(TBoolean = false)

# primitive_if = :(T0 = (TBoolean ? T0 : T0)) #@TODO revert to genertic types
primitive_if_int = :(TInt = (TBoolean ? TInt : TInt))
primitive_if_list = :(TList = (TBoolean ? TList : TList))
primitive_is_square = :(TBoolean = is_square(TInt))
function is_square(x::Int)
    y = float(x)
    s = Int(sqrt(y))
    return s * s == x
end

primitive_is_prime = :(TBoolean = is_prime(TInt))
function is_prime(n::Int)
    if n <= 1
        return false
    end
    for i in 2:sqrt(n)
        if n % i == 0
            return false
        end
    end
    return true
end

# List operations
# primitive_cons = :(TList{T0} = [T0; TList{T0}])
primitive_cons = :(TList = [TInt; TList])
#primitive_car = :(T0 = TList{T0}[1])
primitive_car = :(TInt = TList[1])
# primitive_cdr = :(TList{T0} = TList{T0}[2:end]) 
primitive_cdr = :(TList = TList[2:end]) #@TODO revert to generic types

primitive_is_empty = :(TBoolean = isempty(TList{T0}))

primitive_empty_list = :(TList{T0} = [])

primitive_string_constant = :(TList{TCharacter} = "")

#primitive_range = :(TList{TInt} = 1:TInt)
#primitive_sort = :(TList{TInt} = sort(TList{TInt}))
#primitive_reverse = :(TList{TInt} = reverse(TList{TInt}))
#primitive_append = :(TList{T0} = vcat(TList{T0}, TList{T0}))
#primitive_singleton = :(TList{TInt} = [TInt])
#primitive_slice = :(TList{TInt} = TList{TInt}[TInt:TInt])
#primitive_length = :(TInt = length(TList{T0}))
#primitive_map = :(TList{T1} = map(TFunction{T0, T1}, TList{T0}))
#primitive_fold_right = :(TInt = foldr(TFunction{TInt, TInt, TInt}, TInt, TList{TInt}))
#primitive_mapi = :(TList{T1} = mapi(TFunction{TInt, T0, T1}, TList{T0}))
#primitive_a2 = :(TList{T0} = vcat(TList{T0}, TList{T0}))
#primitive_reducei = :(T1 = reduce(TFunction{TInt, T1, T0, T1}, T1, TList{T0}))
#primitive_filter = :(TList{T0} = filter(TFunction{T0, TBoolean}, TList{T0}))
#primitive_filter_int = :(TList{TInt} = filter(TFunction{TInt, TBoolean}, TList{TInt}))
primitive_range = :(TList = 1:TInt)
primitive_sort = :(TList = sort(TList))
primitive_reverse = :(TList = reverse(TList))
primitive_append = :(TList = vcat(TList, TList))
primitive_singleton = :(TList = [TInt])
primitive_slice = :(TList = TList[TInt:TInt])
primitive_length = :(TInt = length(TList))
primitive_map = :(TList = map(TFunction, TList))
primitive_reduce = :(TInt = reduce(TFunction, TList))
primitive_fold_right = :(TInt = foldr(TFunction, TInt, TList))
primitive_a2 = :(TList = vcat(TList, TList))
primitive_filter = :(TList = filter(TFunction, TList))

primitive_unfold = :(TList = unfold(TFunction, TFunction, TFunction, TInt))
primitive_fold = :(TInt = foldl(TFunction, TList, 0)) #@TODO define starting point with init?

primitive_sum = :(TInt = sum(TList))
primitive_reverse = :(TList = reverse(TList))
primitive_all = :(TBool = all(TList))
primitive_any = :(TBool = any(TList))
primitive_index = :(TInt = TList[TInt])

"""
- p = predicate function
- h = mapper function
- n = updater function
- x = initial seed value

Example: Generate a list of numbers starting from 1, doubling each time, until greater than 100
p = x -> x > 100
h = x -> x
n = x -> x * 2
x = 1

unfolded_list = _unfold(x)(p, h, n)
"""
function unfold(x)
    return (p, h, n) -> _unfold(p, h, n, x)
end

function _unfold(p, f, n, x, recursion_limit=50)
    if recursion_limit <= 0
        error("Recursion depth exceeded")
    end
    if p(x)
        return []
    else
        return [f(x); _unfold(p, f, n, n(x), recursion_limit-1)]
    end
end
primitive_unfold = :(TList = unfold(TInt)(TFunction, TFunction, TFunction))

primitive_equal = :(TBoolean = ==(TInt, TInt))
primitive_equal0 = :(TBoolean = ==(TInt, 0))
primitive_not = :(TBoolean = !TBoolean)
primitive_and = :(TBoolean = TBoolean && TBoolean)
primitive_nand = :(TBoolean = !(TBoolean && TBoolean))
primitive_or = :(TBoolean = TBoolean || TBoolean)
primitive_greater_than = :(TBoolean = >(TInt, TInt))


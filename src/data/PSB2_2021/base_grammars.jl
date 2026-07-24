"""
Type-generic building blocks of the PSB2 grammars.

Every problem grammar is a merge of an `input_<problem>` grammar (inputs,
constants and the `Return` rule, see `problem_grammars.jl`) with the base
grammars for the types that occur in that problem. `merge_grammar` prunes the
rules that refer to types the merged grammar has no productions for, so the
base grammars may refer to each other freely.

The instruction sets follow the ones of the PSB2 paper (PushGP integer, float,
boolean, char, string, vector and exec instructions), restricted to the
operations that can be written as a Julia expression. All operations are total,
see `psb2_primitives.jl`.

Non-terminals:

| Non-terminal | Meaning                                    |
|:-------------|:-------------------------------------------|
| `Return`     | Start symbol, has the output type of the problem |
| `IntRule`    | Integer                                     |
| `Float`      | Floating point number                       |
| `Boolean`    | Boolean                                     |
| `Character`  | Character                                   |
| `String`     | String                                      |
| `List`       | List of integers, floats or strings, depending on the problem |
"""

grammar_integer = @csgrammar begin
    IntRule = IntRule + IntRule
    IntRule = IntRule - IntRule
    IntRule = IntRule * IntRule
    IntRule = safe_div(IntRule, IntRule)
    IntRule = safe_mod(IntRule, IntRule)
    IntRule = safe_pow(IntRule, IntRule)
    IntRule = IntRule + 1
    IntRule = IntRule - 1
    IntRule = -IntRule
    IntRule = max(IntRule, IntRule)
    IntRule = min(IntRule, IntRule)
    IntRule = abs(IntRule)
    IntRule = to_int(Boolean)
    IntRule = to_int(Float)
    IntRule = to_int(String)
    IntRule = to_int(Character)
    IntRule = Boolean ? IntRule : IntRule
    Boolean = IntRule > IntRule
    Boolean = IntRule >= IntRule
    Boolean = IntRule < IntRule
    Boolean = IntRule <= IntRule
    Boolean = IntRule == IntRule
    Boolean = IntRule != IntRule
end

grammar_float = @csgrammar begin
    Float = Float + Float
    Float = Float - Float
    Float = Float * Float
    Float = safe_fdiv(Float, Float)
    Float = -Float
    Float = max(Float, Float)
    Float = min(Float, Float)
    Float = abs(Float)
    Float = safe_sqrt(Float)
    Float = safe_log(Float)
    Float = floor(Float)
    Float = ceil(Float)
    Float = round(Float)
    Float = sin(Float)
    Float = cos(Float)
    Float = tan(Float)
    Float = to_float(IntRule)
    Float = to_float(String)
    Float = to_float(Boolean)
    Float = Boolean ? Float : Float
    Boolean = Float > Float
    Boolean = Float >= Float
    Boolean = Float < Float
    Boolean = Float <= Float
    Boolean = Float == Float
end

grammar_boolean = @csgrammar begin
    Boolean = true
    Boolean = false
    Boolean = Boolean && Boolean
    Boolean = Boolean || Boolean
    Boolean = !Boolean
    Boolean = Boolean ⊻ Boolean
    Boolean = Boolean == Boolean
    Boolean = to_bool(IntRule)
    Boolean = to_bool(Float)
    Boolean = to_bool(String)
    Boolean = Boolean ? Boolean : Boolean
end

grammar_character = @csgrammar begin
    Character = char_of(IntRule)
    Character = char_at(String, IntRule)
    Character = uppercase(Character)
    Character = lowercase(Character)
    Character = Boolean ? Character : Character
    Boolean = islowercase(Character)
    Boolean = isuppercase(Character)
    Boolean = isletter(Character)
    Boolean = isdigit(Character)
    Boolean = is_whitespace(Character)
    Boolean = Character == Character
    IntRule = char_to_digit(Character)
end

grammar_string = @csgrammar begin
    String = ""
    String = String * String
    String = string(Character)
    String = string(IntRule)
    String = string(Float)
    String = string(Boolean)
    String = substring(String, IntRule, IntRule)
    String = reverse(String)
    String = uppercase(String)
    String = lowercase(String)
    String = replace(String, String => String)
    String = replace(String, Character => Character)
    String = replace_in_string(String, IntRule, Character)
    String = Boolean ? String : String
    IntRule = length(String)
    IntRule = str_index_of(String, String)
    IntRule = str_count(String, String)
    Boolean = occursin(String, String)
    Boolean = String == String
    Boolean = isempty(String)
end

"""
List instructions for a list of integers. `map`, `filter` and `map_pairs` bind
their element to `:x` (and `:y`), which `IntRule = int_var(:x)` reads back;
see `psb2_primitives.jl`.
"""
grammar_list_integer = @csgrammar begin
    List = []
    List = map(x -> begin bind_var!(:x, x); IntRule end, List)
    List = filter(x -> begin bind_var!(:x, x); Boolean end, List)
    List = map_pairs((x, y) -> begin bind_var!(:x, x); bind_var!(:y, y); IntRule end, List, List)
    List = sublist(List, IntRule, IntRule)
    List = list_push(List, IntRule)
    List = list_concat(List, List)
    List = reverse(List)
    List = sort(List)
    List = range_list(IntRule, IntRule)
    List = Boolean ? List : List
    IntRule = int_var(:x)
    IntRule = int_var(:y)
    IntRule = length(List)
    IntRule = list_sum(List)
    IntRule = list_max(List)
    IntRule = list_min(List)
    IntRule = list_ref(List, IntRule)
    IntRule = list_first(List)
    IntRule = list_last(List)
    IntRule = index_of(IntRule, List)
    Boolean = isempty(List)
    Boolean = List == List
end

"""
List instructions for a list of floats, see [`grammar_list_integer`](@ref).
"""
grammar_list_float = @csgrammar begin
    List = []
    List = map(x -> begin bind_var!(:x, x); Float end, List)
    List = filter(x -> begin bind_var!(:x, x); Boolean end, List)
    List = map_pairs((x, y) -> begin bind_var!(:x, x); bind_var!(:y, y); Float end, List, List)
    List = sublist(List, IntRule, IntRule)
    List = list_push(List, Float)
    List = list_concat(List, List)
    List = reverse(List)
    List = sort(List)
    List = Boolean ? List : List
    Float = float_var(:x)
    Float = float_var(:y)
    Float = list_sum(List)
    Float = list_max(List)
    Float = list_min(List)
    Float = list_ref(List, IntRule)
    Float = list_first(List)
    Float = list_last(List)
    IntRule = length(List)
    Boolean = isempty(List)
    Boolean = List == List
end

"""
List instructions for a list of strings, see [`grammar_list_integer`](@ref).
"""
grammar_list_string = @csgrammar begin
    List = []
    List = split_string(String, String)
    List = map(x -> begin bind_var!(:x, x); String end, List)
    List = filter(x -> begin bind_var!(:x, x); Boolean end, List)
    List = sublist(List, IntRule, IntRule)
    List = list_push(List, String)
    List = list_concat(List, List)
    List = reverse(List)
    List = Boolean ? List : List
    String = string_var(:x)
    String = list_ref(List, IntRule, "")
    String = list_first(List, "")
    String = list_last(List, "")
    String = join_string(List, String)
    IntRule = length(List)
    Boolean = isempty(List)
end

"""
Bounded `while` loops over an integer accumulator. The accumulator is bound to
`:s` on every iteration, `IntRule = int_var(:s)` reads it back.
"""
grammar_loop_integer = @csgrammar begin
    IntRule = while_loop(IntRule, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); IntRule end)
    IntRule = int_var(:s)
end

"""
Bounded `while` loops over a float accumulator, see [`grammar_loop_integer`](@ref).
"""
grammar_loop_float = @csgrammar begin
    Float = while_loop(Float, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); Float end)
    Float = float_var(:s)
end

"""
Bounded `while` loops over a string accumulator, see [`grammar_loop_integer`](@ref).
"""
grammar_loop_string = @csgrammar begin
    String = while_loop(String, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); String end)
    String = string_var(:s)
end

"""
Bounded `while` loops over a list accumulator, see [`grammar_loop_integer`](@ref).
A list accumulator is how a loop over several variables is written, for example
the two numbers of Euclid's algorithm in `program_examples.jl`.
"""
grammar_loop_list = @csgrammar begin
    List = while_loop(List, s -> begin bind_var!(:s, s); Boolean end, s -> begin bind_var!(:s, s); List end)
    List = list_var(:s)
end

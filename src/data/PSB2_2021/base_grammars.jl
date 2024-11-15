include("psb2_primitives.jl")

grammar_integer = @csgrammar begin
    IntRule = IntRule + IntRule
    IntRule = IntRule - IntRule
    IntRule = IntRule * IntRule 
    IntRule = IntRule / IntRule
    IntRule = IntRule % IntRule 
    IntRule = IntRule ^ IntRule 
    IntRule = IntRule ^ 2
    IntRule = IntRule + 1
    IntRule = IntRule - 1
    IntRule = IntRule * -1
    IntRule = max(IntRule, IntRule)
    IntRule = min(IntRule, IntRule)
    IntRule = abs(IntRule)
    IntRule = Integer(Boolean)
    IntRule = Integer(String)
    IntRule = Integer(Float)
    IntRule = Integer(Character)
    IntRule = ceil(IntRule)
    IntRule = floor(IntRule)
    Boolean = IntRule > IntRule
    Boolean = IntRule >= IntRule 
    Boolean = IntRule < IntRule 
    Boolean = IntRule <= IntRule 
    Boolean = IntRule == IntRule 
    Boolean = IntRule != IntRule
    IntRule = Boolean ? IntRule : IntRule
    Expression = IntRule
    Expression = begin Expression; Expression end
    IntRule = command_while(Boolean, Expression)
end

grammar_state_integer = @csgrammar begin
    State = Dict(Sym => IntRule)
    State = Dict(Sym => IntRule, Sym => IntRule)
    State = Dict(Sym => IntRule, Sym => IntRule, Sym => IntRule)
    State = merge!(state, State)
    State = push!(State, Sym => IntRule)
    IntRule = get(state, Sym, "Key not found")
    Expression = State | IntRule
    Expression = let state = State; Expression end
end

grammar_list_integer = @csgrammar begin
    List = map(Func, List)
    Func = (x -> IntRule)
    IntRule = x
    IntRule = length(List)
    IntRule = sum(List)
    IntRule = indexin(IntRule, List)
    List = getindex(List, IntRule:IntRule)
end

grammar_float = @csgrammar begin
    Number = Float | IntRule
    Number = Number + Number
    Number = Number - Number
    Number = Number * Number 
    Number = Number / Number
    Number = Number % Number 
    Number = Number ^ Number 
    Number = Number ^ 2
    Float = sqrt(Number)
    Number = Number + 1
    Number = Number - 1
    Number = Number * -1
    Number = min(Number, Number)
    Number = max(Number, Number)
    Number = abs(Number)
    Number = ceil(Number)
    Number = floor(Number)
    Float = cos(Number)
    Float = sin(Number)
    Float = tan(Number)
    Float = argcos(Number)
    Float = argsin(Number)
    Float = argtan(Number)
    Float = log(Number, IntRule)
    Float = log(Number, 2)
    Float = log(Number, 10)
    Float = float(IntRule)
    Float = float(String)
    Float = float(Boolean)
    Expression = Float
    Expression = begin Expression; Expression end
    Float = Boolean ? Expression : Expression
    Float = command_while(Boolean, Expression)
end

grammar_boolean = @csgrammar begin
    Boolean = Boolean && Boolean 
    Boolean = Boolean || Boolean 
    Boolean = !Boolean 
    Boolean = Boolean ⊻ Boolean
    Boolean = Bool(IntRule)
    Boolean = Bool(Float)
    Boolean = Boolean ? Boolean : Boolean
end

grammar_character = @csgrammar begin
    Character = Char(IntRule)
    Character = Char(Float)
    Character = Char(Boolean)
    Character = Char(String)
    Boolean = islowercase(Character)
    Boolean = isuppercase(Character)
    Boolean = isletter(Character)
    Boolean = isdigit(Character)
    Boolean = iswhitespace(Character)
    Character = Boolean ? Character : Character
end

grammar_string = @csgrammar begin
    String = string(Character)
    String = string(IntRule)
    String = string(Boolean)
    String = string(Float)
    String = String * String
    String = String * string(Character)
    String = String[IntRule]
    String = chop(String, head=IntRule, last=IntRule)
    String = chop(String, head=0, last=1)
    String = first(String)
    String = last(String)
    String = reverse(String)
    String = replace(String, String=>String)
    String = replace(String, Character=>Character)
    String = replace(String, String=>String, count=1)
    String = replace(String, Character=>Character, count=1)
    String = replace(String, Character=>"")
    String = uppercase(String)
    String = lowercase(String)
    String = replace_in_string(String, IntRule, Character)
    String = ""
    IntRule = length(String)
    IntRule = findfirst(Character, String)
    IntRule = count(String, String)
    Boolean = contains(Character, String)
    Boolean = contains(String, String)
    String = Boolean ? String : String
    Expression = String
    Expression = begin Expression; Expression end
    String = command_while(Boolean, Expression)
end
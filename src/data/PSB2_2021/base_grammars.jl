include("grammar_util.jl")

grammar_integer = @csgrammar begin
    Int = Int + Int
    Int = Int - Int
    Int = Int * Int 
    Int = Int / Int
    Int = Int % Int 
    Int = Int ^ Int 
    Int = Int ^ 2
    Int = Int + 1
    Int = Int - 1
    Int = Int * -1
    Int = max(Int, Int)
    Int = min(Int, Int)
    Int = abs(Int)
    Int = Integer(Boolean)
    Int = Integer(String)
    Int = Integer(Float)
    Int = Integer(Character)
    Int = ceil(Int)
    Int = floor(Int)
    Boolean = Int > Int
    Boolean = Int >= Int 
    Boolean = Int < Int 
    Boolean = Int <= Int 
    Boolean = Int == Int 
    Boolean = Int != Int
    Int = Boolean ? Int : Int
    Expression = Int
    Expression = begin Expression; Expression end
    Int = Int -> while Bool; Expression end
end

grammar_state_integer = @csgrammar begin
    State = Dict(Sym => Int)
    Var = merge!(Var, State)
    Var = push(State, Sym => Int)
    Int = get(Var, Sym, "Key not found")
    Var = state
    Expression = let Var = State; Expression end
end

grammar_list_integer = @csgrammar begin
    List = map(Func, List)
    Func = (x -> Int)
    Int = x
    Int = length(List)
    Int = sum(List)
    Int = indexin(Int, List)
    List = getindex(List, Int:Int)
end

grammar_float = @csgrammar begin
    Number = Float | Int
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
    Float = log(Number, Int)
    Float = log(Number, 2)
    Float = log(Number, 10)
    Float = float(Int)
    Float = float(String)
    Float = float(Boolean)
    Expression = Float
    Expression = begin Expression; Expression end
    Float = Boolean ? Expression : Expression
    Float = Float -> while Bool; Expression end
end

grammar_boolean = @csgrammar begin
    Boolean = Boolean && Boolean 
    Boolean = Boolean || Boolean 
    Boolean = !Boolean 
    Boolean = Boolean ⊻ Boolean
    Boolean = Bool(Int)
    Boolean = Bool(Float)
    Boolean = Boolean ? Boolean : Boolean
end

grammar_character = @csgrammar begin
    Character = Char(Int)
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
    String = string(Int)
    String = string(Boolean)
    String = string(Float)
    String = String * String
    String = String * string(Character)
    String = String[Int]
    String = chop(String, head=Int, last=Int)
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
    String = replace_in_string(String, Int, Character)
    String = ""
    Int = length(String)
    Int = findfirst(Character, String)
    Int = count(String, String)
    Boolean = contains(Character, String)
    Boolean = contains(String, String)
    String = Boolean ? String : String
    Expression = String
    Expression = begin Expression; Expression end
    String = String -> while Boolean; Expression end
end

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
    Int = ceil(Float)
    Int = floor(Float)
    Boolean = Int > Int
    Boolean = Int >= Int 
    Boolean = Int < Int 
    Boolean = Int <= Int 
    Boolean = Int == Int 
    Boolean = Int != Int    
end

grammar_execution = @csgrammar begin
    Variable = String | Int | Boolean | Character
    Variable = Bool ? Variable : Variable
    Variable = while Boolean; Variable end; Variable
end

grammar_list = @csgrammar begin
    List = []
    List = [Variable]
    Variable = pop!(List)
    Bool = isempty(List)
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
end

grammar_boolean = @csgrammar begin
    Boolean = Boolean && Boolean 
    Boolean = Boolean || Boolean 
    Boolean = !Boolean 
    Boolean = Boolean ⊻ Boolean
    Boolean = Bool(Int)
    Boolean = Bool(Float)
end

grammar_character = @csgrammar begin
    Character = Char(Int)
    Character = Char(Float)
    Character = Char(Boolean)
    Character = Char(String)
    Bool = islowercase(Character)
    Bool = isuppercase(Character)
    Bool = isletter(Character)
    Bool = isdigit(Character)
    Bool = iswhitespace(Character)
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
end

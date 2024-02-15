grammar_fizz_buzz = @csgrammar begin
    Int = input1
    Int = 0 | 3 | 5
    # Int = Int + Int
    # Int = Int - Int | Int * Int 
    # Int = Int / Int
    Int = Int % Int 
    # Int = Int ^ Int 
    # Int = Int ^ 2
    # Boolean = Int > Int
    # Boolean =  Int >= Int 
    # Boolean = Int < Int 
    # Boolean = Int <= Int 
    Boolean = Int == Int 
    # Boolean = Int != Int
    Boolean = Boolean && Boolean 
    # Boolean = Boolean || Boolean 
    # Boolean = !Boolean 
    # Boolean = Boolean ⊻ Boolean
    # Int = Integer(Boolean)
    # Boolean = Bool(Int)
    String = string(Int)
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = Boolean ? String : String
    output1 = String
end

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
    Variable = String | Integer | Boolean | Character
    Variable = Bool ? Variable : Variable
end

grammar_float = @csgrammar begin
    Number = Float | Integer
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
    Float = float(Integer)
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
    String = String[Integer]
    String = chop(String, head=Integer, last=Integer)
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
    String = String[Integer] = 
    String = ""
    Integer = length(String)
    Integer = findfirst(Character, String)
    Integer = count(String, String)
    Boolean = contains(Character, String)
    Boolean = contains(String, String)
end
minimal_grammar_fizz_buzz = @csgrammar begin
    Num = _arg_1
    Num = 0 | 3 | 5
    String = "Fizz" | "Buzz" | "FizzBuzz"
    String = string(Num)
    Return = String
    Num = Num % Num
    Boolean = Num == Num
    Num = Boolean ? Num : Num
    Boolean = Boolean && Boolean
end

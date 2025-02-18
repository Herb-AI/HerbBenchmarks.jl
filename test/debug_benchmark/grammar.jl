grammar_debug_benchmark = @csgrammar begin
    Start = Number
    Number = |(1:2)
    Number = x
    Number = Number + Number
    Number = Number * Number
    Number = - Number
end
using MLStyle

struct StringState
    str::String
    pointer::Union{Int,Nothing}
end

 # Initialize the pointer to 1 (not 0, since Julia is 1-indexed)
StringState(s::String) = StringState(s, 1)

function interpret(prog::AbstractRuleNode, example::IOExample)
    interpret(prog, example.in[:in]) 
end

function interpret(prog::AbstractRuleNode, state::StringState)
    rule_node = get_rule(prog)

    @match rule_node begin
        3 => interpret(prog.children[2], interpret(prog.children[1], state)) # (Operation ; Sequence)
        6 => StringState(state.str, min(state.pointer + 1, length(state.str))) # moveRight
        7 => StringState(state.str, max(state.pointer - 1, 1))   # moveLeft
        8 => StringState(state.str[1:state.pointer-1] * uppercase(state.str[state.pointer]) * state.str[state.pointer+1:end], state.pointer) #MakeUppercase
        9 => StringState(state.str[1:state.pointer-1] * lowercase(state.str[state.pointer]) * state.str[state.pointer+1:end], state.pointer) #makeLowercase
        10 => state.pointer < length(state.string) ? StringState(state.str[1:state.pointer-1] * state.str[state.pointer+1:end], state.pointer) : StringState(state.str[1:state.pointer-1] * state.str[state.pointer+1:end], state.pointer-1) #drop
        11 => interpret(prog.children[1], state) ? interpret(prog.children[2], state) : interpret(prog.children[3], state) # if statement
        12 => command_while(prog.children[1], prog.children[2], state) # while statement
        13 => state.pointer == length(state.str) # atEnd
        14 => state.pointer != length(state.str) # notAtEnd
        15 => state.pointer == 1 # atStart
        16 => state.pointer != 1 # notAtStart
        17 => state.pointer <= length(state.str) && isletter(state.str[state.pointer]) # isLetter
        18 => state.pointer > length(state.str) || !isletter(state.str[state.pointer]) # isNotLetter
        19 => state.pointer <= length(state.str) && isuppercase(state.str[state.pointer]) # isUpperCase 
        20 => state.pointer > length(state.str) || !isuppercase(state.str[state.pointer]) # isNotUppercase
        21 => state.pointer <= length(state.str) && islowercase(state.str[state.pointer]) # isLowercase
        22 => state.pointer > length(state.str) || !islowercase(state.str[state.pointer]) # isNotLowercase
        23 => state.pointer <= length(state.str) && isdigit(state.str[state.pointer]) # isNumber
        24 => state.pointer > length(state.str) || !isdigit(state.str[state.pointer]) # isNotNumber
        25 => state.pointer <= length(state.str) && isspace(state.str[state.pointer]) # isSpace
        26 => state.pointer > length(state.str) || !isspace(state.str[state.pointer]) # isNotSpace
        _ => interpret(prog.children[1], state)
    end

end

function command_while(condition::RuleNode, body::RuleNode, state::StringState, max_steps::Int=1000)
    counter = max_steps 
    while interpret(condition, state) && counter > 0
        state = interpret(body, state)
        counter -= 1
    end
    state
end

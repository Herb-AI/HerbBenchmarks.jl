using MLStyle

struct StringState
    str::String
    pointer::Union{Int,Nothing}
end

# Initialize the pointer to 1 (not 0, since Julia is 1-indexed)
StringState(s::String) = StringState(s, 1)

function interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::StringState)
    rule_node = get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammartags, state)) # (Operation ; Sequence)
        :moveRight => StringState(state.str, min(state.pointer + 1, length(state.str))) # moveRight
        :moveLeft => StringState(state.str, max(state.pointer - 1, 1))   # moveLeft
        :makeUppercase => StringState(state.str[1:state.pointer-1] * uppercase(state.str[state.pointer]) * state.str[state.pointer+1:end], state.pointer) #MakeUppercase
        :makeLowercase => StringState(state.str[1:state.pointer-1] * lowercase(state.str[state.pointer]) * state.str[state.pointer+1:end], state.pointer) #makeLowercase
        :drop => state.pointer < length(state.str) ? StringState(state.str[1:state.pointer-1] * state.str[state.pointer+1:end], state.pointer) : StringState(state.str[1:state.pointer-1] * state.str[state.pointer+1:end], state.pointer - 1) #drop
        :IF => interpret(prog.children[1], grammartags, state) ? interpret(prog.children[2], grammartags, state) : interpret(prog.children[3], grammartags, state) # if statement
        :WHILE => command_while(prog.children[1], prog.children[2], grammartags, state) # while statement
        :atEnd => state.pointer == length(state.str) # atEnd
        :notAtEnd => state.pointer != length(state.str) # notAtEnd
        :atStart => state.pointer == 1 # atStart
        :notAtStart => state.pointer != 1 # notAtStart
        :isLetter => state.pointer <= length(state.str) && isletter(state.str[state.pointer]) # isLetter
        :isNotLetter => state.pointer > length(state.str) || !isletter(state.str[state.pointer]) # isNotLetter
        :isUppercase => state.pointer <= length(state.str) && isuppercase(state.str[state.pointer]) # isUpperCase 
        :isNotUppercase => state.pointer > length(state.str) || !isuppercase(state.str[state.pointer]) # isNotUppercase
        :isLowercase => state.pointer <= length(state.str) && islowercase(state.str[state.pointer]) # isLowercase
        :isNotLowercase => state.pointer > length(state.str) || !islowercase(state.str[state.pointer]) # isNotLowercase
        :isNumber => state.pointer <= length(state.str) && isdigit(state.str[state.pointer]) # isNumber
        :isNotNumber => state.pointer > length(state.str) || !isdigit(state.str[state.pointer]) # isNotNumber
        :isSpace => state.pointer <= length(state.str) && isspace(state.str[state.pointer]) # isSpace
        :isNotSpace => state.pointer > length(state.str) || !isspace(state.str[state.pointer]) # isNotSpace
        _ => interpret(prog.children[1], grammartags, state)
    end

end

"""
Gets relevant symbol to easily match the rules
"""
function get_relevant_tags(grammar::ContextSensitiveGrammar)
    tags = Dict{Int,Symbol}()
    for (ind, r) in pairs(grammar.rules)
        tags[ind] = if typeof(r) == Symbol
            r
        else
            @match r.head begin
                :block => :OpSeq
                :call => r.args[1]
            end
        end
    end
    return tags
end

function command_while(condition::AbstractRuleNode, body::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::StringState, max_steps::Int=1000)
    counter = max_steps
    while interpret(condition, grammartags, state) && counter > 0
        state = interpret(body, grammartags, state)
        counter -= 1
    end
    state
end

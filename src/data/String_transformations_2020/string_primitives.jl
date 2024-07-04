using MLStyle

"""
Represents the state of a string, including a pointer to a specific position within the string.
"""
struct StringState
    str::String
    pointer::Union{Int,Nothing}
end

# Initialize the pointer to 1 (not 0, since Julia is 1-indexed)
StringState(s::String) = StringState(s, 1)

"""
    interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)

Interprets a program (in form of an AbstractRuleNode) on a given grammar and `IOExample`. 
Serves as an entry point that prepares the necessary grammar tags and initial state before 
calling `interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::StringState)`.

---
    interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::StringState)

Interprets a program (`prog`) based on a set of grammar tags (`grammartags`) and the current state (`state`). 
The functions handles the execution of a program by matching grammar tags to the corresponding functionality. 
"""
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
Gets relevant symbol to easily match grammar rules to operations in `interpret` function
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

"""
Custom implementation of a while loop with a condition and a body. 

Loop is terminated either when condition is false or when `max_steps` is reached.
"""
function command_while(condition::AbstractRuleNode, body::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::StringState, max_steps::Int=1000)
    counter = max_steps
    while interpret(condition, grammartags, state) && counter > 0
        state = interpret(body, grammartags, state)
        counter -= 1
    end
    state
end

# Two instances of StringState are equal if their strings are equal and at least one of the pointers is nothing
Base .== (a::StringState, b::StringState) = a.str == b.str && (a.pointer === nothing || b.pointer === nothing)
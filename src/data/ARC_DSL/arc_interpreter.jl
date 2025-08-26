# interpret function

"""
    interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)

Interprets a program (in form of an AbstractRuleNode) on a given grammar and `IOExample`. 
Serves as an entry point that prepares the necessary grammar tags and initial state before 
calling `interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::AbstractMatrix)`.

---
    interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::AbstractMatrix)

Interprets a program (`prog`) based on a set of grammar tags (`grammartags`) and the current state (`state`). 
The functions handles the execution of a program by matching grammar tags to the corresponding functionality. 
"""
function interpret(prog, grammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function interpret(prog, grammartags, state) # state => matrix (can state be more than one thing?)
    rule_node = get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammartags, state)) # (Operation ; Sequence)
        :vMirror => vmirror(state)
        :hMirror => hmirror(state)
        :hConcat => hconcat(interpret(prog.children[1], grammartags, state), state)
        :vConcat => vconcat(state)
        _ => interpret(prog.children[1], grammartags, state)

        # :moveRight => moveright(state)
        # :IF => interpret(prog.children[1], grammartags, state) ? interpret(prog.children[2], grammartags, state) : interpret(prog.children[3], grammartags, state)
        # :WHILE => command_while(prog.children[1], prog.children[2], grammartags, state)
    end
end


# TODO: get_grammar_tags

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

# implementation of primitives 

# function command_while(condition::RuleNode, body::RuleNode, grammartags::Dict{Int,Symbol}, state::PixelState, max_steps::Int=1000)
#     counter = max_steps
#     while interpret(condition, grammartags, state) && counter > 0
#         state = interpret(body, grammartags, state)
#         counter -= 1
#     end
#     state
# end

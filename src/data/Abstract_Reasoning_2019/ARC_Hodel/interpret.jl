# interpret function

"""
    HerbInterpret.interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)

Interprets a program (in form of an AbstractRuleNode) on a given grammar and `IOExample`. 
Serves as an entry point that prepares the necessary grammar tags and initial state before 
calling `interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::AbstractMatrix)`.

---
    interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::AbstractMatrix)

Interprets a program (`prog`) based on a set of grammar tags (`grammartags`) and the current state (`state`). 
The functions handles the execution of a program by matching grammar tags to the corresponding functionality. 
"""
function HerbInterpret.interpret(prog, grammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function HerbInterpret.interpret(prog, grammartags, state) # state => matrix (can state be more than one thing?)
    rule_node = get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammartags, state)) # (Operation ; Sequence)
        :vMirror => vmirror(state)
        :hMirror => hmirror(state)
        :hConcat => hconcat(interpret(prog.children[1], grammartags, state), state)
        :vConcat => vconcat(state)
        _ => interpret(prog.children[1], grammartags, state)
    end
end
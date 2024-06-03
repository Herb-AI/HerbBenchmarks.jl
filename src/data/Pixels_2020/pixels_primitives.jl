using MLStyle

mutable struct PixelState
    matrix::Matrix{Bool}
    position::Tuple{Int,Int} # (x, y)
    PixelState(matrix::Matrix{Bool}) = new(matrix, (1, 1))
end

function interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::PixelState)
    rule_node = get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammartags, state)) # (Operation ; Sequence)
        :moveRight => moveright(state)
        :moveDown => movedown(state)
        :moveLeft => moveleft(state)
        :moveUp => moveup(state)
        :draw0 => draw_0(state)
        :draw1 => draw_1(state)
        :IF => interpret(prog.children[1], grammartags, state) ? interpret(prog.children[2], grammartags, state) : interpret(prog.children[3], grammartags, state)
        :WHILE => command_while(prog.children[1], prog.children[2], grammartags, state)
        :atTop => state.position[2] == 1
        :atBottom => state.position[2] == size(state.matrix, 1)
        :atRight => state.position[1] == size(state.matrix, 2)
        :atLeft => state.position[1] == 1
        :notAtTop => !(state.position[2] == 1)
        :notAtBottom => !(state.position[2] == size(state.matrix, 1))
        :notAtRight => !(state.position[1] == size(state.matrix, 2))
        :notAtLeft => !(state.position[1] == 1)
        _ => interpret(prog.children[1], grammartags, state) # Start operation Transformation ControlStatement
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

function command_while(condition::RuleNode, body::RuleNode, grammartags::Dict{Int,Symbol}, state::PixelState, max_steps::Int=1000)
    counter = max_steps
    while interpret(condition, grammartags, state) && counter > 0
        state = interpret(body, grammartags, state)
        counter -= 1
    end
    state
end


# Transition functions
function moveright(state::PixelState)
    if !(state.position[1] == size(state.matrix, 2))
        state.position = (state.position[1] + 1, state.position[2])
    end
    return state
end

function moveleft(state::PixelState)
    if !(state.position[1] == 1)
        state.position = (state.position[1] - 1, state.position[2])
    end
    return state
end

function movedown(state::PixelState)
    if !(state.position[2] == size(state.matrix, 1))
        state.position = (state.position[1], state.position[2] + 1)
    end
    return state
end

function moveup(state::PixelState)
    if !(state.position[2] == 1)
        state.position = (state.position[1], state.position[2] - 1)
    end
    return state
end

function draw_0(state::PixelState)
    state.matrix[state.position[2], state.position[1]] = false
    return state
end

function draw_1(state::PixelState)
    state.matrix[state.position[2], state.position[1]] = true
    return state
end

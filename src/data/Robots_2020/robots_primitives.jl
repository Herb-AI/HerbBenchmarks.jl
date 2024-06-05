using MLStyle

struct RobotState
    holds_ball::Int
    robot_x::Int
    robot_y::Int
    ball_x::Int
    ball_y::Int
    size::Int
end

function interpret(prog::AbstractRuleNode, grammar::ContextSensitiveGrammar, example::IOExample)
    interpret(prog, get_relevant_tags(grammar), example.in[:in])
end

function interpret(prog::AbstractRuleNode, grammartags::Dict{Int,Symbol}, state::RobotState)
    rule_node = get_rule(prog)

    @match grammartags[rule_node] begin
        :OpSeq => interpret(prog.children[2], grammartags, interpret(prog.children[1], grammartags, state)) # (Operation ; Sequence)
        :moveRight => moveright(state)
        :moveDown => movedown(state)
        :moveLeft => moveleft(state)
        :moveUp => moveup(state)
        :drop => state.holds_ball == 1 ? RobotState(0, state.robot_x, state.robot_y, state.robot_x, state.robot_y, state.size) : state
        :grab => can_pickup(state) ? RobotState(1, state.robot_x, state.robot_y, state.ball_x, state.ball_y, state.size) : state
        :IF => interpret(prog.children[1], grammartags, state) ? interpret(prog.children[2], grammartags, state) : interpret(prog.children[3], grammartags, state)
        :WHILE => command_while(prog.children[1], prog.children[2], grammartags, state)              # while loop
        :atTop => state.robot_y == 1
        :atBottom => state.robot_y == state.size
        :atLeft => state.robot_x == 1
        :atRight => state.robot_x == state.size
        :notAtTop => !(state.robot_y == 1)
        :notAtBottom => !(state.robot_y == state.size)
        :notAtLeft => !(state.robot_x == 1)
        :notAtRight => !(state.robot_x == state.size)
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

can_pickup(state::RobotState) = state.holds_ball == 0 && state.robot_x == state.ball_x && state.robot_y == state.ball_y

function command_while(condition::RuleNode, body::RuleNode, grammartags::Dict{Int,Symbol}, state::RobotState, max_steps::Int=1000)
    counter = max_steps
    while interpret(condition, grammartags, state) && counter > 0
        tag = grammartags[get_rule(body)]
        state = interpret(body, grammartags, state)
        counter -= 1
    end
    state
end

function Base.show(io::IO, state::RobotState)
    for y in 1:state.size
        row = ""
        for x in 1:state.size
            if (x == state.robot_x && y == state.robot_y)
                row *= state.holds_ball == 1 ? "#" : "R"
            elseif (x == state.ball_x && y == state.ball_y)
                row *= "B"
            else
                row *= "."
            end
        end
        println(io, row)
    end
end

function moveright(state::RobotState)
    if !(state.robot_x == state.size)
        if Bool(state.holds_ball)
            return RobotState(state.holds_ball, state.robot_x + 1, state.robot_y, state.ball_x + 1, state.ball_y, state.size)
        else
            return RobotState(state.holds_ball, state.robot_x + 1, state.robot_y, state.ball_x, state.ball_y, state.size)
        end
    else
        return state
    end
end

function moveleft(state::RobotState)
    if !(state.robot_x == 1)
        if Bool(state.holds_ball)
            return RobotState(state.holds_ball, state.robot_x - 1, state.robot_y, state.ball_x - 1, state.ball_y, state.size)
        else
            return RobotState(state.holds_ball, state.robot_x - 1, state.robot_y, state.ball_x, state.ball_y, state.size)
        end
    else
        return state
    end
end

function movedown(state::RobotState)
    if !(state.robot_y == state.size)
        if Bool(state.holds_ball)
            return RobotState(state.holds_ball, state.robot_x, state.robot_y + 1, state.ball_x, state.ball_y + 1, state.size)
        else
            return RobotState(state.holds_ball, state.robot_x, state.robot_y + 1, state.ball_x, state.ball_y, state.size)
        end
    else
        return state
    end
end

function moveup(state::RobotState)
    if !(state.robot_y == 1)
        if Bool(state.holds_ball)
            return RobotState(state.holds_ball, state.robot_x, state.robot_y - 1, state.ball_x, state.ball_y - 1, state.size)
        else
            return RobotState(state.holds_ball, state.robot_x, state.robot_y - 1, state.ball_x, state.ball_y, state.size)
        end
    else
        return state
    end
end
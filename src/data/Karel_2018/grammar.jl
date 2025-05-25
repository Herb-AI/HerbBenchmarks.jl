using MLStyle

"""
The Karel grammar defines the Domain Specific Language (DSL) for Karel programs.
It includes control structures (if, while, repeat), conditions, and actions.
"""
grammar_karel = @cfgrammar begin
    Start = Program
    Program = (:DEF; :RUN; Block)

    Block = Action
    Block = (Action; Block)
    Block = ControlFlow

    Action = move
    Action = turnLeft
    Action = turnRight
    Action = pickMarker
    Action = putMarker

    ControlFlow = IF(Condition, Block)
    ControlFlow = IFELSE(Condition, Block, Block)
    ControlFlow = WHILE(Condition, Block)
    ControlFlow = REPEAT(R=INT, Block)
    INT = |(1:5)

    Condition = frontIsClear
    Condition = leftIsClear
    Condition = rightIsClear
    Condition = markersPresent
    Condition = noMarkersPresent
    Condition = NOT(Condition)
end

"""
    interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample)

Interprets a Karel program on a given input state.
"""
function interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample)
    input_state = array_to_state(example.in[:_arg_1])
    tags = get_relevant_tags(grammar)
    final_state = interpret(prog, tags, input_state)
    return state_to_array(final_state)
end

"""
    interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState)

Internal interpreter function that executes Karel programs.
"""
function interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState)
    rule = get_rule(prog)
    @match tags[rule] begin
        :Program => begin
            interpret(prog.children[3], tags, state)
        end
        :Block => begin
            if length(prog.children) == 1
                interpret(prog.children[1], tags, state)
            else
                state = interpret(prog.children[1], tags, state)
                interpret(prog.children[2], tags, state)
            end
        end
        :move => begin
            new_hero = move(state.hero, state.world)
            if !isnothing(new_hero)
                state.hero = new_hero
            end
            state
        end
        :turnLeft => begin
            state.hero = turn_left(state.hero)
            state
        end
        :turnRight => begin
            state.hero = turn_right(state.hero)
            state
        end
        :pickMarker => begin
            pick_marker!(state)
            state
        end
        :putMarker => begin
            put_marker!(state)
            state
        end
        :IF => begin
            condition = interpret(prog.children[1], tags, state)
            if condition
                interpret(prog.children[2], tags, state)
            else
                state
            end
        end
        :IFELSE => begin
            condition = interpret(prog.children[1], tags, state)
            if condition
                interpret(prog.children[2], tags, state)
            else
                interpret(prog.children[3], tags, state)
            end
        end
        :WHILE => begin
            condition = interpret(prog.children[1], tags, state)
            if condition
                state = interpret(prog.children[2], tags, state)
                interpret(prog, tags, state)
            else
                state
            end
        end
        :REPEAT => begin
            count = parse(Int, replace(prog.children[1].value, "R=" => ""))
            for _ in 1:count
                state = interpret(prog.children[2], tags, state)
            end
            state
        end
        :frontIsClear => front_is_clear(state)
        :leftIsClear => left_is_clear(state)
        :rightIsClear => right_is_clear(state)
        :markersPresent => markers_present(state)
        :noMarkersPresent => no_markers_present(state)
        :NOT => !interpret(prog.children[1], tags, state)
        _ => interpret(prog.children[1], tags, state)
    end
end

"""
Gets relevant symbol to easily match grammar rules to operations in `interpret` function
"""
function get_relevant_tags(grammar::AbstractGrammar)
    tags = Dict{Int,Symbol}()
    for (ind, r) in pairs(grammar.rules)
        tags[ind] = if typeof(r) == Symbol
            r
        else
            @match r.head begin
                :block => :Block
                :call => r.args[1]
            end
        end
    end
    return tags
end
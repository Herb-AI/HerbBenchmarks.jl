using MLStyle

"""
The Karel grammar defines the Domain Specific Language (DSL) for Karel programs.
It includes control structures (if, while, repeat), conditions, and actions.
"""
grammar_karel = @cfgrammar begin
    Start = (:DEF; :RUN; Block)                     #1

    Block = Action                                  #2
    Block = (Action; Block)                         #3
    Block = ControlFlow                             #4

    Action = move                                   #5
    Action = turnLeft                               #6
    Action = turnRight                              #7
    Action = pickMarker                             #8
    Action = putMarker                              #9

    ControlFlow = IF(Condition, Block)              #10
    ControlFlow = IFELSE(Condition, Block, Block)   #11
    ControlFlow = WHILE(Condition, Block)           #12
    ControlFlow = REPEAT(R=INT, Block)              #13
    INT = |(1:5)                                    #14-18

    Condition = frontIsClear                        #19
    Condition = leftIsClear                         #20
    Condition = rightIsClear                        #21
    Condition = markersPresent                      #22
    Condition = noMarkersPresent                    #23
    Condition = NOT(Condition)                      #24
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
        :Block => begin
            # Single action
            if length(prog.children) == 1
                interpret(prog.children[1], tags, state)
                # Sequential
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
        _ => begin
            if !isempty(prog.children)
                interpret(prog.children[1], tags, state)
            else
                state
            end
        end
    end
end

"""
Gets relevant symbol to easily match grammar rules to operations in `interpret` function
"""
function get_relevant_tags(grammar::AbstractGrammar)
    tags = Dict{Int,Symbol}()
    for (ind, r) in pairs(grammar.rules)
        tags[ind] = if r isa Symbol
            r
        elseif r isa Int
            Symbol(string(r))
        else
            @match r.head begin
                :block => :Block
                :call => r.args[1]
                _ => Symbol(string(r))
            end
        end
    end
    # pretty_print_dict(tags)
    return tags
end

function pretty_print_dict(d::Dict)
    println("Dict(")
    for (k, v) in sort(collect(d); by=first)
        println("  $k => $v")
    end
    println(")")
end
using MLStyle

"""
    interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample)

Interprets a Karel program on a given input state.
"""
function interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample,
        new_rules_decoding::Dict{Int,AbstractRuleNode}=Dict{Int,AbstractRuleNode}())
    input_state = deepcopy(example.in[:_arg_1])
    tags = get_relevant_tags(grammar)
    return interpret(prog, tags, input_state, new_rules_decoding)
end

"""
    interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState)

Internal interpreter function that executes Karel programs.
"""
function interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState,
        new_rules_decoding::Dict{Int,AbstractRuleNode}=Dict{Int,AbstractRuleNode}())
    rule_node = get_rule(prog)
    if rule_node in keys(new_rules_decoding)
        return interpret(new_rules_decoding[rule_node], tags, state, new_rules_decoding)
    end

    @match tags[rule_node] begin
        :Block => begin
            # Single action
            if length(prog.children) == 1
                interpret(prog.children[1], tags, state, new_rules_decoding)
                # Sequential
            else
                state = interpret(prog.children[1], tags, state, new_rules_decoding)
                interpret(prog.children[2], tags, state, new_rules_decoding)
            end
        end
        :move => begin
            move(state.hero, state.world)
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
            condition = interpret(prog.children[1], tags, state, new_rules_decoding)
            if condition
                interpret(prog.children[2], tags, state, new_rules_decoding)
            else
                state
            end
        end
        :IFELSE => begin
            condition = interpret(prog.children[1], tags, state, new_rules_decoding)
            if condition
                interpret(prog.children[2], tags, state, new_rules_decoding)
            else
                interpret(prog.children[3], tags, state, new_rules_decoding)
            end
        end
        :WHILE => command_while(prog.children[1], prog.children[2], tags, state, new_rules_decoding, 2 * max(size(state.world)...)) # while loop 
        :REPEAT => begin
            count = begin
                first_int_rule_idx = 13  # Hardcoded (#idx of INT=1 - 1)
                try
                    first(prog.children[1].domain) - first_int_rule_idx
                catch
                    try
                        prog.children[1].ind - first_int_rule_idx
                    catch
                        1
                    end
                end
            end
            for _ in 1:count
                state = interpret(prog.children[2], tags, state, new_rules_decoding)
            end
            state
        end
        :frontIsClear => front_is_clear(state)
        :leftIsClear => left_is_clear(state)
        :rightIsClear => right_is_clear(state)
        :markersPresent => markers_present(state)
        :noMarkersPresent => no_markers_present(state)
        :NOT => !interpret(prog.children[1], tags, state, new_rules_decoding)
        _ => begin
            if !isempty(prog.children)
                interpret(prog.children[1], tags, state, new_rules_decoding)
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

"""
Custom implementation of a while loop with a condition and a body. 

Loop is terminated either when condition is false or when `max_steps` is reached.
"""
function command_while(condition::AbstractRuleNode, body::AbstractRuleNode, tags::Dict{Int,Symbol},
    state::KarelState, new_rules_decoding::Dict{Int,AbstractRuleNode}, max_steps::Int=1000)
    counter = max_steps
    while interpret(condition, tags, state, new_rules_decoding) && counter > 0
        tag = tags[get_rule(body)]
        state = interpret(body, tags, state, new_rules_decoding)
        counter -= 1
    end
    state
end

function pretty_print_dict(d::Dict)
    println("Dict(")
    for (k, v) in sort(collect(d); by=first)
        println("  $k => $v")
    end
    println(")")
end

"""
    move(hero::Hero, world::Matrix{Bool})::Bool

Move the hero one step in the direction it's facing if possible.
Returns true if move successful, false if blocked by wall.
"""
function move(hero::Hero, world::Matrix{Bool})::Bool
    facing = DIRECTION_TO_VECTOR[hero.direction]
    next_x = hero.position[1] + facing[1]
    next_y = hero.position[2] + facing[2]
    if world[next_y, next_x]
        return false
    end
    hero.position = (next_x, next_y)
    return true
end

"""
    turn_left(hero::Hero)::Hero

Turn the hero 90 degrees counter-clockwise.
"""
function turn_left(hero::Hero)::Hero
    hero.direction = Direction(mod1(Int(hero.direction) - 1, 4))
    return hero
end

"""
    turn_right(hero::Hero)::Hero

Turn the hero 90 degrees clockwise.
"""
function turn_right(hero::Hero)::Hero
    hero.direction = Direction(mod1(Int(hero.direction) + 1, 4))
    return hero
end

"""
    pick_marker!(state::KarelState)::Bool

Pick up a marker at the hero's current position if one exists.
Returns true if successful, false otherwise.
"""
function pick_marker!(state::KarelState)::Bool
    pos = state.hero.position
    num_markers = get(state.markers, pos, 0)
    if num_markers == 0
        return false
    end
    if num_markers == 1
        delete!(state.markers, pos)
    else
        state.markers[pos] = num_markers - 1
    end
    state.hero.marker_count += 1
    return true
end

"""
    put_marker!(state::KarelState)::Bool

Put down a marker at the hero's current position.
Returns true if successful.
"""
function put_marker!(state::KarelState)::Bool
    if state.hero.marker_count == 0
        return false
    end
    pos = state.hero.position
    state.markers[pos] = get(state.markers, pos, 0) + 1
    state.hero.marker_count -= 1
    return true
end

# helper: rotate a direction without mutating the hero
@inline turned(dir::Direction, δ::Int) = Direction(mod1(Int(dir) + δ, 4))

# pure vector lookup
@inline facevec(dir::Direction) = DIRECTION_TO_VECTOR[dir]

"""
    front_is_clear(state::KarelState)::Bool

Check if the space in front of the hero is clear.
"""
function front_is_clear(state::KarelState)::Bool
    dx, dy = facevec(state.hero.direction)
    x, y = state.hero.position
    return !state.world[y + dy, x + dx]
end
"""
    left_is_clear(state::KarelState)::Bool

Check if the space to the left of the hero is clear.
"""
function left_is_clear(state::KarelState)::Bool
    dir = turned(state.hero.direction, -1)  # 90° CCW
    dx, dy = facevec(dir)
    x, y = state.hero.position
    return !state.world[y + dy, x + dx]
end
"""
    right_is_clear(state::KarelState)::Bool

Check if the space to the right of the hero is clear.
"""
function right_is_clear(state::KarelState)::Bool
    dir = turned(state.hero.direction, +1)  # 90° CW
    dx, dy = facevec(dir)
    x, y = state.hero.position
    return !state.world[y + dy, x + dx]
end
"""
    markers_present(state::KarelState)::Bool

Check if there are markers at the hero's current position.
"""
function markers_present(state::KarelState)::Bool
    return haskey(state.markers, state.hero.position)
end

"""
    no_markers_present(state::KarelState)::Bool

Check if there are no markers at the hero's current position.
"""
function no_markers_present(state::KarelState)::Bool
    return !markers_present(state)
end
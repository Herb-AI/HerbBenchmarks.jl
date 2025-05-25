using MLStyle

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

"""
    move(hero::Hero, world::Matrix{Char})::Union{Hero,Nothing}

Move the hero one step in the direction it's facing if possible.
Returns new hero state if move successful, nothing if blocked.
"""
function move(hero::Hero, world::Matrix{Char})::Union{Hero,Nothing}
    next_x = hero.position[1] + hero.facing[1]
    next_y = hero.position[2] + hero.facing[2]
    if world[next_y, next_x] == WALL_CHAR
        return nothing
    end
    return Hero((next_x, next_y), hero.facing, hero.marker_bag)
end

"""
    turn_left(hero::Hero)::Hero

Turn the hero 90 degrees counter-clockwise.
"""
function turn_left(hero::Hero)::Hero
    new_facing = (hero.facing[2], -hero.facing[1])
    return Hero(hero.position, new_facing, hero.marker_bag)
end

"""
    turn_right(hero::Hero)::Hero

Turn the hero 90 degrees clockwise.
"""
function turn_right(hero::Hero)::Hero
    new_facing = (-hero.facing[2], hero.facing[1])
    return Hero(hero.position, new_facing, hero.marker_bag)
end

"""
    pick_marker!(state::KarelState)::Bool

Pick up a marker at the hero's current position if one exists.
Returns true if successful, false otherwise.
"""
function pick_marker!(state::KarelState)::Bool
    pos = state.hero.position
    idx = findfirst(m -> m == pos, state.markers)
    if isnothing(idx)
        return false
    end
    deleteat!(state.markers, idx)
    return true
end

"""
    put_marker!(state::KarelState)::Bool

Put down a marker at the hero's current position.
Returns true if successful.
"""
function put_marker!(state::KarelState)::Bool
    push!(state.markers, state.hero.position)
    return true
end

"""
    front_is_clear(state::KarelState)::Bool

Check if the space in front of the hero is clear.
"""
function front_is_clear(state::KarelState)::Bool
    next_x = state.hero.position[1] + state.hero.facing[1]
    next_y = state.hero.position[2] + state.hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    left_is_clear(state::KarelState)::Bool

Check if the space to the left of the hero is clear.
"""
function left_is_clear(state::KarelState)::Bool
    left_hero = turn_left(state.hero)
    next_x = left_hero.position[1] + left_hero.facing[1]
    next_y = left_hero.position[2] + left_hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    right_is_clear(state::KarelState)::Bool

Check if the space to the right of the hero is clear.
"""
function right_is_clear(state::KarelState)::Bool
    right_hero = turn_right(state.hero)
    next_x = right_hero.position[1] + right_hero.facing[1]
    next_y = right_hero.position[2] + right_hero.facing[2]
    return state.world[next_y, next_x] != WALL_CHAR
end

"""
    markers_present(state::KarelState)::Bool

Check if there are markers at the hero's current position.
"""
function markers_present(state::KarelState)::Bool
    return state.hero.position in state.markers
end

"""
    no_markers_present(state::KarelState)::Bool

Check if there are no markers at the hero's current position.
"""
function no_markers_present(state::KarelState)::Bool
    return !markers_present(state)
end
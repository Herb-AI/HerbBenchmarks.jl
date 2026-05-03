    using Random
    using HerbSpecification
    using HerbSearch
    using NPZ
    using HerbGrammar
    using HerbBenchmarks.Karel_2018
    using HerbCore
    using MLStyle
    using HerbBenchmarks.Karel_2018: Trace
    using Serialization


    grammar_karel = @cfgrammar begin
        Start = Block                                   #1

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

    function gen_world(h::Int=8, w::Int=8; wall_ratio=0.1, rng=Random.default_rng())
        world = create_random_world(h, w, wall_ratio)
        hero  = Hero((rand(rng, 2:w-1), rand(rng, 2:h-1)), rand(rng, (NORTH, EAST, SOUTH, WEST)))
        # sprinkle a few markers
        markers = Dict{Tuple{Int,Int},Int}()
        for _ in 1:rand(rng, 1:5)
            pos = (rand(rng, 2:w-1), rand(rng, 2:h-1))
            markers[pos] = get(markers, pos, 0) + 1
        end
        return KarelState(world, markers, hero)
    end

    function interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState,
                    new_rules_decoding::Dict{Int,AbstractRuleNode}, actions::Ref{Int})
        dummy_trace = KarelState[]
        return interpret(prog, tags, state, new_rules_decoding, actions, dummy_trace)
    end

    function record_if_changed!(state::KarelState,
                                trace::Vector{KarelState},
                                actions::Ref{Int},
                                f::Function)
        prev_pos = state.hero.position
        prev_dir = state.hero.direction
        prev_bag = state.hero.marker_count
        prev_markers = copy(state.markers)

        f()  # perform the primitive

        changed = state.hero.position != prev_pos ||
                state.hero.direction != prev_dir ||
                state.hero.marker_count != prev_bag ||
                state.markers != prev_markers

        # optional dedupe against last recorded snapshot
        if changed && (isempty(trace) || state != trace[end])
            actions[] += 1
            push!(trace, deepcopy(state))
        end
        return state
    end

    # Wrapper so `record_if_changed!(...) do ... end` works
    record_if_changed!(f::Function,
                    state::KarelState,
                    trace::Vector{KarelState},
                    actions::Ref{Int}) =
        record_if_changed!(state, trace, actions, f)


    function interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample;
                    new_rules_decoding::Dict{Int,AbstractRuleNode}=Dict{Int,AbstractRuleNode}(),
                    actions::Ref{Int}=Ref{Int}(0))
        input_state = deepcopy(example.in[:_arg_1])
        tags = get_relevant_tags(grammar)
        state = interpret(prog, tags, input_state, new_rules_decoding, actions)
        return state, actions[]
    end


    # While helper gets the same actions Ref, no other changes
    function command_while(condition::AbstractRuleNode, body::AbstractRuleNode, tags::Dict{Int,Symbol},
        state::KarelState, new_rules_decoding::Dict{Int,AbstractRuleNode}, max_steps::Int=1000, actions::Ref{Int}=Ref(0))
        counter = max_steps
        while interpret(condition, tags, state, new_rules_decoding, actions) && counter > 0
            state = interpret(body, tags, state, new_rules_decoding, actions)
            counter -= 1
        end
        state
    end

    ### trace MD

    # ── OUTER interpret: now can also collect a trace of KarelState's ─────────────
    function interpret(prog::AbstractRuleNode, grammar::AbstractGrammar, example::IOExample;
                    new_rules_decoding::Dict{Int,AbstractRuleNode}=Dict{Int,AbstractRuleNode}(),
                    actions::Ref{Int}=Ref{Int}(0),
                    trace::Vector{KarelState}=KarelState[],              
                    include_initial::Bool=false)                         
        input_state = deepcopy(example.in[:_arg_1])
        tags = get_relevant_tags(grammar)
        if include_initial
            push!(trace, deepcopy(input_state))
        end
        state = interpret(prog, tags, input_state, new_rules_decoding, actions, trace)  # pass trace
        return state, actions[], trace
    end


    function interpret(prog::AbstractRuleNode, tags::Dict{Int,Symbol}, state::KarelState,
                    new_rules_decoding::Dict{Int,AbstractRuleNode}, actions::Ref{Int},
                    trace::Vector{KarelState})  
        rule_node = get_rule(prog)
        if haskey(new_rules_decoding, rule_node)
            return interpret(new_rules_decoding[rule_node], tags, state, new_rules_decoding, actions, trace)
        end

        @match tags[rule_node] begin
            :Block => begin
                if length(prog.children) == 1
                    interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
                else
                    state = interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
                    interpret(prog.children[2], tags, state, new_rules_decoding, actions, trace)
                end
            end
            :move       => record_if_changed!(state, trace, actions) do
                move(state.hero, state.world)          # failed move → no record
            end
            :turnLeft   => record_if_changed!(state, trace, actions) do
                state.hero = turn_left(state.hero)
            end
            :turnRight  => record_if_changed!(state, trace, actions) do
                state.hero = turn_right(state.hero)
            end
            :pickMarker => record_if_changed!(state, trace, actions) do
                pick_marker!(state)                     # no marker → no record
            end
            :putMarker  => record_if_changed!(state, trace, actions) do
                put_marker!(state)                      # empty bag → no record
            end
            :IF => begin
                condition = interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
                condition ? interpret(prog.children[2], tags, state, new_rules_decoding, actions, trace) : state
            end
            :IFELSE => begin
                condition = interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
                if condition
                    interpret(prog.children[2], tags, state, new_rules_decoding, actions, trace)
                else
                    interpret(prog.children[3], tags, state, new_rules_decoding, actions, trace)
                end
            end
            :WHILE => command_while(prog.children[1], prog.children[2], tags, state,
                                    new_rules_decoding, 2 * max(size(state.world)...), actions, trace)
            :REPEAT => begin
                count = begin
                    first_int_rule_idx = 13
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
                    state = interpret(prog.children[2], tags, state, new_rules_decoding, actions, trace)
                end
                state
            end
            :frontIsClear     => front_is_clear(state)
            :leftIsClear      => left_is_clear(state)
            :rightIsClear     => right_is_clear(state)
            :markersPresent   => markers_present(state)
            :noMarkersPresent => no_markers_present(state)
            :NOT => !interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
            _ => begin
                if !isempty(prog.children)
                    interpret(prog.children[1], tags, state, new_rules_decoding, actions, trace)
                else
                    state
                end
            end
        end
    end


    function command_while(condition::AbstractRuleNode, body::AbstractRuleNode, tags::Dict{Int,Symbol},
        state::KarelState, new_rules_decoding::Dict{Int,AbstractRuleNode},
        max_steps::Int=1000, actions::Ref{Int}=Ref(0), trace::Vector{KarelState}=KarelState[])
        counter = max_steps
        while interpret(condition, tags, state, new_rules_decoding, actions, trace) && counter > 0
            state = interpret(body, tags, state, new_rules_decoding, actions, trace)
            counter -= 1
        end
        state
    end


    # Sum all markers on the grid
    count_markers(m::Dict{Tuple{Int,Int},Int}) = sum(values(m))

    # Return :pick if bag +1 & grid markers -1, :drop if bag -1 & grid markers +1
    function classify_transition(s1::KarelState, s2::KarelState)
        bag_diff = s2.hero.marker_count - s1.hero.marker_count
        map_diff = count_markers(s2.markers) - count_markers(s1.markers)
        if bag_diff == 1 && map_diff == -1
            return :pick
        elseif bag_diff == -1 && map_diff == 1
            return :drop
        else
            return :other
        end
    end


    function trace_has_pick_then_drop_at_different_cells(trace::Vector{KarelState})::Bool
        length(trace) < 2 && return false
        init  = trace[1]
        final = trace[end]

        last_pick_pos = nothing :: Union{Nothing, Tuple{Int,Int}}
        moves_since_pick = 0

        @inbounds for i in 1:length(trace)-1
            # track motion since the last pick
            if last_pick_pos !== nothing &&
            trace[i+1].hero.position != trace[i].hero.position
                moves_since_pick += 1
            end

            ev = classify_transition(trace[i], trace[i+1])

            if ev === :pick
                last_pick_pos = trace[i].hero.position
                moves_since_pick = 0

            elseif ev === :drop && last_pick_pos !== nothing
                drop_pos = trace[i].hero.position
                if drop_pos != last_pick_pos && moves_since_pick >= 1
                    # forbid any later re-pick from the same drop cell
                    re_picked = false
                    for j in i+1:length(trace)-1
                        if classify_transition(trace[j], trace[j+1]) === :pick &&
                        trace[j].hero.position == drop_pos
                            re_picked = true
                            break
                        end
                    end
                    if !re_picked
                        # net deltas between initial and final snapshots
                        pick_delta = get(final.markers, last_pick_pos, 0) - get(init.markers, last_pick_pos, 0)
                        drop_delta = get(final.markers, drop_pos, 0)      - get(init.markers, drop_pos, 0)
                        if drop_delta > 0 && pick_delta < 0
                            return true  # transported and *left* the marker at a different cell
                        end
                    end
                end
                # reset and keep scanning for another pick→drop interval
                last_pick_pos = nothing
                moves_since_pick = 0
            end
        end
        return false
    end



    function picks_then_drops_on_any_world(p, grammar, worlds)::Bool
        for w in worlds
            ex  = IOExample(Dict(:_arg_1 => w), nothing)
            buf = KarelState[]  # fresh per world
            _, _, tr = interpret(p, grammar, ex; trace=buf, include_initial=true)
            if trace_has_pick_then_drop_at_different_cells(tr)   
                return true
            end
        end
        return false
    end
    #############################################################################################


    const TARGET_ACTIONS = 5

    # True if program executes exactly `target` actions on at least one world
    function hits_target_on_any_world(p, grammar, worlds, target)::Bool
        for w in worlds
            ex = IOExample(Dict(:_arg_1 => w), nothing)
            _, n_actions, _ = interpret(p, grammar, ex)
            if n_actions == target
                return true
            end
        end
        return false
    end

    # Run the chosen program on all worlds and collect traces
    function collect_traces_for_program(p, grammar, worlds; include_initial::Bool=true)
        finals  = KarelState[]
        traces  = Trace{KarelState}[]
        counts  = Int[]
        for w in worlds
            ex  = IOExample(Dict(:_arg_1 => w), nothing)
            buf = KarelState[]  # fresh buffer per world
            final_state, n_actions, exec_path = interpret(p, grammar, ex; trace=buf, include_initial=include_initial)
            push!(finals, final_state)
            push!(traces, Trace(exec_path))
            push!(counts, n_actions)
            @info "world trace" actions=n_actions trace_len=length(exec_path)
        end
        return finals, traces, counts
    end

    """
    Return one sampled program that hits `target` actions on at least one of `n_worlds`
    freshly generated worlds; also returns its traces on those worlds. No printing/saving.
    """
    function generate_one(grammar; target=5, max_tries=100_000, max_depth=8,
                        include_initial=true, verbose=false, n_worlds=5)

        worlds = [gen_world() for _ in 1:n_worlds]

        tries = 0
        found_prog = nothing
        found_expr = nothing
        for p in RandomIterator(grammar, :Start, max_depth=max_depth;)
            tries += 1
            
            # Must hit target action count on ≥1 world AND actually pick then drop on ≥1 world
            if picks_then_drops_on_any_world(p, grammar, worlds) && hits_target_on_any_world(p, grammar, worlds, target)
                found_prog = p
                found_expr = rulenode2expr(p, grammar)
                verbose && println("Picked program: ", found_expr)
                break
            end

            if tries >= max_tries
                println("Gave up after $tries tries")
                break
            end
        end

        isnothing(found_prog) && return nothing

        finals, traces, counts = collect_traces_for_program(found_prog, grammar, worlds;
                                                            include_initial=include_initial)
        println(found_expr)
        return (; program = string(found_expr),
                worlds,
                finals,
                per_world_actions = counts,
                traces)
    end


    function generate_many(grammar;
                        count::Int,
                        n_worlds::Int=5,
                        target::Int=TARGET_ACTIONS,
                        max_tries::Int=1_000_000,
                        max_depth::Int=8,
                        outpath::String="karel_dataset.jls",
                        include_initial::Bool=true,
                        verbose::Bool=false,
                        max_failures::Int=10_000)  # overall cap to avoid infinite loops

        entries = NamedTuple[]
        seen    = Set{String}()
        failures = 0

        while length(entries) < count && failures < max_failures
            rec = generate_one(grammar;
                            n_worlds=n_worlds,
                            target=target,
                            max_tries=max_tries,
                            max_depth=max_depth,
                            include_initial=include_initial,
                            verbose=verbose)

            if rec === nothing
                failures += 1
                if verbose && failures % 100 == 0
                    @info "No program found this round; retrying with new worlds" failures
                end
                continue   # ← try again; generate_one will create NEW worlds
            end

            if rec.program ∉ seen
                push!(entries, rec)
                push!(seen, rec.program)
                verbose && println("Collected #$(length(entries)): ", rec.program)
            end
        end

        serialize(outpath, (; target, max_depth, programs = entries))
        println("Saved $(length(entries)) / $count programs (each with $n_worlds worlds) to $(outpath)")
        return outpath, length(entries)
    end



    # ------------------- CLI -------------------
    if abspath(PROGRAM_FILE) == @__FILE__
        arg = (i, default) -> (length(ARGS) >= i ? ARGS[i] : default)

        num_programs = parse(Int, arg(1, "10"))
        outpath      = arg(2, "karel_dataset.jls")
        target       = parse(Int, arg(3, string(TARGET_ACTIONS)))
        max_depth    = parse(Int, arg(4, "8"))
        n_worlds     = parse(Int, arg(5, "5"))   # <— NEW: worlds per program

        generate_many(grammar_karel;
                    count=num_programs,
                    n_worlds=n_worlds,
                    target=target,
                    max_depth=max_depth,
                    outpath="karel_dataset_6.jls",
                    verbose=false)
    end

using Test
using HerbBenchmarks.Karel_2018

@testset "Karel Tests" begin
    @testset "Basic World Creation" begin
        world = create_world(5, 5)
        @test size(world) == (5, 5)
        @test all(world[1, :] .== WALL_CHAR)  # Top wall
        @test all(world[end, :] .== WALL_CHAR)  # Bottom wall
        @test all(world[:, 1] .== WALL_CHAR)  # Left wall
        @test all(world[:, end] .== WALL_CHAR)  # Right wall
        @test all(world[2:4, 2:4] .== EMPTY_CHAR)  # Inner space
    end

    @testset "Hero Movement" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), (1, 0))  # Facing east
        # Test moving forward
        new_hero = move(hero, world)
        @test new_hero.position == (3, 2)
        @test new_hero.facing == (1, 0)
        # Test turning left
        left_hero = turn_left(hero)
        @test left_hero.position == (2, 2)
        @test left_hero.facing == (0, -1)
        # Test turning right
        right_hero = turn_right(hero)
        @test right_hero.position == (2, 2)
        @test right_hero.facing == (0, 1)
        # Test moving into wall
        wall_hero = Hero((2, 2), (0, -1))  # Facing wall
        @test isnothing(move(wall_hero, world))
    end

    @testset "Marker Operations" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), (1, 0))
        state = KarelState(world, Tuple{Int,Int}[], hero, false)
        # Test putting marker
        @test put_marker!(state)
        @test length(state.markers) == 1
        @test state.markers[1] == (2, 2)
        # Test picking marker
        @test pick_marker!(state)
        @test isempty(state.markers)
        # Test picking from empty space
        @test !pick_marker!(state)
    end

    @testset "State Conversion" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), (1, 0))  # Facing east
        markers = [(2, 2), (3, 3)]
        state = KarelState(world, markers, hero, false)
        # Conversion
        array = state_to_array(state)
        new_state = array_to_state(array)
        # Check conversion preserved state
        @test new_state.hero.position == state.hero.position
        @test new_state.hero.facing == state.hero.facing
        @test sort(new_state.markers) == sort(state.markers)
        @test new_state.world == state.world
    end

    @testset "Program Interpretation" begin
        prog = RuleNode(1, [  # Start -> Block
            RuleNode(2, [     # Block -> Action
                RuleNode(5, [])  # Action -> move
            ])
        ])
        world = create_world(5, 5)
        hero = Hero((2, 2), (1, 0))  # Facing east
        initial_state = KarelState(world, Tuple{Int,Int}[], hero, false)

        example = IOExample(
            Dict(:_arg_1 => state_to_array(initial_state)),
            zeros(5, 5, 16)  # Dummy output state
        )
        result = interpret(prog, grammar_karel, example)

        # Check results
        @test size(result) == (5, 5, 16)
        final_state = array_to_state(result)
        # Should have moved one step east
        @test final_state.hero.position == (3, 2)
    end

    # @testset "Data Loading" begin
    #     examples = load_karel_data(joinpath(@__DIR__, "..", "src", "data", "Karel_2018", "data.npz"))
    #     @test length(examples) > 0
    #     @test all(ex -> haskey(ex.in, :_arg_1), examples)
    #     @test all(ex -> isa(ex.in[:_arg_1], Array), examples)
    #     @test all(ex -> isa(ex.out, Array), examples)
    # end
end
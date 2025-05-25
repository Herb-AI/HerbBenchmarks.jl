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
        # Test each direction
        hero_east = Hero((3, 3), direction_to_vector(EAST))
        hero_west = Hero((3, 3), direction_to_vector(WEST))
        hero_north = Hero((3, 3), direction_to_vector(NORTH))
        hero_south = Hero((3, 3), direction_to_vector(SOUTH))
        # Test moving in each direction
        @test move(hero_east, world) == true
        @test hero_east.position == (4, 3)
        @test move(hero_west, world) == true
        @test hero_west.position == (2, 3)
        @test move(hero_north, world) == true
        @test hero_north.position == (3, 2)
        @test move(hero_south, world) == true
        @test hero_south.position == (3, 4)
        # Test turning left from each direction
        @test vector_to_direction(turn_left(hero_east).facing) == NORTH
        @test vector_to_direction(turn_left(hero_north).facing) == WEST
        @test vector_to_direction(turn_left(hero_west).facing) == SOUTH
        @test vector_to_direction(turn_left(hero_south).facing) == EAST
        # Test turning right from each direction
        @test vector_to_direction(turn_right(hero_east).facing) == SOUTH
        @test vector_to_direction(turn_right(hero_south).facing) == WEST
        @test vector_to_direction(turn_right(hero_west).facing) == NORTH
        @test vector_to_direction(turn_right(hero_north).facing) == EAST
        # Test moving into wall
        wall_hero = Hero((2, 2), direction_to_vector(WEST))  # Facing wall
        @test move(wall_hero, world) == false
        @test wall_hero.position == (2, 2)  # Position unchanged
    end

    @testset "Marker Operations" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), direction_to_vector(EAST))
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
        hero = Hero((2, 2), direction_to_vector(EAST))  # Facing east
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
        hero = Hero((2, 2), direction_to_vector(EAST))  # Facing east
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
        @test final_state.hero.facing == direction_to_vector(EAST)
    end

    @testset "Data Loading" begin
        # Only run data format tests if file exists
        problems = Karel_2018.get_all_problems()
        # print(problems)
        # Basic structure tests
        # @test !isempty(problems) "No problems loaded from dataset"
        # @test all(p -> !isempty(p.examples), problems) "Found problem with no examples"

        # Verify data format
        # for problem in problems
        #     for example in problem.examples
        #         # Check input format
        #         @test haskey(example.in, :_arg_1)
        #         @test length(size(example.in[:_arg_1])) == 3  # Should be 3D array
        #         @test size(example.in[:_arg_1], 3) == 16  # 16 channels

        #         # Check output format
        #         @test size(example.out) == size(example.in[:_arg_1])

        #         # Convert and check basic state structure
        #         input_state = array_to_state(example.in[:_arg_1])
        #         @test input_state.world isa Matrix{Char}
        #         @test input_state.hero.position isa Tuple{Int,Int}
        #         @test input_state.hero.facing isa Tuple{Int,Int}
        #         @test input_state.markers isa Vector{Tuple{Int,Int}}
        #     end
        # end
    end
end
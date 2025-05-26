using Test
using HerbBenchmarks.Karel_2018

@testset "Karel Tests" begin
    @testset "Basic World Creation" begin
        world = create_world(5, 5)
        @test size(world) == (5, 5)
        @test all(world[1, :])  # Top wall
        @test all(world[end, :])  # Bottom wall
        @test all(world[:, 1])  # Left wall
        @test all(world[:, end])  # Right wall
        @test !any(world[2:4, 2:4])  # Inner space
    end

    @testset "Hero Movement" begin
        world = create_world(5, 5)
        # Test each direction
        hero_east = Hero((3, 3), EAST)
        hero_west = Hero((3, 3), WEST)
        hero_north = Hero((3, 3), NORTH)
        hero_south = Hero((3, 3), SOUTH)
        # Test moving in each direction
        @test move(hero_east, world) == true
        @test hero_east.position == (4, 3)
        @test move(hero_west, world) == true
        @test hero_west.position == (2, 3)
        @test move(hero_north, world) == true
        @test hero_north.position == (3, 2)
        @test move(hero_south, world) == true
        @test hero_south.position == (3, 4)
        # Test moving into wall
        wall_hero = Hero((2, 2), WEST)
        @test move(wall_hero, world) == false
        # Position unchanged
        @test wall_hero.position == (2, 2)
    end

    @testset "Hero Turning Left" begin
        # Test each direction
        hero_east = Hero((3, 3), EAST)
        hero_west = Hero((3, 3), WEST)
        hero_north = Hero((3, 3), NORTH)
        hero_south = Hero((3, 3), SOUTH)
        # Test turning left from each direction
        @test turn_left(hero_east).direction == NORTH
        @test turn_left(hero_north).direction == WEST
        @test turn_left(hero_west).direction == SOUTH
        @test turn_left(hero_south).direction == EAST
    end

    @testset "Hero Turning Right" begin
        # Test each direction
        hero_east = Hero((3, 3), EAST)
        hero_west = Hero((3, 3), WEST)
        hero_north = Hero((3, 3), NORTH)
        hero_south = Hero((3, 3), SOUTH)
        # Test turning right from each direction
        @test turn_right(hero_east).direction == SOUTH
        @test turn_right(hero_south).direction == WEST
        @test turn_right(hero_west).direction == NORTH
        @test turn_right(hero_north).direction == EAST

    end

    @testset "Marker Operations" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), EAST)
        state = KarelState(world, hero)
        state.markers[(3, 2)] = 1
        # No markers in bag - should not be able to put
        @test !put_marker!(state)
        @test state.hero.marker_count == 0
        @test length(state.markers) == 1
        # No marker to pickup at (2, 2)
        @test !pick_marker!(state)
        @test state.hero.marker_count == 0
        @test length(state.markers) == 1
        # Move and pickup marker
        @test move(hero, world) == true
        @test pick_marker!(state)
        @test state.hero.marker_count == 1
        @test length(state.markers) == 0
        # Put marker down
        @test put_marker!(state)
        @test state.hero.marker_count == 0
        @test length(state.markers) == 1
    end

    @testset "State Conversion" begin
        world = create_world(5, 5)
        hero = Hero((2, 2), EAST)  # Facing east
        state = KarelState(world, hero)
        state.markers = Dict([(2, 2), (3, 3)] .=> 1)
        # Conversion
        array = state_to_array(state)
        new_state = array_to_state(array)
        # Check conversion preserved state
        @test new_state.hero.position == state.hero.position
        @test new_state.hero.direction == state.hero.direction
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
        hero = Hero((2, 2), EAST)  # Facing east
        initial_state = KarelState(world, hero)
        example = IOExample(Dict(:_arg_1 => initial_state), 0)
        result = interpret(prog, grammar_karel, example)
        # Check results
        @test size(result.world) == (5, 5)
        # Should have moved one step east
        @test result.hero.position == (3, 2)
        @test result.hero.direction == EAST
        # Original hero unchanged
        @test hero.position == (2, 2)
    end

    @testset "Data Loading" begin
        # Only run data format tests if file exists
        problems = Karel_2018.get_all_problems()
        # Basic structure tests
        @test !isempty(problems)
        @test all(p -> !isempty(p.spec) && length(p.spec) == 10, problems)
        # Verify data format
        for problem in problems
            for example in problem.spec
                input_state = example.in[:_arg_1]
                # println(input_state)
                # Check input format
                @test input_state.world isa Matrix{Bool} &&             # World is character matrix
                      size(input_state.world) == (8, 8) &&              # Same shape
                      all(input_state.world[1, :]) &&                   # Top wall
                      all(input_state.world[end, :]) &&                 # Bottom wall
                      all(input_state.world[:, 1]) &&                   # Left wall
                      all(input_state.world[:, end]) &&                 # Right wall
                      all(0 .< input_state.hero.position .< 8) &&       # Hero position not on edges/walls
                      input_state.hero.direction isa Direction &&       # initialized
                      input_state.markers isa Dict                      # initialized
            end
        end
    end
end
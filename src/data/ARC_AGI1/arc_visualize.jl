# ARC REPL visualization

# Approximate ARC color palette
const ARC_COLORS = Dict(
    0 => (0,   0,   0),     # black
    1 => (0,   116, 217),   # blue
    2 => (255, 65,  54),    # red
    3 => (46,  204, 64),    # green
    4 => (255, 220, 0),     # yellow
    5 => (170, 170, 170),   # gray
    6 => (240, 18,  190),   # magenta
    7 => (255, 133, 27),    # orange
    8 => (127, 219, 255),   # cyan
    9 => (135, 12,  37),    # brown-ish
)

bg(rgb) = "\e[48;2;$(rgb[1]);$(rgb[2]);$(rgb[3])m"
fg(rgb) = "\e[38;2;$(rgb[1]);$(rgb[2]);$(rgb[3])m"
reset() = "\e[0m"

function text_color_for(bg_rgb)
    y = 0.299 * bg_rgb[1] + 0.587 * bg_rgb[2] + 0.114 * bg_rgb[3]
    return y > 140 ? (0, 0, 0) : (255, 255, 255)
end

function grid_lines(grid::Grid; show_numbers::Bool=false, show_axes::Bool=false)
    lines = String[]

    if show_axes
        header = "    " * join(lpad.(string.(1:grid.width), 2), "")
        push!(lines, header)
    end

    for i in 1:grid.height
        row_io = IOBuffer()

        if show_axes
            print(row_io, lpad(string(i), 3), " ")
        end

        for j in 1:grid.width
            val = grid.data[i, j]
            rgb = get(ARC_COLORS, val, (255, 255, 255))
            if show_numbers
                print(row_io, bg(rgb), fg(text_color_for(rgb)), lpad(string(val), 2), reset())
            else
                print(row_io, bg(rgb), "  ", reset())
            end
        end

        push!(lines, String(take!(row_io)))
    end

    return lines
end

function visualize(grid::Grid; show_numbers::Bool=false, show_axes::Bool=false)
    for line in grid_lines(grid; show_numbers=show_numbers, show_axes=show_axes)
        println(line)
    end
end

visualize(mat::Matrix{Int}; kwargs...) = visualize(Grid(mat); kwargs...)

function visualize_example(ex::IOExample; show_numbers::Bool=false, show_axes::Bool=false)
    input_grid = ex.in[:_arg_1]
    output_grid = ex.out

    println("Input:")
    visualize(input_grid; show_numbers=show_numbers, show_axes=show_axes)
    println()

    println("Output:")
    visualize(output_grid; show_numbers=show_numbers, show_axes=show_axes)
end

function visualize(problem::Problem; show_numbers::Bool=false, show_axes::Bool=false)
    examples = problem.spec

    println("Problem: ", problem.name)
    println("Examples: ", length(examples))
    println()

    for (i, ex) in enumerate(examples)
        println("Example ", i)
        visualize_example(ex; show_numbers=show_numbers, show_axes=show_axes)
        println()
        println(repeat("─", 40))
        println()
    end
end
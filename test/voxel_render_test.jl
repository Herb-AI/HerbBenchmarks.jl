@testitem "VoxelRender" begin
    import HerbBenchmarks: VoxelRender
    const VR = VoxelRender

    palette = [(200, 40, 40), (40, 200, 40), (40, 40, 200)]
    scene = Dict{NTuple{3,Int},Int}((x, y, z) => 1 + mod(x + y + z, 3)
                                    for x in 0:3, y in 0:2, z in 0:3)

    @testset "SVG" begin
        svg = VR.voxel_svg(scene, palette; scale = 8)
        @test startswith(svg, "<svg")
        @test endswith(rstrip(svg), "</svg>")
        # Three visible faces per voxel, plus the background rect.
        @test count("<polygon", svg) == 3 * length(scene)
    end

    @testset "painter's order" begin
        # Nearer voxels must be drawn later, so they overwrite farther ones.
        order = VR.paint_order(scene)
        @test length(order) == length(scene)
        @test issorted([sum(cell) for cell in order])
    end

    @testset "raster" begin
        (pixels, gif_palette) = VR.voxel_raster(scene, palette; scale = 6)
        @test eltype(pixels) == UInt8
        # Background plus three face shades and an edge tone per colour.
        @test length(gif_palette) == 4 * length(palette) + 1
        @test all(1 .<= pixels .<= length(gif_palette))
        @test 1 in pixels                       # some background survives
        @test length(unique(pixels)) > 4        # and the voxels are drawn

        # A palette too large for a GIF colour table is rejected, not truncated.
        @test_throws ArgumentError VR.voxel_raster(scene, fill((1, 2, 3), 64))
    end

    @testset "GIF encoding" begin
        path = tempname() * ".gif"
        frames = [Dict{NTuple{3,Int},Int}(cell => scene[cell]
                                          for cell in VR.paint_order(scene)[1:k])
                  for k in (1, 8, length(scene))]
        VR.voxel_gif(path, frames, palette; scale = 5, delay_cs = 10)

        bytes = read(path)
        @test bytes[1:6] == b"GIF89a"
        @test bytes[end] == 0x3B                       # trailer
        @test occursin("NETSCAPE2.0", String(copy(bytes)))  # loops forever

        # Every frame shares the canvas of the largest, so an animation does not
        # drift as the model grows.
        (width, height) = (Int(bytes[7]) | Int(bytes[8]) << 8,
            Int(bytes[9]) | Int(bytes[10]) << 8)
        @test width > 0 && height > 0

        @test_throws ArgumentError VR.voxel_gif(path, typeof(first(frames))[], palette)
    end

    @testset "LZW round-trips" begin
        # Decode with an independent implementation, so a desynchronised code
        # width cannot pass unnoticed: a GIF encoder that is subtly wrong still
        # produces a file, just not one anybody can read.
        function lzw_decode(data::Vector{UInt8}, min_code_size::Int)
            clear = 1 << min_code_size
            eoi = clear + 1
            table = Dict{Int,Vector{UInt8}}(i => UInt8[i] for i in 0:(clear-1))
            next_code = eoi + 1
            # The decoder tracks code width one step behind the encoder.
            running, bits, maxcode = eoi + 1, min_code_size + 1, 1 << (min_code_size + 1)
            out = UInt8[]
            previous = nothing
            buffer = 0
            held = 0
            index = 1
            while true
                while held < bits
                    index > length(data) && return out
                    buffer |= Int(data[index]) << held
                    held += 8
                    index += 1
                end
                code = buffer & ((1 << bits) - 1)
                buffer >>= bits
                held -= bits
                running += 1
                if running > maxcode && bits < 12
                    maxcode <<= 1
                    bits += 1
                end
                code == eoi && return out
                if code == clear
                    table = Dict{Int,Vector{UInt8}}(i => UInt8[i] for i in 0:(clear-1))
                    next_code = eoi + 1
                    running, bits, maxcode = eoi + 1, min_code_size + 1, 1 << (min_code_size + 1)
                    previous = nothing
                    continue
                end
                entry = haskey(table, code) ? table[code] :
                        (code == next_code && previous !== nothing) ?
                        [previous; previous[1]] : error("bad LZW code $code")
                append!(out, entry)
                if previous !== nothing && next_code < 4096
                    table[next_code] = [previous; entry[1]]
                    next_code += 1
                end
                previous = entry
            end
        end

        for (data, min_code_size) in (
            (UInt8[0, 1, 2, 3], 2),
            ([fill(0x01, 50); fill(0x02, 50)], 4),
            (UInt8.(mod.(0:20_000, 16)), 4),
            (UInt8.(rand(0:255, 5_000)), 8),
        )
            encoded = VR._lzw_encode(data, min_code_size)
            @test lzw_decode(encoded, min_code_size) == data
        end
    end
end

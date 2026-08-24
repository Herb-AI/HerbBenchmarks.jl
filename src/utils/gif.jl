"""
A minimal GIF89a encoder.

Written out longhand so that rendering an animation costs HerbBenchmarks no
dependencies. It handles exactly the case the voxel visualisers need: a
sequence of palette-indexed frames sharing one global colour table, looping
forever. See [`write_gif`](@ref).
"""

"""
    write_gif(path, frames, palette; delay_cs=25, loop=true)

Write palette-indexed `frames` to `path` as an animated GIF.

Every frame is a `Matrix{UInt8}` of *one-based* indices into `palette`, a
vector of `(r, g, b)` triples of at most 256 entries. Row 1 is the top of the
image. `delay_cs` is the delay between frames in hundredths of a second.

```julia
julia> write_gif("build.gif", frames, palette; delay_cs=12)
```
"""
function write_gif(path::AbstractString,
    frames::AbstractVector{<:AbstractMatrix{UInt8}},
    palette::AbstractVector{<:NTuple{3,Integer}};
    delay_cs::Integer=25, loop::Bool=true)
    open(path, "w") do io
        write_gif(io, frames, palette; delay_cs=delay_cs, loop=loop)
    end
    return path
end

function write_gif(io::IO,
    frames::AbstractVector{<:AbstractMatrix{UInt8}},
    palette::AbstractVector{<:NTuple{3,Integer}};
    delay_cs::Integer=25, loop::Bool=true)
    isempty(frames) && throw(ArgumentError("a GIF needs at least one frame"))
    length(palette) <= 256 ||
        throw(ArgumentError("a GIF palette holds at most 256 colours, got $(length(palette))"))
    allequal(size.(frames)) ||
        throw(DimensionMismatch("every frame must have the same size"))

    height, width = size(first(frames))
    # The colour table is padded up to a power of two; `depth` is its exponent.
    depth = max(1, ceil(Int, log2(max(2, length(palette)))))

    write(io, "GIF89a")
    _le16(io, width)
    _le16(io, height)
    write(io, UInt8(0x80 | ((depth - 1) << 4) | (depth - 1)))  # global table, sorted flags
    write(io, UInt8(0))                                        # background colour index
    write(io, UInt8(0))                                        # pixel aspect ratio

    for i in 1:(1<<depth)
        (r, g, b) = i <= length(palette) ? palette[i] : (0, 0, 0)
        write(io, UInt8(r), UInt8(g), UInt8(b))
    end

    if loop && length(frames) > 1
        write(io, UInt8(0x21), UInt8(0xFF), UInt8(11))
        write(io, "NETSCAPE2.0")
        write(io, UInt8(3), UInt8(1))
        _le16(io, 0)          # 0 = repeat forever
        write(io, UInt8(0))
    end

    # A GIF's minimum LZW code size must be at least 2, even for 1-bit images.
    min_code_size = max(2, depth)
    for frame in frames
        write(io, UInt8(0x21), UInt8(0xF9), UInt8(4))
        write(io, UInt8(0))   # no transparency, no disposal
        _le16(io, delay_cs)
        write(io, UInt8(0), UInt8(0))

        write(io, UInt8(0x2C))
        _le16(io, 0)
        _le16(io, 0)
        _le16(io, width)
        _le16(io, height)
        write(io, UInt8(0))   # no local colour table, not interlaced

        write(io, UInt8(min_code_size))
        # `permutedims` puts the matrix in row-major order, which is the order
        # GIF stores pixels in; the shift converts Julia's one-based palette
        # indices to the zero-based ones the colour table uses.
        _sub_blocks(io, _lzw_encode(vec(permutedims(frame)) .- 0x01, min_code_size))
        write(io, UInt8(0))   # block terminator
    end

    write(io, UInt8(0x3B))    # trailer
    return nothing
end

"""
    _le16(io, value)

Write `value` as a little-endian 16-bit integer, the only multi-byte number
format GIF uses.
"""
_le16(io::IO, value::Integer) = write(io, UInt8(value & 0xFF), UInt8((value >> 8) & 0xFF))

"""
    _sub_blocks(io, bytes)

Write `bytes` as GIF sub-blocks: runs of at most 255 bytes, each preceded by
its length. The caller writes the terminating zero byte.
"""
function _sub_blocks(io::IO, bytes::Vector{UInt8})
    offset = 1
    while offset <= length(bytes)
        chunk = min(255, length(bytes) - offset + 1)
        write(io, UInt8(chunk))
        write(io, view(bytes, offset:(offset+chunk-1)))
        offset += chunk
    end
    return nothing
end

"""
    _lzw_encode(indices, min_code_size) -> Vector{UInt8}

GIF-flavoured LZW: variable-width codes packed least-significant-bit first,
with a clear code and an end-of-information code reserved above the literals.

The dictionary is reset whenever it fills to 12-bit codes, which is what keeps
the code width bounded and lets a decoder stay in step without any header.
"""
function _lzw_encode(indices::AbstractVector{UInt8}, min_code_size::Int)
    clear_code = 1 << min_code_size
    eoi_code = clear_code + 1

    out = UInt8[]
    bit_buffer = UInt32(0)
    bit_count = 0
    code_size = min_code_size + 1

    function emit(code::Integer)
        bit_buffer |= UInt32(code) << bit_count
        bit_count += code_size
        while bit_count >= 8
            push!(out, UInt8(bit_buffer & 0xFF))
            bit_buffer >>= 8
            bit_count -= 8
        end
    end

    # Keys are (prefix_code, next_index); the initial single-index entries are
    # implicit, so the table only ever stores multi-symbol strings.
    table = Dict{Tuple{Int,UInt8},Int}()
    next_code = eoi_code + 1

    emit(clear_code)
    isempty(indices) && (emit(eoi_code); bit_count > 0 && push!(out, UInt8(bit_buffer & 0xFF)); return out)

    prefix = Int(indices[1])
    for i in 2:length(indices)
        symbol = indices[i]
        existing = get(table, (prefix, symbol), 0)
        if existing != 0
            prefix = existing
            continue
        end

        emit(prefix)
        if next_code < 4096
            table[(prefix, symbol)] = next_code
            next_code += 1
            # Widen once the code just issued no longer fits the current
            # width. A decoder runs the same counter one step behind, so this
            # exact off-by-one is what keeps the two in step (cf. giflib's
            # EGifCompressOutput / DGifDecompressInput).
            if next_code - 1 >= (1 << code_size) && code_size < 12
                code_size += 1
            end
        else
            emit(clear_code)
            empty!(table)
            next_code = eoi_code + 1
            code_size = min_code_size + 1
        end
        prefix = Int(symbol)
    end

    emit(prefix)
    emit(eoi_code)
    bit_count > 0 && push!(out, UInt8(bit_buffer & 0xFF))
    return out
end

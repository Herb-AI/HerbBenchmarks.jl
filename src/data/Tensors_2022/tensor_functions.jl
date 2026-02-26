tf_abs(x) = abs.(x)
tf_add(x, y) = x .+ y
tf_add_n(inputs) = reduce(.+, inputs)
tf_argmax(input, axis) = argmax(input, dims=axis)
tf_argmin(input, axis) = argmin(input, dims=axis)
tf_argsort_ascending(values, axis) = mapslices(x -> sortperm(x), values; dims=axis)
tf_argsort_descending(values, axis) = mapslices(x -> sortperm(x, rev=true), values; dims=axis)
tf_boolean_mask(tensor, mask) = tensor[mask]
# tf_broadcast_to(input, shape) = 
tf_cast(x, dtype) = convert.(dtype, x)
tf_clip_by_value(t, clip_value_min, clip_value_max) = clamp.(t, clip_value_min, clip_value_max)
tf_concat(values, axis) = cat(values...; dims=axis)
tf_constant(value) = value
tf_constant(value, dtype) = convert.(dtype, value)
tf_divide(x, y) = x ./ y
tf_equal(x, y) = x .== y
tf_exp(x) = exp.(x)
tf_expand_dims(input, axis) = Flux.unsqueeze(input, axis)
tf_eye(num_rows) = Float32.(I(num_rows))
tf_eye(num_rows, num_columns) = Matrix{Float32}(I, num_rows, num_columns)
tf_eye(num_rows, dtype) = convert.(dtype, Matrix(I, num_rows, num_rows))
tf_fill(dims, value) = fill(value, dims...)
tf_gather(params, indices) = params[indices]
tf_gather(params, indices, axis) = selectdim(params, axis, indices) # batch_dims not directly supported
# tf_gather_nd(params, indices) = getindex.(Ref(params), eachrow(indices))
# tf_gather_nd(params, indices, batch_dims) # batch_dims not directly supported
tf_greater(x, y) = x .> y
tf_greater_equal(x, y) = x .>= y
tf_math_bincount(arr) = StatsBase.countmap(arr) # requires StatsBase.jl
tf_math_ceil(x) = ceil.(x)
tf_math_count_nonzero(input) = count(!iszero, input)
tf_math_count_nonzero(input, axis) = mapslices(x -> count(!iszero, x), input; dims=axis)
tf_math_cumsum(x, axis) = cumsum(x, dims=axis)
# tf_math_cumsum(x, axis, exclusive=True)
tf_math_divide_no_nan(x, y) = ifelse.(y .== 0, 0, x ./ y)
tf_math_floor(x) = floor.(x)
tf_math_log(x) = log.(x)
tf_math_negative(x) = .-x
tf_math_reciprocal(x) = 1.0 ./ x
tf_math_reciprocal_no_nan(x) = ifelse.(x .!= 0, 1 ./ x, 0)
# tf_math_segment_max(data, segment_ids)
# tf_math_segment_mean(data, segment_ids)
# tf_math_segment_min(data, segment_ids)
# tf_math_segment_prod(data, segment_ids)
# tf_math_segment_sum(data, segment_ids)
tf_math_squared_difference(x, y) = (x .- y).^2
tf_math_top_k(input, k) = partialsort(input, 1:k; rev=true)
# tf_math_unsorted_segment_max(data, segment_ids, num_segments)
# tf_math_unsorted_segment_mean(data, segment_ids, num_segments)
# tf_math_unsorted_segment_min(data, segment_ids, num_segments)
# tf_math_unsorted_segment_prod(data, segment_ids, num_segments)
# tf_math_unsorted_segment_sum(data, segment_ids, num_segments)
tf_matmul(a, b) = a * b
tf_maximum(x, y) = max.(x, y)
tf_minimum(x, y) = min.(x, y)
tf_multiply(x, y) = x .* y
tf_not_equal(x, y) = x .!= y
tf_one_hot(indices, depth) = Flux.onehotbatch(indices, 1:depth)
tf_ones(shape) = ones(Float32, shape...)
tf_ones_like(input) = ones(Float32, size(input))
# tf_pad(tensor, paddings, mode='CONSTANT')
# tf_pad(tensor, paddings, mode='CONSTANT', constant_values)
# tf_pad(tensor, paddings, mode='REFLECT')
# tf_pad(tensor, paddings, mode='SYMMETRIC')
tf_range(limit) = 1:limit
tf_range(start, limit, delta) = start:delta:limit
tf_reduce_any(input_tensor, axis) = dropdims(any(input_tensor, dims=axis), dims=axis)
tf_reduce_max(input_tensor) = maximum(input_tensor)
tf_reduce_max(input_tensor, axis) = dropdims(maximum(input_tensor, dims=axis), dims=axis)
tf_reduce_mean(input_tensor) = Statistics.mean(input_tensor)
tf_reduce_mean(input_tensor, axis) = dropdims(Statistics.mean(input_tensor, dims=axis), dims=axis)
tf_reduce_min(input_tensor) = minimum(input_tensor)
tf_reduce_min(input_tensor, axis) = dropdims(minimum(input_tensor, dims=axis), dims=axis)
tf_reduce_prod(input_tensor, axis) = dropdims(prod(input_tensor, dims=axis), dims=axis)
tf_reduce_sum(input_tensor) = sum(input_tensor)
tf_reduce_sum(input_tensor, axis) = dropdims(sum(input_tensor, dims=axis), dims=axis)
tf_reshape(tensor, shape) = reshape(permutedims(tensor), shape...)
tf_reverse(tensor, axis) = reverse(tensor, dims=axis)
# tf_roll(input, shift, axis) =
tf_round(x) = round.(x)
tf_searchsortedfirst(sorted_sequence, values) = searchsortedfirst.(Ref(sorted_sequence), values)
tf_searchsortedlast(sorted_sequence, values) = searchsortedlast.(Ref(sorted_sequence), values)
# tf_sequence_mask(lengths)
tf_sequence_mask(lengths, maxlen) = [j <= l for l in lengths, j in 1:maxlen]
tf_shape(input) = size(input)
tf_sign(x) = sign.(x)
tf_sort_ascending(values, axis) = mapslices(x -> sort(x), values; dims=axis)
tf_sort_descending(values, axis) = mapslices(x -> sort(x, rev=true), values; dims=axis)
tf_sqrt(x) = sqrt.(x)
tf_square(x) = x .^ 2
tf_squeeze(input) = squeeze(input)
tf_squeeze(input, axis) = squeeze(input, dims=axis)
tf_stack(values, axis) = cat(values...; dims=axis)
tf_subtract(x, y) = x .- y
# tf_tensordot(a, b, axes) = 
tf_tile(input, multiples) = repeat(input, multiples...)
tf_transpose(a) = permutedims(a)
tf_transpose(a, perm) = permutedims(a, perm)
# tf_unique_with_counts(x) = unique(x, returncounts=true)
tf_unstack(value, axis) = [selectdim(value, axis, i) for i=1:size(value, axis)]
tf_where(condition) = Tuple.(findall(condition))
tf_where(condition, x, y) = ifelse.(condition, x, y)
tf_zeros(shape) = zeros(Float32, shape)
tf_zeros_like(input) = zeros(Float32, size(input))


tf_sparse(indices, values, dense_shape) = SparseArrays.sparse(indices, values, dense_shape)
tf_sprase_add(a, b) = a + b
# tf_sprase_concat(axis, sp_inputs)
tf_sprase_expand_dims(sp_input, axis) = Flux.unsqueeze(sp_input, axis)
tf_sprase_from_dense(tensor) = sparse(tensor)
tf_sprase_maximum(sp_a, sp_b) = max.(sp_a, sp_b)
tf_sprase_minimum(sp_a, sp_b) = min.(sp_a, sp_b)
# tf_sprase_reduce_max(sp_input, axis, output_is_sparse) = maximum(sp_input, dims=axis)
tf_sprase_reduce_max(sp_input, axis) = maximum(sp_input, dims=axis)
# tf_sprase_reduce_sum(sp_input, axis, output_is_sparse)
tf_sprase_reduce_sum(sp_input, axis) = sum(sp_input, dims=axis)
tf_sprase_reset_shape(sp_input) = reshape(permutedims(sp_input), size(sp_input))
tf_sprase_reshape(sp_input, shape) = reshape(permutedims(sp_input), shape...)


tf_index(arg1, arg2) = arg1[arg2]
tf_create_singleton(arg1) = (arg1,)
tf_create_tuple(arg1, arg2) = (arg1, arg2)
tf_create_triplet(arg1, arg2, arg3) = (arg1, arg2, arg3)
tf_slice(arg1, arg2, arg3) = arg1[arg2:arg3]
tf_slice_left(arg1, arg2) = arg1[arg2:end]
tf_slice_right(arg1, arg2) = arg1[1:arg2]
tf_slice_scalar_1(arg1, arg2, arg3) = arg1[:, arg2:arg3]
tf_slice_scalar_1_left(arg1, arg2) = arg1[:, arg2:end]
tf_slice_scalar_1_right(arg1, arg2) = arg1[:, 1:arg2]
tf_index_scalar_1(arg1, arg2) = arg1[:, arg2]

tf_dimension(d) = d
tf_dimensions(d, ds) = [d; ds]

tf_axis(a) = a
tf_axes(a, as) = [a; as]

tf_index(i) = i
tf_slice(i1, i2) = i1:i2
tf_range(r, rs) = [r; rs]

tf_true() = true
tf_false() = false

tf_int() = Int64
tf_float() = Float64
tf_bool() = Bool


function get_relevant_tags(grammar::ContextSensitiveGrammar, args::Dict)
    tags = Dict{Int, Any}()

    for (i, r) in pairs(grammar.rules)
        tags[i] = if haskey(args, r)
            tags[i] = args[r]
        elseif typeof(r) != Expr
            r
        else
            r.args[1]
        end
    end

    return tags
end

const TF_TABLE = Dict(
    Symbol(name) => getfield(@__MODULE__, name)
    for name in names(@__MODULE__, all=true) 
        if startswith(string(name), "tf_") && 
            isdefined(@__MODULE__, name) && 
            isa(getfield(@__MODULE__, name), Function))

function interpret_tensor(prog::AbstractRuleNode, grammar_tags::Dict{Int,Any})
    cs = get_children(prog)
    vals = map(c -> interpret_tensor(c, grammar_tags), cs)
    fname = grammar_tags[get_rule(prog)]

    if haskey(TF_TABLE, fname)
        return TF_TABLE[fname](vals...)
    else
        return fname
    end
end


# # === Example Tests ===
# @testset "Basic elementwise tests" begin
#     x = [-2.0, 0.0, 3.0]
#     y = [1.0, 0.0, -1.0]

#     @test tf_abs(x) == [2.0, 0.0, 3.0]
#     @test tf_add(x, y) == [-1.0, 0.0, 2.0]
#     @test tf_subtract(x, y) == [-3.0, 0.0, 4.0]
#     @test tf_multiply(x, y) == [-2.0, 0.0, -3.0]
#     @test tf_divide(x, [1.0, 1.0, 1.0]) == [-2.0, 0.0, 3.0]
#     @test tf_exp([0.0, 1.0]) ≈ [1.0, exp(1.0)]
#     @test tf_math_log([1.0, exp(1.0)]) ≈ [0.0, 1.0]
#     @test tf_sqrt([0.0, 4.0]) == [0.0, 2.0]
#     @test tf_square([-2.0, 3.0]) == [4.0, 9.0]
#     @test tf_round([0.4, 0.6]) == [0.0, 1.0]
#     @test tf_math_floor([0.6, -0.3]) == [0.0, -1.0]
#     @test tf_math_ceil([0.6, -0.3]) == [1.0, 0.0]
#     @test tf_sign([-5.0, 0.0, 3.0]) == [-1.0, 0.0, 1.0]
#     @test tf_maximum(x, y) == [1.0, 0.0, 3.0]
#     @test tf_minimum(x, y) == [-2.0, 0.0, -1.0]
#     @test tf_clip_by_value(x, -1.0, 2.0) == [-1.0, 0.0, 2.0]
#     @test tf_equal([1,2,3], [1,0,3]) == [true,false,true]
#     @test tf_not_equal([1,2,3], [1,0,3]) == [false,true,false]
#     @test tf_greater([1,2,3], [0,2,4]) == [true,false,false]
#     @test tf_greater_equal([1,2,3], [0,2,4]) == [true,true,false]
#     @test tf_math_reciprocal([2.0, 0.5]) == [0.5, 2.0]
#     @test tf_math_reciprocal_no_nan([2.0, 0.0]) == [0.5, 0.0]
#     @test tf_math_negative([1.0, -2.0]) == [-1.0, 2.0]
# end

# @testset "Indexing and masking tests" begin
#     tensor = [1,2,3,4]
#     mask = [true, false, true, false]
#     @test tf_boolean_mask(tensor, mask) == [1,3]
# end

# @testset "Concatenation and reshape tests" begin
#     a = [1 2; 3 4]
#     b = [5 6; 7 8]
#     @test tf_concat([a,b], 1) == [1 2; 3 4; 5 6; 7 8]
#     @test tf_reshape(a, 4) == [1,2,3,4]
#     @test tf_expand_dims([1,2], 1) == reshape([1,2], 1, :)
#     @test tf_stack([a,b], 3)[:,:,1] == a
#     @test tf_stack([a,b], 3)[:,:,2] == b
# end

# @testset "One-hot tests" begin
#     indices = [1,3,2]
#     oh = tf_one_hot(indices, 3)
#     @test oh[:,1] == [1,0,0]
#     @test oh[:,2] == [0,0,1]
#     @test oh[:,3] == [0,1,0]
# end

# @testset "Reduction tests" begin
#     x = [1 2 3; 4 5 6]

#     @test tf_reduce_sum(x) == 21
#     @test tf_reduce_sum(x, 1) == [5, 7, 9]
#     @test tf_reduce_sum(x, 2) == [6, 15]

#     @test tf_reduce_mean(x) == 3.5
#     @test tf_reduce_mean(x, 1) == [2.5, 3.5, 4.5]
#     @test tf_reduce_mean(x, 2) == [2.0, 5.0]

#     @test tf_reduce_max(x) == 6
#     @test tf_reduce_max(x, 1) == [4, 5, 6]
#     @test tf_reduce_min(x, 2) == [1, 4]

#     @test tf_reduce_prod(x, 1) == [4, 10, 18]
# end

# @testset "Sorting and argsort tests" begin
#     x = [3, 1, 2]

#     @test tf_sort_ascending(x, 1) == [1, 2, 3]
#     @test tf_sort_descending(x, 1) == [3, 2, 1]

#     @test tf_argsort_ascending(x, 1) == [2, 3, 1]
#     @test tf_argsort_descending(x, 1) == [1, 3, 2]

#     @test tf_math_top_k(x, 2) == [3, 2]
# end

# @testset "Gather tests" begin
#     x = [10, 20, 30, 40]

#     @test tf_gather(x, [1, 3]) == [10, 30]

#     m = reshape(1:12, 3, 4)
#     @test tf_gather(m, 2, 1) == m[2, :]

#     # params = reshape(1:9, 3, 3)
#     # indices = [1 1; 3 2]
#     # @test tf_gather_nd(params, indices) == [1, 8]
# end

# @testset "Where and logical tests" begin
#     x = [1, 2, 3]
#     y = [10, 20, 30]

#     cond = [true, false, true]
#     @test tf_where(cond, x, y) == [1, 20, 3]

#     mat = [true false; false true]
#     @test tf_where(mat) == [(1,1), (2,2)]
# end

# # @testset "Broadcasting and tiling tests" begin
# #     x = [1, 2, 3]

# #     @test tf_broadcast_to(x, (3,3)) ==
# #           [1 2 3;
# #            1 2 3;
# #            1 2 3]

# #     @test tf_tile([1, 2], (3,)) == [1,2,1,2,1,2]

# #     @test tf_fill((2,3), 7) ==
# #           [7 7 7;
# #            7 7 7]
# # end

# @testset "Shape and transpose tests" begin
#     x = reshape(1:6, 2, 3)

#     @test tf_shape(x) == (2, 3)
#     @test tf_transpose(x) == permutedims(x)
#     @test tf_transpose(x, (2,1)) == permutedims(x, (2,1))

#     ys = tf_unstack(x, 2)
#     @test length(ys) == 3
#     @test ys[1] == x[:,1]
# end

# @testset "Sequence mask tests" begin
#     lengths = [1, 3, 2]

#     mask = tf_sequence_mask(lengths, 4)
#     @test mask ==
#         [ true false false false;
#           true true  true  false;
#           true true  false false ]
# end

# @testset "Math edge-case tests" begin
#     x = [1.0, 0.0, -1.0]

#     @test tf_math_divide_no_nan([1.0, 2.0, 3.0], [1.0, 0.0, 2.0]) ==
#           [1.0, 0.0, 1.5]

#     @test tf_math_count_nonzero(x) == 2
#     @test tf_math_count_nonzero([1 0; 0 2], 1) == [1 1]

#     @test tf_math_squared_difference([1,2,3], [3,2,1]) == [4,0,4]
# end

# @testset "Sparse tensor tests" begin
#     dense = [1 0 0; 0 2 0]
#     sp = tf_sprase_from_dense(dense)

#     @test Array(sp) == dense

#     @test tf_sprase_add(sp, sp) |> Array ==
#           [2 0 0; 0 4 0]

#     @test tf_sprase_reduce_sum(sp, 1) ==
#           sum(sp, dims=1)

#     @test tf_sprase_reduce_max(sp, 2) ==
#           maximum(sp, dims=2)
# end

# # @testset "Tensordot tests" begin
# #     a = reshape(1:6, 2, 3)
# #     b = reshape(1:12, 3, 4)

# #     @test tf_tensordot(a, b, ((2,), (1,))) == a * b
# # end

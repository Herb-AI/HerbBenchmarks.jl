common_tensor_grammar = quote
    Tensor = tf_abs(Tensor)
    Tensor = tf_add(Tensor, Tensor)
    Tensor = tf_add_n(Tensor)
    Tensor = tf_argmax(Tensor, Axis)
    Tensor = tf_argmin(Tensor, Axis)
    Tensor = tf_argsort_ascending(Tensor, Axis)
    Tensor = tf_argsort_descending(Tensor, Axis)
    Tensor = tf_boolean_mask(Tensor, Tensor)
    Tensor = tf_broadcast_to(Tensor, Tensor)
    Tensor = tf_cast(Tensor, Type)
    Tensor = tf_clip_by_Scalar(Tensor, Scalar, Scalar)
    Tensor = tf_concat(Tensor, Axis)
    Tensor = tf_constant(Scalar)
    Tensor = tf_constant(Scalar, Type)
    Tensor = tf_divide(Tensor, Tensor)
    Tensor = tf_equal(Tensor, Tensor)
    Tensor = tf_exp(Tensor)
    Tensor = tf_expand_dims(Tensor, Axis)
    Tensor = tf_eye(Value)
    Tensor = tf_eye(Value, Integer)
    Tensor = tf_eye(Value, Type)
    Tensor = tf_fill(Dims, Scalar)
    Tensor = tf_gather(Tensor, Ranges)
    Tensor = tf_gather(Tensor, Ranges, Axis) 
    Tensor = tf_gather(Tensor, Ranges, Axis, Dimensions)
    Tensor = tf_gather_nd(Tensor, Tensor)
    # Tensor = tf_gather_nd(params, indices, batch_dims) # batch_dims not directly supported
    Tensor = tf_greater(Tensor, Tensor)
    Tensor = tf_greater_equal(Tensor, Tensor)
    Tensor = tf_math_bincount(Tensor)
    Tensor = tf_math_ceil(Tensor)
    Tensor = tf_math_count_nonzero(Tensor)
    Tensor = tf_math_count_nonzero(Tensor, Axis)
    Tensor = tf_math_cumsum(Tensor, Axis)
    # Tensor = tf_math_cumsum(x, Axis, exclusive=True)
    Tensor = tf_math_divide_no_nan(Tensor, Tensor)
    Tensor = tf_math_floor(Tensor)
    Tensor = tf_math_log(Tensor)
    Tensor = tf_math_negative(Tensor)
    Tensor = tf_math_reciprocal(Tensor)
    Tensor = tf_math_reciprocal_no_nan(Tensor)
    # Tensor = tf_math_segment_max(data, segment_ids)
    # Tensor = tf_math_segment_mean(data, segment_ids)
    # Tensor = tf_math_segment_min(data, segment_ids)
    # Tensor = tf_math_segment_prod(data, segment_ids)
    # Tensor = tf_math_segment_sum(data, segment_ids)
    Tensor = tf_math_squared_difference(Tensor, Tensor)
    Tensor = tf_math_top_k(Tensor, Integer)
    # Tensor = tf_math_unsorted_segment_max(data, segment_ids, num_segments)
    # Tensor = tf_math_unsorted_segment_mean(data, segment_ids, num_segments)
    # Tensor = tf_math_unsorted_segment_min(data, segment_ids, num_segments)
    # Tensor = tf_math_unsorted_segment_prod(data, segment_ids, num_segments)
    # Tensor = tf_math_unsorted_segment_sum(data, segment_ids, num_segments)
    Tensor = tf_matmul(Tensor, Tensor)
    Tensor = tf_maximum(Tensor, Tensor)
    Tensor = tf_minimum(Tensor, Tensor)
    Tensor = tf_multiply(Tensor, Tensor)
    Tensor = tf_not_equal(Tensor, Tensor)
    Tensor = tf_one_hot(Tensor, Integer)
    Tensor = tf_ones(Dimensions)
    Tensor = tf_ones_like(Tensor)
    # Tensor = tf_pad(tensor, paddings, mode='CONSTANT')
    # Tensor = tf_pad(tensor, paddings, mode='CONSTANT', constant_Scalars)
    # Tensor = tf_pad(tensor, paddings, mode='REFLECT')
    # Tensor = tf_pad(tensor, paddings, mode='SYMMETRIC')
    Tensor = tf_Ranges(Integer)
    Tensor = tf_Ranges(Integer, Integer, Integer)
    Tensor = tf_reduce_any(Tensor, Axis)
    Tensor = tf_reduce_max(Tensor)
    Tensor = tf_reduce_max(Tensor, Axis)
    Tensor = tf_reduce_mean(Tensor)
    Tensor = tf_reduce_mean(Tensor, Axis)
    Tensor = tf_reduce_min(Tensor)
    Tensor = tf_reduce_min(Tensor, Axis)
    Tensor = tf_reduce_prod(Tensor, Axis)
    Tensor = tf_reduce_sum(Tensor)
    Tensor = tf_reduce_sum(Tensor, Axis)
    Tensor = tf_reshape(Tensor, Dimensions)
    Tensor = tf_reverse(Tensor, Axis)
    Tensor = tf_roll(Tensor, Scalar, Axis)
    Tensor = tf_round(Tensor)
    Tensor = tf_searchsortedfirst(sorted_sequence, Scalars)
    Tensor = tf_searchsortedlast(sorted_sequence, Scalars)
    # Tensor = tf_sequence_mask(lengths)
    Tensor = tf_sequence_mask(Tensor, Integer)
    Tensor = tf_shape(Tensor) 
    Tensor = tf_sign(Tensor)
    Tensor = tf_sort_ascending(Tensor, Axis)
    Tensor = tf_sort_descending(Tensor, Axis)
    Tensor = tf_sqrt(Tensor)
    Tensor = tf_square(Tensor)
    Tensor = tf_squeeze(Tensor)
    Tensor = tf_squeeze(Tensor, Axis)
    Tensor = tf_stack(Tensor, Axis)
    Tensor = tf_subtract(Tensor, Tensor)
    Tensor = tf_tensordot(Tensor, Tensor, Axes)
    Tensor = tf_tile(Tensor, Dimensions)
    Tensor = tf_transpose(Tensor)
    Tensor = tf_transpose(Tensor, Tensor)
    Tensor = tf_unique_with_counts(Tensor)
    Tensor = tf_unstack(Tensor, Axis)
    Tensor = tf_where(Condition)
    Tensor = tf_where(Condition, Tensor, Tensor)
    Tensor = tf_zeros(Dimensions)
    Tensor = tf_zeros_like(Tensor)
    SparseTensor = tf_SparseTensor(Tensor, Tensor, Tensor)
    SparseTensor = tf_sparse_add(SparseTensor, SparseTensor)
    # SparseTensor = tf_sparse_concat(Axis, sp_inputs)
    SparseTensor = tf_sparse_expand_dims(SparseTensor, Axis)
    SparseTensor = tf_sparse_from_dense(Tensor)
    SparseTensor = tf_sparse_maximum(SparseTensor, SparseTensor)
    SparseTensor = tf_sparse_minimum(SparseTensor, SparseTensor)
    SparseTensor = tf_sparse_reduce_max(SparseTensor, Axis, Boolean)
    SparseTensor = tf_sparse_reduce_max(SparseTensor, Axis)
    SparseTensor = tf_sparse_reduce_sum(SparseTensor, Axis, Boolean)
    SparseTensor = tf_sparse_reduce_sum(SparseTensor, Axis)
    SparseTensor = tf_sparse_reset_shape(SparseTensor)
    SparseTensor = tf_sparse_reshape(SparseTensor, Tensor)

    Tensor = tf_slice(Tensor, Ranges)
    Tensor = tf_slice_scalar_1(Tensor, Ranges)
    Tensor = tf_create_singleton(Tensor)
    Tensor = tf_create_tuple(Tensor, Tensor)
    Tensor = tf_create_triplet(Tensor, Tensor, Tensor)

	# Dimensions: list of integers
	Dimension = tf_dimension(Int)
    Dimensions = Dimension | tf_dimensions(Dimension, Dimensions)

	# Axis: list of integers
    Axis = tf_axis(Int)
    Axes = Axis | tf_axes(Axis, Axes)

	# Ranges: list of indices/slices
    Index = tf_index(Int)
	#| start | finish | start + Int | finish - Int
    Range = tf_slice(Index, Index) | Index
    Ranges = Range | tf_ranges(Range, Ranges)


    Value = Int | Float | Bool | Tensor | SparseTensor
    Bool = tf_true | tf_false
	Int = 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10

	Type = tf_int | tf_float | tf_bool
end

macro grammar_tensor(body)
    # Ensure a block is passed
    body isa Expr && body.head == :block ||
        error("@grammar_tensor expects a begin ... end block")

    # Merge base rules + problem specific rules
    combined = Expr(
        :block,
        body.args...,                   # splice problem specific rules
        common_tensor_grammar.args...,  # splice base rules
    )

    # Call @cfgrammar on the combined block
    return esc(:(@cfgrammar $combined))
end

grammar_test_add = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Value = 0
end

grammar_test_cast = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_simple_add_big_tensors = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_broadcasted_add = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_cast = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_simple_index = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_output_equals_constant = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
	Value = 1
	Value = 10
	Value = 100
end

grammar_simple_output_equals_input_multiple = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
	Value = 999
end

grammar_simple_output_equals_input_single = @grammar_tensor begin
	Tensor = _arg_1
	Value = 999
end

grammar_simple_slice = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_sparse_add = @grammar_tensor begin
	SparseTensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_using_boolean_constant = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_simple_using_constant = @grammar_tensor begin
	Tensor = _arg_1
	Value = 100
end

grammar_simple_using_constant_kwarg = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_simple_using_output_shape = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_simple_using_output_shape_tuple = @grammar_tensor begin

end

grammar_simple_using_primitive_input = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_with_input_names = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_simple_with_many_inputs = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
	Tensor = _arg_4
end

grammar_google_01 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_02 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_03 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_04 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_05 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 6
end

grammar_google_06 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_07 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_08 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 5
end

grammar_google_09 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_10 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_11 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_12 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_13 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_14 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_15 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_16 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_17 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Value = -10
end

grammar_google_18 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_19 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_google_20 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_google_21 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
end

grammar_google_22 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_01 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_02 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 1
end

grammar_stackoverflow_03 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Value = 3
	Value = 4
	Value = 5
end

grammar_stackoverflow_04 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
end

grammar_stackoverflow_05 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_06 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_07 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_08 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Value = 1
end

grammar_stackoverflow_09 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_10 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_11 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_12 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 0
	Value = 1
	Value = 2
end

grammar_stackoverflow_13 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_14 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_15 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 0
	Value = 1
end

grammar_stackoverflow_16 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_17 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_18 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
end

grammar_stackoverflow_19 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_20 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_21 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_22 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_23 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_24 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Value = 0
end

grammar_stackoverflow_25 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_26 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_27 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_28 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_29 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_30 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_31 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_32 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_33 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_34 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_35 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
end

grammar_stackoverflow_36 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_37 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_38 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_39 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_40 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_41 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_42 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_43 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_44 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 2
end

grammar_stackoverflow_45 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_46 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_stackoverflow_47 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_48 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_49 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_stackoverflow_50 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
	Tensor = _arg_3
end

grammar_autopandas_01 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_autopandas_02 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_03 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 3
	Value = 5
end

grammar_autopandas_04 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_05 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_06 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 2
end

grammar_autopandas_07 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_08 = @grammar_tensor begin
	Tensor = _arg_1
	Value = 1
end

grammar_autopandas_09 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_10 = @grammar_tensor begin
	Tensor = _arg_1
	Value = NaN
end

grammar_autopandas_11 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_12 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_13 = @grammar_tensor begin
	Tensor = _arg_1
	Tensor = _arg_2
end

grammar_autopandas_14 = @grammar_tensor begin
	Tensor = _arg_1
	Value = NaN
end

grammar_autopandas_15 = @grammar_tensor begin
	Tensor = _arg_1
end

grammar_autopandas_16 = @grammar_tensor begin
	Tensor = _arg_1
end
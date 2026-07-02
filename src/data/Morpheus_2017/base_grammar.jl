base_grammar_morpheus = @csgrammar begin
    Start = Table

    Table = gather(Table, NewCol, NewCol, ColSet) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1) + 2,
        morpheus_new_column_count(y) <= morpheus_new_column_count(x1) + 2,
        morpheus_row_count(y) >= morpheus_row_count(x1),
        morpheus_column_count(y) <= morpheus_column_count(x1),
    )
    Table = spread(Table, Col, Col) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1),
        morpheus_new_column_count(y) <= morpheus_new_value_count(x1),
        morpheus_row_count(y) <= morpheus_row_count(x1),
        morpheus_column_count(y) >= morpheus_column_count(x1),
    )
    Table = unite(Table, NewCol, Col, Col) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) >= morpheus_new_value_count(x1) + 1,
        morpheus_new_column_count(y) <= morpheus_new_column_count(x1) + 1,
        morpheus_row_count(y) == morpheus_row_count(x1),
        morpheus_column_count(y) == morpheus_column_count(x1) - 1,
    )
    Table = separate(Table, Col, NewCol, NewCol) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) >= morpheus_new_value_count(x1) + 2,
        morpheus_new_column_count(y) <= morpheus_new_column_count(x1) + 2,
        morpheus_row_count(y) == morpheus_row_count(x1),
        morpheus_column_count(y) == morpheus_column_count(x1) + 1,
    )
    Table = select(Table, ColSet) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1),
        morpheus_new_column_count(y) <= morpheus_new_column_count(x1),
        morpheus_row_count(y) == morpheus_row_count(x1),
        morpheus_column_count(y) < morpheus_column_count(x1),
    )
    Table = group_by(Table, ColSet) := (
        morpheus_group_count(y) >= morpheus_group_count(x1),
        morpheus_new_value_count(y) == morpheus_new_value_count(x1),
        morpheus_new_column_count(y) == morpheus_new_column_count(x1),
        morpheus_row_count(y) == morpheus_row_count(x1),
        morpheus_column_count(y) == morpheus_column_count(x1),
    )
    Table = arrange(Table, ColSet) := (length(y) == length(x1))

    Table = filter(Table, Pred) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1),
        morpheus_new_column_count(y) == morpheus_new_column_count(x1),
        morpheus_row_count(y) < morpheus_row_count(x1),
        morpheus_column_count(y) == morpheus_column_count(x1),
    )
    Table = summarise(Table, NewCol, Agg) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_group_count(y) == morpheus_row_count(y),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1) + morpheus_group_count(x1) + 1,
        morpheus_new_column_count(y) > 0,
        morpheus_new_column_count(y) <= morpheus_new_column_count(x1) + 1,
        morpheus_row_count(y) <= morpheus_row_count(x1),
        morpheus_column_count(y) <= morpheus_column_count(x1) + 1,
    )
    Table = mutate(Table, NewCol, ValExpr) := (
        morpheus_group_count(y) == morpheus_group_count(x1),
        morpheus_new_column_count(y) == morpheus_new_column_count(x1) + 1,
        morpheus_new_value_count(x1) < morpheus_new_value_count(y),
        morpheus_new_value_count(y) <= morpheus_new_value_count(x1) + morpheus_row_count(x1),
        morpheus_row_count(y) == morpheus_row_count(x1),
        morpheus_column_count(y) == morpheus_column_count(x1) + 1,
    )

    ColSet = cols(Col)
    ColSet = cols2(Col, Col)
    # ColSet = cols3(Col, Col, Col)
    ColSet = not_cols(Col)
    ColSet = not_cols2(Col, Col)
    # ColSet = not_cols3(Col, Col, Col)
    ColSet = union_cols(ColSet, ColSet)

    Agg = mean_agg(Col)
    Agg = sum_agg(Col)
    Agg = count_agg()

    Pred = positive(Col)
    Pred = negative(Col)
    Pred = eq_value(Col, Value)
    Pred = neq_value(Col, Value)
    Pred = lt_value(Col, Value)
    Pred = gt_value(Col, Value)

    ValExpr = copy_expr(Col)
    ValExpr = div_expr(Col, Col) := (x1 != x2)
    ValExpr = div_sum_expr(Col)
    ValExpr = add_expr(Col, Col) := (x1 != x2)
    ValExpr = sub_expr(Col, Col) := (x1 != x2)
    ValExpr = mul_expr(Col, Col) := (x1 != x2)

    Value = lit(0)
    Value = lit(1)
end

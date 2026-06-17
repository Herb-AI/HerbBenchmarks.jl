base_grammar_morpheus = @csgrammar begin
    Start = Table

    Table = gather(Table, NewCol, NewCol, ColSet) := (length(y) >= length(x1))
    Table = spread(Table, Col, Col)               := (length(y) <= length(x1))
    Table = unite(Table, NewCol, Col, Col)        := (length(y) == length(x1))
    Table = separate(Table, Col, NewCol, NewCol)  := (length(y) == length(x1))
    Table = select(Table, ColSet)                 := (length(y) == length(x1))
    Table = group_by(Table, ColSet)               := (length(y) == length(x1))
    Table = arrange(Table, ColSet)                := (length(y) == length(x1))

    Table = filter(Table, Pred)                   := (length(y) <= length(x1))
    Table = summarise(Table, NewCol, Agg)         := (length(y) <= length(x1))
    Table = mutate(Table, NewCol, ValExpr)        := (length(y) == length(x1))
    Table = inner_join(Table, Table)

    ColSet = cols(Col)
    ColSet = cols2(Col, Col)
    ColSet = cols3(Col, Col, Col)
    ColSet = not_cols(Col)
    ColSet = not_cols2(Col, Col)
    ColSet = not_cols3(Col, Col, Col)
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
    ValExpr = div_expr(Col, Col)
    ValExpr = div_sum_expr(Col)
    ValExpr = add_expr(Col, Col)
    ValExpr = sub_expr(Col, Col)
    ValExpr = mul_expr(Col, Col)
end

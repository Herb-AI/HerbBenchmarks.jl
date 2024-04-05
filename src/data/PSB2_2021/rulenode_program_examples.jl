include("grammars.jl")

program_basement_rulenodes = begin # depth 11
    rulenode2expr(
        RuleNode(1, [
            RuleNode(18, [
                RuleNode(12, [
                    RuleNode(11),
                    RuleNode(4)
                ]),
                RuleNode(17, [
                    RuleNode(16, [
                        RuleNode(19, [
                            RuleNode(7, [
                                RuleNode(6, [
                                    RuleNode(13, [
                                        RuleNode(11)
                                    ])
                                    RuleNode(8, [
                                        RuleNode(2)
                                    ])
                                ]),
                                RuleNode(6, [
                                    RuleNode(9, [
                                        RuleNode(10, [
                                            RuleNode(2),
                                            RuleNode(4),
                                            RuleNode(5, [
                                                RuleNode(13, [
                                                    RuleNode(11)
                                                ]),
                                                RuleNode(4)
                                            ])
                                        ])
                                    ]),
                                    RuleNode(3)
                                ])
                            ]),
                            RuleNode(14, [
                                RuleNode(11),
                                RuleNode(5, [
                                    RuleNode(13, [
                                        RuleNode(11)
                                    ]),
                                    RuleNode(4)
                                ])
                            ])
                        ])
                    ]),
                    RuleNode(15, [
                        RuleNode(13, [
                            RuleNode(11)
                        ])
                    ])
                ])
            ])
        ]), minimal_grammar_basement
    )
end

program_coinsums_rulenodes = begin # depth 6
    rulenode2expr(
        RuleNode(7, [
            RuleNode(8, [
                RuleNode(10, [
                    RuleNode(10, [
                        RuleNode(10, [
                            RuleNode(6),
                            RuleNode(5),
                        ])
                        RuleNode(4)
                    ]),
                    RuleNode(3)
                    ])
            ]),
            RuleNode(8, [
                RuleNode(9, [
                    RuleNode(10, [
                        RuleNode(10, [
                            RuleNode(6),
                            RuleNode(5),
                        ])
                        RuleNode(4)
                    ]),
                    RuleNode(3)
                ])
            ]),            
            RuleNode(8, [
                RuleNode(9, [
                    RuleNode(10, [
                        RuleNode(6),
                        RuleNode(5)
                    ]),
                    RuleNode(4)
                ])
            ]),
            RuleNode(8, [
                RuleNode(9, [
                    RuleNode(6),
                    RuleNode(5)
                ])
            ])
        ]), minimal_grammar_coin_sums
    )
end

program_fizzbuzz_rulenodes = begin # depth 7, using minimal_grammar_fizz_buzz
    rulenode2expr(
        RuleNode(9, [
            RuleNode(12, [
                RuleNode(13, [
                    RuleNode(11, [
                        RuleNode(10, [
                            RuleNode(1),
                            RuleNode(4)
                        ]),
                        RuleNode(2)
                    ]),
                    RuleNode(11, [
                        RuleNode(10, [
                            RuleNode(1),
                            RuleNode(3)
                        ]),
                        RuleNode(2)
                    ])
                ]),
                RuleNode(7),
                RuleNode(12, [
                    RuleNode(11, [
                        RuleNode(10, [
                            RuleNode(1),
                            RuleNode(3),
                        ]),
                        RuleNode(2)
                    ]),
                    RuleNode(5),
                    RuleNode(12, [
                        RuleNode(11, [
                            RuleNode(10, [
                                RuleNode(1),
                                RuleNode(4)
                            ]),
                            RuleNode(2)
                        ]),
                        RuleNode(6),
                        RuleNode(8, [
                            RuleNode(1)
                        ])
                    ])
               ])
           ])
        ]), minimal_grammar_fizz_buzz)
end


# :(Dict(:output1 => (sum(map(floor(x / 3) - 2, input1)))))
program_fuel_cost_rulenodes = begin # depth 6
    rulenode2expr(
        RuleNode(13, [
            RuleNode(9, [
                RuleNode(10, [
                    RuleNode(11, [
                        RuleNode(8, [
                            RuleNode(7, [
                                RuleNode(6, [
                                    RuleNode(12)
                                    RuleNode(5)
                                ])
                            ]),
                            RuleNode(4)
                        ])
                    ]),
                    RuleNode(1)
                ])
            ])
        ]), minimal_grammar_fuel_cost
    )
end

program_gcd_rulenodes = begin
    rulenode2expr(
        RuleNode(3, [
            RuleNode(15, [
                RuleNode(9, [
                    RuleNode(7),
                    RuleNode(1),
                    RuleNode(8),
                    RuleNode(2)
                ]),
                RuleNode(14, [
                    RuleNode(13, [
                        RuleNode(16, [
                            RuleNode(6, [
                                RuleNode(10, [
                                    RuleNode(8)
                                ]),
                                RuleNode(4)
                            ]),
                            RuleNode(11, [
                                RuleNode(9, [
                                    RuleNode(7),
                                    RuleNode(10, [
                                        RuleNode(8)
                                    ]),
                                    RuleNode(8),
                                    RuleNode(5, [
                                        RuleNode(10, [
                                            RuleNode(7)
                                        ]),
                                        RuleNode(10, [
                                            RuleNode(8)
                                        ])
                                    ])
                                ])
                            ])
                        ])
                    ]),
                    RuleNode(12, [
                        RuleNode(10, [
                            RuleNode(7)
                        ])
                    ])
                ])
            ])
        ]), minimal_grammar_gcd
    )
end
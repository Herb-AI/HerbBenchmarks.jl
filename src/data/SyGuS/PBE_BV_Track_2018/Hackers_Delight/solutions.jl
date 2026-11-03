"""
Reference implementations of the Hacker's Delight benchmarks.

Each `solution_hd_NN` is the `define-fun hdNN` of `hd-NN.sl` -- the ground truth
the SyGuS `constraint` refers to -- transliterated into the primitives of
`hd_primitives.jl`. These are the functions the IO examples in `data.jl` were
sampled from, and they are what a synthesiser is expected to (re)discover.

Note that some of them do *not* implement the natural-language comment at the top
of their `.sl` file; see the README for the list.
"""

# hd-01: Hacker's delight 01, difficulty 5 Turn off the rightmost 1-bit in a bit-vector.
solution_hd_01(_arg_1::UInt64)::UInt64 = bvand(_arg_1, bvsub(_arg_1, 0x0000000000000001))

# hd-02: Hacker's delight 02, difficulty 5 Test if unsigned int is of form 2^n - 1
solution_hd_02(_arg_1::UInt64)::UInt64 = bvand(_arg_1, bvadd(_arg_1, 0x0000000000000001))

# hd-03: Hacker's delight 03, difficulty 5 Isolate the right most one bit
solution_hd_03(_arg_1::UInt64)::UInt64 = bvand(_arg_1, bvneg(_arg_1))

# hd-04: Form a bit mask that identifies the rightmost one bit and trailing zeros
solution_hd_04(_arg_1::UInt64)::UInt64 = bvxor(_arg_1, bvsub(_arg_1, 0x0000000000000001))

# hd-05: Hacker's delight 05, difficulty 5 Right propagate the rightmost one bit
solution_hd_05(_arg_1::UInt64)::UInt64 = bvor(_arg_1, bvsub(_arg_1, 0x0000000000000001))

# hd-06: Hacker's delight 06, difficulty 5 Turn on the right most 0 bit
solution_hd_06(_arg_1::UInt64)::UInt64 = bvor(_arg_1, bvadd(_arg_1, 0x0000000000000001))

# hd-07: Hacker's delight 07, difficulty 5 Isolate the rightmost 0 bit
solution_hd_07(_arg_1::UInt64)::UInt64 = bvand(bvnot(_arg_1), bvadd(_arg_1, 0x0000000000000001))

# hd-08: Hacker's delight 08, difficulty 5 Form a mask that identifies the trailing zeros
solution_hd_08(_arg_1::UInt64)::UInt64 = bvand(bvnot(_arg_1), bvsub(_arg_1, 0x0000000000000001))

# hd-09: Hacker's delight 09, difficulty 5 Absolute value function
solution_hd_09(_arg_1::UInt64)::UInt64 = bvsub(bvxor(_arg_1, bvashr(_arg_1, 0x000000000000001f)), bvashr(_arg_1, 0x000000000000001f))

# hd-10: Hacker's delight 10, difficulty 5 Test if (nlz x) == (nlz y) where nlz is the number of leading zeros
solution_hd_10(_arg_1::UInt64, _arg_2::UInt64)::Bool = bvule(bvxor(_arg_1, _arg_2), bvand(_arg_1, _arg_2))

# hd-11: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
solution_hd_11(_arg_1::UInt64, _arg_2::UInt64)::Bool = bvugt(bvand(_arg_1, bvnot(_arg_2)), _arg_2)

# hd-12: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
solution_hd_12(_arg_1::UInt64, _arg_2::UInt64)::Bool = bvule(bvand(_arg_2, bvnot(_arg_1)), _arg_1)

# hd-13: Hacker's delight 13, difficulty 5 sign function
solution_hd_13(_arg_1::UInt64)::UInt64 = bvor(bvashr(_arg_1, 0x000000000000001f), bvlshr(bvneg(_arg_1), 0x000000000000001f))

# hd-14: floor of average of two integers
solution_hd_14(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = bvadd(bvand(_arg_1, _arg_2), bvlshr(bvxor(_arg_1, _arg_2), 0x0000000000000001))

# hd-15: floor of average of two integers
solution_hd_15(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = bvsub(bvor(_arg_1, _arg_2), bvlshr(bvxor(_arg_1, _arg_2), 0x0000000000000001))

# hd-16: (no description in the original file)
solution_hd_16(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = ite(bvslt(_arg_1, _arg_2), _arg_2, _arg_1)

# hd-17: Hacker's delight 17, difficulty 5 turn off the rightmost string of contiguous ones
solution_hd_17(_arg_1::UInt64)::UInt64 = bvand(bvadd(bvor(_arg_1, bvsub(_arg_1, 0x0000000000000001)), 0x0000000000000001), _arg_1)

# hd-18: determine if power of two
solution_hd_18(_arg_1::UInt64)::Bool = booland(boolnot(bvredor(bvand(bvsub(_arg_1, 0x0000000000000001), _arg_1))), bvredor(_arg_1))

# hd-19: Exchanging 2 fields A and B of the same register x where m is mask which identifies field B and k is number of bits from end of A to start of B.
solution_hd_19(_arg_1::UInt64, _arg_2::UInt64, _arg_3::UInt64)::UInt64 = bvxor(
    _arg_1,
    bvxor(
        bvshl(bvand(bvxor(bvlshr(_arg_1, _arg_3), _arg_1), _arg_2), _arg_3),
        bvand(bvxor(bvlshr(_arg_1, _arg_3), _arg_1), _arg_2)
    )
)

# hd-20: Next higher unsigned number with the same number of 1 bits.
solution_hd_20(_arg_1::UInt64)::UInt64 = bvor(
    bvadd(_arg_1, bvand(bvneg(_arg_1), _arg_1)),
    bvudiv(
        bvlshr(bvxor(_arg_1, bvand(bvneg(_arg_1), _arg_1)), 0x0000000000000002),
        bvand(bvneg(_arg_1), _arg_1)
    )
)

# hd-21: Cycling through 3 values a, b, c.
solution_hd_21(_arg_1::UInt64, _arg_2::UInt64, _arg_3::UInt64, _arg_4::UInt64)::UInt64 = ite(bveq(_arg_1, _arg_2), _arg_3, ite(bveq(_arg_1, _arg_3), _arg_4, _arg_2))

# hd-22: Compute parity.
solution_hd_22(_arg_1::UInt64)::UInt64 = bvand(
    bvlshr(
        bvmul(
            bvand(
                bvxor(
                    bvxor(bvlshr(_arg_1, 0x0000000000000001), _arg_1),
                    bvlshr(bvxor(bvlshr(_arg_1, 0x0000000000000001), _arg_1), 0x0000000000000002)
                ),
                0x1111111111111111
            ),
            0x1111111111111111
        ),
        0x000000000000001c
    ),
    0x0000000000000001
)

# hd-23: Counting number of set bits.
solution_hd_23(_arg_1::UInt64)::UInt64 = bvand(
    bvadd(
        bvadd(
            bvand(
                bvadd(
                    bvlshr(
                        bvadd(
                            bvand(
                                bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                0x0000000033333333
                            ),
                            bvand(
                                bvlshr(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000000000002
                                ),
                                0x0000000033333333
                            )
                        ),
                        0x0000000000000004
                    ),
                    bvadd(
                        bvand(
                            bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                            0x0000000033333333
                        ),
                        bvand(
                            bvlshr(
                                bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                0x0000000000000002
                            ),
                            0x0000000033333333
                        )
                    )
                ),
                0x0000000f0f0f0f0f
            ),
            bvlshr(
                bvand(
                    bvadd(
                        bvlshr(
                            bvadd(
                                bvand(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000033333333
                                ),
                                bvand(
                                    bvlshr(
                                        bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                        0x0000000000000002
                                    ),
                                    0x0000000033333333
                                )
                            ),
                            0x0000000000000004
                        ),
                        bvadd(
                            bvand(
                                bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                0x0000000033333333
                            ),
                            bvand(
                                bvlshr(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000000000002
                                ),
                                0x0000000033333333
                            )
                        )
                    ),
                    0x0000000f0f0f0f0f
                ),
                0x0000000000000008
            )
        ),
        bvlshr(
            bvadd(
                bvand(
                    bvadd(
                        bvlshr(
                            bvadd(
                                bvand(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000033333333
                                ),
                                bvand(
                                    bvlshr(
                                        bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                        0x0000000000000002
                                    ),
                                    0x0000000033333333
                                )
                            ),
                            0x0000000000000004
                        ),
                        bvadd(
                            bvand(
                                bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                0x0000000033333333
                            ),
                            bvand(
                                bvlshr(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000000000002
                                ),
                                0x0000000033333333
                            )
                        )
                    ),
                    0x0000000f0f0f0f0f
                ),
                bvlshr(
                    bvand(
                        bvadd(
                            bvlshr(
                                bvadd(
                                    bvand(
                                        bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                        0x0000000033333333
                                    ),
                                    bvand(
                                        bvlshr(
                                            bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                            0x0000000000000002
                                        ),
                                        0x0000000033333333
                                    )
                                ),
                                0x0000000000000004
                            ),
                            bvadd(
                                bvand(
                                    bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                    0x0000000033333333
                                ),
                                bvand(
                                    bvlshr(
                                        bvsub(_arg_1, bvand(bvlshr(_arg_1, 0x0000000000000001), 0x0000000055555555)),
                                        0x0000000000000002
                                    ),
                                    0x0000000033333333
                                )
                            )
                        ),
                        0x0000000f0f0f0f0f
                    ),
                    0x0000000000000008
                )
            ),
            0x0000000000000010
        )
    ),
    0x000000000000003f
)

# hd-24: Round up to the next higher power of 2.
solution_hd_24(_arg_1::UInt64)::UInt64 = bvadd(
    bvor(
        bvor(
            bvor(
                bvor(
                    bvor(
                        bvsub(_arg_1, 0x0000000000000001),
                        bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                    ),
                    bvlshr(
                        bvor(
                            bvsub(_arg_1, 0x0000000000000001),
                            bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                        ),
                        0x0000000000000002
                    )
                ),
                bvlshr(
                    bvor(
                        bvor(
                            bvsub(_arg_1, 0x0000000000000001),
                            bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                        ),
                        bvlshr(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            0x0000000000000002
                        )
                    ),
                    0x0000000000000004
                )
            ),
            bvlshr(
                bvor(
                    bvor(
                        bvor(
                            bvsub(_arg_1, 0x0000000000000001),
                            bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                        ),
                        bvlshr(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            0x0000000000000002
                        )
                    ),
                    bvlshr(
                        bvor(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            bvlshr(
                                bvor(
                                    bvsub(_arg_1, 0x0000000000000001),
                                    bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                                ),
                                0x0000000000000002
                            )
                        ),
                        0x0000000000000004
                    )
                ),
                0x0000000000000008
            )
        ),
        bvlshr(
            bvor(
                bvor(
                    bvor(
                        bvor(
                            bvsub(_arg_1, 0x0000000000000001),
                            bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                        ),
                        bvlshr(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            0x0000000000000002
                        )
                    ),
                    bvlshr(
                        bvor(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            bvlshr(
                                bvor(
                                    bvsub(_arg_1, 0x0000000000000001),
                                    bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                                ),
                                0x0000000000000002
                            )
                        ),
                        0x0000000000000004
                    )
                ),
                bvlshr(
                    bvor(
                        bvor(
                            bvor(
                                bvsub(_arg_1, 0x0000000000000001),
                                bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                            ),
                            bvlshr(
                                bvor(
                                    bvsub(_arg_1, 0x0000000000000001),
                                    bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                                ),
                                0x0000000000000002
                            )
                        ),
                        bvlshr(
                            bvor(
                                bvor(
                                    bvsub(_arg_1, 0x0000000000000001),
                                    bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                                ),
                                bvlshr(
                                    bvor(
                                        bvsub(_arg_1, 0x0000000000000001),
                                        bvlshr(bvsub(_arg_1, 0x0000000000000001), 0x0000000000000001)
                                    ),
                                    0x0000000000000002
                                )
                            ),
                            0x0000000000000004
                        )
                    ),
                    0x0000000000000008
                )
            ),
            0x0000000000000010
        )
    ),
    0x0000000000000001
)

# hd-25: Compute higher order half of product of x and y.
solution_hd_25(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = bvadd(
    bvadd(
        bvlshr(
            bvadd(
                bvmul(bvand(_arg_1, 0xffffffffffffffff), bvlshr(_arg_2, 0x0000000000000010)),
                bvand(
                    bvadd(
                        bvmul(bvlshr(_arg_1, 0x0000000000000010), bvand(_arg_2, 0xffffffffffffffff)),
                        bvlshr(
                            bvmul(bvand(_arg_1, 0xffffffffffffffff), bvand(_arg_2, 0xffffffffffffffff)),
                            0x0000000000000010
                        )
                    ),
                    0xffffffffffffffff
                )
            ),
            0x0000000000000010
        ),
        bvlshr(
            bvadd(
                bvmul(bvlshr(_arg_1, 0x0000000000000010), bvand(_arg_2, 0xffffffffffffffff)),
                bvlshr(
                    bvmul(bvand(_arg_1, 0xffffffffffffffff), bvand(_arg_2, 0xffffffffffffffff)),
                    0x0000000000000010
                )
            ),
            0x0000000000000010
        )
    ),
    bvmul(bvlshr(_arg_1, 0x0000000000000010), bvlshr(_arg_2, 0x0000000000000010))
)

# hd-26: Round up x to a multiple of k-th power of 2
solution_hd_26(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = bvand(
    bvsub(bvsub(_arg_1, bvshl(0xffffffffffffffff, _arg_2)), 0xffffffffffffffff),
    bvshl(0xffffffffffffffff, _arg_2)
)

# hd-27: (no description in the original file)
solution_hd_27(_arg_1::UInt64, _arg_2::UInt64)::UInt64 = ite(bvslt(_arg_1, _arg_2), _arg_1, _arg_2)

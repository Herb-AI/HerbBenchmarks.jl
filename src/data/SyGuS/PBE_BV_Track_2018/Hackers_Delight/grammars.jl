"""
Grammars for the SyGuS Hacker's Delight benchmarks.

Each `grammar_hd_NN` is the `synth-fun` grammar of `hd-NN.sl`, rule for rule and
in the original order. `Start` is always the start symbol and carries the return
type of the synthesised function; the second nonterminal (`StartBool` for the
bit-vector problems, `StartBV` for the predicate problems) is the other sort.
Arguments are named `_arg_1`, `_arg_2`, ... following the HerbBenchmarks
convention; the mapping to the original SyGuS names is given per grammar.
"""

# hd-01: Hacker's delight 01, difficulty 5 Turn off the rightmost 1-bit in a bit-vector.
# arguments: _arg_1 = x
grammar_hd_01 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = 0x0000000000000001
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-02: Hacker's delight 02, difficulty 5 Test if unsigned int is of form 2^n - 1
# arguments: _arg_1 = x
grammar_hd_02 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = 0x0000000000000001
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-03: Hacker's delight 03, difficulty 5 Isolate the right most one bit
# arguments: _arg_1 = x
grammar_hd_03 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvand(Start, Start)
    Start = bvxor(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000001
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-04: Form a bit mask that identifies the rightmost one bit and trailing zeros
# arguments: _arg_1 = x
grammar_hd_04 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-05: Hacker's delight 05, difficulty 5 Right propagate the rightmost one bit
# arguments: _arg_1 = x
grammar_hd_05 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000001
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-06: Hacker's delight 06, difficulty 5 Turn on the right most 0 bit
# arguments: _arg_1 = x
grammar_hd_06 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = 0x0000000000000001
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-07: Hacker's delight 07, difficulty 5 Isolate the rightmost 0 bit
# arguments: _arg_1 = x
grammar_hd_07 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvand(Start, Start)
    Start = bvxor(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-08: Hacker's delight 08, difficulty 5 Form a mask that identifies the trailing zeros
# arguments: _arg_1 = x
grammar_hd_08 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvxor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-09: Hacker's delight 09, difficulty 5 Absolute value function
# arguments: _arg_1 = x
grammar_hd_09 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvand(Start, Start)
    Start = bvxor(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000001
    Start = 0x0000000000000000
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-10: Hacker's delight 10, difficulty 5 Test if (nlz x) == (nlz y) where nlz is the number of leading zeros
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_10 = @cfgrammar begin
    Start = bvule(StartBV, StartBV)
    Start = bvult(StartBV, StartBV)
    Start = bvslt(StartBV, StartBV)
    Start = bvsle(StartBV, StartBV)
    Start = true
    Start = false
    Start = bveq(StartBV, StartBV)
    StartBV = bvnot(StartBV)
    StartBV = bvxor(StartBV, StartBV)
    StartBV = bvand(StartBV, StartBV)
    StartBV = bvor(StartBV, StartBV)
    StartBV = bvneg(StartBV)
    StartBV = bvadd(StartBV, StartBV)
    StartBV = bvmul(StartBV, StartBV)
    StartBV = bvudiv(StartBV, StartBV)
    StartBV = bvurem(StartBV, StartBV)
    StartBV = bvlshr(StartBV, StartBV)
    StartBV = bvashr(StartBV, StartBV)
    StartBV = bvshl(StartBV, StartBV)
    StartBV = bvsdiv(StartBV, StartBV)
    StartBV = bvsrem(StartBV, StartBV)
    StartBV = bvsub(StartBV, StartBV)
    StartBV = _arg_1
    StartBV = _arg_2
    StartBV = ite(Start, StartBV, StartBV)
end

# hd-11: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_11 = @cfgrammar begin
    Start = bvule(StartBV, StartBV)
    Start = bvult(StartBV, StartBV)
    Start = bvslt(StartBV, StartBV)
    Start = bvsle(StartBV, StartBV)
    Start = bvugt(StartBV, StartBV)
    Start = true
    Start = false
    Start = bveq(StartBV, StartBV)
    StartBV = bvnot(StartBV)
    StartBV = bvxor(StartBV, StartBV)
    StartBV = bvand(StartBV, StartBV)
    StartBV = bvor(StartBV, StartBV)
    StartBV = bvneg(StartBV)
    StartBV = bvadd(StartBV, StartBV)
    StartBV = bvmul(StartBV, StartBV)
    StartBV = bvudiv(StartBV, StartBV)
    StartBV = bvurem(StartBV, StartBV)
    StartBV = bvlshr(StartBV, StartBV)
    StartBV = bvashr(StartBV, StartBV)
    StartBV = bvshl(StartBV, StartBV)
    StartBV = bvsdiv(StartBV, StartBV)
    StartBV = bvsrem(StartBV, StartBV)
    StartBV = bvsub(StartBV, StartBV)
    StartBV = 0x0000000000000000
    StartBV = 0x0000000000000001
    StartBV = 0xffffffffffffffff
    StartBV = _arg_1
    StartBV = _arg_2
    StartBV = ite(Start, StartBV, StartBV)
end

# hd-12: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_12 = @cfgrammar begin
    Start = bvule(StartBV, StartBV)
    Start = bvult(StartBV, StartBV)
    Start = bvslt(StartBV, StartBV)
    Start = bvsle(StartBV, StartBV)
    Start = bvugt(StartBV, StartBV)
    Start = true
    Start = false
    Start = bveq(StartBV, StartBV)
    StartBV = bvnot(StartBV)
    StartBV = bvxor(StartBV, StartBV)
    StartBV = bvand(StartBV, StartBV)
    StartBV = bvor(StartBV, StartBV)
    StartBV = bvneg(StartBV)
    StartBV = bvadd(StartBV, StartBV)
    StartBV = bvmul(StartBV, StartBV)
    StartBV = bvudiv(StartBV, StartBV)
    StartBV = bvurem(StartBV, StartBV)
    StartBV = bvlshr(StartBV, StartBV)
    StartBV = bvashr(StartBV, StartBV)
    StartBV = bvshl(StartBV, StartBV)
    StartBV = bvsdiv(StartBV, StartBV)
    StartBV = bvsrem(StartBV, StartBV)
    StartBV = bvsub(StartBV, StartBV)
    StartBV = _arg_1
    StartBV = _arg_2
    StartBV = ite(Start, StartBV, StartBV)
end

# hd-13: Hacker's delight 13, difficulty 5 sign function
# arguments: _arg_1 = x
grammar_hd_13 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x000000000000001f
    Start = 0x0000000000000001
    Start = 0x0000000000000000
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-14: floor of average of two integers
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_14 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = _arg_2
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-15: floor of average of two integers
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_15 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = _arg_2
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-16: (no description in the original file)
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_16 = @cfgrammar begin
    Start = _arg_1
    Start = _arg_2
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
    StartBool = bvslt(Start, Start)
    StartBool = bvule(Start, Start)
    StartBool = bvult(Start, Start)
    StartBool = bvsle(Start, Start)
    StartBool = bvugt(Start, Start)
end

# hd-17: Hacker's delight 17, difficulty 5 turn off the rightmost string of contiguous ones
# arguments: _arg_1 = x
grammar_hd_17 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-18: determine if power of two
# arguments: _arg_1 = x
grammar_hd_18 = @cfgrammar begin
    Start = bvule(StartBV, StartBV)
    Start = bvult(StartBV, StartBV)
    Start = bvslt(StartBV, StartBV)
    Start = bvsle(StartBV, StartBV)
    Start = bvugt(StartBV, StartBV)
    Start = bvredor(StartBV)
    Start = boolnot(Start)
    Start = booland(Start, Start)
    Start = true
    Start = false
    Start = bveq(StartBV, StartBV)
    StartBV = bvnot(StartBV)
    StartBV = bvxor(StartBV, StartBV)
    StartBV = bvand(StartBV, StartBV)
    StartBV = bvor(StartBV, StartBV)
    StartBV = bvneg(StartBV)
    StartBV = bvadd(StartBV, StartBV)
    StartBV = bvmul(StartBV, StartBV)
    StartBV = bvudiv(StartBV, StartBV)
    StartBV = bvurem(StartBV, StartBV)
    StartBV = bvlshr(StartBV, StartBV)
    StartBV = bvashr(StartBV, StartBV)
    StartBV = bvshl(StartBV, StartBV)
    StartBV = bvsdiv(StartBV, StartBV)
    StartBV = bvsrem(StartBV, StartBV)
    StartBV = bvsub(StartBV, StartBV)
    StartBV = _arg_1
    StartBV = 0x0000000000000001
    StartBV = ite(Start, StartBV, StartBV)
end

# hd-19: Exchanging 2 fields A and B of the same register x where m is mask which identifies field B and k is number of bits from end of A to start of B.
# arguments: _arg_1 = x, _arg_2 = m, _arg_3 = k
grammar_hd_19 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = _arg_2
    Start = _arg_3
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-20: Next higher unsigned number with the same number of 1 bits.
# arguments: _arg_1 = x
grammar_hd_20 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x0000000000000002
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-21: Cycling through 3 values a, b, c.
# arguments: _arg_1 = x, _arg_2 = a, _arg_3 = b, _arg_4 = c
grammar_hd_21 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = _arg_2
    Start = _arg_3
    Start = _arg_4
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-22: Compute parity.
# arguments: _arg_1 = x
grammar_hd_22 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x0000000000000002
    Start = 0x000000000000001c
    Start = 0x1111111111111111
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-23: Counting number of set bits.
# arguments: _arg_1 = x
grammar_hd_23 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000001
    Start = 0x0000000000000002
    Start = 0x0000000000000004
    Start = 0x0000000000000008
    Start = 0x000000000000003f
    Start = 0x0000000055555555
    Start = 0x0000000f0f0f0f0f
    Start = 0x0000000033333333
    Start = 0x0000000000000010
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-24: Round up to the next higher power of 2.
# arguments: _arg_1 = x
grammar_hd_24 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x0000000000000002
    Start = 0x0000000000000004
    Start = 0x0000000000000008
    Start = 0x0000000000000010
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-25: Compute higher order half of product of x and y.
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_25 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = _arg_1
    Start = _arg_2
    Start = 0x0000000000000001
    Start = 0x0000000000000010
    Start = 0xffffffffffffffff
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-26: Round up x to a multiple of k-th power of 2
# arguments: _arg_1 = x, _arg_2 = k
grammar_hd_26 = @cfgrammar begin
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = 0x0000000000000000
    Start = 0x0000000000000001
    Start = 0x000000000000001f
    Start = 0xffffffffffffffff
    Start = _arg_1
    Start = _arg_2
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
end

# hd-27: (no description in the original file)
# arguments: _arg_1 = x, _arg_2 = y
grammar_hd_27 = @cfgrammar begin
    Start = _arg_1
    Start = _arg_2
    Start = bvnot(Start)
    Start = bvxor(Start, Start)
    Start = bvand(Start, Start)
    Start = bvor(Start, Start)
    Start = bvneg(Start)
    Start = bvadd(Start, Start)
    Start = bvmul(Start, Start)
    Start = bvudiv(Start, Start)
    Start = bvurem(Start, Start)
    Start = bvlshr(Start, Start)
    Start = bvashr(Start, Start)
    Start = bvshl(Start, Start)
    Start = bvsdiv(Start, Start)
    Start = bvsrem(Start, Start)
    Start = bvsub(Start, Start)
    Start = ite(StartBool, Start, Start)
    StartBool = bveq(Start, Start)
    StartBool = bvslt(Start, Start)
    StartBool = bvule(Start, Start)
    StartBool = bvult(Start, Start)
    StartBool = bvsle(Start, Start)
    StartBool = bvugt(Start, Start)
end

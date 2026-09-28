"""
IO examples for the SyGuS Hacker's Delight benchmarks.

Ten examples per problem, every one of them a model of
`(assert (= out (hdNN x ...)))` produced by z3 (see `README.md` for the sampling
procedure). Inputs are 64-bit bit-vectors (`UInt64`); the output is a `UInt64`,
except for hd_10, hd_11, hd_12 and hd_18 whose specification returns a `Bool`.
"""

# hd-01: Hacker's delight 01, difficulty 5 Turn off the rightmost 1-bit in a bit-vector.
problem_hd_01 = Problem("problem_hd_01", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0xfffffffffffffffe),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000d1df440b), 0x00000000d1df440a),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000f02a), 0x000000000000f028),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000c009), 0x000000000000c008),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xda4f1cc74c10eb2d), 0xda4f1cc74c10eb2c),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000028d9c547), 0x0000000028d9c546),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc4b90fe9bc53c966), 0xc4b90fe9bc53c964)
])

# hd-02: Hacker's delight 02, difficulty 5 Test if unsigned int is of form 2^n - 1
problem_hd_02 = Problem("problem_hd_02", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000d367), 0x000000000000d360),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd2281e5980ce1a88), 0xd2281e5980ce1a88),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000019cc3493), 0x0000000019cc3490),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000948e), 0x000000000000948e),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000032d918af), 0x0000000032d918a0),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000a28319a3), 0x00000000a28319a0)
])

# hd-03: Hacker's delight 03, difficulty 5 Isolate the right most one bit
problem_hd_03 = Problem("problem_hd_03", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x081011c0000b0004), 0x0000000000000004),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0800000200000086), 0x0000000000000002),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0900001000024090), 0x0000000000000010),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0b00a223185adcc8), 0x0000000000000008),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xb41a091064840e20), 0x0000000000000020),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000001c0), 0x0000000000000040)
])

# hd-04: Form a bit mask that identifies the rightmost one bit and trailing zeros
problem_hd_04 = Problem("problem_hd_04", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x071b1d2570bf1840), 0x000000000000007f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x17ab091bd3bad272), 0x0000000000000003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x022910180c050088), 0x000000000000000f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000084d4), 0x0000000000000007),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000800000000), 0x0000000fffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000090), 0x000000000000001f)
])

# hd-05: Hacker's delight 05, difficulty 5 Right propagate the rightmost one bit
problem_hd_05 = Problem("problem_hd_05", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000001cb65cd9), 0x000000001cb65cd9),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000096ab), 0x00000000000096ab),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8c729a3249a01722), 0x8c729a3249a01723),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x91078a6ada09ebd6), 0x91078a6ada09ebd7),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000001e62), 0x0000000000001e63),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000092), 0x0000000000000093)
])

# hd-06: Hacker's delight 06, difficulty 5 Turn on the right most 0 bit
problem_hd_06 = Problem("problem_hd_06", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x8000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000f5b0), 0x000000000000f5b1),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000e9c0), 0x000000000000e9c1),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd9b411c8f138acb8), 0xd9b411c8f138acb9),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000001db5), 0x0000000000001db7),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000008f), 0x000000000000009f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000c44c9fcf), 0x00000000c44c9fdf)
])

# hd-07: Hacker's delight 07, difficulty 5 Isolate the rightmost 0 bit
problem_hd_07 = Problem("problem_hd_07", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000002),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x022210008e08009f), 0x0000000000000020),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000003), 0x0000000000000004),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xe040c04081030407), 0x0000000000000008),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x010240100301800f), 0x0000000000000010),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000003f), 0x0000000000000040),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000007fff), 0x0000000000008000)
])

# hd-08: Hacker's delight 08, difficulty 5 Form a mask that identifies the trailing zeros
problem_hd_08 = Problem("problem_hd_08", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x7fffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000090), 0x000000000000000f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000002040202), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd41e0ebc21efd194), 0x0000000000000003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x4005a00d000a0808), 0x0000000000000007),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000020), 0x000000000000001f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000080081080), 0x000000000000007f)
])

# hd-09: Hacker's delight 09, difficulty 5 Absolute value function
problem_hd_09 = Problem("problem_hd_09", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000085), 0x0000000000000085),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xcb280438b9806874), 0x34d7fbc799805794),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xdb840aa93ad3c2d7), 0x247bf556d6d3c233),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd32b693eb875e8af), 0x2cd496c177cc6855),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc5ac29b64c27f2ab), 0x3a53d64a3c274e5b),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x86a593226a747651), 0x795a6cde59f429d1)
])

# hd-10: Hacker's delight 10, difficulty 5 Test if (nlz x) == (nlz y) where nlz is the number of leading zeros
problem_hd_10 = Problem("problem_hd_10", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc0b01256fdd36c53, :_arg_2 => 0x954aa529000000c0), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000077, :_arg_2 => 0x54e9256d359220e1), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc8830ee220420077, :_arg_2 => 0x94601c07059001e1), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000052, :_arg_2 => 0x0000000003d011e5), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000003d011b7), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0000000003c011b6), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0030844420020418), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x75ba20028a2e29ab), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x52b2980b798c8540, :_arg_2 => 0x00000000000000cb), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000f264, :_arg_2 => 0x000000000ae62df4), false)
])

# hd-11: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
problem_hd_11 = Problem("problem_hd_11", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xf9490aa1fbf7defe, :_arg_2 => 0x0000400004002001), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x01480200bb774e7e, :_arg_2 => 0x2000000000000001), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x2040020000034e3c, :_arg_2 => 0x0000040480000000), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x2042001080534a3c, :_arg_2 => 0x8008008000000040), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000000000040), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0000000000000041), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0xbffffffff7fffdfe), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x263f73b7e3dd39fc), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x3ad05607d15962d8, :_arg_2 => 0xb0f9b8bcf28e55b8), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x1d48b754935590f2, :_arg_2 => 0x0000000000000026), true)
])

# hd-12: Test if (nlz x) < (nlz y) where nlz is the number of leading zeros
problem_hd_12 = Problem("problem_hd_12", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8388040084121060, :_arg_2 => 0x000000007bedefcd), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x03800410e4161042, :_arg_2 => 0x400000007befefcb), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000ec127162, :_arg_2 => 0x00000000000000cb), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000108cc107904, :_arg_2 => 0x000010000000048e), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x000010000000048e), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x000000000000048f), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x000000000000048f), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0001200000000002), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000087, :_arg_2 => 0x000000003dc34abf), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x298488e7b1c14794, :_arg_2 => 0x0087624298f367bd), true)
])

# hd-13: Hacker's delight 13, difficulty 5 sign function
problem_hd_13 = Problem("problem_hd_13", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x00000001ffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0xffffffff00000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x1000004000000000), 0x00000001ffffff80),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000100000000), 0x00000001fffffffe),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000002000000000), 0x00000001ffffffc0),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0010000000000000), 0x00000001ffe00000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000400000000000), 0x00000001ffff8000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0010080000000000), 0x00000001fffff000)
])

# hd-14: floor of average of two integers
problem_hd_14 = Problem("problem_hd_14", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x8000008000080003), 0x4000004000040001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x8000008000080006), 0x4000004000040003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0000000000000007), 0x8000000000000003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0000000000000083), 0x4000000000000041),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000004e, :_arg_2 => 0x1602a857a39ae846), 0x0b01542bd1cd744a),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xb7d4e00be7cf5cc6, :_arg_2 => 0x000000000000003d), 0x5bea7005f3e7ae81),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000097, :_arg_2 => 0x000000006517f21d), 0x00000000328bf95a),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000c90fe1ca, :_arg_2 => 0x681b040e64cac32e), 0x340d820796ed527c),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xacabae2269b607ea, :_arg_2 => 0x84a8c11be4ee7ad4), 0x98aa379f2752415f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000006fec, :_arg_2 => 0xc8a19836c0fd8a46), 0x6450cc1b607efd19)
])

# hd-15: floor of average of two integers
problem_hd_15 = Problem("problem_hd_15", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0xffffc80000000000), 0x7fffe40000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0xffffc80000000000), 0x7fffe40000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x4208a30a521ffffe), 0xa1045185290fffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x21e2ccfe08140000), 0x50f1667f040a0000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x004dcb3e39a33ef3, :_arg_2 => 0x0000000000000032), 0x0026e59f1cd19f93),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xe65fcb0c2bab95c9, :_arg_2 => 0x000000000000000e), 0x732fe58615d5caec),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000bbbf, :_arg_2 => 0x630c416ce524af93), 0x318620b67292b5a9),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xf6d42d7013a5d96b, :_arg_2 => 0x8d482a3ecf1624ce), 0xc20e2bd7715dff1d),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000000f, :_arg_2 => 0x00000000000000ca), 0x000000000000006d),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000473b, :_arg_2 => 0x00000000a6fd2c59), 0x00000000537eb9ca)
])

# hd-16: (no description in the original file)
problem_hd_16 = Problem("problem_hd_16", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000004050, :_arg_2 => 0x028800c012074161), 0x028800c012074161),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000048, :_arg_2 => 0x8ec900c01e077c61), 0x0000000000000048),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x8ec100c01c077461), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x8ec100c01c077463), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x6fffffdffffffffe), 0x6fffffdffffffffe),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x4000000000000000), 0x4000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x912021bb01846aa2, :_arg_2 => 0x00000000c0951932), 0x00000000c0951932),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000002c60, :_arg_2 => 0x00000000000012ad), 0x0000000000002c60),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc497f303d91b2850, :_arg_2 => 0x9005240476288e24), 0xc497f303d91b2850),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000071b76112, :_arg_2 => 0x000000000000006f), 0x0000000071b76112)
])

# hd-17: Hacker's delight 17, difficulty 5 turn off the rightmost string of contiguous ones
problem_hd_17 = Problem("problem_hd_17", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000b505), 0x000000000000b504),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x3841bc9a64c0bf87), 0x3841bc9a64c0bf80),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x4366348b6c561357), 0x4366348b6c561350),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000004c), 0x0000000000000040),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xf95886b8ab29e1da), 0xf95886b8ab29e1d8),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd5b5ada6ec3addd4), 0xd5b5ada6ec3addd0)
])

# hd-18: determine if power of two
problem_hd_18 = Problem("problem_hd_18", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000400), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000005), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000800000000000), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0082815802c65a06), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000010000), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000046046190), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000071d0), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000001000), true),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x6062400089090521), false),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), false)
])

# hd-19: Exchanging 2 fields A and B of the same register x where m is mask which identifies field B and k is number of bits from end of A to start of B.
problem_hd_19 = Problem("problem_hd_19", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000000000001, :_arg_3 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0000000000000001, :_arg_3 => 0x0000000000000021), 0x0000000200000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0000000000000001, :_arg_3 => 0x0000000000000021), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0000400000000001, :_arg_3 => 0x000000000000003b), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000001b502c08, :_arg_2 => 0xab6091c7a28224a0, :_arg_3 => 0x0000000000000002), 0x0000000019d09808),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000006d, :_arg_2 => 0x00000000e97e24ae, :_arg_3 => 0x000000000000000a), 0x000000000000b041),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xc6d9b146a09aa081, :_arg_2 => 0x0000000000002022, :_arg_3 => 0x0000000000000029), 0xc6d9b146a09aa081),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000be089579, :_arg_2 => 0x0000000007016e00, :_arg_3 => 0x0000000000000003), 0x00000000b701a379),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000059, :_arg_2 => 0x21483d121c1b4fc5, :_arg_3 => 0x0000000000000024), 0x0000041000000018),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000ae431033, :_arg_2 => 0x0000000000000075, :_arg_3 => 0x0000000000000025), 0x00000620ae431002)
])

# hd-20: Next higher unsigned number with the same number of 1 bits.
problem_hd_20 = Problem("problem_hd_20", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0xffffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000002),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x3fffffffffffffff),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x48c22b6ba5d04c47), 0x5af2abfbedf45f59),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x59a4bb44eb6a2424), 0x5dbefbf4effea66a),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000003e), 0x0000000000000047),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000008e), 0x0000000000000091),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8f1cd03d4448925f), 0xafdff43f555ab6f7),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000fc03), 0x000000000000ff04)
])

# hd-21: Cycling through 3 values a, b, c.
problem_hd_21 = Problem("problem_hd_21", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000001100, :_arg_2 => 0x0000000000001100, :_arg_3 => 0x0000000000001100, :_arg_4 => 0x0040000000000000), 0x0000000000001100),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000006efa, :_arg_2 => 0xfffffbeeeb9f9105, :_arg_3 => 0x0000000000000100, :_arg_4 => 0x0000000000000002), 0xfffffbeeeb9f9105),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000100c786, :_arg_2 => 0x131c416000820000, :_arg_3 => 0x000000000100c786, :_arg_4 => 0x8d14280000030110), 0x8d14280000030110),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000000ad, :_arg_2 => 0x0000000000000342, :_arg_3 => 0x000000009fdff712, :_arg_4 => 0x993c188120030911), 0x0000000000000342),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000000000340, :_arg_3 => 0x000000000000d713, :_arg_4 => 0x0000000000000080), 0x0000000000000340),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0000000000004340, :_arg_3 => 0x000400000000d713, :_arg_4 => 0x0000000000000080), 0x0000000000004340),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0000000000004341, :_arg_3 => 0x000400000000d793, :_arg_4 => 0x0001000000000080), 0x0000000000004341),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x000200040000c341, :_arg_3 => 0x0004000000009593, :_arg_4 => 0x0000888000000081), 0x000200040000c341),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8ca5800702401132, :_arg_2 => 0x9cc38c2b34996516, :_arg_3 => 0xf30dce6808374c61, :_arg_4 => 0x0000000048c3a083), 0x9cc38c2b34996516),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x9c0c1897487e81de, :_arg_2 => 0xaeefcd18b29a1e5f, :_arg_3 => 0x00000000000000e8, :_arg_4 => 0xbfc0e5b038c38dc0), 0xaeefcd18b29a1e5f)
])

# hd-22: Compute parity.
problem_hd_22 = Problem("problem_hd_22", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000000a9), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xa8495ee709616b6d), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x88ca3204c936f5b0), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000d4eb), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0c2d06a8065607c3), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000db2b4992), 0x0000000000000000)
])

# hd-23: Counting number of set bits.
problem_hd_23 = Problem("problem_hd_23", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000020),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x3d05984f9f25129d), 0x0000000000000010),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000079), 0x0000000000000005),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000000a2), 0x0000000000000003),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xa61c835674b9e0fa), 0x0000000000000012),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x830cd30f6aac318e), 0x000000000000000f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x5b6df9a184f8294c), 0x000000000000000d)
])

# hd-24: Round up to the next higher power of 2.
problem_hd_24 = Problem("problem_hd_24", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001), 0x0000000000000001),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0500010008200100), 0x0800000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x1d820fe12d5dd5e0), 0x2000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000000fe), 0x0000000000000100),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0c00004020000000), 0x1000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000008ae2), 0x0000000000010000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000121cc651), 0x0000000020000000)
])

# hd-25: Compute higher order half of product of x and y.
problem_hd_25 = Problem("problem_hd_25", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000000000001), 0x0000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0001000000000001), 0x0000000000030000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0000000000000003), 0x00000007fffffffe),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0000000000000003), 0x0000000400000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000038020c5309, :_arg_2 => 0x000800936a261e1a), 0x01c0c2862dd16c31),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x1b82a2c26315dc65, :_arg_2 => 0x94634929ce74666b), 0x10fac073f6fe10be),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x58075e504243bca0, :_arg_2 => 0x63189550b517e5f0), 0xeb9e9c3df8229278),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x7031184084c090fd, :_arg_2 => 0x00010050622c05f6), 0x529eb7c4e18bbc5a),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xb4fc8521efe5aadf, :_arg_2 => 0x000000000000bbb6), 0x0001096a8319c174),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xd3da9703951154ba, :_arg_2 => 0x3c5fab169cf8d696), 0x9ad4e70912d3b374)
])

# hd-26: Round up x to a multiple of k-th power of 2
problem_hd_26 = Problem("problem_hd_26", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0x0000000000000013), 0x0000000000080000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0x0000000000000033), 0x0008000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0x0000000000000010), 0x0000000000010000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0000000000000003), 0x8000000000000008),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000289a4383, :_arg_2 => 0x0000000000000017), 0x0000000029000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000000031bc, :_arg_2 => 0x000000000000001d), 0x0000000020000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000763668b9, :_arg_2 => 0x000000000000002e), 0x0000400000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x1f059587f26a2469, :_arg_2 => 0x0000000000000038), 0x2000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x000000000000007a, :_arg_2 => 0x000000000000000a), 0x0000000000000400),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x804a973d032cf442, :_arg_2 => 0x0000000000000003), 0x804a973d032cf448)
])

# hd-27: (no description in the original file)
problem_hd_27 = Problem("problem_hd_27", [
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8004408110001080, :_arg_2 => 0x00000000000020a3), 0x8004408110001080),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0dac48cb78421690, :_arg_2 => 0xc0ac08cb101034aa), 0xc0ac08cb101034aa),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000000, :_arg_2 => 0xc0ac08cb101034ea), 0xc0ac08cb101034ea),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000001, :_arg_2 => 0xc0ac08cb101074aa), 0xc0ac08cb101074aa),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0xffffffffffffffff, :_arg_2 => 0xc2ac08cb101074aa), 0xc2ac08cb101074aa),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x8000000000000000, :_arg_2 => 0x0000000000000010), 0x8000000000000000),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000000048, :_arg_2 => 0x11f2c03010d511bb), 0x0000000000000048),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x0000000000009264, :_arg_2 => 0x000000000000fbc7), 0x0000000000009264),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000506c0090, :_arg_2 => 0x000000000000007f), 0x000000000000007f),
    IOExample(Dict{Symbol,Any}(:_arg_1 => 0x00000000dfba9450, :_arg_2 => 0x00000000cad36cce), 0x00000000cad36cce)
])

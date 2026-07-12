# Generated from ConflictAnalysisExperiments.jl/artifacts/solutions/benchmark*.txt.

problem_001 = Problem("problem_001", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   round var1 var2 nam        val
    1 round1   22   33 foo 0.16912201
    2 round2   11   44 foo 0.18570826
    3 round1   22   33 bar 0.12410581
    4 round2   11   44 bar 0.03258235""")
        ), MorpheusTable(raw"""  nam val_round1 val_round2 var1_round1 var1_round2 var2_round1 var2_round2
    1 bar  0.1241058 0.03258235          22          11          33          44
    2 foo  0.1691220 0.18570826          22          11          33          44
    
    --------------------------------------------------------------------------------"""))
])

problem_002 = Problem("problem_002", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  month student A B
    1     1     Amy 9 6
    2     2     Amy 7 7
    3     3     Amy 6 8
    4     1     Bob 8 5
    5     2     Bob 6 6
    6     3     Bob 9 7""")
        ), MorpheusTable(raw"""  month Amy_A Amy_B Bob_A Bob_B
    1     1     9     6     8     5
    2     2     7     7     6     6
    3     3     6     8     9     7
    
    --------------------------------------------------------------------------------"""))
])

problem_003 = Problem("problem_003", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Person Time Score1 Score2
    1   greg  Pre     75     76
    2   greg Post     86     85
    3  sally  Pre     85     86
    4  sally Post     80     78""")
        ), MorpheusTable(raw"""  Person Post_Score1 Post_Score2 Pre_Score1 Pre_Score2
    1   greg          86          85         75         76
    2  sally          80          78         85         86
    
    --------------------------------------------------------------------------------"""))
])

problem_004 = Problem("problem_004", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id Year A  B
    1  1 2007 5 10
    2  1 2008 2  0
    3  1 2009 3 50
    4  2 2007 7 13
    5  2 2008 5 17
    6  2 2009 6 17""")
        ), MorpheusTable(raw"""  id A_2007 A_2008 A_2009 B_2007 B_2008 B_2009
    1  1      5      2      3     10      0     50
    2  2      7      5      6     13     17     17
    
    --------------------------------------------------------------------------------"""))
])

problem_005 = Problem("problem_005", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ID    T  P.1 P.2 Q.1
    1  1 24.3 10.2 5.5 4.5
    2  2 23.4 10.4 5.7 3.2""")
        ), MorpheusTable(raw"""  ID Channel    T    P
    1  1       1 24.3 10.2
    2  2       1 23.4 10.4
    3  1       2 24.3  5.5
    4  2       2 23.4  5.7
    5  1       1 24.3  4.5
    6  2       1 23.4  3.2
    
    --------------------------------------------------------------------------------"""))
])

problem_006 = Problem("problem_006", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  GeneID   D.1    T.1    D.8    T.8
    1 8876.5 510.5 4318.3 8957.7 4092.4
    2 2120.8 480.3 1694.6 2471.0 1784.1
    3 1266.6 213.8 1337.9  831.5  814.1""")
        ), MorpheusTable(raw"""  GeneID type    sum
    1 1266.6    D 1045.3
    2 1266.6    T 1337.9
    3 2120.8    D 2951.3
    4 2120.8    T 1694.6
    5 8876.5    D 9468.2
    6 8876.5    T 4318.3
    
    --------------------------------------------------------------------------------"""))
])

problem_007 = Problem("problem_007", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  GeneID D.1 T.1 D.2 T.2 D.8
    1    A2M  18  50   2   6  A1
    2   ABL1  20  48   4   8  C1""")
        ), MorpheusTable(raw"""  GeneID pt.num  D  T     Ratio
    1    A2M      1 18 50 0.3600000
    2    A2M      2  2  6 0.3333333
    3   ABL1      1 20 48 0.4166667
    4   ABL1      2  4  8 0.5000000
    
    --------------------------------------------------------------------------------"""))
])

problem_008 = Problem("problem_008", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Name Month Rate1 Rate2
    1 Aira     1    12    23
    2 Aira     2    18    73
    3  Ben     1    53    19
    4  Ben     2    22    87
    5  Cat     1    22    87
    6  Cat     2    67    43""")
        ), MorpheusTable(raw"""  Name avg1 avg2
    1 Aira 15.0   48
    2  Ben 37.5   53
    3  Cat 44.5   65
    
    --------------------------------------------------------------------------------"""))
])

problem_009 = Problem("problem_009", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   V1 V2   V3          V4
    1   a  1 High -0.62645381
    2   a  2 High  0.18364332
    3   a  3 High -0.83562861
    4   a  4 High  1.59528080
    5   a  1  Low  0.32950777
    6   a  2  Low -0.82046838
    7   a  3  Low  0.48742905
    8   a  4  Low  0.73832471
    9   b  1 High  0.57578135
    10  b  2 High -0.30538839
    11  b  3 High  1.51178117
    12  b  4 High  0.38984324
    13  b  1  Low -0.62124058
    14  b  2  Low -2.21469989
    15  b  3  Low  1.12493092
    16  b  4  Low -0.04493361""")
        ), MorpheusTable(raw"""  V1 V2      Ratio
    1  a  1 -1.9011807
    2  a  2 -0.2238274
    3  a  3 -1.7143595
    4  a  4  2.1606764
    5  b  1 -0.9268251
    6  b  2  0.1378915
    7  b  3  1.3438880
    8  b  4 -8.6759831
    
    --------------------------------------------------------------------------------"""))
])

problem_010 = Problem("problem_010", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""        date days                name        topics
    1 2012-06-12  1.0      Intro to stats probability|R
    2 2012-07-13  6.0 Stats Winter school  R|regression
    3 2012-08-04  0.5         TidyR tools   tidyR|dplyr""")
        ), MorpheusTable(raw"""        date days                name      value2
    1 2012-06-12  1.0      Intro to stats probability
    2 2012-07-13  6.0 Stats Winter school           R
    3 2012-08-04  0.5         TidyR tools       tidyR
    4 2012-06-12  1.0      Intro to stats           R
    5 2012-07-13  6.0 Stats Winter school  regression
    6 2012-08-04  0.5         TidyR tools       dplyr
    
    --------------------------------------------------------------------------------"""))
])

problem_011 = Problem("problem_011", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""       expr     time
    1 base__1d4  4203379
    2 base__1d4  4219165
    3 base__1d5 59249811
    4 base__1d5 59249833
    5 dplyr_1d4  4911550
    6 dplyr_1d4  4911533
    7 dplyr_1d5 72271322
    8 dplyr_1d5 63373463""")
        ), MorpheusTable(raw"""  size     base    dplyr     ratio
    1  1d4  4211272  4911542 0.8574237
    2  1d5 59249822 67822392 0.8736027
    
    --------------------------------------------------------------------------------"""))
])

problem_012 = Problem("problem_012", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   flight origin dest
    1    1141    JFK  MIA
    2     725    JFK  BQN
    3     461    LGA  ATL
    4    1696    EWR  ORD
    5     507    EWR  FLL
    6    5708    LGA  IAD
    7      79    JFK  MCO
    8     301    LGA  ORD
    9      11    EWR  SEA
    10    495    JFK  SEA
    11   1670    EWR  SEA""")
        ), MorpheusTable(raw"""  origin n      freq
    1    EWR 2 0.6666667
    2    JFK 1 0.3333333
    
    --------------------------------------------------------------------------------"""))
])

problem_013 = Problem("problem_013", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id    type transactions amount
    1 20  income           20    100
    2 20 expense           25     95
    3 30  income           50    300
    4 30 expense           45    250""")
        ), MorpheusTable(raw"""  id expense_amount expense_transactions income_amount income_transactions
    1 20             95                   25           100                  20
    2 30            250                   45           300                  50
    
    --------------------------------------------------------------------------------"""))
])

problem_014 = Problem("problem_014", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   ID Diagnosis_1 Diagnosis_2 Diagnosis_3 Diagnosis_4
    1   A           1           0           0           0
    2   A           1           0           0           0
    3   A           1           0           0           0
    4   B           0           1           0           0
    5   C           0           0           0           1
    6   C           0           1           0           0
    7   D           0           0           0           1
    8   E           0           0           1           0
    9   E           0           1           0           0
    10  E           0           0           1           0""")
        ), MorpheusTable(raw"""   ID value
    1   A     1
    2   A     1
    3   A     1
    4   B     2
    5   C     2
    6   E     2
    7   E     3
    8   E     3
    9   C     4
    10  D     4
    
    --------------------------------------------------------------------------------"""))
])

problem_015 = Problem("problem_015", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Timepoint Group1 Error1_Group1 Group2 Error2_Group1
    1         7     60             4     60            14
    2        14     66             6     90            16""")
        ), MorpheusTable(raw"""  Timepoint Group1 Group2 Error1 mGroup Error2
    1         7     60     60      4 Group1     14
    2        14     66     90      6 Group1     16
    
    --------------------------------------------------------------------------------"""))
])

problem_016 = Problem("problem_016", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ID  Color    Type     W1     W2
    1  1    red Outdoor  74.22  26.86
    2  2    red  Indoor  78.59 138.80
    3  7    red  Indoor  38.41  84.81
    4  8    red Outdoor 140.68  93.33
    5  9 yellow Outdoor  65.95 104.31""")
        ), MorpheusTable(raw"""   Color sumCount sumMean
    1    red        3       3
    2 yellow        1       1
    
    --------------------------------------------------------------------------------"""))
])

problem_017 = Problem("problem_017", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Id Group Var1 Var2
    1  1     A good   10
    2  2     A good    6
    3  3     A  bad    9
    4  4     B good    3
    5  5     B good    3
    6  6     B  bad    8""")
        ), MorpheusTable(raw"""  Group bad good
    1     A   9   16
    
    --------------------------------------------------------------------------------"""))
])

problem_018 = Problem("problem_018", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  message.id sender recipient
    1          1      A         A
    2          1      A         C
    3          2      A         B
    4          3      B         C
    5          3      C         D
    6          3      D         B""")
        ), MorpheusTable(raw"""  address recipient sender
    1       A         1      3
    2       B         2      1
    3       C         2      1
    4       D         1      1
    
    --------------------------------------------------------------------------------"""))
])

problem_019 = Problem("problem_019", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""                     12:10                    12:20                    12:30
    1                  nuclear                  nuclear                  nuclear
    2                  nuclear                  nuclear                    child
    3                    child                    child                    child
    4                    child                    child                    child
    5                    child                    child                    child
    6 nuclear and acquaintance nuclear and acquaintance nuclear and acquaintance
    7 nuclear and acquaintance nuclear and acquaintance nuclear and acquaintance
    8                notnotnot                notnotnot                notnotnot
    9                  nuclear                  nuclear                  nuclear""")
        ), MorpheusTable(raw"""                     value 12:10 12:20 12:30
    1                    child     3     3     4
    2                notnotnot     1     1     1
    3                  nuclear     3     3     2
    4 nuclear and acquaintance     2     2     2
    
    --------------------------------------------------------------------------------"""))
])

problem_020 = Problem("problem_020", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  group  times action_rate action_rate2
    1     a before        0.10         0.20
    2     a  after        0.15         0.25
    3     b before        0.20         0.30
    4     b  after        0.18         0.28""")
        ), MorpheusTable(raw"""  group action_rate_after action_rate_before action_rate2_after
    1     a              0.15                0.1               0.25
    2     b              0.18                0.2               0.28
      action_rate2_before
    1                 0.2
    2                 0.3
    
    --------------------------------------------------------------------------------"""))
])

problem_021 = Problem("problem_021", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  obs pre.data1 post.data1 pre.data2 post.data2
    1   1      0.40       0.12      0.61       0.15
    2   2      0.21       0.05      0.18       0.49
    3   3      0.48       0.85      0.00       0.62
    4   4      0.66       0.29      0.88       0.56""")
        ), MorpheusTable(raw"""  obs  key data1 data2
    1   1 post  0.12  0.15
    2   1  pre  0.40  0.61
    3   2 post  0.05  0.49
    4   2  pre  0.21  0.18
    5   3 post  0.85  0.62
    6   3  pre  0.48  0.00
    7   4 post  0.29  0.56
    8   4  pre  0.66  0.88
    
    --------------------------------------------------------------------------------"""))
])

problem_022 = Problem("problem_022", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Player    Team Shots Passes Tackles
    1 Abdoun Algeria     0      6       0
    2    Abe   Japan     3    101      14
    3 Abidal  France     0     91       6
    4  Abreu Uruguay     5     15       0""")
        ), MorpheusTable(raw"""      Var  Mean
    1  Passes 53.25
    2 Tackles  5.00
    
    --------------------------------------------------------------------------------"""))
])

problem_023 = Problem("problem_023", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  custno     X1    X2     X3
    1    100  29.85 49.75 146.70
    2    100 122.70 49.75  39.80
    3    100   0.00  9.95  44.95""")
        ), MorpheusTable(raw"""  custno totalspent
    1    100     493.45
    
    --------------------------------------------------------------------------------"""))
])

problem_024 = Problem("problem_024", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id  yr1  yr2  yr3  yr4 var
    1  1 1090 2066 3050 4012 yr3
    2  2 1026 2062 3071 4026 yr2
    3  3 1036 2006 3098 4038 yr1
    4  4 1056 2020 3037 4001 yr4""")
        ), MorpheusTable(raw"""   id var value
    1   1 yr3  2066
    2   1 yr3  3050
    3   1 yr3  4012
    4   2 yr2  2062
    5   2 yr2  3071
    6   2 yr2  4026
    7   3 yr1  2006
    8   3 yr1  3098
    9   3 yr1  4038
    10  4 yr4  2020
    11  4 yr4  3037
    12  4 yr4  4001
    
    --------------------------------------------------------------------------------"""))
])

problem_025 = Problem("problem_025", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  a b
    1 1 1
    2 1 2
    3 4 3
    4 4 3
    5 1 2
    6 1 2""")
        ), MorpheusTable(raw"""  key_ab e
    1    1_2 3
    2    4_3 2
    
    --------------------------------------------------------------------------------"""))
])

problem_026 = Problem("problem_026", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  sym a1 a2 b1 b2
    1   a  1  2  1  1
    2   a  2  2  2  2
    3   a  1  2  3  3
    4   b  2  1  4  4
    5   b  1  1  5  5
    6   b  2  1  6  6""")
        ), MorpheusTable(raw"""  sym a1 b1.mean a2 b2.mean
    1   a  1       2  2       2
    2   a  2       2  2       2
    3   b  1       5  1       5
    4   b  2       5  1       5
    
    --------------------------------------------------------------------------------"""))
])

problem_027 = Problem("problem_027", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Factor A.measure     A.SD B.measure     B.SD C.measure     C.SD
    1      K  52127803  9124563  63752981 34800000 103512032 23900000
    2      L  63410326 21975533  68303447 22600000  65074191 20800000
    3      M  76455662  9864019  73250794  6090000  92686983 38300000""")
        ), MorpheusTable(raw"""  Factor measure_letter   measure       SD
    1      K              A  52127803  9124563
    2      K              B  63752981 34800000
    3      K              C 103512032 23900000
    4      L              A  63410326 21975533
    5      L              B  68303447 22600000
    6      L              C  65074191 20800000
    7      M              A  76455662  9864019
    8      M              B  73250794  6090000
    9      M              C  92686983 38300000
    
    --------------------------------------------------------------------------------"""))
])

problem_028 = Problem("problem_028", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   id a b c
    1 101 1 2 3
    2 102 2 2 3
    3 103 3 2 3""")
        ), MorpheusTable(raw"""   id     mean a b c
    1 101 2.000000 1 2 3
    2 102 2.333333 2 2 3
    3 103 2.666667 3 2 3
    
    --------------------------------------------------------------------------------"""))
])

problem_029 = Problem("problem_029", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  rowname   CA   DATE_1   TIME_1 ENTRIES_1   DATE_2   TIME_2 ENTRIES_2
    1       1 A002 07-27-13 00:00:00   4209603 07-27-13 08:00:00   4209663
    2       2 A002 07-28-13 08:00:00   4210490 07-28-13 16:00:00   4210775
    3       3 A002 07-29-13 16:00:00   4211586 07-30-13 00:00:00   4212845""")
        ), MorpheusTable(raw"""    CA     DATE ENTRIES     TIME
    1 A002 07-27-13 4209603 00:00:00
    2 A002 07-27-13 4209663 08:00:00
    3 A002 07-28-13 4210490 08:00:00
    4 A002 07-28-13 4210775 16:00:00
    5 A002 07-29-13 4211586 16:00:00
    6 A002 07-30-13 4212845 00:00:00
    
    --------------------------------------------------------------------------------"""))
])

problem_030 = Problem("problem_030", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  name1 con1_1 con1_2 con2_1 con2_2
    1     a     23     33     23     40
    2     b     25     34     22     50
    3     c     28     29     30     60""")
        ), MorpheusTable(raw"""  name1 con1 con2
    1     a 28.0 31.5
    2     b 29.5 36.0
    3     c 28.5 45.0
    
    --------------------------------------------------------------------------------"""))
])

problem_031 = Problem("problem_031", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  gear am  n
    1    3  0 15
    2    4  0  4
    3    4  1  8
    4    3  1  5""")
        ), MorpheusTable(raw"""  gear 0_n 0_percent 1_n 1_percent
    1    3  15   0.46875   5   0.15625
    2    4   4   0.12500   8   0.25000
    
    --------------------------------------------------------------------------------"""))
])

problem_032 = Problem("problem_032", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id sex trt.1 response.1 trt.2 response.2
    1  1   M     A          1     B          1
    2  2   M     A          1     B          1
    3  3   F     A          1     B          1
    4  4   M     A          1     B          1
    5  5   F     A          1     B          1
    6  6   M     A          1     B          1""")
        ), MorpheusTable(raw"""   id sex number response trt
    1   1   M      1        1   A
    2   1   M      2        1   B
    3   2   M      1        1   A
    4   2   M      2        1   B
    5   3   F      1        1   A
    6   3   F      2        1   B
    7   4   M      1        1   A
    8   4   M      2        1   B
    9   5   F      1        1   A
    10  5   F      2        1   B
    11  6   M      1        1   A
    12  6   M      2        1   B
    
    --------------------------------------------------------------------------------"""))
])

problem_033 = Problem("problem_033", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  event_id income location
    1        A      1   PlaceX
    2        B      2   PlaceY
    3        A      3   PlaceX
    4        A      4   PlaceX
    5        B      5   PlaceY""")
        ), MorpheusTable(raw"""  event_id mean_inc income location
    1        A 2.666667      1   PlaceX
    2        A 2.666667      3   PlaceX
    3        A 2.666667      4   PlaceX
    4        B 3.500000      2   PlaceY
    5        B 3.500000      5   PlaceY
    
    --------------------------------------------------------------------------------"""))
])

problem_034 = Problem("problem_034", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  test1_rater1 test2_rater1 test1_rater2 test2_rater2 row
    1            1            1            2            1   1
    2            3            3            3            3   3
    3            2            3            4            4   4
    4            3            2            1            3   5
    5            4            3            2            4   6
    6            3            1            1            3  10""")
        ), MorpheusTable(raw"""   row  test rater1 rater2
    1    1 test1      1      2
    2    1 test2      1      1
    3    3 test1      3      3
    4    3 test2      3      3
    5    4 test1      2      4
    6    4 test2      3      4
    7    5 test1      3      1
    8    5 test2      2      3
    9    6 test1      4      2
    10   6 test2      3      4
    11  10 test1      3      1
    12  10 test2      1      3
    
    --------------------------------------------------------------------------------"""))
])

problem_035 = Problem("problem_035", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""      Day HL.Average D.Average LL.Average noHKB.Average    HL.SD      D.SD
    1 0.00000       8760      8900      10000          8030 2337.844  924.2742
    2 1.90625      13300     11900      12100          3860 1016.291 2308.2661
    3 3.00000      14500      7320      12300          1750 2945.098 1308.0389
    4 4.00000      16200      9160      15100          2710 1006.893  514.2177
         LL.SD noHKB.SD
    1 1120.785 1592.646
    2 3581.763 1031.057
    3 4338.897 1793.583
    4 4362.261 2691.648""")
        ), MorpheusTable(raw"""       Day Group Average        SD
    1  0.00000     D    8900  924.2742
    2  0.00000    HL    8760 2337.8440
    3  0.00000    LL   10000 1120.7850
    4  0.00000 noHKB    8030 1592.6460
    5  1.90625     D   11900 2308.2661
    6  1.90625    HL   13300 1016.2910
    7  1.90625    LL   12100 3581.7630
    8  1.90625 noHKB    3860 1031.0570
    9  3.00000     D    7320 1308.0389
    10 3.00000    HL   14500 2945.0980
    11 3.00000    LL   12300 4338.8970
    12 3.00000 noHKB    1750 1793.5830
    13 4.00000     D    9160  514.2177
    14 4.00000    HL   16200 1006.8930
    15 4.00000    LL   15100 4362.2610
    16 4.00000 noHKB    2710 2691.6480
    
    --------------------------------------------------------------------------------"""))
])

problem_036 = Problem("problem_036", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  sbj f1.avg f1.sd f2.avg f2.sd blabla
    1   A     10     6     50    10     bA
    2   B     12     5     70    11     bB
    3   C     20     7     20     8     bC
    4   D     22     8     22     9     bD""")
        ), MorpheusTable(raw"""  sbj blabla var avg sd
    1   A     bA  f1  10  6
    2   A     bA  f2  50 10
    3   B     bB  f1  12  5
    4   B     bB  f2  70 11
    5   C     bC  f1  20  7
    6   C     bC  f2  20  8
    7   D     bD  f1  22  8
    8   D     bD  f2  22  9
    
    --------------------------------------------------------------------------------"""))
])

problem_037 = Problem("problem_037", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  V1 V2  V3  V4  V5
    1  a  b   a EMP EMP
    2  a  b EMP   c EMP
    3  a  b EMP EMP   d
    4  x  y   h EMP EMP
    5  x  y EMP   k   e""")
        ), MorpheusTable(raw"""  V1 V2 V3 V4 V5
    1  a  b  a  c  d
    2  x  y  h  k  e
    
    --------------------------------------------------------------------------------"""))
])

problem_038 = Problem("problem_038", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  name group V1 V2
    1    A    g1 10  6
    2    A    g2 40  3
    3    B    g1 20  1
    4    B    g2 30  7""")
        ), MorpheusTable(raw"""  name V1_g1 V1_g2 V2_g1 V2_g2
    1    A    10    40     6     3
    2    B    20    30     1     7
    
    --------------------------------------------------------------------------------"""))
])

problem_039 = Problem("problem_039", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""     id age_1 age_2 favCol_1 favCol_2
    1 user1    20    21     blue      red
    2 user2    25    34      red     blue
    3 user3    32    33     blue      red""")
        ), MorpheusTable(raw"""     id panel age favCol
    1 user1     1  20   blue
    2 user1     2  21    red
    3 user2     1  25    red
    4 user2     2  34   blue
    5 user3     1  32   blue
    6 user3     2  33    red
    
    --------------------------------------------------------------------------------"""))
])

problem_040 = Problem("problem_040", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   day site value.1 value.2
    1    1    a       1       5
    2    2    a       2       4
    3    3    a       5       7
    4    4    a       7       6
    5    5    a       5       2
    6    6    a       3       4
    7    1    b       9       6
    8    2    b       4       9
    9    3    b       2       4
    10   4    b       8       2
    11   5    b       1       5
    12   6    b       8       6""")
        ), MorpheusTable(raw"""  day a_value.1 a_value.2 b_value.1 b_value.2
    1   1         1         5         9         6
    2   2         2         4         4         9
    3   3         5         7         2         4
    4   4         7         6         8         2
    5   5         5         2         1         5
    6   6         3         4         8         6
    
    --------------------------------------------------------------------------------"""))
])

problem_041 = Problem("problem_041", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Scenario x_min x_mean x_max y_min y_mean y_max z_min z_mean z_max
    1     base  -3.0   0.00     2  -1.5      1   5.0     0   0.25     2
    2   stress  -2.0   0.25     1  -2.0      2   3.0     1   2.00     4
    3  extreme  -2.5   1.00     3  -3.0      3   3.5     3   5.00     7""")
        ), MorpheusTable(raw"""  Scenario varNew max mean  min
    1     base      x 2.0 0.00 -3.0
    2     base      y 5.0 1.00 -1.5
    3     base      z 2.0 0.25  0.0
    4  extreme      x 3.0 1.00 -2.5
    5  extreme      y 3.5 3.00 -3.0
    6  extreme      z 7.0 5.00  3.0
    7   stress      x 1.0 0.25 -2.0
    8   stress      y 3.0 2.00 -2.0
    9   stress      z 4.0 2.00  1.0
    
    --------------------------------------------------------------------------------"""))
])

problem_042 = Problem("problem_042", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  MemberID years a b c d
    1      123    Y1 0 0 1 0
    2      123    Y2 0 0 1 0
    3      234    Y1 1 0 0 1
    4      234    Y2 0 1 0 0""")
        ), MorpheusTable(raw"""  MemberID Y1_a Y1_b Y1_c Y1_d Y2_a Y2_b Y2_c Y2_d
    1      123    0    0    1    0    0    0    1    0
    2      234    1    0    0    1    0    1    0    0
    
    --------------------------------------------------------------------------------"""))
])

problem_043 = Problem("problem_043", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Geotype   Strategy Year.1 Year.2
    1       A     Demand      1      5
    2       A Strategy_1      2      6
    3       A Strategy_2      3      7
    4       B     Demand      8      8
    5       B Strategy_1      9      9
    6       B Strategy_2     10     10""")
        ), MorpheusTable(raw"""  Geotype    key sumVal
    1       A Year.1      5
    2       A Year.2     13
    3       B Year.1     19
    4       B Year.2     19
    
    --------------------------------------------------------------------------------"""))
])

problem_044 = Problem("problem_044", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Geotype   Strategy Year.1 Year.2
    1       A     Demand      1      5
    2       A Strategy_1      2      6
    3       A Strategy_2      3      7
    4       B     Demand      8      8
    5       B Strategy_1      9      9
    6       B Strategy_2     10     10""")
        ), MorpheusTable(raw"""  Geotype Year.1 Year.2
    1       A      5     13
    2       B     19     19
    
    --------------------------------------------------------------------------------"""))
])

problem_045 = Problem("problem_045", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   posture code  HR  EE a
    1  cycling  A03 102 100 3
    2 standing  A03  99  99 4
    3  sitting  A03  98  67 5
    4  walking  A03  97  78 3
    5  cycling  B01 111  76 5
    6 standing  B01 100  88 4
    7  sitting  B01  78  34 4
    8  walking  B01  99  99 2""")
        ), MorpheusTable(raw"""  code cycling_a cycling_EE cycling_HR sitting_a sitting_EE sitting_HR
    1  A03         3        100        102         5         67         98
    2  B01         5         76        111         4         34         78
      standing_a standing_EE standing_HR walking_a walking_EE walking_HR
    1          4          99          99         3         78         97
    2          4          88         100         2         99         99
    
    --------------------------------------------------------------------------------"""))
])

problem_046 = Problem("problem_046", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  sample_ID   site   species TOT inf_status
    1    382870 site_1 Species_B   1   positive
    2    487405 site_2 Species_A   1   positive
    3    487405 site_2 Species_B   1   positive
    4    487405 site_2 Species_A   1   positive
    5    382899 site_1 Species_A   1   positive
    6    382899 site_1 Species_C   1   positive
    7    382899 site_2 Species_C  10   positive
    8    382899 site_1 Species_D   1   positive
    9    382899 site_2 Species_D  20   positive""")
        ), MorpheusTable(raw"""    site Species_A_positive Species_B_positive Species_C_positive
    1 site_1                  1                  1                  1
    2 site_2                  2                  1                 10
      Species_D_positive
    1                  1
    2                 20
    
    --------------------------------------------------------------------------------"""))
])

problem_047 = Problem("problem_047", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ID c_Al c_D c_Hy  occ
    1  C    0   0    1 2581
    2  D    1   0    1 1917
    3  E    0   0    1 2708
    4  F    0   1    0 2751
    5  G    1   1    0 1522""")
        ), MorpheusTable(raw"""   Var      0      1
    1 c_Al 2680.0 1719.5
    2  c_D 2402.0 2136.5
    3 c_Hy 2136.5 2402.0
    
    --------------------------------------------------------------------------------"""))
])

problem_048 = Problem("problem_048", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  sample  BMI var1_LRR var1_BAF var2_LRR var2_BAF var3_LRR var3_BAF var200_LRR
    1     AA 18.9     0.27     0.99     0.18     0.99     0.11        1       0.20
    2     BB 27.1     0.23     1.00     0.13     0.99     0.17        1       0.23
      var200_BAF
    1       0.99
    2       0.99""")
        ), MorpheusTable(raw"""  sample  BMI varNew  BAF  LRR
    1     AA 18.9   var1 0.99 0.27
    2     AA 18.9   var2 0.99 0.18
    3     AA 18.9 var200 0.99 0.20
    4     AA 18.9   var3 1.00 0.11
    5     BB 27.1   var1 1.00 0.23
    6     BB 27.1   var2 0.99 0.13
    7     BB 27.1 var200 0.99 0.23
    8     BB 27.1   var3 1.00 0.17
    
    --------------------------------------------------------------------------------"""))
])

problem_049 = Problem("problem_049", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Test temperature_sensor1 temperature_sensor2 pressure_sensor1
    1    1            22.51868            24.23571        11.346620
    2    2            20.69246            22.53656        11.798325
    3    3            33.94608            20.24266        11.479349
    4    4            24.10963            26.41655         8.250279
    5    5            26.50271            28.55482         9.926986
    6    6            27.10880            31.80768        11.575317
      pressure_sensor2
    1        11.489648
    2         7.680483
    3         9.820589
    4        13.810615
    5        10.582618
    6         7.205214""")
        ), MorpheusTable(raw"""   Test  sensor  pressure temperature
    1     1 sensor1 11.346620    22.51868
    2     1 sensor2 11.489648    24.23571
    3     2 sensor1 11.798325    20.69246
    4     2 sensor2  7.680483    22.53656
    5     3 sensor1 11.479349    33.94608
    6     3 sensor2  9.820589    20.24266
    7     4 sensor1  8.250279    24.10963
    8     4 sensor2 13.810615    26.41655
    9     5 sensor1  9.926986    26.50271
    10    5 sensor2 10.582618    28.55482
    11    6 sensor1 11.575317    27.10880
    12    6 sensor2  7.205214    31.80768
    
    --------------------------------------------------------------------------------"""))
])

problem_050 = Problem("problem_050", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ID p_2012 p_2010 p_2008 p_2006 c_2012 c_2010 c_2008 c_2006
    1  1    160    162    163    165   37.3   37.3   37.1   37.1
    2  2    163    164    164    163    2.6    2.6    2.6    2.6""")
        ), MorpheusTable(raw"""  ID year    c   p
    1  1 2006 37.1 165
    2  1 2008 37.1 163
    3  1 2010 37.3 162
    4  1 2012 37.3 160
    5  2 2006  2.6 163
    6  2 2008  2.6 164
    7  2 2010  2.6 164
    8  2 2012  2.6 163
    
    --------------------------------------------------------------------------------"""))
])

problem_051 = Problem("problem_051", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""       V2         V3 V4
    1  CCRG10 BranchDBMS  2
    2  CCRG10  CacheDBMS  3
    3  CCRG20 BranchDBMS  7
    4  CCRG20  CacheDBMS  2
    5  CCRG30 BranchDBMS 15
    6  CCRG30  CacheDBMS  5
    7  CCRG40 BranchDBMS 62
    8  CCRG40  CacheDBMS  7
    9  CCRG50 BranchDBMS 58
    10 CCRG50  CacheDBMS 11""")
        ), MorpheusTable(raw"""       V2        key      value
    1  CCRG10 BranchDBMS  2.0000000
    2  CCRG20 BranchDBMS  7.0000000
    3  CCRG30 BranchDBMS 15.0000000
    4  CCRG40 BranchDBMS 62.0000000
    5  CCRG50 BranchDBMS 58.0000000
    6  CCRG10  CacheDBMS  3.0000000
    7  CCRG20  CacheDBMS  2.0000000
    8  CCRG30  CacheDBMS  5.0000000
    9  CCRG40  CacheDBMS  7.0000000
    10 CCRG50  CacheDBMS 11.0000000
    11 CCRG10    wtimRes  0.6666667
    12 CCRG20    wtimRes  3.5000000
    13 CCRG30    wtimRes  3.0000000
    14 CCRG40    wtimRes  8.8571429
    15 CCRG50    wtimRes  5.2727273
    
    --------------------------------------------------------------------------------"""))
])

problem_052 = Problem("problem_052", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""    Market Variables median lower.limit upper.limit
    1 market_1     var_1   2.78        2.71        2.72
    2 market_1     var_2   3.21        2.96        3.44
    3 market_2     var_1   2.95        2.79        3.11
    4 market_2     var_2   2.11        1.91        2.30""")
        ), MorpheusTable(raw"""    Market var_1_lower.limit var_1_median var_1_upper.limit var_2_lower.limit
    1 market_1              2.71         2.78              2.72              2.96
    2 market_2              2.79         2.95              3.11              1.91
      var_2_median var_2_upper.limit
    1         3.21              3.44
    2         2.11              2.30
    
    --------------------------------------------------------------------------------"""))
])

problem_053 = Problem("problem_053", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  year roleInDebate Clarity_1 Effort_1 Clarity_2 Effort_2 Clarity_3 Effort_3
    1 2006            x         3        5        10        4         5        7
    2 2009            y         2        8         3        1         6        8
    3 2013            r         7       10         7        4         5        2
    4 2020            q         4        4         2        9         2        8
    5 2004            b         8        8         3        4         9        5""")
        ), MorpheusTable(raw"""   year roleInDebate person Clarity Effort
    1  2004            b      1       8      8
    2  2004            b      2       3      4
    3  2004            b      3       9      5
    4  2006            x      1       3      5
    5  2006            x      2      10      4
    6  2006            x      3       5      7
    7  2009            y      1       2      8
    8  2009            y      2       3      1
    9  2009            y      3       6      8
    10 2013            r      1       7     10
    11 2013            r      2       7      4
    12 2013            r      3       5      2
    13 2020            q      1       4      4
    14 2020            q      2       2      9
    15 2020            q      3       2      8
    
    --------------------------------------------------------------------------------"""))
])

problem_054 = Problem("problem_054", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   score group category
    1     10    a1      big
    2      8    a1      big
    3      9    a1      big
    4      1    a1      big
    5      5    a1    small
    6      8    a2      big
    7      2    a2      big
    8      8    a2      big
    9      5    a2      big
    10     6    a2    small
    11     9    a3      big
    12     4    a3      big
    13     7    a3      big
    14     9    a3      big
    15     9    a3    small""")
        ), MorpheusTable(raw"""  group mean
    1    a1 7.00
    2    a2 5.75
    3    a3 7.25
    
    --------------------------------------------------------------------------------"""))
])

problem_055 = Problem("problem_055", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Category             qs Ans
    1     Cat1 Q1.a-Some-Text   1
    2     Cat2 Q1.b-Some-Text   2
    3     Cat2 Q1.a-Some-Text   2
    4     Cat2 Q1.a-Some-Text   1
    5     Cat1 Q1.b-Some-Text   1
    6     Cat2 Q1.a-Some-Text   1
    7     Cat1 Q1.b-Some-Text   2
    8     Cat1 Q1.a-Some-Text   2
    9     Cat2 Q1.b-Some-Text   1""")
        ), MorpheusTable(raw"""              qs   1   2
    1 Q1.a-Some-Text 0.6 0.4
    2 Q1.b-Some-Text 0.5 0.5
    
    --------------------------------------------------------------------------------"""))
])

problem_056 = Problem("problem_056", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ST Rfips   zip Year  dist.km
    1 PA 42107 17972 2010  0.00000
    2 VA 51760 23226 2005 42.46894
    3 RI 44001  2806 2010 28.11234
    4 NJ 34001  8330 2008 36.85470
    5 PA 51061 20118 2007  0.00000
    6 VT 50023  5681 2006 49.72765
    7 NY 36029 14072 2005  0.00000
    8 PA 42101 19115 2008 30.19372
    9 NC 37019 28451 2009  0.00000""")
        ), MorpheusTable(raw"""  ST total
    1 NC     1
    2 NY     1
    3 PA     2
    
    --------------------------------------------------------------------------------"""))
])

problem_057 = Problem("problem_057", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  ID MGW.one MGW.two HEL.one HEL.two
    1  A   10.00      19      12   13.00
    2  B  -13.29      13      12   -0.12
    3  C   -6.95      10      15    4.00""")
        ), MorpheusTable(raw"""  ID   HEL    MGW
    1  A 12.50 14.500
    2  B  5.94 -0.145
    3  C  9.50  1.525
    
    --------------------------------------------------------------------------------"""))
])

problem_058 = Problem("problem_058", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  V51     Hour Group
    1   1 02:00:00   SBT
    2   1 08:00:00   SBS
    3   9 08:00:00   SBS
    4   4 18:00:00   SBS
    5   2 06:00:00   SBI
    6   6 11:00:00   SBT
    7   4 18:00:00   SBS
    8   6 10:00:00   SBI""")
        ), MorpheusTable(raw"""  sum
    1  10
    2   8
    
    --------------------------------------------------------------------------------"""))
])

problem_059 = Problem("problem_059", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  year sex   name    n
    1 1955   F  Kerry  615
    2 1955   M  Kerry 1600
    3 1980   F  Kerry 1000
    4 1980   M  Kerry  432
    5 1988   F  Kerry  598
    6 1988   M  Kerry  421
    7 1980   F Sherry  234
    8 1980   M Sherry 1200""")
        ), MorpheusTable(raw"""  year    F    M
    1 1955  615 1600
    2 1980 1000  432
    3 1988  598  421
    
    --------------------------------------------------------------------------------"""))
])

problem_060 = Problem("problem_060", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""   mpg cyl vs am
    1 21.0   6  0  1
    2 21.0   6  0  1
    3 22.8   4  1  1
    4 21.4   6  1  0
    5 18.7   8  0  0
    6 18.1   6  1  0
    7 14.3   8  0  0
    8 24.4   4  1  0""")
        ), MorpheusTable(raw"""  vs_am countofvalues
    1   0_0             2
    2   0_1             2
    3   1_0             3
    4   1_1             1
    
    --------------------------------------------------------------------------------"""))
])

problem_061 = Problem("problem_061", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  Subject Var1 Var2
    1   A-pre   25   27
    2  A-post   25   26
    3   B-pre   30   28
    4  B-post   30   28""")
        ), MorpheusTable(raw"""  SubjectNew Var1_post Var1_pre Var2_post Var2_pre
    1          A        25       25        26       27
    2          B        30       30        28       28
    
    --------------------------------------------------------------------------------"""))
])

problem_062 = Problem("problem_062", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""                 Title Rating Action Sci.Fi
    1               Carrie      4      0      1
    2 Fried-Green-Tomatoes      2      0      0
    3              Amadeus      5      1      0
    4    Amityville-Horror      1      0      0
    5              Dracula      2      0      1
    6                Speed      4      1      0""")
        ), MorpheusTable(raw"""   genre average
    1 Action     4.5
    2 Sci.Fi     3.0
    
    --------------------------------------------------------------------------------"""))
])

problem_063 = Problem("problem_063", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id         p1         p2 p3
    1  1 -0.7833568  0.6383588  1
    2  2 -0.4073465  0.3480860  1
    3  1  0.2799414 -0.1938586  2
    4  2 -1.3496633 -0.5271080  2
    5  1 -0.1030045  0.8642336  3
    6  2  0.5839070 -0.9723264  3""")
        ), MorpheusTable(raw"""  id       1_p1      1_p2       2_p1       2_p2       3_p1       3_p2
    1  1 -0.7833568 0.6383588  0.2799414 -0.1938586 -0.1030045  0.8642336
    2  2 -0.4073465 0.3480860 -1.3496633 -0.5271080  0.5839070 -0.9723264
    
    --------------------------------------------------------------------------------"""))
])

problem_064 = Problem("problem_064", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  a b   d
    1 1 1   0
    2 1 1 200
    3 1 1 300
    4 1 1   0
    5 1 1 600
    6 1 2   0
    7 1 2 100
    8 1 2 200
    9 1 3   0""")
        ), MorpheusTable(raw"""  a b   mean_d
    1 1 1 366.6667
    2 1 2 150.0000
    
    --------------------------------------------------------------------------------"""))
])

problem_065 = Problem("problem_065", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  vial_id band non_spec      reads
    1       1    1        1 -1.7906249
    2       2    0        0  1.3883798
    3       3    0        1  0.4490315
    4       4    2        1  0.9137950
    5       5    1        1 -1.5885563
    6       6    2        1  0.4183408""")
        ), MorpheusTable(raw"""  group_id group_mean
    1      0_0  1.3883798
    2      0_1  0.4490315
    3      1_1 -1.6895906
    4      2_1  0.6660679
    
    --------------------------------------------------------------------------------"""))
])

problem_066 = Problem("problem_066", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""      Which Color Response Count
    1   Control   Red        2    10
    2   Control  Blue        3    20
    3 Treatment   Red        1    14
    4 Treatment  Blue        4    21""")
        ), MorpheusTable(raw"""  Color Count_Control Count_Treatment Response_Control Response_Treatment
    1  Blue            20              21                3                  4
    2   Red            10              14                2                  1
    
    --------------------------------------------------------------------------------"""))
])

problem_067 = Problem("problem_067", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id       time      Q1.1        Q1.2       Q2.1       Q2.2
    1  1 2009-01-01 0.4874289 -0.01618826  1.5271807 -0.2917768
    2  2 2009-01-02 0.7383247  0.94383621 -0.4038005 -1.1981381""")
        ), MorpheusTable(raw"""  id       time          Q1         Q2
    1  1 2009-01-01  0.48742885  1.5271807
    2  1 2009-01-01 -0.01618826 -0.2917768
    3  2 2009-01-02  0.73832471 -0.4038005
    4  2 2009-01-02  0.94383621 -1.1981381
    
    --------------------------------------------------------------------------------"""))
])

problem_068 = Problem("problem_068", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""     x y value.1 value.2
    1  red a       1      13
    2  red b       2      14
    3  red c       3      15
    4  red d       4      16
    5 blue a       5      17
    6 blue b       6      18
    7 blue c       7      19
    8 blue d       8      20""")
        ), MorpheusTable(raw"""     x value.1_a value.1_b value.1_c value.1_d value.2_a value.2_b value.2_c
    1 blue         5         6         7         8        17        18        19
    2  red         1         2         3         4        13        14        15
      value.2_d
    1        20
    2        16
    
    --------------------------------------------------------------------------------"""))
])

problem_069 = Problem("problem_069", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  obs year type
    1   1 2015    A
    2   2 2015    A
    3   3 2015    B
    4   4 2014    A
    5   5 2014    B
    6   6 2014    A
    7   7 2015    A""")
        ), MorpheusTable(raw"""  obs year type freq
    1   1 2015    A    3
    2   2 2015    A    3
    3   3 2015    B    1
    4   4 2014    A    3
    5   5 2014    B    1
    6   6 2014    A    3
    7   7 2015    A    3
    
    --------------------------------------------------------------------------------"""))
])

problem_070 = Problem("problem_070", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  x x2    y
    1 1  1 1.41
    2 1  1 1.39
    3 1  2 1.90
    4 1  2 2.10
    5 2  1 0.90
    6 2  1 1.10
    7 2  2 1.90
    8 2  2 2.10""")
        ), MorpheusTable(raw"""  x x2    y   a         z
    1 1  1 1.41 1.4 1.0071429
    2 1  1 1.39 1.4 0.9928571
    3 1  2 1.90 1.4 1.3571429
    4 1  2 2.10 1.4 1.5000000
    5 2  1 0.90 1.0 0.9000000
    6 2  1 1.10 1.0 1.1000000
    7 2  2 1.90 1.0 1.9000000
    8 2  2 2.10 1.0 2.1000000
    
    --------------------------------------------------------------------------------"""))
])

problem_071 = Problem("problem_071", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  id    dept employee salary
    1  1      CS   Yossi   21000
    2  2      EE    Pitt   23400
    3  3   Civil   Deepak  26800
    4  4 Physics    Golan  91000""")
        ), MorpheusTable(raw"""   mean
    1 58900
    
    --------------------------------------------------------------------------------"""))
])

problem_072 = Problem("problem_072", [
    IOExample(Dict{Symbol,Any}(
            :_arg_1 => MorpheusTable(raw"""  order_id Prod1 prod2 Prod3 Prod4 Prod5
    1        A     1     0     1     1     1
    2        B     0     0     1     1     0
    3        C     1     1     0     1     1""")
        ), MorpheusTable(raw"""   order_id   var
    1         A Prod1
    2         C Prod1
    3         C prod2
    4         A Prod3
    5         B Prod3
    6         A Prod4
    7         B Prod4
    8         C Prod4
    9         A Prod5
    10        C Prod5
    
    --------------------------------------------------------------------------------"""))
])


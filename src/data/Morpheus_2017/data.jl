problem_1 = Problem("problem_1", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :nam => ["foo 0.1691", "foo 0.1857", "bar 0.1241", "bar 0.0325"],
            :round => ["round1", "round2", "round1", "round2"],
            :val => ["2201", "0826", "0581", "8235"],
            :var1 => ["22", "11", "22", "11"],
            :var2 => ["33", "44", "33", "44"]
            ))
    ), 
    DataFrame(Dict(
        :nam => ["bar", "foo"],
        :val_round1 => ["0.1241058", "0.1691220"],
        :val_round2 => ["0.03258235", "0.18570826"],
        :var1_round1 => ["22", "22"],
        :var1_round2 => ["11", "11"],
        :var2_round1 => ["33", "33"],
        :var2_round2 => ["44", "44"]
        )))
])

problem_2 = Problem("problem_2", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :A => ["", "", "", "", "", ""],
            :B => ["", "", "", "", "", ""],
            :month => ["1", "2", "3", "1", "2", "3"],
            :student => ["Amy 9 6", "Amy 7 7", "Amy 6 8", "Bob 8 5", "Bob 6 6", "Bob 9 7"]
            ))
    ), 
    DataFrame(Dict(
        :Amy_A => ["9", "7", "6"],
        :Amy_B => ["6", "7", "8"],
        :Bob_A => ["8", "6", "9"],
        :Bob_B => ["5", "6", "7"],
        :month => ["1", "2", "3"]
        )))
])

problem_3 = Problem("problem_3", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Person => ["greg  P", "greg Po", "sally", "sally P"],
            :Score1 => ["75", "86", "85", "80"],
            :Score2 => ["76", "85", "86", "78"],
            :Time => ["re", "st", "Pre", "ost"]
            ))
    ), 
    DataFrame(Dict(
        :Person => ["greg", "sally"],
        :Post_Score1 => ["86", "80"],
        :Post_Score2 => ["85", "78"],
        :Pre_Score1 => ["75", "85"],
        :Pre_Score2 => ["76", "86"]
        )))
])

problem_4 = Problem("problem_4", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :A => ["10", "0", "50", "13", "17", "17"],
            :B => ["", "", "", "", "", ""],
            :Year => ["007 5", "008 2", "009 3", "007 7", "008 5", "009 6"],
            :id => ["1 2", "1 2", "1 2", "2 2", "2 2", "2 2"]
            ))
    ), 
    DataFrame(Dict(
        :A_2007 => ["5", "7"],
        :A_2008 => ["2", "5"],
        :A_2009 => ["3", "6"],
        :B_2007 => ["10", "13"],
        :B_2008 => ["0", "17"],
        :B_2009 => ["50", "17"],
        :id => ["1", "2"]
        )))
])

problem_5 = Problem("problem_5", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ID => ["1 24.3", "2 23.4"],
            :P.1 => [".2 5", ".4 5"],
            :P.2 => [".5 4", ".7 3"],
            :Q.1 => [".5", ".2"],
            :T => ["10", "10"]
            ))
    ), 
    DataFrame(Dict(
        :Channel => ["1 24.3", "1 23.4", "2 24.3", "2 23.4", "1 24.3", "1 23.4"],
        :ID => ["1", "2", "1", "2", "1", "2"],
        :P => ["", "", "", "", "", ""],
        :T => ["10.2", "10.4", "5.5", "5.7", "4.5", "3.2"]
        )))
])

problem_6 = Problem("problem_6", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :D.1 => ["0.5 431", "0.3 169", "3.8 133"],
            :D.8 => ["7.7 409", "1.0 178", "1.5  81"],
            :GeneID => ["8876.5 51", "2120.8 48", "1266.6 21"],
            :T.1 => ["8.3 895", "4.6 247", "7.9  83"],
            :T.8 => ["2.4", "4.1", "4.1"]
            ))
    ), 
    DataFrame(Dict(
        :GeneID => ["1266.6", "1266.6", "2120.8", "2120.8", "8876.5", "8876.5"],
        :sum => ["5.3", "7.9", "1.3", "4.6", "8.2", "8.3"],
        :type => ["D 104", "T 133", "D 295", "T 169", "D 946", "T 431"]
        )))
])

problem_7 = Problem("problem_7", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :D.1 => ["50", "0  4"],
            :D.2 => ["6", "4"],
            :D.8 => ["", "1"],
            :GeneID => ["A2M  18", "ABL1  2"],
            :T.1 => ["2", "8"],
            :T.2 => ["A1", "8  C"]
            ))
    ), 
    DataFrame(Dict(
        :D => ["0 0", "6 0", "48", "8"],
        :GeneID => ["A2M", "A2M", "ABL1", "ABL1"],
        :Ratio => ["00", "33", "667", "000"],
        :T => [".36000", ".33333", "0.4166", "0.5000"],
        :pt.num => ["1 18 5", "2  2", "1 20", "2  4"]
        )))
])

problem_8 = Problem("problem_8", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Month => ["1", "2", "1", "2", "1", "2"],
            :Name => ["Aira", "Aira", "Ben", "Ben", "Cat", "Cat"],
            :Rate1 => ["12", "18", "53", "22", "22", "67"],
            :Rate2 => ["23", "73", "19", "87", "87", "43"]
            ))
    ), 
    DataFrame(Dict(
        :Name => ["Aira", "Ben 3", "Cat 4"],
        :avg1 => ["15.0", "7.5", "4.5"],
        :avg2 => ["48", "53", "65"]
        )))
])

problem_9 = Problem("problem_9", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :V1 => ["a", "a", "a", "a", "a", "a", "a", "a", "b", "b", "b", "b", "b", "b", "b", "b"],
            :V2 => ["1 Hig", "2 Hig", "3 Hig", "4 Hig", "1  Lo", "2  Lo", "3  Lo", "4  Lo", "1 Hig", "2 Hig", "3 Hig", "4 Hig", "1  Lo", "2  Lo", "3  Lo", "4  Lo"],
            :V3 => ["h -0.6264538", "h  0.1836433", "h -0.8356286", "h  1.5952808", "w  0.3295077", "w -0.8204683", "w  0.4874290", "w  0.7383247", "h  0.5757813", "h -0.3053883", "h  1.5117811", "h  0.3898432", "w -0.6212405", "w -2.2146998", "w  1.1249309", "w -0.0449336"],
            :V4 => ["1", "2", "1", "0", "7", "8", "5", "1", "5", "9", "7", "4", "8", "9", "2", "1"]
            ))
    ), 
    DataFrame(Dict(
        :Ratio => ["1807", "8274", "3595", "6764", "8251", "8915", "8880", "9831"],
        :V1 => ["a", "a", "a", "a", "b", "b", "b", "b"],
        :V2 => ["1 -1.901", "2 -0.223", "3 -1.714", "4  2.160", "1 -0.926", "2  0.137", "3  1.343", "4 -8.675"]
        )))
])

problem_10 = Problem("problem_10", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :date => ["2012-", "2012-", "2012-"],
            :days => ["06-12  1.0      Intr", "07-13  6.0 Stats Win", "08-04  0.5         T"],
            :name => ["o to stats p", "ter school", "idyR tools"],
            :topics => ["robability|R", "R|regression", "tidyR|dplyr"]
            ))
    ), 
    DataFrame(Dict(
        :date => ["2012-", "2012-", "2012-", "2012-", "2012-", "2012-"],
        :days => ["06-12  1.0      Intr", "07-13  6.0 Stats Win", "08-04  0.5         T", "06-12  1.0      Intr", "07-13  6.0 Stats Win", "08-04  0.5         T"],
        :name => ["o to stats", "ter school", "idyR tools", "o to stats", "ter school", "idyR tools"],
        :value2 => ["probability", "R", "tidyR", "R", "regression", "dplyr"]
        )))
])

problem_11 = Problem("problem_11", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :expr => ["base__1d4", "base__1d4", "base__1d5", "base__1d5", "dplyr_1d4", "dplyr_1d4", "dplyr_1d5", "dplyr_1d5"],
            :time => ["4203379", "4219165", "59249811", "59249833", "4911550", "4911533", "72271322", "63373463"]
            ))
    ), 
    DataFrame(Dict(
        :base => ["272  491", "822 6782"],
        :dplyr => ["1542 0.857", "2392 0.873"],
        :ratio => ["4237", "6027"],
        :size => ["1d4  4211", "1d5 59249"]
        )))
])

problem_12 = Problem("problem_12", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :dest => ["IA", "N", "L", "RD", "L", "AD", "", "D", "", "A", "EA"],
            :flight => ["1141", "725", "461", "1696", "507", "5708", "79    J", "301", "11    E", "495", "1670"],
            :origin => ["JFK  M", "JFK  BQ", "LGA  AT", "EWR  O", "EWR  FL", "LGA  I", "FK  MCO", "LGA  OR", "WR  SEA", "JFK  SE", "EWR  S"]
            ))
    ), 
    DataFrame(Dict(
        :freq => ["7", "3"],
        :n => [".666666", ".333333"],
        :origin => ["EWR 2 0", "JFK 1 0"]
        )))
])

problem_13 = Problem("problem_13", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :amount => ["100", "95", "300", "250"],
            :id => ["20  in", "20 exp", "30  in", "30 exp"],
            :transactions => ["20", "25", "50", "45"],
            :type => ["come", "ense", "come", "ense"]
            ))
    ), 
    DataFrame(Dict(
        :expense_amount => ["95", "250"],
        :expense_transactions => ["25", "45"],
        :id => ["20", "30"],
        :income_amount => ["100", "300"],
        :income_transactions => ["20", "50"]
        )))
])

problem_14 = Problem("problem_14", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Diagnosis_1 => ["1", "1", "1", "0", "0", "0", "0", "0", "0", "0"],
            :Diagnosis_2 => ["0", "0", "0", "1", "0", "1", "0", "0", "1", "0"],
            :Diagnosis_3 => ["0", "0", "0", "0", "0", "0", "0", "1", "0", "1"],
            :Diagnosis_4 => ["0", "0", "0", "0", "1", "0", "1", "0", "0", "0"],
            :ID => ["A", "A", "A", "B", "C", "C", "D", "E", "E", "E"]
            ))
    ), 
    DataFrame(Dict(
        :ID => ["A", "A", "A", "B", "C", "E", "E", "E", "C", "D"],
        :value => ["1", "1", "1", "2", "2", "2", "3", "3", "4", "4"]
        )))
])

problem_15 = Problem("problem_15", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Error1_Group1 => ["4     60", "6     90"],
            :Error2_Group1 => ["14", "16"],
            :Group1 => ["", ""],
            :Group2 => ["", ""],
            :Timepoint => ["7     60", "14     66"]
            ))
    ), 
    DataFrame(Dict(
        :Error1 => ["roup1", "Group1"],
        :Error2 => ["", ""],
        :Group1 => ["60", "90"],
        :Group2 => ["4 G", "6"],
        :Timepoint => ["7     60", "14     66"],
        :mGroup => ["14", "16"]
        )))
])

problem_16 = Problem("problem_16", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Color => ["red Outd", "red  Ind", "red  Ind", "red Outd", "llow Outd"],
            :ID => ["1", "2", "7", "8", "9 ye"],
            :Type => ["oor  74.2", "oor  78.5", "oor  38.4", "oor 140.6", "oor  65.9"],
            :W1 => ["2  26.8", "9 138.8", "1  84.8", "8  93.3", "5 104.3"],
            :W2 => ["6", "0", "1", "3", "1"]
            ))
    ), 
    DataFrame(Dict(
        :Color => ["red", "yellow"],
        :sumCount => ["3", "1"],
        :sumMean => ["3", "1"]
        )))
])

problem_17 = Problem("problem_17", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Group => ["A g", "A g", "A", "B g", "B g", "B"],
            :Id => ["1", "2", "3", "4", "5", "6"],
            :Var1 => ["ood", "ood", "bad", "ood", "ood", "bad"],
            :Var2 => ["10", "6", "9", "3", "3", "8"]
            ))
    ), 
    DataFrame(Dict(
        :Group => ["A   9"],
        :bad => ["16"],
        :good => [""]
        )))
])

problem_18 = Problem("problem_18", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :message.id => ["1      A", "1      A", "2      A", "3      B", "3      C", "3      D"],
            :recipient => ["", "", "", "", "", ""],
            :sender => ["A", "C", "B", "C", "D", "B"]
            ))
    ), 
    DataFrame(Dict(
        :address => ["A", "B", "C", "D"],
        :recipient => ["1      3", "2      1", "2      1", "1      1"],
        :sender => ["", "", "", ""]
        )))
])

problem_19 = Problem("problem_19", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :12:10 => ["nuclear", "nuclear", "child", "child", "child", "nuclear and acquaintance", "nuclear and acquaintance", "notnotnot", "nuclear"],
            :12:20 => ["nuclear", "nuclear", "child", "child", "child", "nuclear and acquaintance", "nuclear and acquaintance", "notnotnot", "nuclear"],
            :12:30 => ["nuclear", "child", "child", "child", "child", "nuclear and acquaintance", "nuclear and acquaintance", "notnotnot", "nuclear"]
            ))
    ), 
    DataFrame(Dict(
        :12:10 => ["3", "not", "r", "r and"],
        :12:20 => ["3", "1", "3", "acquai"],
        :12:30 => ["4", "1     1", "3     2", "ntance     2     2     2"],
        :value => ["child", "notnot", "nuclea", "nuclea"]
        )))
])

problem_20 = Problem("problem_20", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :action_rate => ["0.10", "0.15", "0.20", "0.18"],
            :action_rate2 => ["0.20", "0.25", "0.30", "0.28"],
            :group => ["a befor", "a  afte", "b befor", "b  afte"],
            :times => ["e", "r", "e", "r"]
            ))
    ), 
    DataFrame(Dict(
        :action_rate2_after => ["0.25", "0.28", "", "", ""],
        :action_rate_after => ["0.15", "0.18", "on_rate2_before", "", ""],
        :action_rate_before => ["0.1", "0.2", "", "", ""],
        :group => ["a", "b", "acti", "0.2", "0.3"]
        )))
])

problem_21 = Problem("problem_21", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :obs => ["1", "2", "3", "4"],
            :post.data1 => ["0.12", "0.05", "0.85", "0.29"],
            :post.data2 => ["0.15", "0.49", "0.62", "0.56"],
            :pre.data1 => ["0.40", "0.21", "0.48", "0.66"],
            :pre.data2 => ["0.61", "0.18", "0.00", "0.88"]
            ))
    ), 
    DataFrame(Dict(
        :data1 => [".12  0", ".40  0", ".05  0", ".21  0", ".85  0", ".48  0", ".29  0", ".66  0"],
        :data2 => [".15", ".61", ".49", ".18", ".62", ".00", ".56", ".88"],
        :key => ["t  0", "e  0", "t  0", "e  0", "t  0", "e  0", "t  0", "e  0"],
        :obs => ["1 pos", "1  pr", "2 pos", "2  pr", "3 pos", "3  pr", "4 pos", "4  pr"]
        )))
])

problem_22 = Problem("problem_22", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Passes => ["6", "101", "91", "15"],
            :Player => ["Abdoun Alg", "Abe   Japa", "Abidal  Fr", "Abreu Urug"],
            :Shots => ["0", "3", "0", "5"],
            :Tackles => ["0", "14", "6", "0"],
            :Team => ["eria", "n", "ance", "uay"]
            ))
    ), 
    DataFrame(Dict(
        :Mean => ["s 53.25", "es  5.00"],
        :Var => ["Passe", "Tackl"]
        )))
])

problem_23 = Problem("problem_23", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :X1 => ["49.75", "49.75", "9.95"],
            :X2 => ["146.70", "39.80", "44.95"],
            :X3 => ["", "", ""],
            :custno => ["100  29.85", "100 122.70", "100   0.00"]
            ))
    ), 
    DataFrame(Dict(
        :custno => ["100"],
        :totalspent => ["493.45"]
        )))
])

problem_24 = Problem("problem_24", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :id => ["1 10", "2 10", "3 10", "4 10"],
            :var => ["r3", "r2", "r1", "r4"],
            :yr1 => ["90 20", "26 20", "36 20", "56 20"],
            :yr2 => ["66 30", "62 30", "06 30", "20 30"],
            :yr3 => ["50 40", "71 40", "98 40", "37 40"],
            :yr4 => ["12 y", "26 y", "38 y", "01 y"]
            ))
    ), 
    DataFrame(Dict(
        :id => ["1 y", "1 y", "1 y", "2 y", "2 y", "2 y", "3 y", "3 y", "3 y", "4 y", "4 y", "4 y"],
        :value => ["2066", "3050", "4012", "2062", "3071", "4026", "2006", "3098", "4038", "2020", "3037", "4001"],
        :var => ["r3", "r3", "r3", "r2", "r2", "r2", "r1", "r1", "r1", "r4", "r4", "r4"]
        )))
])

problem_25 = Problem("problem_25", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :a => ["1", "1", "4", "4", "1", "1"],
            :b => ["1", "2", "3", "3", "2", "2"]
            ))
    ), 
    DataFrame(Dict(
        :e => ["", ""],
        :key_ab => ["1_2 3", "4_3 2"]
        )))
])

problem_26 = Problem("problem_26", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :X1 => ["0", "5", "0", "0"],
            :X2 => ["0", "0", "0", "0"],
            :X3 => ["", "", "", ""],
            :frame => ["1  0", "2 10 1", "3 15 1", "4 15 1"]
            )),
        :_arg_2 => DataFrame(Dict(
            :X1 => ["0.00", "2.57", "4.65", "4.70"],
            :X2 => ["0", "0", "0", "0"],
            :X3 => ["", "", "", ""],
            :frame => ["1  0.00", "2 14.53 1", "3 13.90 1", "4 14.10 1"]
            ))
    ), 
    DataFrame(Dict(
        :carid => ["0 14.5", "0 14.6", "0 14.7", "5 12.5", "5 13.9", "5 14.1"],
        :frame => ["2  X1", "3  X2", "4  X2", "2  X2", "3  X1", "4  X1"],
        :pos => ["1", "1", "1", "1", "1", "1"],
        :speed => ["3", "5", "0", "7", "0", "0"]
        )))
])

problem_27 = Problem("problem_27", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :clnt => ["5 6.91", "6 5.11", "1 7.47", "4 7.34", "5 9.41"],
            :id => ["1", "3", "4", "2", "5"],
            :order => ["2931", "9676", "2010", "5583", "2050"],
            :prod => ["8", "2", "7", "8", "8"]
            )),
        :_arg_2 => DataFrame(Dict(
            :clnt => ["6 5.11", "5 9.41"],
            :id => ["3", "5"],
            :order => ["9676", "2050"],
            :prod => ["2", "8"]
            ))
    ), 
    DataFrame(Dict(
        :clnt => ["6   5", "5   8"],
        :mean.order => [".119676", ".162491"],
        :prod => ["2", "8"]
        )))
])

problem_28 = Problem("problem_28", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ID => ["1 Ca", "2 Ca", "3 Ca", "1 Em", "2 Em", "3 Em", "1 Rh", "2 Rh", "3 Rh"],
            :Species => ["llvulg", "llvulg", "llvulg", "penigr 1", "penigr", "penigr", "odtome", "odtome", "odtome"],
            :Value => ["0.55", "0.67", "0.10", "1.13", "0.17", "1.55", "0.17", "1.55", "3.00"]
            )),
        :_arg_2 => DataFrame(Dict(
            :Attribute => ["MI", "MI", "PI"],
            :Species => ["Callvulg", "Empenigr", "Rhodtome"]
            ))
    ), 
    DataFrame(Dict(
        :ID => ["1 1", "2", "3"],
        :Total => ["1.68", "0.84", "1.65"]
        )))
])

problem_29 = Problem("problem_29", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :a1 => ["2", "2", "2", "1", "1", "1"],
            :a2 => ["1", "2", "3", "4", "5", "6"],
            :b1 => ["1", "2", "3", "4", "5", "6"],
            :b2 => ["", "", "", "", "", ""],
            :sym => ["a  1", "a  2", "a  1", "b  2", "b  1", "b  2"]
            ))
    ), 
    DataFrame(Dict(
        :a1 => ["", "", "", ""],
        :a2 => ["", "", "", ""],
        :b1.mean => ["2  2", "2  2", "5  1", "5  1"],
        :b2.mean => ["2", "2", "5", "5"],
        :sym => ["a  1", "a  2", "b  1", "b  2"]
        )))
])

problem_30 = Problem("problem_30", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :A.SD => ["6375", "6830", "7325"],
            :A.measure => ["7803  9124563", "0326 21975533", "5662  9864019"],
            :B.SD => ["10351", "6507", "9268"],
            :B.measure => ["2981 34800000", "3447 22600000", "0794  6090000"],
            :C.SD => ["", "", ""],
            :C.measure => ["2032 23900000", "4191 20800000", "6983 38300000"],
            :Factor => ["K  5212", "L  6341", "M  7645"]
            ))
    ), 
    DataFrame(Dict(
        :Factor => ["K", "K", "K", "L", "L", "L", "M", "M", "M"],
        :SD => ["", "", "", "", "", "", "", "", ""],
        :measure => ["03  9124563", "81 34800000", "32 23900000", "26 21975533", "47 22600000", "91 20800000", "62  9864019", "94  6090000", "83 38300000"],
        :measure_letter => ["A  521278", "B  637529", "C 1035120", "A  634103", "B  683034", "C  650741", "A  764556", "B  732507", "C  926869"]
        )))
])

problem_31 = Problem("problem_31", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :a => ["1", "2", "3"],
            :b => ["2", "2", "2"],
            :c => ["3", "3", "3"],
            :id => ["101", "102", "103"]
            ))
    ), 
    DataFrame(Dict(
        :a => ["1", "2", "3"],
        :b => ["2", "2", "2"],
        :c => ["3", "3", "3"],
        :id => ["101 2.0", "102 2.3", "103 2.6"],
        :mean => ["00000", "33333", "66667"]
        )))
])

problem_32 = Problem("problem_32", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :CA => ["27-13", "28-13", "29-13"],
            :DATE_1 => ["00:00:00", "08:00:00", "16:00:00"],
            :DATE_2 => ["08:00:00", "16:00:00", "00:00:00"],
            :ENTRIES_1 => ["603 07-27-13", "490 07-28-13", "586 07-30-13"],
            :ENTRIES_2 => ["663", "775", "845"],
            :TIME_1 => ["4209", "4210", "4211"],
            :TIME_2 => ["4209", "4210", "4212"],
            :rowname => ["1 A002 07-", "2 A002 07-", "3 A002 07-"]
            ))
    ), 
    DataFrame(Dict(
        :CA => ["A002 07", "A002 07", "A002 07", "A002 07", "A002 07", "A002 07"],
        :DATE => ["-27-1", "-27-1", "-28-1", "-28-1", "-29-1", "-30-1"],
        :ENTRIES => ["3 4209603 00", "3 4209663 08", "3 4210490 08", "3 4210775 16", "3 4211586 16", "3 4212845 00"],
        :TIME => [":00:00", ":00:00", ":00:00", ":00:00", ":00:00", ":00:00"]
        )))
])

problem_33 = Problem("problem_33", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :am_min => ["0", "", ""],
            :am_q25 => ["0", "", ""],
            :carb_min => ["1  15", "", ""],
            :cyl_min => ["4", "25 carb_", "2"],
            :cyl_q25 => ["4", "", ""],
            :gear_min => ["3", "", ""],
            :mpg_min => ["10.4", "gear_q", "3"],
            :mpg_q25 => [".425", "", ""],
            :vs_min => ["0", "q25", ""],
            :vs_q25 => ["0", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :min => [".0  0.0", "1.0  2", "4.0  4.", "3.0  3", "0.4 15.", ".0  0.0"],
        :q25 => ["00", ".000", "000", ".000", "425", "00"],
        :var => ["am  0", "carb", "cyl", "gear", "mpg 1", "vs  0"]
        )))
])

problem_34 = Problem("problem_34", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :mult => ["K", "M", "G"],
            :size => ["1", "2", "3"]
            )),
        :_arg_2 => DataFrame(Dict(
            :mult => ["K", "M", "G"],
            :value => ["230", "128", "420"]
            ))
    ), 
    DataFrame(Dict(
        :mult => ["K   2", "M", "G   1"],
        :size => ["1", "2", "3"],
        :total => ["30", "64", "40"]
        )))
])

problem_35 = Problem("problem_35", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :con1_1 => ["23", "25", "28"],
            :con1_2 => ["33", "34", "29"],
            :con2_1 => ["23", "22", "30"],
            :con2_2 => ["40", "50", "60"],
            :name1 => ["a", "b", "c"]
            ))
    ), 
    DataFrame(Dict(
        :con1 => ["31.5", "36.0", "45.0"],
        :con2 => ["", "", ""],
        :name1 => ["a 28.0", "b 29.5", "c 28.5"]
        )))
])

problem_36 = Problem("problem_36", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :am => ["15", "4", "8", "5"],
            :gear => ["3  0", "4  0", "4  1", "3  1"],
            :n => ["", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :0_n => ["0", "0"],
        :0_percent => [".46875   5", ".12500   8"],
        :1_n => ["0", "0"],
        :1_percent => [".15625", ".25000"],
        :gear => ["3  15", "4   4"]
        )))
])

problem_37 = Problem("problem_37", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :id => ["1", "2", "3", "4", "5", "6"],
            :response.1 => ["1", "1", "1", "1", "1", "1"],
            :response.2 => ["1", "1", "1", "1", "1", "1"],
            :sex => ["M", "M", "F", "M", "F", "M"],
            :trt.1 => ["A", "A", "A", "A", "A", "A"],
            :trt.2 => ["B", "B", "B", "B", "B", "B"]
            ))
    ), 
    DataFrame(Dict(
        :id => ["1", "1", "2", "2", "3", "3", "4", "4", "5", "5", "6", "6"],
        :number => ["1", "2", "1", "2", "1", "2", "1", "2", "1", "2", "1", "2"],
        :response => ["1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"],
        :sex => ["M", "M", "M", "M", "F", "F", "M", "M", "F", "F", "M", "M"],
        :trt => ["A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B"]
        )))
])

problem_38 = Problem("problem_38", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :x => ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
            )),
        :_arg_2 => DataFrame(Dict(
            :x => ["a  93.7354", "b 101.8364", "c  91.6437", "d 115.9528", "e 103.2950", "f  91.7953", "g 104.8742", "h 107.3832", "i 105.7578", "j  96.9461", "a 115.1178", "b 103.8984", "c  93.7875", "d  77.8530", "e 111.2493", "f  99.5506", "g  99.8381", "h 109.4383", "i 108.2122", "j 105.9390"],
            :z => ["6", "3", "1", "1", "8", "2", "9", "5", "1", "2", "1", "3", "9", "0", "1", "6", "0", "6", "1", "1"]
            ))
    ), 
    DataFrame(Dict(
        :x => ["a 208.853", "b 205.734", "c 185.431", "d 193.805", "e 214.544", "f 191.346", "g 204.712", "h 216.821", "i 213.970", "j 202.885"],
        :z => ["3", "9", "3", "8", "4", "0", "4", "6", "0", "1"]
        )))
])

problem_39 = Problem("problem_39", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :event_id => ["A      1", "B      2", "A      3", "A      4", "B      5"],
            :income => ["Place", "Place", "Place", "Place", "Place"],
            :location => ["X", "Y", "X", "X", "Y"]
            ))
    ), 
    DataFrame(Dict(
        :event_id => ["A 2.66666", "A 2.66666", "A 2.66666", "B 3.50000", "B 3.50000"],
        :income => ["Place", "Place", "Place", "Place", "Place"],
        :location => ["X", "X", "X", "Y", "Y"],
        :mean_inc => ["7      1", "7      3", "7      4", "0      2", "0      5"]
        )))
])

problem_40 = Problem("problem_40", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ID => ["ID1  hsa-miR", "ID1  hsa-miR", "ID1   hsa-mi", "ID1    hsa-m", "ID1   hsa-mi", "ID1  hsa-miR", "ID1   hsa-mi", "ID1   hsa-mi", "ID2    hsa-m", "ID2   hsa-mi", "ID2 hsa-miR-", "ID2    hsa-m", "ID2   hsa-mi", "ID2 hsa-miR-", "ID2    hsa-m", "ID2 hsa-miR-", "ID2 hsa-miR-", "ID24   hsa-m", "ID24    hsa-", "ID24   hsa-m", "ID25    hsa-", "ID25   hsa-m"],
            :miRNA => ["-512-1", "-512-2", "R-1323", "iR-498", "R-520e", "-515-1", "R-519e", "R-520f", "iR-495", "R-376c", "376a-2", "iR-654", "R-376b", "376a-1", "iR-300", "1185-1", "1185-2", "iR-1179", "miR-7-2", "iR-3677", "miR-940", "iR-4717"]
            )),
        :_arg_2 => DataFrame(Dict(
            :logFC => ["R-512-1  13.0", "R-512-2 123.0", "R-1323  53.0", "R-498   4.2", "R-520e  12.0", "R-515-1   1.0", "R-519e  56.0", "R-520f 113.0", "R-495  11.0", "R-376c  11.0", "R-376a-2 113.0", "R-654  13.0", "R-376b 123.0", "R-376a-1 567.0", "R-300 757.0", "R-1185-1   6.0", "R-1185-2  35.0", "R-1179   2.0", "R-7-2   2.0", "R-3677   1.0", "R-940 134.0", "R-4717 566.0"],
            :miRNA => ["hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi", "hsa-mi"]
            ))
    ), 
    DataFrame(Dict(
        :AvgLogFC => ["46.900000", "81.777778", "1.666667", "350.000000"],
        :ID => ["ID1", "ID2 1", "ID24", "ID25"]
        )))
])

problem_41 = Problem("problem_41", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :row => ["", "", "", "", "", ""],
            :test1_rater1 => ["1", "3", "2", "3", "4", "3"],
            :test1_rater2 => ["2", "3", "4", "1", "2", "1"],
            :test2_rater1 => ["1", "3", "3", "2", "3", "1"],
            :test2_rater2 => ["1   1", "3   3", "4   4", "3   5", "4   6", "3  10"]
            ))
    ), 
    DataFrame(Dict(
        :rater1 => ["1", "1", "3", "3", "2", "3", "3", "2", "4", "3", "3", "1"],
        :rater2 => ["2", "1", "3", "3", "4", "4", "1", "3", "2", "4", "1", "3"],
        :row => ["1 tes", "1 tes", "3 tes", "3 tes", "4 tes", "4 tes", "5 tes", "5 tes", "6 tes", "6 tes", "10 te", "10 te"],
        :test => ["t1", "t2", "t1", "t2", "t1", "t2", "t1", "t2", "t1", "t2", "st1", "st2"]
        )))
])

problem_42 = Problem("problem_42", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ADC => ["", "", "", "", "", ""],
            :Exposure => ["0.01  185", "0.03  210", "0.01  218", "0.03  249", "0.01  258", "0.03  292"],
            :Noise => ["4   1", "3   4", "6   1", "9   4", "8   1", "6   4"],
            :Signal => [".0 0.674", ".2 0.768", ".2 0.835", ".5 0.860", ".4 0.898", ".7 0.832"],
            :ill => ["12", "12", "10", "10", "9", "9"]
            )),
        :_arg_2 => DataFrame(Dict(
            :factor => ["1.0", "3.0", "11.5"],
            :ill => ["1", "4", "10"]
            ))
    ), 
    DataFrame(Dict(
        :ADC => ["12", "12", "10", "10", "9", "9"],
        :ExposureNew => ["0.01", "0.01", "0.01", "0.01", "0.01", "0.01"],
        :Noise => ["6744", "7683", "8356", "8609", "8988", "8326"],
        :Signal => ["185.0 0.", "210.2 0.", "218.2 0.", "249.5 0.", "258.4 0.", "292.7 0."],
        :ill => ["1", "4", "1", "4", "1", "4"]
        )))
])

problem_43 = Problem("problem_43", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :D.Average => ["760      8", "300     11", "500      7", "200      9", "B.SD", "46", "57", "83", "48"],
            :D.SD => ["924.2742", "308.2661", "308.0389", "514.2177", "", "", "", "", ""],
            :Day => ["0.00", "1.90", "3.00", "4.00", "", "1120", "3581", "4338", "4362"],
            :HL.Average => ["000       8", "625      13", "000      14", "000      16", "LL.SD noHK", ".785 1592.6", ".763 1031.0", ".897 1793.5", ".261 2691.6"],
            :HL.SD => ["2337.844", "1016.291 2", "2945.098 1", "1006.893", "", "", "", "", ""],
            :LL.Average => ["900      10", "900      12", "320      12", "160      15", "", "", "", "", ""],
            :noHKB.Average => ["000          8030", "100          3860", "300          1750", "100          2710", "", "", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :Average => ["D    8900  92", "HL    8760 233", "LL   10000 112", "HKB    8030 159", "D   11900 230", "HL   13300 101", "LL   12100 358", "HKB    3860 103", "D    7320 130", "HL   14500 294", "LL   12300 433", "HKB    1750 179", "D    9160  51", "HL   16200 100", "LL   15100 436", "HKB    2710 269"],
        :Day => ["0.00", "0.00", "0.00", "0.00", "1.90", "1.90", "1.90", "1.90", "3.00", "3.00", "3.00", "3.00", "4.00", "4.00", "4.00", "4.00"],
        :Group => ["000", "000", "000", "000 no", "625", "625", "625", "625 no", "000", "000", "000", "000 no", "000", "000", "000", "000 no"],
        :SD => ["4.2742", "7.8440", "0.7850", "2.6460", "8.2661", "6.2910", "1.7630", "1.0570", "8.0389", "5.0980", "8.8970", "3.5830", "4.2177", "6.8930", "2.2610", "1.6480"]
        )))
])

problem_44 = Problem("problem_44", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :blabla => ["bA", "bB", "bC", "bD"],
            :f1.avg => ["10", "12", "20", "22"],
            :f1.sd => ["6", "5", "7", "8"],
            :f2.avg => ["50", "70", "20", "22"],
            :f2.sd => ["10", "11", "8", "9"],
            :sbj => ["A", "B", "C", "D"]
            ))
    ), 
    DataFrame(Dict(
        :avg => ["0  6", "0 10", "2  5", "0 11", "0  7", "0  8", "2  8", "2  9"],
        :blabla => ["bA  f", "bA  f", "bB  f", "bB  f", "bC  f", "bC  f", "bD  f", "bD  f"],
        :sbj => ["A", "A", "B", "B", "C", "C", "D", "D"],
        :sd => ["", "", "", "", "", "", "", ""],
        :var => ["1  1", "2  5", "1  1", "2  7", "1  2", "2  2", "1  2", "2  2"]
        )))
])

problem_45 = Problem("problem_45", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :V1 => ["a", "a", "a", "x", "x"],
            :V2 => ["b", "b EM", "b EM", "y", "y EM"],
            :V3 => ["a EM", "P", "P EM", "h EM", "P"],
            :V4 => ["P EM", "c EM", "P", "P EM", "k"],
            :V5 => ["P", "P", "d", "P", "e"]
            ))
    ), 
    DataFrame(Dict(
        :V1 => ["a", "x"],
        :V2 => ["b", "y"],
        :V3 => ["a", "h"],
        :V4 => ["c", "k"],
        :V5 => ["d", "e"]
        )))
])

problem_46 = Problem("problem_46", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :V1 => ["6", "3", "1", "7"],
            :V2 => ["", "", "", ""],
            :group => ["g1 10", "g2 40", "g1 20", "g2 30"],
            :name => ["A", "A", "B", "B"]
            ))
    ), 
    DataFrame(Dict(
        :V1_g1 => ["10", "20"],
        :V1_g2 => ["40", "30"],
        :V2_g1 => ["6", "1"],
        :V2_g2 => ["3", "7"],
        :name => ["A", "B"]
        )))
])

problem_47 = Problem("problem_47", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :age_1 => ["r1", "r2", "r3"],
            :age_2 => ["20", "25", "32"],
            :favCol_1 => ["21     bl", "34      r", "33     bl"],
            :favCol_2 => ["ue      red", "ed     blue", "ue      red"],
            :id => ["use", "use", "use"]
            ))
    ), 
    DataFrame(Dict(
        :age => ["1", "2", "1", "2", "1", "2"],
        :favCol => ["20   blue", "21    red", "25    red", "34   blue", "32   blue", "33    red"],
        :id => ["use", "use", "use", "use", "use", "use"],
        :panel => ["r1", "r1", "r2", "r2", "r3", "r3"]
        )))
])

problem_48 = Problem("problem_48", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :day => ["1", "2", "3", "4", "5", "6", "1", "2", "3", "4", "5", "6"],
            :site => ["a", "a", "a", "a", "a", "a", "b", "b", "b", "b", "b", "b"],
            :value.1 => ["1", "2", "5", "7", "5", "3", "9", "4", "2", "8", "1", "8"],
            :value.2 => ["5", "4", "7", "6", "2", "4", "6", "9", "4", "2", "5", "6"]
            ))
    ), 
    DataFrame(Dict(
        :a_value.1 => ["1", "2", "5", "7", "5", "3"],
        :a_value.2 => ["5", "4", "7", "6", "2", "4"],
        :b_value.1 => ["9", "4", "2", "8", "1", "8"],
        :b_value.2 => ["6", "9", "4", "2", "5", "6"],
        :day => ["1", "2", "3", "4", "5", "6"]
        )))
])

problem_49 = Problem("problem_49", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Scenario => ["base  -3.", "stress  -", "extreme"],
            :x_max => ["2  -1.", "1  -", "3"],
            :x_mean => ["00", "0.25", "1.00"],
            :x_min => ["0   0.", "2.0", "-2.5"],
            :y_max => ["0", "3.0", "3.5"],
            :y_mean => ["1   5.", "2", "3"],
            :y_min => ["5", "2.0", "-3.0"],
            :z_max => ["2", "4", "7"],
            :z_mean => ["25", "2.00", "5.00"],
            :z_min => ["0   0.", "1", "3"]
            ))
    ), 
    DataFrame(Dict(
        :Scenario => ["base", "base", "base", "extreme", "extreme", "extreme", "stress", "stress", "stress"],
        :max => ["0.00", "1.00", "0.25", ".0 1", ".5 3", ".0 5", "0 0.", "0 2.", "0 2."],
        :mean => ["-3.0", "-1.5", "0.0", ".00 -2", ".00 -3", ".00  3", "25 -2.", "00 -2.", "00  1."],
        :min => ["", "", "", ".5", ".0", ".0", "0", "0", "0"],
        :varNew => ["x 2.0", "y 5.0", "z 2.0", "x 3", "y 3", "z 7", "x 1.", "y 3.", "z 4."]
        )))
])

problem_50 = Problem("problem_50", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :MemberID => ["123    Y1", "123    Y2", "234    Y1", "234    Y2"],
            :a => ["0", "0", "1", "0"],
            :b => ["", "", "", ""],
            :c => ["", "", "", ""],
            :d => ["", "", "", ""],
            :years => ["0 0 1", "0 0 1", "1 0 0", "0 1 0"]
            ))
    ), 
    DataFrame(Dict(
        :MemberID => ["123    0", "234    1"],
        :Y1_a => ["0", "0"],
        :Y1_b => ["1", "0"],
        :Y1_c => ["0", "1"],
        :Y1_d => ["0", "0"],
        :Y2_a => ["0", "1"],
        :Y2_b => ["1", "0"],
        :Y2_c => ["0", "0"],
        :Y2_d => ["", ""]
        )))
])

problem_51 = Problem("problem_51", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Geotype => ["A     Dema", "A Strategy", "A Strategy", "B     Dema", "B Strategy", "B Strategy"],
            :Strategy => ["nd      1", "_1      2", "_2      3", "nd      8", "_1      9", "_2     10"],
            :Year.1 => ["5", "6", "7", "8", "9", "10"],
            :Year.2 => ["", "", "", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :Geotype => ["A Year.1", "A Year.2", "B Year.1", "B Year.2"],
        :key => ["5", "13", "19", "19"],
        :sumVal => ["", "", "", ""]
        )))
])

problem_52 = Problem("problem_52", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Geotype => ["A     Dema", "A Strategy", "A Strategy", "B     Dema", "B Strategy", "B Strategy"],
            :Strategy => ["nd      1", "_1      2", "_2      3", "nd      8", "_1      9", "_2     10"],
            :Year.1 => ["5", "6", "7", "8", "9", "10"],
            :Year.2 => ["", "", "", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :Geotype => ["A      5", "B     19"],
        :Year.1 => ["13", "19"],
        :Year.2 => ["", ""]
        )))
])

problem_53 = Problem("problem_53", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :EE => ["00", "99", "67", "78", "76", "88", "34", "99"],
            :HR => ["02 1", "99", "98", "97", "11", "100", "78", "99"],
            :a => ["3", "4", "5", "3", "5", "4", "4", "2"],
            :code => ["A03 1", "A03", "A03", "A03", "B01 1", "B01", "B01", "B01"],
            :posture => ["cycling", "standing", "sitting", "walking", "cycling", "standing", "sitting", "walking"]
            ))
    ), 
    DataFrame(Dict(
        :code => ["A03", "B01", "sta", "4", "4"],
        :cycling_EE => ["100", "76", "anding_EE s", "99", "100"],
        :cycling_HR => ["102", "111", "tanding_HR", "3", "2"],
        :cycling_a => ["3", "5", "nding_a st", "99", "88"],
        :sitting_EE => ["67", "34", "walking_EE", "97", "99"],
        :sitting_HR => ["98", "78", "walking_HR", "", ""],
        :sitting_a => ["5", "4", "walking_a", "78", "99"]
        )))
])

problem_54 = Problem("problem_54", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :TOT => ["p", "p", "p", "p", "p", "p", "p", "p", "p"],
            :inf_status => ["ositive", "ositive", "ositive", "ositive", "ositive", "ositive", "ositive", "ositive", "ositive"],
            :sample_ID => ["382870 site_", "487405 site_", "487405 site_", "487405 site_", "382899 site_", "382899 site_", "382899 site_", "382899 site_", "382899 site_"],
            :site => ["1 Speci", "2 Speci", "2 Speci", "2 Speci", "1 Speci", "1 Speci", "2 Speci", "1 Speci", "2 Speci"],
            :species => ["es_B   1", "es_A   1", "es_B   1", "es_A   1", "es_A   1", "es_C   1", "es_C  10", "es_D   1", "es_D  20"]
            ))
    ), 
    DataFrame(Dict(
        :Species_A_positive => ["1", "2", "cies_D_positive", "", ""],
        :Species_B_positive => ["1", "2", "", "", ""],
        :Species_C_positive => ["1                  1", "1                 10", "", "", ""],
        :site => ["site_", "site_", "Spe", "1", "20"]
        )))
])

problem_55 = Problem("problem_55", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ID => ["C", "D", "E", "F", "G"],
            :c_Al => ["0", "1", "0", "0", "1"],
            :c_D => ["0", "0", "0", "1", "1"],
            :c_Hy => ["1 25", "1 19", "1 27", "0 27", "0 15"],
            :occ => ["81", "17", "08", "51", "22"]
            ))
    ), 
    DataFrame(Dict(
        :0 => [".0 1719", "0 2136.", ".5 2402"],
        :1 => [".5", "5", ".0"],
        :Var => ["c_Al 2680", "c_D 2402.", "c_Hy 2136"]
        )))
])

problem_56 = Problem("problem_56", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :BMI => ["", "", "_BAF", "", ""],
            :sample => ["AA 18.9", "BB 27.1", "var200", "0.99", "0.99"],
            :var1_BAF => ["0.99", "1.00", "", "", ""],
            :var1_LRR => ["0.27", "0.23", "", "", ""],
            :var200_LRR => ["0.20", "0.23", "", "", ""],
            :var2_BAF => ["0.99", "0.99", "", "", ""],
            :var2_LRR => ["0.18", "0.13", "", "", ""],
            :var3_BAF => ["1", "1", "", "", ""],
            :var3_LRR => ["0.11", "0.17", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :BAF => ["0.27", "0.18", "0.20", "0.11", "0.23", "0.13", "0.23", "0.17"],
        :BMI => ["va", "va", "var2", "va", "va", "va", "var2", "va"],
        :LRR => ["", "", "", "", "", "", "", ""],
        :sample => ["AA 18.9", "AA 18.9", "AA 18.9", "AA 18.9", "BB 27.1", "BB 27.1", "BB 27.1", "BB 27.1"],
        :varNew => ["r1 0.99", "r2 0.99", "00 0.99", "r3 1.00", "r1 1.00", "r2 0.99", "00 0.99", "r3 1.00"]
        )))
])

problem_57 = Problem("problem_57", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Test => ["1", "2", "3", "4", "5", "6", "pre", "11.48", "7.680", "9.820", "13.81", "10.58", "7.205"],
            :pressure_sensor1 => ["11.346620", "11.798325", "11.479349", "8.250279", "9.926986", "11.575317", "", "", "", "", "", "", ""],
            :temperature_sensor1 => ["22.51868", "20.69246", "33.94608", "24.10963", "26.50271", "27.10880", "ssure_sensor2", "9648", "483", "589", "0615", "2618", "214"],
            :temperature_sensor2 => ["24.23571", "22.53656", "20.24266", "26.41655", "28.55482", "31.80768", "", "", "", "", "", "", ""]
            ))
    ), 
    DataFrame(Dict(
        :Test => ["1 sens", "1 sens", "2 sens", "2 sens", "3 sens", "3 sens", "4 sens", "4 sens", "5 sens", "5 sens", "6 sens", "6 sens"],
        :pressure => ["46620", "89648", "98325", "80483", "79349", "20589", "50279", "10615", "26986", "82618", "75317", "05214"],
        :sensor => ["or1 11.3", "or2 11.4", "or1 11.7", "or2  7.6", "or1 11.4", "or2  9.8", "or1  8.2", "or2 13.8", "or1  9.9", "or2 10.5", "or1 11.5", "or2  7.2"],
        :temperature => ["22.51868", "24.23571", "20.69246", "22.53656", "33.94608", "20.24266", "24.10963", "26.41655", "26.50271", "28.55482", "27.10880", "31.80768"]
        )))
])

problem_58 = Problem("problem_58", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :ID => ["1", "2"],
            :c_2006 => ["37.1", "2.6"],
            :c_2008 => ["37.1", "2.6"],
            :c_2010 => ["37.3", "2.6"],
            :c_2012 => ["37.3", "2.6"],
            :p_2006 => ["165", "163"],
            :p_2008 => ["163", "164"],
            :p_2010 => ["162", "164"],
            :p_2012 => ["160", "163"]
            ))
    ), 
    DataFrame(Dict(
        :ID => ["1 2", "1 2", "1 2", "1 2", "2 2", "2 2", "2 2", "2 2"],
        :c => ["165", "163", "162", "160", "163", "164", "164", "163"],
        :p => ["", "", "", "", "", "", "", ""],
        :year => ["006 37.1", "008 37.1", "010 37.3", "012 37.3", "006  2.6", "008  2.6", "010  2.6", "012  2.6"]
        )))
])

problem_59 = Problem("problem_59", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :V2 => ["CCRG10 Bran", "CCRG10  Cac", "CCRG20 Bran", "CCRG20  Cac", "CCRG30 Bran", "CCRG30  Cac", "CCRG40 Bran", "CCRG40  Cac", "CCRG50 Bran", "CCRG50  Cac"],
            :V3 => ["chD", "heD", "chD", "heD", "chD", "heD", "chD", "heD", "chD", "heD"],
            :V4 => ["BMS  2", "BMS  3", "BMS  7", "BMS  2", "BMS 15", "BMS  5", "BMS 62", "BMS  7", "BMS 58", "BMS 11"]
            ))
    ), 
    DataFrame(Dict(
        :V2 => ["CCRG10 Bra", "CCRG20 Bra", "CCRG30 Bra", "CCRG40 Bra", "CCRG50 Bra", "CCRG10  Ca", "CCRG20  Ca", "CCRG30  Ca", "CCRG40  Ca", "CCRG50  Ca", "CCRG10", "CCRG20", "CCRG30", "CCRG40", "CCRG50"],
        :key => ["nchDBMS", "nchDBMS", "nchDBMS 1", "nchDBMS 6", "nchDBMS 5", "cheDBMS", "cheDBMS", "cheDBMS", "cheDBMS", "cheDBMS 1", "wtimRes", "wtimRes", "wtimRes", "wtimRes", "wtimRes"],
        :value => ["2.0000000", "7.0000000", "5.0000000", "2.0000000", "8.0000000", "3.0000000", "2.0000000", "5.0000000", "7.0000000", "1.0000000", "0.6666667", "3.5000000", "3.0000000", "8.8571429", "5.2727273"]
        )))
])

problem_60 = Problem("problem_60", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Market => ["market_", "market_", "market_", "market_"],
            :Variables => ["1     var_", "1     var_", "2     var_", "2     var_"],
            :lower.limit => ["8        2.7", "1        2.9", "5        2.7", "1        1.9"],
            :median => ["1   2.7", "2   3.2", "1   2.9", "2   2.1"],
            :upper.limit => ["1        2.72", "6        3.44", "9        3.11", "1        2.30"]
            ))
    ), 
    DataFrame(Dict(
        :Market => ["market_", "market_", "var_2", "3.21", "2.11"],
        :var_1_lower.limit => ["1              2.7", "2              2.7", "_median var_2_uppe", "3.44", "2.30"],
        :var_1_median => ["1         2.7", "9         2.9", "r.limit", "", ""],
        :var_1_upper.limit => ["8              2.7", "5              3.1", "", "", ""],
        :var_2_lower.limit => ["2              2.96", "1              1.91", "", "", ""]
        )))
])

problem_61 = Problem("problem_61", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Clarity_1 => ["3", "2", "7", "4", "8"],
            :Clarity_2 => ["10", "3", "7", "2", "3"],
            :Clarity_3 => ["5", "6", "5", "2", "9"],
            :Effort_1 => ["5", "8", "10", "4", "8"],
            :Effort_2 => ["4", "1", "4", "9", "4"],
            :Effort_3 => ["7", "8", "2", "8", "5"],
            :roleInDebate => ["x", "y", "r", "q", "b"],
            :year => ["2006", "2009", "2013", "2020", "2004"]
            ))
    ), 
    DataFrame(Dict(
        :Clarity => ["8", "3", "9", "3", "10", "5", "2", "3", "6", "7", "7", "5", "4", "2", "2"],
        :Effort => ["8", "4", "5", "5", "4", "7", "8", "1", "8", "10", "4", "2", "4", "9", "8"],
        :person => ["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"],
        :roleInDebate => ["b", "b", "b", "x", "x", "x", "y", "y", "y", "r", "r", "r", "q", "q", "q"],
        :year => ["2004", "2004", "2004", "2006", "2006", "2006", "2009", "2009", "2009", "2013", "2013", "2013", "2020", "2020", "2020"]
        )))
])

problem_62 = Problem("problem_62", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :category => ["big", "big", "big", "big", "mall", "big", "big", "big", "big", "mall", "big", "big", "big", "big", "mall"],
            :group => ["a1", "1", "1", "1", "1    s", "2", "2", "2", "2", "2    s", "3", "3", "3", "3", "3    s"],
            :score => ["10", "8    a", "9    a", "1    a", "5    a", "8    a", "2    a", "8    a", "5    a", "6    a", "9    a", "4    a", "7    a", "9    a", "9    a"]
            ))
    ), 
    DataFrame(Dict(
        :group => ["a1 7.0", "a2 5.7", "a3 7.2"],
        :mean => ["0", "5", "5"]
        )))
])

problem_63 = Problem("problem_63", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Ans => ["", "", "", "", "", "", "", "", ""],
            :Category => ["Cat1 Q1.a-Some-Text", "Cat2 Q1.b-Some-Text", "Cat2 Q1.a-Some-Text", "Cat2 Q1.a-Some-Text", "Cat1 Q1.b-Some-Text", "Cat2 Q1.a-Some-Text", "Cat1 Q1.b-Some-Text", "Cat1 Q1.a-Some-Text", "Cat2 Q1.b-Some-Text"],
            :qs => ["1", "2", "2", "1", "1", "1", "2", "2", "1"]
            ))
    ), 
    DataFrame(Dict(
        :1 => ["Some", "Some"],
        :2 => ["-Text 0.6 0.4", "-Text 0.5 0.5"],
        :qs => ["Q1.a-", "Q1.b-"]
        )))
])

problem_64 = Problem("problem_64", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Rfips => ["42107 17", "51760 23", "44001  2", "34001  8", "51061 20", "50023  5", "36029 14", "42101 19", "37019 28"],
            :ST => ["PA", "VA", "RI", "NJ", "PA", "VT", "NY", "PA", "NC"],
            :Year => ["2010", "2005 4", "2010 2", "2008 3", "2007", "2006 4", "2005", "2008 3", "2009"],
            :dist.km => ["0.00000", "2.46894", "8.11234", "6.85470", "0.00000", "9.72765", "0.00000", "0.19372", "0.00000"],
            :zip => ["972", "226", "806", "330", "118", "681", "072", "115", "451"]
            ))
    ), 
    DataFrame(Dict(
        :ST => ["NC", "NY", "PA"],
        :total => ["1", "1", "2"]
        )))
])

problem_65 = Problem("problem_65", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :HEL.one => ["12", "12", "15"],
            :HEL.two => ["13.00", "-0.12", "4.00"],
            :ID => ["A", "B", "C"],
            :MGW.one => ["10.00", "-13.29", "-6.95"],
            :MGW.two => ["19", "13", "10"]
            ))
    ), 
    DataFrame(Dict(
        :HEL => ["50 14.5", "94 -0.1", "50  1.5"],
        :ID => ["A 12.", "B  5.", "C  9."],
        :MGW => ["00", "45", "25"]
        )))
])

problem_66 = Problem("problem_66", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Group => ["SBT", "SBS", "SBS", "SBS", "SBI", "SBT", "SBS", "SBI"],
            :Hour => ["00", "00", "00", "00", "00", "00", "00", "00"],
            :V51 => ["1 02:00:", "1 08:00:", "9 08:00:", "4 18:00:", "2 06:00:", "6 11:00:", "4 18:00:", "6 10:00:"]
            ))
    ), 
    DataFrame(Dict(
        :sum => ["10", "8"]
        )))
])

problem_67 = Problem("problem_67", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :n => ["5", "0", "0", "2", "8", "1", "4", "0"],
            :name => ["erry  61", "erry 160", "erry 100", "erry  43", "erry  59", "erry  42", "erry  23", "erry 120"],
            :sex => ["F  K", "M  K", "F  K", "M  K", "F  K", "M  K", "F Sh", "M Sh"],
            :year => ["1955", "1955", "1980", "1980", "1988", "1988", "1980", "1980"]
            ))
    ), 
    DataFrame(Dict(
        :F => ["5 160", "0  43", "8  42"],
        :M => ["0", "2", "1"],
        :year => ["1955  61", "1980 100", "1988  59"]
        )))
])

problem_68 = Problem("problem_68", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :am => ["1", "1", "1", "0", "0", "0", "0", "0"],
            :cyl => ["6", "6", "4", "6", "8", "6", "8", "4"],
            :mpg => ["21.0", "21.0", "22.8", "21.4", "18.7", "18.1", "14.3", "24.4"],
            :vs => ["0", "0", "1", "1", "0", "1", "0", "1"]
            ))
    ), 
    DataFrame(Dict(
        :countofvalues => ["2", "2", "3", "1"],
        :vs_am => ["0_0", "0_1", "1_0", "1_1"]
        )))
])

problem_69 = Problem("problem_69", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Subject => ["A-pre", "A-post", "B-pre", "B-post"],
            :Var1 => ["25", "25", "30", "30"],
            :Var2 => ["27", "26", "28", "28"]
            ))
    ), 
    DataFrame(Dict(
        :SubjectNew => ["A        25", "B        30"],
        :Var1_post => ["25", "30"],
        :Var1_pre => ["26", "28"],
        :Var2_post => ["27", "28"],
        :Var2_pre => ["", ""]
        )))
])

problem_70 = Problem("problem_70", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Action => ["0", "omatoes", "5", "rror", "2", "1"],
            :Rating => ["4", "Green-T", "s", "ille-Ho", "a", "4"],
            :Sci.Fi => ["1", "2      0      0", "1      0", "1      0      0", "0      1", "0"],
            :Title => ["Carrie", "Fried-", "Amadeu", "Amityv", "Dracul", "Speed"]
            ))
    ), 
    DataFrame(Dict(
        :average => ["4.5", "3.0"],
        :genre => ["Action", "Sci.Fi"]
        )))
])

problem_71 = Problem("problem_71", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :id => ["1 -0.783356", "2 -0.407346", "1  0.279941", "2 -1.349663", "1 -0.103004", "2  0.583907"],
            :p1 => ["8  0.638358", "5  0.348086", "4 -0.193858", "3 -0.527108", "5  0.864233", "0 -0.972326"],
            :p2 => ["8", "0", "6", "0", "6", "4"],
            :p3 => ["1", "1", "2", "2", "3", "3"]
            ))
    ), 
    DataFrame(Dict(
        :1_p1 => ["568 0.6383", "465 0.3480"],
        :1_p2 => ["588  0.2799", "860 -1.3496"],
        :2_p1 => ["414 -0.1938", "633 -0.5271"],
        :2_p2 => ["586 -0.1030", "080  0.5839"],
        :3_p1 => ["045  0.8642", "070 -0.9723"],
        :3_p2 => ["336", "264"],
        :id => ["1 -0.7833", "2 -0.4073"]
        )))
])

problem_72 = Problem("problem_72", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :a => ["1", "1", "1", "1", "1", "1", "1", "1", "1"],
            :b => ["1", "1 20", "1 30", "1", "1 60", "2", "2 10", "2 20", "3"],
            :d => ["0", "0", "0", "0", "0", "0", "0", "0", "0"]
            ))
    ), 
    DataFrame(Dict(
        :a => ["1", "1"],
        :b => ["1 36", "2 15"],
        :mean_d => ["6.6667", "0.0000"]
        )))
])

problem_73 = Problem("problem_73", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :band => ["", "", "", "", "", ""],
            :non_spec => ["1 -1.7906249", "0  1.3883798", "1  0.4490315", "1  0.9137950", "1 -1.5885563", "1  0.4183408"],
            :reads => ["", "", "", "", "", ""],
            :vial_id => ["1    1", "2    0", "3    0", "4    2", "5    1", "6    2"]
            ))
    ), 
    DataFrame(Dict(
        :group_id => ["0_0  1.38", "0_1  0.44", "1_1 -1.68", "2_1  0.66"],
        :group_mean => ["83798", "90315", "95906", "60679"]
        )))
])

problem_74 = Problem("problem_74", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Color => ["l   Re", "l  Blu", "ent", "ent  B"],
            :Count => ["2    10", "3    20", "1    14", "4    21"],
            :Response => ["d", "e", "Red", "lue"],
            :Which => ["Contro", "Contro", "Treatm", "Treatm"]
            ))
    ), 
    DataFrame(Dict(
        :Color => ["Blue", "Red"],
        :Count_Control => ["20", "10"],
        :Count_Treatment => ["21", "14"],
        :Response_Control => ["3", "2"],
        :Response_Treatment => ["4", "1"]
        )))
])

problem_75 = Problem("problem_75", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Q1.1 => ["289 -0.01618", "247  0.94383"],
            :Q1.2 => ["826  1.5271", "621 -0.4038"],
            :Q2.1 => ["807 -0.2917", "005 -1.1981"],
            :Q2.2 => ["768", "381"],
            :id => ["1 2009-01", "2 2009-01"],
            :time => ["-01 0.4874", "-02 0.7383"]
            ))
    ), 
    DataFrame(Dict(
        :Q1 => ["5  1.527180", "6 -0.291776", "1 -0.403800", "1 -1.198138"],
        :Q2 => ["7", "8", "5", "1"],
        :id => ["1 2009-01", "1 2009-01", "2 2009-01", "2 2009-01"],
        :time => ["-01  0.4874288", "-01 -0.0161882", "-02  0.7383247", "-02  0.9438362"]
        )))
])

problem_76 = Problem("problem_76", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :value.1 => ["a", "b", "c", "d", "a", "b", "c", "d"],
            :value.2 => ["1      13", "2      14", "3      15", "4      16", "5      17", "6      18", "7      19", "8      20"],
            :x => ["re", "re", "re", "re", "bl", "bl", "bl", "bl"],
            :y => ["d", "d", "d", "d", "ue", "ue", "ue", "ue"]
            ))
    ), 
    DataFrame(Dict(
        :value.1_a => ["ue", "d", "value.2_d", "", ""],
        :value.1_b => ["5", "1", "", "", ""],
        :value.1_c => ["6", "2", "", "", ""],
        :value.1_d => ["7", "3", "", "", ""],
        :value.2_a => ["8", "4        1", "", "", ""],
        :value.2_b => ["17", "3        1", "", "", ""],
        :value.2_c => ["18        19", "4        15", "", "", ""],
        :x => ["bl", "re", "", "20", "16"]
        )))
])

problem_77 = Problem("problem_77", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :obs => ["1 20", "2 20", "3 20", "4 20", "5 20", "6 20", "7 20"],
            :type => ["A", "A", "B", "A", "B", "A", "A"],
            :year => ["15", "15", "15", "14", "14", "14", "15"]
            ))
    ), 
    DataFrame(Dict(
        :freq => ["3", "3", "1", "3", "1", "3", "3"],
        :obs => ["1 20", "2 20", "3 20", "4 20", "5 20", "6 20", "7 20"],
        :type => ["A", "A", "B", "A", "B", "A", "A"],
        :year => ["15", "15", "15", "14", "14", "14", "15"]
        )))
])

problem_78 = Problem("problem_78", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :x => ["1", "1", "1", "1", "2", "2", "2", "2"],
            :x2 => ["1 1.4", "1 1.3", "2 1.9", "2 2.1", "1 0.9", "1 1.1", "2 1.9", "2 2.1"],
            :y => ["1", "9", "0", "0", "0", "0", "0", "0"]
            ))
    ), 
    DataFrame(Dict(
        :a => ["4 1.007142", "4 0.992857", "4 1.357142", "4 1.500000", "0 0.900000", "0 1.100000", "0 1.900000", "0 2.100000"],
        :x => ["1", "1", "1", "1", "2", "2", "2", "2"],
        :x2 => ["1 1.4", "1 1.3", "2 1.9", "2 2.1", "1 0.9", "1 1.1", "2 1.9", "2 2.1"],
        :y => ["1 1.", "9 1.", "0 1.", "0 1.", "0 1.", "0 1.", "0 1.", "0 1."],
        :z => ["9", "1", "9", "0", "0", "0", "0", "0"]
        )))
])

problem_79 = Problem("problem_79", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :dept => ["CS", "EE", "vil", "ics"],
            :employee => ["Yossi", "Pitt", "Deepak", "Golan"],
            :id => ["1", "2", "3   Ci", "4 Phys"],
            :salary => ["21000", "23400", "26800", "91000"]
            ))
    ), 
    DataFrame(Dict(
        :mean => ["58900"]
        )))
])

problem_80 = Problem("problem_80", [
    IOExample(Dict(
        :_arg_1 => DataFrame(Dict(
            :Prod1 => ["0", "0", "1"],
            :Prod3 => ["1", "1", "1"],
            :Prod4 => ["1", "0", "1"],
            :Prod5 => ["", "", ""],
            :order_id => ["A     1", "B     0", "C     1"],
            :prod2 => ["1", "1", "0"]
            ))
    ), 
    DataFrame(Dict(
        :order_id => ["A Prod1", "C Prod1", "C prod2", "A Prod3", "B Prod3", "A Prod4", "B Prod4", "C Prod4", "A Prod5", "C Prod5"],
        :var => ["", "", "", "", "", "", "", "", "", ""]
        )))
])

# Auto-generated from DreamCoder's text-editing domain
# (`dreamcoder/domains/text/makeTextTasks.py`, Ellis et al., 2021).
#
# DreamCoder represents strings as lists of characters; this benchmark
# uses Julia `String`s, which the grammar's primitives operate on directly.

problem_000_replace_w = Problem("problem_000_replace_w", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Nancy,334,611,+172"), "Nancy(334(611(+172"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "820,Connecticut"), "820(Connecticut"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "066,+106,Bobo,200"), "066(+106(Bobo(200"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+132,Tobias"), "+132(Tobias")
])

problem_001_replace_w_2 = Problem("problem_001_replace_w_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Beata.21.119"), "Beata)21)119"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "83.Ramthun"), "83)Ramthun"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "622.270"), "622)270"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lakenya.876.18.064"), "Lakenya)876)18)064")
])

problem_002_replace_w_3 = Problem("problem_002_replace_w_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+138-Irwin-46"), "+138,Irwin,46"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "2-FreeHafer-+188"), "2,FreeHafer,+188"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "834-Cruz-+197-Clasen"), "834,Cruz,+197,Clasen"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Georgina-Dr-Alida-Acura100"), "Georgina,Dr,Alida,Acura100")
])

problem_003_replace_w_4 = Problem("problem_003_replace_w_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "C(40"), "C.40"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spagnoli(7(Seamons"), "Spagnoli.7.Seamons"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "75(University"), "75.University"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "155(Edison(CA(29"), "155.Edison.CA.29")
])

problem_004_replace_w_5 = Problem("problem_004_replace_w_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "017,Celsa"), "017.Celsa"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Reily,Madelaine"), "Reily.Madelaine"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati,+147"), "Ducati.+147"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+197,980,Hage,Cencici"), "+197.980.Hage.Cencici")
])

problem_005_replace_w_6 = Problem("problem_005_replace_w_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+194(+185(+147(Rice"), "+194)+185)+147)Rice"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "14(Micha"), "14)Micha"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Babiarz(Annalisa(+151(Samuel"), "Babiarz)Annalisa)+151)Samuel"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hornak(Q(Mackenzie"), "Hornak)Q)Mackenzie")
])

problem_006_replace_w_7 = Problem("problem_006_replace_w_7", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jacqualine-62"), "Jacqualine 62"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+183-13"), "+183 13"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "759-Bogle"), "759 Bogle"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+106-Yale-+130-+141"), "+106 Yale +130 +141")
])

problem_007_replace_w_8 = Problem("problem_007_replace_w_8", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Honda250 Casler Edison"), "Honda250(Casler(Edison"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "52 622"), "52(622"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "035 Penn Hornak"), "035(Penn(Hornak"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+9 Rowden Reily"), "+9(Rowden(Reily")
])

problem_008_replace_w_9 = Problem("problem_008_replace_w_9", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+194(Alaina"), "+194 Alaina"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "CT(Heintz(Cornell(Phillip"), "CT Heintz Cornell Phillip"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Nancy(Houston"), "Nancy Houston"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "377(209(+118"), "377 209 +118")
])

problem_009_drop_first_word_delimited_by = Problem("problem_009_drop_first_word_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Acura.Urbana"), "Urbana"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "598.849.854.Kimberley"), "849.854.Kimberley"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Angeles.+115.+140"), "+115.+140"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jenee.21.80.Soderstrom"), "21.80.Soderstrom")
])

problem_010_nth_n_0_word_delimited_by = Problem("problem_010_nth_n_0_word_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "505.+46"), "505"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "B.25.Jeanice"), "B"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bradford.971.+180"), "Bradford"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Maryann.705.Barbara"), "Maryann")
])

problem_011_nth_n_1_word_delimited_by = Problem("problem_011_nth_n_1_word_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Karrie.Covelli.882.+129"), "Covelli"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bogle.Jani"), "Jani"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "H.+7.Cortes.+169"), "+7"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati125.of.588.843"), "of")
])

problem_012_nth_n_1_word_delimited_by_2 = Problem("problem_012_nth_n_1_word_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "N.Annalisa.Houston"), "Houston"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Latimore.Joaquin.Bobo.G"), "G"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "197.58"), "58"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+118.Mulloy.56"), "56")
])

problem_013_drop_first_word_delimited_by_2 = Problem("problem_013_drop_first_word_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "943,65,216,CA"), "65,216,CA"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+6,Micha,167"), "Micha,167"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Nancy,Beata,512,864"), "Beata,512,864"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Rice,Partida,894,40"), "Partida,894,40")
])

problem_014_nth_n_0_word_delimited_by_2 = Problem("problem_014_nth_n_0_word_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "R,Miah,Arbor"), "R"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Neil,Heintz,Malissa,Berkeley"), "Neil"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+115,+106"), "+115"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "MA,B,+95"), "MA")
])

problem_015_nth_n_1_word_delimited_by_3 = Problem("problem_015_nth_n_1_word_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Arbor,Scalia,Seamons,847"), "Scalia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Sergienko,009,Jacquiline,Sergienko"), "009"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Tobias,986,FreeHafer,+9"), "986"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "473,Phialdelphia"), "Phialdelphia")
])

problem_016_nth_n_1_word_delimited_by_4 = Problem("problem_016_nth_n_1_word_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "144,Honda550,Hopkins"), "Hopkins"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "468,376"), "376"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+194,Scalia,Montiel,Ghoston"), "Ghoston"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "50,+9"), "+9")
])

problem_017_drop_first_word_delimited_by_3 = Problem("problem_017_drop_first_word_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "386 Georgina 720 141"), "Georgina 720 141"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "141 Lashanda"), "Lashanda"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bess Berkeley"), "Berkeley"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "S 2 86 178"), "2 86 178")
])

problem_018_nth_n_0_word_delimited_by_3 = Problem("problem_018_nth_n_0_word_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "42 597 J"), "42"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "268 14 +104"), "268"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Q +108 Desiree"), "Q"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Brescia A 56"), "Brescia")
])

problem_019_nth_n_1_word_delimited_by_5 = Problem("problem_019_nth_n_1_word_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+132 Annalisa Mcgaughey Ferrari"), "Annalisa"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "University Sergienko"), "Sergienko"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "29 Ferrari250"), "Ferrari250"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Soderstrom Scalia"), "Scalia")
])

problem_020_nth_n_1_word_delimited_by_6 = Problem("problem_020_nth_n_1_word_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "K 358 Jacquiline Columbia"), "Columbia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Park +183 186"), "186"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "CA Vena 23 Hopkins"), "Hopkins"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Edison 29 938 W"), "W")
])

problem_021_drop_first_word_delimited_by_4 = Problem("problem_021_drop_first_word_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+9(Urbana"), "Urbana"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati(969(+144(Olague"), "969(+144(Olague"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "75(Rice"), "Rice"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Barbara(Temple(Samuel"), "Temple(Samuel")
])

problem_022_nth_n_0_word_delimited_by_4 = Problem("problem_022_nth_n_0_word_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "C(98"), "C"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "B(23"), "B"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lango(Desiree"), "Lango"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Pennsylvania(Marquess"), "Pennsylvania")
])

problem_023_nth_n_1_word_delimited_by_7 = Problem("problem_023_nth_n_1_word_delimited_by_7", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "W(517(+199"), "517"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria(736(654"), "736"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Phialdelphia(+176(741(Ducati250"), "+176"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+188(45(+9"), "45")
])

problem_024_nth_n_1_word_delimited_by_8 = Problem("problem_024_nth_n_1_word_delimited_by_8", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Scalia(65"), "65"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "684(Ghoston"), "Ghoston"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "N(Spell(Babiarz(MD"), "MD"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Berkeley(557(29"), "29")
])

problem_025_drop_first_word_delimited_by_5 = Problem("problem_025_drop_first_word_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Heintz)Babiarz)University"), "Babiarz)University"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jeanice)+194)+189)491"), "+194)+189)491"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jenee)Jenee)151)UC"), "Jenee)151)UC"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mariel)+195"), "+195")
])

problem_026_nth_n_0_word_delimited_by_5 = Problem("problem_026_nth_n_0_word_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "E)844"), "E"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lara)+176"), "Lara"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+105)046)Casler"), "+105"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "L)40)591)W"), "L")
])

problem_027_nth_n_1_word_delimited_by_9 = Problem("problem_027_nth_n_1_word_delimited_by_9", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "UC)+176)Jeanice)+174"), "+176"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mariel)Carlene)Ducati100)Jeff"), "Carlene"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "R)+144"), "+144"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Partida)FreeHafer)+130)D"), "FreeHafer")
])

problem_028_nth_n_1_word_delimited_by_10 = Problem("problem_028_nth_n_1_word_delimited_by_10", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+151)50)Withers"), "Withers"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "T)+197"), "+197"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+42)+98)+115)Junkin"), "Junkin"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "539)027)42"), "42")
])

problem_029_drop_first_word_delimited_by_6 = Problem("problem_029_drop_first_word_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "62-Temple"), "Temple"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cambridge-+7-+140-29"), "+7-+140-29"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Coralee-862"), "862"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "California-+158-Ghoston-82"), "+158-Ghoston-82")
])

problem_030_nth_n_0_word_delimited_by_6 = Problem("problem_030_nth_n_0_word_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jeff-Lara-Karrie"), "Jeff"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "64-836-197-Michigan"), "64"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+172-Penn-Chilcott-E"), "+172"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Olague-Bradford-+115-N"), "Olague")
])

problem_031_nth_n_1_word_delimited_by_11 = Problem("problem_031_nth_n_1_word_delimited_by_11", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+155-Covelli-Constable-405"), "Covelli"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Kotas-028"), "028"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Launa-Hornak"), "Hornak"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "504-Jeanice-K"), "Jeanice")
])

problem_032_nth_n_1_word_delimited_by_12 = Problem("problem_032_nth_n_1_word_delimited_by_12", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "473-Nancy-980-166"), "166"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Alaina-Jacquiline"), "Jacquiline"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "21-of"), "of"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+172-University-College"), "College")
])

problem_033_append_two_words_delimited_by = Problem("problem_033_append_two_words_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bradford", :_arg_2 => "Beata"), "Bradford.Beata"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "R", :_arg_2 => "Rowden"), "R.Rowden"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+2", :_arg_2 => "Jacquiline"), "+2.Jacquiline"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "632", :_arg_2 => "836"), "632.836")
])

problem_034_append_two_words_delimited_by_2 = Problem("problem_034_append_two_words_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "UIUC", :_arg_2 => "608"), "UIUC,608"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "2", :_arg_2 => "Garrard"), "2,Garrard"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Pennsylvania", :_arg_2 => "+198"), "Pennsylvania,+198"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Acura100", :_arg_2 => "705"), "Acura100,705")
])

problem_035_append_two_words_delimited_by_3 = Problem("problem_035_append_two_words_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lain", :_arg_2 => "Irwin"), "Lain Irwin"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mariel", :_arg_2 => "Harvard"), "Mariel Harvard"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "051", :_arg_2 => "+174"), "051 +174"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "35", :_arg_2 => "Rowden"), "35 Rowden")
])

problem_036_append_two_words_delimited_by_4 = Problem("problem_036_append_two_words_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "PA", :_arg_2 => "Dermody"), "PA(Dermody"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "204", :_arg_2 => "Elias"), "204(Elias"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Q", :_arg_2 => "Ducati250"), "Q(Ducati250"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "176", :_arg_2 => "C"), "176(C")
])

problem_037_append_two_words_delimited_by_5 = Problem("problem_037_append_two_words_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "42", :_arg_2 => "959"), "42)959"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Vena", :_arg_2 => "Eccleston"), "Vena)Eccleston"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Park", :_arg_2 => "Hopkins"), "Park)Hopkins"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Storrs", :_arg_2 => "Jacquiline"), "Storrs)Jacquiline")
])

problem_038_append_two_words_delimited_by_6 = Problem("problem_038_append_two_words_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+196", :_arg_2 => "O"), "+196-O"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "119", :_arg_2 => "Harvard"), "119-Harvard"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "47", :_arg_2 => "NY"), "47-NY"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Constable", :_arg_2 => "+197"), "Constable-+197")
])

problem_039_append_two_words_delimited_by_7 = Problem("problem_039_append_two_words_delimited_by_7", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Malissa", :_arg_2 => "Philadelphia"), "Malissa  Philadelphia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+155", :_arg_2 => "Bobo"), "+155  Bobo"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Acura", :_arg_2 => "Vena"), "Acura  Vena"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "2", :_arg_2 => "+151"), "2  +151")
])

problem_040_append_two_words_delimited_by_8 = Problem("problem_040_append_two_words_delimited_by_8", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "771", :_arg_2 => "5"), "771. 5"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Philadelphia", :_arg_2 => "433"), "Philadelphia. 433"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "62", :_arg_2 => "Mackenzie"), "62. Mackenzie"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Haven", :_arg_2 => "575"), "Haven. 575")
])

problem_041_append_two_words_delimited_by_9 = Problem("problem_041_append_two_words_delimited_by_9", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "245", :_arg_2 => "18"), "245(,18"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati100", :_arg_2 => "+176"), "Ducati100(,+176"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "50", :_arg_2 => "949"), "50(,949"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Harvard", :_arg_2 => "+183"), "Harvard(,+183")
])

problem_042_append_two_words_delimited_by_10 = Problem("problem_042_append_two_words_delimited_by_10", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ferrari", :_arg_2 => "Angeles"), "Ferrari..Angeles"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "568", :_arg_2 => "Teddy"), "568..Teddy"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Vena", :_arg_2 => "50"), "Vena..50"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spagnoli", :_arg_2 => "Hornak"), "Spagnoli..Hornak")
])

problem_043_append_two_words_delimited_by_11 = Problem("problem_043_append_two_words_delimited_by_11", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "2", :_arg_2 => "Kotas"), "2.-Kotas"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Salley", :_arg_2 => "29"), "Salley.-29"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mackenzie", :_arg_2 => "163"), "Mackenzie.-163"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Philadelphia", :_arg_2 => "6"), "Philadelphia.-6")
])

problem_044_append_two_words_delimited_by_12 = Problem("problem_044_append_two_words_delimited_by_12", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "2", :_arg_2 => "J"), "2 -J"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Q", :_arg_2 => "Phillip"), "Q -Phillip"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "779", :_arg_2 => "Withers"), "779 -Withers"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "622", :_arg_2 => "Andrew"), "622 -Andrew")
])

problem_045_drop_last_1_characters = Problem("problem_045_drop_last_1_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "290"), "29"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "769"), "76"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+130"), "+13"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Latimore"), "Latimor")
])

problem_046_drop_last_2_characters = Problem("problem_046_drop_last_2_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Nancy"), "Nan"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "562"), "5"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "MI"), ""),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Stefany"), "Stefa")
])

problem_047_take_first_2_characters = Problem("problem_047_take_first_2_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+2"), "+2"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Stefany"), "St"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Dermody"), "De"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "334"), "33")
])

problem_048_drop_last_3_characters = Problem("problem_048_drop_last_3_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "012"), ""),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "857"), ""),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hage"), "H"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Brescia"), "Bres")
])

problem_049_take_first_3_characters = Problem("problem_049_take_first_3_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Vena"), "Ven"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Trinidad"), "Tri"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "766"), "766"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "598"), "598")
])

problem_050_drop_last_4_characters = Problem("problem_050_drop_last_4_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+167"), ""),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jenee"), "J"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria"), "An"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Santa"), "S")
])

problem_051_take_first_4_characters = Problem("problem_051_take_first_4_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+106"), "+106"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Haven"), "Have"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Reily"), "Reil"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati250"), "Duca")
])

problem_052_drop_last_5_characters = Problem("problem_052_drop_last_5_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ferrari250"), "Ferra"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cencici"), "Ce"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Heintz"), "H"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mcgaughey"), "Mcga")
])

problem_053_take_first_5_characters = Problem("problem_053_take_first_5_characters", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Carlene"), "Carle"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Desiree"), "Desir"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati250"), "Ducat"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Gregori"), "Grego")
])

problem_054_extract_word_delimited_by = Problem("problem_054_extract_word_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "86,+161.13,+7"), "+161"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "CT,+118.Mariel.40"), "+118"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "426,Lain.45,Honda125"), "Lain"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "504,566.20.F"), "566")
])

problem_055_extract_word_delimited_by_2 = Problem("problem_055_extract_word_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati250(+183(Richert(Park"), "+183"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "14(Rowden(Jeanice(Acura125"), "Rowden"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Montiel(Temple(Heintz(Teddy"), "Temple"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria(Honda125(+75(Malissa"), "Honda125")
])

problem_056_extract_word_delimited_by_3 = Problem("problem_056_extract_word_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jeff,Scalia,Gertude,877"), "Scalia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Barbara,+86,95,Urbana"), "+86"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+75,FreeHafer,861,Babiarz"), "FreeHafer"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "7,Soderstrom,S,A"), "Soderstrom")
])

problem_057_extract_word_delimited_by_4 = Problem("problem_057_extract_word_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cruz)+188-Maryann)183"), "+188"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "141)Penn-Jani-Clasen"), "Penn"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+144)060-Soderstrom)68"), "060"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+60)Lain-Ducati100-Bradford"), "Lain")
])

problem_058_extract_word_delimited_by_5 = Problem("problem_058_extract_word_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "NY-Philadelphia)Ferrari-PA"), "Philadelphia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "York-Mackenzie)Jacquiline)L"), "Mackenzie"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "T-188)Brendan-736"), "188"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "155-Reily)Haven)+132"), "Reily")
])

problem_059_extract_word_delimited_by_6 = Problem("problem_059_extract_word_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "244)Karrie,Lashanda)Kimberley"), "Karrie"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+104)+58,Ramthun,Bobo"), "+58"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cambridge)Storrs,449)10"), "Storrs"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "963)Kathlyn,Melodi,Spagnoli"), "Kathlyn")
])

problem_060_first_letters_of_words_i = Problem("problem_060_first_letters_of_words_i", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+118 Chism 428 Acura100"), "+C4A"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "81 Heintz Pannell"), "8HP"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria Richert 652 Penn"), "AR6P"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "C 461 +140 Phillip"), "C4+P")
])

problem_061_first_letters_of_words_ii = Problem("problem_061_first_letters_of_words_ii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "365 Aylward"), "3A"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Celsa Latimore"), "CL"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "438 20 MA FreeHafer"), "42MF"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "6 Kimberley 095"), "6K0")
])

problem_062_first_letters_of_words_iii = Problem("problem_062_first_letters_of_words_iii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Trinidad 500 862"), "T58"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lango Babiarz R"), "LBR"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "000 Dermody +196"), "0D+"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+5 Urbana"), "+U")
])

problem_063_first_letters_of_words_iiii = Problem("problem_063_first_letters_of_words_iiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spell 865 169 095"), "S810"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "310 817 Q +185"), "38Q+"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "CT FreeHafer Bogle"), "CFB"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati250 Lashanda N Barbara"), "DLNB")
])

problem_064_first_letters_of_words_iiiii = Problem("problem_064_first_letters_of_words_iiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Honda550 +180 Q"), "H+Q"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "46 439"), "44"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "751 Drexel L J"), "7DLJ"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Dr UC K Rowden"), "DUKR")
])

problem_065_first_letters_of_words_iiiiii = Problem("problem_065_first_letters_of_words_iiiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+155 174 Dr Haven"), "+1DH"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "888 Penn 50 UC"), "8P5U"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "43 390 Phillip"), "43P"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "21 B"), "2B")
])

problem_066_take_first_character_and_append = Problem("problem_066_take_first_character_and_append", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+189"), "+."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+46"), "+."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "290"), "2."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Marquess"), "M.")
])

problem_067_take_first_character_and_append_2 = Problem("problem_067_take_first_character_and_append_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "56"), "5,"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ramthun"), "R,"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Covelli"), "C,"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "546"), "5,")
])

problem_068_take_first_character_and_append_3 = Problem("problem_068_take_first_character_and_append_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jan"), "J "),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Alida"), "A "),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Brescia"), "B "),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "MI"), "M ")
])

problem_069_take_first_character_and_append_4 = Problem("problem_069_take_first_character_and_append_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "82"), "8("),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "020"), "0("),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Pennsylvania"), "P("),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Melodi"), "M(")
])

problem_070_take_first_character_and_append_5 = Problem("problem_070_take_first_character_and_append_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "DPhiladelphia"), "D)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+169"), "+)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "414"), "4)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "83"), "8)")
])

problem_071_take_first_character_and_append_6 = Problem("problem_071_take_first_character_and_append_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Chong"), "C-"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Scalia"), "S-"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "751"), "7-"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+158"), "+-")
])

problem_072_abbreviate_separate_words_i = Problem("problem_072_abbreviate_separate_words_i", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Dermody", :_arg_2 => "D"), "D.D."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Irwin", :_arg_2 => "Spell"), "I.S."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+118", :_arg_2 => "894"), "+.8."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "62", :_arg_2 => "Ramthun"), "6.R.")
])

problem_073_abbreviate_words_separated_by = Problem("problem_073_abbreviate_words_separated_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spagnoli.734"), "S.7."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "T.81"), "T.8."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cambridge.6"), "C.6."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "817.33"), "8.3.")
])

problem_074_abbreviate_separate_words_ii = Problem("problem_074_abbreviate_separate_words_ii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hayley", :_arg_2 => "Ferrari"), "H.F."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Gertude", :_arg_2 => "Dermody"), "G.D."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "York", :_arg_2 => "Madelaine"), "Y.M."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "395", :_arg_2 => "082"), "3.0.")
])

problem_075_abbreviate_words_separated_by_2 = Problem("problem_075_abbreviate_words_separated_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "R,+108"), "R.+."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "FreeHafer,Park"), "F.P."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Rice,883"), "R.8."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Trinidad,58"), "T.5.")
])

problem_076_abbreviate_separate_words_iii = Problem("problem_076_abbreviate_separate_words_iii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+189", :_arg_2 => "856"), "+.8."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "038", :_arg_2 => "Hornak"), "0.H."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+174", :_arg_2 => "Lain"), "+.L."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "692", :_arg_2 => "Soderstrom"), "6.S.")
])

problem_077_abbreviate_words_separated_by_3 = Problem("problem_077_abbreviate_words_separated_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "938 Alida"), "9.A."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Annalisa College"), "A.C."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "038 Cruz"), "0.C."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+104 Hayley"), "+.H.")
])

problem_078_abbreviate_separate_words_iiii = Problem("problem_078_abbreviate_separate_words_iiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+140", :_arg_2 => "Partida"), "+.P."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "413", :_arg_2 => "Acura"), "4.A."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "M", :_arg_2 => "145"), "M.1."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "S", :_arg_2 => "Beata"), "S.B.")
])

problem_079_abbreviate_words_separated_by_4 = Problem("problem_079_abbreviate_words_separated_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jeanice(Acura"), "J.A."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "G(Partida"), "G.P."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "048(Joaquin"), "0.J."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+180(P"), "+.P.")
])

problem_080_abbreviate_separate_words_iiiii = Problem("problem_080_abbreviate_separate_words_iiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mulloy", :_arg_2 => "V"), "M.V."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "50", :_arg_2 => "PA"), "5.P."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati125", :_arg_2 => "46"), "D.4."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "21", :_arg_2 => "169"), "2.1.")
])

problem_081_abbreviate_words_separated_by_5 = Problem("problem_081_abbreviate_words_separated_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "585)13"), "5.1."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+196)253"), "+.2."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "83)56"), "8.5."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Coralee)Rowden"), "C.R.")
])

problem_082_abbreviate_separate_words_iiiiii = Problem("problem_082_abbreviate_separate_words_iiiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+81", :_arg_2 => "Halpern"), "+.H."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lakenya", :_arg_2 => "62"), "L.6."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "O", :_arg_2 => "Dr"), "O.D."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "25", :_arg_2 => "488"), "2.4.")
])

problem_083_abbreviate_words_separated_by_6 = Problem("problem_083_abbreviate_words_separated_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Kathlyn-Beata"), "K.B."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cruz-150"), "C.1."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mackenzie-K"), "M.K."),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "941-162"), "9.1.")
])

problem_084_append_2_strings_i = Problem("problem_084_append_2_strings_i", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Georgina", :_arg_2 => "2"), "Georgina2"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Phialdelphia", :_arg_2 => "40"), "Phialdelphia40"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "I", :_arg_2 => "+172"), "I+172"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Richert", :_arg_2 => "NY"), "RichertNY")
])

problem_085_append_2_strings_ii = Problem("problem_085_append_2_strings_ii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spell", :_arg_2 => "Los"), "SpellLos"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+163", :_arg_2 => "+141"), "+163+141"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "I", :_arg_2 => "P"), "IP"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "245", :_arg_2 => "Casler"), "245Casler")
])

problem_086_append_2_strings_iii = Problem("problem_086_append_2_strings_iii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cambridge", :_arg_2 => "Honda550"), "CambridgeHonda550"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "35", :_arg_2 => "981"), "35981"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "25", :_arg_2 => "176"), "25176"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Tobias", :_arg_2 => "58"), "Tobias58")
])

problem_087_append_2_strings_iiii = Problem("problem_087_append_2_strings_iiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "426", :_arg_2 => "369"), "426369"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Marcus", :_arg_2 => "776"), "Marcus776"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "141", :_arg_2 => "636"), "141636"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Seamons", :_arg_2 => "Lakenya"), "SeamonsLakenya")
])

problem_088_append_2_strings_iiiii = Problem("problem_088_append_2_strings_iiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jacquiline", :_arg_2 => "College"), "JacquilineCollege"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Soderstrom", :_arg_2 => "+199"), "Soderstrom+199"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Alaina", :_arg_2 => "7"), "Alaina7"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Madelaine", :_arg_2 => "29"), "Madelaine29")
])

problem_089_append_2_strings_iiiiii = Problem("problem_089_append_2_strings_iiiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Miah", :_arg_2 => "81"), "Miah81"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Garrard", :_arg_2 => "+141"), "Garrard+141"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+199", :_arg_2 => "919"), "+199919"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "O", :_arg_2 => "765"), "O765")
])

problem_090_prepend_hornak = Problem("problem_090_prepend_hornak", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "865"), "Hornak865"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "P"), "HornakP"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "H"), "HornakH"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Mackenzie"), "HornakMackenzie")
])

problem_091_append_cornell = Problem("problem_091_append_cornell", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "IL"), "ILCornell"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "101"), "101Cornell"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Akiyama"), "AkiyamaCornell"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "715"), "715Cornell")
])

problem_092_prepend_167_to_first_word = Problem("problem_092_prepend_167_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "172 Hayley"), "+167172"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Madelaine Carlene"), "+167Madelaine"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+169 29"), "+167+169"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Launa 845"), "+167Launa")
])

problem_093_prepend_174 = Problem("problem_093_prepend_174", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "S"), "+174S"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "851"), "+174851"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "52"), "+17452"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jurgens"), "+174Jurgens")
])

problem_094_append_636 = Problem("problem_094_append_636", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "FreeHafer"), "FreeHafer636"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bess"), "Bess636"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "844"), "844636"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "C"), "C636")
])

problem_095_prepend_ghoston_to_first_word = Problem("problem_095_prepend_ghoston_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "FreeHafer 47"), "GhostonFreeHafer"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "720 588"), "Ghoston720"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "125 +118"), "Ghoston125"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Samuel Hage"), "GhostonSamuel")
])

problem_096_prepend_ucla = Problem("problem_096_prepend_ucla", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "MI"), "UCLAMI"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Santa"), "UCLASanta"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ferrari"), "UCLAFerrari"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Sergienko"), "UCLASergienko")
])

problem_097_append_138 = Problem("problem_097_append_138", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hopkins"), "Hopkins+138"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "512"), "512+138"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cornell"), "Cornell+138"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "TX"), "TX+138")
])

problem_098_prepend_170_to_first_word = Problem("problem_098_prepend_170_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Drexel Maryann"), "170Drexel"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "of Latimore"), "170of"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Malissa W"), "170Malissa"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Malissa 500"), "170Malissa")
])

problem_099_prepend_sergienko = Problem("problem_099_prepend_sergienko", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "F"), "SergienkoF"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Stefany"), "SergienkoStefany"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Barbara"), "SergienkoBarbara"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "009"), "Sergienko009")
])

problem_100_append_beata = Problem("problem_100_append_beata", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "092"), "092Beata"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "997"), "997Beata"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "S"), "SBeata"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Eccleston"), "EcclestonBeata")
])

problem_101_prepend_carlene_to_first_word = Problem("problem_101_prepend_carlene_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+155 45"), "Carlene+155"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "997 CA"), "Carlene997"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Gertude +198"), "CarleneGertude"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "43 927"), "Carlene43")
])

problem_102_prepend_jani = Problem("problem_102_prepend_jani", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ithaca"), "JaniIthaca"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Honda550"), "JaniHonda550"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria"), "JaniAndria"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "25"), "Jani25")
])

problem_103_append_angeles = Problem("problem_103_append_angeles", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+199"), "+199Angeles"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "469"), "469Angeles"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Celsa"), "CelsaAngeles"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spell"), "SpellAngeles")
])

problem_104_prepend_177_to_first_word = Problem("problem_104_prepend_177_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "566 14"), "177566"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "421 Annalisa"), "177421"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Alaina +141"), "177Alaina"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Jacqualine +180"), "177Jacqualine")
])

problem_105_prepend_spell = Problem("problem_105_prepend_spell", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Aylward"), "SpellAylward"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+105"), "Spell+105"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+197"), "Spell+197"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "358"), "Spell358")
])

problem_106_append_dermody = Problem("problem_106_append_dermody", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "29"), "29Dermody"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Columbia"), "ColumbiaDermody"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+5"), "+5Dermody"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "085"), "085Dermody")
])

problem_107_prepend_086_to_first_word = Problem("problem_107_prepend_086_to_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "18 Miah"), "08618"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Georgina 72"), "086Georgina"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati Penn"), "086Ducati"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "35 Lara"), "08635")
])

problem_108_parentheses_around_a_single_word_i = Problem("problem_108_parentheses_around_a_single_word_i", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Halpern"), "(Halpern)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Withers"), "(Withers)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+140"), "(+140)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+176"), "(+176)")
])

problem_109_parentheses_around_a_single_word_ii = Problem("problem_109_parentheses_around_a_single_word_ii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "29"), "(29)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Honda"), "(Honda)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "B"), "(B)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "426"), "(426)")
])

problem_110_parentheses_around_a_single_word_iii = Problem("problem_110_parentheses_around_a_single_word_iii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Park"), "(Park)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "NY"), "(NY)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati"), "(Ducati)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lain"), "(Lain)")
])

problem_111_parentheses_around_a_single_word_iiii = Problem("problem_111_parentheses_around_a_single_word_iiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+155"), "(+155)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "986"), "(986)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+176"), "(+176)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Harvard"), "(Harvard)")
])

problem_112_parentheses_around_a_single_word_iiiii = Problem("problem_112_parentheses_around_a_single_word_iiiii", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Halpern"), "(Halpern)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Acura"), "(Acura)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "York"), "(York)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "68"), "(68)")
])

problem_113_parentheses_around_first_word = Problem("problem_113_parentheses_around_first_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "TX 33 Pennsylvania"), "(TX)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+108 29 95 +196 332"), "(+108)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "415 +115 484"), "(415)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "018 +176 Houston"), "(018)")
])

problem_114_parentheses_around_second_word = Problem("problem_114_parentheses_around_second_word", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "856 +138 424 Montiel"), "(+138)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Trinidad 311 33"), "(311)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "California 86"), "(86)"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "O Jeanice"), "(Jeanice)")
])

problem_115_parentheses_around_word_delimited_by = Problem("problem_115_parentheses_around_word_delimited_by", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Spagnoli Marquess Gertude"), "Spagnoli (Marquess) Gertude"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "94 Heintz Q"), "94 (Heintz) Q"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Honda250 Melodi +9-Kotas"), "Honda250 (Melodi) +9-Kotas"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => " California +104,Teddy"), " (California) +104,Teddy")
])

problem_116_parentheses_around_word_delimited_by_2 = Problem("problem_116_parentheses_around_word_delimited_by_2", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => ",551 Cencici 68"), ",(551) Cencici 68"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => ",Samuel Stefany.+185"), ",(Samuel) Stefany.+185"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "29,10 Stefany +158"), "29,(10) Stefany +158"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Dr,+104 45"), "Dr,(+104) 45")
])

problem_117_parentheses_around_word_delimited_by_3 = Problem("problem_117_parentheses_around_word_delimited_by_3", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => " +194-9"), " (+194)-9"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => " Reily-Withers,Urbana"), " (Reily)-Withers,Urbana"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => " Barbara-Mackenzie"), " (Barbara)-Mackenzie"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+151 Annalisa-Phillip-Pennsylvania"), "+151 (Annalisa)-Phillip-Pennsylvania")
])

problem_118_parentheses_around_word_delimited_by_4 = Problem("problem_118_parentheses_around_word_delimited_by_4", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => ".+197,64"), ".(+197),64"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "20.066,TX-Pannell"), "20.(066),TX-Pannell"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => ".DPhiladelphia,+132 G"), ".(DPhiladelphia),+132 G"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "476.47,017"), "476.(47),017")
])

problem_119_parentheses_around_word_delimited_by_5 = Problem("problem_119_parentheses_around_word_delimited_by_5", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "100,066,Annalisa"), "100,(066),Annalisa"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bess,994,Montiel"), "Bess,(994),Montiel"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => ",548,43"), ",(548),43"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+174,Bradford,University"), "+174,(Bradford),University")
])

problem_120_parentheses_around_word_delimited_by_6 = Problem("problem_120_parentheses_around_word_delimited_by_6", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Lain-Edison.C-Temple"), "Lain-(Edison).C-Temple"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "-Spell.Rowden Arbor"), "-(Spell).Rowden Arbor"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "9-Ducati125.976.Alida"), "9-(Ducati125).976.Alida"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "-Haven.80"), "-(Haven).80")
])

problem_121_ensure_suffix_andria = Problem("problem_121_ensure_suffix_andria", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Madelaine +189Andria"), "Madelaine +189Andria"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hornak 575 MA JacquilineAndria"), "Hornak 575 MA JacquilineAndria"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+68 +161 Heintz York"), "+68 +161 Heintz YorkAndria"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+13 20 +7"), "+13 20 +7Andria")
])

problem_122_ensure_suffix_997 = Problem("problem_122_ensure_suffix_997", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Marcus +108 Ramthun Rudolf"), "Marcus +108 Ramthun Rudolf997"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Hopkins 701 F"), "Hopkins 701 F997"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+163 +129997"), "+163 +129997"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Quashie Miah"), "Quashie Miah997")
])

problem_123_ensure_suffix_769 = Problem("problem_123_ensure_suffix_769", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "520 T769"), "520 T769"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati125 A Eccleston +198769"), "Ducati125 A Eccleston +198769"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+169 +163 +129 46"), "+169 +163 +129 46769"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Andria +140 Spell"), "Andria +140 Spell769")
])

problem_124_ensure_suffix_scalia = Problem("problem_124_ensure_suffix_scalia", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ducati250 HoustonScalia"), "Ducati250 HoustonScalia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ramthun Beata Chism FreeHaferScalia"), "Ramthun Beata Chism FreeHaferScalia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "UIUC 526"), "UIUC 526Scalia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Angeles T N"), "Angeles T NScalia")
])

problem_125_ensure_suffix_ramthun = Problem("problem_125_ensure_suffix_ramthun", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Bogle Miah Honda250 Trinidad"), "Bogle Miah Honda250 TrinidadRamthun"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ghoston Bobo Scalia Chism"), "Ghoston Bobo Scalia ChismRamthun"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Annalisa Latimore ChismRamthun"), "Annalisa Latimore ChismRamthun"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "107 CollegeRamthun"), "107 CollegeRamthun")
])

problem_126_ensure_suffix_568 = Problem("problem_126_ensure_suffix_568", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+194 517 Bobo568"), "+194 517 Bobo568"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+23 10 IL 844"), "+23 10 IL 844568"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "+47 P568"), "+47 P568"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "MD Hopkins 394"), "MD Hopkins 394568")
])

problem_127_ensure_suffix_columbia = Problem("problem_127_ensure_suffix_columbia", [
	IOExample(Dict{Symbol, Any}(:_arg_1 => "158 Quashie Hage"), "158 Quashie HageColumbia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "647 Seamons 40 Teddy"), "647 Seamons 40 TeddyColumbia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Ferrari250 +58 AndrewColumbia"), "Ferrari250 +58 AndrewColumbia"),
	IOExample(Dict{Symbol, Any}(:_arg_1 => "Cambridge MD 875 Ducati125"), "Cambridge MD 875 Ducati125Columbia")
])

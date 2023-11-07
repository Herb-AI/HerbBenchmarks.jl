# String primitives
primitive_empty_string = Dict(:name => "emptyString", :type => :tstring, :value => "")
primitive_uppercase = Dict(:name => "caseUpper", :type => [:tcharacter, :tcharacter], :value => uppercase)
primitive_strip = Dict(:name => "strip", :type => [:tstring, :tstring], :value => (s -> strip(s)))
primitive_lowercase = Dict(:name => "caseLower", :type => [:tcharacter, :tcharacter], :value => lowercase)
primitive_character_equal = Dict(:name => "char-eq?", :type => [:tcharacter, :tcharacter, :tboolean], :value => isequal)
primitive_char_upper = Dict(:name => "char-upper?", :type => [:tcharacter, :tboolean], :value => isuppercase)
primitive_str_equal = Dict(:name => "str-eq?", :type => [:tsring, :tstring, :tboolean], :value => (x, y -> x == y))
primitive_capitalize = Dict(:name => "caseCapitalize", :type => [:tstring, :tstring], :value => capitalize)
primitive_concatenate = Dict(:name => "concatenate", :type => [:tstring, :tstring, :tstring], :value => (*))

primitive_constant_strings = [
    Dict(:name => "','", :type => :tcharacter, :value => ','),
    Dict(:name => "'.'", :type => :tcharacter, :value => '.'),
    Dict(:name => "'@'", :type => :tcharacter, :value => '@'),
    Dict(:name => "SPACE", :type => :tcharacter, :value => ' '),
    Dict(:name => "'<'", :type => :tcharacter, :value => '<'),
    Dict(:name => "'>'", :type => :tcharacter, :value => '>'),
    Dict(:name => "'/'", :type => :tcharacter, :value => '/'),
    Dict(:name => "'|'", :type => :tcharacter, :value => '|'),
    Dict(:name => "'-'", :type => :tcharacter, :value => '-'),
    Dict(:name => "LPAREN", :type => :tcharacter, :value => '('),
    Dict(:name => "RPAREN", :type => :tcharacter, :value => ')'),
]


# Int primitives
primitive0 = Dict(:name => "0", :type => :tint, :value => 0)
primitive1 = Dict(:name => "1", :type => :tint, :value => 1)
primitiven1 = Dict(:name => "-1", :type => :tint, :value => 0-1)
primitive2 = Dict(:name => "2", :type => :tint, :value => 2)
primitive3 = Dict(:name => "3", :type => :tint, :value => 3)
primitive4 = Dict(:name => "4", :type => :tint, :value => 4)
primitive5 = Dict(:name => "5", :type => :tint, :value => 5)
primitive6 = Dict(:name => "6", :type => :tint, :value => 6)
primitive7 = Dict(:name => "7", :type => :tint, :value => 7)
primitive8 = Dict(:name => "8", :type => :tint, :value => 8)
primitive9 = Dict(:name => "9", :type => :tint, :value => 9)
primitive20 = Dict(:name => "ifty", :type => :tint, :value => 20)

primitive_addition = Dict(:name => "+", :type => [:tint, :tint, :tint], :value => ((x, y) -> x + y))
primitive_increment = Dict(:name => "incr", :type => [:tint, :tint], :value => (x -> 1+x))
primitive_decrement = Dict(:name => "decr", :type => [:tint, :tint], :value => (x -> x - 1))
primitive_subtraction = Dict(:name => "-", :type => [:tint, :tint, :tint], :value => (-))
primitive_negation = Dict(:name => "negate", :type => [:tint, :tint], :value => (x -> 0-x))
primitive_multiplication = Dict(:name => "*", :type => [:tint, :tint, :tint], :value => (*))
primitive_modulus = Dict(:name => "mod", :type => [:tint, :tint, :tint], :value => ((x, y) -> x % y))

primitive_apply = Dict(:name => "apply", :type => [:t1, (:t1, :t0), :t0], :value => (x, f) -> f(x))
primitive_true = Dict(:name => "true", :type => [:tboolean], :value => true)
primitive_false = Dict(:name => "false", :type => [:tboolean], :value => false)


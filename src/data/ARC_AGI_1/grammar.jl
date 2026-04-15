grammar_tilman = @cfgrammar begin
    Start = (state = Grid; returnState(state))
    InputGrid = initState(_arg_1)
    Return = returnState(state)

    Color = |(0:9)
    Pos = |(1:30)

    Grid = init_grid(3, 3)
    Grid = resize_grid(Grid, Pos, Pos)
    Grid = clone_grid(InputGrid)
    Grid = reset_grid(Grid)
    Grid = set_cell(Grid, Pos, Pos, Color)

    Grid = select_and_paste(Grid, Pos, Pos, Pos, Pos, Pos, Pos)
    Grid = select_and_paste(InputGrid, Pos, Pos, Pos, Pos, Grid, Pos, Pos)
    Grid = floodfill(Grid, Pos, Pos, Color)
end


grammar_hodel = @csgrammar begin    
    Grid = _arg_1

    Integer = |(1:30) # covers color and grid size

    Patch = Object | Indices
    Piece = Grid | Patch
    Element = Object | Grid
    Container = Grid | Object | Objects | Indices

    # Integer and IntegerTuple producers
    Integer = add(Integer, Integer)
    Integer = subtract(Integer, Integer)
    Integer = multiply(Integer, Integer)
    Integer = divide(Integer, Integer)
    Integer = invert(Integer)
    Integer = double(Integer)
    Integer = halve(Integer)
    Integer = increment(Integer)
    Integer = decrement(Integer)
    Integer = crement(Integer)
    Integer = signof(Integer)
    Integer = size_of(Container)
    Integer = maximum_of(IntContainer) 
    Integer = maximum_of(Grid) 
    Integer = minimum_of(IntContainer) 
    Integer = minimum_of(Grid) 
    Integer = lowermost(Patch)
    Integer = uppermost(Patch)
    Integer = rightmost(Patch)
    Integer = leftmost(Patch)
    Integer = height(Piece)
    Integer = width(Piece) 
    Integer = mostcolor(Element)
    Integer = leastcolor(Element)
    Integer = colorcount(Element, Integer)
    Integer = manhattan(Patch, Patch) 
    Integer = color(Object) 
    Integer = hperiod(Object)
    Integer = vperiod(Object)
    Integer = index(Grid, IntegerTuple)
    Integer = numcolors(Element)  

    IntegerTuple = add(IntegerTuple, IntegerTuple)
    IntegerTuple = add(Integer, IntegerTuple)
    IntegerTuple = subtract(IntegerTuple, IntegerTuple)
    IntegerTuple = subtract(Integer, IntegerTuple)
    IntegerTuple = multiply(IntegerTuple, IntegerTuple)
    IntegerTuple = multiply(Integer, IntegerTuple)
    IntegerTuple = divide(IntegerTuple, IntegerTuple)
    IntegerTuple = divide(Integer, IntegerTuple)
    IntegerTuple = divide(IntegerTuple, Integer)
    IntegerTuple = invert(IntegerTuple)
    IntegerTuple = double(IntegerTuple)
    IntegerTuple = halve(IntegerTuple)
    IntegerTuple = increment(IntegerTuple)
    IntegerTuple = decrement(IntegerTuple)
    IntegerTuple = crement(IntegerTuple)
    IntegerTuple = signof(IntegerTuple)
    IntegerTuple = toivec(Integer) 
    IntegerTuple = tojvec(Integer) 
    IntegerTuple = astuple(Integer, Integer)
    IntegerTuple = ulcorner(Patch) 
    IntegerTuple = urcorner(Patch) 
    IntegerTuple = llcorner(Patch) 
    IntegerTuple = lrcorner(Patch)
    IntegerTuple = center(Patch) 
    IntegerTuple = rel_position(Patch, Patch)
    IntegerTuple = gravitate(Patch, Patch) 
    IntegerTuple = centerofmass(Patch) 
    IntegerTuple = shape(Piece)

    # Higher-order funcs + usage
    ObjectToObjectFunc = normalize | hmirror | vmirror | dmirror | cmirror 
    ObjectToIntFunc = color | size_of | height | width | numcolors | leastcolor | mostcolor
    IndexToIndicesFunc = dneighbors | ineighbors | neighbors | vfrontier | hfrontier
    ObjectToIndicesFunc = toindices | corners | backdrop | delta | box | outbox | inbox
    GridToIntFunc = maximum_of | minimum_of | height | width | mostcolor | leastcolor | numcolors
    
    Objects = apply(ObjectToObjectFunc, Objects)
    IntContainer = apply(ObjectToIntFunc, Objects)
    Indices = mapply(IndexToIndicesFunc, Indices)
    Indices = mapply(ObjectToIndicesFunc, Objects)

    Object = argmax_by(Objects, ObjectToIntFunc)
    Object = argmin_by(Objects, ObjectToIntFunc)
    Grid = argmax_by(GridContainer, GridToIntFunc)
    Grid = argmin_by(GridContainer, GridToIntFunc)
    Objects = order_by(Objects, ObjectToIntFunc)
    Integer = valmax(Objects, ObjectToIntFunc)
    Integer = valmin(Objects, ObjectToIntFunc) 

    # Boolean producers: good for branch condition
    Boolean = portrait(Piece)
    Boolean = square(Piece)
    Boolean = vline(Piece) 
    Boolean = hline(Piece) 
    Boolean = contained(Integer, IntContainer)
    Boolean = contained(IntegerTuple, Indices)
    Boolean = contained(Object, Objects)

    Boolean = hmatching(Patch, Patch) 
    Boolean = vmatching(Patch, Patch) 
    Boolean = adjacent(Patch, Patch)
    Boolean = bordering(Patch, Grid) 
    Boolean = flip(Boolean) 
    Boolean = both(Boolean, Boolean) 
    Boolean = either(Boolean, Boolean)
    
    Boolean = equality(Integer, Integer) # equality() usefule for branch()
    Boolean = equality(IntegerTuple, IntegerTuple)
    Boolean = equality(Grid, Grid)
    Boolean = equality(Object, Object)

    ## shared core for combinators: Integer -> Boolean
    IntToBoolFunc = even
    IntToBoolFunc = positive
    IntToBoolFunc = x -> greater(x, Integer)

    ## shared core for combinators: Object -> Boolean
    ObjectToBoolFunc = portrait | square | vline | hline

    ## predicate combinators: take predicate function(s) and return a predicate function
    IntToBoolFunc = negate(IntToBoolFunc) 
    IntToBoolFunc = conjunct(IntToBoolFunc, IntToBoolFunc) 
    IntToBoolFunc = disjunct(IntToBoolFunc, IntToBoolFunc) 

    ObjectToBoolFunc = negate(ObjectToBoolFunc) 
    ObjectToBoolFunc = conjunct(ObjectToBoolFunc, ObjectToBoolFunc) 
    ObjectToBoolFunc = disjunct(ObjectToBoolFunc, ObjectToBoolFunc) 
    
    Boolean = IntToBoolFunc(Integer)
    Boolean = ObjectToBoolFunc(Object)

    # Grid producers
    Grid = rot90deg(Grid)
    Grid = rot180deg(Grid)
    Grid = rot270deg(Grid)
    Grid = downscale(Grid, Integer) 
    Grid = hconcat(Grid, Grid)
    Grid = vconcat(Grid, Grid)
    Grid = hupscale(Grid, Integer) 
    Grid = vupscale(Grid, Integer)    
    Grid = cellwise(Grid, Grid, Integer) 
    Grid = replace_color(Grid, Integer, Integer) 
    Grid = switch(Grid, Integer, Integer)
    Grid = trim(Grid) 
    Grid = tophalf(Grid)
    Grid = bottomhalf(Grid)
    Grid = lefthalf(Grid)
    Grid = righthalf(Grid)
    Grid = compress(Grid)
    Grid = canvas(Integer, IntegerTuple)
    Grid = subgrid(Patch, Grid)
    Grid = move(Grid, Object, IntegerTuple)
    Grid = cover(Grid, Patch) 
    Grid = crop(Grid, IntegerTuple, IntegerTuple) 
    Grid = fill_loc(Grid, Integer, Patch) 
    Grid = paint(Grid, Object)
    Grid = underfill(Grid, Integer, Patch) 
    Grid = underpaint(Grid, Object)  
    Grid = init(Integer)
    Grid = repeat_item(Grid, Integer)
    
 
    GridContainer = hsplit(Grid, Integer) # we need to be able to pick one (e.g., firstof(), extract, filter + merge, argmax/argmin + score)
    GridContainer = vsplit(Grid, Integer) 

    # Object/Objects
    ## Object(s) extraction from Grid
    Objects = objects(Grid, Boolean, Boolean, Boolean)
    Objects = partition(Grid)
    Objects = fgpartition(Grid)
    Objects = frontiers(Grid)

    ## Object/Patch/Piece/Element construction & transformation
    Object = recolor(Integer, Patch) 
    Object = toobject(Patch, Grid) 
    Object = asobject(Grid)
    Object = merge_containers(Objects)

    Patch = shift(Patch, IntegerTuple) 
    Patch = normalize(Patch)

    Piece = vmirror(Piece)
    Piece = hmirror(Piece)
    Piece = dmirror(Piece)
    Piece = cmirror(Piece)

    Element = upscale(Element, Integer)

    # Predicates & filtering
    IntPredicate = IntToBoolFunc
    ObjectPredicate = ObjectToBoolFunc
    GridPredicate = ObjectToBoolFunc

    IntContainer = sfilter(IntContainer, IntPredicate) 
    Objects = sfilter(Objects, ObjectPredicate) 
    Object = mfilter(Objects, ObjectPredicate)
    GridContainer = sfilter(GridContainer, GridPredicate) 
    Objects = sizefilter(Objects, Integer)
    Objects = colorfilter(Objects, Integer)

    # Set/collection operations
    Indices = intersection(Indices, Indices)
    Objects = intersection(Objects, Objects)
    Object = intersection(Object, Object)
    IntContainer = intersection(IntContainer, IntContainer)

    Indices = combine(Indices, Indices)
    Object = combine(Object, Object)
    Objects = combine(Objects, Objects)
    IntContainer = combine(IntContainer, IntContainer)

    Indices = difference(Indices, Indices)
    Object = difference(Object, Object)
    Objects = difference(Objects, Objects)
    IntContainer = difference(IntContainer, IntContainer)

    Indices = insert(IntegerTuple, Indices)
    Objects = insert(Object, Objects)
    IntContainer = insert(Integer, IntContainer)

    Indices = remove(IntegerTuple, Indices)
    Objects = remove(Object, Objects)
    IntContainer = remove(Integer, IntContainer)

    # Indices producers
    ## from Patch
    Indices  = toindices(Patch)
    Indices = inbox(Patch) 
    Indices = outbox(Patch) 
    Indices = box(Patch)
    Indices = corners(Patch)
    Indices = backdrop(Patch)
    Indices = delta(Patch) 

    ## from a location
    Indices = neighbors(IntegerTuple)
    Indices = dneighbors(IntegerTuple)
    Indices = ineighbors(IntegerTuple)
    Indices = vfrontier(IntegerTuple) 
    Indices = hfrontier(IntegerTuple)

    ## between two points
    Indices = connect(IntegerTuple, IntegerTuple) 
    Indices = shoot(IntegerTuple, IntegerTuple)
    Indices = pair(IntegerTuple, IntegerTuple)

    ## from Grid
    Indices = asindices(Grid) 
    Indices = ofcolor(Grid, Integer) 
    Indices = occurrences(Grid, Object)
    Indices = cartesian_product(IntContainer, IntContainer)

    # IntContainer producers
    IntContainer = interval(Integer, Integer, Integer)
    IntContainer = palette(Element) 

    # Deduplication and ordering
    Grid = dedupe(Grid)
    Indices = dedupe(Indices)
    Object = dedupe(Object) # probably not needed
    Objects = dedupe(Objects) # probably not needed
    IntContainer = dedupe(IntContainer)
    Objects = order(Objects)

    # Selection/extraction (of single elements from containers)
    Integer = mostcommon(IntContainer)
    IntegerTuple = mostcommon(Indices)
    Object = mostcommon(Objects) # probably not needed
    
    Integer = leastcommon(IntContainer)
    IntegerTuple = leastcommon(Indices)
    Object = leastcommon(Objects) # probably not needed

    IntegerTuple = firstof(Indices)
    Object = firstof(Objects)
    Integer = firstof(IntContainer)
    Grid = firstof(GridContainer)

    IntegerTuple = lastof(Indices)
    Object = lastof(Objects)
    Integer = lastof(IntContainer)
    Grid = lastof(GridContainer)

    IntegerTuple = other(IntegerTuple, Indices)
    Object = other(Object, Objects)
    Integer = other(Integer, IntContainer)

    Integer = extract(IntContainer, IntPredicate)
    Object = extract(Objects, ObjectPredicate)
    Grid = extract(GridContainer, GridPredicate)
  
    # Control flow (branch)  
    Integer = branch(Boolean, Integer, Integer)
    IntegerTuple = branch(Boolean, IntegerTuple, IntegerTuple)
    Object = branch(Boolean, Object, Object)
    Objects = branch(Boolean, Objects, Objects)
    Indices = branch(Boolean, Indices, Indices)
    Grid = branch(Boolean, Grid, Grid)
    # only most likely branch targets included
end






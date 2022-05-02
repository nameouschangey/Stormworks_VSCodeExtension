require("Parsing.parse")
local T = LBTokenTypes
local S = LBSymbolTypes

---@class VariableNamer
---@field i number
---@field firstChars string[]
---@field secondChars string[]
---@field existingVariables any
---@field current string
---@field next string
VariableNamer = {
    ---@param this VariableNamer
    new = function(this, existingVariables)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.firstChars = {"_", "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}

        this.secondChars = {"_", "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
        "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
        "0","1","2","3","4","5","6","7","8","9"}

        this.existingVariables = existingVariables or {}
        this.i = 1
        this.current = this:_generate(this.i)
        this.next = this:_generate(this.i + 1)
        return this
    end;

    peekNext = function(this)
        return this.next
    end;

    getNext = function(this)
        repeat
        this.current = this:_generate(this.i)
        this.next = this:_generate(this.i + 1)
        this.i = this.i + 1
        until not this.existingVariables[this.current]

        return this.current
    end;

    _generate = function(this, i)
        local lenFirst = #this.firstChars
        local result = {this.firstChars[((i-1) % lenFirst) + 1]}

        local covered = lenFirst
        local lenSecond = #this.secondChars
        while (i-1) // covered > 0 do
            result[#result+1] = this.secondChars[(((i-1) // covered) % lenSecond) + 1]
            covered = covered * lenSecond
        end

        return table.concat(result)
    end;
}

removeComments = function(tree)
    -- remove all comment elements
    treeForEach(tree,
        function(current)
            for i=#current,1,-1 do
                if current[i].type == T.COMMENT then
                    table.remove(current, i)
                end
            end
        end)

    combineConsecutiveWhitespace(tree)

    return tree
end;

convertHexadecimals = function(tree)
    treeForEach(tree,
        function(current)
            if current.type == T.HEX then
                current.type = T.NUMBER
                current.raw = tostring(tonumber(current.raw))
            end
        end)

    return tree
end;

-- convert IDENTIFIER -> EXT_IDENTIFIER where they are non-minifiable externals

classifyProtectedExternals = function(tree)
    treeForEach(tree,
    function(current)
        if current.type == S.EXPCHAIN then
            
        end
    end)
end;


shortenVariables = function(tree)
    -- shorten all identifiers that aren't externals
    -- do we want to protect every use of the word "maths" for example
    -- or only when it's the base word.
    -- only way it'd be a problem is if you'd assigned something to _ENV
    -- but that's on you if you do it, completely idiotic move
    -- as such we only care about the direct externals <blank>input.getNumber, etc.
    -- and the base also can't be changed <blank>input
    -- or better: we find all the base uses <blank>input, <blank>math etc.
    -- then find all children of that which are also protected and just protect them too

    -- we can also figure out if any of the base elements are being severely overused
    -- note: we do the chained elements first (e.g. each call to screen.drawTriangleF), then from that; make the screen. calls better themselves

    treeForEach(tree,
        function(current)
            if current.type == T.IDENTIFIER then
                current.type = T.NUMBER
                current.raw = tostring(tonumber(current.raw))
            end
        end)

    return tree
end;

findExternals = function(tree, externals)
    local identifiers = {}
    treeForEach(tree,
        function(current)
            if current.type == S.EXPCHAIN then
                local first = current[1]
                local external = externals[first.raw]
                if first and first.type == T.IDENTIFIER and external then
                    if external.second 
                    and not (current[2] and is(current[2].type, T.DOTACCESS, T.COLONACCESS)) 
                    and not (current[3] and current[3].type == T.IDENTIFIER) then
                        return
                    end

                    -- does no_minify mean we don't shorten globals used in that section?
                end
                
                identifiers[current.raw] = current
            end
        end)
    return identifiers
end;


-- what do we do if something uses e.g. a function
-- a.b.c.d().e.f = math - working back from what d() (can) return
-- could become quite a nightmare to parse through - finding everyway the variables are used
-- but could allow us to remove unused functions and code
-- a[1] pairs(a), all resolve the same -> a.ANY we don't try to figure out the index

-- the issue is in that chain, we need to find out what d() is
-- d might be defined elsewhere
-- what if d() is defined in a weird way as well
-- for EVERY variable use, we'd need to re-graph the whole thing
-- how do we fine the ORIGINAL creation of the value
-- including if it's unused
-- or do we start from each function definition -> go forward that way?

-- this seems entirely mental
-- language is "too" dynamic arguably

-- how does it work
-- we need some semi-recursive thing to do it

-- start with each assignment
-- the issue is pass-by-reference into functions 

-- start with all function definitions + the globals
findAllFunctionDefinitions = function(tree)
    local result = {}
    treeForEach(tree,
        function(current)
            if current.type == S.FUNCTIONDEF then
                result[current.raw] = current
            end
        end)
    return result
end;

-- 
findAllIdentifiers = function(tree)
    local identifiers = {}
    treeForEach(tree,
        function(current)
            if current.type == T.IDENTIFIER then
                identifiers[current.raw] = current
            end
        end)
    return identifiers
end;


findAllAssignments = function(tree)
    local result = {}
    treeForEach(tree,
        function(current)
            if current.type == S.ASSIGNMENT then
                result[current.raw] = current
            end
        end)
    return result
end;

reduceDuplicateLiterals = function(tree, variableNamer)
    reduceDuplicatesWhere(tree, variableNamer,
    function(val)
        return is(val.type, T.TRUE, T.FALSE, T.NIL, T.NUMBER, T.HEX, T.STRING)
    end)
end;

reduceDuplicateExternals = function(tree, variableNamer)
    -- this one is slightly harder
    -- we might have had a solution before, but not sure we do not
    -- all we're tracking are the fully qualified names
    -- but what happens if somebody does e.g. a = math
    -- a.min()
    -- we can't risk accidentally minifying the word "min"
    -- on the basic level, we can protect from just these names raw
    -- but on a better level, we should be looking at building the dependency graph

    -- duplicates that are special identifiers
    reduceDuplicatesWhere(tree, variableNamer, 
    function(val)
        return val.type == T.IDENTIFIER and isExternal(val.raw)
    end)
end;

reduceDuplicatesWhere = function(tree, variableNamer, condition)
    -- find how many of each number literal exists
    local found = {}
    treeForEach(tree,
        function(current)
            if condition(current) then
                found[current.raw] = found[current.raw] or {}
                found[current.raw][#found[current.raw]+1] = current
            end
        end)

    -- generate and make the replacmenets
    local nextVarLength = #variableNamer:peekNext()
    local variablesByValue = {}
    for rawValue, listOfElements in pairs(found) do
        -- +2 for the = and ; needed in the definition
        if nextVarLength + 2 + #rawValue + (nextVarLength*#listOfElements) < (#rawValue * #listOfElements) then
            local variableReplacement = variableNamer:getNext()
            
            variablesByValue[rawValue] = {type = listOfElements[1].type, replacement=variableReplacement}
            nextVarLength = #variableNamer:peekNext()

            -- replace the elements
            for i=1,#listOfElements do
                local element = listOfElements[i]
                element.type = T.IDENTIFIER
                element.raw = variableReplacement
            end
        end
    end

    -- add the shared variables to the top
    for value,variable in pairs(variablesByValue) do
        --raw=table.concat({variable,"=",number,";"})
        newVariable = {type=S.ASSIGNMENT,
                            {type=T.IDENTIFIER,     raw=variable.replacement},
                            {type=T.ASSIGN,         raw="="},
                            {type=variable.type,    raw=value},
                            {type=T.SEMICOLON,      raw=";"} }
        table.insert(tree, 1, newVariable)
    end

    return tree
end;


combineConsecutiveWhitespace = function(tree)
    -- remove all comment elements
    treeForEach(tree,
        function(current)
            for i=#current,2,-1 do
                if current[i].type == T.WHITESPACE and current[i-1].type == T.WHITESPACE then
                    current[i-1].raw = current[i-1].raw .. current[i].raw
                    table.remove(current, i)
                end
            end
        end)

    return tree
end;



shrinkWhitespaceBlocks = function(tree)
    local LBStr = LifeBoatAPI.Tools.StringUtils
    -- any whitespace surrounding certain operators can be stripped "for free"
    treeForEach(tree,
        function(current)
            if current.type == T.WHITESPACE then
                if LBStr.count(current.raw, "\n") > 0 then
                    current.raw = "\n"
                else
                    current.raw = " "
                end
            end
        end)

    return tree
end;

removeUnecessaryWhitespaceBlocks = function(tree)
    local stripWhitespace;
    stripWhitespace = function(t)
        for i=#t, 1, -1 do
            if t[i].type == T.WHITESPACE then
                table.remove(t, i)
            end
        end
    end;
    
    -- any whitespace surrounding certain operators can be stripped "for free"
    local lastNonWitespace = nil
    treeForEach(tree,
        function(current)
            if  (not lastNonWitespace) 
                or is(current.type, T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.OPENCURLY,  T.OPENBRACKET,  T.OPENSQUARE,  T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
                or is(lastNonWitespace.type,    T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.CLOSECURLY, T.CLOSEBRACKET, T.CLOSESQUARE, T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
                then
                stripWhitespace(current)
            end

            lastNonWitespace = (current.raw and current.type ~= T.WHITESPACE and current) or lastNonWitespace
        end)

    return tree
end;

treeForEach = function (tree, func)
    local foreachInTree;
    foreachInTree = function(subtree)
        for i=1,#subtree do
            foreachInTree(subtree[i])
            func(subtree[i])
        end
    end;
    foreachInTree(tree)
end
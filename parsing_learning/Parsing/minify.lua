require("Parsing.parse")
local T = LBTokenTypes
local S = LBSymbolTypes

-- macro stuff?


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

shortenVariables = function(tree)
end;

shortenExternalGlobals = function(tree)
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

--adds 4 character
-- meaning the number must be used enough that 4+(instances*2) < (length*instances)
-- minimum length is therefore 3, otherwise it cannot be shorter
-- and for 3 times, minimum instances is 4+(2*5) < (3*5)  14 < 15; need 5 instances of 3

-- if variable is 2, it's 3+(instances) < (length * instance)
-- length 2, 7 < 6

---@class VariableNamer
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

reduceDuplicates = function(tree, variableNamer, condition)
    -- find how many of each number literal exists
    local found = {}
    treeForEach(tree,
        function(current)
            if is(current.type, T.TRUE, T.FALSE, T.NIL, T.NUMBER, T.HEX, T.STRING) then
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

getSetOfAllIdentifiers = function(tree)
    local identifiers = {}
    treeForEach(tree,
        function(current)
            if current.type == T.IDENTIFIER then
                identifiers[current.raw] = true
            end
        end)
    return identifiers
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
                or is(current.type, T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.COMPARISON, T.OPENCURLY,  T.OPENBRACKET,  T.OPENSQUARE,  T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
                or is(lastNonWitespace.type,    T.BINARY_OP, T.COLONACCESS, T.DOTACCESS, T.MIXED_OP, T.UNARY_OP, T.COMPARISON, T.CLOSECURLY, T.CLOSEBRACKET, T.CLOSESQUARE, T.ASSIGN, T.STRING, T.COMMA, T.SEMICOLON, T.VARARGS)
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
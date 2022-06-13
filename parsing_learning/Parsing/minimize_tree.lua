require("Parsing.parse_symboltree")
local S = LBSymbolTypes
local T = LBTokenTypes

-- Makes it easier to remove or replace nodes
---@class ScopedTree
---@field parent ScopedTree
---@field parentIndex number
---@field symbol LBToken
---@field [number] ScopedTree
ScopedTree = {
    ---@param self ScopedTree
    ---@return ScopedTree
    newFromSymbol = function(self, symbol, parent, parentIndex)
        local this = {
            -- fields
            parent = parent,
            parentIndex = parentIndex,
            symbol = symbol,

            -- functions
            replaceSelf     = self.replaceSelf,
            sibling         = self.sibling,
            siblingsUntil   = self.siblingsUntil,
            next            = self.next,
            nextInstanceOf  = self.nextInstanceOf,
            nextUntil       = self.nextUntil
        }

        for i=1,#this.symbol do
            this[#this+1] = ScopedTree:newFromSymbol(this.symbol[i], this, i)
        end

        return this;
    end;

    is = function(this, ...)
        return is(this.symbol.type, ...)
    end;

    ---@param this ScopedTree
    ---@param replacementSymbol LBToken
    replaceSelf = function(this, replacementSymbol)
        this.parent.symbol[this.parentIndex] = replacementSymbol
    end;

    removeSelf = function(this)
        this:replaceSelf(LBToken:new(T.EMPTY, ""))
    end;

    ---@param this ScopedTree
    ---@return ScopedTree
    has = function(this, ...)
        for i=1, #this do
            if is(this[i].symbol.type, ...) then
                return this[i]
            end
        end
        return nil
    end;

    --- Enters the child chain, just *before* the first element
    --- Makes it easier to iterate the child nodes
    ---@param this ScopedTree
    ---@return ScopedTree
    getChildSiblingStart = function(this)
        if #this then
            return ScopedTree:newFromSymbol(LBToken:new("NONE"), this, 0)
        end
        return nil
    end;

    ---@param this ScopedTree
    ---@return ScopedTree
    next = function(this, i)
        i = i or 1
        if i == 0 then
            return this, 0
        else
            i = i - 1
            local found
            for iChildren=1, #this do
                found, i = next(this[iChildren], i)
                if i == 0 then
                    return found, 0
                end
            end
            return nil, i
        end
    end;

    ---@param this ScopedTree
    ---@return ScopedTree[]
    nextUntil = function(this, ...)
        local _nextUntil;
        _nextUntil = function(this, found, ...)
            if is(this.symbol.type, ...) then
                return found, true
            else
                found[#found+1] = this

                for iChildren=1, #this do
                    local childrenFound, wasFound = _nextUntil(this[iChildren], found, ...)

                    if wasFound then
                        return found, true
                    end
                end
                return found, false
            end
        end;

        local result = _nextUntil(this, {}, ...)

        -- clip off self from the front of the list, as we're only wanting the "next" stuff
        if #result > 1 then
            table.remove(result, 1)    
        end
        return result
    end;
    
    ---@param this ScopedTree
    ---@return ScopedTree
    nextInstanceOf = function(this, ...)
        if is(this.symbol.type, ...) then
            return this
        else
            local found
            for iChildren=1, #this do
                found = this[iChildren]:nextInstanceOf(...)
                if found then
                    return found
                end
            end
            return nil
        end
    end;

    ---@param this ScopedTree
    ---@return ScopedTree
    sibling = function(this, i)
        i = i or 1
        return this.parent[this.parentIndex + i]
    end;

    ---@param this ScopedTree
    ---@return ScopedTree[]
    siblingsUntil = function(this, ...)
        local siblings = {}
        for i=this.parentIndex+1, #this.parent do
            if not is(this.parent[i].symbol.type, ...) then
                siblings[#siblings+1] = this.parent[i]
            else
                return siblings, this.parent[i]
            end
        end
        return siblings, nil
    end;
}



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


Minimizer = {

    ---@param tree ScopedTree
    removeUnusedAssignments_byScope = function(tree)
        -- assign a local scope to each code block
        -- mark BASE uses (no table key checks)
        -- remove anything that wasn't used
        -- treat local a,b the same as local a,b = nil,nil
        -- an direct assignment a = 1 is NOT a use
        -- a table index, that results in an assignment, a.b = 1 IS a use of (a)
        -- we're only removing the base case

        -- this is different from the byIdentifierCount:
        --  it kills off locals quickly
        --  it respects the scope, so (a) in one scope, is NOT the same as (a) in another
        --  but it doesn't handle table keys at all, so we need to deal with that
    end;


    ---@param tree ScopedTree
    removeUnusedAssignments_byIdentifierCount = function(tree)
        
        -- count each identifier use, outside lvalues
        -- for lvalues we track everything except the *last* use, as it's being overwritten (so previous use doesnt matter)

        -- find all EXPCHAIN

        -- first identifier => base
        -- each subsequent identifier => table key

        -- means we can have <add> and <a.add> separate
        -- which is, a minor win at least?
    end;


    removeComments = function(tree)
        -- remove all comment elements
        Minimizer.treeForEach(tree,
            function(current)
                for i=#current,1,-1 do
                    if current[i].type == T.COMMENT then
                        table.remove(current, i)
                    end
                end
            end)

        Minimizer.combineConsecutiveWhitespace(tree)

        return tree
    end;

    convertHexadecimals = function(tree)
        Minimizer.treeForEach(tree,
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
        Minimizer.treeForEach(tree,
        function(current)
            if current.type == S.EXPCHAIN then
                
            end
        end)
    end;


    shortenVariables = function(tree)
        -- shorten all identifiers that aren't externals
        -- do we want to protect every use of the word "maths" for example
        Minimizer.treeForEach(tree,
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
        Minimizer.treeForEach(tree,
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

    findAllFunctionDefinitions = function(tree)
        local result = {}
        Minimizer.treeForEach(tree,
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
        Minimizer.treeForEach(tree,
            function(current)
                if current.type == T.IDENTIFIER then
                    identifiers[current.raw] = current
                end
            end)
        return identifiers
    end;


    findAllAssignments = function(tree)
        local result = {}
        Minimizer.treeForEach(tree,
            function(current)
                if current.type == S.GLOBAL_ASSIGNMENT then
                    result[current.raw] = current
                end
            end)
        return result
    end;

    reduceDuplicateLiterals = function(tree, variableNamer)
        Minimizer.reduceDuplicatesWhere(tree, variableNamer,
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
        Minimizer.reduceDuplicatesWhere(tree, variableNamer, 
            function(val)
                return val.type == T.IDENTIFIER and isExternal(val.raw)
            end)
    end;

    reduceDuplicatesWhere = function(tree, variableNamer, condition)
        -- find how many of each number literal exists
        local found = {}
        Minimizer.treeForEach(tree,
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
            newVariable = {type=S.GLOBAL_ASSIGNMENT,
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
        Minimizer.treeForEach(tree,
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
        Minimizer.treeForEach(tree,
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
        Minimizer.treeForEach(tree,
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
}
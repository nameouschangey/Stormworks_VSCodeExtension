require("Parsing.parse_symboltree")
local S = LBSymbolTypes
local T = LBTokenTypes

ValueTypes = {
    TABLE = "TABLE",
    FUNCTION = "FUNCTION",
    STRING = "STRING",
    NUMBER = "NUMBER",
    BOOL = "BOOL",
}
local V = ValueTypes

local K = {
    UNDEFINED_KEY = "__lbundefinedkeytype__",
    VALUE_KEY = "__lbvaluekeytype__",
    STRING_KEY = "__lbstringkeytype__"
}

---@class Value
---@field type string
---@field symbol LBToken
Value = {
    ---@return Value
    new = function(self, type, symbol)
        return {
            type = type,
            symbol = symbol
        }
    end;
}

--[[
    for globals and locals, we just want to track in the Scope "was this used"
    that's super easy
    we then just go back over every assignment and check "is this lvalue used in the scope, or not?" and if it's not - we remove it

    we don't care about any values OTHER than tables (inc. strings) and functions
        that's because they are pass by reference

    strings matter because they can have functions called on them...or does it matter?
    it feels kinda like they don't matter in the same way
        we're obviously not removing any of the string functions

    in fact all we need to track are:
        - tables
        - functions
        - which identifiers are "used" in each scope

    we can represent values as:
        - plain value
        - function
        - table
    
    in each Scope, we have a "ScopeValue"
        - isUsed
        - tableScopes
        - functionVals

    functionVals link back to the function def they're from, so we can run that function
        this part will be hard/a pain

    tableScopes are used anytime we do a.b or a:b
    
    return values from a function, is a list of ScopeValues (comma separated)
        this is for handling comma-separate assignments, annoyingly

    table.unpack - might be a pain?
        need to understand how it works better

    table[""] - maybe we don't care about these?
              - maybe we're only interested in the identifier string keys (won't remove the rest)
              - although what if you add functions in like this? nightmare maybe
              - each tableScope will have an additional key "__unknown__" that we use for now, to hold any/all of these indeterminate ones?
              - we're just plain restricting people from doing a = {hello = 123} => a["hello"]
    
    pairs is an obvious horror
        especially if pairs is assigned to something else, and then used
        we'll just have to handle it specially instead of it holding a symbol
]]

---@class FunctionValue
---@field symbol LBToken|string
---@field isSpecial boolean
FunctionValue = {
    ---@return ScopeValue
    new = function(self, symbol, isSpecial)
        return {
            isSpecial = isSpecial,
            symbol = symbol
        }
    end;
}

---@class ScopeValue : Value
---@field children table<string, ScopeValue>
---@field funcs table<string, FunctionValue>
---@field symbols LBToken[]
---@field isUsed boolean
ScopeValue = {
    ---@return ScopeValue
    new = function(self, symbol)
        return {
            children = {}, -- if this represents a table, these are the keys
            funcs = {}, -- combined list of any function that can exist for this table-like scope
            -- we don't care about regular vals, because they're meaningless, just whether or not they're used
            -- in future, we can extend to add constant folding, etc.
            isUsed = false,
            symbols = {symbol=true},

            -- functions
            getChildScope = self.getChildScope,
            assign = self.assign,
            checkIsUsed = self.checkIsUsed
        }
    end;

    ---@param self ScopeValue
    ---@return ScopeValue
    getChildScope = function(self, key)
        if not self.children[key] then
            self.children[key] = ScopeValue:new()
        end
        return self.children[key]
    end;

    ---@param self ScopeValue
    ---@param value ScopeValue
    assign = function(self, value)
        for k,v in pairs(value.symbols) do
            self.symbols[k] = v
        end
        -- combine in all the functions, table keys, etc.
        for k,v in pairs(value.funcs) do
            self.funcs[k] = v -- should be safe, as each function definition IS the key
        end

        for k,v in pairs(value.children) do
            if not self.children[k] then
                self.children[k] = v
            else
                self.children[k]:assign(k, v)
            end

            self.children[k].isUsed = self.children.isUsed or v.isUsed
        end
    end;

    ---@param self ScopeValue
    ---@param symbol LBToken
    checkIsUsed = function(self, symbol)
        if self.symbols[symbol] then
            return true
        else
            for k,v in self.children do
                if v:checkIsUsed(symbol) then
                    return true
                end
            end
        end
        return false
    end;
}

---@class Scope
---@field parent Scope
---@field locals ScopeValue
---@field _ENV ScopeValue collection of all the values _ENV can be (can be not a table too)
Scope = {
    ---@param self Scope
    ---@return Scope
    new = function(self)
        local scope = {
            parent = nil,
            locals = ScopeValue:new(),
            _ENV = ScopeValue:new(), -- env itself can be redefined, which would be a real PITA

            --functions
            get = self.get,
            addLocal = self.addLocal,
            newChildScope = self.newChildScope
        }
        return scope
    end;

    ---@param self Scope
    ---@return Scope
    newChildScope = function(self)
        local scope = {
            parent = self,
            locals = ScopeValue:new(),

            --functions
            get = self.get,
            addLocal = self.addLocal,
            newChildScope = self.newChildScope
        }
        return scope
    end;

    -- note, expected use is:
    --  e.g. a.b.c = 123  => get(a).get(b).set(c, 123)
    --  or,  a = 123      => set(a, 123)
    ---@param self Scope
    ---@param key string
    ---@return ScopeValue
    get = function(self, key)
        if self.locals[key] then
            return self.locals[key]
        elseif self.parent then
            return self.parent:get(key)
        end

        -- no parent, so is a global from _ENV
        if key == "_ENV" then
            return self._ENV -- request for the _ENV table directly
        else
            return self._ENV:getChildScope(key)
        end
    end;

    ---@param self Scope
    addLocal = function(self, key)
        self.locals:getChildScope(key) -- creates the key if not existent
    end;

    ---@param self Scope
    ---@param symbol LBToken
    checkIsUsed = function(self, symbol)
        for k,v in pairs(self.locals) do
            if v:checkIsUsed(symbol) then
                return true
            end
        end

        if self.parent and self.parent:checkIsUsed(symbol) then
            return true
        else
            return self._ENV:checkIsUsed(symbol)
        end
    end;
}


-- the reason we want this, over the other one?
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



---@param scope Scope
---@param tree ScopedTree
walkBody = function(tree, scope)
    ---@type ScopeValue[]
    local returnValues = {}

    for i=1,#tree do
        local node = tree[i]
        if is(node.symbol.type, S.GLOBAL_ASSIGNMENT) then
            -- some variable is being set in some scope
            resolveAssignmentChain(node, scope)

        elseif is(node.symbol.type, S.EXPCHAIN) then
            resolveExpChain(node, scope)

        elseif is(node.symbol.type, S.GLOBAL_NAMEDFUNCTIONDEF) then
            -- some variable is being set in some scope
            resolveNamedFunctionDef(node, scope)

        elseif is(node.symbol.type, S.LOCAL_NAMEDFUNCTIONDEF) then
            -- some variable is being set in some scope
            resolveLocalNamedFunctionDef(node, scope)

        elseif is(node.symbol.type, S.LOCAL_ASSIGNMENT) then
            -- some variable is being set in some scope
            resolveLocalAssignmentChain(node, scope)

        elseif is(node.symbol.type, S.IF_STATEMENT) then

        elseif is(node.symbol.type, S.FOR_LOOP, S.WHILE_LOOP, S.REPEAT_UNTIL, S.DO_END) then
            -- new local scope
            walkBody(node, scope:newChildScope())

        elseif is(node.symbol.type, S.RETURNSTATEMENT) then
            -- add the return values to the things we're returning
            local vals = resolveReturnStatement(node, scope)
            for i=1,#vals do
                returnValues[i] = returnValues[i] or ScopeValue:new()
                returnValues[i]:assign(vals[i])
            end
        end
    end

    return returnValues
end;

resolveExpChain = function(tree, scope)
    for i=1,#tree do
        local child = tree[i]
        if is(child.symbol.type, S.EXPCHAIN) then
            resolveExpChain(child, scope) -- ignore the return value
        end
        resolveExpChain(child)
    end
end;


-- walk means "run through these"
-- resolve means "get me the return type"?
-- do we need it for everything?
-- is an operator chain still needed?

-- why are we handling named functs differently from each other


-- resolves the value type for inner square brackets
---@param tree ScopedTree
---@return Value
getKeyFromSquareBrackets = function (tree, scope)
    local innerSymbol = tree:next(2)
    if innerSymbol:is(T.STRING) then
        return innerSymbol.symbol.stringContent

    elseif innerSymbol:is(S.STRINGCHAIN) then
        return K.UNDEFINED_KEY -- could be any string key

    elseif innerSymbol:is(S.NUMCHAIN, T.NUMBER, S.BOOLCHAIN, T.TRUE, T.FALSE) then
        return K.VALUE_KEY

    else
        local resolvedValues = resolveValueElement(innerSymbol, scope)

        -- if we end up with *just* value types, then we're ok
        -- if we end up with unreliable types, then we're 
        if resolvedValues:isHomogenous() then
            -- something
        else
            return K.UNDEFINED_KEY
        end
    end
end

---@param scope Scope
---@param tree ScopedTree
resolveNamedFunctionDef = function(tree, scope)
    -- sets variable value to the function
    local functionKeyword = tree:nextInstanceOf(T.FUNCTION)
    local identchain = functionKeyword:siblingsUntil(S.FUNCTIONDEF_PARAMS)

    -- note, in named functions identchain is always just identifiers + (./:) access, no expression
    local isSelf = #identchain > 1 and identchain[#identchain-1].symbol.type == T.COLONACCESS

    -- this is the actual variable (if it's a chain, this must be a table)
    local baseVariable = scope:get(identchain[1].symbol.raw)
    for i=2,#identchain do
        local ident = identchain[i]
        if ident.symbol.type == T.IDENTIFIER then
        elseif ident.symbol.type == T.DOTACCESS then
        elseif ident.symbol.type == S.SQUARE_BRACKETS then
            local key = getKeyFromSquareBrackets(ident)
        end
    end


    if baseVariable.is(V.TABLE) then
        local tableVals = baseVariable.valuesOfType(V.TABLE) -- TODO: write a wrapper that avoids insane duplication (lots of inner loops)
        
        -- we kind of need to branch here, for each variable that's in the table; no?
        -- or we need to handle this in a more sensible way somehow
        -- we can't force type checking, if we don't know for sure what value is in this
        -- or do we handle tables as just another scope?
        -- and variables like some kind of chainable thing?
        -- or we keep it "simple" and concat the names, into the global table?
        -- so everything is still a flat style value
        -- the issue, is putting that all back together

        -- on table definitions, we need to make a new table
        -- we need to share the instance of that table/find where it's used etc.
        local vars = tableVals:get()
        for i=3, #identchain,2 do
            if identchain[i].symbol.type == T.IDENTIFIER then
    
            end
        end

    else
        if #identchain > 1 then
            error("cannot use . notation on non-table value " .. baseVariable.name)
        end


    end
end;

---@param scope Scope
---@param tree ScopedTree
resolveLocalNamedFunctionDef = function(tree, scope)
    -- sets variable value to the function
    local functionKeyword = tree:nextInstanceOf(T.FUNCTION)
    local identifier = functionKeyword:nextInstanceOf(T.IDENTIFIER)

    local identname = identifier.symbol.raw
    local variable = scope:newLocal(identname)

    variable:assign("FUNCTIONDEF", tree)
end;

resolveValueElement = function(tree, scope)
    local valueCollection = ValueCollection:new()
    if is(tree.symbol.type, S.BOOLCHAIN) then
        valueCollection[#valueCollection+1] = Value:new(V.BOOL, tree.symbol)
        walkSideEffectsOnly(tree, scope)

    elseif is(tree.symbol.type, S.NUMCHAIN) then
        valueCollection[#valueCollection+1] = Value:new(V.NUMBER, tree.symbol)
        walkSideEffectsOnly(tree, scope)

    elseif is(tree.symbol.type, S.STRINGCHAIN) then
        valueCollection[#valueCollection+1] = Value:new(V.STRING, tree.symbol)
        walkSideEffectsOnly(tree, scope)

    end
end;

---@param tree ScopedTree
resolveOrChain = function(tree, scope)
    local returnValues = ValueCollection:new()

    -- right now we just assume all the branches could be true
    -- in future, could add it that we check if the condition can't possibly be true?
    -- maybe all this was a bit of a silly endeavor
    for i=1,#tree, 2 do
        local child = tree[i]
        local returnVal = resolveValueElement(child)
        returnValues:combine(returnVal)
    end
    return returnValues
end;

---@param tree ScopedTree
resolveAndChain = function(tree, scope)
    local returnValues = ValueCollection:new()

    for i=1,#tree, 2 do
        local child = tree[i]
        local returnVal = resolveValueElement(child)
        returnValues:combine(returnVal)
    end
    return returnValues
end;

--- function calls, a.b.c():def() etc.
---@param tree ScopedTree
resolveExpChain = function(tree, scope)
    local returnValues = ValueCollection:new()

    for i=1,#tree, 2 do
        local child = tree[i]
        local returnVal = resolveValueElement(child)
        returnValues:combine(returnVal)
    end
    return returnValues
end;



---@param scope Scope
---@param tree ScopedTree
resolveAssignmentChain = function(tree, scope)
    -- sets variable value
    local lvalues = tree:nextUntil(T.ASSIGN)
end;

---@param scope Scope
---@param tree ScopedTree
resolveLocalAssignmentChain = function(tree, scope)
    -- sets variable value
    local identChain = tree:nextInstanceOf(T.LOCAL):siblingsUntil(T.ASSIGN)

    local variablesToAssign = {}
    for i=1,#identChain do
        if identChain[i].symbol.type == T.IDENTIFIER then
            local identName = identChain[i].symbol.raw
            variablesToAssign[#variablesToAssign+1] = scope:newLocal(identName)
        end
    end

    local assign = identChain[#identChain]:nextInstanceOf(T.ASSIGN)
    if assign then
        local rvalues = identChain:siblingsUntil()

    end
end;

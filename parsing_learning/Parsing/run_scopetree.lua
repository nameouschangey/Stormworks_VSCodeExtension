require("Parsing.parse_symboltree")
local S = LBSymbolTypes
local T = LBTokenTypes
--[[
bit confused about how we should be handling these symbols etc.
    - should we be handling each one

    - what about values created from operator-chains
    - and expression-chains
    - it becomes a nightmare doesn't it

    - what are we even trying to do?
    - are we just trying to mark when things are used?
    - do we care about any type of value other than table? maybe?
    - string table is the only built-in we need to care for ("hello"):(a,b,c)

    - the thing we're trying to find, is whether any functions aren't use
    - and if any tables aren't used?
    - any assignments unused?

    - the unused assignments is what we want
    - because then we can just remove them entirely
    - the issue is, what about circular references; a = 1, b = a, a = b - not "needed"
    - - but just doing that will resolve that both variables are used, despite them having the same values
    - - an operator chain just creates one value

    - is an expression chain a value?
    - no, we need to resolve each part

    - similarly, we need to resolve every part of the operator chain, if it contains any function-calls

    - but the "value" that comes out of it, is the operator-chain itself
    - the type of value, we can somehow resolve?

    
]]

ValueTypes = {
    TABLE = "TABLE",
    STRING = "STRING",
    FUNCTION = "FUNCTION",
    NUMBER = "NUMBER",
    BOOL = "BOOL",
    NIL = "NIL" -- even though "nil" isn't really a value, anthing that's only nil at the end can kinda be killed
}
local V = ValueTypes

---@class Value
---@field type string
---@field symbol LBToken
Value = {
    new = function(this, type, symbol)
        return {
            type = type,
            symbol = symbol
        }
    end;
}

local ANYNUMBER = "ANYNUMBER"

---@class TableValue : Value
---@field fields Variable[]
TableValue = {
    new = function(this, symbol)
        return {
            type = V.TABLE,
            symbol = symbol,
            fields = {}
        }
    end;

    get = function(this, name)
        if this.fields[name] then
            return this.fields[name]
        end
    end;
}

---@class Variable
---@field name string
---@field scope Scope
---@field isLocal boolean
---@field possibleValues Value[]
Variable = {
    new = function(this, name, scope, isLocal)
        return {
            name = name,
            scope = scope,
            isLocal = isLocal,
            possibleValues = {},

            -- functions
            assign = this.assign
        }
    end;

    valuesOfType = function(this, ...)
        local values = {}
        for i=1, #this.possibleValues do
            if is(this.possibleValues[i].type, ...) then
                values[#values+1] = this.possibleValues[i]
            end
        end
        return values
    end;

    is = function(this, ...)
        for i=1, #this.possibleValues do
            if is(this.possibleValues[i].type, ...) then
                return true
            end
        end
        return false
    end;

    assign = function(this, value)
        this.possibleValues[#this.possibleValues+1] = value
    end;
}

---@class Scope
---@field parent Scope
---@field locals table<string,Variable>
---@field globals table<string,Variable>
Scope = {
    ---@param this Scope
    ---@return Scope
    new = function(this)
        return {
            parent = nil,
            locals = {},
            globals = {},

            --functions
            newLocal = this.newLocal,
            get = this.get,
        }
    end;

    ---@param this Scope
    ---@return Scope
    newChildScope = function(this)
        local scope = {
            parent = this,
            locals = {},
            globals = this.globals or {},

            --functions
            newLocal = this.newLocal,
            get = this.get,
        }

        this[#this+1] = scope
        return scope
    end;

    ---@param this Scope
    ---@param name string
    ---@return Variable
    newLocal = function(this, name)
        local var = Variable:new(name, this, true)
        this.locals[var.name] = var
        return var
    end;

    ---@param this Scope
    ---@param name string
    ---@return Variable
    get = function(this, name)
        if this.locals[name] then
            return this.locals[name]
        elseif this.parent then
            local upvalue = this.parent:get(name)
            if upvalue then
                return upvalue
            end
        end

        local global = this.globals[name] -- or nil
        if global then
            return global
        else
            global = Variable:new(name, this, false)
            this.globals[name] = global
            return global
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
    ---@param this ScopedTree
    ---@return ScopedTree
    newFromSymbol = function(this, symbol, parent, parentIndex)
        local this = {
            -- fields
            parent = parent,
            parentIndex = parentIndex,
            symbol = symbol,

            -- functions
            replaceSelf     = this.replaceSelf,
            sibling         = this.sibling,
            siblingsUntil   = this.siblingsUntil,
            next            = this.next,
            nextInstanceOf  = this.nextInstanceOf,
            nextUntil       = this.nextUntil
        }

        for i=1,#this.symbol do
            this[#this+1] = ScopedTree:newFromSymbol(this.symbol[i], this, i)
        end

        return this;
    end;

    ---@param this ScopedTree
    ---@param replacementSymbol LBToken
    replaceSelf = function(this, replacementSymbol)
        this.parent.symbol[this.parentIndex] = replacementSymbol
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
resolveBody = function(tree, scope)
    local returnValues = {}

    for i=1,#tree do
        local val = tree[i]
        if is(val.symbol.type, S.GLOBAL_ASSIGNMENT) then
            -- some variable is being set in some scope
            resolveAssignmentChain(val, scope)

        elseif is(val.symbol.type, S.GLOBAL_NAMEDFUNCTIONDEF) then
            -- some variable is being set in some scope
            resolveNamedFunctionDef(val, scope)

        elseif is(val.symbol.type, S.LOCAL_NAMEDFUNCTIONDEF) then
            -- some variable is being set in some scope
            resolveLocalNamedFunctionDef(val, scope)

        elseif is(val.symbol.type, S.LOCAL_ASSIGNMENT) then
            -- some variable is being set in some scope
            resolveLocalAssignmentChain(val, scope)

        elseif is(val.symbol.type, S.FOR_LOOP, S.IF_STATEMENT, S.WHILE_LOOP, S.REPEAT_UNTIL, S.DO_END) then
            -- new local scope
            --returnValues:combine(resolveBody(val, scope:branch()))
        elseif is(val.symbol.type, T.RETURN) then
            -- add the return values to the things we're returning
        end
    end

    return returnValues
end;

--[[
if we branch each time, then we only have 1 value per variable
    but...doesn't that make some things less reliable?
    what happens to functions with and/or, do we need to branch each of those too?
    we'd potentially get multiple warnings for each statement
        the benefit is something or other?
    it may also be a significantly less productive way to do things
        BUT it means if we ever found unreachable branches, that could be doable.

    how do we handle side-effects?
        just naturally?

    how do we handle recursion?
    
    what about branches that wouldn't ever *actually* happen?

    let's give it a try, it might be easier?
    every and & or statement either needs resolved or branched
    
    conditionals can be "skipped"?

    if we handle "multiple vals" then in many ways easier?

    +/-/^ etc. all just generate numbers

    conditionals always create bools

    it's a BIG can of worms

    are the simplifications making life easier or harder?

    the and, or, is a right pain (not can be ignored, it's just a modifier)
    resolve and before or
    why is ^ higher priority than unary?
]]



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

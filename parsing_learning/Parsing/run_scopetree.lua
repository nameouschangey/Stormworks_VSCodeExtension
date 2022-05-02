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

---@class Value
---@field type string
---@field symbol LBSymbol
Value = {
    new = function(this, type, symbol)
        this.type = type
        this.symbol = symbol
    end;
}



-- how does this even work?
-- do we just find every lvalue and that's a variable?
-- even local a; is an "assignment" of sorts, but assigns the value nil

-- the main thing is we 1) need to parse the symbol tree into a scoped tree
-- we then need to run through the code line by line, as if we were running it
--  and just handle each type of statement

-- we need some way to handle branching the execution
-- so every ifstatement runs both ways, etc.
-- if we even need that, because we just have "possible values"
-- and operator_chains resolve into a list of possibles, not one type
-- same with most things; we're not trying simplify dead code, just uncalled "library" code
-- we're not try to figure out if a conditional is try or not



---@class Variable
---@field scope Scope
---@field isLocal boolean
---@field possibleValues Value[]
Variable = {
    new = function(this, name, scope, isLocal)
        this.name = name
        this.scope = scope
        this.isLocal = isLocal
        this.possibleValues = {}
    end;

    assign = function(this, value)
        this.possibleValues[value.identifier] = value
    end;
}

---@class Scope
---@field parent Scope
---@field locals table<string,Variable>
---@field globals table<string,Variable>
Scope = {
    new = function(this, parent)
        this.parent = parent
        this.locals = {}
        this.globals = parent and parent.globals or {}
    end;

    newLocal = function(this, name)
        local var = Variable:new(name, this, true)
        this.locals[var.name] = var
        return var
    end;

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
---@field symbol LBSymbol
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
            replaceSelf = this.replaceSelf,
            sibling = this.sibling,
            siblingsUntil = this.siblingsUntil,
            next = this.next,
            nextUntil = this.nextUntil
        }

        for i=1,#this.symbol do
            this[#this+1] = ScopedTree:newFromSymbol(this.symbol[i], this, i)
        end

        return this;
    end;

    ---@param this ScopedTree
    ---@param replacementSymbol LBSymbol
    replaceSelf = function(this, replacementSymbol)
        this.parent.symbol[this.parentIndex] = replacementSymbol
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
    ---@return ScopedTree
    nextUntil = function(this, ...)
        if is(this.symbol.type, ...) then
            return this
        else
            local found
            for iChildren=1, #this do
                found = next(this[iChildren])
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
    ---@return ScopedTree
    siblingsUntil = function(this, ...)
        local siblings = {}
        for i=this.parentIndex+1, #this.parent do
            if not is(this.parent[i].symbol.type, ...) then
                siblings[#siblings+1] = this.parent[i]
            else
                return siblings
            end
        end
        return siblings
    end;
}


deepCopyTree = function(tree)
    local result = {}
    for k,v in pairs(tree) do
        if type(v) == "table" then
            result[k] = deepCopyTree(v)
        end
        result[k] = v
    end
    return result
end;


-- useful for being able to remove items from the tree
addParentRelationships = function(tree, parent)
    tree.parent = parent

    tree.replaceSelf = function(this, replacement)
        for i=1,#this.parent do
            if this.parent[i] == this then
                this.parent[i] = replacement
                return
            end
        end
    end;

    for i=1,#tree do
        tree[i].parentIndex = i
        addParentRelationships(tree[i])
    end
end;

-- what's the point in this?
createScopeTree = function(tree, currentScope)
    currentScope = currentScope or Scope:new()

    local result = {}
    result.symbol = tree
    result.scope = currentScope
    result.timesCalled = 0

    for i=1,#tree do
        if is(tree[i].type, S.FUNCTIONDEF, S.IF_STATEMENT, S.DO_END, S.WHILE_LOOP, S.FOR_LOOP, S.REPEAT_UNTIL) then
            -- new scope
            result[#result+1] = createScopeTree(tree[i], Scope:new(currentScope))
        end
    end

    return result
end;

---@param scope Scope
---@param tree ScopedTree
walkScopeTree = function(tree, scope)
    scope = scope or Scope:new()

    for i=1,#tree do
        local val = tree[i]
        if is(val.symbol.type, S.ASSIGNMENT) then
            -- some variable is being set in some scope
            resolveAssignmentChain(val, scope)

        elseif is(val.symbol.type, S.NAMEDFUNCTIONDEF) then
            -- some variable is being set in some scope
            resolveNamedFunction(val, scope)
            
        elseif is(val.symbol.type, S.FOR_LOOP, S.IF_STATEMENT, S.WHILE_LOOP, S.REPEAT_UNTIL, S.DO_END) then
            -- new local scope
            walkScopeTree(val, Scope:new(scope))
        end
    end
end;

---@param scope Scope
---@param tree ScopedTree
resolveNamedFunction = function(tree, scope)
    -- sets variable value to the function
    local isLocal = tree:next().symbol.type == T.LOCAL

    local functionKeyword = tree:nextUntil(T.FUNCTION)
    local identifiers = functionKeyword:siblingsUntil(S.FUNCTIONDEF_PARAMS)

    local isSelf = identifiers[#identifiers-1].symbol.type == T.COLONACCESS

    for i=1, #identifiers do
        local variable = scope:get(identifiers[i].symbol.token.raw)
    end
end;

resolveAssignmentChain = function(symbol, scope)
    -- sets variable value
end;

-- this is so much damn work
-- all we're trying to do is handle some real basic shit





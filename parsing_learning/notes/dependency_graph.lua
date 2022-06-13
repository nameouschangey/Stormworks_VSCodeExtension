--[[
notes:

each element that is created: literals, function defs, table defs
some of these have a limited scope, but ignoring that means more things depending on each other than expected
- it just makes minification less efficient; fundamentally things are still true

each name is a field in a table
_ENV is the first table
potentially/arguably a local table in each function

we're trying to find how these tables depend on each other

some functions do things that make us uncertain - e.g. pairs
- in those cases, we will have to assume every key of every type is affected



what are the nodes:
primary nodes/scopes are the tables?

or is it the functions?

the functions, are fixed - they have sets of instructions in them, that makes sense

each function - links to other functions
we can keep going until we've resolved every function - and then kill the unlinked ones
via variable names, is the way that functions are stored and called and stuff
]]

-- remember, we also have closures
-- so need some kind of Scope object to be passed around, for local scopes

FunctionDef = {
    new = function(this, parentScope)
        
    end;
}

-- a function definition is what we want to remove if it's never called from anywhere
-- everything else is slightly redundant no?
-- table definitions & function defs, we need to track what variables they're assigned to
-- and that way we can figure out whether they're ever actually called
-- if not called, we can safely remove them, no?
--   does technically remove the ability to use the function variable as a "does this exist" kind of thing
--   do we need to add an lbtag for "always assume this is totally fine" or something?

-- this all needs to happen after the pre-processor though

Variable = {
    new = function(this, scope, islocal)
        this.scope = scope
        this.islocal = islocal
        this.possibleValues = {}
    end;

    assign = function(this, value)
        this.possibleValues[value.identifier] = value
    end;
}

Scope = {
    new = function(this, parent)
        this.parent = parent
        this.locals = {}
        this.globals = parent.globals or {}
    end;

    newLocal = function(this)
    end;
}

getAllRootStatements = function(tree)
end;

--1 get all "nodes"
createDependencyGraph = function(tree)
    root = "_ENV"

    for statement in getAllRootStatements() do
        if statement.type == ASSIGNMENT then
            local variableAssignedInto = statement.lvalue
            local possibleValuesBeingAssigned = ResolveExpressionChain(statement.rvalue)
        elseif statement.type == FUNCTION_CALL then
            resolveFunctionCall(statement)
        end
    end
end

-- or is everything a table
-- or are there two simultaneous kinds of things happening

-- assignments are a key example of things
-- function defs matter, in so far as they determine locality when locals are used
-- could do some restructuring to make it easier to parse

-- but effectively
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

--1 get all "nodes"
createDependencyGraph = function(tree, rootTable)
    root = rootTable or "_ENV"
    root = "_ENV"

    for statement in getAllRootStatements do
        if statement == ASSIGNMENT then
            
        end
    end
end

-- or is everything a table
-- or are there two simultaneous kinds of things happening

-- assignments are a key example of things
-- function defs matter, in so far as they determine locality when locals are used
-- could do some restructuring to make it easier to parse

-- but effectively
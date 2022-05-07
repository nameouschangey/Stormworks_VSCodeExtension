a = {}

function abc(val)
    a[#a+1] = val
    return val
end;

local b = false and abc(1) or abc(2) and (2 ^ abc(5) + abc(3) + abc(4))

-- because and and or are the lowest, we can split the chain at each of those
-- so we evaluate left-side of and, then right side of and
-- left side of or, and ONLY right side of or IF it's not true
-- everything else is quite straight forward, ish

-- above, we would parse the chain upto the first "or"
-- we then resolve the left side, splitting on "and"
-- resolve each of the left and right side of each and condition?

-- splitting on "or" is the right thing to do
-- then resolving each section and "and" as it short-circuits too



---@param tree ScopedTree
function resolveOperatorChain(tree)
    local orBlocks = {}
    for i=1,#tree do
        local node = tree[i]
        if not node.symbol.type == T.
    end
end;

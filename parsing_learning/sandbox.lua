
func = function(a,b)
    return a,b
end;

-- multiple returns is the real danger
-- the last expression in the chain can expand to provide however many values
-- could really be a nightmare

-- this is all such a horrible idea

local a,b,c = 1,func(5,6)

print(a,b,c)
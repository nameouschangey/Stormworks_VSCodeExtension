LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.MaxSafeInt = 16777216
LifeBoatAPI.MinSafeInt = -16777216
LifeBoatAPI.__instanceid1 = LifeBoatAPI.MinSafeInt
LifeBoatAPI.__instanceid2 = LifeBoatAPI.MinSafeInt

--- instantiates the given class table
--- requires previous call to LifeBoatAPI.setupClass
--- underwrites each value from class into the new instance obj
--- uses the __classkeys lookup to avoid calls to pairs() => calls to next() => *EXTREMELY slow*
LifeBoatAPI.instantiate = function(class, obj)
    obj = LifeBoatAPI.newTable(obj)

    for i=1, #class.__classkeys do
        local key = class.__classkeys[i]
        if obj[key] == nil then
            obj[key] = class[key]
        end
    end
    
    -- generate a UID for persistence loading later
    LifeBoatAPI.__instanceid1 = LifeBoatAPI.__instanceid1 + 1
    if LifeBoatAPI.__instanceid1 >= LifeBoatAPI.MaxSafeInt then
        LifeBoatAPI.__instanceid1 = LifeBoatAPI.MinSafeInt
        LifeBoatAPI.__instanceid2 = LifeBoatAPI.__instanceid2 + 1
    end
    obj.__instanceid1 = LifeBoatAPI.__instanceid1
    obj.__instanceid2 = LifeBoatAPI.__instanceid2

    return obj
end

LifeBoatAPI.newTable = function (tbl)
    tbl = tbl or {}

    -- duplicate of code above, we manually inline it line this to avoid an extra function call per instantiation
    LifeBoatAPI.__instanceid1 = LifeBoatAPI.__instanceid1 + 1
    if LifeBoatAPI.__instanceid1 >= LifeBoatAPI.MaxSafeInt then
        LifeBoatAPI.__instanceid1 = LifeBoatAPI.MinSafeInt
        LifeBoatAPI.__instanceid2 = LifeBoatAPI.__instanceid2 + 1
    end
    
    tbl.__instanceid1 = LifeBoatAPI.__instanceid1
    tbl.__instanceid2 = LifeBoatAPI.__instanceid2

    return tbl
end


-- what about things like arrays, and other tables that really should be "linked" but the link is lost?
-- not that everything becomes single precision floats when loaded
-- our goal was to make everything easier
-- are we achieving that?
--  potentially we make saving impossible to get wrong
--  at the expense of having to do weird tricks for creating new tables each time
-- the benefit is having complex missions should become far less of a stress
-- we want the game to load, and just "keep working"
-- some rules, e.g. expecting everything to be floats not doubles helps
--   and that all persisting state needs to be stored in tables (potentially everything)
-- ...although could we just persist _ENV?
-- ...then only local variables are lost each re-load
-- 

--- Global State
LifeBoatAPI.Globals = LifeBoatAPI.Globals or {}

LifeBoatAPI.Globals.Classes = {
    classes = {},

    register = function(this, uniqueID, cls, parent)
        local keys = {}

        -- inheritance
        if parent then
            for k,v in pairs(parent) do
                if not cls[k] then
                    cls[k] = v
                end
            end
        end
    
        -- key optimization, so we can skip using pairs
        for k,v in pairs(cls) do
            keys[#keys + 1] = k
        end
        cls.__classkeys = keys
        cls.__classuid = uniqueID

        this.classes[cls.__classuid] = cls

        return cls
    end;

    load = function(this, tbl, alreadyLoadedTables)
        alreadyLoadedTables = alreadyLoadedTables or {}

        -- handle instanceIDs to make sure two references to the same table resolve to be be the same table
        -- as the way g_savedata will serialize it, is into two separate tables
        if tbl.__instanceid1 and tbl.__instanceid2 then
            if alreadyLoadedTables[tbl.__instanceid1] and alreadyLoadedTables[tbl.__instanceid1][tbl.__instanceid2] then
                return alreadyLoadedTables[tbl.__instanceid1][tbl.__instanceid2]
            else
                alreadyLoadedTables[tbl.__instanceid1] = alreadyLoadedTables[tbl.__instanceid1] or {}
                alreadyLoadedTables[tbl.__instanceid1][tbl.__instanceid2] = tbl
            end
        end

        -- if this table is a Class table, we overwrite all functions with the actual class functions
        -- as these are not saved in g_savedata (replaced by the string "?")
        -- this means we can easily save the entire mission state; as long as we avoid anonymous/unregistered functions
        if tbl.__classuid then
            local class = this.classes[tbl.__classuid]
            if class then
                for i=1, #class.__classkeys do
                    local key = class.__classkeys[i]
                    local value = class[key]
                    if type(value) == "function" then
                        tbl[key] = value
                    end
                end
            end
        end

        -- recursively load each subtable
        for k,v in pairs(tbl) do
            if type(v) == "table" then
                tbl[k] = this:load(v, alreadyLoadedTables)
            end
        end

        return tbl
    end;
}

-- limitation on working this way:
-- you cannot use anonymous functions; at all.
-- every anonymous function needs to be defined as a class
-- even if it's a one-off

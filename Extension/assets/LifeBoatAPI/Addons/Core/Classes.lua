LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.MaxSafeInt = 16777216
LifeBoatAPI.MinSafeInt = -16777216
LifeBoatAPI.NumSafeInts = (16777216*2)+1
LifeBoatAPI.__instanceid1 = LifeBoatAPI.MinSafeInt
LifeBoatAPI.__instanceid2 = LifeBoatAPI.MinSafeInt


LifeBoatAPI.Classes = {
    _classes = {},

    --- instantiates the given class table
    --- requires previous call to LifeBoatAPI.setupClass
    --- underwrites each value from class into the new instance obj
    --- uses the __classkeys lookup to avoid calls to pairs() => calls to next() => *EXTREMELY slow*
    instantiate = function(class, obj)
        obj = obj or {}

        for i=1, #class.__classkeys do
            local key = class.__classkeys[i]
            if obj[key] == nil then
                obj[key] = class[key]
            end
        end;
    
        -- generate a UID for persistence loading later
        LifeBoatAPI.__instanceid1 = LifeBoatAPI.__instanceid1 + 1
        if LifeBoatAPI.__instanceid1 >= LifeBoatAPI.MaxSafeInt then
            LifeBoatAPI.__instanceid1 = LifeBoatAPI.MinSafeInt
            LifeBoatAPI.__instanceid2 = LifeBoatAPI.__instanceid2 + 1
        end
        obj.__instanceid1 = LifeBoatAPI.__instanceid1
        obj.__instanceid2 = LifeBoatAPI.__instanceid2

        return obj
    end;

    newReferencableTable = function (tbl)
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
    end;

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

        this._classes[cls.__classuid] = cls

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
            local class = this._classes[tbl.__classuid]
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

        -- allow classes to be updatable, if addon was altered during use - it may be needed to set defaults to keep existing long-running elements functional
        if tbl.__update then
            tbl:__update()
        end

        return tbl
    end;
}

---Extremely niche class for handling circular references, that are saved in g_savedata
---Really shouldn't be used; but those few instances where it's needed might not be optional
---@class LifeBoatAPI.SafeCircularRef
---@field indexes string[] list of indexes to get to the value we want
---@field base table table from which to index the value (default _ENV)
SafeCircularRef = {
    ---@param this LifeBoatAPI.SafeCircularRef
    ---@param globalBase table default to _ENV if not specified
    ---@overload fun(this:LifeBoatAPI.SafeCircularRef, ...:string[])
    ---@vararg string[] indexes to reach the value e.g. ("myTable", "subTable", "dog", 1, "nameTable")
    ---@return LifeBoatAPI.SafeCircularRef
    new = function(this, globalBase, ...)
        this = LifeBoatAPI.instantiate(this, {})
        local indexes = {...}

        if type(globalBase) == "table" then
            this.base = globalBase
            this.indexes = indexes
        else
            this.base = _ENV
            this.indexes = {globalBase}
            for i=1, #indexes do
                this.indexes[i+1] = indexes[i]
            end
        end
        
        return this
    end;

    ---Get the value this is safely referencing
    ---@param this LifeBoatAPI.SafeCircularRef
    get = function (this)
        local result = this.base
        for i=1, #this.indexes do
            result = result[this.indexes[i]]
        end
        return result
    end;

    ---Safer version of "get" that returns nil if any of the children aren't found
    ---But could hide an error you wanted to throw
    ---@param this LifeBoatAPI.SafeCircularRef
    tryGet = function (this)
        local result = this.base
        for i=1, #this.indexes do
            if result == nil then
                return nil
            end
            result = result[this.indexes[i]]
        end
        return result
    end;
}

LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.SafeCircularRef", LifeBoatAPI.SafeCircularRef)
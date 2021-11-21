
require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")

---@class LBIteratorProtection : LBBaseClass
LBIteratorProtection = {

    new = function(cls, tbl)
        local this = LBBaseClass.new(cls)
        this.isIterating = false
        this.data = tbl
        this.queuedOperations = {}
        return this
    end;

    beginIteration = function (this)
        this.isIterating = true
    end;

    endIteration = function (this)
        this.isIterating = false

        for i,operation in ipairs(this.queuedOperations) do
            operation.func(table.unpack(operation.args))
        end

        this.queuedOperations = {}
    end;

    insert = function(this, value, index)
        if(not this.isIterating) then
            LBTable_add(this.data, value, index)
        else
            LBTable_add(this.queuedOperations, {func=this.insert, {this, value, index}})
        end
    end;

    -- changing a value is fine, as long as the key already exists
    -- but anything that adds a new key, is UB during iteration
    set = function(this, key, value)
        if(not this.isIterating or (this.data[key] and value)) then
            this.data[key] = value
        else
            LBTable_add(this.queuedOperations, {func=this.set, {this, key, value}})
        end
    end;

    remove = function(this, key)
        if(not this.isIterating) then
            LBTable_remove(this.data, key)
        else
            LBTable_add(this.queuedOperations, {func=this.remove, {this, key}})
        end
    end;
}
LBClass(LBIteratorProtection)
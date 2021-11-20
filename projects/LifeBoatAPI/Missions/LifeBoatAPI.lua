
---@class LifeBoatAPI : LBBaseClass
---@field ticks number
LifeBoatEntityFramework = {

    new = function(cls)
        local this = LBBaseClass.new(cls)
        return this
    end;

    giveControlOfCallbacks = function (this) 
        _ENV.onTick = this.onTick
    end;

    onTick = function (this, delta)
        this.ticks = this.ticks + delta

        -- update each manager

        -- update all entities
    end;
}
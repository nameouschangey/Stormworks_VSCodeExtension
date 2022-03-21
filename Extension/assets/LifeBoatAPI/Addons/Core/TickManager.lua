
---@class LifeBoatAPI.TickManager
---@field ticks number
LifeBoatAPI.TickManager = {
    new = function (this)
        return LifeBoatAPI.instantiate(this, {
            _tickables = LifeBoatAPI.newTable(),
            ticks = 0,
            _tickableRestructureFrequency = 60,
        })
    end;

    onTick = function (this, gameTicks)
        this.ticks = (this.ticks + 1) % LifeBoatAPI.MaxSafeInt

        for i=1, #this._tickables do
            local tickable = this._tickables[i]
            if not tickable.disposable.isDisposed and (tickable.nextTick == this.ticks or tickable.shouldTickImmediately) then
                tickable.shouldTickImmediately = false

                if tickable.tickFrequency and tickable.tickFrequency > 0 then
                    tickable.nextTick = (this.ticks + tickable.tickFrequency) % LifeBoatAPI.MaxSafeInt
                else
                    tickable.nextTick = -1
                end
                tickable:onTick(this.ticks)
            end
        end
        
        -- handle restructuring
        if this.ticks % this._tickableRestructureFrequency == 0 then
            this:_restructureTickables()
        end
    end;

    add = function (this, tickable)
        -- safe during iteration, as the loop is fixed length
        -- as such, new tickables will *never* be evaluated during the tick they are added
        if tickable and not tickable.disposable.isDisposed then
            this._tickables[#this._tickables + 1] = tickable
            tickable.nextTick = (this.ticks + 1) % LifeBoatAPI.MaxSafeInt
        end
    end;

    -- Restructure the internal tickables list, to remove holes
    -- Run infrequently to balance cost of restructure against cost of checking holes
    -- Missions doing "more work" may want a more frequent restructure
    _restructureTickables = function (this)
        local newTickables = {}

        for i=1, #this._tickables do
            local tickable = this._tickables[i]
            if tickable.disposable.isDisposed then
                newTickables[#newTickables+1] = tickable
            end
        end

        this._tickables = newTickables
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.TickManager", LifeBoatAPI.TickManager)





-- example
--[[
---@class LifeBoatAPI.SimpleTickable : LifeBoatAPI.ITickable
LifeBoatAPI.SimpleTickable = {
    new = function (this, onTickFunction, tickFrequency, disposable)
        return LifeBoatAPI.instantiate(this, {
                tickFrequency = tickFrequency or 1,
                onTick = onTickFunction,
                disposable = disposable or {}
            })
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.SimpleTickable", LifeBoatAPI.Tickable)
]]






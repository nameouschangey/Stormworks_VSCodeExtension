---@class TickManager
---@field ticks number
LifeBoatAPI.TickManager = {
    new = function (this)
        return LifeBoatAPI.instantiate(this, {
            _tickables = LifeBoatAPI.newTable(),
            _serializableTicks1 = LifeBoatAPI.MinSafeInt,
            _serializableTicks2 = LifeBoatAPI.MaxSafeInt,
            _tickableRestructureFrequency = 60,
            ticks = 0
        })
    end;

    onLoad = function (this)
        -- recalculate the running total of ticks from the serializable ones
        -- enough tickspace to run for multiple years 24/7 without running into issues
        this.ticks = this._serializableTicks1 + (LifeBoatAPI.NumSafeInts * (this._serializableTicks2_ + LifeBoatAPI.MinSafeInt))
    end;

    onTick = function (this)
        this._serializableTicks1 = this._serializableTicks1 + 1
        if this._serializableTicks1 > LifeBoatAPI.MaxSafeInt then
            this._serializableTicks1 = LifeBoatAPI.MinSafeInt
            this._serializableTicks2 = this._serializableTicks2 + 1
        end

        this.ticks = this.ticks + 1

        for i=1, #this._tickables do
            local tickable = this._tickables[i]
            if tickable.isAlive and (tickable.nextTick == ticks or tickable.shouldTickImmediately) then
                tickable.shouldTickImmediately = false
                tickable.nextTick = (this.ticks + (tickable.tickFrequency or 0)) % this.MaxTicks
                tickable:onTick(ticks)
            end
        end
        
        -- handle restructuring
        if ticks % this._tickableRestructureFrequency == 0 then
            this:_restructureTickables()
        end
    end;

    add = function (this, tickable)
        -- safe during iteration, as the loop is fixed length
        -- as such, new tickables will *never* be evaluated during the tick they are added
        if this.tickable and this.tickable.isAlive then
            this._tickables[#this._tickables + 1] = tickable
        end
    end;

    -- Restructure the internal tickables list, to remove holes
    -- Run infrequently to balance cost of restructure against cost of checking holes
    -- Missions doing "more work" may want a more frequent restructure
    _restructureTickables = function (this)
        local newTickables = {}

        for i=1, #this._tickables do
            local tickable = this._tickables[i]
            if tickable.isAlive then
                newTickables[#newTickables+1] = tickable
            end
        end

        this._tickables = newTickables
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Globals.TickManager", LifeBoatAPI.Globals.TickManager)


---@class LifeBoatAPI.ITickable
---@field tickFrequency number
---@field isAlive boolean
---@field nextTick number

---@class LifeBoatAPI.Tickable : LifeBoatAPI.ITickable
LifeBoatAPI.Tickable = {
    new = function (this, onTickFunction, tickFrequency, delay)
        return LifeBoatAPI.instantiate(this, {
                isAlive = true,
                tickFrequency = tickFrequency or 1,
                nextTick = (LifeBoatAPI.Globals.TickManager.ticks + (delay or 0)) % LifeBoatAPI.Globals.TickManager.MaxTicks,
                onTick = onTickFunction
            })
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Tickable", LifeBoatAPI.Tickable)







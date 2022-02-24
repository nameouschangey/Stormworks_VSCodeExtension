---@class TickManager
---@field ticks number
LifeBoatAPI.TickManager = {
    new = function (this)
        return LifeBoatAPI.instantiate(this, {
            _tickables = LifeBoatAPI.newTable(),
            _serializableTicks1 = 0,
            _serializableTicks2 = LifeBoatAPI.MaxSafeInt,
            _tickableRestructureFrequency = 60,
            ticks = 0
        })
    end;

    onLoad = function (this)
        -- recalculate the running total of ticks from the serializable ones
        -- enough tickspace to run for multiple years 24/7 without running into issues
        this.ticks = this._serializableTicks1 + ((LifeBoatAPI.MaxSafeInt+1) * (this._serializableTicks2_ + LifeBoatAPI.MinSafeInt))
    end;

    onTick = function (this)
        this._serializableTicks1 = this._serializableTicks1 + 1
        if this._serializableTicks1 > LifeBoatAPI.MaxSafeInt then
            this._serializableTicks1 = 0
            this._serializableTicks2 = this._serializableTicks2 + 1
        end

        this.ticks = this.ticks + 1

        for i=1, #this._tickables do
            local tickable = this._tickables[i]
            if not tickable.disposable.isDisposed and (tickable.nextTick == ticks or tickable.shouldTickImmediately) then
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
        if tickable and not tickable.disposable.isDisposed then
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
            if tickable.disposable.isDisposed then
                newTickables[#newTickables+1] = tickable
            end
        end

        this._tickables = newTickables
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Globals.TickManager", LifeBoatAPI.Globals.TickManager)


---@class LifeBoatAPI.IDisposable
---@field isDisposed    boolean

---@class LifeBoatAPI.ITickable : LifeBoatAPI.IDisposable
---@field tickFrequency     number
---@field nextTick          number
---@field disposable        IDisposable

---@class LifeBoatAPI.SimpleTickable : LifeBoatAPI.ITickable
LifeBoatAPI.SimpleTickable = {
    new = function (this, onTickFunction, tickFrequency, disposable, delay)
        return LifeBoatAPI.instantiate(this, {
                tickFrequency = tickFrequency or 1,
                nextTick = (LifeBoatAPI.Globals.TickManager.ticks + (delay or 0)) % LifeBoatAPI.Globals.TickManager.MaxTicks,
                onTick = onTickFunction,
                disposable = disposable or {}
            })
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.SimpleTickable", LifeBoatAPI.Tickable)







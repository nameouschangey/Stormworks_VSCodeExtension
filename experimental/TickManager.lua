---@class TickManager
---@field ticks number
---@field tickables Tickable[]
---@field tickableRestructureFrequency number
LifeBoatAPI.Globals.TickManager = {
    tickables = {};
    ticks = 0;
    tickableRestructureFrequency = 60;
    MaxTicks = 100000;

    onTick = function (this)
        ticks = ticks + 1

        for i=1, #this.tickables do
            local tickable = this.tickables[i]
            if tickable.isAlive and (tickable.nextTick == ticks or tickable.shouldTickImmediately) then
                tickable.shouldTickImmediately = false
                tickable.nextTick = (this.ticks + (tickable.tickFrequency or 0)) % this.MaxTicks
                tickable:onTick(ticks)
            end
        end
        
        -- handle restructuring
        if ticks % this.tickableRestructureFrequency == 0 then
            this:_restructureTickables()
        end
    end;

    add = function (this, tickable)
        -- safe during iteration, as the loop is fixed length
        -- as such, new tickables will *never* be evaluated during the tick they are added
        if this.tickable and this.tickable.isAlive then
            this.tickables[#this.tickables + 1] = tickable
        end
    end;

    -- Restructure the internal tickables list, to remove holes
    -- Run infrequently to balance cost of restructure against cost of checking holes
    -- Missions doing "more work" may want a more frequent restructure
    _restructureTickables = function (this)
        local newTickables = {}

        for i=1, #this.tickables do
            local tickable = this.tickables[i]
            if tickable.isAlive then
                newTickables[#newTickables+1] = tickable
            end
        end

        this.tickables = newTickables
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








---@class LifeBoatAPI.Coroutine : LifeBoatAPI.ITickable
---@field routine function
LifeBoatAPI.Coroutine = {
    Yield = -1;
    Repeat = -2;
    AwaitYield = -4;
    AwaitRepeat = -5;
    Return = nil;

    new = function (this, tickFrequency, delay)
        this = LifeBoatAPI.instantiate(this, {
            isAlive = true,
            tickFrequency = tickFrequency or 1,
            nextTick = LifeBoatAPI.Globals.TickManager.ticks + (delay or 0),
            stage = 1
        })
    end;

    onTick = function (this, ticks)
        if this.routine and this.isAlive then
            local resultType, resultArg = this.routine(this, this.stage, ticks)

            if resultType == LifeBoatAPI.Coroutine.Yield then
                this.stage = this.stage + 1

            elseif resultType == LifeBoatAPI.Coroutine.Repeat then
                -- don't change the stage

            elseif resultType == LifeBoatAPI.Coroutine.Return then
                this.isAlive = false

            elseif resultType == LifeBoatAPI.Coroutine.AwaitYield then
                -- pause until the event triggers, then continue at the current tick Frequency
                resultArg:register(function() this.shouldTickImmediately = true end)
                this.nextTick = -1
                this.stage = this.stage + 1

            elseif resultType == LifeBoatAPI.Coroutine.AwaitRepeat then
                -- pause until the event triggers, then continue at the current tick Frequency; repeating the same stage again
                resultArg:register(function() this.shouldTickImmediately = true end) -- how do we handle scope objects?
                this.nextTick = -1
            end
        else
            this.isAlive = false
        end
    end;
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Coroutine", LifeBoatAPI.Coroutine)













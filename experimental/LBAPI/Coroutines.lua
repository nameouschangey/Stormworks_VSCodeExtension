
---@class LifeBoatAPI.Coroutine : LifeBoatAPI.ITickable
---@field routine function
---@field Yield number
---@field Repeat number
---@field Goto number
---@field AwaitYield number
---@field AwaitRepeat number
---@field AwaitGoto number
---@field End number
LifeBoatAPI.Coroutine = {
    Yield = -1;
    Repeat = -2;
    Goto = -3;
    AwaitYield = -4;
    AwaitRepeat = -5;
    AwaitGoto = -6;
    End = nil;

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
            local resultType, resultArg1, resultArg2 = this.routine(this, this.stage, ticks)

            if resultType == this.Yield then
                this.stage = this.stage + 1

            elseif resultType == this.Repeat then
                -- don't change the stage

            elseif resultType == this.Return then
                this.isAlive = false

            elseif resultType == this.Goto then
                this.stage = resultArg1

            elseif resultType == this.AwaitYield then
                -- pause until the event triggers, then continue at the current tick Frequency
                resultArg1:registerOnce(this._OnAwaitCompleteListener:new())
                this.nextTick = -1
                this.stage = this.stage + 1

            elseif resultType == this.AwaitRepeat then
                -- pause until the event triggers, then continue at the current tick Frequency; repeating the same stage again
                resultArg1:registerOneShot(this._OnAwaitCompleteListener:new()) -- how do we handle scope objects?
                this.nextTick = -1

            elseif resultType == this.AwaitGoto then
                resultArg1:registerOneShot(this._OnAwaitCompleteListener:new())
                this.nextTick = -1
                this.stage = resultArg2

            else 
                this.isAlive = false
            end
        end
    end;

    _OnAwaitCompleteListener = {
        new = function(this, coroutine)
            return LifeBoatAPI.instantiate(this,{
                _coroutine = coroutine;
            })
        end;
    
        onTrigger = function (this)
            this.coroutine.shouldTickImmediately = true;
        end;
    }
}
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Coroutine", LifeBoatAPI.Coroutine)
LifeBoatAPI.Globals.Classes:register("LifeBoatAPI.Coroutine._OnAwaitCompleteListener", LifeBoatAPI._OnAwaitCompleteListener)



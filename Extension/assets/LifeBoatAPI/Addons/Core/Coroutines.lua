
---@class LifeBoatAPI.Coroutine : LifeBoatAPI.ITickable
---@field routine LifeBoatAPI.IExecutable function to run each tick
---@field stage number current stage of the coroutine being run
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

    ---@param this LifeBoatAPI.Coroutine
    ---@param tickFrequency number how often to run the coroutine
    ---@param disposable LifeBoatAPI.IDisposable disposable, for determining when the coroutine ends naturally
    ---@param routine LifeBoatAPI.IExecutable routine to run, logic in onTrigger
    ---@return LifeBoatAPI.Coroutine
    new = function (this, tickFrequency, disposable, routine)
        this = LifeBoatAPI.instantiate(this, {
            disposable = disposable or {};
            tickFrequency = tickFrequency or 1;
            stage = 1;
            routine = routine;
        })

        LifeBoatAPI.LifeBoatAPI.tickManager:add(this)

        return this
    end;

    onTick = function (this, ticks)
        -- if resultType is an awaitable, resultArg1 should be an LifeBoatAPI.Event, resultarg2 can be used in awaitgoto for the stage
        local resultType, resultArg1, resultArg2 = this.routine:onExecute(this, this.stage, ticks)

        if resultType == this.Yield then
            this.stage = this.stage + 1

        elseif resultType == this.Repeat then
            -- don't change the stage

        elseif resultType == this.Return then
            this.disposable = {isDisposed = true}

        elseif resultType == this.Goto then
            this.stage = resultArg1

        elseif resultType == this.AwaitYield then
            -- pause until the event triggers, then continue at the current tick Frequency
            resultArg1:registerOnce(this._OnAwaitCompleteListener:new(this))
            this.nextTick = -1
            this.stage = this.stage + 1

        elseif resultType == this.AwaitRepeat then
            -- pause until the event triggers, then continue at the current tick Frequency; repeating the same stage again
            resultArg1:registerOneShot(this._OnAwaitCompleteListener:new(this)) -- how do we handle scope objects?
            this.nextTick = -1

        elseif resultType == this.AwaitGoto then
            resultArg1:registerOneShot(this._OnAwaitCompleteListener:new(this))
            this.nextTick = -1
            this.stage = resultArg2

        else 
            this.disposable = {isDisposed = true}
        end
    end;

    ---@class LifeBoatAPI.Coroutine._OnAwaitCompleteListener : LifeBoatAPI.IExecutable
    _OnAwaitCompleteListener = {
        new = function(this, coroutine)
            return LifeBoatAPI.Classes.instantiate(this,{
                coroutine = coroutine;
                disposable = coroutine.disposable;
                countLeft = 1;
            })
        end;
    
        onTrigger = function (this)
            this.coroutine.shouldTickImmediately = true;
        end;
    }
}
LifeBoatAPI.Classes:register("LifeBoatAPI.Coroutine", LifeBoatAPI.Coroutine)
LifeBoatAPI.Classes:register("LifeBoatAPI.Coroutine._OnAwaitCompleteListener", LifeBoatAPI._OnAwaitCompleteListener)

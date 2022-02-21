
---@class TestRoutine1 : LifeBoatAPI.Coroutine

TestRoutine1 = {
    new = function(cls) return LifeBoatAPI.instantiate(cls) end;

    ---@overload fun(this:any, stage:any) : boolean
    routine = function (this, stage)
        if stage == 1 then
            -- some fake description of something we'd do here
            return LifeBoatAPI.Coroutine.Yield

        
        elseif stage == 2 then
            -- wait for the player to stand in the spot etc.
            return LifeBoatAPI.Coroutine.AwaitYield, LifeBoatAPI.Triggers.onPlayerEnterArea()
        
        elseif stage == 3 then
            -- find players
            this.i = 0
            while this.i < 10 do
                this.i = this.i + 1
                this.players[#this.players + 1] = this:getNextPlayer(this.i)
                return LifeBoatAPI.Coroutine.Repeat
            end

            return LifeBoatAPI.Coroutine.Yield
        else
            this.onComplete:trigger()
            return LifeBoatAPI.Coroutine.End
        end
    end;

    getNextPlayer = function(this, index)
    end
}
LifeBoatAPI.Globals.Classes:register("TestRoutine1", TestRoutine1, LifeBoatAPI.Coroutine)
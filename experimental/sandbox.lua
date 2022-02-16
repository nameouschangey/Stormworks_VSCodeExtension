
---@class TestRoutine1 : LifeBoatAPI.Coroutine
TestRoutine1 = {
    new = function(cls) return LifeBoatAPI.instantiate(cls) end;

    routine = function ()
        if stage == 1 then


            return LifeBoatAPI.Coroutine.Yield
        end
    
        if stage == 2 then
            
    
            return LifeBoatAPI.Coroutine.Yield
        end
    
        if stage == 3 then
            this.i = 0
            while this.i < 10 do
                this.players[#this.players + 1] = getNextPlayer(this.i)
    
                return LifeBoatAPI.Coroutine.Repeat
            end
        end
    end;
}

function getNextPlayer(index)
end


-- how do we handle re-linking tables?

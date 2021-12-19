
-- think of this in terms of functions with callbacks
-- 1) we're registering against the callback of something else
-- 2) when that callback is done, we then call the function that's registered against us

LifeBoatAPI = LifeBoatAPI or {}
LifeBoatAPI.Async = LifeBoatAPI.Async or {}
LifeBoatAPI.Async = LBNamespace(

---@class LifeBoat.Async
---@field Awaitble LifeBoat.Async.Awaitable
---@field AwaitAll LifeBoat.Async.AwaitAll
{

    ---@class LifeBoat.Async.Awaitable : LBBaseClass
    Awaitable = {
        new = function (this, parent)
            this = LBBaseClass.new(this)
            this.parent = parent
            return this
        end;
        
        trigger = function (this, ...)
            if(this.onComplete) then
                this.onComplete(...)
            end
        end;

        andThen = function (this, callback)
            local awaitable = LifeBoatAPI.Async.Awaitable:new(this)

            this.onComplete = function(...)
                local result = callback(...)
                awaitable:trigger(result)
            end
    
            return awaitable
        end;
    };


    ---@class LifeBoat.Async.AwaitAll : LifeBoat.Async.Awaitable
    AwaitAll = {
        --- overwrites parent
        trigger = function (this, ...)
            if(this.onComplete) then
                this.onComplete(...)
            end
        end;

        andThen = function (this, callback)
            local awaitable = LifeBoatAPI.Async.Awaitable:new(this)

            this.onComplete = function(...)
                local result = callback(...)
                awaitable:trigger(result)
            end
    
            return awaitable
        end;
    };


}, LifeBoatAPI.Async)

LBClass(LifeBoatAPI.Async.Awaitable)
LBClass(LifeBoatAPI.Async.Awaitable, LifeBoatAPI.Async.AwaitAll)


---@class LBAwaitable
LBAwaitable = {

    trigger = function (this, ...)
        if(this.onComplete) then
            this.onComplete(...)
        end
    end;

    ---@return LBAwaitable
    -- when this is a collection of awaitables, we await all of them
    -- when this is one awaitable, we await just that one
    andThen = function (this, callback)
        local awaitable = LBAwaitable:new(this)

        this.onComplete = function(...)
            local result = callback(...)
            awaitable:trigger(result)
        end

        return awaitable
    end;

    -- when there is a collection of awaitables, we do the relevant type of await
    -- otherwise a single awaitable, is treated like andThen (we effectively wrap it in a list {[1]=awaitable})
    waitForAllAndThen = function (this, callback)
        local awaitable = LBAwaitable:new(this)

        this.onComplete = function(...)
            local args = {...}

            for i,v in ipairs(args) do
                
            end
            local result = callback(...)
            awaitable:trigger(result)
        end

        return awaitable
    end;

    waitForAnyAndThen = function()
    end;
    
    waitForSomeAndThen = function()
    end;
    
    whenEachFinishesThen = function()
    end;
    

    -- possibly this is just syntax sugar, not clear whether we want it or not really
    -- maybe it makes life easier, but it might also make it harder to understand
    whilstWaiting = function()
    end;


    -- control functions
    -- we need to be able to say "hey, actually, repeat that last step"
    --  or "hey, repeat the entire chain please"
    -- for example, the mission ends - ok, repeat it all

    -- resets the awaitable chain, so it can be run again?
    -- does that work?
    -- what would that even look like?
    repeatFromStart = function ()
        
    end;

    -- go back one in the chain?
    repeatLast = function ()
        
    end;

    
    -- cancels this specific awaitable chain, stopping it from processing any further
    cancel = function ()
    end;

    -- cancels all awaitables that spawned from the same parent
    cancelAll = function ()
    end;
}
LBClass(LBAwaitable);
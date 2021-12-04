
require("LifeBoatAPI.Missions.Utils.LBIteratorProtection")

---@class LBEvent : LBBaseClass
---@field iterProtection LBIteratorProtection
---@field listeners LBEventListener[]
LBEvent = {
    new = function (cls)
        local this = LBBaseClass.new(cls)
        this.listeners = {}
        this.iterProtection = LBIteratorProtection:new(this.listeners)
        return this
    end;

    -- note, because of the unpredictable nature of event chains, we don't know if events may be registered or deregistered
    --   during iteration.
    -- as such, we must be extremely careful about adding or removing event handlers during iteration - saving them for afterwards.
    ---@param this LBEvent
    send = function (this, sender, ...)
        this.iterProtection:beginIteration()
        
        for listener in ipairs(this.listeners) do
            if(listener.isActive) then
                listener:send(sender,...)
            end
        end

        this.iterProtection:endIteration()
    end;

    ---@param this LBEvent
    register = function(this, listener)
        this.iterProtection:set(listener, true)
        listener._event = this
    end;

    deregister = function(this, listener)
        this.iterProtection:set(listener, false)
    end;
}
LBClass(LBEvent)


---@class LBEventListener : LBBaseClass
---@field callback fun(this:LBEventListener, sender:any, args:...)
---@field isActive boolean whether this listener is currently listening (Allows for pausing, without deregistering and re-registering)
---@field isDeregistered boolean whether this listener is dead, and should be permanently removed from the event it listens to
---@field _event LBEvent event that this is registered to
LBEventListener = {
    new = function(cls, onEventCallback, startDisabled, priority)
        local this = LBBaseClass.new(cls)
        this.callback = onEventCallback -- e.g. format myFunction(LBListener, sender, args...)
        this.isActive = not (startDisabled or false)
        this._event = nil
        this.priority = priority or 0
    end;

    send = function(this, sender, ...)
        if(this.callback) then
            this:callback(sender, ...)
        else
            this:deregister()
        end
    end;

    deregister = function(this)
        this.isActive = false
        if(this._event) then
            this._event.deregister(this)
            this._event = nil
        end
    end;

    pauseListening = function(this)
        this.isActive = false 
    end;

    resumeListening = function(this)
        this.isActive = true
    end;
}
LBClass(LBEventListener)



-- main event bus, easiest to work with as it's global and can be called from anywhere
--  of course; please bear in mind that using global events to communicate - is just a sneaky way of
--  hiding your global state, and coupling ;)

---Global State
---@class LBGlobalEventHandler : LBBaseClass
LBGlobalEventHandler = {
    -- default event names from SW    
    SW_OnTick = "onTick";
    SW_OnVehicleSpawn = "onVehicleSpawned";
    SW_OnVehicleDespawn = "onVehicleDespawned";

    LB_OnTick_RealTime  = "onTickRealtime";     -- every tick,         60 times/second    upto 0ms    latency
    LB_OnTick_High      = "onTickHigh";         -- every 3rd tick,     20 times/second    upto 50ms   latency
    LB_OnTick_Default   = "onTickDefault";      -- every 10th tick,    6 times/second     upto 166ms  latency
    LB_OnTick_Low       = "onTickLow";          -- every 30th tick,    2 times/second     upto 500ms  latency
    LB_OnTick_Lowest    = "onTickLowest";       -- every 60th tick,    1 time/second      upto 1000ms latency

    events = {};

    get = function(this, eventName)
        if not this.events[eventName] then
            this.events[eventName] = LBEvent:new()
        end
        return this.events[eventName]
    end;
}
LBClass(LBGlobalEventHandler)

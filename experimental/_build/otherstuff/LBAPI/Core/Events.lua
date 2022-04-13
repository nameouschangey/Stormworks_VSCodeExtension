
---@class LifeBoatAPI.IEventListener
---@field disposable LifeBoatAPI.IDisposable
---@field onTrigger function
---@field countLeft number          number of times for this listener to be called, or -1 for indefinitely


---@class Event
---@field _listeners LifeBoatAPI.IEventListener[]
Event = {
    new = function (this)
        this = LifeBoatAPI.instantiate(this, {
            _listeners = {},
        })
    end;

    ---@param this Event
    ---@param listener IEventListener
    register = function (this, listener)
        this._listeners[#this._listeners + 1] = listener
    end;

    ---@param this Event
    ---@param listener IEventListener
    registerOneShot = function (this, listener)
        listener.countLeft = 1
        this._listeners[#this._listeners + 1] = listener
    end;

    ---@param this Event
    trigger = function (this, ...)
        local newListeners = {}
        for i = 1, #this._listeners do
            local listener = this._listeners[i]

            -- check against ~=0 so that a listener set to -1 will stay registstered forever
            if not listener.disposable.isDisposed and listener.countLeft ~= 0 then
                listener.countLeft = listener.countLeft - 1
                listener:onTrigger(this, ...)
            end
            
            -- add listener to list that remains for the next trigger event
            if not listener.disposable.isDisposed and listener.countLeft ~= 0 then
                newListeners[#newListeners+1] = listener
            end
        end
        this._listeners = newListeners
    end;
}


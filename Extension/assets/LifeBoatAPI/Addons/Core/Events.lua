
---@class LifeBoatAPI.IExecutable
---@field disposable LifeBoatAPI.IDisposable
---@field onExecute function
---@field countLeft number          number of times for this listener to be called, or -1 for indefinitely

---@class LifeBoatAPI.Event
---@field listeners LifeBoatAPI.IExecutable[]
LifeBoatAPI.Event = {
    new = function (this)
        return LifeBoatAPI.instantiate(this, {
            listeners = {},
        })
    end;

    ---@param this LifeBoatAPI.Event
    ---@param listener IExecutable
    register = function (this, listener)
        this.listeners[#this.listeners + 1] = listener
    end;

    ---@param this LifeBoatAPI.Event
    ---@param listener IExecutable
    registerOneShot = function (this, listener)
        listener.countLeft = 1
        this.listeners[#this.listeners + 1] = listener
    end;

    ---@param this LifeBoatAPI.Event
    trigger = function (this, ...)
        local newListeners = {}
        for i = 1, #this.listeners do
            local listener = this.listeners[i]

            -- check against ~=0 so that a listener set to -1 will stay registered forever
            if not listener.disposable.isDisposed and listener.countLeft ~= 0 then
                listener.countLeft = (listener.countLeft or -1) - 1
                listener:onExecute(this, ...)
            end
            
            -- add listener to list that remains for the next trigger event
            if not listener.disposable.isDisposed and listener.countLeft ~= 0 then
                newListeners[#newListeners+1] = listener
            end
        end
        this.listeners = newListeners
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.Event", LifeBoatAPI.Event)

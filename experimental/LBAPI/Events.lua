EventBase = {
    new = function (this)
        this = LifeBoatAPI.instantiate(this, {
            _listeners = {},

        })
    end;

    register = function (this, listener)
        this._listeners[#this._listeners + 1] = listener
    end;

    registerOneShot = function (this, listener)
        listener.countLeft = 1
        this._listeners[#this._listeners + 1] = listener
    end;

    deregister = function (this)
        
    end;

    trigger = function (this)
        local newListeners = {}
        for i = 1, #this._listeners do
            local listener = this._listeners[i]

            -- check against ~=0 so that a listener set to -1 will stay registstered forever
            if listener.countLeft ~= 0 then
                listener.countLeft = listener.countLeft - 1
                listener:onTrigger(this)
            end
            
            if listener.countLeft ~= 0 then
                newListeners[#newListeners+1] = listener
            end

        end
        this._listeners = newListeners
    end;
}

EventListenerBase = {

    onTrigger = function()end
}
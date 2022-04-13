

CallbackManager = {

    giveControlOfGameCallbacks = function(this)
        this._onCreate = onCreate
        this._onTick = onTick
    end;
    
}
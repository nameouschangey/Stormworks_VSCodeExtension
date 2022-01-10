---@section LBSTATEMACHINEBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBStateMachine 1 LBSTATEMACHINECLASS
---Basic state machine
---Each state is a function that returns the name of the state to transition into, or nil to stay in the current state
---Can make life easier for handling basic mechanics like landing gear, or radar that goes between sweep and track modes, etc.
---Can also be using in onDraw to handle e.g. different menus/screens in a fairly straight forward way
---@class LBStateMachine
---@field states table
---@field currentState string name of the current state to run
---@field ticks number number of ticks that have been spent in the current state
LifeBoatAPI.LBStateMachine = {
    ---@param this LBStateMachine
    ---@param defaultStateCallback fun(ticks:number, statemachine:LBStateMachine):string default state function
    ---@return LBStateMachine
    new = function (this, defaultStateCallback)
        return LifeBoatAPI.lb_copy(this, {
            states = {
                [0] = defaultStateCallback
            },
            ticks = 0,
            currentState = 0
        })
    end;

    ---@section lbstatemachine_onTick
    ---Call during the onTick function for this state machine to function
    ---@param this LBStateMachine
    lbstatemachine_onTick = function (this)
        this._currentStateFunc = this.states[this.currentState]
        if this._currentStateFunc then
            this._nextState = this._currentStateFunc(this.ticks, this) or this.currentState -- nil preserves the current state
            this.ticks = this._nextState == this.currentState and this.ticks + 1 or 0 -- reset ticks when the stateName changes
        else
            this.currentState = 0
        end
    end;
    ---@endsection

    ---@section lbstatemachine_setState
    ---Recommended to just do myStatemachine.states["MyStateName"] = function() ... end,
    ---But let this act as active code documentation
    ---@param this LBStateMachine
    ---@param stateName string name of the state
    ---@param callback fun(ticks:number, statemachine:LBStateMachine):string state callback that will be run while in the given state. Returns the name of the next state to move into or nil
    lbstatemachine_addState = function (this, stateName, callback)
        this.states[stateName] = callback
    end;
    ---@endsection
}
---@endsection LBSTATEMACHINECLASS

require("LifeBoatAPI.Utils.LBCopy")

---Basic state machine
---Each state is a function that returns the name of the state to transition into, or nil to stay in the current state
---Can make life easier for handling basic mechanics like landing gear, or radar that goes between sweep and track modes, etc.
---Can also be using in onDraw to handle e.g. different menus/screens in a fairly straight forward way
---@class LBStateMachine
---@field states table
---@field stateName string current state to run
---@field ticks number number of ticks that have been spent in the current state
---@section LBStateMachine 1 LBSTATEMACHINECLASS
LifeBoatAPI.LBStateMachine = {
    ---@param this LBStateMachine
    ---@param defaultStateCallback fun(ticks:number, statemachine:LBStateMachine):string default state function
    ---@return LBStateMachine
    new = function (this, defaultStateCallback)
        return LifeBoatAPI.lb_copy(this, {
            states = {
                default = defaultStateCallback
            },
            ticks = 0,
            stateName = "default"
        })
    end;

    ---Call during the onTick function for this state machine to function
    ---@param this LBStateMachine
    ---@section lbstatemachine_onTick
    lbstatemachine_onTick = function (this)
        this.currentState = this.states[this.stateName]
        if this.currentState then
            this.nextState = this.currentState(this.ticks, this) or this.stateName -- nil preserves the current state
            this.ticks = this.nextState == this.stateName and this.ticks + 1 or 0 -- reset ticks when the stateName changes
        else
            this.stateName = "default"
        end
    end;
    ---@endsection

    ---Recommended to just do myStatemachine.states["MyStateName"] = function() ... end,
    ---But let this act as active code documentation
    ---@param this LBStateMachine
    ---@param stateName string name of the state
    ---@param callback fun(ticks:number, statemachine:LBStateMachine):string state callback that will be run while in the given state. Returns the name of the next state to move into or nil
    ---@section lbstatemachine_setState
    lbstatemachine_setState = function (this, stateName, callback)
        this.states[stateName] = callback
    end;
    ---@endsection
}
---@endsection LBSTATEMACHINECLASS
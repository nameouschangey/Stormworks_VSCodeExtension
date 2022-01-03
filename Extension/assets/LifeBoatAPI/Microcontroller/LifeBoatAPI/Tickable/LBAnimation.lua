---@section LBANIMATIONBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBAnimation 1 LBANIMATIONCLASS
---Table format for each of the animation steps
---@class LBAnimationStep
---@field length number length of the step in ticks
---@field callback fun(t:number, ticks:number) callback to run

---An animation that runs per tick, for handling simple state based things such as simple UI animations, landing gear stages, etc.
---@class LBAnimation
---@field steps LBAnimationStep[]
---@field index number index of the current playing animation step
---@field currentStep LBAnimationStep currently playing animation step
---@field lastStep LBAnimationStep last animation step to have played
LifeBoatAPI.LBAnimation = {

    ---@param this LBAnimation
    ---@param startPlayingStraightAway boolean (optional) if True, will begin the animation immediately. Otherwise only starts when playFromStart is called
    ---@param steps LBAnimationStep[] (optional) list of steps to initialize with, otherwise use lbanimation_addStep
    ---@return LBAnimation
    new = function (this, startPlayingStraightAway, steps)
        return LifeBoatAPI.lb_copy(this, {
            steps = steps or {},
            index = startPlayingStraightAway and 1 or 0
        })
    end;

    ---@section lbanimation_playFromStart
    ---Begin playing this animation from the start (restarts if currently playing)
    ---@param this LBAnimation
    lbanimation_playFromStart = function (this)
        this.lastStep = nil
        this.index = 1
    end;
    ---@endsection

    ---@section lbanimation_stop
    ---Stop playing the current animation#
    ---Once called, can only be restarted using playFromStart
    ---@param this LBAnimation
    lbanimation_stop = function (this)
        this.index = 0
    end;
    ---@endsection

    ---@section lbanimation_onTick
    ---Call during the onTick function for this animation to play
    ---@param this LBAnimation
    lbanimation_onTick = function (this)
        this.lastStep = this.currentStep
        this.currentStep = this.steps[this.index]
        if this.currentStep then
            this.currentStep.ticks = this.lastStep == this.currentStep and this.currentStep.ticks + 1 or 0 -- reset ticks to 0 if we've changed step
            this.currentStep.callback(this.currentStep.ticks / this.currentStep.length, this.currentStep.ticks)
            this.index = this.index + (this.currentStep.ticks > this.currentStep.length) and 1 or 0
        end
    end;
    ---@endsection

    ---@section lbanimation_addStep
    ---Add a step to this animation
    ---@param this LBAnimation
    ---@param length number number of ticks this will play for
    ---@param callback fun(t:number, ticks:number) animation function that takes a parameter t between 0->1, and a parameter ticks for the raw tick count
    lbanimation_addStep = function (this, length, callback)
        this.steps[#this.steps + 1] = {
            length = length,
            callback = callback
        }
    end;
    ---@endsection
}
---@endsection LBANIMATIONCLASS
---@section LBROLLINGAVERAGEBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBRollingAverage 1 LBROLLINGAVERAGECLASS
---A rolling average across a given number of values
---Useful for filtering noisey values
---@class LBRollingAverage
---@field maxValues number number of values this rolling average holds
---@field values number[] list of values to be averaged
---@field average number current average of the values that have been added
---@field count number number of values currently being averaged
---@field sum number total of the currently tracked values
LifeBoatAPI.LBRollingAverage = {

    ---@param this LBRollingAverage
    ---@param maxValues number number of values this rolling average holds
    ---@return LBRollingAverage
    new = function (this, maxValues)
        return LifeBoatAPI.lb_copy(this,
        {
            values = {},
            maxValues = maxValues or math.maxinteger,
            index = 1
        })
    end;

    ---@section lbrollingaverage_addValue 
    ---Add a value to the rolling average
    ---@param this LBRollingAverage
    ---@param value number value to add into the rolling average
    ---@return number average the current rolling average (also accessible via .average)
    lbrollingaverage_addValue = function (this, value)
        this.values[(this.index % this.maxValues) + 1] = value
        this.index = this.index + 1
        this.count = math.min(this.index, this.maxValues)
        this.sum = 0
        for _,v in ipairs(this.values) do
            this.sum = this.sum + v
        end
        this.average = this.sum / this.count
        return this.average
    end;
    ---@endsection
}
---@endsection LBROLLINGAVERAGECLASS

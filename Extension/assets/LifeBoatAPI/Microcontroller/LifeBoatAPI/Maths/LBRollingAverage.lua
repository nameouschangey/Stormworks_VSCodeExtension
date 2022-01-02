
require("LifeBoatAPI.Utils.LBCopy")

---A rolling average across a given number of values
---Useful for filtering noisey values
---@class LBRollingAverage
---@field maxValues number number of values this rolling average holds
---@field values number[] list of values to be averaged
---@field average number current average of the values that have been added
---@field count number number of values currently being averaged
---@field sum number total of the currently tracked values
---@section LBRollingAverage 1 LBROLLINGAVERAGECLASS
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

    ---Add a value to the rolling average
    ---@param this LBRollingAverage
    ---@param value number value to add into the rolling average
    ---@return number average the current rolling average (also accessible via .average)
    ---@section lbrollingaverage_addValue 
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
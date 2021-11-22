---@class LBSimulatorScreen
---@field width number
---@field height number
---@field touchX number
---@field touchY number
---@field isTouchedL boolean
---@field isTouchedR boolean
LBSimulatorScreen = {
    ---@param this LBSimulatorScreen
    ---@return LBSimulatorScreen
    new = function(this)
        this = LBBaseClass.new(this)
        this.width = 0
        this.height = 0
        this.touchX = 0
        this.touchY = 0
        this.isTouchedL = false
        this.isTouchedR = false
        return this
    end;
}

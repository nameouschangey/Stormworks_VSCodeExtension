-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")

---@class SimulatorScreen
---@field width number
---@field height number
---@field touchX number
---@field touchY number
---@field touchAltX number      last position E & Q were held
---@field touchAltY number      last position E & Q were held
---@field isTouched boolean     is E or Q held down
---@field isTouchedAlt boolean  are E and Q both held down
---@field poweredOn boolean
---@field portrait boolean
---@field screenNumber number
LifeBoatAPI.Tools.SimulatorScreen = {
    ---@param this SimulatorScreen
    ---@return SimulatorScreen
    new = function(this, screenNumber)
        this = LifeBoatAPI.Tools.BaseClass.new(this)
        this.width          = 0
        this.height         = 0
        this.touchX         = 0
        this.touchY         = 0
        this.touchAltX      = 0
        this.touchAltY      = 0
        this.isTouched      = false
        this.isTouchedAlt   = false
        this.poweredOn      = true
        this.portrait       = false
        this.screenNumber   = screenNumber
        return this
    end;
}

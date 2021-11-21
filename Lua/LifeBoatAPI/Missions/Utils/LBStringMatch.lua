-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates


require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")

--- struct representing a variable found in the code
---@class LBStringMatch : LBBaseClass
---@field startIndex number position it was found in the text
---@field endIndex number end position this variable was found at
---@field captures table variable text that was found
LBStringMatch = {
    ---@return LBStringMatch
    new = function(cls, ...)
        local this, args = LBBaseClass.new(cls),{...}
        this.startIndex = args[1]
        this.endIndex = args[2]
        this.captures = LBTable_islice(args,3)
        return this
    end;
}
LBClass(LBStringMatch)--- struct representing a variable found in the code
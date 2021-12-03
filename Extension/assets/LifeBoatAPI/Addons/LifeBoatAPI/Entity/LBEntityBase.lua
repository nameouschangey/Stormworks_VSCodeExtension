require("LifeBoatAPI.Missions.Utils.LBBase")

---@class LBEntityBase : LBBaseClass
---@field entityID number
LBEntityBase = {
    
    onTick = function(ticks) end
    
}
LBClass(LBEntityBase)

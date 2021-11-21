require("LifeBoatAPI.Missions.Utils.LBBase")

-- Tracks all vehicles spawned and their states

LBVehicleManager = {

    new = function(cls)
        local this = LBBaseClass.new(cls)
        return this
    end;

    
}
LBClass(LBVehicleManager)




-- server.spawnAddonVehicle
--
-- server.spawnVehicle
--
-- server.cleanVehicles

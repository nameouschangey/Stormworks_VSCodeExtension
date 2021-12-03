require("LifeBoatAPI.Missions.Utils.LBBase")

---@class LBAddon : LBBaseClass
LBAddon = {

    ---@param cls LBAddon
    ---@return LBAddon
    new = function(cls)
        local this = LBBaseClass.new(cls)
        return this
    end;
    
    getAddonIndex = function ()
        
    end;

    getLocationIndex = function ()
        
    end;

    spawnThisAddonLocation = function ()
        
    end;

    spawnAddonLocation = function ()
        
    end;

    getAddonPath = function()
    end;

    getZones = function()
    end;

    isInZone = function ()
        
    end;

    spawnAddonComponent = function ()
        
    end;

    getAddonCount = function ()
        
    end;

    getAddonData = function ()
        
    end;

    getLocationData = function ()
        
    end;

    getLocationComponentData = function ()
        
    end;


}
LBClass(LBAddon)
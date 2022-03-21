------------------------

-- require LifeBoatAPI stuff here

-----------------------------

--- Core LifeBoatAPI instance which handles all other logic
--- Note, because this isn't loaded from g_savedata, this is the ONLY place where lambdas can be used
--- All other code must implement functors as specific objects
---@class LifeBoatAPI.LifeBoatAPI
---@field tickManager LifeBoatAPI.TickManager
---@field vehicleManager LifeBoatAPI.VehicleManager
---@field playerManager LifeBoatAPI.PlayerMananger
LifeBoatAPI.LifeBoatAPI = {
    new = function(this)
        this = LifeBoatAPI.instantiate(this, {
            tickManager = LifeBoatAPI.TickManager:new();
            vehicleManager = LifeBoatAPI.VehicleManager:new();
        })

        -- handle onCreate
        onCreate = function(isWorldCreate)
            -- g_globalstate is now fulfilled
            if isWorldCreate then
                this:onWorldCreate()
            end
            
            -- handle getting the stuff out of global state
            g_savedata.LifeBoatAPI = g_savedata.LifeBoatAPI and LifeBoatAPI.Classes:load(g_savedata.LifeBoatAPI) or this
            this = g_savedata.LifeBoatAPI
            LifeBoatAPI.LifeBoatAPI = g_savedata.LifeBoatAPI
            

            if server.getPlayers()[1].steam_id==0 then
                this:onLoad() --this is when loading from an already saved file AND not a "?reload_scripts".
            end

            this:onReloaded()
        end;

        onTick = function(gameTicks)
            this.tickManager:onTick(gameTicks)
        end;

    end;

    onWorldCreate   = function(this) end;
    onLoad          = function(this) end;
    onReloaded      = function(this) end;
}
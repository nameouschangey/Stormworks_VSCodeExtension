
---Factory for mapping vehicles in game to meaningful vehicle scripts
---Default (unmapped) vehicle type is nothing but a simple data container
---@class LifeBoatAPI.IVehicleFactory
---@field create fun(this, vehicle:LifeBoatAPI.Vehicle) : LifeBoatAPI.Vehicle


---@class LifeBoatAPI.Vehicle
---@field id                    number
---@field isLoaded              boolean
---@field isAddonOwner          boolean
---@field ownerPeerID           number
---@field spawnCost             number
---@field position              LifeBoatAPI.Vector
---@field disposable            LifeBoatAPI.IDisposable
---@field onLoad                fun(this)
---@field onDespawn             fun(this)
---@field onDamaged             fun(this)
---@field onButtonPress         fun(this)
---@field onUnload              fun(this)
---@field onTeleport            fun(this)
---@field onLoadEvent           LifeBoatAPI.Event
---@field onDespawnEvent        LifeBoatAPI.Event
---@field onDamagedEvent        LifeBoatAPI.Event
---@field onButtonPressEvent    LifeBoatAPI.Event
---@field onUnloadEvent         LifeBoatAPI.Event
---@field onTeleportEvent       LifeBoatAPI.Event
LifeBoatAPI.Vehicle = {

    ---@param this LifeBoatAPI.Vehicle
    new = function (this, vehicleID, isAddonOwner, peerID, x, y, z, cost)
        LifeBoatAPI.Classes.instantiate(this, {
            id = vehicleID;
            isAddonOwner = isAddonOwner;
            ownerPeerID = peerID;
            spawnCost = cost;
            position = LifeBoatAPI.Vector:new(x,y,z);
            disposable = {};

            -- event pass-through
            onLoadEvent         = LifeBoatAPI.Event:new();
            onDespawnEvent      = LifeBoatAPI.Event:new();
            onDamagedEvent      = LifeBoatAPI.Event:new();
            onButtonPressEvent  = LifeBoatAPI.Event:new();
            onUnloadEvent       = LifeBoatAPI.Event:new();
            onTeleportEvent     = LifeBoatAPI.Event:new();
        })
    end;
}

---Handles all vehicles and vehicle events
---@class LifeBoatAPI.VehicleManager
---@field vehicles LifeBoatAPI.Vehicle[]
---@field vehiclesByID table<number,LifeBoatAPI.IVehicle>
---@field vehicleFactories LifeBoatAPI.IVehicleFactory[]
---@field onVehicleSpawnedEvent LifeBoatAPI.Event
---@field awaitingVehicles int[]
LifeBoatAPI.VehicleManager = {

    ---@param this LifeBoatAPI.VehicleManager
    new = function(this)
        this = LifeBoatAPI.Classes.instantiate(this, {
            vehiclesByID = {};
            vehicles = {};
            onVehicleSpawnedEvent = LifeBoatAPI.Event:new();
            vehicleFactories = {};
            spawnAwaitables = {};
            awaitingVehicles = {};
        })

        onVehicleSpawn = function (vehicleID, peerID, x, y, z, cost)
            local vehicle = LifeBoatAPI.Vehicle:new(vehicleID, this.awaitingVehicles[vehicleID] ~= nil, peerID, x, y, z, cost)
            vehicle.isLoaded = false
            this.vehiclesByID[vehicleID] = vehicle
            this.vehicles[#this.vehicles + 1] = vehicle
        end;
        
        onVehicleLoad = function (vehicleID)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                if vehicle.awaitingFirstLoad then
                    vehicle.awaitingFirstLoad = nil

                    -- check if there's a mapping for this vehicle to turn it into a useful object
                    for i=1,#this.vehicleFactories do
                        local factory = this.vehicleFactories[i]
                        local mappedVehicle = factory.create(vehicle)
                        if mappedVehicle then
                            vehicle = mappedVehicle
                            this.vehiclesByID[vehicleID] = mappedVehicle
                            break;
                        end
                    end

                    this.onVehicleSpawnedEvent:trigger(vehicle)
                    -- trigger the awaitable if this was spawned from such a command
                    local awaitable = this.awaitingVehicles[vehicleID]
                    if awaitable then
                        awaitable:trigger()
                    end
                end
                
                vehicle.isLoaded = true
                if vehicle.onLoad then
                    vehicle:onLoad()
                end

                if #vehicle.onLoadEvent.listeners > 0 then
                    vehicle.onLoadEvent:trigger(vehicle)
                end
            end
        end;

        onVehicleDespawn = function (vehicleID, peerID)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                vehicle.disposable.isDisposed = true

                if vehicle.onDespawn then
                    vehicle:onDespawn(peerID)
                end

                if #vehicle.onDespawnEvent.listeners > 0 then
                    vehicle.onDespawnEvent:trigger(vehicle)
                end

                this.vehiclesByID[vehicleID] = nil
                for i=1, #this.vehicles do
                    if this.vehicles[i].id == vehicleID then
                        table.remove(this.vehicles, i)
                        break
                    end
                end
            end
        end;
    
        onVehicleDamaged = function (vehicleID, amount, voxelX, voxelY, voxelZ, bodyIndex)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                if vehicle.onDamaged then
                    vehicle:onDamaged(amount, voxelX, voxelY, voxelZ, bodyIndex)
                end

                if #vehicle.onDamagedEvent.listeners > 0 then
                    vehicle.onDamagedEvent:trigger(vehicle, amount, voxelX, voxelY, voxelZ, bodyIndex)
                end
            end
        end;
    
        onButtonPress = function (vehicleID, peerID, buttonName)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                if vehicle.onButtonPress then
                    vehicle:onButtonPress(peerID, buttonName)
                end
                if #vehicle.onButtonPressEvent.listeners > 0 then
                    vehicle.onButtonPressEvent:trigger(vehicle, peerID, buttonName)
                end
            end
        end;
    
        onVehicleTeleport = function (vehicleID, peerID, x, y, z)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                vehicle.position.set(x, y, z)

                if vehicle.onTeleport then
                    vehicle:onTeleport(peerID, x, y, z)
                end
                if #vehicle.onTeleportEvent.listeners > 0 then
                    vehicle.onTeleportEvent:trigger(vehicle, peerID, x, y, z)
                end
            end
        end;
    
        onVehicleUnload = function (vehicleID)
            local vehicle = this.vehiclesByID[vehicleID]
            if vehicle then
                vehicle.isLoaded = false
                if vehicle.onUnload then
                    vehicle:onUnload()
                end
            end
        end

        return this
    end;

    registerFactory = function(this, vehicleFactory)
        this.vehicleFactories[vehicleFactory.name] = vehicleFactory
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.VehicleManager", LifeBoatAPI.VehicleManager)


---Default/Recommended Vehicle Factory, maps vehicles based on a LBTYPE dial on them
--- This means all the information needed for classifying a vehicle can be stored on the vehicle itself
--- Allowing multiple addons to track the same tyoe of vehicle/extend from it more easily
---@class LifeBoatAPI.VehicleFactory_ByDial : LifeBoatAPI.IVehicleFactory
---@field onlyOwnVehicles boolean if true only maps vehicles spawned by this addon
---@field mappings table<number, funtion> mappings of types -> vehicle constructors
---@field dialName string default LBTYPE, shouldn't really be changed - but allows re-use of this class for other purposes if wanted
LifeBoatAPI.VehicleFactory_ByDial = {

    ---@param this LifeBoatAPI.VehicleFactory_ByDial
    new = function(this, onlyOwnVehicles, mappings, dialName)
        return LifeBoatAPI.Classes.instantiate(this, {
            onlyOwnVehicles = onlyOwnVehicles;
            mappings = mappings or {};
            dialName = dialName or "LBTYPE"
        })
    end;

    ---@param this LifeBoatAPI.VehicleFactory_ByDial
    ---@param vehicle LifeBoatAPI.Vehicle
    create = function (this, vehicle)
        if not this.onlyOwnVehicles or vehicle.isAddonOwner then
            local dial, success = server.getVehicleDial(vehicle.id, this.dialName)
            if success and dial and this.mappings[dial] then
                return this.mappings[dial](vehicle)
            end
        end
        return nil
    end
}
LifeBoatAPI.Classes:register("LifeBoatAPI.VehicleFactory_ByDial", LifeBoatAPI.VehicleFactory_ByDial)

require("Utils.LBBase")
require("LifeBoatAPI.Missions.Math.LBVec")

---@class LBSeatController : LBBaseClass
---@field axisWS number
---@field axisDA number
---@field axisUD number
---@field axisR1 number
---@field buttons boolean[]
LBSeatController = {

    ---@return LBSeatController
    new = function(this)
        this = LBBaseClass.new(this)
        this:reset()
        return this
    end;

    reset = function (this)
        this:resetAxis()
        this:resetButtons()    
    end;

    resetAxis = function (this)
        this.axisWS = 0
        this.axisDA = 0
        this.axisUD = 0
        this.axisR1 = 0
    end;

    resetButtons = function(this)
        this.buttons ={
            false,
            false,
            false,
            false,
            false,
            false
        }
    end;
}

---@class LBVehicle : LBBaseClass
---@field vehicleID number unique id assigned by the game
LBVehicle = {
    new = function(this, vehicleID)
        this = LBBaseClass.new(this)
        this.vehicleID = vehicleID
        return this
    end;

    despawnVehicle = function(this, immediate)
        server.despawnVehicle(this.vehicleID, immediate)
    end;

    getPosition = function(this, voxel)
        voxel = voxel or LBVec:zero()
        server.getVehiclePos(this.vehicleID, voxel.x, voxel.y, voxel.z)
    end;

    setPosition = function(this, matrix)
        server.setVehiclePos(this, matrix)
    end;

    getName = function(this)
        local name, success = server.getVehicleName(this.vehicleID)
        return name
    end;

    getData = function(this)
        local data, success =server.getVehicleData(this)
        return data
    end;

    ---@param this LBVehicle
    ---@param seatName string
    ---@param seatController LBSeatController
    updateSeat = function(this, seatName, seatController)
        server.setVehicleSeat(this.vehicleID, seatName, seatController.axisWS, seatController.axisDA, seatController.axisUD, seatController.axisR1,
                                seatController.buttons[1], seatController.buttons[2], seatController.buttons[3],
                                seatController.buttons[4], seatController.buttons[5], seatController.buttons[6])
    end;

    getButton = function(this, buttonName)
        local value, success = server.getVehicleButton(this.vehicleID, buttonName)
        return (success and value) or nil
    end;

    pressButton = function(this, buttonName)
        server.pressVehicleButton(this.vehicleID, buttonName)
    end;

    setKeypad = function(this, keypadName, value)
        server.setVehicleKeypad(this.vehicleID, keypadName, value)
    end;

    getDial = function(this, dialName)
        local value, success = server.getVehicleDial(this.vehicleID, dialName)
        return value
    end;


    getTank = function(this, tankName)
        local data, success =server.getVehicleTank(this.vehicleID, tankName)
        return data
    end;

    setTank = function(this, tankName, level, fluidType)
        server.setVehicleTank(this.vehicleID, tankName, level, fluidType)
    end;

    getSign = function(this, signName)
        server.getVehicleSign(this.vehicleID, signName)
    end;

    getHopper = function(this, hopperName)
        local data, success = server.getVehicleHopper(this.vehicleID, hopperName)
        return data
    end;

    setHopper = function(this, hopperName, value)
        server.setVehicleHopper(this.vehicleID, hopperName, value)
    end;

    getBattery = function(this, batterName)
        local value, success = server.getVehicleBattery(this.vehicleID, batterName)
        return value
    end;

    setBattery = function(this, batteryName, value)
        server.setVehicleBattery(this.vehicleID, batteryName, value)
    end;

    getFireCount = function(this)
        return server.getVehicleFireCount(this.vehicleID)
    end;

    setTooltip = function(this, tooltipText)
        server.setVehicleTooltip(this.vehicleID, tooltipText)
    end;

    isSimulating = function(this)
        local isSimulating, success = server.getVehicleSimulating(this.vehicleID)
        return isSimulating
    end;

    setTransponder = function(this, active)
        server.setVehicleTransponder(this.vehicleID, active)
    end;

    ---@param voxel LBVec3
    addDamage = function(this, amount, voxel)
        server.addDamage(this.vehicleID, amount, voxel.x, voxel.y, voxel.z)
    end;

    showOnMap = function(this, shouldShowOnMap)
        server.setVehicleShowOnMap(this.vehicleID, shouldShowOnMap)
    end;

    setEditable = function(this, editable)
        server.setVehicleEditable(this.vehicleID, editable)
    end;
}
LBClass(LBVehicle)




-- server.spawnAddonVehicle
--
-- server.spawnVehicle
--
-- server.cleanVehicles

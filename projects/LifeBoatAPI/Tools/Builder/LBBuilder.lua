-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Vehicle.Utils.LBCopy")
require("LifeBoatAPI.Tools.Combiner.LBCombiner")
require("LifeBoatAPI.Tools.Minimizer.LBMinimizer")
require("LifeBoatAPI.Tools.Minimizer.LBParsingConstantsLoader")


-- A simpler setup for the Minimizer and Combiner, to make them more user friendly

---@class LBBuilder
---@field outputDirectory LBFilepath
LBBuilder = {
    ---@param outputDirectory LBFilepath
    ---@return LBBuilder
    new = function(this, outputDirectory)
        this = LBCopy(this)
        this.outputDirectory = outputDirectory

        this.vehicle_constants = this:_setupVehicleConstants()
        this.mission_constants = this:_setupMissionConstants()

        this.combiner = LBCombiner:new()
        this.combiner:addRootFolder(LBFilepath:new([[C:\personal\STORMWORKS\projects\]]))

        return this
    end;

    _setupVehicleConstants = function(this)
        local constants = LBParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._vehicle_restricted_callbacks)  -- select from _vehicle_restricted and _mission_restricted
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(LBFilepath:new([[C:\personal\STORMWORKS\projects\_NeloDocs\docs_vehicles.lua]]))
        return constants
    end;

    _setupMissionConstants = function (this)
        local constants = LBParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._mission_restricted_callbacks)
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(LBFilepath:new([[C:\personal\STORMWORKS\projects\_NeloDocs\docs_missions.lua]]))
        return constants
    end;

    ---@param this LBBuilder
    ---@param name string
    ---@param entrypoint LBFilepath
    buildMicrocontroller = function(this, name, entrypoint, params)
        print("Building micrcontroller: " .. name)
        params = params or {}

        local outFile = LBFilepath:new(this.outputDirectory:linux() .. [[\MC\]] .. name .. [[.lua]],true)
        local cmbFile = params.keepIntermediate and LBFilepath:new(this.outputDirectory:linux() .. [[\MC\]] .. name .. [[.cmb]],true) or outFile

        this.combiner:combineFile(entrypoint, cmbFile)

        
        local minimizer = LBMinimizer:new(this.vehicle_constants, params)
        minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print("Complete") 
    end;

    ---@param this LBBuilder
    ---@param name string
    ---@param entrypoint LBFilepath
    buildAddonScript = function (this, name, entrypoint, params)    
        print("Building addon: " .. name)
        params = params or {}
        
        local outFile = LBFilepath:new(this.outputDirectory:linux() .. [[\]] .. name .. [[.lua]],true)
        local cmbFile = params.keepIntermediate and LBFilepath:new(this.outputDirectory:linux() .. [[\MC\]] .. name .. [[.cmb]],true) or outFile

        this.combiner:combineFile(entrypoint, cmbFile)

        local minimizer = LBMinimizer:new(constants, params or {})
        minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print("Complete") 
    end;
}
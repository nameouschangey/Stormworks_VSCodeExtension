-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Build.Combiner.Combiner")
require("LifeBoatAPI.Tools.Build.Minimizer.Minimizer")
require("LifeBoatAPI.Tools.Build.Minimizer.ParsingConstantsLoader")

-- A simpler setup for the Minimizer and Combiner, to make them more user friendly
---@class Builder
---@field outputDirectory Filepath
---@field combiner Combiner
---@field minimizer Minimizer
---@field vehicle_constants ParsingConstantsLoader
---@field mission_constants ParsingConstantsLoader
LifeBoatAPI.Tools.Builder = {
    ---@param outputDirectory Filepath
    ---@return Builder
    new = function(this, rootDirs, outputDirectory, microcontrollerDoc, addonDoc)
        this = LifeBoatAPI.Tools.Copy(this)
        this.outputDirectory = outputDirectory

        this.vehicle_constants = this:_setupVehicleConstants(microcontrollerDoc)
        this.mission_constants = this:_setupMissionConstants(addonDoc)

        this.combiner = LifeBoatAPI.Tools.LBCombiner:new()
        for _,dir in ipairs(rootDirs) do
            this.combiner:addRootFolder(dir)
        end
        return this
    end;

    ---@param this Builder
    ---@param name string
    ---@param entrypoint Filepath
    buildMicrocontroller = function(this, name, entrypoint, params)
        print("Building micrcontroller: " .. name)
        params = params or {}

        local cmbFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/_intermediate/]] .. name, true)
        local outFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/release/]] .. name, true)

        this.combiner:combineFile(entrypoint, cmbFile)

        local minimizer = LifeBoatAPI.Tools.Minimizer:new(this.vehicle_constants, params)
        minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print("Complete") 
    end;

    ---@param this Builder
    ---@param name string
    ---@param entrypoint Filepath
    buildAddonScript = function (this, name, entrypoint, params)    
        print("Building addon: " .. name)
        params = params or {}

        local cmbFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/_intermediate/]] .. name, true)
        local outFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/release/]] .. name, true)

        this.combiner:combineFile(entrypoint, cmbFile)

        local minimizer = LifeBoatAPI.Tools.Minimizer:new(this.mission_constants, params or {})
        minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print("Complete") 
    end;


    _setupVehicleConstants = function(this, docpath)
        local constants = LifeBoatAPI.Tools.ParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._vehicle_restricted_callbacks)  -- select from _vehicle_restricted and _mission_restricted
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(docpath)
        return constants
    end;

    _setupMissionConstants = function (this, docpath)
        local constants = LifeBoatAPI.Tools.ParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._mission_restricted_callbacks)
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(docpath)
        return constants
    end;
}

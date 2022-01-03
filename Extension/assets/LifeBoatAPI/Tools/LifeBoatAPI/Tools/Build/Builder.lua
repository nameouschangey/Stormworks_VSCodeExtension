-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Build.Combiner")
require("LifeBoatAPI.Tools.Build.Minimizer")
require("LifeBoatAPI.Tools.Build.ParsingConstantsLoader")

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

        this.combiner = LifeBoatAPI.Tools.Combiner:new()
        for _,dir in ipairs(rootDirs) do
            this.combiner:addRootFolder(dir)
        end
        return this
    end;

    ---@param this Builder
    ---@param name string
    ---@param entrypoint Filepath
    buildMicrocontroller = function(this, name, entrypoint, params)
        --print("Building: " .. name)
        params = params or {}

        local cmbFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/_intermediate/]] .. name, true)
        local outFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/release/]] .. name, true)

        this.combiner:combineFile(entrypoint, cmbFile)

        local minimizer = LifeBoatAPI.Tools.Minimizer:new(this.vehicle_constants, params)
        local finalText, originalLength, newLength = minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print(name .. " " .. tostring(originalLength) .. " -> " .. tostring(newLength) .. " chars") 
    end;

    ---@param this Builder
    ---@param name string
    ---@param entrypoint Filepath
    buildAddonScript = function (this, name, entrypoint, params)    
        --print("Building: " .. name)
        params = params or {}

        local cmbFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/_intermediate/]] .. name, true)
        local outFile = LifeBoatAPI.Tools.Filepath:new(this.outputDirectory:linux() .. [[/release/]] .. name, true)

        this.combiner:combineFile(entrypoint, cmbFile)

        local minimizer = LifeBoatAPI.Tools.Minimizer:new(this.mission_constants, params or {})
        local finalText, originalLength, newLength = minimizer:minimizeFile(cmbFile, outFile, params.boilerPlate)
        print(name .. " " .. tostring(originalLength) .. " -> " .. tostring(newLength) .. " chars") 
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

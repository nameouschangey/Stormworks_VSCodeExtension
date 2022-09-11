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
---@field filter string|nil lua-pattern applied against each filepath, to see if it should be built or not
LifeBoatAPI.Tools.Builder = {

    ---@param cls Builder
    ---@param outputDirectory Filepath
    ---@return Builder
    new = function(cls, rootDirs, outputDirectory, microcontrollerDoc, addonDoc)
        ---@type Builder
        local self = LifeBoatAPI.Tools.Copy(cls)
        self.outputDirectory = outputDirectory

        self.vehicle_constants = self:_setupVehicleConstants(microcontrollerDoc)
        self.mission_constants = self:_setupMissionConstants(addonDoc)

        self.combiner = LifeBoatAPI.Tools.Combiner:new()
        for i=1, #rootDirs do
            self.combiner:addRootFolder(rootDirs[i])
        end
        return self
    end;

    ---@param self Builder
    ---@param name string
    ---@param entrypointFile Filepath
    buildMicrocontroller = function(self, name, entrypointFile, params)
        return self:_buildScript(name, entrypointFile, params, self.vehicle_constants)
    end;

    ---@param self Builder
    ---@param name string
    ---@param entrypointFile Filepath
    buildAddonScript = function (self, name, entrypointFile, params)    
        return self:_buildScript(name, entrypointFile, params, self.mission_constants)
    end;

    ---@param self Builder
    ---@param name string
    ---@param entrypointFile Filepath
    _buildScript = function (self, name, entrypointFile, params, minimizerConstants)
        if self.filter then
            -- check if we're filtering out the file
            if not name:match(self.filter) then
                print(name .. " skipped by build filter")
                return
            end
        end
        params = params or {}

        local cmbFile = LifeBoatAPI.Tools.Filepath:new(self.outputDirectory:linux() .. [[/_intermediate/]] .. name, true)
        local outFile = LifeBoatAPI.Tools.Filepath:new(self.outputDirectory:linux() .. [[/release/]] .. name, true)

        local originalText = LifeBoatAPI.Tools.FileSystemUtils.readAllText(entrypointFile)

        local combinedText = self.combiner:combine(originalText)
        if not params.skipCombinedFileOutput then
            LifeBoatAPI.Tools.FileSystemUtils.writeAllText(cmbFile, combinedText)
        end

        local minimizer = LifeBoatAPI.Tools.Minimizer:new(minimizerConstants, params or {})
        local finalText, newSize = minimizer:minimize(combinedText, params.boilerPlate)
        LifeBoatAPI.Tools.FileSystemUtils.writeAllText(outFile, finalText)

        print(name .. " minimized to: " .. tostring(newSize) .. " (" .. tostring(#finalText) .. " with comment) chars")

        return originalText, combinedText, finalText, outFile
    end;

    _setupVehicleConstants = function(self, docpath)
        local constants = LifeBoatAPI.Tools.ParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._vehicle_restricted_callbacks)  -- select from _vehicle_restricted and _mission_restricted
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(docpath)
        return constants
    end;

    _setupMissionConstants = function (self, docpath)
        local constants = LifeBoatAPI.Tools.ParsingConstantsLoader:new()
        constants:addRestrictedKeywords(constants._mission_restricted_callbacks)
        constants:loadLibrary("table")
        constants:loadLibrary("math")
        constants:loadLibrary("string", true)
        constants:loadNeloDocFile(docpath)
        return constants
    end;
}

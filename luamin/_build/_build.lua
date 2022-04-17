
require([[_build._buildactions]])
--- @diagnostic disable: undefined-global

require("LifeBoatAPI.Tools.Build.Builder")

local luaDocsAddonPath  = LifeBoatAPI.Tools.Filepath:new(arg[1]);
local luaDocsMCPath     = LifeBoatAPI.Tools.Filepath:new(arg[2]);
local outputDir         = LifeBoatAPI.Tools.Filepath:new(arg[3]);
local params            = {
    boilerPlate             = arg[4],
    reduceAllWhitespace     = arg[5] == "true",
    reduceNewlines          = arg[6] == "true",
    removeRedundancies      = arg[7] == "true",
    shortenVariables        = arg[8] == "true",
    shortenGlobals          = arg[9] == "true",
    shortenNumbers          = arg[10]== "true",
    forceNCBoilerplate      = arg[11]== "true",
    forceBoilerplate        = arg[12]== "true",
    shortenStringDuplicates = arg[13]== "true",
    removeComments          = arg[14]== "true",
    skipCombinedFileOutput  = arg[15]== "true"
};
local rootDirs          = {};

for i=15, #arg do
    table.insert(rootDirs, LifeBoatAPI.Tools.Filepath:new(arg[i]));
end

local _builder = LifeBoatAPI.Tools.Builder:new(rootDirs, outputDir, luaDocsMCPath, luaDocsAddonPath)

if onLBBuildStarted then onLBBuildStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]])) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Util.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Util.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Util.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Scope.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Scope.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\Scope.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\ParseLua.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\ParseLua.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\ParseLua.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\MyMicrocontroller.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\MyMicrocontroller.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\MyMicrocontroller.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatMini.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatMini.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatMini.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatIdentity.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatIdentity.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatIdentity.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatBeautiful.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatBeautiful.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]]), [[FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin\FormatBeautiful.lua]]), outFile, combinedText, outText) end

if onLBBuildComplete then onLBBuildComplete(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\luamin]])) end
--- @diagnostic enable: undefined-global


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

if onLBBuildStarted then onLBBuildStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]])) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[tt.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\tt.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[tt.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\tt.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[tt.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\tt.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[gen1.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[gen1.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[gen1.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[archived.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\archived.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[archived.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\archived.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[archived.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\archived.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\parse.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\parse.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\parse.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\lex.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\lex.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\lex.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Util.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Util.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\Util.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Util.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Scope.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Scope.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\Scope.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\Scope.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\ParseLua.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\ParseLua.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\ParseLua.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\ParseLua.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatMini.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatMini.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatMini.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatMini.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatIdentity.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatIdentity.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatIdentity.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatIdentity.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatBeautiful.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[luaminify\FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatBeautiful.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]]), [[luaminify\FormatBeautiful.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning\luaminify\FormatBeautiful.lua]]), outFile, combinedText, outText) end

if onLBBuildComplete then onLBBuildComplete(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\personal\STORMWORKS_VSCodeExtension\parsing_learning]])) end
--- @diagnostic enable: undefined-global

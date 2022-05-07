
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

if onLBBuildStarted then onLBBuildStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]])) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[test.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\test.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[sandbox.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\sandbox.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[sandbox.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\sandbox.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[sandbox.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\sandbox.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\utils.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\utils.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\utils.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\utils.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\utils.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\utils.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\run_scopetree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\run_scopetree.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\run_scopetree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\run_scopetree.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\run_scopetree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\run_scopetree.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\parse_symboltree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse_symboltree.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\parse_symboltree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse_symboltree.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\parse_symboltree.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\parse_symboltree.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\lex_tokenlist.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex_tokenlist.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[Parsing\lex_tokenlist.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex_tokenlist.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[Parsing\lex_tokenlist.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\Parsing\lex_tokenlist.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[notes\minify.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\minify.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[notes\minify.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\minify.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[notes\minify.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\minify.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[notes\dependency_graph.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\dependency_graph.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[notes\dependency_graph.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\dependency_graph.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[notes\dependency_graph.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\notes\dependency_graph.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[MyMicrocontroller.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[min\types_printout_with_comments.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout_with_comments.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[min\types_printout_with_comments.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout_with_comments.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[min\types_printout_with_comments.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout_with_comments.lua]]), outFile, combinedText, outText) end

if onLBBuildFileStarted then onLBBuildFileStarted(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[min\types_printout.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout.lua]])) end

local combinedText, outText, outFile = _builder:buildMicrocontroller([[min\types_printout.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout.lua]]), params)
if onLBBuildFileComplete then onLBBuildFileComplete(LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]]), [[min\types_printout.lua]], LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout.lua]]), outFile, combinedText, outText) end

if onLBBuildComplete then onLBBuildComplete(_builder, params, LifeBoatAPI.Tools.Filepath:new([[c:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning]])) end
--- @diagnostic enable: undefined-global

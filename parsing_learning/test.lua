require("Parsing.utils")
require("Parsing.parse_symboltree")
require("Parsing.run_scopetree")

local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))
local parsed = parse(text)

local scopeTree = createScopeTree(parsed)

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout.lua]]),
    "a=[[\n" .. printTypeTree(parsed) .. "]]")

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\Workspaces\STORMWORKS_VSCodeExtension\parsing_learning\min\types_printout_with_comments.lua]]),
    "a=[[\n" .. printTypeTree(parsed, true) .. "]]")

__simulator:exit()
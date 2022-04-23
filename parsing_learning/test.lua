require("Parsing.minify")

--local sandboxtext = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\Sandbox.lua]]))
--local parsedSandbox = parse(sandboxtext)

local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))
local parsed = parse(text)

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\gen1.lua]]),
    toString(parsed))

local minified = parsed

convertHexadecimals(minified)
    LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\min_hex_converted.lua]]),
    toString(minified))
    
--removeComments(minified)
--LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
--    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\min3.lua]]),
--    toString(minified))
--
--
--removeUnecessaryWhitespaceBlocks(minified)
--LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
--    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\min1.lua]]),
--    toString(minified))
--
--
--shrinkWhitespaceBlocks(minified)
--LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
--    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\min2.lua]]),
--    toString(minified))

local variableRenamer = VariableNamer:new(getSetOfAllIdentifiers(minified))
reduceDuplicateLiterals(minified, variableRenamer)

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min\min_var.lua]]),
    toString(minified))

__simulator:exit()

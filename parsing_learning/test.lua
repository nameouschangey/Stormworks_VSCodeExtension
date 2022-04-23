require("Parsing.minify")

local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))

local parsed = parse(text)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]),
    toString(parsed))

    local minified = parsed

removeComments(minified)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min3.lua]]),
    toString(minified))


removeUnecessaryWhitespaceBlocks(minified)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min1.lua]]),
    toString(minified))


shrinkWhitespaceBlocks(minified)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\min2.lua]]),
    toString(minified))



__simulator:exit()

luamin = require("ParseLua")
luaformat = require("FormatIdentity")

text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\MyMicrocontroller.lua]]))

success, parsed = luamin.ParseLua(text)
success, format = luaformat(parsed)

LifeBoatAPI.Tools.FileSystemUtils.writeAllText(
    LifeBoatAPI.Tools.Filepath:new([[C:\personal\STORMWORKS_VSCodeExtension\parsing_learning\gen1.lua]]),
    format
    )




__simulator:exit()
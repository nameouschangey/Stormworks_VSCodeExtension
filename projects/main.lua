-- Nameous Changey 2021
-- LOVE2D Simulator entrypoint
-- DO NOT EDIT OR MOVE this file, or risk breaking your Love2D integration
-- Moving this file out of the workspace root will also break the simulator; thanks to how Love2D works

require("LifeBoatAPI.Tools.Utils.LBFilepath")

local workspace = LBFilepath:new(arg[1], true)
local luaFile = LBFilepath:new(arg[2], true)

local requirePath = luaFile:relativeTo(workspace,true):linux():gsub(".lua", ""):gsub("/", ".")

require("LifeBoatAPI.Tools.Love2DSimulator.LBSimulator")
require(requirePath)
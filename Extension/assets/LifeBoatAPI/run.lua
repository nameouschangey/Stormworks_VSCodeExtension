-- Please note, this is an example setup, but as you do not have the MCs it expects - it will NOT "just run"
-- If you are not confident with Lua, it is advised you DO NOT use this feature
-- Simulating multiple MCs has a lot of quirks and you may be making your life harder.
-- Remember: The job of simulation is not replacing the game - it's to make your life easier.

-- After configuring this, you would run it with F6, and it should simulate multiple MCs for you.
-- That said, it is fully supported; hence the lua for the extension is provided for you to edit if needed

require("LifeBoatAPI.Simulator.MultiSimulatorExtension")
local __multiSim = LifeBoatAPI.Tools.MultiSimulator:new()

-----------LOAD MCS-------------------------------------------------------------------------------
-- set your MCs here
-- LoadMC takes the same parameter as require(...)
-- Order matters, they will draw to screen in this order (last over the top)

local loadingScreen = __multiSim:loadMC("MyMicrocontroller") -- replace each of these with one of your MC files you'd be chaining
--local navigation    = __multiSim:loadMC("Navigation_at_top_of_page")
--local menuLayout    = __multiSim:loadMC("Menu_Layout")

-----------CONFIG----------------------------------------------------------------------------------
-- set which MC should show it's inputs and outputs
__multiSim:setDisplayMC(loadingScreen)

-- configure how many screens to use
__multiSim._originalSim.config:configureScreen(1, "2x2", true, false)
__multiSim._originalSim.config:configureScreen(2, "2x2", true, false)

-- connect the MCs to each other

-- set "loaded" input after 3 seconds
loadingScreen.__simulator.config:addBoolHandler(10, function() return loadingScreen._globalTicks > 120 end)
loadingScreen.__simulator.config:addBoolHandler(11, function() return loadingScreen._globalTicks > 240 end)


-- wait for loading screen to set output 11
--  and only connect to Monitor 1
--navigation.__simulator.config:addNumberHandler(2, function() return loadingScreen.output._bools[11] and 1 or 0 end) -- once loadingScreen is done
--navigation.__simulator.config:addBoolHandler(3, function () return true end)
--navigation.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end
--
--
---- wait for loading screen to set output 11
----  and only connect to Monitor 1
--menuLayout.__simulator.config:addNumberHandler(29,function() return loadingScreen.output._bools[11] and 1 or 0 end)
--menuLayout.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end


-----------RUN----------------------------------------------------------------------------------
-- do not remove or edit this
onTick = __multiSim:generateOnTick()
onDraw = __multiSim:generateOnDraw()

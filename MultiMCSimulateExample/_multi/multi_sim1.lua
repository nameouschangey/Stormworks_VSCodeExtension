require("_multi.LBMultiSimulate")

-----------LOAD MCS-------------------------------------------------------------------------------
-- set your MCs here
-- LoadMC takes the same parameter as require(...)
-- Order matters, they will draw to screen in this order (last over the top)

local loadingScreen = LoadMC("Loading_Screen")
local navigation    = LoadMC("Navigation_at_top_of_page")
local menuLayout    = LoadMC("Menu_Layout")

-----------CONFIG----------------------------------------------------------------------------------
-- set which MC should show it's inputs and outputs
displayMCInOut(navigation)

-- configure how many screens to use
__simulator.config:configureScreen(1, "2x2", true, false)
__simulator.config:configureScreen(2, "2x2", true, false)

-- connect the MCs to each other

-- set "loaded" input after 3 seconds
loadingScreen.__simulator.config:addBoolHandler(10, function() return loadingScreen._globalTicks > 180 end)
loadingScreen.__simulator.config:addBoolHandler(11, function() return loadingScreen._globalTicks > 360 end)


-- wait for loading screen to set output 11
--  and only connect to Monitor 1
navigation.__simulator.config:addNumberHandler(2, function(a) return loadingScreen.output._bools[11] and 1 or 0 end) -- once loadingScreen is done
navigation.__simulator.config:addBoolHandler(3, function () return true end)
navigation.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end


-- wait for loading screen to set output 11
--  and only connect to Monitor 1
menuLayout.__simulator.config:addNumberHandler(29,function(a) return loadingScreen.output._bools[11] and 1 or 0 end)
menuLayout.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end




-----------RUN----------------------------------------------------------------------------------
-- do not remove this
onTick = multiTick
onDraw = multiDraw
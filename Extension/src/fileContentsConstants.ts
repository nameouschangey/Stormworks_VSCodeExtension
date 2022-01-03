// Note, this is very temporary
// When time permits, replace this with copying files from the Extension into the Project folder
//  as this is ever so slightly...idiotic


export const microControllerDefaultScript =
`
require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library


myButton = LifeBoatAPI.LBTouchScreen:lbtouchscreen_newButton(0, 1, 31, 9) -- using the TouchScreen functionality from LifeBoatAPI - make a simple button
isRedToggle = false -- toggle to keep track of whether to draw in red or green
ticks = 0

function onTick()
    LifeBoatAPI.LBTouchScreen:lbtouchscreen_onTick() -- touchscreen handler provided by LifeBoatAPI. Handles checking for clicks/releases etc.
    ticks = ticks + 1

    -- example: touchscreen buttons
    if myButton:lbbutton_isClicked() then
        isRedToggle = not isRedToggle    
    end

    -- example debugging random values, and checking things per tick
    local myRandomValue = math.random()    
    if(ticks%100 == 0) then
        -- Debugging Tip (F6 to run Simulator):
        --  By clicking just left of the line number (left column), you can set a little red dot; called a "breakpoint"
        --  When you run this in the LifeBoatAPI Simulator, the debugger will stop at each breakpoint and let you see the memory values
        -- You can also look at the "callstack" to see which functions were called to get where you are.
        --  Put a breakpoint to the left of this a = nil statement, and you'll be able to see what the value of "myRandomValue" is by hovering over it
        a = nil;
    end
end


function onDraw()
	-- when you simulate, you should see a slightly pink circle growing over 10 seconds and repeating.
    -- Clicking the button, will change between red and green
    if isRedToggle then
        screen.setColor(255, 125, 125)
    else
        screen.setColor(125, 255, 125)
    end
	
	screen.drawCircleF(16, 16, (ticks%600)/60)

    myButton:lbbutton_drawRect("Toggle") -- basic button drawing, you can of course use the .x,y,width,height property from the button to draw something more custom instead
end

--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder


`;

export const microControllerDefaultSimulatorConfig =
`
--- Note: code wrapped in ---@section <Identifier> <number> <Name> ... ---@endsection <Name>
---  Is only included in the final output if <Identifier> is seen <number> of times or more
---  This means the code below will not be included in the final, minimized version
---  And you can do the same to wrap library code; so that it's there if you use it, and deleted if you don't!
---  No more manual cutting/pasting code out!

---@section __SIMULATORONLY__ 1 _MAIN_SIMSECTION_INIT


-- When running the simulator, the global variable __simulator is created
-- Make sure to do any configuration before the the start of your main file
---@param simulator Simulator
---@param config SimulatorConfig
---@param helpers SimulatorInputHelpers
__simulator.config:configureScreen(1, "3x2", true, false)
__simulator.config:setProperty("ExampleProperty", 50)

-- handlers that automatically update the inputs each frame
-- useful for simple inputs (sweeps/wraps etc.)
__simulator.config:addBoolHandler(10,   function() return math.random() * 100 < 20 end)
__simulator.config:addNumberHandler(10, function() return math.random() * 100 end)

-- there's also a helpers library with a number of handling functions for you to try!
__simulator.config:addNumberHandler(10, LBSimulatorInputHelpers.constantNumber(5001))


--- runs every tick, prior to onTick and onDraw
--- Usually not needed, can allow you to do some custom manipulation
--- Or set breakpoints based on simulator state
---@param simulator Simulator
function onLBSimulatorTick(simulator)end

--- For easier debugging, called when an output value is changed
function onLBSimulatorOutputBoolChanged(index, oldValue, newValue)end
function onLBSimulatorOutputNumberChanged(index, oldValue, newValue)end

---@endsection _MAIN_SIMSECTION_INIT


`;

export const addonDefaultScript =
`
--- Note, minimizer functionality can be disabled in your project settings. (right click -> Folder Settings)
--- A large scale update for supporting Addon work is in the works, so keep an eye on the extension!

function onTick(game_ticks)
end

`;

export const preBuildActionsDefault =
`
-- This file is called just prior to the build process starting
-- Can add any pre-build actions; such as any code generation processes you wish, or other tool chains
-- Regular lua - you have access to the filesystem etc. via LifeBoatAPI.Tools.LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Started - No additional actions taken in _build/_pre_buildactions.lua")
`;


export const postBuildActionsDefault =
`
-- This file is called after the build process finished
-- Can be used to copy data into the game, trigger deployments, etc.
-- Regular lua - you have access to the filesystem etc. via LifeBoatAPI.Tools.LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Success - No additional actions in _build/_post_buildactions.lua file")
print("See the /out/release/ folder for your minimized code")
`;


export const simulateMultipleExample =
`
-- Please note, this is an example setup, but as you do not have the MCs it expects - it will NOT "just run"
-- If you are not confident with Lua, it is advised you DO NOT use this feature
-- Simulating multiple MCs has a lot of quirks and you may be making your life harder.
-- Remember: The job of simulation is not replacing the game - it's to make your life easier.

-- After configuring this, you would run it with F6, and it should simulate multiple MCs for you.
-- That said, it is fully supported; hence the lua for the extension is provided for you to edit if needed

require("LifeBoatAPI.Tools.Simulator.MultiSimulatorExtension")
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

`;
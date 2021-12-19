// Note, this is very temporary
// When time permits, replace this with copying files from the Extension into the Project folder
//  as this is ever so slightly...idiotic


export const microControllerDefaultScript =
`--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues
--- 	Please try to describe the issue clearly, and send a copy of the /_build/_debug_simulator_log.txt file, with any screenshots (thank you!)


--- With LifeBoatAPI; you can use the "require(...)" keyword to use code from other files!
---     This lets you share code between projects, and organise your work better.
---     The below, includes the content from _simulator_config.lua in the generated /_build/ folder
--- (If you want to include code from other projects, press CTRL+COMMA, and add to the LifeBoatAPI library paths)
require("_build._simulator_config")

--- default onTick function; called once per in-game tick (60 per second)
ticks = 0
function onTick()
    ticks = ticks + 1
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

--- default onDraw function; called once for each monitor connected each tick, order is not guaranteed
function onDraw()
	-- when you simulate, you should see a slightly pink circle growing over 10 seconds and repeating.
	screen.setColor(255, 125, 125)
	screen.drawCircleF(16, 16, (ticks%600)/60)
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
---@param simulator LBSimulator
---@param config LBSimulatorConfig
---@param helpers LBSimulatorInputHelpers
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
---@param simulator LBSimulator
function onLBSimulatorTick(simulator)end

--- For easier debugging, called when an output value is changed
function onLBSimulatorOutputBoolChanged(index, oldValue, newValue)end
function onLBSimulatorOutputNumberChanged(index, oldValue, newValue)end

---@endsection _MAIN_SIMSECTION_INIT


`;

export const addonDefaultScript =
`

function onTick(game_ticks)
end

`;

export const preBuildActionsDefault =
`
-- This file is called just prior to the build process starting
-- Can add any pre-build actions; such as any code generation processes you wish, or other tool chains
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Started - No additional actions taken in _build/_pre_buildactions.lua")
`;


export const postBuildActionsDefault =
`
-- This file is called after the build process finished
-- Can be used to copy data into the game, trigger deployments, etc.
-- Regular lua - you have access to the filesystem etc. via LBFilesystem
-- Recommend using LBFilepath for paths, to keep things easy

-- default is no actions
print("Build Success - No additional actions in _build/_post_buildactions.lua file")
`;


export const lbMultiSimulatorExtension =
`
-- Author: <Authorname> (Please change this in user settings, Ctrl+Comma)
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
--
-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)

-- Author: Nameous Changey
-- Please do not remove this notice
-- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--      By Nameous Changey (Please retain this notice at the top of the file as a courtesy; a lot of effort went into the creation of these tools.)

-- Note: This is entirely experimental
-- It affects _ENV, and there's a lot of chance of unpredictable results from data being shared between different environments
-- I will not be providing support for this Multi-MC Simulate, beyond providing this file

--- @diagnostic disable: undefined-global

_mcs = {}
_originalSim = __simulator
_originalSim._isInputOutputChanged = true
_originalInput = input -- for displaying to screen
_originalOutput = output -- for displaying to screen

function CopyTable(from, into, onlyExists)
    into = into or {}

    for k,v in pairs(from) do
        if(into[k] or not onlyExists) then
            into[k] = v
        end
    end
    return into
end

function CopyENV(name, env)
    local _env = CopyTable(env)

    env._globalTicks = 0
    
    ---@type LBSimulator_PropertiesAPI
    _env.property = CopyTable(_env.property)
    _env.property.name = name
    _env.property._numbers = CopyTable(_env.property._numbers)
    _env.property._bools = CopyTable(_env.property._bools)
    _env.property._texts = CopyTable(_env.property._texts)

    ---@type LBSimulator_InputAPI
    _env.input = CopyTable(_env.input)
    _env.input.name = name
    _env.input._numbers = CopyTable(_env.input._numbers)
    _env.input._bools = CopyTable(_env.input._bools)

    ---@type LBSimulator_OutputAPI
    _env.output = CopyTable(_env.output)
    _env.output.name = name
    _env.output._numbers = CopyTable(_env.output._numbers)
    _env.output._bools = CopyTable(_env.output._bools)

    ---@type LBSimulator
    _env.__simulator = CopyTable(_env.__simulator)
    _env.__simulator.name = name
    _env.__simulator.config = CopyTable(_env.__simulator.config)
    _env.__simulator.config.simulator = _env.__simulator
    _env.__simulator.config.name = name
    _env.__simulator.config.boolHandlers = CopyTable(_env.__simulator.config.boolHandlers)
    _env.__simulator.config.numberHandlers = CopyTable(_env.__simulator.config.numberHandlers)
    return _env
end

function LoadMC(name)
    local originalEnv = _ENV
    _ENV = CopyENV("MAIN", _ENV)

    require(name)

    local mcENV = CopyENV(name, _ENV._G)
    table.insert(_mcs, mcENV)

    _ENV = originalEnv
    _ENV.__simulator.config = LBSimulatorConfig:new(__simulator)

    onLBSimulatorTick = Empty
    onTick = Empty
    onDraw = Empty

    return mcENV
end


function multiTick()
    -- do not edit unless you know what you're doing
    for i, _env in ipairs(_mcs) do
        local originalENV = _ENV
        input = _env.input
        output = _env.output
        property = _env.property

        _ENV = _env

        __simulator.config:onSimulate()
        onSimulate = onLBSimulatorTick or Empty
        onSimulate(__simulator)

        if onTick then
            onTick()
        end

        _globalTicks = _globalTicks + 1

        _ENV = originalENV
        input = originalENV.input
        output = originalENV.output
        property = originalENV.property
    end

    hasChanged = false
    if _displayableMC then
        for i=1, 32 do

            hasChanged = hasChanged or
                (_originalInput._bools[i] ~= _displayableMC.input._bools[i] or
                _originalInput._numbers[i] ~= _displayableMC.input._numbers[i] or
                _originalOutput._bools[i] ~= _displayableMC.output._bools[i] or
                _originalOutput._numbers[i] ~= _displayableMC.output._numbers[i])

            _originalInput._bools[i] = _displayableMC.input._bools[i]
            _originalInput._numbers[i] = _displayableMC.input._numbers[i]

            _originalOutput._bools[i] = _displayableMC.output._bools[i]
            _originalOutput._numbers[i] = _displayableMC.output._numbers[i]

        end
    end

    if hasChanged then
        _originalSim._isInputOutputChanged = true
    end
end

function multiDraw()
    -- do not edit unless you know what you're doing
    for i, _env in ipairs(_mcs) do
        local originalENV = _ENV
        _ENV = _env


        if(onDraw) then
            if onLBSimulatorShouldDraw == nil or onLBSimulatorShouldDraw(screen._simulator._currentScreen.screenNumber) then
                onDraw()
            end
        end

        _ENV = originalENV
    end
end

function displayMCInOut(mc)
    _displayableMC = mc
end

--- @diagnostic enable: undefined-global

`;

export const simulateMultipleExample =
`
-- Please note, this is an example setup, but as you do not have the MCs it expects - it will NOT "just run"
-- If you are not confident with Lua, it is advised you DO NOT use this feature
-- Simulating multiple MCs has a lot of quirks and you may be making your life harder.
-- Remember: The job of simulation is not replacing the game - it's to make your life easier.

-- After configuring this, you would run it with F6, and it should simulate multiple MCs for you.
-- That said, it is fully supported; hence the lua for the extension is provided for you to edit if needed

require("_build._multi.LBMultiSimulatorExtension")

-----------LOAD MCS-------------------------------------------------------------------------------
-- set your MCs here
-- LoadMC takes the same parameter as require(...)
-- Order matters, they will draw to screen in this order (last over the top)

local loadingScreen = LoadMC("Loading_Screen") -- replace each of these with one of your MC files you'd be chaining
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
loadingScreen.__simulator.config:addBoolHandler(10, function() return loadingScreen._globalTicks > 120 end)
loadingScreen.__simulator.config:addBoolHandler(11, function() return loadingScreen._globalTicks > 240 end)


-- wait for loading screen to set output 11
--  and only connect to Monitor 1
navigation.__simulator.config:addNumberHandler(2, function() return loadingScreen.output._bools[11] and 1 or 0 end) -- once loadingScreen is done
navigation.__simulator.config:addBoolHandler(3, function () return true end)
navigation.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end


-- wait for loading screen to set output 11
--  and only connect to Monitor 1
menuLayout.__simulator.config:addNumberHandler(29,function() return loadingScreen.output._bools[11] and 1 or 0 end)
menuLayout.onLBSimulatorShouldDraw = function (screenNumber) return screenNumber == 1 end


-----------RUN----------------------------------------------------------------------------------
-- do not remove or edit this
onTick = multiTick
onDraw = multiDraw
`;
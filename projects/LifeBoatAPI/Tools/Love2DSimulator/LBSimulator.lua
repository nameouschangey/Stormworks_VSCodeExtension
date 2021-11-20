---@diagnostic disable: undefined-global
if not _debugger then
    _debugger = require("lldebugger")
end


require("LifeBoatAPI.Tools.Love2DSimulator.LBSimulator_InputOutputAPI")
require("LifeBoatAPI.Tools.Love2DSimulator.LBSimulator_ScreenAPI")
require("LifeBoatAPI.Tools.Love2DSimulator.LBSimulator_Config")


debugOnTick = false
debugOnDraw = false
-- overwrite tostring, as the 5.1 (Love2D) version doesn't like getting nil values
-- there'll be some other 5.1 differences we'll find eventually - but for now this is the main one
__oldtostring = tostring
function tostring(arg)
    if arg == nil then
        return __oldtostring("nil")
    else
        return __oldtostring(arg)
    end
end


-- override "error" function with debugger breakpoint
__oldError = error
function error(msg)
    if(_debugger) then
        _debugger:start()
    end
    __oldError(msg)
end

function love.load()
    local font = love.graphics.newFont("/LifeBoatAPI/Tools/Love2DSimulator/Love2DFont/slkscr.ttf")
    font:setFilter("nearest", "nearest")
    love.graphics.setFont(font)

    love.window.setMode(screen._Love2DScreenWidth, screen._Love2DScreenHeight, {resizable=true})
end

function love.resize(w, h)
    screen._Love2DScreenWidth  = w
    screen._Love2DScreenHeight = h
end

-- simulate the onTick from Stormworks
love.lb_timeToSimulate = 0
love.lb_timePerFrame = 1 / 60
function love.update(dt)
    love.lb_timeToSimulate = love.lb_timeToSimulate + dt
    
    while love.lb_timeToSimulate > love.lb_timePerFrame do
        love.lb_timeToSimulate = love.lb_timeToSimulate - love.lb_timePerFrame

        -- If you don't know what to do, press F5 and it'll continue to your next breakpoint
        if(debugOnTick or debugNextTick) then
            _debugger:start()
        end
        debugNextTick = false

        -- chance to do any simulated stuff, e.g. clicks and cursor positioning etc.
        if(simulator_onTick) then
            _, _, skip_tick = xpcall(simulator_onTick, error)  -- can return true from simulator_onTick() to skip/pause ticks. Useful for slowmo or manual step-through
        else
            LBSimulatorConfig_Input:updateMonitorTouches()
        end

        if(not skip_tick and onTick) then
            xpcall(onTick, error)
        end
    end
end


-- simulate the onDraw
function love.draw()
    -- set drawing surface area
    screen.love2D_recalculateScreen()

    love.graphics.clear(0.4, 0.4, 0.5, 0)

    -- draw actual screen in middle
    screen.setColor(0,0,0,0)
    screen.drawClear()

    if(onDraw)then

        -- If you don't know what to do, press F5 and it'll continue to your next breakpoint
        if(debugOnDraw or debugNextDraw) then
            _debugger:start()
            debugNextDraw = false
        end
        
        xpcall(onDraw, error)
    end

    --draw over the borders of the screen so it all fits on the screen
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), screen.love2D_y(0))                                         -- top
    love.graphics.rectangle("fill", 0, screen.love2D_y(screen.getHeight()), love.graphics.getWidth(), love.graphics.getHeight())  -- bottom
    love.graphics.rectangle("fill", 0, 0, screen.love2D_x(0), love.graphics.getHeight())                                        -- left
    love.graphics.rectangle("fill", screen.love2D_x(screen.getWidth()), 0, love.graphics.getWidth(), love.graphics.getHeight())   -- right

    -- draw the input/output values for visual debugging
    love.graphics.setColor(1,1,1)
    text_spacing = 15
    for i=1,32,1 do
        love.graphics.print("in" .. tostring(i),            10,  10 + (i * text_spacing))
        love.graphics.print(tostring(input.getNumber(i)),   50,  10 + (i * text_spacing))
        love.graphics.print(tostring(input.getBool(i)),     100, 10 + (i * text_spacing))            
        love.graphics.print("out" .. tostring(i),           love.graphics.getWidth() - 150, 10 + (i * text_spacing))
        love.graphics.print(tostring(output._numbers[i]),   love.graphics.getWidth() - 100, 10 + (i * text_spacing))
        love.graphics.print(tostring(output._bools[i]),     love.graphics.getWidth() - 50,  10 + (i * text_spacing))
    end
end



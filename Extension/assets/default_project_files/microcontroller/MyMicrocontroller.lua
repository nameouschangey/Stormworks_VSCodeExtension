-- Boilerplate
-- Boilerplate
-- Boilerplate
-- Boilerplate
-- Boilerplate
-- Boilerplate

require("_build._simulator_config") -- default simulator config, CTRL+CLICK or F12 to goto this file and edit it. Separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

--  Want to test everything works? Just hit F6 and the simulator will run
--  Remember, you can add a breakpoint by clicking to the left of the line-number, for full debugging!

myButton = LifeBoatAPI.LBTouchScreen:lbtouchscreen_newButton(0, 1, 31, 9) -- using the TouchScreen functionality from LifeBoatAPI - make a simple button
ticks = 0

function onTick()
    LifeBoatAPI.LBTouchScreen:lbtouchscreen_onTick() -- touchscreen handler provided by LifeBoatAPI. Handles checking for clicks/releases etc.
    ticks = ticks + 1

    -- example: touchscreen buttons
    if myButton:lbbutton_isClicked() then
        isRedToggle = not isRedToggle    
    end
end

function onDraw()
	-- when you simulate (F6), you should see a slightly green circle growing over 10 seconds and repeating.
    -- Clicking the button, will change between red and green
    if isRedToggle then
        LifeBoatAPI.LBColorSpace.lbcolorspace_setColorGammaCorrected(255, 125, 125) -- replacement for screen.setColor, that corrects the colours to be less washed out
    else
        LifeBoatAPI.LBColorSpace.lbcolorspace_setColorGammaCorrected(125, 255, 125)
    end
	
	screen.drawCircleF(16, 16, (ticks%600)/60)

    myButton:lbbutton_drawRect("Toggle") -- basic button drawing, you can of course use the .x,y,width,height property from the button to draw something more custom instead
end

--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder

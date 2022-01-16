

require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

--  Want to test everything works? Just hit F6 and the simulator will run
--  Remember, you can add a breakpoint by clicking to the left of the line-number, for full debugging!


-- color palette, keeping them here makes UI easier to restyle
color_Highlight = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(230, 230, 230)   -- offwhite
color_Inactive  = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(100,100,100)     -- grey
color_Active    = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(230,150,0)   -- orangeRed

-- define out button
myButton = LifeBoatAPI.LBTouchScreen:lbtouchscreen_newStyledButton(0, 1, 31, 9, "Toggle", color_Highlight, color_Inactive, color_Active, color_Highlight,color_Inactive) -- using the TouchScreen functionality from LifeBoatAPI - make a simple button

ticks = 0
function onTick()
    LifeBoatAPI.LBTouchScreen:lbtouchscreen_onTick() -- touchscreen handler provided by LifeBoatAPI. Handles checking for clicks/releases etc.
    ticks = ticks + 1

    -- listen for the button being "clicked and released" (a "true" click like Windows)
    --   then toggle the circle drawing color
    if myButton:lbstyledbutton_isReleased() then
        isCircleColorToggled = not isCircleColorToggled    
    end
end

function onDraw()
	-- when you simulate (F6), you should see a grey circle growing over 10 seconds and repeating.
    -- Clicking the button, will change between orangeRed and grey
    if isCircleColorToggled then
        color_Active:lbcolorrgba_setColor() -- replacement for screen.setColor
    else
        color_Inactive:lbcolorrgba_setColor()
    end
	screen.drawCircleF(16, 16, (ticks%600)/60)

    -- draw our button - using its internal styling (set at the top when we created it)
    myButton:lbstyledbutton_draw() -- this button code is of course just as an example, CTRL+CLICK any function to see how it was written, to write your own better one
end

--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder
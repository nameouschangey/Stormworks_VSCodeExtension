g=100;f=true;_="1234234";h=nil;d=230;e=false;-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

a = 291
b = 144452
c = 16773120

asd  = "123"
def  = _
deff = _
d2ff = _
d3ff = _

asd = f, f, f, e, e, e, h, h, h, h, h
-- F6 To run me!

a = g,g,g,g,g,g

require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library


-- color palette, keeping them here makes UI easier to restyle
color_Highlight = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(d, d, d)   -- offwhite
color_Inactive  = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(g,g,g)     -- grey
color_Active    = LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(d,150,0)   -- orangeRed

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
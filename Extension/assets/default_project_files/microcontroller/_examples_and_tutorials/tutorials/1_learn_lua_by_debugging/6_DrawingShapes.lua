-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------


-- F6 to run!


tickCounter = 0 -- we'll use this in onTick

onTick = function()
    tickCounter = tickCounter + 1 -- add 1 each tick, so we can count how many ticks

    ticksWrappedInto10Seconds = tickCounter % 600 -- (%) gives us the modulo/remainder; aka, a number wrapped around into that range
    percentOf10Seconds = ticksWrappedInto10Seconds / 600 -- divide our number that's between 0->600, by 600, and it'll be in the range 0->1. aka 0.1 is 10%, etc.
                                                         -- this is just a handy maths trick we can use
end


onDraw = function()
    -- we're going to use the values we calculate in onTick, in onDraw
    -- because these variables are all "global", we can use them anywhere
    -- think of there being one GIANT heap of all our variable boxes; we can find any of them easily

    canStickABreakpointHereAndSee = percentOf10Seconds




    -- not something to worry about for now, but for later - this is a "local" variable.
    --  it goes on a heap of boxes that can ONLY exists until we reach the end of this block of code
    local myValue = 123 -- can't use this in onTick - because it only exists from here, till we reach the end of this function
end
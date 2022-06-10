-- Author: Nameous Changey
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
------------------------------------------------------------------------------------------------------------------------------------------------------------

-- F6 to run, example blinker

-- function that returns a table that represents a blinker
createBlinker = function(ticksToStayOff, ticksToStayOn)
    local blinker = {
        ticksOn = ticksToStayOn,
        ticksOff = ticksToStayOff,
        ticks = 1,
        isOn = false,
        onTick = function(this)
            this.ticks = (this.ticks + 1) % (this.ticksOn + this.ticksOff)
            this.isOn = this.ticks > this.ticksOff
        end
    }
    return blinker
end


-- create a new blinker (we could make multiple, easily like this)
myBlinker = createBlinker(60, 30)

onTick = function ()
    myBlinker:onTick() -- blinker handles its own updates, we just need to tell it to update each tick
end


onDraw = function ()
    -- example drawing based on the blinker's current state
    if myBlinker.isOn then
        screen.setColor(100,255,100)
        screen.drawRectF(5,5,2,2)
    else
        screen.setColor(255,100,100)
        screen.drawRect(5,5,2,2)
    end
end


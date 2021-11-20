
--- Property Setup
---@class LBSimulatorConfig_Properties
LBSimulatorConfig_Properties =
{
    setProperty = function(this, label, value)
        if type(value) == "string" then
            property._texts[label] = value
        elseif type(value) == "boolean" then
            property._bools[label] = value
        elseif type(value) == "number" then
            property._numbers[label] = value
        else
            error("Stormworks properties must be Numbers, Strings or Booleans, when you tried to set property: " .. tostring(label))
        end
    end;
}

--- Property Setup
---@class LBSimulatorConfig_Screen
LBSimulatorConfig_Screen =
{
    setSizePixels = function(this, width, height)
        screen._Width = width
        screen._Height = height
    end;

    set1x1 = function(this) this:setSizePixels(32,32) end;

    set1x2 = function(this) this:setSizePixels(32,64) end;
    set1x2Portrait = function(this) this:setSizePixels(64,32) end;

    set1x3 = function(this) this:setSizePixels(32,96) end;
    set1x3Portrait = function(this) this:setSizePixels(96,32) end;

    set2x2 = function(this) this:setSizePixels(64,64) end;

    set2x3 = function(this) this:setSizePixels(96,64) end;
    set2x3Portrait = function(this) this:setSizePixels(64,96) end;

    set3x3 = function(this) this:setSizePixels(96,96) end;

    set5x3 = function(this) this:setSizePixels(160,96) end;
    set5x3Portrait = function(this) this:setSizePixels(96,160) end;

    set9x5 = function(this) this:setSizePixels(288,160) end;
    set9x5Portrait = function(this) this:setSizePixels(160,288) end;
}

--- Input functions
---@class LBSimulatorConfig_Input
LBSimulatorConfig_Input =
{
    _indexErrorCheck = function(this, index)
        if(index < 1 or index > 32) then
            error("Stormworks inputs must be in the range 1->32, but you tried to configue index: " .. tostring(index))
        end
    end;

    updateMonitorTouches = function(this)
        local mouseX = screen.getWidth()  * (((love.mouse.getX() or 0) - screen.love2D_x(0)) / screen._DrawableWidth)
        local mouseY = screen.getHeight() * (((love.mouse.getY() or 0) - screen.love2D_y(0)) / screen._DrawableHeight)

        mouseX = math.ceil(mouseX)
        mouseY = math.ceil(mouseY)

        if(mouseX <= 0 or mouseX > screen.getWidth() or 
           mouseY <= 0 or mouseY > screen.getHeight()) then
            mouseX = 0
            mouseY = 0
        end
        
        eDown = love.mouse.isDown(1)
        qDown = love.mouse.isDown(2)

        this:updateValue(1, false)
        this:updateValue(2, false)

        -- note, the screen touch position only updates when touching
        -- there is no on-hover ability
        if (eDown or qDown) and mouseX > 0 and mouseY > 0 then
            this:updateValue(1, eDown)
            this:updateValue(2, qDown)
            this:updateValue(3, mouseX)
            this:updateValue(4, mouseY)
        end
        this:updateValue(1, screen.getWidth())
        this:updateValue(2, screen.getHeight())
    end;
    
    updateValue = function(this, index, value)
        this:_indexErrorCheck(index)
        if(type(value) == "number") then
            input._numbers[index] = value
        elseif (type(value) == "boolean") then
            input._bools[index] = value
        else
            error("Stormworks inputs must be Numbers or Booleans, when you tried to set input: " .. tostring(index) .. " to a " .. type(value))
        end
    end;

    updateWrappedNumber = function(this, index, min, max, step)
        this:_indexErrorCheck(index)
        step = step or ((max-min) * 60)
        input._numbers[index] = (((input._numbers[index] or min) + step) % max) + 1
    end;

    updateNoiseyNumber = function (this, index, noiseMax)
        this:_indexErrorCheck(index)
        input._numbers[index] = (input._numbers[index] or 0) + (math.random()-0.5) * noiseMax
    end;
}

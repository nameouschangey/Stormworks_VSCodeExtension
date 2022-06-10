---@section LBTOUCHSCREENBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@class LBTouchScreen
---@field screenWidth number
---@field screenHeight number
---@field touchX number
---@field touchY number
---@field wasPressed boolean if the screen was being touched last tick
---@field isPressed boolean if the screen is being touched this frame
---@section LBTouchScreen 1 LBTOUCHSCREENCLASS
LifeBoatAPI.LBTouchScreen = {

    ---@section lbtouchscreen_onTick
    --- If using the button functionality, it is expected that you call this at the start of onTick
    --- Handles the touchscreen state for whether things are pressed or not
    ---@param this LBTouchScreen
    ---@param compositeOffset number default composite for touches is 1,2,3,4; offset if composite has been re-routed
    ---@overload fun(self)
    lbtouchscreen_onTick = function(this, compositeOffset)
        compositeOffset = compositeOffset or 0
        this.screenWidth    = input.getNumber(compositeOffset + 1)
        this.screenHeight   = input.getNumber(compositeOffset + 2)
        this.touchX         = input.getNumber(compositeOffset + 3)
        this.touchY         = input.getNumber(compositeOffset + 4)
        this.wasPressed     = this.isPressed or false
        this.isPressed      = input.getBool(compositeOffset + 1)
    end;
    ---@endsection

    ---@section lbtouchscreen_newButton 1 LBTOUCHSCREEN_NEWBASICBUTTON
    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param this LBTouchScreen
    ---@param x         number topleft x position of the button
    ---@param y         number topleft y position of the button
    ---@param width     number width of the button
    ---@param height    number height of the button
    ---@param text      string text to display in the button
    ---@return LBTouchScreenButton button button object to check for touches
    lbtouchscreen_newButton = function (this, x, y, width, height, text)
        ---@class LBTouchScreenButton
        ---@field touchScreenRef LBTouchScreen reference to the touchscreen, needed for tracking click state
        ---@field x number topLeft x position of the button
        ---@field y number topLeft y position of the button
        ---@field width number width of the button rect
        ---@field height number height of the button rect
        local button = {
            touchScreenRef = this,
            x = x,
            y = y,
            width = width,
            height = height,
            text = text,

            ---@section lbbutton_isClicked
            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param this LBTouchScreenButton
            lbbutton_isClicked = function(this)
                return this.touchScreenRef.isPressed
                        and not this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbbutton_isHeld
            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param this LBTouchScreenButton
            lbbutton_isHeld = function(this)
                return this.touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbbutton_isReleased
            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param this LBTouchScreenButton
            lbbutton_isReleased = function(this)
                return not this.touchScreenRef.isPressed
                        and this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbbutton_draw
            --- Simple drawing function, can make life easier while prototyping things
            ---@param this LBTouchScreenButton
            lbbutton_draw = function(this)
                screen.drawRect(this.x, this.y, this.width, this.height)
                screen.drawTextBox(this.x+1, this.y+1, this.width-1, this.height-1, this.text, 0, 0)
            end;
            ---@endsection

            ---@section lbbutton_drawRect
            ---@deprecated
            --- DEPRECATED please use lbbutton_draw instead, and set text value in :new()
            --- This function will be removed in a future version, please update your code.
            ---@param this LBTouchScreenButton
            lbbutton_drawRect = function(this, text)
                screen.drawRect(this.x, this.y, this.width, this.height)
                screen.drawTextBox(this.x+1, this.y+1, this.width-1, this.height-1, this.text or text, 0, 0)
            end;
            ---@endsection
        }
        return button
    end;
    ---@endsection LBTOUCHSCREEN_NEWBASICBUTTON

    ---@section lbtouchscreen_newStyledButton 1 LBTOUCHSCREEN_NEWSTYLEDBUTTON
    --- PLEASE BE AWARE, FANCY STYLED BUTTONS HAVE A RELATIVELY HIGH CHARACTER COST
    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param this LBTouchScreen
    ---@param x number topleft x position of the button
    ---@param y number topleft y position of the button
    ---@param width number width of the button
    ---@param height number height of the button
    ---@param borderColor LBColorRGBA color for the border
    ---@param fillColor LBColorRGBA color for the fill, when not clicked
    ---@param fillPushColor LBColorRGBA color when pushed
    ---@param textColor LBColorRGBA color for the text
    ---@param textPushColor LBColorRGBA color for the text when clicked
    ---@return LBTouchScreenButtonStyled button button object to check for touches
    lbtouchscreen_newStyledButton = function (this, x, y, width, height,
                                                        text,
                                                        textColor,
                                                        fillColor,
                                                        borderColor,
                                                        fillPushColor,
                                                        textPushColor)
        ---@class LBTouchScreenButtonStyled
        ---@field touchScreenRef LBTouchScreen reference to the touchscreen, needed for tracking click state
        ---@field x number topLeft x position of the button
        ---@field y number topLeft y position of the button
        ---@field width number width of the button rect
        ---@field height number height of the button rect
        ---@field text string text to display in the button
        ---@field borderColor LBColorRGBA height of the button rect
        ---@field fillColor LBColorRGBA height of the button rect
        ---@field fillPushColor LBColorRGBA height of the button rect
        ---@field textColor LBColorRGBA height of the button rect
        ---@field textPushColor LBColorRGBA height of the button rect
        local button = {
            touchScreenRef = this,
            x = x,
            y = y,
            width = width,
            height = height,
            text = text,
            borderColor     = borderColor or textColor,
            fillColor       = fillColor,
            fillPushColor   = fillPushColor or fillColor,
            textColor       = textColor,
            textPushColor   = textPushColor or textColor,

            ---@section lbstyledbutton_isClicked
            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param this LBTouchScreenButtonStyled
            lbstyledbutton_isClicked = function(this)
                return this.touchScreenRef.isPressed
                        and not this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbstyledbutton_isHeld
            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param this LBTouchScreenButtonStyled
            lbstyledbutton_isHeld = function(this)
                return this.touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbstyledbutton_isReleased
            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param this LBTouchScreenButtonStyled
            lbstyledbutton_isReleased = function(this)
                return not this.touchScreenRef.isPressed
                        and this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            ---@section lbstyledbutton_draw
            --- Simple drawing function, can make life easier while prototyping things
            ---@param this LBTouchScreenButtonStyled
            lbstyledbutton_draw = function(this)
                (this:lbstyledbutton_isHeld() and this.fillPushColor or this.fillColor):lbcolorrgba_setColor()
                screen.drawRectF(this.x, this.y, this.width, this.height);

                (this:lbstyledbutton_isHeld() and this.textPushColor or this.textColor):lbcolorrgba_setColor()
                screen.drawTextBox(this.x+1, this.y+1, this.width-1, this.height-1, this.text, 0, 0)

                this.borderColor:lbcolorrgba_setColor()
                screen.drawRect(this.x, this.y, this.width, this.height)
            end;
            ---@endsection
        }
        return button
    end;
    ---@endsection LBTOUCHSCREEN_NEWSTYLEDBUTTON
}
---@endsection LBTOUCHSCREENCLASS

---@class LBTouchScreen
---@field screenWidth number
---@field screenHeight number
---@field touchX number
---@field touchY number
---@field wasPressed boolean if the screen was being touched last tick
---@field isPressed boolean if the screen is being touched this frame
---@section LBTouchScreen 1 LBTOUCHSCREENCLASS
LifeBoatAPI.LBTouchScreen = {

    --- If using the button functionality, it is expected that you call this at the start of onTick
    --- Handles the touchscreen state for whether things are pressed or not
    ---@param this LBTouchScreen
    ---@param compositeOffset number default composite for touches is 1,2,3,4; offset if composite has been re-routed
    lbtouchscreen_onTick = function(this, compositeOffset)
        compositeOffset = compositeOffset or 0
        this.screenWidth    = input.getNumber(compositeOffset + 1)
        this.screenHeight   = input.getNumber(compositeOffset + 2)
        this.touchX         = input.getNumber(compositeOffset + 3)
        this.touchY         = input.getNumber(compositeOffset + 4)
        this.wasPressed     = this.isPressed or false
        this.isPressed      = input.getBool(compositeOffset + 1)
    end;

    --- Create a new button that works with the LBTouchScreen
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param this LBTouchScreen
    ---@param x number topleft x position of the button
    ---@param y number topleft y position of the button
    ---@param width number width of the button
    ---@param height number height of the button
    ---@return LBTouchScreenButton button button object to check for touches
    ---@section lbtouchscreen_newBasicButton 1 LBTOUCHSCREEN_NEWBASICBUTTON
    lbtouchscreen_newButton = function (this, x, y, width, height)
        ---@class LBTouchScreenButton
        ---@field touchScreenRef LBTouchScreen reference to the touchscreen, needed for tracking click state
        ---@field enabled boolean true for active, false disables all click functionality for this button
        ---@field x number topLeft x position of the button
        ---@field y number topLeft y position of the button
        ---@field width number width of the button rect
        ---@field height number height of the button rect
        _lbtouchscreen_button = {
            touchscreenRef = this,
            enabled = true,
            x = x,
            y = y,
            width = width,
            height = height,

            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param this LBTouchScreenButton
            ---@section lbbutton_isClicked
            lbbutton_isClicked = function(this)
                return this.touchScreenRef.isPressed
                        and not this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param this LBTouchScreenButton
            ---@section lbbutton_isHeld
            lbbutton_isHeld = function(this)
                return this.touchScreenRef.isPressed
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection

            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param this LBTouchScreenButton
            ---@section lbbutton_isReleased
            lbbutton_isReleased = function(this)
                return not this.touchScreenRef.isPressed
                        and this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.x, this.y, this.width, this.height)
            end;
            ---@endsection
        }
        return _lbtouchscreen_button
    end;
    ---@endsection LBTOUCHSCREEN_NEWBASICBUTTON
}
---@endsection LBTOUCHSCREENCLASS
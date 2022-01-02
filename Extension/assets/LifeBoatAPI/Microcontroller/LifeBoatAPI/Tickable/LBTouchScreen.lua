
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
    ---@section lbtouchscreen_newButton 1 LBTOUCHSCREEN_NEWBASICBUTTON
    lbtouchscreen_newButton = function (this, x, y, width, height)
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

            --- Simple drawing function, can make life easier while prototyping things
            ---@param this LBTouchScreenVecButton
            ---@param text string button name
            ---@section lbbutton_drawRect
            lbbutton_drawRect = function(this, text)
                screen.drawRect(this.x, this.y, this.width, this.height)
                screen.drawTextBox(this.x, this.y, this.width, this.height, text, 0, 0)
            end;
            ---@endsection
        }
        return button
    end;
    ---@endsection LBTOUCHSCREEN_NEWBASICBUTTON

    --- Create a new button that works with the LBTouchScreen
    --- If already using the LBVec library, it's recommended to use this as it'll make life easier
    --- Note, you must call LBTouchScreen.lbtouchscreen_ontick() at the start of onTick to make these buttons work
    ---@param this LBTouchScreen
    ---@param position LBVec position vector for the button (top/left)
    ---@param size LBVec size vector for the button (x = width, y = height)
    ---@return LBTouchScreenVecButton button button object to check for touches
    ---@section lbtouchscreen_newVectorButton 1 LBTOUCHSCREEN_NEWVECTORBUTTON
    lbtouchscreen_newVectorButton = function (this, position, size)
        ---@class LBTouchScreenVecButton
        ---@field touchScreenRef LBTouchScreen reference to the touchscreen, needed for tracking click state
        ---@field position LBVec
        ---@field size LBVec
        local button = {
            touchScreenRef = this,
            position = position,
            size = size,

            --- Checks if this button was clicked; triggers ONLY on the frame it's being clicked
            ---@param this LBTouchScreenVecButton
            ---@section lbvecbutton_isClicked
            lbvecbutton_isClicked = function(this)
                return this.touchScreenRef.isPressed
                        and not this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.position.x, this.position.y, this.size.x, this.size.y)
            end;
            ---@endsection

            --- Checks if this button is being pressed (i.e. HELD down), returns true on every frame it is being held
            ---@param this LBTouchScreenVecButton
            ---@section lbvecbutton_isHeld
            lbvecbutton_isHeld = function(this)
                return this.touchScreenRef.isPressed
                and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.position.x, this.position.y, this.size.x, this.size.y)
            end;
            ---@endsection

            --- Checks for the user lifting the mouse button, like a "on mouse up" event. Note; this is actually how most buttons work on your computer.
            ---@param this LBTouchScreenVecButton
            ---@section lbvecbutton_isReleased
            lbvecbutton_isReleased = function(this)
                return not this.touchScreenRef.isPressed
                        and this.touchScreenRef.wasPressed 
                        and LifeBoatAPI.LBMaths.lbmaths_isPointInRectangle(this.touchScreenRef.touchX, this.touchScreenRef.touchY, this.position.x, this.position.y, this.size.x, this.size.y)
            end;
            ---@endsection

            --- Simple drawing function, can make life easier while prototyping things
            ---@param this LBTouchScreenVecButton
            ---@param text string button name
            ---@section lbvecbutton_drawRect
            lbvecbutton_drawRect = function(this, text)
                screen.drawRect(this.position.x, this.position.y, this.size.x, this.size.y)
                screen.drawTextBox(this.position.x, this.position.y, this.size.x, this.size.y, text, 0, 0)
            end;
            ---@endsection
        }
        return button
    end;
    ---@endsection LBTOUCHSCREEN_NEWVECTORBUTTON
}
---@endsection LBTOUCHSCREENCLASS
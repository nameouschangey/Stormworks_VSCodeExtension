---@section LBMATHSBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBColorRGBA 1 LBCOLORRGBACLASS
---@class LBColorRGBA
---@field r number red   0->255
---@field g number green 0->255
---@field b number blue  0->255
---@field a number alpha 255->0 (0 is transparent)
LifeBoatAPI.LBColorRGBA = {
    ---@section lbcolorrgba_newRGBA
    --- Creates a new LBColorRGBA from simple RGBA values
    ---@param this LBColorRGBA
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number alpha 0->255
    lbcolorrgba_newRGBA = function (this, r,g,b,a)
        return LifeBoatAPI.lb_copy(this, {r=r, g=g, b=b, a=a or 255})
    end;
    ---@endsection

    ---@section lbcolorrgba_newGammaCorrected
    --- Creates a new LBColorRGBA, correcting for the game's gamma factor
    --- Allows for colours that are closer to the expected HTML values
    ---@param this LBColorRGBA
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number alpha 0->255
    ---@param constantCorrection number (default 0.8) constant factor, as K in the equation (K*color) ^ gamma
    ---@param gamma number (default 2.6) gamma factor, in the equation (K*color) ^ gamma
    ---@overload fun(self, r,g,b,a)
    --- see explanation of Stormworks gamma here: https://steamcommunity.com/sharedfiles/filedetails/?id=2273112890
    lbcolorrgba_newGammaCorrected = function (this, r,g,b,a, gamma, constantCorrection)
        constantCorrection = constantCorrection or 0.85
        gamma = gamma or 2.4

        return LifeBoatAPI.lb_copy(this,
                                    {r=255*(constantCorrection*r/255)^gamma,
                                     g=255*(constantCorrection*g/255)^gamma,
                                     b=255*(constantCorrection*b/255)^gamma,
                                     a=a or 255})
    end;
    ---@endsection

    ---@section lbcolorrgba_setColor
    --- Set the screen color with the current values of this LBColorRGBA
    ---@param this LBColorRGBA
    lbcolorrgba_setColor = function (this)
        screen.setColor(this.r, this.g, this.b, this.a)
    end;
    ---@endsection
}
---@endsection LBCOLORRGBACLASS
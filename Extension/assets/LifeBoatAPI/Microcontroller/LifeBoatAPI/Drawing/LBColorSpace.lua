---@section LBMATHSBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

require("LifeBoatAPI.Utils.LBCopy")

---@section LBColorSpace 1 LBCOLORSPACECLASS
---@class LBColorSpace
LifeBoatAPI.LBColorSpace = {
    ---@section lbcolorspace_setColorGammaCorrected
    --- Sets the screen colour, correcting for the game's gamma factor
    --- Allows for colours that are closer to the expected HTML values
    ---@param r number red 0->255
    ---@param g number green 0->255
    ---@param b number blue 0->255
    ---@param a number alpha 0->255
    ---@param constantCorrection number (default 0.8) constant factor, as K in the equation (K*color) ^ gamma
    ---@param gamma number (default 2.6) gamma factor, in the equation (K*color) ^ gamma
    --- see explanation of Stormworks gamma here: https://steamcommunity.com/sharedfiles/filedetails/?id=2273112890
    lbcolorspace_setColorGammaCorrected = function (r,g,b,a, gamma, constantCorrection)
        constantCorrection = constantCorrection or 0.85
        gamma = gamma or 2.4

        screen.setColor(
             255*(constantCorrection*r/255)^gamma
            ,255*(constantCorrection*g/255)^gamma
            ,255*(constantCorrection*b/255)^gamma
            ,a or 255)
    end;
    ---@endsection
}
---@endsection LBCOLORSPACECLASS
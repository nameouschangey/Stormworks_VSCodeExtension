require("LifeBoatAPI")color_Highlight=LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(230,230,230)color_Inactive=LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(100,100,100)color_Active=LifeBoatAPI.LBColorRGBA:lbcolorrgba_newGammaCorrected(230,150,0)myButton=LifeBoatAPI.LBTouchScreen:lbtouchscreen_newStyledButton(0,1,31,9,"Toggle",color_Highlight,color_Inactive,color_Active,color_Highlight,color_Inactive)ticks=0
function onTick()LifeBoatAPI.LBTouchScreen:lbtouchscreen_onTick()ticks=ticks+1

    
    
    if myButton:lbstyledbutton_isReleased()then
        isCircleColorToggled=not isCircleColorToggled    
    end
end

function onDraw()if isCircleColorToggled then
        color_Active:lbcolorrgba_setColor()else
        color_Inactive:lbcolorrgba_setColor()end
	screen.drawCircleF(16,16,(ticks%600)/60)myButton:lbstyledbutton_draw()end
-- make sure that you input width and height of the display you are going to use to "px," "h," "w."
w=48
h=48
px=48
maxdst=500
storedtgt={}

function onTick()

    tgt=input.getBool(1)
    dst=input.getNumber(1)
    dstpx=(dst/maxdst)*px
    radarAng=(input.getNumber(5)%1)*math.pi*2

    x1=w/2+px*math.cos(-math.pi/2+radarAng)
    y1=h/2+px*math.sin(-math.pi/2+radarAng)

    x2=w/2+dstpx*math.cos(-math.pi/2+radarAng)
    y2=h/2+dstpx*math.sin(-math.pi/2+radarAng)

    if tgt then
        storedtgt[x2]=y2
    end

    if radarAng==0 then 
        for x3 in pairs(storedtgt) do
            storedtgt[x3]=nil
        end
    end

end

function onDraw()
	w=screen.getWidth()
	h=screen.getHeight()
	screen.setColor(0,255,0)
	screen.drawCircle(w/2,h/2,px)
	screen.drawLine(w/2,h/2,x1,y1)
	
	for x3,y3 in pairs(storedtgt) do
		screen.setColor(255,0,0)
		screen.drawCircleF(x3,y3,2)
	end
	
	
end
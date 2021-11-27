
ticks = 0
function onDraw()	
	ticks = ticks + 1

	screen.setColor(255,0,0,100)

	radius = (ticks / 20) % 32 
	screen.drawCircle(32,32,0.5)
end

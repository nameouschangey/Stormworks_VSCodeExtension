
ticks = 0
function onDraw()	
	ticks = ticks + 1

	screen.setColor(255,0,0,100)

	radius = (ticks / 10) % 64 

	screen.drawCircle(32,32,1)
	screen.drawCircle(24,24,2)
	screen.drawCircle(16,16,0.5)
	--screen.drawLine(-100,-100,100,100)
end

w = 96
h = 64
a = 0
spd = 0.003
maxdistance = 60000
trgts = {}

function onTick()

	radarA = ((a+0.5)*360)*math.pi/180

	x1=w/2 + 30 * math.cos(1.58+radarA)
	y1=h/2 + 30 * math.sin(1.58+radarA)

	x2=w/2 + distancepixel * math.cos(1.58+radarA)
	y2=h/2 + distancepixel * math.sin(1.58+radarA)

	a=a+spd 

	if a >= 0.5 then
		a = -0.5
	end

	target = input.getBool(2)
	distance = input.getNumber(2)
	distancepixel = (distance/maxdistance)*30
end -- end of the onTick function

-- this ISN'T within the onTick function
if target then 
	trgts[x2] = y2
end

if radarA > -0.49 then
	for i in pairs(trgts) do
		trgts[i] = nil
	end
	output.setNumber(1, a)
end
------------------------------------------

function onDraw()
	w = screen.getWidth()				 
	h = screen.getHeight()					
	screen.setColor(0, 255, 0)			
	screen.drawCircle(w / 2, h / 2, 30)   
	screen.drawLine(w/2, h/2, x1, y1)
	
	for i,v in pairs(trgts) do
		screen.setColor(250, 0, 0)
		screen.drawCircle(x3,y3, 1) 	
	end		
end
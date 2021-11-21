gn = input.getNumber; gb = input.getBool
pi2, pi = math.pi * 2, math.pi
points = {}
dcf = screen.drawCircleF
zoom = 3; width = 0; height = 0

local function drawJoystick()
	centerW, centerH = width - 7, height - 7
	white()
	dc(centerW, centerH, 5)
	if touchInRectangle(width - 14, height - 14, 10, 10) then
		distance = ((touchX - centerW)^2 + (touchY - centerH)^2)^0.5
		angle = math.atan(touchX - centerW,touchY - centerH) - pi / 2 
		mapX = mapX + cos(angle) * distance * zoom
		mapY = mapY + sin(angle) * distance * zoom
		dcf(touchX, touchY, 2)
	else
		dcf(centerW, centerH, 2)
	end
end

local function drawPointer(x, y, rot, size)
	local pointer = {}
	local offsets = {0, 0.75, 1.25}
	for i = 1, 3 do
		local angle = rot + offsets[i] * pi
		pointer[i*2-1] = x + math.sin(angle) * size 
		pointer[i*2] = y + math.cos(angle) * size
	end
	screen.drawTriangleF(table.unpack(pointer))
end

function inCircle(x, y, r, tX, tY)
	return len2({x = tX - x, y = tY - y}) <= r
end

function subVector2(v1, v2)
	return {x = v1.x - v2.x, y = v1.y, v2.y}
end

function color(r,g,b)
	return function() screen.setColor(r,g,b) end
end
white=color(35,35,35)
pGreen = color(0, 255, 0)

function len2(v)
	return (v.x^2 + v.y^2)^0.5
end

function onTick()
	vehicle = {x = gn(1), y = gn(2), hdg = gn(3)}
	t1 = {x = gn(4), y = gn(5), on = gb(1)}
	t2 = {x = gn(6), y = gn(7), on = gb(2)}
	if not mapMoved then
		mapX, mapY = vehicle.x, vehicle.y
	end
	f = false
	if t1.on or t2.on then
		if not mapControls then
			for i, v in pairs(points) do
				local px, py = map.mapToScreen(mapX, mapY, zoom, width, height, v.x, v.y)
				if inCircle(px, py, 3, t1.x, t1.y) or inCircle(px, py, 3, t2.x, t2.y) then
					sel = sel ~= i and i or 0
					f = true
				end
			end
			if not f then
				local tx, ty = t2.x, t2.y --(t1.on and t1.x) or (t2.on and t2.x), (t1.on and t1.y) or (t2.on and t2.y)
				kk = tx == 0 and ty == 0 -- debug
				local mX, mY = map.screenToMap(mapX, mapY, zoom, width, height, tx, ty)
				table.insert(points, {x = mX, y = mY})
			end
		end
	end
end

function onDraw()
	width, height = screen.getWidth(), screen.getHeight()
	screen.setMapColorOcean(0, 10, 0)
	screen.setMapColorShallows(0, 25, 0)
	screen.setMapColorLand(0, 65, 0)
	screen.setMapColorGrass(0, 85, 0)
	screen.setMapColorSand(0, 115, 0)
	screen.setMapColorSnow(0, 130, 0)
	screen.drawMap(vehicle.x, vehicle.y, zoom)
	for i,v in pairs(points) do
		local x, y = map.mapToScreen(mapX, mapY, zoom, width, height, v.x, v.y)
		pGreen()
		dcf(x, y, 3)
	end
	white()
	local vehX, vehY = map.mapToScreen(mapX, mapY, zoom, width, height, vehicle.x, vehicle.y)
	drawPointer(vehX, vehY, vehicle.hdg * pi2 + pi, 5)
	screen.drawText(1, 0, string.format("%.0f,%.0f", t2.x, t2.y))
	screen.drawText(1, 16, kk and "true" or "false")
	if points[1] then
	end
end
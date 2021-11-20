function onTick()
	speed = input.getNumber(1)
	altitude = input.getNumber(2)
	cluster = input.getBool(1)
	medium = input.getBool(2)
	output.setNumber(1, numero)
    output.setNumber(2, altitude)
	

    values = {0.463,0.461,0.649}
    for i=1,#values,1 do
        local minValue = 390 + i*10
        local maxValue = 390 + (i+1)*10    
        if (altitude > minValue and altitude < maxValue) then
            numero = values[i]
        end
    end

	-- 400 -> 500
	if altitude>400 and altitude<=410 then numero=0.463 end
	if altitude>410 and altitude<=420 then numero=0.461 end
	if altitude>420 and altitude<=430 then numero=0.459 end
	if altitude>430 and altitude<=440 then numero=0.457 end
    if altitude>440 and altitude<=450 then numero=0.455 end
    if altitude>450 and altitude<=460 then numero=0.453 end
    if altitude>460 and altitude<=470 then numero=0.451 end
    if altitude>470 and altitude<=480 then numero=0.449 end
    if altitude>480 and altitude<=490 then numero=0.447 end 
	if altitude>490 and altitude<=500 then numero=0.445 end 
	-- 500 -> 600
	if altitude>500 and altitude<=510 then numero=0.418 end
	if altitude>510 and altitude<=520 then numero=0.416 end
	if altitude>520 and altitude<=530 then numero=0.414 end
	if altitude>530 and altitude<=540 then numero=0.412 end
	if altitude>540 and altitude<=550 then numero=0.410 end
	if altitude>550 and altitude<=560 then numero=0.408 end
	if altitude>560 and altitude<=570 then numero=0.406 end
	if altitude>570 and altitude<=580 then numero=0.404 end
	if altitude>580 and altitude<=590 then numero=0.402 end 
	if altitude>590 and altitude<=600 then numero=0.400 end 
	-- 600 -> 700
	if altitude>600 and altitude<=610 then numero=0.348 end
	if altitude>610 and altitude<=620 then numero=0.346 end
	if altitude>620 and altitude<=630 then numero=0.344 end
	if altitude>630 and altitude<=640 then numero=0.342 end
	if altitude>640 and altitude<=650 then numero=0.340 end
	if altitude>650 and altitude<=660 then numero=0.338 end
	if altitude>660 and altitude<=670 then numero=0.336 end
	if altitude>670 and altitude<=680 then numero=0.334 end
	if altitude>680 and altitude<=690 then numero=0.332 end
	if altitude>690 and altitude<=700 then numero=0.330 end 
	-- 700 -> 800
	if altitude>700 and altitude<=710 then numero=0.328 end
	if altitude>710 and altitude<=720 then numero=0.326 end
	if altitude>720 and altitude<=730 then numero=0.324 end
	if altitude>730 and altitude<=740 then numero=0.322 end
	if altitude>740 and altitude<=750 then numero=0.320 end
	if altitude>750 and altitude<=760 then numero=0.318 end
	if altitude>760 and altitude<=770 then numero=0.316 end
	if altitude>770 and altitude<=780 then numero=0.314 end
	if altitude>780 and altitude<=790 then numero=0.312 end
	if altitude>790 and altitude<=800 then numero=0.310 end 
	-- 800 -> 900
	if altitude>800 and altitude<=810 then numero=0.308 end
	if altitude>810 and altitude<=820 then numero=0.306 end
	if altitude>820 and altitude<=830 then numero=0.304 end
	if altitude>830 and altitude<=840 then numero=0.302 end
	if altitude>840 and altitude<=850 then numero=0.300 end
	if altitude>850 and altitude<=860 then numero=0.298 end
	if altitude>860 and altitude<=870 then numero=0.296 end
	if altitude>870 and altitude<=880 then numero=0.294 end
	if altitude>880 and altitude<=890 then numero=0.292 end 
	if altitude>890 and altitude<=900 then numero=0.290 end 
	-- 900 -> 1000
	if altitude>900 and altitude<=910 then numero=0.288 end
	if altitude>910 and altitude<=920 then numero=0.286 end
	if altitude>920 and altitude<=930 then numero=0.284 end
	if altitude>930 and altitude<=940 then numero=0.282 end
	if altitude>940 and altitude<=950 then numero=0.280 end 
	if altitude>950 and altitude<=960 then numero=0.278 end
	if altitude>960 and altitude<=970 then numero=0.276 end
	if altitude>970 and altitude<=980 then numero=0.274 end
	if altitude>980 and altitude<=990 then numero=0.272 end
	if altitude>990 and altitude<=1000 then numero=0.270 end 
end


function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()					
	
	screen.setColor(5, 5, 5)
	screen.drawCircle(w/2, h/2, 10)
	screen.drawCircle(w/2, h/2, 20)
	
	screen.setColor(5, 5, 5)
	screen.drawLine(w/2, 0, w/2, 22)
	screen.drawLine(0, h/2, 38, h/2)
	screen.drawLine(w/2, 64, w/2, 42)
	screen.drawLine(96, h/2, 58, h/2)
		
end
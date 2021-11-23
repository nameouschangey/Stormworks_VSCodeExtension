deltaELEV = 0
deltaAZIMUTH = 0
deltaDISTANCE = 0
tick = 0
valueMonitoredELEV = 0
valueMonitoredAZIMUTH = 0
valueMonitoredDISTANCE = 0

function onTick()
    tiltright = input.getNumber(1)
    elevangle = input.getNumber(2)
    tiltforward = input.getNumber(3)
    azimuth = input.getNumber(4)
    compass = input.getNumber(5)
    targetdistance = input.getNumber(6)
    nav = property.getNumber("navconstant")
    
    tick=(tick+1)%2

    if tick==0 then
        deltaELEV = valueMonitoredELEV-(elevangle+tiltforward)
        valueMonitoredELEV = (elevangle+tiltforward)
    end

    if tick==1 then
        deltaELEV = valueMonitoredELEV-(elevangle+tiltforward)
        valueMonitoredELEV = (elevangle+tiltforward)
    end

    if tick==0 then
        deltaAZIMUTH = valueMonitoredAZIMUTH-(azimuth-compass)
        valueMonitoredAZIMUTH = (azimuth-compass)
    end

    if tick==1 then
        deltaAZIMUTH = valueMonitoredAZIMUTH-(azimuth-compass)
        valueMonitoredAZIMUTH = (azimuth-compass)
    end

    if tick==0 then
        deltaDISTANCE = valueMonitoredDISTANCE-targetdistance
        valueMonitoredDISTANCE = targetdistance
    end

    if tick==1 then
        deltaDISTANCE = valueMonitoredDISTANCE-targetdistance
        valueMonitoredDISTANCE = targetdistance
    end
    closingspeed = math.abs(deltaDISTANCE*60)
    
    pitchfins = deltaELEV*closingspeed*nav
    yawfins = -(deltaAZIMUTH*closingspeed*nav)
    
    output.setNumber(7,tiltright*20)
    output.setNumber(8,pitchfins)
    output.setNumber(9,yawfins)
end
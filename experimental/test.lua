--missile_guided

i = input
o = output
gn = i.getNumber
gb = i.getBool
sn = o.setNumber
sb = o.setBool
state = 0
cruise_height = 100
mid_course_height = 25
mid_course_distance = 1000
terminal_distance = 500
target_height = (altimeter * math.tan(math.pi*2))
function Pitch(altitude_setpoint , input_alt) sn(1,(pitch - clamp(((altitude_setpoint - input_alt) / 4000), -1, 1))*2) end
function Yaw(bearing) sn(2,clamp((bearing - compass) * 4.25, -1, 1)) end
function clamp(Value, Min, Max)
return math.min(math.max(Value , Min), Max)
end

function onTick()
        altimeter = gn(1)
        laser_distance_sensor = gn(2)
        pitch = gn(3)
        compass = (gn(4)*-1)
        roll = (gn(5)*-1)
        gps_X = gn(6)
        gps_Y = gn(7)
        target_X = gn(8)
        target_Y = gn(9)
        start_point_X = gn(10)
        start_point_Y = gn(11)
        coordinates_locked = gb(1)
        
        target_distance_XY = (((target_X - gps_X) ^ 2 + (target_Y - gps_Y) ^ 2)^ 0.5)
        target_bearing = (((math.atan(target_X - gps_X, target_Y - gps_Y) / (math.pi * 2))%1 + 1.5)%1 - 0.5)
            
        if state == 0 and coordinates_locked then
        
                Pitch(cruise_height , altimeter)
                Yaw(target_bearing) 
                if (target_distance_XY < mid_course_distance) then
                    state = 1
                end
        end
        if state == 1 then

                Pitch(mid_course_height , altimeter)
                Yaw(target_bearing)
                
                if (target_distance_XY < terminal_distance) then
                    state = 2
                end
        end
        if state == 2 then
                Pitch(target_height , altimeter)
                Yaw(target_bearing)
        end
        
        sn(3, roll)
        sn(4, target_distance_XY)
        sn(5, altimeter)
        sn(6, state)


end
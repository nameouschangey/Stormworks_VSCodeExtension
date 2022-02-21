
ticks = 0
onTick = function()
    ticks = ticks + 1
end


lastTick = 0
x = 16
y = 16
onDraw = function()
    if lastTick == ticks then
        x = x + 1
        y = y + 1
    end

    screen.drawCircleF(x % 40,y % 40, 5)
    
    lastTick = ticks
end
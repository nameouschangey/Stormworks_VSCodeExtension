
ticks = 0
function onDraw()
	ticks = ticks%600 + 1
    -- your code
    --screen.drawTextBox(2, 5, 35, 64, "abc d defdef def def def def", -1, -1)
	screen.drawMap(ticks,ticks, 1);
end

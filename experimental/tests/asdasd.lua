

onTick = function ()
    
    runTest({
        _tickables = {
            {nextTick = 0}
        }
    })

end

runTest = function (this)
    for i=1,100000 do
        local tickable = this._tickables[1]
        if not tickable._disposable.isDisposed and (tickable.nextTick == ticks or tickable.shouldTickImmediately) then
            -- do nothing
        end
    end
end
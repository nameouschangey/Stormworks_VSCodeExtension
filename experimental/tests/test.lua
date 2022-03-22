function benchmark(f, ...)
    local before = os.clock()
    f(...)
    local after = os.clock()
    print(after - before)
end

benchmark(function()
    t = {}
    for i = 0, 9 do
        for j = 0, 9 do
            for k = 0, 9 do
                for l = 0, 9 do
                    for m = 0, 9 do
                        t[i..' '..j..' '..k..' '..l..' '..m..' hello beautiful world!'] = true
                    end
                end
            end
        end
    end
end)

benchmark(function()
    for k in pairs(t) do
    end
end)
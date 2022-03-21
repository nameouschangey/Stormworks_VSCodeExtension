a = {}
b = {}
bb = {}

for i=1, 100000 do
    a[i] = i
    b[tostring(i)] = i
    bb[i] = tostring(i)
end


mark = os.clock()
for i=1, #a do
    local b = a[i]
end
time = os.clock() - mark
print("numerical: \t" .. tostring(time))

mark = os.clock()
for i=1, #bb do
    local b = b[bb[i]]
end
time = os.clock() - mark
print("numerical-b: \t" .. tostring(time))


mark = os.clock()
for k,v in ipairs(a) do
    local b = k
end
time = os.clock() - mark
print("ipairs: \t" .. time)



mark = os.clock()
for k,v in pairs(a) do
    local b = k
end
time = os.clock() - mark
print("pairs:  \t" .. tostring(time))


mark = os.clock()
for k,v in pairs(b) do
    local b = k
end
time = os.clock() - mark
print("pairsb:  \t" .. tostring(time))

mark = os.clock()
for k,v in pairs(a) do
    local b = k
end
time = os.clock() - mark
print("double-table:  \t" .. tostring(time))
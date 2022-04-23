require("Parsing.minify")

dupes = {}
renamer = VariableNamer:new()
for i=1, 5000, 1 do
    local next = renamer:getNext()
    if dupes[next] then
        error("DUPE ON " .. tostring(i) .. " = " .. next)
    end
    dupes[next] = true
    print(tostring(i) .. " : " .. next)
end
--- takes either a list of params, of a table in arg1
set = function(...)
    local args = {...}
    args = type(args[1]) == "table" and args[1] or args 

    local result = {}
    for i=1,#args do
        result[args[i]] = true
    end
    return result
end;

is = function(obj, ...)
    local args = {...}
    for i=1,#args do
        if obj == args[i] then
            return args[i]
        end
    end
    return nil
end;


deepCopyTree = function(tree)
    local result = {}
    for k,v in pairs(tree) do
        if type(v) == "table" then
            result[k] = deepCopyTree(v)
        end
        result[k] = v
    end
    return result
end;







treeToString = function(node, keyFilters)
    keyFilters = keyFilters or {}
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0


        local cur_index = 1
        -- make a new table of keys ordered string keys first => numerical keys at the end
        local sorted = {}
        do
            local seen = {}
            for i=1, #node do
                seen[i] = true
                sorted[#sorted+1] = {k=i, v=node[i]}
            end

            for k,v in pairs(node) do
                if not seen[k] and not keyFilters[k] then
                    seen[k] = true
                    table.insert(sorted, 1, {k=k, v=v})
                end
            end
        end


        size = #sorted

        for i=1, #sorted do
            local k,v = sorted[i].k, sorted[i].v

            if (cache[node] == nil) or (cur_index >= cache[node]) then
            
                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""
            
                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = tostring(k)
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v):gsub("\n", "\\n"):gsub("'", "\\'").."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    return "a="..output_str
end

printTypeTree = function(tree, printComments, depth)
    local depth = depth or 0
    local indent = (" "):rep(depth * 4)

    local result = {}
    for i=1, #tree do
        local v = tree[i]
        if type(v) == "table" and v.type and (printComments or not is(v.type, "COMMENT", "WHITESPACE")) then
            if v.type then
                result[#result+1] = indent
                result[#result+1] = v.type
                if v.raw then
                    result[#result+1] = "("
                    result[#result+1] = v.raw:gsub("\n", "\\n")
                    result[#result+1] = ")"
                end
                result[#result+1] = "\n"
            end
            result[#result+1] = printTypeTree(v, printComments, depth + 1)
        end
    end
    return table.concat(result)
end;
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

LifeBoatAPI.Tools.SimulatorSandbox = {}
LifeBoatAPI.Tools.SimulatorSandbox.createSandbox = function(rootDirs)
    
    local filesnamesByRequirePattern = {}
    local loadedRequires = {}

    -- load the requires
    local loadRequires = function(rootDirectory, requiresToFilenames)
        local files = LifeBoatAPI.Tools.FileSystemUtils.findFilesRecursive(rootDirectory, {["_build"]=1, [".git"]=1, [".vscode"]=1}, {["lua"]=1, ["luah"]=1})

        for _, filename in ipairs(files) do
            local requireName = filename:linux():gsub(LifeBoatAPI.Tools.StringUtils.escape(rootDirectory:linux()) .. "/", "")
            
            requireName = requireName:gsub("/", ".") -- slashes -> . style
            requireName = requireName:gsub("%.init.lua$", "") -- if name is init.lua, strip it
            requireName = requireName:gsub("%.lua$", "") -- if name ends in .lua, strip it
            requireName = requireName:gsub("%.luah$", "") -- "hidden" lua files

            requiresToFilenames[requireName] = requiresToFilenames[requireName] or filename:linux()
        end
    end;

    for i=1, #rootDirs do
        loadRequires(rootDirs[i], filesnamesByRequirePattern)
    end

    -- sandbox environment, that MCs are run in
    local sandboxEnv = {
        ipairs = ipairs,
        next = next,
        pairs = pairs,
        tonumber = tonumber,
        tostring = tostring,
        type = type,
        print = print,

        -- library tables
        string = string,
        table = table,
        math = math, -- etc.
        debug = {log = print},

        -- simulator stuff
        screen = screen,
        input = input,
        output = output
    }

    sandboxEnv.require = function(pattern)
        local filePath = filesnamesByRequirePattern[pattern]
        if not filePath then
            error("Could not find require: " .. pattern)
        end

        if not loadedRequires[pattern] then
            loadedRequires[pattern] = loadfile(filePath, "t", sandboxEnv)
            loadedRequires[pattern]()
        end
    end;

    return sandboxEnv
end
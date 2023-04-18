-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


-- combines multiple scripts into one by following the require tree.
-- resulting script can then be passed through luamin to minify it (or alternate tools)

require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Utils.FileSystemUtils")


---@class Combiner : BaseClass
---@field systemRequires string[] list of system libraries that are OK to import, but should be stripped
---@field filesByRequire table<string,string> table of require names -> filenames
---@field loadedFileData table<string,string> table of require names -> filecontents
LifeBoatAPI.Tools.Combiner = {
    ---@param cls Combiner
    ---@return Combiner
    new = function(cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.filesByRequire = {}
        this.loadedFileData = {}
        this.systemRequires = {"table", "math", "string"}
        return this;
    end;

    ---@param this Combiner
    ---@param rootDirectory Filepath sourcecode root folder, to load files from
    addRootFolder = function(this, rootDirectory)
        local filesByRequire = this:_getDataByRequire(rootDirectory)
        LifeBoatAPI.Tools.TableUtils.addRange(this.filesByRequire, filesByRequire)
    end;

    ---@param this Combiner
    ---@param entryPointFile Filepath
    ---@param outputFile Filepath
    combineFile = function (this, entryPointFile, outputFile)   
        local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(entryPointFile)
        local combinedText = this:combine(text)
        LifeBoatAPI.Tools.FileSystemUtils.writeAllText(outputFile, combinedText)
        
        return combinedText
    end;

    ---@param this Combiner
    ---@param data string
    combine = function (this, data)   
        data = "\n" .. data -- ensure the file starts with a new line, so any first-line requires get found

        local requiresSeen = {}
        local keepSearching = true
        while keepSearching do
            keepSearching = false
            local require = data:match("\n%s-require%([\"'](..-)[\"']%)")

            -- God knows why, but - and + fuck with gsub in a way I cannot explain
            -- Make this better when someone figures that out
            if require:match("-") or require:match("+") then
                error("Characters '+' and '-' are not permitted in module names!")
            end

            if require then
                keepSearching = true
                local fullstring = "\n%s-require%([\"']"..require.."[\"']%)%s-"
                if(requiresSeen[require]) then
                    -- already seen this, so we just cut it from the file
                    data = data:gsub(fullstring, "")
                else
                    -- valid require to be replaced with the file contents
                    requiresSeen[require] = true

                    if(this.filesByRequire[require]) then
                        local filename = this.filesByRequire[require]

                        -- only load each file's contentes one time
                        if not this.loadedFileData[require] then
                            this.loadedFileData[require] = LifeBoatAPI.Tools.FileSystemUtils.readAllText(filename)
                        end

                        local filedata = this.loadedFileData[require]
                        data = data:gsub(fullstring, LifeBoatAPI.Tools.StringUtils.escapeSub("\n" .. filedata .. "\n"), 1) -- only first instance

                    elseif (LifeBoatAPI.Tools.TableUtils.containsValue(this.systemRequires, require)) then
                        data = data:gsub(fullstring, "") -- remove system requires, without error, as long as they are allowed in the game
                    else
                        error("Require " .. require .. " was not found.")
                    end
                end
            end
        end
        return data
    end;

    ---@param this Combiner
    ---@param rootDirectory Filepath
    _getDataByRequire = function(this, rootDirectory)
        local requiresToFilecontents = {}
        local files = LifeBoatAPI.Tools.FileSystemUtils.findFilesRecursive(rootDirectory, {[".vscode"]=1, ["_build"]=1, [".git"]=1}, {["lua"]=1, ["luah"]=1})

        for _, filename in ipairs(files) do
            local requireName = filename:linux():gsub(LifeBoatAPI.Tools.StringUtils.escape(rootDirectory:linux()) .. "/", "")
            requireName = requireName:gsub("/", ".") -- slashes -> . style
            requireName = requireName:gsub("%.init.lua$", "") -- if name is init.lua, strip it
            requireName = requireName:gsub("%.lua$", "") -- if name ends in .lua, strip it
            requireName = requireName:gsub("%.luah$", "") -- "hidden" lua files

            requiresToFilecontents[requireName] = filename
        end

        return requiresToFilecontents
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Combiner)



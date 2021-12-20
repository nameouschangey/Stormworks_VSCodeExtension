-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates


-- combines multiple scripts into one by following the require tree.
-- resulting script can then be passed through luamin to minify it (or alternate tools)

require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringUtils")
require("LifeBoatAPI.Tools.Utils.FileSystemUtils")


---@class Combiner : BaseClass
---@field filesByRequire table<string,string> table of require names -> filecontents
---@field systemRequires string[] list of system libraries that are OK to import, but should be stripped
LifeBoatAPI.Tools.Combiner = {

    ---@param cls Combiner
    ---@return Combiner
    new = function(cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.filesByRequire = {}
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
        local outputFileHandle = LifeBoatAPI.Tools.FileSystemUtils.openForWrite(outputFile)
        local data = LifeBoatAPI.Tools.FileSystemUtils.readAllText(entryPointFile)
        data = this:combine(data)
        outputFileHandle:write(data)
        outputFileHandle:close()
    end;

    ---@param this Combiner
    ---@param data string
    combine = function (this, data)   
        local requiresSeen = {}

        local keepSearching = true
        while keepSearching do
            keepSearching = false
            local requires = data:gmatch("%s-require%(\"(..-)\"%)")
            for require in requires do
                local fullstring = "%s-require%(\""..require.."\"%)%s-"
                if(requiresSeen[require]) then
                    -- already seen this, so we just cut it from the file
                    data = data:gsub(fullstring, "")
                else
                    -- valid require to be replaced with the file contents
                    keepSearching = true
                    requiresSeen[require] = true

                    if(this.filesByRequire[require]) then
                        data = data:gsub(fullstring, LifeBoatAPI.Tools.StringUtils.escapeSub(this.filesByRequire[require]), 1) -- only first instance

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
        local files = LifeBoatAPI.Tools.FileSystemUtils.findFilesRecursive(rootDirectory)

        for _, filename in ipairs(files) do
            local requireName = filename:linux():gsub(LifeBoatAPI.Tools.StringUtils.escape(rootDirectory:linux()) .. "/", "")
            requireName = requireName:gsub("/", ".")
            requireName = requireName:gsub(".lua", "")

            requiresToFilecontents[requireName] = LifeBoatAPI.Tools.FileSystemUtils.readAllText(filename)
        end

        return requiresToFilecontents
    end;
}
LifeBoatAPI.Tools.LBClass(LifeBoatAPI.Tools.Combiner)



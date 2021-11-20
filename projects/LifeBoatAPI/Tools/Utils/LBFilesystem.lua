-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBTable")
require("LifeBoatAPI.Tools.Utils.LBFilepath")

---@param filepath LBFilepath
function LBFileSystem_openForWrite(filepath)
    os.execute("mkdir \"" .. filepath:directory():win() .. "\"")
    local file = io.open(filepath:win(), "w")
    return file
end

---reads all text from a file and returns it as a string
---@param filePath LBFilepath path to read from
---@return string text from the file
function LBFileSystem_readAllText(filePath)
    local file = io.open(filePath:win(), "r")
    local data = file:read("*a")
    file:close()
    return data
end

---writes the given text to a file, overwriting the existing file
---@param text string text to write to the file
---@param filePath LBFilepath path to write to
function LBFileSystem_writeAllText(filePath, text)
    local outputFileHandle = LBFileSystem_openForWrite(filePath)
    outputFileHandle:write(text)
    outputFileHandle:close()
end

---@param dirPath LBFilepath directory to search in
---@return LBFilepath[] list of directory paths
function LBFileSystem_findDirsInDir(dirPath)
    return LBFileSystem_findPathsInDir(dirPath, "/ad")
end


---@param dirPath LBFilepath directory to search in
---@return LBFilepath[] list of filepaths
function LBFileSystem_findFilesInDir(dirPath)
    return LBFileSystem_findPathsInDir(dirPath, "/a-d")
end

---@param dirPath LBFilepath directory to search in
---@param commandlinePattern string pattern to use to select the type of file/directory desired
---@return LBFilepath[] list of filepaths
function LBFileSystem_findPathsInDir(dirPath, commandlinePattern)
    local result = {}
    local process = io.popen('dir "'..dirPath:win()..'" /b ' .. commandlinePattern)

    for filename in process:lines() do
        LBTable_add(result, LBFilepath:new(filename))
    end
    process:close()
    return result
end

---@param dirPath LBFilepath root to start search in
---@return LBFilepath[] list of filepaths in all subfolders
function LBFileSystem_findFilesRecursive(dirPath)
    local files = {}
    for _, dirname in ipairs(LBFileSystem_findDirsInDir(dirPath)) do
        local dir = dirPath:add("/" .. dirname:linux())
        local filesInDir = LBFileSystem_findFilesRecursive(dir)

        LBTable_iaddRange(files, filesInDir)
    end

    for _, filename in ipairs(LBFileSystem_findFilesInDir(dirPath)) do
        local file = dirPath:add("/" .. filename:linux())
        LBTable_add(files, file)
    end

    return files
end


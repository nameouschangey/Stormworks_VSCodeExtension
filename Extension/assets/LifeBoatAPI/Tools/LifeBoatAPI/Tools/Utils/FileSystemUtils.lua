-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.Filepath")

---@class FileSystemUtils
LifeBoatAPI.Tools.FileSystemUtils = {

    --- Copies the given source file to the given destination filepath
    ---@param sourceFilepath Filepath
    ---@param destinationFilepath Filepath
    copyFile = function(sourceFilepath, destinationFilepath)
        local fileContents = LifeBoatAPI.Tools.FileSystemUtils.readAllText(sourceFilepath)
        LifeBoatAPI.Tools.FileSystemUtils.writeAllText(destinationFilepath, fileContents)
    end;

    ---@param filepath Filepath
    openForWrite = function(filepath)
        os.execute("mkdir \"" .. filepath:directory():win() .. "\" 2>nul")
        local file = io.open(filepath:win(), "w")
        return file
    end;

    ---reads all text from a file and returns it as a string
    ---@param filePath Filepath path to read from
    ---@return string text from the file
    readAllText = function(filePath)
        local file = io.open(filePath:win(), "r")
        local data = file:read("*a")
        file:close()
        return data
    end;

    ---writes the given text to a file, overwriting the existing file
    ---@param text string text to write to the file
    ---@param filePath Filepath path to write to
    writeAllText = function(filePath, text)
        local outputFileHandle = LifeBoatAPI.Tools.FileSystemUtils.openForWrite(filePath)
        outputFileHandle:write(text)
        outputFileHandle:close()
    end;

    ---@param dirPath Filepath directory to search in
    ---@return Filepath[] list of directory paths
    findDirsInDir = function (dirPath)
        return LifeBoatAPI.Tools.FileSystemUtils.findPathsInDir(dirPath, "/ad")
    end;

    ---@param dirPath Filepath directory to search in
    ---@return Filepath[] list of filepaths
    findFilesInDir = function (dirPath)
        return LifeBoatAPI.Tools.FileSystemUtils.findPathsInDir(dirPath, "/a-d")
    end;

    ---@param dirPath Filepath directory to search in
    ---@param commandlinePattern string pattern to use to select the type of file/directory desired
    ---@return Filepath[] list of filepaths
    findPathsInDir = function (dirPath, commandlinePattern)
        local result = {}
        local process = io.popen('dir "'..dirPath:win()..'" /b ' .. commandlinePattern .. " 2>nul")

        for filename in process:lines() do
            LifeBoatAPI.Tools.TableUtils.add(result, LifeBoatAPI.Tools.Filepath:new(filename))
        end
        process:close()
        return result
    end;

    ---@param dirPath Filepath root to start search in
    ---@return Filepath[] list of filepaths in all subfolders
    findFilesRecursive = function (dirPath)
        local files = {}
        for _, dirname in ipairs(LifeBoatAPI.Tools.FileSystemUtils.findDirsInDir(dirPath)) do
            local dir = dirPath:add("/" .. dirname:linux())
            local filesInDir = LifeBoatAPI.Tools.FileSystemUtils.findFilesRecursive(dir)

            LifeBoatAPI.Tools.TableUtils.iaddRange(files, filesInDir)
        end

        for _, filename in ipairs(LifeBoatAPI.Tools.FileSystemUtils.findFilesInDir(dirPath)) do
            local file = dirPath:add("/" .. filename:linux())
            LifeBoatAPI.Tools.TableUtils.add(files, file)
        end

        return files
    end;
}
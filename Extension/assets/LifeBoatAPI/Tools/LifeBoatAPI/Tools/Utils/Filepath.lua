-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.StringUtils")

---Simple filepath standardisation to avoid the usual issues with filepath (which slash to use, etc.)
---@class Filepath: BaseClass
---@field rawPath string raw path stored internally, currently uses forward slashes to represent slashes
---@field caseSensitive boolean whether this path is case sensitive or not (true by default)
LifeBoatAPI.Tools.Filepath = {

    ---@param caseSensitive boolean
    ---@param path string
    ---@param cls Filepath
    ---@overload fun(path:string):Filepath
    new = function(cls, path, caseSensitive)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)

        path = path:gsub("\\", "/") -- normalize all slashes
        if(path:sub(#path, #path) == "/") then -- remove trailing slashes
            path = path:sub(1,#path-1)
        end

        this.caseSensitive = caseSensitive
        if this.caseSensitive then
            path = path:lower()
        end

        this.rawPath = path
        return this
    end;

    ---@param this Filepath
    ---@param pathSegment string part to add to the path
    ---@return Filepath path new concatenated filepath
    add = function(this, pathSegment)
        return LifeBoatAPI.Tools.Filepath:new(this:linux() .. pathSegment, this.caseSensitive)
    end;

    ---@param this Filepath
    ---@param parent Filepath parent path to get relative path from
    ---@return Filepath path relative path from the parent
    relativeTo = function(this, parent, removeFirstSlash)
        local path = this:linux():gsub(LifeBoatAPI.Tools.StringUtils.escape(parent:linux()), "")

        if(removeFirstSlash and path:sub(1, 1) == "/") then -- remove starting slash (optional)
            path = path:sub(2,#path)
        end
        return LifeBoatAPI.Tools.Filepath:new(path, this.caseSensitive)
    end;

    ---@param this Filepath
    ---@return Filepath
    directory = function(this)
        return LifeBoatAPI.Tools.Filepath:new(this:win():match("(.+\\)"), this.caseSensitive)
    end;

    filename = function(this)
        local _,filename = LifeBoatAPI.Tools.Filepath:new(this:win():match("(.+\\)(.+)"), this.caseSensitive)
        return filename
    end;

    ---@param this Filepath
    win = function(this)
        return this.rawPath:gsub("/", "\\")
    end;

    ---@param this Filepath
    linux = function(this)
        return this.rawPath
    end;
};
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.Filepath)
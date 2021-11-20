-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBString")

---Simple filepath standardisation to avoid the usual issues with filepath (which slash to use, etc.)
---@class LBFilepath: LBBaseClass
---@field rawPath string raw path stored internally, currently uses forward slashes to represent slashes
---@field caseSensitive boolean whether this path is case sensitive or not (true by default)
LBFilepath = {
    ---@param cls LBFilepath
    new = function(cls, path, caseSensitive)
        local this = LBBaseClass.new(cls)

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

    ---@param this LBFilepath
    ---@param pathSegment string part to add to the path
    ---@return LBFilepath path new concatenated filepath
    add = function(this, pathSegment)
        return LBFilepath:new(this:linux() .. pathSegment, this.caseSensitive)
    end;

    ---@param this LBFilepath
    ---@param parent LBFilepath parent path to get relative path from
    ---@return LBFilepath path relative path from the parent
    relativeTo = function(this, parent, removeFirstSlash)
        path = this:linux():gsub(LBString_escape(parent:linux()), "")

        if(removeFirstSlash and path:sub(1, 1) == "/") then -- remove starting slash (optional)
            path = path:sub(2,#path)
        end
        return LBFilepath:new(path, this.caseSensitive)
    end;

    ---@param this LBFilepath
    ---@return LBFilepath
    directory = function(this)
        return LBFilepath:new(this:win():match("(.+\\)"), this.caseSensitive)
    end;

    filename = function(this)
        _,filename = LBFilepath:new(this:win():match("(.+\\)(.+)"), this.caseSensitive)
        return filename
    end;

    ---@param this LBFilepath
    win = function(this)
        return this.rawPath:gsub("/", "\\")
    end;

    ---@param this LBFilepath
    linux = function(this)
        return this.rawPath
    end;
};
LBClass(LBFilepath)
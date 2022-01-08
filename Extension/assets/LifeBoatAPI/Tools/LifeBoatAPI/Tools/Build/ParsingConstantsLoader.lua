-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")

---@class ParsingConstantsLoader : BaseClass
---@field restrictedKeywords table<string,boolean>
---@field baseNames table<string,boolean>
---@field fullNames table<string,boolean>
---@field allNames table<string,boolean>
LifeBoatAPI.Tools.ParsingConstantsLoader = {
    _default_restrictedKeywords = { -- restricted keywords will rarely be changed
        "and"        ,"break"     ,"do"        ,"else"      ,"elseif"
        ,"end"       ,"for"       ,"function"  ,"goto"      ,"if"
        ,"in"        ,"local"     ,"not"       ,"or"
        ,"repeat"    ,"return"    ,"then"      ,"until"
        ,"while"
    };
    _default_baseNames = {"nil", "arg", "true", "false", "type", "debug", "_ENV", "g_save_data", "pairs", "ipairs", "next", "tostring", "tonumber"};
    _vehicle_restricted_callbacks = {"onTick", "onDraw", "httpReply"};
    _mission_restricted_callbacks = {"onTick", "onCreate", "onDestroy", "onCustomCommand", "onChatMessage",
                                     "onPlayerJoin", "onPlayerSit", "onCharacterSit", "onPlayerRespawn",
                                     "onPlayerLeave", "onToggleMap", "onPlayerDie", "onVehicleSpawn", "onVehicleLoad", "onVehicleTeleport",
                                     "onVehicleDespawn", "onSpawnAddonComponent", "onVehicleDamaged", "httpReply",
                                     "onFireExtinguished","onVehicleUnload", "onForestFireSpawned", "onForestFireExtinguised"};

    ---@param cls ParsingConstantsLoader
    ---@return ParsingConstantsLoader
    new = function(cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.restrictedKeywords = {}
        this.baseNames = {}
        this.fullNames = {}

        this:addRestrictedKeywords(LifeBoatAPI.Tools.ParsingConstantsLoader._default_restrictedKeywords)
        this:addBaseNames(LifeBoatAPI.Tools.ParsingConstantsLoader._default_baseNames)
        return this
    end;

    loadNeloDocFile = function(this, filepath) -- 'René Sackers Docs, with well formatted class definitions and function names ready to be plucked out
        local text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(filepath)

        -- find all unreachable class members
        for field in text:gmatch("---%s@field%s([%a_%d]-)%s") do
            this:addRestrictedKeywords(field)
        end

        -- find all functions
        for func in text:gmatch("function%s([%a%._%d]-)%(") do
            this:addFullNames(func)
        end
    end;

    loadLibrary = function(this, libname, instanceBased) -- libraries used in Stormworks are all flat name.function - nothing more needed
        instanceBased = instanceBased == nil or instanceBased
        local tbl = _ENV[libname]
        for k,_ in pairs(tbl) do
            this:_addFullName(libname .. "." .. k, instanceBased)
        end
    end;

    addRestrictedKeywords = function(this, list)
        if(type(list) == "table") then
            local asDict = LifeBoatAPI.Tools.TableUtils.select(list, function(v,k) return true,v end)
            LifeBoatAPI.Tools.TableUtils.addRange(this.restrictedKeywords, asDict)
        elseif(type(list) == "string") then
            this.restrictedKeywords[list] = true
        end
    end;

    addBaseNames = function(this, list)
        if(type(list) == "table") then
            for k,v in ipairs(list) do
                this:addBaseNames(v)
            end
        elseif(type(list) == "string") then
            this.baseNames[list] = true
            if(#list < 3) then -- keywords 1 or 2 letters long need to be restricted, as they interfere with our substitutions 
                this:addRestrictedKeywords(list)
            end
        end
    end;

    addFullNames = function(this, list)
        if(type(list) == "table") then
            for i,v in ipairs(list) do
                this:_addFullName(v)
            end
        elseif(type(list) == "string") then
            this:_addFullName(list)
        end
    end;

    _addFullName = function(this, item, instanceBased)
        instanceBased = instanceBased == nil or instanceBased
        local nameParts = LifeBoatAPI.Tools.StringUtils.split(item, ".")
        this.baseNames[nameParts[1]] = true
        this.fullNames[item] = true
        if(instanceBased) then -- instance based means things like gmatch which apply to any string
            this.restrictedKeywords[nameParts[2]] = true
        end
    end;
};
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.ParsingConstantsLoader)
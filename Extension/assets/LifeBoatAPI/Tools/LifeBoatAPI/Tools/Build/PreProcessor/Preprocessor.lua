-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("LifeBoatAPI.Tools.Utils.Base")
require("LifeBoatAPI.Tools.Utils.TableUtils")
require("LifeBoatAPI.Tools.Utils.StringBuilder")
require("LifeBoatAPI.Tools.Utils.StringUtils")



---@class PreProcessor : BaseClass
LifeBoatAPI.Tools.PreProcessor = {
    TagPattern = "%-%-%-@lb%(([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*),?([^,]*)%)[^\n]*\n";

    new = function (cls)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)
        this.tagFactories = {}
        this.tags = {}
        this.maxIterations = 10000
    end;

    register = function(this, name, factory)
        this.tagFactories[name] = factory
    end;

    process = function(this, text)
        local changesMade = false
        local iterations = 0
        repeat
            changesMade = false
            iterations = iterations + 1

            this.tags = this:_findAndInitializeTags(text)
            for i=1, #this.tags do
                local tag = this.tags[i]
                local newText = tag:process(this, text)
                
                if newText then
                    text = newText
                    changesMade = true
                    break
                end
            end
        until(not changesMade or iterations > this.maxIterations)
  

        if iterations > this.maxIterations then
            error("Please check ---@lb() processor tags, especially macros, for recursive content. Exceeded max processor passes. Cancelling build.")    
        end

        return text
    end;

    _findAndInitializeTags = function(this, text)
        local tags = {}

        local tagMatches = LifeBoatAPI.Tools.StringUtils.find(text, this.TagPattern)

        for i=1, #tagMatches do
            local match = tagMatches[i]
            local tag = LifeBoatAPI.Tools.ProcessorTag:new(i, match)
            local mappedTag = this:mapTag(tag)
            tags[#tags+1] = mappedTag
        end

        return tags
    end;

    _mapTag = function(this, tag)
        if this.tagFactories[tag.type] then
            return this.tagFactories[tag.type]:create(tag) or tag
        end
        return tag -- no additional rules found, use default mapping
    end;

    getTag = function(this, index)
        return this.tags[index]
    end;

    getNextTagWhere = function(this, startIndex, predicate)
        if startIndex < #this.tags then
            for i=startIndex, #this.tags do
                local tag = this.tags[i]
                if predicate(tag) then
                    return tag
                end
            end
        end
        return nil
    end;
}

---@class ProcessorTag : BaseClass
---@field startIndex number
---@field endIndex number
---@field args string[]
---@field type string
---@field index number
LifeBoatAPI.Tools.ProcessorTag = {
    ---example: ---@lb(arg1,arg2,arg3,...arg10) note no spaces between each argument
    ---example: ---@lb(arg1,arg2,arg3,...arg10) note no spaces between each argument
    ---@param cls ProcessorTag
    ---@param match StringMatch
    ---@return ProcessorTag
    new = function(cls, i, match)
        local this = LifeBoatAPI.Tools.BaseClass.new(cls)

        this.priorty = 0; -- lowest priority
        this.type = match.captures[1]
        this.index = i

        for i=2, #match.captures do
            this.args[#this.args+1] = match.captures[i] ~= "" and match.captures[i] or nil
        end

        this.startIndex = match.startIndex
        this.endIndex = match.endIndex
        return this
    end;

    process = function() end;

    remove = function(this,text)
        return this:replace(text, "")
    end;

    replace = function(this, text, replacement)
        return LifeBoatAPI.Tools.StringUtils.replaceIndex(text, this.startIndex, this.endIndex, replacement)
    end;
}
LifeBoatAPI.Tools.Class(LifeBoatAPI.Tools.ProcessorTag)

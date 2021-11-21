-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Utils.LBTable")
require("LifeBoatAPI.Missions.Utils.LBStringBuilder")
require("LifeBoatAPI.Missions.Utils.LBString")

-- Format accepted:
-- "---@section EXACT|PARTIAL Identifier 2 SectionName"
-- "---@section Identifier 2 SectionName"
-- "---@section Identifier"
-- With corresponding end section:
-- "---@endsection SectionName"
-- "---@endsection"
-- care must be taken not to share one endsection between two section labels, otherwise you'll break it
-- care must also be taken not to incorrectly overlap two sections - overlaps must be handled nested; otherwise removal will break things
-- failing to do this will mean code lingers, but will not throw errors - as such the resulting lua size will be larger than you could have managed

---@class LBCodeSection : LBBaseClass
---@field startIndex number
---@field endIndex number
---@field identifier string
---@field instances number
---@field sectionName string
LBCodeSection = {
    ---@param cls LBCodeSection
    ---@param match LBStringMatch
    ---@return LBCodeSection
    new = function(cls, match, text)
        local this = LBBaseClass.new(cls)
        this.startIndex = match.startIndex

        local captures = LBString_split(match.captures[1], "%s")
        this:_init_from_captures(captures)

        local endings =  LBString_find(text, "%-%-%-@endsection[^%S\n]-".. this.sectionName .."[^%S\n]-\n", match.endIndex)
        this.endIndex = endings[1] and endings[1].endIndex or match.endIndex -- if no end was found, this section does nothing

        return this
    end;

    _init_from_captures = function(this, args)
        local index = 1

        -- 1. first arg can be one of two constants - EXACT or PATTERN to specify the match type
        --  otherwise EXACT matching is used
        this.exact = true
        if(args[index] == "EXACT") then
            this.exact = true
            index = index + 1
        elseif(args[index] == "PATTERN") then
            this.exact = false
            index = index + 1
        end

        -- 2. next argument is the identifier to search for
        this.identifier = args[index]
        index = index + 1
        -- exact matching (default) means we expect this to be the entire word, and not made of any pattern stuff
        -- PATTERN matching (non-exact) means we trust the user comes up with a relevant pattern themself
        if(this.exact) then
            this.identifier = "[^%a%d_]" .. LBString_escape(this.identifier) .. "[^%a%d_]"
        end

        -- 3. if given the next argument is the count
        this.instances = 1
        if(args[index] and tonumber(args[index])) then
            this.instances = tonumber(args[index])
            index = index + 1
        end

        --- 4. final argument, if given, is the section name
        this.sectionName = ""
        if(args[index]) then
            this.sectionName = args[index]
            index = index + 1
        end
    end;

    ---@param this LBCodeSection
    isRemovable = function(this, text)
        local textBefore,textAfter = this:_textOutsideSection(text)
        local countBefore, countAfter = LBString_count(textBefore, this.identifier), LBString_count(textAfter, this.identifier)
        return countBefore + countAfter < this.instances
    end;

    ---@param this LBCodeSection
    stripFromText = function(this, text)
        local textBefore,textAfter = this:_textOutsideSection(text)
        return textBefore .. textAfter
    end;

    ---@param this LBCodeSection
    _textOutsideSection = function(this, text)
        local textBefore = text:sub(1, this.startIndex-1)
        local textAfter = text:sub(this.endIndex+1, #text)
        return textBefore, textAfter
    end;
};
LBClass(LBCodeSection)

--------------------------------------------------------------------------------------------------------------------
---@class LBRedundancyRemover : LBBaseClass
LBRedundancyRemover = {
    
    ---@param this LBRedundancyRemover
    removeRedundantCode = function(this, text)
        local reducedText, foundRemovable = text, false
        repeat
            reducedText, foundRemovable = this:attemptDeletionPass(reducedText)
        until(not foundRemovable);

        return reducedText
    end;

    -- we can only strip one each time, and then need to re-pass the entire file
    -- it's a slow process; but it's the only way to do this reasonable safely without a lot of thinking
    ---@param this LBRedundancyRemover
    attemptDeletionPass = function(this, text)
        ---@type LBCodeSection[]
        local sections = LBString_find(text, "%-%-%-@section%s-([^\n]+)\n")
        sections = LBTable_iselect(sections, function(v)return LBCodeSection:new(v, text) end)

        for i,section in ipairs(sections) do
            if(section:isRemovable(text)) then
                text = section:stripFromText(text)
                return text, true
            end
        end
        return text, false
    end;
};
LBClass(LBRedundancyRemover)

require("Parsing.LuaParser")
require("Parsing.LuaTree")



LifeBoatAPI.Tools.LuaTreeMinifications = {

    ---@param tree LuaTree
    ---@return LuaTree
    collapseLuaNodes = function(tree)
        local this = LifeBoatAPI.Tools.LuaTreeMinifications
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes

        local lastContent = {type="none"}
        for i=#tree,1,-1 do -- reverse for deletion
            local content = tree[i]
            if content.type == LBTypes.lua and lastContent.type == LBTypes.lua then
                content.raw = content.raw .. lastContent.raw
                table.remove(tree, i+1)
            else
                this.collapseLuaNodes(content)
            end
            lastContent = content
        end
        return tree
    end;


    ---@param variableNamer VariableRenamer
    ---@param tree LuaTree
    ---@return LuaTree
    removeStringDuplicates = function(variableNamer, tree)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local stringsFound = {}
        tree:forEach(LBTypes.string,
            ---@param c LuaTree_String
            function(t,i,c)
                stringsFound[c.stringContent] = (stringsFound[c.stringContent] or 0) + 1
            end)
        
        for k,v in pairs(stringsFound) do
            stringsFound[k] = v > 1 and variableNamer:getShortName() or nil
        end

        tree:forEach(LBTypes.string,
        ---@param c LuaTree_String
            function(t,i,c)
                if stringsFound[c.stringContent] then
                    c.type = LBTypes.lua
                    c.raw = stringsFound[c.stringContent] -- replace with variable
                end
            end)

        -- generate a new block of code and insert it
        for k,v in pairs(stringsFound) do
            tree:insert(1, LifeBoatAPI.Tools.LuaParser.parse(v .. '="'..k..'"\n'))
        end

        return tree
    end;


    ---@param tree LuaTree
    ---@param variableRenamer VariableRenamer
    minifyIdentifierNames = function(variableRenamer, restrictedKeywordsDict, tree)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local identifiersRenamed = {}
        tree:forEach(LBTypes.identifier,
            function(t,i,c)
                if not restrictedKeywordsDict[c.raw] then
                    identifiersRenamed[c.raw] = identifiersRenamed[c.raw] or variableRenamer:getShortName()
                    c.raw = identifiersRenamed[c.raw]
                end
            end)
        return tree
    end;

    ---@param tree LuaTree
    ---@param variableRenamer VariableRenamer
    minifyDuplicateGlobalUses = function(variableRenamer, globalsToReduceDict, tree)
        local LBTypes = LifeBoatAPI.Tools.LuaParseTypes
        local identifiersRenamed = {}
        -- reduce all "full uses" of e.g. string.whatever etc.
        tree:forEach(LBTypes.identifierchain,
            ---@param c LuaTree_IdentifierChain
            function(t,i,c)
                if globalsToReduceDict[c.identifierFull] then
                    identifiersRenamed[c.raw] = identifiersRenamed[c.raw] or variableRenamer:getShortName()
                    c.raw = identifiersRenamed[c.raw]
                end
            end)

            -- reduce all uses of the base types
        tree:forEach(LBTypes.identifierchain,
            ---@param c LuaTree_IdentifierChain
            function(t,i,c)
                if globalsToReduceDict[c.identifierFull] then
                    identifiersRenamed[c.raw] = identifiersRenamed[c.raw] or variableRenamer:getShortName()
                    c.raw = identifiersRenamed[c.raw]
                end
            end)
        return tree
    end;


    ---@param tree LuaTree
    ---@param variableRenamer VariableRenamer
    covertHexToNumber = function(variableRenamer, tree)
        LifeBoatAPI.Tools.LuaTreeUtils.split(tree, "[^%w_](0x%x+)", "lua", "hex", true)
        
        tree:forEach("hex",
            function(t,i,c)
                    c.type = "number"
                    c.raw = tonumber(c.raw)
            end)

        return tree
    end;
}



text = LifeBoatAPI.Tools.FileSystemUtils.readAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\MyMicrocontroller.lua]]))

local contentTree = LifeBoatAPI.Tools.LuaParser.parse(text)
LifeBoatAPI.Tools.FileSystemUtils.writeAllText(LifeBoatAPI.Tools.Filepath:new([[C:\personal\Sandbox\testst\generated1.lua]]), contentTree:toString())




__simulator:exit()
require("LifeBoatAPI")

---@param this HexadecimalConverter
shortenNumbers = function(this, text)
    local stringUtils = LifeBoatAPI.Tools.StringUtils;

    -- variables shortened are not keywords, and not global names (because those are a pita)
    local hexValues = stringUtils.find(text, "[^%w_](0x%x+)")
    for i=1, #hexValues do
        local hexVal = hexValues[i]
        local hexAsNum = tonumber(hexVal.captures[1])

        text = stringUtils.subAll(text, "([^%w_])" .. stringUtils.escape(hexVal), stringUtils.escapeSub(tostring(hexAsNum)))
    end

    return text
end;


t = [[

abc = 123

def = 0xff1100

ghi = 0xffFFff

0x123*0x332

]]

a = shortenNumbers()

print(a)


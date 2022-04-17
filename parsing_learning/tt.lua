---@lb(macro)
f = 1

abc = {}
fff = function(a) end

abc . def (1, 2 , 3, fff ("test"))
---@lb(end)


---@class abc
a = {
    def = function (this, a)
        return a
    end;

    ghi = function (this, b)
        return b
    end
}
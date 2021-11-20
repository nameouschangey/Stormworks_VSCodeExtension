require("Utils.Class")

---@class LBGameSettings
LBGameSettings = {

    setCurrency = function(this, value)
        server.setCurrency(value, 0)
    end;

    getCurrency = function(this)
        return server.getCurrency()
    end;

    setGameSetting = function(this)
    end;
}

-- server.setGameSetting
--
-- server.getGameSettings
--

--
-- server.getResearchPoints
--
-- server.getDateValue
--
-- server.getDate
--
-- server.getTimeMillisec
--
-- server.getTilePurchased
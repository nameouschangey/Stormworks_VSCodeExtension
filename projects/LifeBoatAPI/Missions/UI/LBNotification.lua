require("LifeBoatAPI.Missions.Utils.LBBase")

--- Represents a notification message that displays a box on the right side of the player's screen
---@class LBNotification : LBBaseClass
---@field title string text to display as the title
---@field message string text to display as the body
---@field displayStyle number style of notification
LBNotification = {

    newMission                  = function(title, message) return LBNotification:_new(title, message, 0) end;
    newCriticalMission          = function(title, message) return LBNotification:_new(title, message, 1) end;
    failedMission               = function(title, message) return LBNotification:_new(title, message, 2) end;
    failedCriticalMission       = function(title, message) return LBNotification:_new(title, message, 3) end;
    completeMission             = function(title, message) return LBNotification:_new(title, message, 4) end;
    networkConnect              = function(title, message) return LBNotification:_new(title, message, 5) end;
    networkDisconnect           = function(title, message) return LBNotification:_new(title, message, 6) end;
    networkInfo                 = function(title, message) return LBNotification:_new(title, message, 7) end;
    chatMessage                 = function(title, message) return LBNotification:_new(title, message, 8) end;
    star                        = function(title, message) return LBNotification:_new(title, message, 9) end;
    networkDisconnectCritical   = function(title, message) return LBNotification:_new(title, message, 10) end;
    scienceFlask                = function(title, message) return LBNotification:_new(title, message, 11) end;
    
    ---@return LBNotification
    _new = function(cls, title, message, displayStyle)
        local this = LBBaseClass.new(cls)
        this.title = title
        this.message = message
        this.displayStyle = displayStyle
        return this
    end
}
LBClass(LBNotification)

-- list of different types of Notification
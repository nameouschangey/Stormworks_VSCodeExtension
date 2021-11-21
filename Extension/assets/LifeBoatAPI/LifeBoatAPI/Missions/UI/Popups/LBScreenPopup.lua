require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.UI.Popup.SWPopupBase")
require("LifeBoatAPI.Math.Vec")
require("LifeBoatAPI.Entity.SWPlayer")
require("LifeBoatAPI.Entity.SWVehicle")
require("LifeBoatAPI.Entity.SWObject")

------------------------------------------------------------------------------------------------------------------------
--- Represents a popup that displays within screenspace
---@class SWScreenPopup : SWPopupBase
SWScreenPopup = {}
LBClass(SWScreenPopup, SWPopupBase)

---@param text string text to display on screen
---@param position SWVec position in screenspace to draw this at
---@param hidden boolean True if this shouldn't be shown
---@overload fun(text:string, position:SWVec) : SWScreenPopup
function SWScreenPopup:new(text, position, hidden) return self:_new(text, position, hidden) end
---@private
function SWScreenPopup:_init(self, text, position, hidden)
    SWPopupBase._init(self, text, position, hidden)
end

function SWScreenPopup:_createInstance(player)
    return SWScreenPopupInstance:new(self, player)
end

------------------------------------------------------------------------------------------------------------------------
--- Represents an instance of a popup, displaying on screen to a specific player
---@class SWScreenPopupInstance : SWPopupInstanceBase
SWScreenPopupInstance = {}
LBClass(SWScreenPopupInstance, SWPopupInstanceBase)

---@param popup SWPopupBase popup this is instantiated from
---@param peer LBPeer peer this displays for
function SWScreenPopupInstance:new(popup, peer) return SWScreenPopupInstance:_new(popup, peer) end
---@private
function SWScreenPopupInstance:_init(popup, peer)
    SWPopupInstanceBase._init(self, popup, peer)
end

function SWScreenPopupInstance:redraw(respawn)
    if(respawn) then
        self:remove()
        self.uiID = server.getMapID()
    end
    server.setPopupScreen(self.peer.peerID,
                    self.uiID,
                    "",
                    self.popup.visible,
                    self.popup.text,
                    self.popup.position.x,
                    self.popup.position.y)
end
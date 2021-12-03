require("Utils.Class")
require("Utils.TableExtensions")
require("ServerAPI.Math.Vec")
require("ServerAPI.Entity.SWPlayer")
require("ServerAPI.Entity.SWEntity")
require("ServerAPI.UI.Popup.SWPopupBase")

------------------------------------------------------------------------------------------------------------------------
--- Represents an instance of a popup, displaying within world-space
---@class SWWorldPopup : SWPopupBase
---@field renderDistance number distance to display this popup from
---@field attachedEntity SWEntity entity this is attached to
SWWorldPopup = {
    renderDistance = 0,
    attachedEntity = nil
}
LBClass(SWWorldPopup, SWPopupBase)

---@param text string text to display on screen
---@param renderDistance number distance to display at
---@param position SWVec position in worldspace to draw this at
---@param hidden boolean true if this shouldn't be shown
---@param attachedEntity SWEntity entity to attach this to, or nil
---@overload fun(text:string, renderDistance:number, position:SWVec)
function SWWorldPopup:new(text, renderDistance, position, attachedEntity, hidden) return SWWorldPopup:_new(text, renderDistance, position, attachedEntity, hidden) end
---@private
function SWWorldPopup:_init(text, renderDistance, position, attachedEntity, hidden)
    SWPopupBase._init(self, text, position, hidden)
    self.renderDistance = renderDistance
    self.attachedEntity = attachedEntity
end

--- Updates the render distance for this popup
--- @overload fun(distance:number)
--- @param distance number distnace this popup will be visible from
--- @param skipRedraw boolean true to disable the automatic "update on change" behaviour
function SWWorldPopup:updateRenderDistance(distance, skipRedraw)
    self:_updateVal("render_distance", distance, skipRedraw, false)
end

--- Setting the attached entity changes the position into a relative position, tied to the vehicle/object
--- Requires respawning of the popup (handled automatically); as the type of it has changed interally to the game
--- @overload fun(entity:SWEntity)
--- @param entity SWEntity entity to attach the popup to
--- @param skipRedraw boolean true to disable the automatic "update on change" behaviour
function SWWorldPopup:updateAttachedEntity(entity, skipRedraw)
    self:_updateVal("attachedToEntity", entity, skipRedraw, true)
end

function SWWorldPopup:_createInstance(player)
    return SWWorldPopupInstance:new(self, player)
end

------------------------------------------------------------------------------------------------------------------------
--- Represents an instance of a popup, displaying on screen to a specific player
---@class SWWorldPopupInstance : SWPopupInstanceBase
---@field popup SWWorldPopup popup this is spawned from
SWWorldPopupInstance = {}
LBClass(SWWorldPopupInstance, SWPopupInstanceBase)

---@param popup SWPopupBase popup this is instantiated from
---@param peer LBPeer player this displays for
function SWWorldPopupInstance:new(popup, peer) return SWWorldPopupInstance:_new(popup, peer) end
function SWWorldPopupInstance:_init(popup, peer)
    SWPopupInstanceBase._init(self, popup, peer)
end

function SWWorldPopupInstance:redraw(respawn)
    if(respawn) then
        self:remove()
        self.uiID = server.getMapID()
    end

    local attachment = self.popup.attachedEntity
    server.setPopup(self.peer.peerID,
            self.uiID,
            "",
            self.popup.visible,
            self.popup.text,
            self.popup.position.x,
            self.popup.position.y,
            self.popup.position.z,
            self.popup.renderDistance,
            attachment and attachment:is(SWVehicle) and attachment.entityID or nil,
            attachment and attachment:is(SWObject) and attachment.entityID or nil
    )
end
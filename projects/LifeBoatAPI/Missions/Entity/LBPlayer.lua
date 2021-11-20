require("LifeBoatAPI.Missions.Utils.LBBase")
require("LifeBoatAPI.Missions.Entity.LBPeer")
---------------------------------------------------------------------------------------------------------------
--- Represents a player connected to the game
---@class LBPlayer : LBPeer
---@field name string current display name of the player, note: players may change this at will
---@field isAdmin boolean whether the player is admin or not
---@field isAuth boolean whether the player is authd or not
---@field steamID string unique steamID for better tracking persistence data
---@field position LBMatrix last known position for this player
LBPlayer = {

    -- server.getPlayerCharacterID() -- not yet implemented character API todo

    ---@type fun(peerID:number) : LBPeer
    ---@param peerID number peer_id assigned to each player uniquely by the game; cannot be -1
    ---@param name string current display name of the player, note: players may change this at will
    ---@param isAdmin boolean whether the player is admin or not
    ---@param isAuth boolean whether the player is authd or not
    ---@param steamID string unique steamID for better tracking persistence data
    new = function(cls, peerID, name, isAdmin, isAuth, steamID)
        local this = LBBaseClass.new(cls)
        this.peerID = peerID
        this.name = name
        this.isAdmin = isAdmin
        this.isAuth = isAuth
        this.steamID = steamID
        this.position = this:updatePosition()

        
        this.character = nil -- server.getPlayerCharacterID() -- not yet implemented character API todo
        return this
    end;

    setCurrency = function(this, value)
        -- server.setCurrency
--
-- server.getCurrency
    end;

    --- Requests a more up to date position from the server
    ---@return LBMatrix
    updatePosition = function(this)
        this.position = SWMatrix:new(server.getPlayerPos(this.peerID))
        return this.position
    end;

    ---@overload fun(destination : LBVec)
    ---@param destination LBMatrix position to teleport to
    teleport = function(this, destination)
        if(destination:is(LBVec)) then
            destination = SWMatrix:translation( --[[---@type SWVec]] destination)
        end
        server.setPlayerPos(this.peerID, destination.matrix)
        this.position = destination -- store the position we just teleported to
    end;

    --- Requests the current look direction from the server
    --- May need the player to be on the server for multiple seconds before this can succeed
    ---@return LBVec current look direction or nil if not able to obtain it
    tryGetLookDirection = function(this)
        local x,y,z,success = server.getPlayerLookDirection(this.peerID)
        if(success) then
            return LBVec:vec3(x,y,z)
        else
            return nil
        end
    end;

    --- Bans the player from the server, permanently
    --- There is currently no way to undo this without creating a new save
    ban = function(this)
        server.banPlayer(this.peerID)
    end;

    --- Kicks the player from the server
    kick = function(this)
        server.kickPlayer(this.peerID)
    end;

    --- gives this player admins rights
    addAdmin = function(this)
        server.addAdmin(this.peerID)
        this.isAdmin = true
    end;

    --- removes this players admin rights
    removeAdmin = function(this)
        server.removeAdmin(this.peerID)
        this.isAdmin = false
    end;

    --- gives this player auth to build
    addAuth = function(this)
        server.addAuth(this.peerID)
        this.isAuth = true
    end;

    --- Removes this players auth for building
    removeAuth = function(this)
        server.removeAuth(this.peerID)
        this.isAuth = false
    end;
}
LBClass(LBPlayer)

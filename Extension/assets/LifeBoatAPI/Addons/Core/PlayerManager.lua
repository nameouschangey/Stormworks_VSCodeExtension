
---Basic interface for a vehicle
---@class LifeBoatAPI.IPlayer
---@field steamID string steamID
---@field peerID number current peerID if connected

---Factory for mapping vehicles in game to meaningful vehicle scripts
---Default (unmapped) vehicle type is nothing but a simple data container
---@class LifeBoatAPI.IPlayerFactory
---@field create fun(this, vehicle:LifeBoatAPI.DefaultPlayer):LifeBoatAPI.IPlayer


---@class LifeBoatAPI.DefaultPlayer : LifeBoatAPI.IPlayer
LifeBoatAPI.DefaultPlayer = {
    ---@param this LifeBoatAPI.DefaultVehicle
    new = function (this, peerID, steamID, isAdmin, isAuth, name)
        LifeBoatAPI.Classes.instantiate(this, {
            peerID = peerID;
            steamID = steamID;
            isAdmin = isAdmin;
            isAuth = isAuth;
            displayName = name;
        })
    end;
}

---Handles all players join/leave status
---@class LifeBoatAPI.PlayerManager
LifeBoatAPI.PlayerManager = {
    new = function(this)
        this = LifeBoatAPI.Classes.instantiate(this, {
            allPlayer = LifeBoatAPI.DefaultPlayer:new(-1, "None", false, false, "All");

            playersBySteamID = {};
            players = {};
            
            connectedPlayersBySteamID = {};
            connectedPlayersByPeerID = {};
            connectedPlayers = {};

            playerFactories = {};

            onPlayerFirstTimeJoinedEvent = LifeBoatAPI.Event:new();
            onPlayerConnectedEvent = LifeBoatAPI.Event:new();
        })

        onPlayerJoin = function(steamID, name, peerID, isAdmin, isAuth)
            local player = LifeBoatAPI.DefaultPlayer:new(peerID, steamID, isAdmin, isAuth, name)

            for i=1, #this.playerFactories do
                local mapped = this.playerFactories[i]:create(player)
                if mapped then
                    player = mapped
                    break
                end
            end

            if not this.playersBySteamID[player.steamID] then
                -- first time this player has ever joined
                this.players[#this.players + 1] = player
                this.playersBySteamID[player.steamID] = player

                this.onPlayerFirstTimeJoinedEvent:trigger(player)
            end

            this.connectedPlayersBySteamID[player.steamID] = player
            this.connectedPlayersByPeerID[player.peerID] = player
            this.connectedPlayers[#this.connectedPlayers+1] = player
            this.onPlayerConnectedEvent:trigger(player)
        end

        onPlayerLeave = function(steamID, name, peerID, isAdmin, isAuth)
            local player = this.connectedPlayersBySteamID[steamID]
            if player then
                this.connectedPlayersBySteamID[steamID] = nil
                this.connectedPlayersByPeerID[peerID] = nil
                
                for i=1, #this.connectedPlayers do
                    local connectedPlayer = this.connectedPlayers[i]
                    if connectedPlayer.steamID == steamID then
                        table.remove(this.connectedPlayers, i)
                        break
                    end
                end
            end
        end

        onPlayerSit = function(peerID, vehicleID, seatName)
            local player = this.connectedPlayersByPeerID[peerID]
            if player and player.onSit then
                player:onSit(vehicleID, seatName)
            end
        end

        onPlayerUnsit = function(peerID, vehicleID, seatName)
            local player = this.connectedPlayersByPeerID[peerID]
            if player and player.onUnsit then
                player:onUnsit(vehicleID, seatName)
            end
        end
        
        onPlayerDie = function(steam_id, name, peerID, is_admin, is_auth)
            local player = this.connectedPlayersByPeerID[peerID]
            if player and player.onDie then
                player:onDie()
            end
        end

        onPlayerRespawn = function(peerID)
            local player = this.connectedPlayersByPeerID[peerID]
            if player and player.onRespawn then
                player:onRespawn()
            end
        end

        onToggleMap = function(peerID, isOpen)
            local player = this.connectedPlayersByPeerID[peerID]
            if player and player.onToggleMap then
                player:onToggleMap(isOpen)
            end
        end
        
        return this
    end;

    registerFactory = function(this, vehicleFactory)
        this.vehicleFactories[vehicleFactory.name] = vehicleFactory
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.VehicleManager", LifeBoatAPI.VehicleManager)
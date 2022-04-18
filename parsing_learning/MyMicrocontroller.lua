local spawnModifiers = {}

local s = server
local m = matrix
local sm = spawnModifiers

local IMPROVED_CONQUEST_VERSION = "(0.2.6)"

-- valid values:
-- "TRUE" if this version will be able to run perfectly fine on old worlds 
-- "FULL_RELOAD" if this version will need to do a full reload to work properly
-- "FALSE" if this version has not been tested or its not compatible with older versions
local IS_COMPATIBLE_WITH_OLDER_VERSIONS = "TRUE"
local IS_DEVELOPMENT_VERSION = false

local MAX_SQUAD_SIZE = 3
local MIN_ATTACKING_SQUADS = 2
local MAX_ATTACKING_SQUADS = 3

local COMMAND_NONE = "nocomm"
local COMMAND_ATTACK = "attack"
local COMMAND_DEFEND = "defend"
local COMMAND_INVESTIGATE = "investigate"
local COMMAND_ENGAGE = "engage"
local COMMAND_PATROL = "patrol"
local COMMAND_STAGE = "stage"
local COMMAND_RESUPPLY = "resupply"
local COMMAND_TURRET = "turret"
local COMMAND_RETREAT = "retreat"
local COMMAND_SCOUT = "scout"

local AI_TYPE_BOAT = "boat"
local AI_TYPE_LAND = "land"
local AI_TYPE_PLANE = "plane"
local AI_TYPE_HELI = "heli"
local AI_TYPE_TURRET = "turret"

local VEHICLE_STATE_PATHING = "pathing"
local VEHICLE_STATE_HOLDING = "holding"

local TARGET_VISIBILITY_VISIBLE = "visible"
local TARGET_VISIBILITY_INVESTIGATE = "investigate"

local REWARD = "reward"
local PUNISH = "punish"

local AI_SPEED_PSEUDO_PLANE = 60
local AI_SPEED_PSEUDO_HELI = 40
local AI_SPEED_PSEUDO_BOAT = 8
local AI_SPEED_PSEUDO_LAND = 10

local RESUPPLY_SQUAD_INDEX = 1

local FACTION_NEUTRAL = "neutral"
local FACTION_AI = "ai"
local FACTION_PLAYER = "player"

local CAPTURE_RADIUS = 1500
local RESUPPLY_RADIUS = 200
local ISLAND_CAPTURE_AMOUNT_PER_SECOND = 1

local VISIBLE_DISTANCE = 1500
local WAYPOINT_CONSUME_DISTANCE = 100

-- plane ai tuning settings
local PLANE_STRAFE_LOCK_DISTANCE = 800

local PLANE_EXPLOSION_DEPTH = -4
local HELI_EXPLOSION_DEPTH = -4
local BOAT_EXPLOSION_DEPTH = -17

local DEFAULT_SPAWNING_DISTANCE = 10 -- the fallback option for how far a vehicle must be away from another in order to not collide, highly reccomended to set tag

local CRUISE_HEIGHT = 300
local built_locations = {}
local flag_prefab = nil
local is_dlc_weapons = false
local render_debug = false
local g_debug_speed_multiplier = 1

local debug_mode_blinker = false -- blinks between showing the vehicle type icon and the vehicle command icon on the map

local vehicles_debugging = {}

local time = { -- the time unit in ticks, irl time, not in game
	second = 60,
	minute = 3600,
	hour = 216000,
	day = 5184000
}

local default_mods = {
	attack = 0.55,
	general = 1,
	defend = 0.2,
	roaming = 0.1,
	stealth = 0.05
}

local ai_training = {
	punishments = {
		-0.02,
		-0.05,
		-0.1,
		-0.15,
		-0.5
	},
	rewards = {
		0.01,
		0.05,
		0.15,
		0.4,
		1
	}
}

local scout_requirement = time.minute*40

local capture_speeds = {
	1,
	1.5,
	1.75
}

local g_holding_pattern = {
    {x=500, z=500},
    {x=500, z=-500},
    {x=-500, z=-500},
    {x=-500, z=500}
}

local g_patrol_route = {
	{ x=0, z=8000 },
	{ x=8000, z=0 },
	{ x=-0, z=-8000 },
	{ x=-8000, z=0 },
	{ x=0, z=8000}
}

local g_is_air_ready = true
local g_is_boats_ready = false
local g_count_squads = 0
local g_count_attack = 0
local g_count_patrol = 0
local g_tick_counter = 0

g_savedata = {
	ai_base_island = nil,
	player_base_island = nil,
	controllable_islands = {},
    ai_army = { squadrons = { [RESUPPLY_SQUAD_INDEX] = { command = COMMAND_RESUPPLY, ai_type = "", role = "", vehicles = {}, target_island = nil }} },
	player_vehicles = {},
	constructable_vehicles = {},
	vehicle_list = {},
	terrain_scanner_prefab = {},
	terrain_scanner_links = {},
	is_attack = false,
	info = {
		creation_version = nil,
		full_reload_versions = {},
		has_default_addon = false,
		has_ai_paths = false,
		awaiting_reload = false
	},
	land_spawn_zones = {},
	tick_counter = 0,
	ai_history = {
		has_defended = 0, -- logs the time in ticks the player attacked at
		defended_charge = 0, -- the charge for it to detect the player is attacking, kinda like a capacitor
		scout_death = -1, -- saves the time the scout plane was destroyed, allows the players some time between each time the scout comes
	},
	ai_knowledge = {
		last_seen_positions = {}, -- saves the last spot it saw each player, and at which time (tick counter)
		scout = {}, -- the scout progress of each island
	},
	playerData = {
		isDebugging = {},
		isDoAsISay = {},
		timers = {
			isDoAsISay = 0,
		},
	},
}

if render_debug then
	g_savedata.playerData.isDebugging[0] = true
end

--[[
        Functions
--]]

function wpDLCDebug(message, requiresDebugging, isError, toPlayer) -- glorious debug function
	local deb_err = s.getAddonData((s.getAddonIndex())).name..(isError and " Error:" or " Debug:")
	
	if type(message) == "table" then
		printTable(message, requiresDebugging, isError, toPlayer)
	elseif requiresDebugging == true then
		if toPlayer ~= -1 and toPlayer ~= nil then
			if g_savedata.playerData.isDebugging.toPlayer then
				s.announce(deb_err, message, toPlayer)
			end
		else
			for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
				if is_debugging then
					s.announce(deb_err, message, player_id)
				end
			end
		end
	else
		s.announce(deb_err, message, toPlayer or "-1")
	end
end

function wpDLCDebugVehicle(id, message, requiresDebugging, isError, toPlayer)
	if vehicles_debugging[id] then
		wpDLCDebug(message, requiresDebugging, isError, toPlayer)
	end
end

function warningChecks(user_peer_id)
	-- check for if they have the weapons dlc enabled
	if not s.dlcWeapons() then
		wpDLCDebug("ERROR: it seems you do not have the weapons dlc enabled, or you do not have the weapon dlc, the addon mod will not function properly!", false, true, user_peer_id)
	end

	-- check if they left the default addon enabled
	if g_savedata.info.has_default_addon then
		wpDLCDebug("ERROR: The default addon for conquest mode was left enabled! This will cause issues and bugs! Please create a new world with the default addon disabled! name of addon: \"DLC Weapons AI\"", false, true, user_peer_id)
		is_dlc_weapons = false

	elseif not g_savedata.info.has_ai_paths then
		wpDLCDebug("ERROR: The AI Paths addon was disabled! This addon uses it for pathfinding for the ships, you may have issues with the ship's pathfinding!")
	end
	
	-- if they are in a development verison
	if IS_DEVELOPMENT_VERSION then
		wpDLCDebug("hey! thanks for using and testing the development version! just note you will very likely experience errors!", false, false, user_peer_id)

	-- check for if the world is outdated
	elseif g_savedata.info.creation_version ~= IMPROVED_CONQUEST_VERSION then
		if IS_COMPATIBLE_WITH_OLDER_VERSIONS == "FALSE" then
			wpDLCDebug("WARNING: This world is outdated, and this version has been marked as uncompatible with older worlds! If you encounter any errors, try using \"?impwep full_reload\", however this command is very dangerous, and theres no guarentees it will fix the issue", false, true, user_peer_id)
		elseif IS_COMPATIBLE_WITH_OLDER_VERSIONS == "FULL_RELOAD" then
			wpDLCDebug("WARNING: This world is outdated, and this version has been marked as uncompatible with older worlds! However, this is fixable via ?impwep full_reload (tested).", false, true, user_peer_id)
		end
	end
end

local SINKING_MODE_BOX = property.checkbox("Sinking Mode (Vehicles sink when damaged)", "true")
local ISLAND_CONTESTING_BOX = property.checkbox("Point Contesting", "true")

function checkSavedata() -- does a check for savedata, is used for backwards compatibility

	-- backwards compatability for before 0.2.5
	if g_savedata.info.has_ai_paths == nil then
		g_savedata.info.has_ai_paths = false
	end

	-- lets you keep debug mode enabled after reloads
	if g_savedata.playerData then -- backwards compatibilty check for versions before 0.2.1
		for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
			if is_debugging then
				render_debug = true
			end
		end
	else -- adds the playerdata field to the savedata
		g_savedata.playerData = {
			isDebugging = {},
			isDoAsISay = {},
			timers = {
				isDoAsISay = 0,
			},
		}
	end

	-- compatibility check for the new settings
	if not g_savedata.settings.MAX_HELI_AMOUNT then
		g_savedata.settings.MAX_BOAT_AMOUNT = 10
		g_savedata.settings.MAX_LAND_AMOUNT = 10
		g_savedata.settings.MAX_PLANE_AMOUNT = 10
		g_savedata.settings.MAX_HELI_AMOUNT = 10
		g_savedata.settings.MAX_TURRET_AMOUNT = 3
	end
end

function onCreate(is_world_create, do_as_i_say, peer_id)
	if not g_savedata.settings then
		g_savedata.settings = { --set the boxes to "true" if you want them to be enabled by default (quotes )
			SINKING_MODE = SINKING_MODE_BOX,
			CONTESTED_MODE = ISLAND_CONTESTING_BOX,
			ENEMY_HP_MODIFIER = property.slider("AI HP Modifier", 0.1, 10, 0.1, 1),
			AI_PRODUCTION_TIME_BASE = property.slider("AI Production Time (Mins)", 1, 60, 1, 15) * 60 * 60,
			CAPTURE_TIME = property.slider("AI Capture Time (Mins) | Player Capture Time (Mins) / 5 ", 10, 600, 1, 60) * 60,
			MAX_BOAT_AMOUNT = property.slider("Max amount of AI Ships", 0, 40, 1, 10),
			MAX_LAND_AMOUNT = property.slider("Max amount of AI Land Vehicles", 0, 40, 1, 10),
			MAX_PLANE_AMOUNT = property.slider("Max amount of AI Planes", 0, 40, 1, 10),
			MAX_HELI_AMOUNT = property.slider("Max amount of AI Helicopters", 0, 40, 1, 10),
			MAX_TURRET_AMOUNT = property.slider("Max amount of AI Turrets (Per Island)", 0, 7, 1, 3),
			AI_INITIAL_SPAWN_COUNT = property.slider("AI Initial Spawn Count", 0, 30, 1, 5),
			AI_INITIAL_ISLAND_AMOUNT = property.slider("Starting Amount of AI Bases (not including main bases)", 0, 17, 1, 1),
			ISLAND_COUNT = property.slider("Island Count", 7, 19, 1, 19),
		}
	end

	checkSavedata() -- backwards compatibility check

    is_dlc_weapons = s.dlcWeapons()

	local addon_index, is_success = s.getAddonIndex("DLC Weapons AI")
	if is_success then
		g_savedata.info.has_default_addon = true
	end

	local addon_index, is_success = s.getAddonIndex("AI Paths")
	if is_success then
		g_savedata.info.has_ai_paths = true
	end

	warningChecks(-1)

	if g_savedata.info.awaiting_reload ~= false then
		for i = 1, g_savedata.settings.AI_INITIAL_SPAWN_COUNT --[[* math.min(math.max(g_savedata.settings.AI_INITIAL_ISLAND_AMOUNT, 1), #g_savedata.controllable_islands - 1)--]] do
			spawnAIVehicle() -- spawn initial ai
		end
		wpDLCDebug("Lastly, you need to save the world and then load that save to complete the full reload", false, false)
		g_savedata.info.awaiting_reload = false
	end

    if is_dlc_weapons then

		s.announce("Loading Script: " .. s.getAddonData((s.getAddonIndex())).name, "Complete, Version: "..IMPROVED_CONQUEST_VERSION, 0)

        if is_world_create then

			-- allows the player to make the scripts reload as if the world was just created
			-- this command is very dangerous
			if do_as_i_say then
				if peer_id then
					wpDLCDebug(s.getPlayerName(peer_id).." has reloaded the improved conquest mode addon, this command is very dangerous and can break many things", false, false)
					-- removes all ai vehicles
					for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							killVehicle(squad_index, vehicle_id, true, true)
						end
					end

					-- removes vehicle icons and paths
					for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							s.removeMapObject(-1,vehicle_object.map_id)
							s.removeMapLine(-1,vehicle_object.map_id)
							for i = 1, #vehicle_object.path - 1 do
								local waypoint = vehicle_object.path[i]
								s.removeMapLine(-1, waypoint.ui_id)
							end
							killVehicle(squad_index, vehicle_id, true, true)
						end
					end
					s.removeMapObject(-1, g_savedata.player_base_island.map_id)
					s.removeMapObject(-1, g_savedata.ai_base_island.map_id)

					-- resets some island data
					for island_index, island in pairs(g_savedata.controllable_islands) do
						-- resets map icons
						updatePeerIslandMapData(-1, island, true)

						-- removes all flags/capture point vehicles
						s.despawnVehicle(island.flag_vehicle.id, true)
					end
					local debugging_player_data = g_savedata.playerData.isDebugging -- keeps those who are debugging

					-- reset savedata
					g_savedata.playerData = {
						isDebugging = debugging_player_data,
						isDoAsISay = {},
						timers = {
							isDoAsISay = 0
						}
					}
					g_savedata.land_spawn_zones = {}
					g_savedata.ai_army.squadrons = {}
					g_savedata.ai_base_island.zones = {}
					g_savedata.player_base_island = nil
					g_savedata.ai_base_island = nil
					g_savedata.controllable_islands = {}
					g_savedata.constructable_vehicles = {}
					g_savedata.is_attack = {}
					g_savedata.vehicle_list = {}
					g_savedata.tick_counter = 0
					g_savedata.ai_history = {
						has_defended = 0, -- logs the time in ticks the player attacked at
						defended_charge = 0, -- the charge for it to detect the player is attacking, kinda like a capacitor
						scout_death = -1, -- saves the time the scout plane was destroyed, allows the players some time between each time the scout comes
					}
					g_savedata.ai_knowledge = {
						last_seen_positions = {}, -- saves the last spot it saw each player, and at which time (tick counter)
						scout = {}, -- the scout progress of each island
					}
					-- save that this happened, as to aid in debugging errors
					table.insert(g_savedata.info.full_reload_versions, IMPROVED_CONQUEST_VERSION.." (by \""..s.getPlayerName(peer_id).."\")")
				end
			else
				if not peer_id then
					-- things that should never be changed even after this command
					-- such as changing what version the world was created in, as this could lead to issues when trying to debug
					if not g_savedata.info.creation_version then
						g_savedata.info.creation_version = IMPROVED_CONQUEST_VERSION
					end
				end
			end

			turret_zones = s.getZones("turret")

			for land_spawn_index, land_spawn in pairs(s.getZones("land_spawn")) do
				table.insert(g_savedata.land_spawn_zones, land_spawn.transform)
			end

            for i in iterPlaylists() do
                for j in iterLocations(i) do
                    build_locations(i, j)
                end
            end

            for i = 1, #built_locations do
				buildPrefabs(i)
            end

			sm.create()

			local start_island = s.getStartIsland()

			-- init player base
			local flag_zones = s.getZones("capture")
			for flagZone_index, flagZone in pairs(flag_zones) do

				local flag_tile = s.getTile(flagZone.transform)
				if flag_tile.name == start_island.name or (flag_tile.name == "data/tiles/island_43_multiplayer_base.xml" and g_savedata.player_base_island == nil) then
					g_savedata.player_base_island = {
						name = flagZone.name,
						index = flagZone_index,
						transform = flagZone.transform,
						tags = flagZone.tags,
						faction = FACTION_PLAYER,
						is_contested = false,
						capture_timer = g_savedata.settings.CAPTURE_TIME, 
						map_id = s.getMapID(),
						assigned_squad_index = -1,
						ai_capturing = 0,
						players_capturing = 0,
						defenders = 0,
						is_scouting = false
					}
					flag_zones[flagZone_index] = nil
				end
			end

			-- calculate furthest flag from player
			local furthest_flagZone_index = nil
			local distance_to_player_max = 0
			for flagZone_index, flagZone in pairs(flag_zones) do
				local distance_to_player = m.distance(flagZone.transform, g_savedata.player_base_island.transform)
				if distance_to_player_max < distance_to_player then
					distance_to_player_max = distance_to_player
					furthest_flagZone_index = flagZone_index
				end
			end

			-- set up ai base as furthest from player
			local flagZone = flag_zones[furthest_flagZone_index]
			g_savedata.ai_base_island = {
				name = flagZone.name, 
				index = furthest_flagZone_index,
				transform = flagZone.transform,
				tags = flagZone.tags,
				faction = FACTION_AI, 
				is_contested = false,
				capture_timer = 0,
				map_id = s.getMapID(), 
				assigned_squad_index = -1, 
				production_timer = 0,
				zones = {},
				ai_capturing = 0,
				players_capturing = 0,
				defenders = 0,
				is_scouting = false
			}
			
			for _, turretZone in pairs(turret_zones) do
				if(m.distance(turretZone.transform, flagZone.transform) <= 1000) then
					table.insert(g_savedata.ai_base_island.zones, turretZone)
				end
			end
			flag_zones[furthest_flagZone_index] = nil

			-- set up remaining neutral islands
			for flagZone_index, flagZone in pairs(flag_zones) do
				local flag = s.spawnAddonComponent(m.multiply(flagZone.transform, m.translation(0, 4.55, 0)), flag_prefab.playlist_index, flag_prefab.location_index, flag_prefab.object_index, 0)
				local new_island = {
					name = flagZone.name,
					index = flagZone_index,
					flag_vehicle = flag,
					transform = flagZone.transform,
					tags = flagZone.tags,
					faction = FACTION_NEUTRAL, 
					is_contested = false,
					capture_timer = g_savedata.settings.CAPTURE_TIME / 2,
					map_id = s.getMapID(), 
					assigned_squad_index = -1, 
					zones = {},
					ai_capturing = 0,
					players_capturing = 0,
					defenders = 0,
					is_scouting = false
				}

				for _, turretZone in pairs(turret_zones) do
					if(m.distance(turretZone.transform, flagZone.transform) <= 1000) then
						table.insert(new_island.zones, turretZone)
					end
				end

				table.insert(g_savedata.controllable_islands, new_island)

				if(#g_savedata.controllable_islands >= g_savedata.settings.ISLAND_COUNT) then
					break
				end
			end

			-- sets up scouting data
			for island_index, island in pairs(g_savedata.controllable_islands) do
				tabulate(g_savedata.ai_knowledge.scout, island.name)
				g_savedata.ai_knowledge.scout[island.name].scouted = 0
			end

			-- game setup
			for i = 1, g_savedata.settings.AI_INITIAL_ISLAND_AMOUNT do
				if i <= #g_savedata.controllable_islands - 2 then
					local t, a = getObjectiveIsland()
					t.capture_timer = 0 -- capture nearest ally
					t.faction = FACTION_AI
				end
			end

			if not do_as_i_say then
				-- if the world was just created like normal
				
				for i = 1, g_savedata.settings.AI_INITIAL_SPAWN_COUNT --[[* math.min(math.max(g_savedata.settings.AI_INITIAL_ISLAND_AMOUNT, 1), #g_savedata.controllable_islands - 1)--]] do
					spawnAIVehicle() -- spawn initial ai
				end
			else -- say we're ready to reload scripts
				g_savedata.info.awaiting_reload = true
				wpDLCDebug("to complete this process, do ?reload_scripts", false, false, peer_id)
				is_dlc_weapons = false
			end
		else
			for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					s.removeMapObject(-1, vehicle_object.map_id)
					s.removeMapLine(-1, vehicle_object.map_id)
					for i = 1, #vehicle_object.path - 1 do
						local waypoint = vehicle_object.path[i]
						s.removeMapLine(-1, waypoint.ui_id)
					end
				end
			end
			s.removeMapObject(-1, g_savedata.player_base_island.map_id)
			s.removeMapObject(-1, g_savedata.ai_base_island.map_id)
		end
	end
end

function buildPrefabs(location_index)
    local location = built_locations[location_index]

	-- construct vehicle-character prefab list
	local vehicle_index = #g_savedata.vehicle_list + 1 or 1
	for key, vehicle in pairs(location.objects.vehicles) do

		local prefab_data = {location = location, vehicle = vehicle, survivors = {}, fires = {}}

		for key, char in  pairs(location.objects.survivors) do
			table.insert(prefab_data.survivors, char)
		end

		for key, fire in  pairs(location.objects.fires) do
			table.insert(prefab_data.fires, fire)
		end

		
		if hasTag(vehicle.tags, "vehicle_type=wep_turret") or #prefab_data.survivors > 0 then
			table.insert(g_savedata.vehicle_list, vehicle_index, prefab_data)
			g_savedata.vehicle_list[vehicle_index].role = getTagValue(vehicle.tags, "role", true) or "general"
			g_savedata.vehicle_list[vehicle_index].vehicle_type = string.gsub(getTagValue(vehicle.tags, "vehicle_type", true), "wep_", "") or "unknown"
			g_savedata.vehicle_list[vehicle_index].strategy = getTagValue(vehicle.tags, "strategy", true) or "general"
		end

		--
		--
		-- <<<<<<<<<< get vehicles, and put them into a table, sorted by their directive/role and their type, as well as additional info >>>>>>>>>
		--
		--

		if #prefab_data.survivors > 0 then
			local varient = getTagValue(vehicle.tags, "varient")
			if not varient then
				local role = getTagValue(vehicle.tags, "role", true) or "general"
				local vehicle_type = string.gsub(getTagValue(vehicle.tags, "vehicle_type", true), "wep_", "") or "unknown"
				local strategy = getTagValue(vehicle.tags, "strategy", true) or "general"
				tabulate(g_savedata.constructable_vehicles, role, vehicle_type, strategy)
				table.insert(g_savedata.constructable_vehicles[role][vehicle_type][strategy], prefab_data)
				g_savedata.constructable_vehicles[role][vehicle_type][strategy][#g_savedata.constructable_vehicles[role][vehicle_type][strategy]].id = vehicle_index
				wpDLCDebug("set id: "..g_savedata.constructable_vehicles[role][vehicle_type][strategy][#g_savedata.constructable_vehicles[role][vehicle_type][strategy]].id.." | # of vehicles: "..#g_savedata.constructable_vehicles[role][vehicle_type][strategy], true, false)
			else
				tabulate(g_savedata.constructable_vehicles, varient)
				table.insert(g_savedata.constructable_vehicles["varient"], prefab_data)
			end
		end
	end
end

function spawnTurret(island)
	local selected_prefab = sm.spawn(true, "turret")

	if (#island.zones < 1) then return end

	local turret_count = 0

	for turret_zone_index, turret_zone in pairs(island.zones) do
		if turret_zone.is_spawned then turret_count = turret_count + 1 end
	end

	if turret_count >= g_savedata.settings.MAX_TURRET_AMOUNT then return end

	local spawnbox_index = math.random(1, #island.zones)
	if island.zones[spawnbox_index].is_spawned == true then
		return
	end
	
	local player_list = s.getPlayers()
	if not playersNotNearby(player_list, island.zones[spawnbox_index].transform, 2500, true) then return end -- makes sure players are not too close before spawning a turret

	island.zones[spawnbox_index].is_spawned = true
	local spawn_transform = island.zones[spawnbox_index].transform

	-- spawn objects
	local all_addon_components = {}
	local spawned_objects = {
		spawned_vehicle = spawnObject(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.vehicle, 0, nil, all_addon_components),
		survivors = spawnObjects(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.survivors, all_addon_components),
		fires = spawnObjects(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.fires, all_addon_components),
	}

	if spawned_objects.spawned_vehicle ~= nil then
		local vehicle_survivors = {}
		for key, char in  pairs(spawned_objects.survivors) do
			local c = s.getCharacterData(char.id)
			s.setCharacterData(char.id, c.hp, true, true)
			s.setAIState(char.id, 1)
			s.setAITargetVehicle(char.id, -1)
			table.insert(vehicle_survivors, char)
		end

		local home_x, home_y, home_z = m.position(spawn_transform)
		local vehicle_data = {
			id = spawned_objects.spawned_vehicle.id,
			name = selected_prefab.location.data.name,
			survivors = vehicle_survivors,
			path = {
				[1] = {
					x = home_x,
					y = home_y,
					z = home_z
				}
			},
			state = {
				s = "stationary",
				timer = math.fmod(spawned_objects.spawned_vehicle.id, 300),
				is_simulating = false
			},
			map_id = s.getMapID(),
			ai_type = spawned_objects.spawned_vehicle.ai_type,
			role = getTagValue(selected_prefab.vehicle.tags, "role") or "turret",
			size = spawned_objects.spawned_vehicle.size,
			holding_index = 1,
			vision = {
				radius = getTagValue(selected_prefab.vehicle.tags, "visibility_range") or VISIBLE_DISTANCE,
				base_radius = getTagValue(selected_prefab.vehicle.tags, "visibility_range") or VISIBLE_DISTANCE,
				is_radar = hasTag(selected_prefab.vehicle.tags, "radar"),
				is_sonar = hasTag(selected_prefab.vehicle.tags, "sonar")
			},
			spawning_transform = {
				distance = getTagValue(selected_prefab.vehicle.tags, "spawning_distance") or DEFAULT_SPAWNING_DISTANCE
			},
			speed = {
				land = {
					normal = {
						road = getTagValue(selected_prefab.vehicle.tags, "road_speed_normal") or 0,
						bridge = getTagValue(selected_prefab.vehicle.tags, "bridge_speed_normal") or 0,
						offroad = getTagValue(selected_prefab.vehicle.tags, "offroad_speed_normal") or 0
					},
					aggressive = {
						road = getTagValue(selected_prefab.vehicle.tags, "road_speed_aggressive") or 0,
						bridge = getTagValue(selected_prefab.vehicle.tags, "bridge_speed_aggressive") or 0,
						offroad = getTagValue(selected_prefab.vehicle.tags, "offroad_speed_aggressive") or 0
					}
				},
				not_land = {
					pseudo_speed = getTagValue(selected_prefab.vehicle.tags, "pseudo_speed")
				}
			},
			capabilities = {
				gps_missiles = hasTag(selected_prefab.vehicle.tags, "GPS_MISSILE")
			},
			is_aggressive = "normal",
			terrain_type = "offroad",
			strategy = getTagValue(selected_prefab.vehicle.tags, "strategy", true) or "general",
			transform = spawn_transform,
			target_player_id = -1,
			target_vehicle_id = -1,
			home_island = island.name,
			current_damage = 0,
			health = getTagValue(selected_prefab.vehicle.tags, "health", false) or 1,
			damage_dealt = {},
			fire_id = nil,
			spawnbox_index = spawnbox_index,
		}

		if #spawned_objects.fires > 0 then
			vehicle_data.fire_id = spawned_objects.fires[1].id
		end
		
		local squad = addToSquadron(vehicle_data)
		setSquadCommand(squad, COMMAND_TURRET)

		wpDLCDebug("spawning island turret", true, false)
	end
end

---@param requested_prefab any vehicle name or vehicle type, such as scout, will try to spawn that vehicle or type
---@return boolean spawned_vehicle if the vehicle successfully spawned or not
---@return vehicle_data[] vehicle_data the vehicle's data if the the vehicle successfully spawned, otherwise its nil
function spawnAIVehicle(requested_prefab)
	local plane_count = 0
	local heli_count = 0
	local army_count = 0
	local land_count = 0
	local boat_count = 0
	
	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if vehicle_object.ai_type ~= AI_TYPE_TURRET then army_count = army_count + 1 end
			if vehicle_object.ai_type == AI_TYPE_PLANE then plane_count = plane_count + 1 end
			if vehicle_object.ai_type == AI_TYPE_HELI then heli_count = heli_count + 1 end
			if vehicle_object.ai_type == AI_TYPE_LAND then land_count = land_count + 1 end
			if vehicle_object.ai_type == AI_TYPE_BOAT then boat_count = boat_count + 1 end
		end
	end

	if army_count >= #g_savedata.controllable_islands * MAX_SQUAD_SIZE then return end
	
	local selected_prefab = nil

	if requested_prefab then
		selected_prefab = sm.spawn(true, requested_prefab) 
	else
		selected_prefab = sm.spawn(false)
	end

	if not requested_prefab then
		if hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_boat") and boat_count >= g_savedata.settings.MAX_BOAT_AMOUNT then
			return false, "boat limit reached"
		elseif hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_land") and land_count >= g_savedata.settings.MAX_LAND_AMOUNT then
			return false, "land limit reached"
		elseif hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_heli") and heli_count >= g_savedata.settings.MAX_HELI_AMOUNT then
			return false, "heli limit reached"
		elseif hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_plane") and plane_count >= g_savedata.settings.MAX_PLANE_AMOUNT then
			return false, "plane limit reached"
		end
		if army_count > g_savedata.settings.MAX_BOAT_AMOUNT + g_savedata.settings.MAX_LAND_AMOUNT + g_savedata.settings.MAX_HELI_AMOUNT + g_savedata.settings.MAX_PLANE_AMOUNT then
			return false, "too many ai vehicles"
		end
	end

	local player_list = s.getPlayers()

	local selected_spawn = g_savedata.ai_base_island.index
	local selected_spawn_transform = g_savedata.ai_base_island.transform

	local min_player_distance = 2500 -- player must be at least 2.5km away for them to spawn an AI vehicle there

	-------
	-- get spawn location
	-------

	-- if the vehicle we want to spawn is an attack vehicle, we want to spawn it as close to their objective as possible
	if getTagValue(selected_prefab.vehicle.tags, "role") == "attack" or getTagValue(selected_prefab.vehicle.tags, "role") == "scout" then
		target, ally = getObjectiveIsland()
		if not target then
			sm.train(PUNISH, attack, 5) -- we can no longer spawn attack vehicles
			sm.train(PUNISH, attack, 5)
			spawnAIVehicle()
			return
		end
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if island.faction == FACTION_AI then
				if selected_spawn_transform == nil or xzDistance(target.transform, island.transform) < xzDistance(target.transform, selected_spawn_transform) then
					if playersNotNearby(player_list, island.transform, min_player_distance, true) then -- makes sure no player is within 3km
						if hasTag(island.tags, "can_spawn="..string.gsub(getTagValue(selected_prefab.vehicle.tags, "vehicle_type", true), "wep_", "")) or hasTag(selected_prefab.vehicle.tags, "role=scout") then -- if it can spawn at the island
							selected_spawn_transform = island.transform
							selected_spawn = island_index
						end
					end
				end
			end
		end
	-- (A) if the vehicle we want to spawn is a defensive vehicle, we want to spawn it on the island that has the least amount of defence
	-- (B) if theres multiple, pick the island we saw the player closest to
	-- (C) if none, then spawn it at the island which is closest to the player's island
	elseif getTagValue(selected_prefab.vehicle.tags, "role") == "defend" then
		local lowest_defenders = nil
		local check_last_seen = false
		local islands_needing_checked = {}
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if island.faction == FACTION_AI then
				if playersNotNearby(player_list, island.transform, min_player_distance, true) then -- make sure no players are within 3km of the island
					if hasTag(island.tags, "can_spawn="..string.gsub(getTagValue(selected_prefab.vehicle.tags, "vehicle_type", true), "wep_", "")) or hasTag(selected_prefab.vehicle.tags, "role=scout") then -- if it can spawn at the island
						if not lowest_defenders or island.defenders < lowest_defenders then -- choose the island with the least amount of defence (A)
							lowest_defenders = island.defenders -- set the new lowest defender amount on an island
							selected_spawn_transform = island.transform
							selected_spawn = island_index
							check_last_seen = false -- say that we dont need to do a tie breaker
							islands_needing_checked = {}
						elseif lowest_defenders == island.defenders then -- if two islands have the same amount of defenders
							islands_needing_checked[selected_spawn] = selected_spawn_transform
							islands_needing_checked[island_index] = island.transform
							check_last_seen = true -- we need a tie breaker
						end
					end
				end
			end
		end
		if check_last_seen then -- do a tie breaker (B)
			local closest_player_pos = nil
			for player_steam_id, player_transform in pairs(g_savedata.ai_knowledge.last_seen_positions) do
				for island_index, island_transform in pairs(islands_needing_checked) do
					local player_to_island_dist = xzDistance(player_transform, island_transform)
					if player_to_island_dist < 6000 then
						if not closest_player_pos or player_to_island_dist < closest_player_pos then
							if playersNotNearby(player_list, island_transform, min_player_distance, true) then
								if hasTag(g_savedata.controllable_islands[island_index].tags, "can_spawn="..string.gsub(getTagValue(selected_prefab.vehicle.tags, "vehicle_type", true), "wep_", "")) or hasTag(selected_prefab.vehicle.tags, "role=scout") then -- if it can spawn at the island
									closest_player_pos = player_transform
									selected_spawn_transform = island_transform
									selected_spawn = island_index
								end
							end
						end
					end
				end
			end
			if not closest_player_pos then -- if no players were seen this game, spawn closest to the closest player island (C)
				for island_index, island_transform in pairs(islands_needing_checked) do
					for player_island_index, player_island in pairs(g_savedata.controllable_islands) do
						if player_island.faction == FACTION_PLAYER then
							if xzDistance(selected_spawn_transform, island_transform) > xzDistance(player_island.transform, island_transform) then
								if playersNotNearby(player_list, island_transform, min_player_distance, true) then
									if hasTag(g_savedata.controllable_islands[island_index].tags, "can_spawn="..string.gsub(getTagValue(selected_prefab.vehicle.tags, "vehicle_type", true), "wep_", "")) or hasTag(selected_prefab.vehicle.tags, "role=scout") then -- if it can spawn at the island
										selected_spawn_transform = island_transform
										selected_spawn = island_index
									end
								end
							end
						end
					end
				end
			end
		end
	-- spawn it at a random ai island
	else
		local valid_islands = {}
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if island.faction == FACTION_AI then
				if playersNotNearby(player_list, island.transform, min_player_distance, true) then
					if hasTag(island.tags, "can_spawn="..string.gsub(getTagValue(selected_prefab.vehicle.tags, "vehicle_type", true), "wep_", "")) or hasTag(selected_prefab.vehicle.tags, "role=scout") then
						table.insert(valid_islands, island)
					end
				end
			end
		end
		if #valid_islands > 0 then
			random_island = math.random(1, #valid_islands)
			selected_spawn_transform = valid_islands[random_island].transform
			selected_spawn = random_island
		end
	end



	-- spawn the vehicle
	local spawn_transform = selected_spawn_transform
	if hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_boat") then
		local boat_spawn_transform, found_ocean = s.getOceanTransform(spawn_transform, 500, 2000)
		if found_ocean == false then wpDLCDebug("unable to find ocean to spawn boat!", true, false); return end
		spawn_transform = m.multiply(boat_spawn_transform, m.translation(math.random(-500, 500), 0, math.random(-500, 500)))
	elseif hasTag(selected_prefab.vehicle.tags, "vehicle_type=wep_land") then
		local land_spawn_locations = {}
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if island.faction == FACTION_AI then
				if g_savedata.land_spawn_zones then
					for land_spawn_index, land_spawn in pairs(g_savedata.land_spawn_zones) do
						if m.distance(land_spawn, island.transform) <= 1000 or m.distance(land_spawn, g_savedata.ai_base_island.transform) <= 1000 then
							table.insert(land_spawn_locations, land_spawn)
						end
					end
				else
					for land_spawn_index, land_spawn in pairs(s.getZones("land_spawn")) do
						table.insert(g_savedata.land_spawn_zones, land_spawn.transform)
					end
				end
			end
		end
		if #land_spawn_locations > 0 then
			spawn_transform = land_spawn_locations[math.random(1, #land_spawn_locations)]
		else
			wpDLCDebug("No suitible spawn location found for land vehicle, attempting to spawn a different vehicle", true, false)
			spawnAIVehicle()
			return false
		end
	else
		spawn_transform = m.multiply(selected_spawn_transform, m.translation(math.random(-500, 500), CRUISE_HEIGHT + 200, math.random(-500, 500)))
	end

	-- check to make sure no vehicles are too close, as this could result in them spawning inside each other
	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if m.distance(spawn_transform, vehicle_object.transform) < (getTagValue(selected_prefab.vehicle.tags, "spawning_distance") or DEFAULT_SPAWNING_DISTANCE + vehicle_object.spawning_transform.distance) then
				wpDLCDebug("cancelling spawning vehicle, due to its proximity to vehicle "..vehicle_id, true, true)
				return false
			end
		end
	end

	-- spawn objects
	local all_addon_components = {}
	local spawned_objects = {
		spawned_vehicle = spawnObject(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.vehicle, 0, nil, all_addon_components),
		survivors = spawnObjects(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.survivors, all_addon_components),
		fires = spawnObjects(spawn_transform, selected_prefab.location.playlist_index, selected_prefab.location.location_index, selected_prefab.fires, all_addon_components),
	}
	local vehX, vehY, vehZ = m.position(spawn_transform)
	if selected_prefab.vehicle.display_name ~= nil then
		wpDLCDebug("spawned vehicle: "..selected_prefab.vehicle.display_name.." at X: "..vehX.." Y: "..vehY.." Z: "..vehZ, true, false)
	else
		wpDLCDebug("the selected vehicle is nil", true, true)
	end

	wpDLCDebug("spawning army vehicle: "..selected_prefab.location.data.name.." / "..selected_prefab.location.playlist_index.." / "..selected_prefab.vehicle.display_name, true, false)

	if spawned_objects.spawned_vehicle ~= nil then
		local vehicle_survivors = {}
		for key, char in  pairs(spawned_objects.survivors) do
			local c = s.getCharacterData(char.id)
			s.setCharacterData(char.id, c.hp, true, true)
			s.setAIState(char.id, 1)
			s.setAITargetVehicle(char.id, -1)
			table.insert(vehicle_survivors, char)
		end

		local home_x, home_y, home_z = m.position(spawn_transform)

		local vehicle_data = { 
			id = spawned_objects.spawned_vehicle.id,
			name = selected_prefab.location.data.name,
			survivors = vehicle_survivors, 
			path = { 
				[1] = {
					x = home_x, 
					y = CRUISE_HEIGHT + (spawned_objects.spawned_vehicle.id % 10 * 20), 
					z = home_z
				} 
			}, 
			state = { 
				s = VEHICLE_STATE_HOLDING, 
				timer = math.fmod(spawned_objects.spawned_vehicle.id, 300),
				is_simulating = false
			}, 
			map_id = s.getMapID(), 
			ai_type = spawned_objects.spawned_vehicle.ai_type,
			role = getTagValue(selected_prefab.vehicle.tags, "role", true) or "general",
			size = spawned_objects.spawned_vehicle.size,
			holding_index = 1, 
			vision = { 
				radius = getTagValue(selected_prefab.vehicle.tags, "visibility_range") or VISIBLE_DISTANCE,
				base_radius = getTagValue(selected_prefab.vehicle.tags, "visibility_range") or VISIBLE_DISTANCE,
				is_radar = hasTag(selected_prefab.vehicle.tags, "radar"),
				is_sonar = hasTag(selected_prefab.vehicle.tags, "sonar")
			},
			spawning_transform = {
				distance = getTagValue(selected_prefab.vehicle.tags, "spawning_distance") or DEFAULT_SPAWNING_DISTANCE
			},
			speed = {
				land = {
					normal = {
						road = getTagValue(selected_prefab.vehicle.tags, "road_speed_normal"),
						bridge = getTagValue(selected_prefab.vehicle.tags, "bridge_speed_normal"),
						offroad = getTagValue(selected_prefab.vehicle.tags, "offroad_speed_normal")
					},
					aggressive = {
						road = getTagValue(selected_prefab.vehicle.tags, "road_speed_aggressive"),
						bridge = getTagValue(selected_prefab.vehicle.tags, "bridge_speed_aggressive"),
						offroad = getTagValue(selected_prefab.vehicle.tags, "offroad_speed_aggressive")
					}
				},
				not_land = {
					pseudo_speed = getTagValue(selected_prefab.vehicle.tags, "pseudo_speed")
				}
			},
			capabilities = {
				gps_missiles = hasTag(selected_prefab.vehicle.tags, "GPS_MISSILE")
			},
			strategy = getTagValue(selected_prefab.vehicle.tags, "strategy", true) or "general",
			is_resupply_on_load = false,
			transform = spawn_transform,
			target_vehicle_id = -1,
			target_player_id = -1,
			current_damage = 0,
			health = getTagValue(selected_prefab.vehicle.tags, "health", false) or 1,
			damage_dealt = {},
			fire_id = nil,
		}

		if #spawned_objects.fires > 0 then
			vehicle_data.fire_id = spawned_objects.fires[1].id
		end

		local squad = addToSquadron(vehicle_data)
		if getTagValue(selected_prefab.vehicle.tags, "role", true) == "scout" then
			setSquadCommand(squad, COMMAND_SCOUT)
		elseif getTagValue(selected_prefab.vehicle.tags, "role", true) == "turret" then
			setSquadCommand(squad, COMMAND_TURRET)
		end
		return true, vehicle_data
	end
	return false
end

local player_commands = {
	normal = {
		info = {
			short_desc = "prints info about the mod",
			desc = "prints some info about the mod in chat! including version, world creation version, times reloaded, ect. Really helpful if you attach the commands output in bug reports!",
			args = "none",
			example = "?impwep info",
		},
		help = {
			short_desc = "shows a list of all of the commands",
			desc = "shows a list of all of the commands, to learn more about a command, type to commands name after \"help\" to learn more about it",
			args = "[command]",
			example = "?impwep help info",
		}
	},
	admin = {
		reset = {
			short_desc = "reset's the ai's commands",
			desc = "this resets the ai's commands, this is helpful for testing and debugging mostly",
			args = "none",
			example = "?impwep reset",
		},
		pseudo_speed = {
			short_desc = "lets you change ai's pseudo speed",
			desc = "this allows you to change the multiplier of the ai's pseudo speed, with the arg being the amount to times it by",
			args = "(multiplier)",
			example = "?impwep pseudo_speed 5",
		},
		vreset = {
			short_desc = "lets you reset an ai's state",
			desc = "this lets you reset an ai vehicle's state, such as holding, stationary, ect",
			args = "(vehicle_id)",
			example = "?impwep vreset 655",
		},
		target = {
			short_desc = "lets you change the ai's target",
			desc = "this lets you change what the ai is targeting, so they will attack it instead",
			args = "(vehicle_id)",
			example = "?impwep target 500",
		},
		sv = { -- spawn vehicle
			short_desc = "lets you spawn in an ai vehicle",
			desc = "this lets you spawn in a ai vehicle, if you dont specify one, it will spawn a random ai vehicle, and if you specify \"scout\", it will spawn a scout vehicle if it can spawn. specify x and y to spawn it at a certain location, or \"near\" and then a minimum distance and then a maximum distance",
			args = "[vehicle_id|\"scout\"] [x & y|\"near\" & min_range & max_range] ",
			example = "?impwep sv PLANE_-_EUROFIGHTER\n?impwep sv PLANE_-_EUROFIGHTER -500 500\n?impwep sv PLANE_-_EUROFIGHTER near 1000 5000",
		},
		vl = { -- vehicle list
			short_desc = "prints a list of all vehicles",
			desc = " prints a list of all of the AI vehicles in the addon, also shows their formatted name, which is used in commands",
			args = "none",
			example = "?impwep vl",
		},
		debug = {
			short_desc = "enables or disables debug mode",
			desc = "lets you toggle debug mode, also shows all the AI vehicles on the map with tons of info",
			args = "[vehicle_id]",
			example = "?impwep debug",
		},
		st = { -- spawn turret
			short_desc = "spawns a turret at every enemy AI island",
			desc = "spawns a turret at every enemy AI island",
			args = "none",
			example = "?impwep st",
		},
		cp = { -- capture point
			short_desc = "allows you to change who owns a point",
			desc = "allows you to change who owns a specific island",
			args = "(island_name) (\"ai\"|\"neutral\"|\"player\")",
			example = "?impwep cp North_Harbour ai",
		},
		aimod = {
			short_desc = "lets you get an ai's spawning modifier",
			desc = "lets you see what an ai's role, type, strategy or vehicle's spawning modifier is",
			args = "(role) [type] [strategy] [constructable_vehicle_id]",
			example = "?impwep aimod attack heli general 0",
		},
		setmod = {
			short_desc = "lets you change an ai's spawning modifier",
			desc = "lets you change what the ai's role spawning modifier is, does not yet support type, strategy or constructable vehicle id",
			args = "(\"reward\"|\"punish\") (role) (modifier: 1-5)",
			example = "?impwep setmod reward attack 4",
		},
		dv = { -- delete vehicle
			short_desc = "lets you delete an ai vehicle",
			desc = "lets you delete an ai vehicle by vehicle id, or all by specifying \"all\"",
			args = "(vehicle_id|\"all\")",
			example = "?impwep dv all",
		},
		si = { -- set scout intel
			short_desc = "lets you set the ai's scout level",
			desc = "lets you set the ai's scout level on a specific island, from 0 to 100 for 0% scouted to 100% scouted",
			args = "(island_name) (0-100)",
			example = "?impwep si North_Harbour 100",
		},
		setting = {
			short_desc = "lets you change or get a specific setting and can get a list of all settings",
			desc = "if you do not input the setting name, it will show a list of all valid settings, if you input a setting name but not a value, it will tell you the setting's current value, if you enter both the setting name and the setting value, it will change that setting to that value",
			args = "[setting_name] [value]",
			example = "?impwep setting MAX_BOAT_AMOUNT 5\n?impwep setting MAX_BOAT_AMOUNT\n?impwep setting",
		}
	},
	host = {
		full_reload = {
			short_desc = "lets you fully reload the addon",
			desc = "lets you fully reload the addon, basically making it think the world was just created, this command can and probably will break things, so dont use it unless you need to",
			args = "none",
			example = "?impwep full_reload",
		}
	}
}

function onCustomCommand(full_message, user_peer_id, is_admin, is_auth, prefix, command, ...)

	if prefix == "?impwep" then
		if is_dlc_weapons then
			if command then
				local arg = table.pack(...) -- this will supply all the remaining arguments to the function


				-- 
				-- commands all players can execute
				--
				if command == "info" then
					wpDLCDebug("------ Improved Conquest Mode Info ------", false, false, user_peer_id)
					wpDLCDebug("Version: "..IMPROVED_CONQUEST_VERSION, false, false, user_peer_id)
					if not g_savedata.info.has_ai_paths then
						wpDLCDebug("AI Paths Disabled (will cause ship pathfinding issues)", false, true, user_peer_id)
					end
					wpDLCDebug("World Creation Version: "..g_savedata.info.creation_version, false, false, user_peer_id)
					wpDLCDebug("Times Addon Was Fully Reloaded: "..tostring(g_savedata.info.full_reload_versions and #g_savedata.info.full_reload_versions or 0), false, false, user_peer_id)
					if g_savedata.info.full_reload_versions and #g_savedata.info.full_reload_versions ~= nil and #g_savedata.info.full_reload_versions ~= 0 then
						wpDLCDebug("Fully Reloaded Versions: ", false, false, user_peer_id)
						for i = 1, #g_savedata.info.full_reload_versions do
							wpDLCDebug(g_savedata.info.full_reload_versions[i], false, false, user_peer_id)
						end
					end
				end

				--
				-- admin only commands
				--
				if is_admin then
					if command == "reset" then
						for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
							if squad_index ~= RESUPPLY_SQUAD_INDEX then
								setSquadCommand(squad, COMMAND_NONE)
							end
						end
						g_is_air_ready = true
						g_is_boats_ready = false
						g_savedata.is_attack = false

					elseif command == "pseudo_speed" then
							g_debug_speed_multiplier = arg[1]

					elseif command == "vreset" then
							s.resetVehicleState(arg[1])

					elseif command == "target" then
						for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
							for vehicle_id, vehicle_object in pairs(squad.vehicles) do
								for i, char in  pairs(vehicle_object.survivors) do
									s.setAITargetVehicle(char.id, arg[1])
								end
							end
						end

					elseif command == "sv" then --spawn vehicle
						if arg[1] then
							vehicle_id = sm.getVehicleListID(string.gsub(arg[1], "_", " "))
							if vehicle_id or arg[1] == "scout" then
								valid_vehicle = true
								wpDLCDebug("Spawning \""..arg[1].."\"", false, false, user_peer_id)
								if arg[1] ~= "scout" then
									successfully_spawned, vehicle_data = spawnAIVehicle(vehicle_id)
									if successfully_spawned then
										if arg[2] ~= nil then
											if arg[2] == "near" then -- the player selected to spawn it in a range
												if tonumber(arg[3]) >= 150 then -- makes sure the min range is equal or greater than 150
													if tonumber(arg[4]) >= tonumber(arg[3]) then -- makes sure the max range is greater or equal to the min range
														if vehicle_data.ai_type == AI_TYPE_BOAT then
															local player_pos = s.getPlayerPos(user_peer_id)
															local new_location, found_new_location = s.getOceanTransform(player_pos, arg[3], arg[4])
															if found_new_location then
																-- teleport vehicle to new position
																local veh_x, veh_y, veh_z = m.position(new_location)
																s.setVehiclePos(vehicle_data.id, new_location)
																wpDLCDebug("Spawned "..vehicle_data.name.." at x:"..veh_x.." y:"..veh_y.." z:"..veh_z, false, false, user_peer_id)
															else
																-- delete vehicle as it was unable to find a valid position
																for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
																	for vehicle_index, vehicle_object in pairs(squad.vehicles) do
																		if vehicle_object.id == vehicle_data.id then
																			killVehicle(squad_index, vehicle_index, true, true)
																			wpDLCDebug("unable to find a valid area to spawn the ship! Try increasing the radius!", false, true, user_peer_id)
																		end
																	end
																end
															end
														elseif vehicle_data.ai_type == AI_TYPE_LAND then
															--[[
															local possible_islands = {}
															for island_index, island in pairs(g_savedata.controllable_islands) do
																if island.faction ~= FACTION_PLAYER then
																	if hasTag(island.tags, "can_spawn=land") then
																		for in pairs(island.zones.land)
																	for g_savedata.controllable_islands[island_index]
																	table.insert(possible_islands.)
																end
															end
															--]]
															wpDLCDebug("Sorry! As of now you are unable to select a spawn zone for land vehicles! this functionality will be added soon (should be implemented in 0.3.0, the next majour update)!", false, true, user_peer_id)
															for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
																for vehicle_index, vehicle_object in pairs(squad.vehicles) do
																	if vehicle_object.id == vehicle_data.id then
																		killVehicle(squad_index, vehicle_index, true, true)
																	end
																end
															end
														else
															local player_pos = s.getPlayerPos(user_peer_id)
															local player_x, player_y, player_z = m.position(player_pos)
															local veh_x, veh_y, veh_z = m.position(vehicle_data.transform)
															local new_location = m.translation(player_x + math.random(-math.random(arg[3], arg[4]), math.random(arg[3], arg[4])), veh_y * 1.5, player_z + math.random(-math.random(arg[3], arg[4]), math.random(arg[3], arg[4])))
															local new_veh_x, new_veh_y, new_veh_z = m.position(new_location)
															s.setVehiclePos(vehicle_data.id, new_location)
															vehicle_data.transform = new_location
															wpDLCDebug("Spawned "..vehicle_data.name.." at x:"..new_veh_x.." y:"..new_veh_y.." z:"..new_veh_z, false, false, user_peer_id)
														end
													else
														wpDLCDebug("your maximum range must be greater or equal to the minimum range!", false, true, user_peer_id)
														for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
															for vehicle_index, vehicle_object in pairs(squad.vehicles) do
																if vehicle_object.id == vehicle_data.id then
																	killVehicle(squad_index, vehicle_index, true, true)
																end
															end
														end
													end
												else
													wpDLCDebug("the minimum range must be at least 150!", false, true, user_peer_id)
													for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
														for vehicle_index, vehicle_object in pairs(squad.vehicles) do
															if vehicle_object.id == vehicle_data.id then
																killVehicle(squad_index, vehicle_index, true, true)
															end
														end
													end
												end
											else
												if tonumber(arg[2]) and tonumber(arg[2]) >= 0 or tonumber(arg[2]) and tonumber(arg[2]) <= 0 then -- the player selected specific coordinates
													if tonumber(arg[3]) and tonumber(arg[3]) >= 0 or tonumber(arg[3]) and tonumber(arg[3]) <= 0 then
														if vehicle_data.ai_type == AI_TYPE_BOAT then
															local new_pos = m.translation(arg[2], 0, arg[3])
															s.setVehiclePos(vehicle_data.id, new_pos)
															vehicle_data.transform = new_pos
															wpDLCDebug("Spawned "..vehicle_data.name.." at x:"..arg[2].." y:0 z:"..arg[3], false, false, user_peer_id)
														elseif vehicle_data.ai_type == AI_TYPE_LAND then
															wpDLCDebug("sorry! but as of now you are unable to specify the coordinates of where to spawn a land vehicle! this functionality will be added soon (should be implemented in 0.3.0, the next majour update)!", false, true, user_peer_id)
															for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
																for vehicle_index, vehicle_object in pairs(squad.vehicles) do
																	if vehicle_object.id == vehicle_data.id then
																		killVehicle(squad_index, vehicle_index, true, true)
																	end
																end
															end
														else -- air vehicle
															local new_pos = m.translation(arg[2], CRUISE_HEIGHT * 1.5, arg[3])
															s.setVehiclePos(vehicle_data.id, new_pos)
															vehicle_data.transform = new_pos
															wpDLCDebug("Spawned "..vehicle_data.name.." at x:"..arg[2].." y:"..(CRUISE_HEIGHT*1.5).." z:"..arg[3], false, false, user_peer_id)
														end
													else
														wpDLCDebug("invalid z coordinate: "..tostring(arg[3]), false, true, user_peer_id)
														for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
															for vehicle_index, vehicle_object in pairs(squad.vehicles) do
																if vehicle_object.id == vehicle_data.id then
																	killVehicle(squad_index, vehicle_index, true, true)
																end
															end
														end
													end
												else
													wpDLCDebug("invalid x coordinate: "..tostring(arg[2]), false, true, user_peer_id)
													for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
														for vehicle_index, vehicle_object in pairs(squad.vehicles) do
															if vehicle_object.id == vehicle_data.id then
																killVehicle(squad_index, vehicle_index, true, true)
															end
														end
													end
												end
											end
										end
									end
								elseif arg[1] == "scout" then
									local scout_exists = false
									for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
										for vehicle_index, vehicle in pairs(squad.vehicles) do
											if vehicle.role == "scout" then
												scout_exists = true
												if squad.command ~= COMMAND_SCOUT then not_scouting = true; squad_to_set = squad_index end
											end
										end
									end
									if not scout_exists then -- if a scout vehicle does not exist
										spawnAIVehicle(arg[1])
									else
										wpDLCDebug("unable to spawn scout vehicle: theres already a scout vehicle!", false, true, user_peer_id)
									end
								end
							else
								wpDLCDebug("Was unable to find a vehicle with the name \""..arg[1].."\", use '?impwep vl' to see all valid vehicle names | this is case sensitive, and all spaces must be replaced with underscores", false, true, user_peer_id)
							end
						else -- if vehicle not specified, spawn random vehicle
							wpDLCDebug("Spawning Random Enemy AI Vehicle", false, false, user_peer_id)
							spawnAIVehicle()
						end


					elseif command == "vl" then --vehicle list
						wpDLCDebug("Valid Vehicles:", false, false, user_peer_id)
						for vehicle_index, vehicle_object in pairs(g_savedata.vehicle_list) do
							wpDLCDebug("raw name: \""..vehicle_object.location.data.name.."\"", false, false, user_peer_id)
							wpDLCDebug("formatted name (for use in commands): \""..string.gsub(vehicle_object.location.data.name, " ", "_").."\"", false, false, user_peer_id)
						end


					elseif command == "debug" then
						if arg[1] then
							vehicles_debugging[tonumber(arg[1])] = not vehicles_debugging[tonumber(arg[1])]
							-- enabled or disabled message
							local enDis = "dis"
							if vehicles_debugging[tonumber(arg[1])] then
								enDis = "en"
							end
							wpDLCDebug(enDis.."abled debugging for vehicle id: "..arg[1], false, false, user_peer_id)
						else
							g_savedata.playerData.isDebugging[user_peer_id] = not g_savedata.playerData.isDebugging[user_peer_id]

							if g_savedata.playerData.isDebugging[user_peer_id] ~= true then
								wpDLCDebug("Debugging Disabled", false, false, user_peer_id)
							else
								wpDLCDebug("Debugging Enabled", false, false, user_peer_id)
							end
							
							render_debug = false
							for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
								if is_debugging then
									render_debug = true
								end
							end

							for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
								for vehicle_id, vehicle_object in pairs(squad.vehicles) do
									s.removeMapObject(user_peer_id, vehicle_object.map_id)
									s.removeMapLine(user_peer_id, vehicle_object.map_id)
									for i = 1, #vehicle_object.path - 1 do
										local waypoint = vehicle_object.path[i]
										s.removeMapLine(user_peer_id, waypoint.ui_id)
									end
								end
							end

							for island_index, island in pairs(g_savedata.controllable_islands) do
								updatePeerIslandMapData(user_peer_id, island)
							end
							
							updatePeerIslandMapData(user_peer_id, g_savedata.player_base_island)
							updatePeerIslandMapData(user_peer_id, g_savedata.ai_base_island)
						end


					elseif command == "st" then --spawn turret
						local turrets_spawned = 1
						spawnTurret(g_savedata.ai_base_island)
						for island_index, island in pairs(g_savedata.controllable_islands) do
							if island.faction == FACTION_AI then
								spawnTurret(island)
								turrets_spawned = turrets_spawned + 1
							end
						end
						wpDLCDebug("attempted to spawn "..turrets_spawned.." turrets", false, false, user_peer_id)


					elseif command == "cp" then --capture point
						if arg[1] and arg[2] then
							local is_island = false
							for island_index, island in pairs(g_savedata.controllable_islands) do
								if island.name == string.gsub(arg[1], "_", " ") then
									is_island = true
									if island.faction ~= arg[2] then
										if arg[2] == FACTION_AI or arg[2] == FACTION_NEUTRAL or arg[2] == FACTION_PLAYER then
											captureIsland(island, arg[2], user_peer_id)
										else
											wpDLCDebug(arg[2].." is not a valid faction! valid factions: | ai | neutral | player", false, true, user_peer_id)
										end
									else
										wpDLCDebug(island.name.." is already set to "..island.faction..".", false, true, user_peer_id)
									end
								end
							end
							if not is_island then
								wpDLCDebug(arg[1].." is not a valid island! Did you replace spaces with _?", false, true, user_peer_id)
							end
						else
							wpDLCDebug("Invalid Syntax! command usage: ?impwep cp (island_name) (faction)", false, true, user_peer_id)
						end


					


					elseif command == "aimod" then
						if arg[1] then
							sm.debug(user_peer_id, arg[1], arg[2], arg[3], arg[4])
						else
							wpDLCDebug("you need to specify which type to debug!", false, true, user_peer_id)
						end


					elseif command == "setmod" then
						if arg[1] then
							if arg[1] == "punish" or arg[2] == "reward" then
								if arg[2] then
									if g_savedata.constructable_vehicles[arg[1]].mod then
										if tonumber(arg[3]) then
											if arg[1] == "punish" then
												if ai_training.punishments[tonumber(arg[3])] then
													g_savedata.constructable_vehicles[arg[2]].mod = g_savedata.constructable_vehicles[arg[2]].mod + ai_training.punishments[tonumber(arg[3])]
													wpDLCDebug("Successfully set role "..arg[2].." to modifier: "..g_savedata.constructable_vehicles[arg[2]].mod, false, false, user_peer_id)
												else
													wpDLCDebug("Incorrect syntax! "..arg[3].." has to be a number from 1-5!", false, true, user_peer_id)
												end
											elseif arg[1] == "reward" then
												if ai_training.rewards[tonumber(arg[3])] then
													g_savedata.constructable_vehicles[arg[2]].mod = g_savedata.constructable_vehicles[arg[2]].mod + ai_training.rewards[tonumber(arg[3])]
													wpDLCDebug("Successfully set role "..arg[2].." to modifier: "..g_savedata.constructable_vehicles[arg[2]].mod, false, false, user_peer_id)
												else
													wpDLCDebug("Incorrect syntax! "..arg[3].." has to be a number from 1-5!", false, true, user_peer_id)
												end
											end
										else
											wpDLCDebug("Incorrect syntax! "..arg[3].." has to be a number from 1-5!", false, true, user_peer_id)
										end
									else
										wpDLCDebug("Unknown role: "..arg[2], false, true, user_peer_id)
									end
								else
									wpDLCDebug("You need to specify which role to set!", false, true, user_peer_id)
								end
							else
								wpDLCDebug("Unknown reinforcement type: "..arg[1].." valid reinforcement types: \"punish\" and \"reward\"", false, true, user_peer_id)
							end
						else
							wpDLCDebug("You need to specify wether to punish or reward!", false, true, user_peer_id)
						end

					-- arg 1 = id
					elseif command == "dv" then -- delete vehicle
						if arg[1] then
							if arg[1] == "all" then
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									for vehicle_id, vehicle_object in pairs(squad.vehicles) do
										killVehicle(squad_index, vehicle_id, true, true)
										wpDLCDebug("Sucessfully deleted vehicle "..vehicle_id, false, false, user_peer_id)
									end
								end
							else
								local found_vehicle = false
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									for vehicle_id, vehicle_object in pairs(squad.vehicles) do
										if vehicle_id == tonumber(arg[1]) then
											found_vehicle = true
											killVehicle(squad_index, vehicle_id, true, true)
											wpDLCDebug("Sucessfully deleted vehicle "..vehicle_id.." name: "..vehicle_object.name, false, false, user_peer_id)
										end
									end
								end
								if not found_vehicle then
									wpDLCDebug("Unable to find vehicle with id "..arg[1]..", double check the ID!", false, true, user_peer_id)
								end
							end
						else
							wpDLCDebug("Invalid syntax! You must either choose a vehicle id, or \"all\" to remove all enemy AI vehicles", false, true, user_peer_id) 
						end


					-- arg 1: island_name
					-- arg 2: 0 - 100, what scout level in % to set it to
					elseif command == "si" then -- scout island
						if arg[1] then
							if arg[2] then
								if tonumber(arg[2]) then
									if g_savedata.ai_knowledge.scout[string.gsub(arg[1], "_", " ")] then
										g_savedata.ai_knowledge.scout[string.gsub(arg[1], "_", " ")].scouted = (math.clamp(tonumber(arg[2]), 0, 100)/100) * scout_requirement

										-- announce the change to the players
										local name = s.getPlayerName(user_peer_id)
										s.notify(-1, "(Improved Conquest Mode) Scout Level Changed", name.." set "..arg[2].."'s scout level to "..(g_savedata.ai_knowledge.scout[string.gsub(arg[1], "_", " ")].scouted/scout_requirement*100).."%", 1)
									else
										wpDLCDebug("Unknown island: "..string.gsub(arg[1], "_", " "), false, true, user_peer_id)
									end
								else
									wpDLCDebug("Arg 2 has to be a number! Unknown value: "..arg[2], false, true, user_peer_id)
								end
							else
								wpDLCDebug("Invalid syntax! you must specify the scout level to set it to (0-100)", false, true, user_peer_id)
							end
						else
							wpDLCDebug("Invalid syntax! you must specify the island and the scout level (0-100) to set it to!", false, true, user_peer_id)
						end

					
					-- arg 1: setting name (optional)
					-- arg 2: value (optional)
					elseif command == "setting" then
						if not arg[1] then
							-- we want to print a list of all settings they can change
							wpDLCDebug("\nAll Improved Conquest Mode Settings", false, false, user_peer_id)
							for setting_name, setting_value in pairs(g_savedata.settings) do
								wpDLCDebug("-----\nSetting Name: "..setting_name.."\nSetting Type: "..type(setting_value), false, false, user_peer_id)
							end
						elseif g_savedata.settings[arg[1]] ~= nil then -- makes sure the setting they selected exists
							if not arg[2] then
								-- print the current value of the setting they selected
								wpDLCDebug(arg[1].."'s current value: "..tostring(g_savedata.settings[arg[1]]))
							else
								-- change the value of the setting they selected
								if type(g_savedata.settings[arg[1]]) == "number" then
									if tonumber(arg[2]) then
										wpDLCDebug(s.getPlayerName(user_peer_id).." has changed the setting "..arg[1].." from "..g_savedata.settings[arg[1]].." to "..arg[2], false, false, -1)
										g_savedata.settings[arg[1]] = tonumber(arg[2])
									else
										wpDLCDebug(arg[2].." is not a valid value! it must be a number!", false, true, user_peer_id)
									end
								elseif g_savedata.settings[arg[1]] == true or g_savedata.settings[arg[1]] == false then
									if arg[2] == "true" then
										wpDLCDebug(s.getPlayerName(user_peer_id).." has changed the setting "..arg[1].." from "..tostring(g_savedata.settings[arg[1]]).." to "..arg[2], false, false, -1)
										g_savedata.settings[arg[1]] = true
									elseif arg[2] == "false" then
										wpDLCDebug(s.getPlayerName(user_peer_id).." has changed the setting "..arg[1].." from "..tostring(g_savedata.settings[arg[1]]).." to "..arg[2], false, false, -1)
										g_savedata.settings[arg[1]] = false
									else
										wpDLCDebug(arg[2].." is not a valid value! it must be either \"true\" or \"false\"!", false, true, user_peer_id)
									end
								else
									wpDLCDebug("g_savedata.settings."..arg[1].." is not a number or a boolean! please report this as a bug! Value of g_savedata.settings."..arg[1]..":"..g_savedata.settings[arg[1]], false, true, user_peer_id)
								end
							end
						else 
							-- the setting they selected does not exist
							wpDLCDebug(arg[1].." is not a valid setting! do \"?impwep setting\" to get a list of all settings!", false, true, user_peer_id)
						end
					end
				else
					for command_name, command_info in pairs(player_commands.admin) do
						if command == command_name then
							wpDLCDebug("You do not have permission to use "..command..", contact a server admin if you believe this is incorrect.", false, true, user_peer_id)
						end
					end
				end

				--
				-- host only commands
				--
				if user_peer_id == 0 and is_admin then
					if command == "full_reload" and user_peer_id == 0 then
						if arg[1] == "confirm" and g_savedata.playerData.isDoAsISay[user_peer_id] then
							wpDLCDebug(s.getPlayerName(user_peer_id).." IS FULLY RELOADING IMPROVED CONQUEST MODE ADDON, THINGS HAVE A HIGH CHANCE OF BREAKING!", false, false)
							onCreate(true, true, user_peer_id)
						elseif arg[1] == "cancel" and g_savedata.playerData.isDoAsISay[user_peer_id] == true then
							wpDLCDebug("Action has been reverted, no longer will be fully reloading addon", false, false, user_peer_id)
							g_savedata.playerData.isDoAsISay[user_peer_id] = nil
						end
						if not arg[1] then
							wpDLCDebug("WARNING: This command can break your entire world, if you care about this world, before commencing with this command please MAKE A BACKUP.\n\nTo acknowledge you've read this, do\n\"?impwep full_reload confirm\".\n\nIf you want to go back now, do \n\"?impwep full_reload cancel.\"\n\nAction will be automatically reverting in 15 seconds", false, false, user_peer_id)
							g_savedata.playerData.isDoAsISay[user_peer_id] = true
							g_savedata.playerData.timers.isDoAsISay = g_savedata.tick_counter
						end
					end
				else
					for command_name, command_info in pairs(player_commands.host) do
						if command == command_name then
							wpDLCDebug("You do not have permission to use "..command..", contact a server admin if you believe this is incorrect.", false, true, user_peer_id)
						end
					end
				end
				
				--
				-- help command
				--
				if command == "help" then
					if not arg[1] then -- print a list of all commands
						
						-- player commands
						wpDLCDebug("All Improved Conquest Mode Commands (PLAYERS)", false, false, user_peer_id)
						for command_name, command_info in pairs(player_commands.normal) do 
							if command_info.args ~= "none" then
								wpDLCDebug("-----\nCommand\n?impwep "..command_name.." "..command_info.args, false, false, user_peer_id)
							else
								wpDLCDebug("-----\nCommand\n?impwep "..command_name, false, false, user_peer_id)
							end
							wpDLCDebug("Short Description\n"..command_info.short_desc, false, false, user_peer_id)
						end

						-- admin commands
						if is_admin then 
							wpDLCDebug("\nAll Improved Conquest Mode Commands (ADMIN)", false, false, user_peer_id)
							for command_name, command_info in pairs(player_commands.admin) do
								if command_info.args ~= "none" then
									wpDLCDebug("-----\nCommand\n?impwep "..command_name.." "..command_info.args, false, false, user_peer_id)
								else
									wpDLCDebug("-----\nCommand\n?impwep "..command_name, false, false, user_peer_id)
								end
								wpDLCDebug("Short Description\n"..command_info.short_desc, false, false, user_peer_id)
							end
						end

						-- host only commands
						if user_peer_id == 0 and is_admin then
							wpDLCDebug("\nAll Improved Conquest Mode Commands (HOST)", false, false, user_peer_id)
							for command_name, command_info in pairs(player_commands.host) do
								if command_info.args ~= "none" then
									wpDLCDebug("-----\nCommand\n?impwep "..command_name.." "..command_info.args, false, false, user_peer_id)
								else
									wpDLCDebug("-----\nCommand\n?impwep "..command_name, false, false, user_peer_id)
								end
								wpDLCDebug("Short Description\n "..command_info.short_desc.."\n", false, false, user_peer_id)
							end
						end

					else -- print data only on the specific command they specified, if it exists
						local command_exists = false
						local has_permission = false
						local command_data = nil
						for permission_level, command_list in pairs(player_commands) do
							for command_name, command_info in pairs(command_list) do
								if command_name == arg[1]then
									command_exists = true
									command_data = command_info
									if
									permission_level == "admin" and is_admin 
									or 
									permission_level == "host" and is_admin and user_peer_id == 0 
									or
									permission_level == "normal"
									then
										has_permission = true
									end
								end
							end
						end
						if command_exists then -- if the command exists
							if has_permission then -- if they can execute it
								if command_data.args ~= "none" then
									wpDLCDebug("\nCommand\n?impwep "..arg[1].." "..command_data.args, false, false, user_peer_id)
								else
									wpDLCDebug("\nCommand\n?impwep "..arg[1], false, false, user_peer_id)
								end
								wpDLCDebug("Description\n"..command_data.desc, false, false, user_peer_id)
								wpDLCDebug("Example Usage\n"..command_data.example, false, false, user_peer_id)
							else
								wpDLCDebug("You do not have permission to use \""..arg[1].."\", contact a server admin if you believe this is incorrect.", false, true, user_peer_id)
							end
						else
							wpDLCDebug("unknown command! \""..arg[1].."\" do \"?impwep help\" to get a list of all valid commands!", false, true, user_peer_id)
						end
					end
				end

				-- if the command they entered exists
				local is_command = false
				for permission_level, command_list in pairs(player_commands) do
					for command_name, command_info in pairs(command_list) do
						if command_name == command then
							is_command = true
						end
					end
				end

				if not is_command then -- if the command they specified does not exist
					wpDLCDebug("unknown command! \""..command.."\" do \"?impwep help\" to get a list of all valid commands!", false, true, user_peer_id)
				end

			else
				wpDLCDebug("you need to specify a command! use\n\"?impwep help\" to get a list of all commands!", false, true, user_peer_id)
			end
		else
			if g_savedata.info.has_default_addon then
				wpDLCDebug("Improved Conquest Mode is disabled as you left Vanilla Conquest Mode enabled! Please create a new world and disable \"DLC Weapons AI\"", false, true, user_peer_id)
			end
		end
	end
end

function captureIsland(island, override, peer_id)
	local faction_to_set = nil

	if not override then
		if island.capture_timer <= 0 and island.faction ~= FACTION_AI then -- Player Lost Island
			faction_to_set = FACTION_AI
		elseif island.capture_timer >= g_savedata.settings.CAPTURE_TIME and island.faction ~= FACTION_PLAYER then -- Player Captured Island
			faction_to_set = FACTION_PLAYER
		end
	end

	-- set it to the override, otherwise if its supposted to be capped then set it to the specified, otherwise set it to ignore
	faction_to_set = override or faction_to_set or "ignore"

	-- set it to ai
	if faction_to_set == FACTION_AI then
		island.capture_timer = 0
		island.faction = FACTION_AI
		g_savedata.is_attack = false
		updatePeerIslandMapData(-1, island)

		if peer_id then
			name = s.getPlayerName(peer_id)
			s.notify(-1, "ISLAND CAPTURED", "The enemy has captured an island. (set manually by "..name.." via command)", 3)
		else
			s.notify(-1, "ISLAND CAPTURED", "The enemy has captured an island.", 3)
		end

		island.is_scouting = false
		g_savedata.ai_knowledge.scout[island.name].scouted = scout_requirement

		sm.train(REWARD, "defend", 4)
		sm.train(PUNISH, "attack", 5)

		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			if squad.command == COMMAND_ATTACK or squad.command == COMMAND_STAGE then
				setSquadCommand(squad, COMMAND_NONE) -- free squads from objective
			end
		end
	-- set it to player
	elseif faction_to_set == FACTION_PLAYER then
		island.capture_timer = g_savedata.settings.CAPTURE_TIME
		island.faction = FACTION_PLAYER
		updatePeerIslandMapData(-1, island)

		if peer_id then
			name = s.getPlayerName(peer_id)
			s.notify(-1, "ISLAND CAPTURED", "Successfully captured an island. (set manually by "..name.." via command)", 4)
		else
			s.notify(-1, "ISLAND CAPTURED", "Successfully captured an island.", 4)
		end

		g_savedata.ai_knowledge.scout[island.name].scouted = 0

		sm.train(REWARD, "defend", 1)
		sm.train(REWARD, "attack", 2)

		-- update vehicles looking to resupply
		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			if squad_index == RESUPPLY_SQUAD_INDEX then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					resetPath(vehicle_object)
				end
			end
		end
	-- set it to neutral
	elseif faction_to_set == FACTION_NEUTRAL then
		island.capture_timer = g_savedata.settings.CAPTURE_TIME/2
		island.faction = FACTION_NEUTRAL
		updatePeerIslandMapData(-1, island)

		if peer_id then
			name = s.getPlayerName(peer_id)
			s.notify(-1, "ISLAND SET NEUTRAL", "Successfully set an island to neutral. (set manually by "..name.." via command)", 1)
		else
			s.notify(-1, "ISLAND SET NEUTRAL", "Successfully set an island to neutral.", 1)
		end

		island.is_scouting = false
		g_savedata.ai_knowledge.scout[island.name].scouted = 0

		-- update vehicles looking to resupply
		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			if squad_index == RESUPPLY_SQUAD_INDEX then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					resetPath(vehicle_object)
				end
			end
		end
	elseif island.capture_timer > g_savedata.settings.CAPTURE_TIME then -- if its over 100% island capture
		island.capture_timer = g_savedata.settings.CAPTURE_TIME
	elseif island.capture_timer < 0 then -- if its less than 0% island capture
		island.capture_timer = 0
	end

	if render_debug then
		for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
			if is_debugging then
				updatePeerIslandMapData(player_id, island)
			end
		end
	end
end

function onPlayerJoin(steam_id, name, peer_id)
	warningChecks(-1)
	if is_dlc_weapons then
		for island_index, island in pairs(g_savedata.controllable_islands) do
			updatePeerIslandMapData(peer_id, island)
		end

		local ts_x, ts_y, ts_z = m.position(g_savedata.ai_base_island.transform)
		s.removeMapObject(peer_id, g_savedata.ai_base_island.map_id)
		s.addMapObject(peer_id, g_savedata.ai_base_island.map_id, 0, 10, ts_x, ts_z, 0, 0, 0, 0, g_savedata.ai_base_island.name.." ("..g_savedata.ai_base_island.faction..")", 1, "", 255, 0, 0, 255)

		local ts_x, ts_y, ts_z = m.position(g_savedata.player_base_island.transform)
		s.removeMapObject(peer_id, g_savedata.player_base_island.map_id)
		s.addMapObject(peer_id, g_savedata.player_base_island.map_id, 0, 10, ts_x, ts_z, 0, 0, 0, 0, g_savedata.player_base_island.name.." ("..g_savedata.player_base_island.faction..")", 1, "", 0, 255, 0, 255)
	end
end

function onVehicleDamaged(incoming_vehicle_id, amount, x, y, z, body_id)
	if is_dlc_weapons then
		vehicleData = s.getVehicleData(incoming_vehicle_id)
		local player_vehicle = g_savedata.player_vehicles[incoming_vehicle_id]

		if player_vehicle ~= nil then
			local damage_prev = player_vehicle.current_damage
			player_vehicle.current_damage = player_vehicle.current_damage + amount

			if damage_prev <= player_vehicle.damage_threshold and player_vehicle.current_damage > player_vehicle.damage_threshold then
				player_vehicle.death_pos = player_vehicle.transform
			end
			if amount > 0 then -- checks if it was actual damage and not from the player repairing their vehicle
				-- attempts to estimate which vehicles did the damage, as to not favour the vehicles that are closest
				-- give it to all vehicles within 3000m of the player, and that are targeting the player's vehicle
				local valid_ai_vehicles = {}
				for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
					for vehicle_id, vehicle_object in pairs(squad.vehicles) do
						if vehicle_object.target_vehicle_id == incoming_vehicle_id then -- if the ai vehicle is targeting the vehicle which was damaged
							if xzDistance(player_vehicle.transform, vehicle_object.transform) <= 3000 then -- if the ai vehicle is 3000m or less away from the player
								valid_ai_vehicles[vehicle_id] = vehicle_object
								if not vehicle_object.damage_dealt[incoming_vehicle_id] then vehicle_object.damage_dealt[incoming_vehicle_id] = 0 end
							end
						end
					end
				end
				-- <valid ai> = all the enemy ai vehicles within 3000m of the player, and that are targeting the player
				-- <ai amount> = number of <valid ai>
				--
				-- for all the <valid ai>, add the damage dealt to the player / <ai_amount> to their damage dealt property
				-- this is used to tell if that vehicle, the type of vehicle, its strategy and its role was effective
				for vehicle_id, vehicle_object in pairs(valid_ai_vehicles) do
					vehicle_object.damage_dealt[incoming_vehicle_id] = vehicle_object.damage_dealt[incoming_vehicle_id] + amount/tableLength(valid_ai_vehicles)
				end
			end
		end

		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			for vehicle_id, vehicle_object in pairs(squad.vehicles) do
				if vehicle_id == incoming_vehicle_id and body_id == 0 then
					if vehicle_object.current_damage == nil then vehicle_object.current_damage = 0 end
					local damage_prev = vehicle_object.current_damage
					vehicle_object.current_damage = vehicle_object.current_damage + amount

					local enemy_hp = vehicle_object.health * g_savedata.settings.ENEMY_HP_MODIFIER

					if not g_savedata.settings.SINKING_MODE or g_savedata.settings.SINKING_MODE and hasTag(vehicleData.tags, "vehicle_type=wep_land") or g_savedata.settings.SINKING_MODE and hasTag(vehicleData.tags, "vehicle_type=wep_turret") then

						if damage_prev <= (enemy_hp * 2) and vehicle_object.current_damage > (enemy_hp * 2) then
							killVehicle(squad_index, vehicle_id, true)
						elseif damage_prev <= enemy_hp and vehicle_object.current_damage > enemy_hp then
							killVehicle(squad_index, vehicle_id, false)
						end
					end
				end
			end
		end
	end
end

function onVehicleTeleport(vehicle_id, peer_id, x, y, z)
	if is_dlc_weapons then
		if g_savedata.player_vehicles[vehicle_id] ~= nil then
			g_savedata.player_vehicles[vehicle_id].current_damage = 0
		end
	end
end

function onVehicleSpawn(vehicle_id, peer_id, x, y, z, cost)
	if is_dlc_weapons then
		if peer_id ~= -1 and peer_id ~= 65535 then
			-- player spawned vehicle
			g_savedata.player_vehicles[vehicle_id] = {
				current_damage = 0, 
				damage_threshold = 100, 
				death_pos = nil, 
				map_id = s.getMapID()
			}
		end
	end
end

function onVehicleDespawn(vehicle_id, peer_id)
	if is_dlc_weapons then
		if g_savedata.player_vehicles[vehicle_id] ~= nil then
			g_savedata.player_vehicles[vehicle_id] = nil
		end
	end

	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for ai_vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if vehicle_id == ai_vehicle_id then
				cleanVehicle(squad_index, vehicle_id)
			end
		end
	end
end

function cleanVehicle(squad_index, vehicle_id)

	local vehicle_object = g_savedata.ai_army.squadrons[squad_index].vehicles[vehicle_id]

	wpDLCDebug("cleaned vehicle: "..vehicle_id, true, false)
	for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
		if is_debugging then

			s.removeMapObject(player_id ,vehicle_object.map_id)
			s.removeMapLine(player_id ,vehicle_object.map_id)
			for i = 1, #vehicle_object.path - 1 do
				local waypoint = vehicle_object.path[i]
				s.removeMapLine(player_id, waypoint.ui_id)
			end
		end
	end

	if vehicle_object.ai_type == AI_TYPE_TURRET and vehicle_object.spawnbox_index ~= nil then
		for island_index, island in pairs(g_savedata.controllable_islands) do		
			if island.name == vehicle_object.home_island then
				island.zones[vehicle_object.spawnbox_index].is_spawned = false
			end
		end
	end

	for _, survivor in pairs(vehicle_object.survivors) do
		s.despawnObject(survivor.id, true)
	end

	if vehicle_object.fire_id ~= nil then
		s.despawnObject(vehicle_object.fire_id, true)
	end

	g_savedata.ai_army.squadrons[squad_index].vehicles[vehicle_id] = nil

	if squad_index ~= RESUPPLY_SQUAD_INDEX then
		if tableLength(g_savedata.ai_army.squadrons[squad_index].vehicles) <= 0 then -- squad has no more vehicles
			g_savedata.ai_army.squadrons[squad_index] = nil

			for island_index, island in pairs(g_savedata.controllable_islands) do
				if island.assigned_squad_index == squad_index then
					island.assigned_squad_index = -1
				end
			end
		end
	end
end

function onVehicleUnload(incoming_vehicle_id)
	if is_dlc_weapons then
		wpDLCDebug("onVehicleUnload: "..incoming_vehicle_id, true, false)

		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			for vehicle_id, vehicle_object in pairs(squad.vehicles) do
				if incoming_vehicle_id == vehicle_id then
					if vehicle_object.is_killed == true then
						cleanVehicle(squad_index, vehicle_id)
					else
						wpDLCDebug("onVehicleUnload: set vehicle pseudo: "..vehicle_id, true, false)
						if not vehicle_object.name then vehicle_object.name = "nil" end
						wpDLCDebug("(onVehicleUnload) vehicle name: "..vehicle_object.name, true, false)
						vehicle_object.state.is_simulating = false
					end
				end
			end
		end
	end
end

function setKeypadTargetCoords(vehicle_id, vehicle_object, squad)
	local squad_vision = squadGetVisionData(squad)
	local target = nil
	if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 and vehicle_object.target_player_id and squad_vision.visible_players_map[vehicle_object.target_player_id] then
		target = squad_vision.visible_players_map[vehicle_object.target_player_id].obj
	elseif vehicle_object.target_vehicle_id ~= -1 and vehicle_object.target_vehicle_id and squad_vision.visible_vehicles_map[vehicle_object.target_vehicle_id] then
		target = squad_vision.visible_vehicles_map[vehicle_object.target_vehicle_id].obj
	end
	if target then
		tx, ty, tz = matrix.position(target.last_known_pos)
		s.setVehicleKeypad(vehicle_id, "AI_GPS_MISSILE_TARGET_X", tx)
		s.setVehicleKeypad(vehicle_id, "AI_GPS_MISSILE_TARGET_Y", ty)
		s.setVehicleKeypad(vehicle_id, "AI_GPS_MISSILE_TARGET_Z", tz)
		s.pressVehicleButton(vehicle_id, "AI_GPS_MISSILE_FIRE")
	end
end

function setLandTarget(vehicle_id, vehicle_object)
	if vehicle_object.state.is_simulating and vehicle_id and vehicle_object.path[1].x then
		s.setVehicleKeypad(vehicle_id, "AI_WAYPOINT_LAND_X", vehicle_object.path[1].x)
		s.setVehicleKeypad(vehicle_id, "AI_WAYPOINT_LAND_Z", vehicle_object.path[1].z)
		s.setVehicleKeypad(vehicle_id, "AI_WAYPOINT_FINAL_LAND_X", vehicle_object.path[#vehicle_object.path].x)
		s.setVehicleKeypad(vehicle_id, "AI_WAYPOINT_FINAL_LAND_Z", vehicle_object.path[#vehicle_object.path].z)
		local terrain_type = 2
		if vehicle_object.terrain_type == "road" then
			terrain_type = 1
		elseif vehicle_object.terrain_type == "bridge" then
			terrain_type = 3
		end

		local is_aggressive = 0
		if vehicle_object.is_aggressive == "aggressive" then
			is_aggressive = 1
		end
		s.setVehicleKeypad(vehicle_id, "AI_ROAD_TYPE", terrain_type)
		s.setVehicleKeypad(vehicle_id, "AI_AGR_STATUS", is_aggressive)
	end
end

function onVehicleLoad(incoming_vehicle_id)
	if is_dlc_weapons then
		wpDLCDebug("(onVehicleLoad) vehicle loading! id: "..incoming_vehicle_id, true, false)

		if g_savedata.player_vehicles[incoming_vehicle_id] ~= nil then
			local player_vehicle_data = s.getVehicleData(incoming_vehicle_id)
			g_savedata.player_vehicles[incoming_vehicle_id].damage_threshold = player_vehicle_data.voxels / 4
			g_savedata.player_vehicles[incoming_vehicle_id].transform = s.getVehiclePos(incoming_vehicle_id)
		end

		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			for vehicle_id, vehicle_object in pairs(squad.vehicles) do
				if incoming_vehicle_id == vehicle_id then
					wpDLCDebug("(onVehicleLoad) set vehicle simulating: "..vehicle_id, true, false)
					if not vehicle_object.name then vehicle_object.name = "nil" end
					wpDLCDebug("(onVehicleLoad) vehicle name: "..vehicle_object.name, true, false)
					vehicle_object.state.is_simulating = true
					vehicle_object.transform = s.getVehiclePos(vehicle_id)
					-- check to make sure no vehicles are too close, as this could result in them spawning inside each other
					for checking_squad_index, checking_squad in pairs(g_savedata.ai_army.squadrons) do
						for checking_vehicle_id, checking_vehicle_object in pairs(checking_squad.vehicles) do
							if checking_vehicle_object.id ~= vehicle_id then
								if m.distance(vehicle_object.transform, checking_vehicle_object.transform) < (getTagValue(vehicle_object.tags, "spawning_distance") or DEFAULT_SPAWNING_DISTANCE + checking_vehicle_object.spawning_transform.distance) then
									wpDLCDebug("cancelling spawning vehicle, due to its proximity to vehicle "..vehicle_id, true, true)
									killVehicle(squad_index, vehicle_id, true, true)
									return
								end
							end
						end
					end

					if vehicle_object.is_resupply_on_load then
						vehicle_object.is_resupply_on_load = false
						reload(vehicle_id)
					end

					for i, char in pairs(vehicle_object.survivors) do
						if vehicle_object.ai_type == AI_TYPE_TURRET then
							--Gunners
							s.setCharacterSeated(char.id, vehicle_id, "Gunner ".. i)
							local c = s.getCharacterData(char.id)
							s.setCharacterData(char.id, c.hp, true, true)
						else
							if i == 1 then
								if vehicle_object.ai_type == AI_TYPE_BOAT or vehicle_object.ai_type == AI_TYPE_LAND then
									s.setCharacterSeated(char.id, vehicle_id, "Captain")
								else
									s.setCharacterSeated(char.id, vehicle_id, "Pilot")
								end
								local c = s.getCharacterData(char.id)
								s.setCharacterData(char.id, c.hp, true, true)
							else
								--Gunners
								s.setCharacterSeated(char.id, vehicle_id, "Gunner ".. (i - 1))
								local c = s.getCharacterData(char.id)
								s.setCharacterData(char.id, c.hp, true, true)
							end
						end
					end
					if vehicle_object.ai_type == AI_TYPE_LAND then
						if(#vehicle_object.path >= 1) then
							setLandTarget(vehicle_id, vehicle_object)
						end
						if g_savedata.terrain_scanner_links[vehicle_id] == nil then
							local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)
							local get_terrain_matrix = m.translation(vehicle_x, 1000, vehicle_z)
							local terrain_object, success = s.spawnAddonComponent(get_terrain_matrix, g_savedata.terrain_scanner_prefab.playlist_index, g_savedata.terrain_scanner_prefab.location_index, g_savedata.terrain_scanner_prefab.object_index, 0)
							if success then
								g_savedata.terrain_scanner_links[vehicle_id] = terrain_object.id
							else
								wpDLCDebug("Unable to spawn terrain height checker!", true, true)
							end
						elseif g_savedata.terrain_scanner_links[vehicle_id] == "Just Teleported" then
							g_savedata.terrain_scanner_links[vehicle_id] = nil
						end
					elseif vehicle_object.ai_type == AI_TYPE_BOAT then
						local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)
						if vehicle_y > 10 then -- if its above y 10
							local playerList = s.getPlayers()
							local is_player_close = false
							-- checks if any players are within 750m of the vehicle
							for _, player in pairs(playerList) do
								local player_transform = s.getPlayerPos(player.id)
								if m.distance(player_transform, vehicle_object.transform) < 250 then
									is_player_close = true
								end
							end
							if not is_player_close then
								wpDLCDebug("a vehicle was removed as it tried to spawn in the air!", true, false)
								killVehicle(squad_index, vehicle_id, true, true) -- delete vehicle
							end
						end
					end
					refuel(vehicle_id)
					return
				end
			end
		end
	end
end

function resetPath(vehicle_object)
	for _, v in pairs(vehicle_object.path) do
		s.removeMapID(-1, v.ui_id)
	end

	vehicle_object.path = {}
end

function addPath(vehicle_object, target_dest)
	if(vehicle_object.ai_type == AI_TYPE_TURRET) then vehicle_object.state.s = "stationary" return end

	if(vehicle_object.ai_type == AI_TYPE_BOAT) then
		local dest_x, dest_y, dest_z = m.position(target_dest)

		local path_start_pos = nil

		if #vehicle_object.path > 0 then
			local waypoint_end = vehicle_object.path[#vehicle_object.path]
			path_start_pos = m.translation(waypoint_end.x, waypoint_end.y, waypoint_end.z)
		else
			path_start_pos = vehicle_object.transform
		end

		local path_list = s.pathfindOcean(path_start_pos, m.translation(dest_x, 0, dest_z))
		for path_index, path in pairs(path_list) do
			table.insert(vehicle_object.path, { x =  path.x + math.random(-50, 50), y = 0, z = path.z + math.random(-50, 50), ui_id = s.getMapID() })
		end
	elseif vehicle_object.ai_type == AI_TYPE_LAND then
		local dest_x, dest_y, dest_z = m.position(target_dest)

		local path_start_pos = nil

		if #vehicle_object.path > 0 then
			local waypoint_end = vehicle_object.path[#vehicle_object.path]
			path_start_pos = m.translation(waypoint_end.x, waypoint_end.y, waypoint_end.z)
		else
			path_start_pos = vehicle_object.transform
		end

		start_x, start_y, start_z = m.position(vehicle_object.transform)
 
		local path_list = s.pathfindOcean(path_start_pos, m.translation(dest_x, 1000, dest_z))
		for path_index, path in pairs(path_list) do
			veh_x, veh_y, veh_z = m.position(vehicle_object.transform)
			distance = m.distance(vehicle_object.transform, m.translation(path.x, veh_y, path.z))
			if path_index == 1 then
				wpDLCDebugVehicle(vehicle_object.id, "vehicle id: "..vehicle_object.id.." | distance from destination: "..m.distance(vehicle_object.transform, m.translation(dest_x, veh_y, dest_z)).." distance from path 1 to dest: "..m.distance(m.translation(dest_x, veh_y, dest_z), m.translation(path.x, veh_y, path.z)), true, false)
			end
			if path_index ~= 1 or #path_list == 1 or m.distance(vehicle_object.transform, m.translation(dest_x, veh_y, dest_z)) > m.distance(m.translation(dest_x, veh_y, dest_z), m.translation(path.x, veh_y, path.z)) and distance >= 7 then
				table.insert(vehicle_object.path, { x =  path.x, y = path.y, z = path.z, ui_id = s.getMapID() })
			end
		end
		setLandTarget(vehicle_id, vehicle_object)
	else
		local dest_x, dest_y, dest_z = m.position(target_dest)
		table.insert(vehicle_object.path, { x = dest_x, y = dest_y, z = dest_z, ui_id = s.getMapID() })
	end

	vehicle_object.state.s = VEHICLE_STATE_PATHING
end

function tickGamemode()
	if is_dlc_weapons then
		-- tick enemy base spawning
		g_savedata.ai_base_island.production_timer = g_savedata.ai_base_island.production_timer + 1
		if g_savedata.ai_base_island.production_timer > g_savedata.settings.AI_PRODUCTION_TIME_BASE then
			g_savedata.ai_base_island.production_timer = 0

			spawnTurret(g_savedata.ai_base_island)
			spawnAIVehicle()
		end
		for island_index, island in pairs(g_savedata.controllable_islands) do

			if island.ai_capturing == nil then
				island.ai_capturing = 0
				island.players_capturing = 0
			end

			-- spawn turrets at owned islands
			if island.faction == FACTION_AI and g_savedata.ai_base_island.production_timer == 1 then
				spawnTurret(island)
			end
			
			-- tick capture timers
			local tick_rate = 60
			if island.capture_timer >= 0 and island.capture_timer <= g_savedata.settings.CAPTURE_TIME then -- if the capture timers are within range of the min and max
				local playerList = s.getPlayers()
				-- does a check for how many enemy ai are capturing the island
				if island.capture_timer > 0 then
					for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
						if squad.command == COMMAND_ATTACK and squad.target_island.name == island.name or squad.command ~= COMMAND_ATTACK and squad.command ~= COMMAND_SCOUT and squad.command ~= COMMAND_RESUPPLY then
							for vehicle_id, vehicle_object in pairs(squad.vehicles) do
								if isTickID(vehicle_id, tick_rate) then
									if vehicle_object.role ~= "scout" and not vehicle_object.is_killed then
										if m.distance(island.transform, vehicle_object.transform) < CAPTURE_RADIUS / 1.5 then
											island.ai_capturing = island.ai_capturing + 1
										elseif m.distance(island.transform, vehicle_object.transform) < CAPTURE_RADIUS and island.faction == FACTION_AI then
											island.ai_capturing = island.ai_capturing + 1
										end
									end
								end
							end
						end
					end
				end

				-- does a check for how many players are capturing the island
				if g_savedata.settings.CAPTURE_TIME > island.capture_timer then -- if the % captured is not 100% or more
					for _, player in pairs(playerList) do
						if isTickID(player.id, tick_rate) then
							local player_transform = s.getPlayerPos(player.id)
							local flag_vehicle_transform = s.getVehiclePos(island.flag_vehicle.id)
							if m.distance(flag_vehicle_transform, player_transform) < 15 then -- if they are within 15 metres of the capture point
								island.players_capturing = island.players_capturing + 1
							elseif m.distance(flag_vehicle_transform, player_transform) < CAPTURE_RADIUS / 5 and island.faction == FACTION_PLAYER then -- if they are within CAPTURE_RADIUS / 5 metres of the capture point and if they own the point, this is their defending radius
								island.players_capturing = island.players_capturing + 1
							end
						end
					end
				end

				if isTickID(60, tick_rate) then
					if island.players_capturing > 0 and island.ai_capturing > 0 and g_savedata.settings.CONTESTED_MODE then -- if theres ai and players capping, and if contested mode is enabled
						if island.is_contested == false then -- notifies that an island is being contested
							s.notify(-1, "ISLAND CONTESTED", "An island is being contested!", 1)
							island.is_contested = true
						end
					else
						island.is_contested = false
						if island.players_capturing > 0 then -- tick player progress if theres one or more players capping

							island.capture_timer = island.capture_timer + ((ISLAND_CAPTURE_AMOUNT_PER_SECOND * 5) * capture_speeds[math.min(island.players_capturing, 3)])
						elseif island.ai_capturing > 0 then -- tick AI progress if theres one or more ai capping
							island.capture_timer = island.capture_timer - (ISLAND_CAPTURE_AMOUNT_PER_SECOND * capture_speeds[math.min(island.ai_capturing, 3)])
						end
					end
					
					-- displays tooltip on vehicle
					local cap_percent = math.floor((island.capture_timer/g_savedata.settings.CAPTURE_TIME) * 100)
					if island.is_contested then -- if the point is contested (both teams trying to cap)
						s.setVehicleTooltip(island.flag_vehicle.id, "Contested: "..cap_percent.."%")
					elseif island.faction ~= FACTION_PLAYER then -- if the player doesn't own the point
						if island.ai_capturing == 0 and island.players_capturing == 0 then -- if nobody is capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Capture: "..cap_percent.."%")
						elseif island.ai_capturing == 0 then -- if players are capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Capturing: "..cap_percent.."%")
						else -- if ai is capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Losing: "..cap_percent.."%")
						end
					else -- if the player does own the point
						if island.ai_capturing == 0 and island.players_capturing == 0 then -- if nobody is capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Captured: "..cap_percent.."%")
						elseif island.ai_capturing == 0 then -- if players are capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Re-Capturing: "..cap_percent.."%")
						else -- if ai is capping the point
							s.setVehicleTooltip(island.flag_vehicle.id, "Losing: "..cap_percent.."%")
						end
					end

					updatePeerIslandMapData(-1, island)

					-- resets amount capping
					island.ai_capturing = 0
					island.players_capturing = 0
					captureIsland(island)
				end
			end
		end

		if render_debug then
			if isTickID(60, 60) then
			
				local ts_x, ts_y, ts_z = m.position(g_savedata.ai_base_island.transform)
				s.removeMapObject(player_debugging_id, g_savedata.ai_base_island.map_id)

				local plane_count = 0
				local heli_count = 0
				local army_count = 0
				local land_count = 0
				local boat_count = 0
				local turret_count = 0
			
				for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
					for vehicle_id, vehicle_object in pairs(squad.vehicles) do
						if vehicle_object.ai_type ~= AI_TYPE_TURRET then army_count = army_count + 1 end
						if vehicle_object.ai_type == AI_TYPE_TURRET then turret_count = turret_count + 1 end
						if vehicle_object.ai_type == AI_TYPE_BOAT then boat_count = boat_count + 1 end
						if vehicle_object.ai_type == AI_TYPE_PLANE then plane_count = plane_count + 1 end
						if vehicle_object.ai_type == AI_TYPE_HELI then heli_count = heli_count + 1 end
						if vehicle_object.ai_type == AI_TYPE_LAND then land_count = land_count + 1 end
					end
				end

				local ai_islands = 1
				for island_index, island in pairs(g_savedata.controllable_islands) do
					if island.faction == FACTION_AI then
						ai_islands = ai_islands + 1
					end
				end

				local t, a = getObjectiveIsland()

				local ai_base_island_turret_count = 0
				for turret_zone_index, turret_zone in pairs(g_savedata.ai_base_island.zones) do
					if turret_zone.is_spawned then ai_base_island_turret_count = ai_base_island_turret_count + 1 end
				end

				local debug_data = ""
				debug_data = debug_data.."--- This Island's Statistics ---\n\n"
				debug_data = debug_data.."Number of Turrets: "..ai_base_island_turret_count.."/"..g_savedata.settings.MAX_TURRET_AMOUNT.."\n"
				debug_data = debug_data.."\n--- Global Statistics ---\n\n"
				debug_data = debug_data .. "Total AI Vehicles: "..army_count.."/"..(g_savedata.settings.MAX_BOAT_AMOUNT + g_savedata.settings.MAX_HELI_AMOUNT + g_savedata.settings.MAX_PLANE_AMOUNT + g_savedata.settings.MAX_LAND_AMOUNT).."\n"
				debug_data = debug_data .. "Total Sea Vehicles: "..boat_count.."/"..g_savedata.settings.MAX_BOAT_AMOUNT.."\n"
				debug_data = debug_data .. "Total Helicopters: "..heli_count.."/"..g_savedata.settings.MAX_HELI_AMOUNT.."\n"
				debug_data = debug_data .. "Total Planes: "..plane_count.."/"..g_savedata.settings.MAX_PLANE_AMOUNT.."\n"
				debug_data = debug_data .. "Total Land Vehicles: "..land_count.."/"..g_savedata.settings.MAX_LAND_AMOUNT.."\n"
				debug_data = debug_data .. "Total Turrets: "..turret_count.."/"..g_savedata.settings.MAX_TURRET_AMOUNT*ai_islands.."\n"
				debug_data = debug_data .. "\nNumber of Squads: "..g_count_squads.."\n"

				if t then
					debug_data = debug_data .. "Attacking: " .. t.name .. "\n"
				end
				if a then
					debug_data = debug_data .. " Attacking From: " .. a.name
				end
				for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
					if is_debugging then
						s.addMapObject(player_id, g_savedata.ai_base_island.map_id, 0, 4, ts_x, ts_z, 0, 0, 0, 0, "Ai Base Island \n" .. g_savedata.ai_base_island.production_timer .. "/" .. g_savedata.settings.AI_PRODUCTION_TIME_BASE, 1, debug_data, 255, 0, 0, 255)

						local ts_x, ts_y, ts_z = m.position(g_savedata.player_base_island.transform)
						s.removeMapObject(player_id, g_savedata.player_base_island.map_id)
						s.addMapObject(player_id, g_savedata.player_base_island.map_id, 0, 4, ts_x, ts_z, 0, 0, 0, 0, "Player Base Island", 1, debug_data, 0, 255, 0, 255)
					end
				end
			end
		end
	end
end


---@param peer_id integer the id of the player of which you want to update the map data for
---@param island island[] the island you want to update
---@param is_reset boolean if you want it to just reset the map, which will remove the island from the map instead of updating it
function updatePeerIslandMapData(peer_id, island, is_reset)
	if is_dlc_weapons then
		local ts_x, ts_y, ts_z = m.position(island.transform)
		s.removeMapObject(peer_id, island.map_id)
		if not is_reset then
			local cap_percent = math.floor((island.capture_timer/g_savedata.settings.CAPTURE_TIME) * 100)
			local extra_title = ""
			local r = 75
			local g = 75
			local b = 75
			if island.is_contested then
				r = 255
				g = 255
				b = 0
				extra_title = " CONTESTED"
			elseif island.faction == FACTION_AI then
				r = 255
				g = 0
				b = 0
			elseif island.faction == FACTION_PLAYER then
				r = 0
				g = 255
				b = 0
			end
			if not g_savedata.playerData.isDebugging[peer_id] then -- checks to see if the player has debug mode disabled
				s.addMapObject(peer_id, island.map_id, 0, 9, ts_x, ts_z, 0, 0, 0, 0, island.name.." ("..island.faction..")"..extra_title, 1, cap_percent.."%", r, g, b, 255)
			else
				if island.transform ~= g_savedata.player_base_island.transform and island.transform ~= g_savedata.ai_base_island.transform then -- makes sure its not trying to update the main islands
					local turret_amount = 0
					for turret_zone_index, turret_zone in pairs(island.zones) do
						if turret_zone.is_spawned then turret_amount = turret_amount + 1 end
					end
					
					local debug_data = ""
					debug_data = debug_data.."\nScout Progress: "..math.floor(g_savedata.ai_knowledge.scout[island.name].scouted/scout_requirement*100).."%"
					debug_data = debug_data.."\n\nNumber of AI Capturing: "..island.ai_capturing
					debug_data = debug_data.."\nNumber of Players Capturing: "..island.players_capturing
					if island.faction == FACTION_AI then 
						debug_data = debug_data.."\n\nNumber of defenders: "..island.defenders.."\n"
						debug_data = debug_data.."Number of Turrets: "..turret_amount.."/"..g_savedata.settings.MAX_TURRET_AMOUNT.."\n"
					end

					s.addMapObject(peer_id, island.map_id, 0, 9, ts_x, ts_z, 0, 0, 0, 0, island.name.." ("..island.faction..")"..extra_title, 1, cap_percent.."%"..debug_data, r, g, b, 255)
				end
			end
		end
	end
end

function getSquadLeader(squad)
	for vehicle_id, vehicle_object in pairs(squad.vehicles) do
		return vehicle_id, vehicle_object
	end
	wpDLCDebug("warning: empty squad "..squad.ai_type.." detected", true, true)
	return nil
end

function getNearbySquad(transform, override_command)

	local closest_free_squad = nil
	local closest_free_squad_index = -1
	local closest_dist = 999999999

	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		if squad.command == COMMAND_NONE
		or squad.command == COMMAND_PATROL
		or override_command then

			local _, squad_leader = getSquadLeader(squad)
			local squad_vehicle_transform = squad_leader.transform
			local distance = m.distance(transform, squad_vehicle_transform)

			if distance < closest_dist then
				closest_free_squad = squad
				closest_free_squad_index = squad_index
				closest_dist = distance
			end
		end
	end

	return closest_free_squad, closest_free_squad_index
end

function tickAI()
	if is_dlc_weapons then

		-- allocate squads to islands
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if isTickID(island_index, 60) then
				if island.faction == FACTION_AI then
					if island.assigned_squad_index == -1 then
						local squad, squad_index = getNearbySquad(island.transform)

						if squad ~= nil then
							setSquadCommandDefend(squad, island)
							island.assigned_squad_index = squad_index
						end
					end
				end
			end
			if isTickID(island_index*15, time.minute/4) then -- every 15 seconds, update the amount of vehicles that are defending the base
				island.defenders = 0
				for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
					if squad.command == COMMAND_DEFEND or squad.command == COMMAND_TURRET then
						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							if island.faction == FACTION_AI then
								if xzDistance(island.transform, vehicle_object.transform) < 1500 then
									island.defenders = island.defenders + 1
								end
							end
						end
					end
				end
			end 
		end

		-- allocate squads to engage or investigate based on vision
		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			if isTickID(squad_index, 60) then			
				if squad_index ~= RESUPPLY_SQUAD_INDEX then
					local squad_vision = squadGetVisionData(squad)
					if squad.command ~= COMMAND_SCOUT then
						if squad.command ~= COMMAND_ENGAGE and squad_vision:is_engage() then
							setSquadCommandEngage(squad)
						elseif squad.command ~= COMMAND_INVESTIGATE and squad_vision:is_investigate() then
							if #squad_vision.investigate_players > 0 then
								local investigate_player = squad_vision:getBestInvestigatePlayer()
								setSquadCommandInvestigate(squad, investigate_player.obj.last_known_pos)
							elseif #squad_vision.investigate_vehicles > 0 then
								local investigate_vehicle = squad_vision:getBestInvestigateVehicle()
								setSquadCommandInvestigate(squad, investigate_vehicle.obj.last_known_pos)
							end
						end
					end
				end
			end
		end

		if isTickID(0, 60) then
			g_count_squads = 0
			g_count_attack = 0
			g_count_patrol = 0

			for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
				if squad_index ~= RESUPPLY_SQUAD_INDEX then
					if squad.command ~= COMMAND_DEFEND and squad.ai_type ~= AI_TYPE_TURRET then
						g_count_squads = g_count_squads + 1
					end
		
					if squad.command == COMMAND_STAGE or squad.command == COMMAND_ATTACK then
						g_count_attack = g_count_attack + 1
					elseif squad.command == COMMAND_PATROL then
						g_count_patrol = g_count_patrol + 1
					end
				end
			end

			local objective_island, ally_island = getObjectiveIsland()

			if objective_island == nil then
				g_savedata.is_attack = false
			else
				if g_savedata.is_attack == false then
					if g_savedata.constructable_vehicles.attack.mod >= 0.1 then -- if its above the threshold in order to attack
						if g_savedata.ai_knowledge.scout[objective_island.name].scouted >= scout_requirement then
							local boats_ready = 0
							local boats_total = 0
							local air_ready = 0
							local air_total = 0
							local land_ready = 0
							local land_total = 0
							objective_island.is_scouting = false

							for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
								if squad.command == COMMAND_STAGE then
									local _, squad_leader = getSquadLeader(squad)
									local squad_leader_transform = squad_leader.transform

									if squad.ai_type == AI_TYPE_BOAT then
										boats_total = boats_total + 1

										local air_dist = m.distance(objective_island.transform, ally_island.transform)
										local dist = m.distance(squad_leader_transform, objective_island.transform)
										local air_sea_speed_factor = AI_SPEED_PSEUDO_BOAT/AI_SPEED_PSEUDO_PLANE

										if dist < air_dist * air_sea_speed_factor then
											boats_ready = boats_ready + 1
										end
									elseif squad.ai_type == AI_TYPE_LAND then
										land_total = land_total + 1

										local air_dist = m.distance(objective_island.transform, ally_island.transform)
										local dist = m.distance(squad_leader_transform, objective_island.transform)
										local air_sea_speed_factor = AI_SPEED_PSEUDO_LAND/AI_SPEED_PSEUDO_PLANE

										if dist < air_dist * air_sea_speed_factor then
											land_ready = land_ready + 1
										end
									else
										air_total = air_total + 1

										local dist = m.distance(squad_leader_transform, ally_island.transform)
										if dist < 2000 then
											air_ready = air_ready + 1
										end
									end
								end
							end
							
							-- add more vehicles if we didn't hit the limit
							if (air_total + boats_total) < MAX_ATTACKING_SQUADS then
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									if squad.command == COMMAND_PATROL or squad.command == COMMAND_DEFEND and squad.ai_type ~= AI_TYPE_TURRET and squad.role ~= "defend" then
										if (air_total + boats_total) < MAX_ATTACKING_SQUADS then
											if squad.ai_type == AI_TYPE_BOAT then
												if not hasTag(objective_island.tags, "no-access=boat") and not hasTag(ally_island.tags, "no-access=boat") then
													boats_total = boats_total + 1
													setSquadCommandStage(squad, objective_island)
												end
											else
												air_total = air_total + 1
												setSquadCommandStage(squad, ally_island)
											end
										end
									end
								end
							end
							
				
							g_is_air_ready = air_total == 0 or air_ready / air_total >= 0.5
							g_is_boats_ready = hasTag(ally_island.tags, "no-access=boat") or hasTag(objective_island.tags, "no-access=boat") or boats_total == 0 or boats_ready / boats_total >= 0.25
							local is_attack = (g_count_attack / g_count_squads) >= 0.25 and g_count_attack >= MIN_ATTACKING_SQUADS and g_is_boats_ready and g_is_air_ready
							
							if is_attack then
								g_savedata.is_attack = is_attack
				
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									if squad.command == COMMAND_STAGE then
										if not hasTag(objective_island.tags, "no-access=boat") and squad.ai_type == AI_TYPE_BOAT or squad.ai_type ~= AI_TYPE_BOAT then -- makes sure boats can attack that island
											setSquadCommandAttack(squad, objective_island)
										end
									elseif squad.command == COMMAND_ATTACK then
										if squad.target_island.faction == FACTION_AI then
											-- if they are targeting their own island
											squad.target_island = objective_island
										end
									end
								end
							else
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									if squad.command == COMMAND_NONE and squad.ai_type ~= AI_TYPE_TURRET and (air_total + boats_total) < MAX_ATTACKING_SQUADS then
										if squad.ai_type == AI_TYPE_BOAT then -- send boats ahead since they are slow
											if not hasTag(objective_island.tags, "no-access=boat") then -- if boats can attack that island
												setSquadCommandStage(squad, objective_island)
												boats_total = boats_total + 1
											end
										else
											setSquadCommandStage(squad, ally_island)
											air_total = air_total + 1
										end
									elseif squad.command == COMMAND_STAGE and squad.ai_type == AI_TYPE_BOAT and not hasTag(objective_island.tags, "no-access=boat") and (air_total + boats_total) < MAX_ATTACKING_SQUADS then
										setSquadCommandStage(squad, objective_island)
										squad.target_island = objective_island
									end
								end
							end
						else -- if they've yet to fully scout the base
							local scout_exists = false
							local not_scouting = false
							local squad_to_set = nil
							if not objective_island.is_scouting then
								for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
									for vehicle_index, vehicle in pairs(squad.vehicles) do
										if vehicle.role == "scout" then
											scout_exists = true
											if squad.command ~= COMMAND_SCOUT then not_scouting = true; squad_to_set = squad_index end
										end
									end
								end
								if not scout_exists then -- if a scout vehicle does not exist
									-- then we want to spawn one, unless its been less than 30 minutes since it was killed
									if g_savedata.ai_history.scout_death == -1 or g_savedata.ai_history.scout_death ~= 0 and g_savedata.tick_counter - g_savedata.ai_history.scout_death <= time.hour / 2 then
										wpDLCDebug("attempting to spawn scout vehicle...", true, false)
										local spawned = spawnAIVehicle("scout")
										if spawned then
											if g_savedata.ai_history.scout_death == -1 then
												g_savedata.ai_history.scout_death = 0
											end
											wpDLCDebug("scout vehicle spawned!", true, false)
											objective_island.is_scouting = true
											for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
												if squad.command == COMMAND_SCOUT then
													setSquadCommandScout(squad)
												end
											end
										else
											wpDLCDebug("Failed to spawn scout vehicle!", true, true)
										end
									end
								elseif not_scouting and squad_to_set then -- if the scout was just set to a different command
									-- then we want to set it back to scouting
									setSquadCommandScout(g_savedata.ai_army.squadrons[squad_to_set])
								end
							end
						end
					else -- if they've not hit the threshold to attack
						if objective_island.is_scouting then -- if theres still a scout plane scouting the island
							for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
								if squad.command == COMMAND_SCOUT then
									squad.target_island = ally_island
									setSquadCommand(squad, COMMAND_DEFEND)
									objective_island.is_scouting = false
								end
							end
						end
					end
				else
					local is_disengage = (g_count_attack / g_count_squads) < 0.25
		
					if is_disengage then
						g_savedata.is_attack = false
		
						for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
							if squad.command == COMMAND_ATTACK then
								if squad.ai_type == AI_TYPE_BOAT and not hasTag(objective_island.tags, "no-access=boat") and not hasTag(ally_island.tags, "no-access=boat") or squad.ai_type ~= AI_TYPE_BOAT then
									setSquadCommandStage(squad, ally_island)
								end
							end
						end
					end
				end
			end

			-- assign squads to patrol
			local allied_islands = getAlliedIslands()

			for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
				if squad.command == COMMAND_NONE then
					if #allied_islands > 0 then
						if (g_count_patrol / g_count_squads) < 0.5 then
							g_count_patrol = g_count_patrol + 1
							setSquadCommandPatrol(squad, allied_islands[math.random(1, #allied_islands)])
						else
							setSquadCommandDefend(squad, allied_islands[math.random(1, #allied_islands)])
						end
					else
						setSquadCommandPatrol(squad, g_savedata.ai_base_island)
					end
				end
			end
		end
	end
end

function getAlliedIslands()
	local alliedIslandIndexes = {}
	for island_index, island in pairs(g_savedata.controllable_islands) do
		if island.faction == FACTION_AI then
			table.insert(alliedIslandIndexes, island)
		end
	end
	return alliedIslandIndexes
end

---@param ignore_scouted boolean true if you want to ignore islands that are already fully scouted
---@return table target_island returns the island which the ai should target
---@return table origin_island returns the island which the ai should attack from
function getObjectiveIsland(ignore_scouted)
	local origin_island = nil
	local target_island = nil
	local target_best_distance = nil
	for island_index, island in pairs(g_savedata.controllable_islands) do
		if island.faction ~= FACTION_AI then
			for ai_island_index, ai_island in pairs(g_savedata.controllable_islands) do
				if ai_island.faction == FACTION_AI or ignore_scouted and g_savedata.ai_knowledge.scout[island.name].scouted >= scout_requirement then
					if not ignore_scouted or g_savedata.ai_knowledge.scout[island.name].scouted < scout_requirement then
						if not target_island then
							origin_island = ai_island
							target_island = island
							if island.faction == FACTION_PLAYER then
								target_best_distance = xzDistance(ai_island.transform, island.transform)/1.5
							else
								target_best_distance = xzDistance(ai_island.transform, island.transform)
							end
						elseif island.faction == FACTION_PLAYER then -- if the player owns the island we are checking
							if target_island.faction == FACTION_PLAYER and xzDistance(ai_island.transform, island.transform) < target_best_distance then -- if the player also owned the island that we detected was the best to attack
								origin_island = ai_island
								target_island = island
								target_best_distance = xzDistance(ai_island.transform, island.transform)
							elseif target_island.faction ~= FACTION_PLAYER and xzDistance(ai_island.transform, island.transform)/1.5 < target_best_distance then -- if the player does not own the best match for an attack target so far
								origin_island = ai_island
								target_island = island
								target_best_distance = xzDistance(ai_island.transform, island.transform)/1.5
							end
						elseif island.faction ~= FACTION_PLAYER and xzDistance(ai_island.transform, island.transform) < target_best_distance then -- if the player does not own the island we are checking
							origin_island = ai_island
							target_island = island
							target_best_distance = xzDistance(ai_island.transform, island.transform)
						end
					end
				end
			end
		end
	end
	if not target_island then
		origin_island = g_savedata.ai_base_island
		for island_index, island in pairs(g_savedata.controllable_islands) do
			if island.faction ~= FACTION_AI or ignore_scouted and g_savedata.ai_knowledge.scout[island.name].scouted >= scout_requirement then
				if not ignore_scouted or g_savedata.ai_knowledge.scout[island.name].scouted < scout_requirement then
					if not target_island then
						target_island = island
						if island.faction == FACTION_PLAYER then
							target_best_distance = xzDistance(origin_island.transform, island.transform)/1.5
						else
							target_best_distance = xzDistance(origin_island.transform, island.transform)
						end
					elseif island.faction == FACTION_PLAYER then
						if target_island.faction == FACTION_PLAYER and xzDistance(origin_island.transform, island.transform) < target_best_distance then -- if the player also owned the island that we detected was the best to attack
							target_island = island
							target_best_distance = xzDistance(origin_island.transform, island.transform)
						elseif target_island.faction ~= FACTION_PLAYER and xzDistance(origin_island.transform, island.transform)/1.5 < target_best_distance then -- if the player does not own the best match for an attack target so far
							target_island = island
							target_best_distance = xzDistance(origin_island.transform, island.transform)/1.5
						end
					elseif island.faction ~= FACTION_PLAYER and xzDistance(origin_island.transform, island.transform) < target_best_distance then -- if the player does not own the island we are checking
						target_island = island
						target_best_distance = xzDistance(origin_island.transform, island.transform)
					end
				end
			end
		end
	end
	return target_island, origin_island
end

function getResupplyIsland(ai_vehicle_transform)
	local closest = g_savedata.ai_base_island
	local closest_dist = m.distance(ai_vehicle_transform, g_savedata.ai_base_island.transform)

	for island_index, island in pairs(g_savedata.controllable_islands) do
		if island.faction == FACTION_AI then
			local distance = m.distance(ai_vehicle_transform, island.transform)

			if distance < closest_dist then
				closest = island
				closest_dist = distance
			end
		end
	end

	return closest
end

function addToSquadron(vehicle_object)
	local new_squad = nil

	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		if squad_index ~= RESUPPLY_SQUAD_INDEX then -- do not automatically add to resupply squadron
			if squad.ai_type == vehicle_object.ai_type then
				local _, squad_leader = getSquadLeader(squad)
				if squad.ai_type ~= AI_TYPE_TURRET or vehicle_object.home_island == squad_leader.home_island then
					if vehicle_object.role ~= "scout" and squad.ai_type ~= "scout" then
						if tableLength(squad.vehicles) < MAX_SQUAD_SIZE then
							squad.vehicles[vehicle_object.id] = vehicle_object
							new_squad = squad
							break
						end
					end
				end
			end
		end
	end

	if new_squad == nil then
		new_squad = { 
			command = COMMAND_NONE, 
			ai_type = vehicle_object.ai_type, 
			role = vehicle_object.role,
			vehicles = {}, 
			target_island = nil,
			target_players = {},
			target_vehicles = {},
			investigate_transform = nil,
		}

		new_squad.vehicles[vehicle_object.id] = vehicle_object
		table.insert(g_savedata.ai_army.squadrons, new_squad)
	end

	squadInitVehicleCommand(new_squad, vehicle_object)
	return new_squad
end

function killVehicle(squad_index, vehicle_id, instant, delete)

	local vehicle_object = g_savedata.ai_army.squadrons[squad_index].vehicles[vehicle_id]

	if vehicle_object.is_killed ~= true or instant then
		wpDLCDebug(vehicle_id.." from squad "..squad_index.." is out of action", true, false)
		vehicle_object.is_killed = true
		vehicle_object.death_timer = 0

		-- change ai spawning modifiers
		if not delete then -- if the vehicle was not forcefully despawned
			local ai_damaged = vehicle_object.current_damage or 0
			local ai_damage_dealt = 1
			for vehicle_id, damage in pairs(vehicle_object.damage_dealt) do
				ai_damage_dealt = ai_damage_dealt + damage
			end

			local constructable_vehicle_id = sm.getConstructableVehicleID(vehicle_object.role, vehicle_object.ai_type, vehicle_object.strategy, sm.getVehicleListID(vehicle_object.name))

			wpDLCDebug("ai damage taken: "..ai_damaged.." ai damage dealt: "..ai_damage_dealt, true, false)
			if vehicle_object.role ~= "scout" then -- makes sure the vehicle isnt a scout vehicle
				if ai_damaged * 0.3333 < ai_damage_dealt then -- if the ai did more damage than the damage it took / 3
					local ai_reward_ratio = ai_damage_dealt//(ai_damaged * 0.3333)
					sm.train(
						REWARD, 
						vehicle_role, math.clamp(ai_reward_ratio, 1, 2),
						vehicle_object.ai_type, math.clamp(ai_reward_ratio, 1, 3), 
						vehicle_object.strategy, math.clamp(ai_reward_ratio, 1, 2), 
						constructable_vehicle_id, math.clamp(ai_reward_ratio, 1, 3)
					)
				else -- if the ai did less damage than the damage it took / 3
					local ai_punish_ratio = (ai_damaged * 0.3333)//ai_damage_dealt
					sm.train(
						PUNISH, 
						vehicle_role, math.clamp(ai_punish_ratio, 1, 2),
						vehicle_object.ai_type, math.clamp(ai_punish_ratio, 1, 3),
						vehicle_object.strategy, math.clamp(ai_punish_ratio, 1, 2),
						constructable_vehicle_id, math.clamp(ai_punish_ratio, 1, 3)
					)
				end
			else -- if it is a scout vehicle, we instead want to reset its progress on whatever island it was on
				target_island, origin_island = getObjectiveIsland(true)
				if target_island then
					g_savedata.ai_knowledge.scout[target_island.name].scouted = 0
					target_island.is_scouting = false
					g_savedata.ai_history.scout_death = g_savedata.tick_counter -- saves that the scout vehicle just died, after 30 minutes it should spawn another scout plane
				end
			end
		end

		if not instant and delete ~= true then
			local fire_id = vehicle_object.fire_id
			if fire_id ~= nil then
				wpDLCDebug("explosion fire enabled", true, false)
				s.setFireData(fire_id, true, true)
			end
		end

		s.despawnVehicle(vehicle_id, instant)

		for _, survivor in pairs(vehicle_object.survivors) do
			s.despawnObject(survivor.id, instant)
		end

		if vehicle_object.fire_id ~= nil then
			s.despawnObject(vehicle_object.fire_id, instant)
		end

		if instant == true and delete ~= true then
			local explosion_size = 2
			if vehicle_object.size == "small" then
				explosion_size = 0.5
			elseif vehicle_object.size == "medium" then
				explosion_size = 1
			end

			wpDLCDebug("explosion spawned", true, false)

			s.spawnExplosion(vehicle_object.transform, explosion_size)
		end
	end
end

function tickSquadrons()
	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		if isTickID(squad_index, 60) then
			-- clean out-of-action vehicles
			for vehicle_id, vehicle_object in pairs(squad.vehicles) do

				if vehicle_object.is_killed and vehicle_object.death_timer ~= nil then
					vehicle_object.death_timer = vehicle_object.death_timer + 1
					if vehicle_object.death_timer >= 300 then
						killVehicle(squad_index, vehicle_id, true)
					end
				end

				-- if pilot is incapacitated
				local c = s.getCharacterData(vehicle_object.survivors[1].id)
				if c ~= nil then
					if c.incapacitated or c.dead then
						killVehicle(squad_index, vehicle_id, false)
					end
				end
			end

			-- check if a vehicle needs resupply, removing from current squad and adding to the resupply squad
			if squad_index ~= RESUPPLY_SQUAD_INDEX then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if isVehicleNeedsResupply(vehicle_id, "Resupply") then
						if vehicle_object.ai_type == AI_TYPE_TURRET then
							reload(vehicle_id)
						else
							g_savedata.ai_army.squadrons[RESUPPLY_SQUAD_INDEX].vehicles[vehicle_id] = g_savedata.ai_army.squadrons[squad_index].vehicles[vehicle_id]
							g_savedata.ai_army.squadrons[squad_index].vehicles[vehicle_id] = nil

							wpDLCDebug(vehicle_id.." leaving squad "..squad_index.." to resupply", true, false)

							if tableLength(g_savedata.ai_army.squadrons[squad_index].vehicles) <= 0 then -- squad has no more vehicles
								g_savedata.ai_army.squadrons[squad_index] = nil
	
								for island_index, island in pairs(g_savedata.controllable_islands) do
									if island.assigned_squad_index == squad_index then
										island.assigned_squad_index = -1
									end
								end
							end

							squadInitVehicleCommand(squad, vehicle_object)
						end
					elseif isVehicleNeedsResupply(vehicle_id, "AI_NO_MORE_MISSILE") then -- if its out of missiles, then kill it
						if not vehicle_object.is_killed then
							killVehicle(squad_index, vehicle_id, false, false)
						end
					end
					-- check if the vehicle simply needs to reload a machine gun
					local mg_info = isVehicleNeedsReloadMG(vehicle_id)
					if mg_info[1] and mg_info[2] ~= 0 then
						local i = 1
						local successed = false
						local ammoData = {}
						repeat
							local ammo, success = s.getVehicleWeapon(vehicle_id, "Ammo "..mg_info[2].." - "..i)
							if success then
								if ammo.ammo > 0 then
									successed = success
									ammoData[i] = ammo
								end
							end
							i = i + 1
						until (not success)
						if successed then
							s.setVehicleWeapon(vehicle_id, "Ammo "..mg_info[2].." - "..#ammoData, 0)
							s.setVehicleWeapon(vehicle_id, "Ammo "..mg_info[2], ammoData[#ammoData].capacity)
						end
					end
				end
			else
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if (vehicle_object.state.is_simulating and isVehicleNeedsResupply(vehicle_id, "Resupply") == false) or (vehicle_object.state.is_simulating == false and vehicle_object.is_resupply_on_load) then
	
						-- add to new squad
						g_savedata.ai_army.squadrons[RESUPPLY_SQUAD_INDEX].vehicles[vehicle_id] = nil
						addToSquadron(vehicle_object)

						wpDLCDebug(vehicle_id.." resupplied. joining squad", true, false)
					end
				end
			end

			-- tick behaivour / exit conditions
			if squad.command == COMMAND_PATROL then
				local squad_leader_id, squad_leader = getSquadLeader(squad)
				if squad_leader ~= nil then
					if squad_leader.state.s ~= VEHICLE_STATE_PATHING then -- has finished patrol
						setSquadCommand(squad, COMMAND_NONE)
					end
				else
					wpDLCDebug("patrol squad missing leader", true, false)
					setSquadCommand(squad, COMMAND_NONE)
				end
			elseif squad.command == COMMAND_STAGE then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if vehicle_object.ai_type == AI_TYPE_BOAT and vehicle_object.state.s == VEHICLE_STATE_HOLDING then
						squadInitVehicleCommand(squad, vehicle_object)
					end
				end
			elseif squad.command == COMMAND_ATTACK then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if vehicle_object.ai_type == AI_TYPE_BOAT and vehicle_object.state.s == VEHICLE_STATE_HOLDING then
						squadInitVehicleCommand(squad, vehicle_object)
					end
				end
			elseif squad.command == COMMAND_DEFEND then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if vehicle_object.ai_type == AI_TYPE_BOAT and vehicle_object.state.s == VEHICLE_STATE_HOLDING then
						squadInitVehicleCommand(squad, vehicle_object)
					end
				end

				if squad.target_island == nil then
					setSquadCommand(squad, COMMAND_NONE)
				elseif squad.target_island.faction ~= FACTION_AI then
					setSquadCommand(squad, COMMAND_NONE)
				end
			elseif squad.command == COMMAND_RESUPPLY then

				g_savedata.ai_army.squadrons[RESUPPLY_SQUAD_INDEX].target_island = nil
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if #vehicle_object.path == 0 then
						wpDLCDebug("resupply mission recalculating target island for: "..vehicle_id, true, false)
						local ally_island = getResupplyIsland(vehicle_object.transform)
						resetPath(vehicle_object)
						wpDLCDebugVehicle(vehicle_id, "(vehicle resupplying) Vehicle: "..vehicle_id.." is resupplying! path reset!", true, false)
						addPath(vehicle_object, m.multiply(ally_island.transform, m.translation(math.random(-250, 250), CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), math.random(-250, 250))))
					end
					
					if m.distance(g_savedata.ai_base_island.transform, vehicle_object.transform) < RESUPPLY_RADIUS then

						if vehicle_object.state.is_simulating then
							-- resupply ammo
							reload(vehicle_id)
						else
							s.resetVehicleState(vehicle_id)
							vehicle_object.is_resupply_on_load = true
						end
					end

					for island_index, island in pairs(g_savedata.controllable_islands) do
						if island.faction == FACTION_AI then
							if m.distance(island.transform, vehicle_object.transform) < CAPTURE_RADIUS then

								if vehicle_object.state.is_simulating then
									-- resupply ammo
									reload(vehicle_id)
								else
									s.resetVehicleState(vehicle_id)
									vehicle_object.is_resupply_on_load = true
								end
							end
						end
					end
				end

			elseif squad.command == COMMAND_INVESTIGATE then
				-- head to search area

				if squad.investigate_transform then
					local is_all_vehicles_at_search_area = true

					for vehicle_id, vehicle_object in pairs(squad.vehicles) do
						if vehicle_object.state.s ~= VEHICLE_STATE_HOLDING then
							is_all_vehicles_at_search_area = false
						end
					end

					if is_all_vehicles_at_search_area then
						squad.investigate_transform = nil
					end
				else
					setSquadCommand(squad, COMMAND_NONE)
				end
			elseif squad.command == COMMAND_ENGAGE then
				local squad_vision = squadGetVisionData(squad)
				local player_counts = {}
				local vehicle_counts = {}
				local function incrementCount(t, index) t[index] = t[index] and t[index] + 1 or 1 end
				local function decrementCount(t, index) t[index] = t[index] and t[index] - 1 or 0 end
				local function getCount(t, index) return t[index] or 0 end

				local function retargetVehicle(vehicle_object, target_player_id, target_vehicle_id)
					-- decrement previous target count
					if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 then decrementCount(player_counts, vehicle_object.target_player_id)
					elseif vehicle_object.target_vehicle_id ~= -1 then decrementCount(vehicle_counts, vehicle_object.target_vehicle_id) end

					vehicle_object.target_player_id = target_player_id
					vehicle_object.target_vehicle_id = target_vehicle_id

					-- increment new target count
					if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 then incrementCount(player_counts, vehicle_object.target_player_id)
					elseif vehicle_object.target_vehicle_id ~= -1 then incrementCount(vehicle_counts, vehicle_object.target_vehicle_id) end
				end

				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					-- check existing target is still visible

					if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 and squad_vision:isPlayerVisible(vehicle_object.target_player_id) == false then
						vehicle_object.target_player_id = -1
					elseif vehicle_object.target_vehicle_id ~= -1 and squad_vision:isVehicleVisible(vehicle_object.target_vehicle_id) == false then
						vehicle_object.target_vehicle_id = -1
					end

					-- find targets if not targeting anything

					if (vehicle_object.target_player_id == -1 or vehicle_object.target_player_id == 65535) and vehicle_object.target_vehicle_id == -1 then
						if #squad_vision.visible_players > 0 then
							vehicle_object.target_player_id = squad_vision:getBestTargetPlayerID()
							incrementCount(player_counts, vehicle_object.target_player_id)
						elseif #squad_vision.visible_vehicles > 0 then
							vehicle_object.target_vehicle_id = squad_vision:getBestTargetVehicleID()
							incrementCount(vehicle_counts, vehicle_object.target_vehicle_id)
						end
					else
						if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 then
							incrementCount(player_counts, vehicle_object.target_player_id)
						elseif vehicle_object.target_vehicle_id ~= -1 then
							incrementCount(vehicle_counts, vehicle_object.target_vehicle_id)
						end
					end
				end

				local squad_vehicle_count = #squad.vehicles
				local visible_target_count = #squad_vision.visible_players + #squad_vision.visible_vehicles
				local vehicles_per_target = math.max(math.floor(squad_vehicle_count / visible_target_count), 1)

				local function isRetarget(target_player_id, target_vehicle_id)
					return ((target_player_id == -1 or target_player_id == 65535) and target_vehicle_id == -1) 
						or ((target_player_id ~= -1 and target_player_id ~= 65535) and getCount(player_counts, target_player_id) > vehicles_per_target)
						or (target_vehicle_id ~= -1 and getCount(vehicle_counts, target_vehicle_id) > vehicles_per_target)
				end

				-- find vehicles to retarget to visible players

				for visible_player_id, visible_player in pairs(squad_vision.visible_players_map) do
					if getCount(player_counts, visible_player_id) < vehicles_per_target then
						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							if isRetarget(vehicle_object.target_player_id, vehicle_object.target_vehicle_id) then
								retargetVehicle(vehicle_object, visible_player_id, -1)
								break
							end
						end
					end
				end

				-- find vehicles to retarget to visible vehicles

				for visible_vehicle_id, visible_vehicle in pairs(squad_vision.visible_vehicles_map) do
					if getCount(vehicle_counts, visible_vehicle_id) < vehicles_per_target then
						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							if isRetarget(vehicle_object.target_player_id, vehicle_object.target_vehicle_id) then
								retargetVehicle(vehicle_object, -1, visible_vehicle_id)
								break
							end
						end
					end
				end

				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					-- update waypoint and target data

					if vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 then
						local target_player_id = vehicle_object.target_player_id
						local target_player_data = squad_vision.visible_players_map[target_player_id]
						local target_player = target_player_data.obj
						local target_x, target_y, target_z = m.position(target_player.last_known_pos)
						local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)
						

						if #vehicle_object.path <= 1 then
							resetPath(vehicle_object)

							if vehicle_object.ai_type == AI_TYPE_PLANE then

								if xzDistance(target_player.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) > 700 then
									addPath(vehicle_object, m.multiply(target_player.last_known_pos, m.translation(target_player.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 75), target_player.last_known_pos)))
									vehicle_object.is_strafing = true
								elseif xzDistance(target_player.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) > 150 and vehicle_object.is_strafing ~= true then
									addPath(vehicle_object, m.multiply(target_player.last_known_pos, m.translation(target_player.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 75, 200), target_player.last_known_pos)))
								elseif xzDistance(target_player.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) < 250 then
									addPath(vehicle_object, m.multiply(target_player.last_known_pos, m.translation(target_player.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 15, 50), target_player.last_known_pos)))
									vehicle_object.is_strafing = false
								else
									addPath(vehicle_object, m.multiply(target_player.last_known_pos, m.translation(target_player.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 75), target_player.last_known_pos))) 
								end
							elseif vehicle_object.ai_type ~= AI_TYPE_LAND then
								addPath(vehicle_object, m.multiply(target_player.last_known_pos, m.translation(target_player.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 75), target_player.last_known_pos)))
							end
						end

						for i, char in pairs(vehicle_object.survivors) do
							s.setAITargetCharacter(char.id, vehicle_object.target_player_id)

							if i ~= 1 or vehicle_object.ai_type == AI_TYPE_TURRET then
								s.setAIState(char.id, 1)
							end
						end
					elseif vehicle_object.target_vehicle_id ~= -1 then
						local target_vehicle = squad_vision.visible_vehicles_map[vehicle_object.target_vehicle_id].obj
						local target_x, target_y, target_z = m.position(target_vehicle.last_known_pos)
						local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)

						
						if #vehicle_object.path <= 1 then
							resetPath(vehicle_object)
							if vehicle_object.type == AI_TYPE_PLANE then
								if m.distance(target_vehicle.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) > 700 then
									addPath(vehicle_object, m.multiply(target_vehicle.last_known_pos, m.translation(target_vehicle.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 50), target_vehicle.last_known_pos)))
									vehicle_object.is_strafing = true
								elseif m.distance(target_vehicle.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) > 150 and vehicle_object.is_strafing ~= true then
									addPath(vehicle_object, m.multiply(target_vehicle.last_known_pos, m.translation(target_vehicle.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 75, 100), target_vehicle.last_known_pos)))
								elseif m.distance(target_vehicle.last_known_pos, vehicle_object.transform) - math.abs(target_y - vehicle_y) < 250 then
									addPath(vehicle_object, m.multiply(target_vehicle.last_known_pos, m.translation(target_vehicle.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 15, 25), target_vehicle.last_known_pos)))
									vehicle_object.is_strafing = false
								else
									addPath(vehicle_object, m.multiply(target_vehicle.last_known_pos, m.translation(target_vehicle.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 50), target_vehicle.last_known_pos)))
								end
							elseif vehicle_object.ai_type ~= AI_TYPE_LAND then
								addPath(vehicle_object, m.multiply(target_vehicle.last_known_pos, m.translation(target_vehicle.last_known_pos, target_y + math.max(target_y + (vehicle_object.id % 5) + 25, 50), target_vehicle.last_known_pos)))
							end
						end
						for i, char in pairs(vehicle_object.survivors) do
							s.setAITargetVehicle(char.id, vehicle_object.target_vehicle_id)

							if i ~= 1 or vehicle_object.ai_type == AI_TYPE_TURRET then
								s.setAIState(char.id, 1)
							end
						end
					end
				end

				if squad_vision:is_engage() == false then
					setSquadCommand(squad, COMMAND_NONE)
				end
			end
			if squad.command ~= COMMAND_RETREAT then
				for vehicle_id, vehicle_object in pairs(squad.vehicles) do
					if (vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535) or vehicle_object.target_vehicle_id ~= -1 then
						if vehicle_object.capabilities.gps_missiles then setKeypadTargetCoords(vehicle_id, vehicle_object, squad) end
					end
				end
			end
		end
	end
end

function tickVision()

	-- get the ai's vision radius
	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if isTickID(vehicle_id, 240) then
				local vehicle_transform = vehicle_object.transform
				local weather = s.getWeather(vehicle_transform)
				local clock = s.getTime()
				if vehicle_object.vision.is_radar then
					vehicle_object.vision.radius = vehicle_object.vision.base_radius * (1 - (weather.fog * 0.2)) * (0.6 + (clock.daylight_factor * 0.2)) * (1 - (weather.rain * 0.2))
				else
					vehicle_object.vision.radius = vehicle_object.vision.base_radius * (1 - (weather.fog * 0.6)) * (0.2 + (clock.daylight_factor * 0.6)) * (1 - (weather.rain * 0.6))
				end
			end
		end
	end

	-- analyse player vehicles
	for player_vehicle_id, player_vehicle in pairs(g_savedata.player_vehicles) do
		if isTickID(player_vehicle_id, 30) then
			local player_vehicle_transform = player_vehicle.transform

			for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
				if squad_index ~= RESUPPLY_SQUAD_INDEX then
					-- reset target visibility state to investigate

					if squad.target_vehicles[player_vehicle_id] ~= nil then
						if player_vehicle.death_pos == nil then
							squad.target_vehicles[player_vehicle_id].state = TARGET_VISIBILITY_INVESTIGATE
						else
							squad.target_vehicles[player_vehicle_id] = nil
						end
					end

					-- check if target is visible to any vehicles
					for vehicle_id, vehicle_object in pairs(squad.vehicles) do
						local vehicle_transform = vehicle_object.transform

						if vehicle_transform ~= nil and player_vehicle_transform ~= nil then
							local distance = m.distance(player_vehicle_transform, vehicle_transform)

							local local_vision_radius = vehicle_object.vision.radius

							if not vehicle_object.vision.is_sonar and player_vehicle_transform[14] < -1 then
								-- if the player is in the water, and the player is below y -1, then reduce the player's sight level depending on the player's depth
								local_vision_radius = local_vision_radius * math.min(0.15 / (math.abs(player_vehicle_transform[14]) * 0.2), 0.15)
							end
							
							if distance < local_vision_radius and player_vehicle.death_pos == nil then
								if squad.target_vehicles[player_vehicle_id] == nil then
									squad.target_vehicles[player_vehicle_id] = {
										state = TARGET_VISIBILITY_VISIBLE,
										last_known_pos = player_vehicle_transform,
									}
								else
									local target_vehicle = squad.target_vehicles[player_vehicle_id]
									target_vehicle.state = TARGET_VISIBILITY_VISIBLE
									target_vehicle.last_known_pos = player_vehicle_transform
								end

								break
							end
						end
					end
				end
			end

			if player_vehicle.death_pos ~= nil then
				if m.distance(player_vehicle.death_pos, player_vehicle_transform) > 500 then
					local player_vehicle_data = s.getVehicleData(player_vehicle_id)
					player_vehicle.death_pos = nil
					player_vehicle.damage_threshold = player_vehicle.damage_threshold + player_vehicle_data.voxels / 10
				end
			end

			if render_debug then
				local debug_data = ""

				debug_data = debug_data .. "\ndamage: " .. player_vehicle.current_damage
				debug_data = debug_data .. "\nthreshold: " .. player_vehicle.damage_threshold

				if recent_spotter ~= nil then debug_data = debug_data .. "\nspotter: " .. player_vehicle.recent_spotter end
				if last_known_pos ~= nil then debug_data = debug_data .. "last_known_pos: " end
				if death_pos ~= nil then debug_data = debug_data .. "death_pos: " end
				for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
					if is_debugging then
						s.removeMapObject(player_id, player_vehicle.map_id)
						s.addMapObject(player_id, player_vehicle.map_id, 1, 4, 0, 150, 0, 150, player_vehicle_id, 0, "Tracked Vehicle: " .. player_vehicle_id, 1, debug_data, 0, 0, 255, 255)
					end
				end
			end
		end
	end

	-- analyse players
	local playerList = s.getPlayers()
	for player_id, player in pairs(playerList) do
		if isTickID(player_id, 30) then
			if player.object_id then
				local player_transform = s.getPlayerPos(player.id)
				
				for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
					if squad_index ~= RESUPPLY_SQUAD_INDEX then
						-- reset target visibility state to investigate

						if squad.target_players[player.object_id] ~= nil then
							squad.target_players[player.object_id].state = TARGET_VISIBILITY_INVESTIGATE
						end

						-- check if target is visible to any vehicles

						for vehicle_id, vehicle_object in pairs(squad.vehicles) do
							local vehicle_transform = vehicle_object.transform
							local distance = m.distance(player_transform, vehicle_transform)

							if distance < vehicle_object.vision.radius then
								g_savedata.ai_knowledge.last_seen_positions[player.steam_id] = player_transform
								if squad.target_players[player.object_id] == nil then
									squad.target_players[player.object_id] = {
										state = TARGET_VISIBILITY_VISIBLE,
										last_known_pos = player_transform,
									}
								else
									local target_player = squad.target_players[player.object_id]
									target_player.state = TARGET_VISIBILITY_VISIBLE
									target_player.last_known_pos = player_transform
								end
								
								break
							end
						end
					end
				end
			end
		end
	end
end

function tickVehicles()
	local vehicle_update_tickrate = 30
	if isTickID(0, 60) then
		debug_mode_blinker = not debug_mode_blinker
	end

	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if isTickID(vehicle_id, vehicle_update_tickrate) then

				-- scout vehicles
				if vehicle_object.role == "scout" then
					local target_island, origin_island = getObjectiveIsland(true)
					if target_island then -- makes sure there is a target island
						if g_savedata.ai_knowledge.scout[target_island.name].scouted < scout_requirement then
							if #vehicle_object.path == 0 then -- if its finishing circling the island
								setSquadCommandScout(squad)
							end
							local attack_target_island, attack_origin_island = getObjectiveIsland()
							if xzDistance(vehicle_object.transform, target_island.transform) <= vehicle_object.vision.radius then
								if attack_target_island.name == target_island.name then -- if the scout is scouting the island that the ai wants to attack
									-- scout it normally
									if target_island.faction == FACTION_NEUTRAL then
										g_savedata.ai_knowledge.scout[target_island.name].scouted = math.clamp(g_savedata.ai_knowledge.scout[target_island.name].scouted + vehicle_update_tickrate * 4, 0, scout_requirement)
									else
										g_savedata.ai_knowledge.scout[target_island.name].scouted = math.clamp(g_savedata.ai_knowledge.scout[target_island.name].scouted + vehicle_update_tickrate, 0, scout_requirement)
									end
								else -- if the scout is scouting an island that the ai is not ready to attack
									-- scout it 4x slower
									if target_island.faction == FACTION_NEUTRAL then
										g_savedata.ai_knowledge.scout[target_island.name].scouted = math.clamp(g_savedata.ai_knowledge.scout[target_island.name].scouted + vehicle_update_tickrate, 0, scout_requirement)
									else
										g_savedata.ai_knowledge.scout[target_island.name].scouted = math.clamp(g_savedata.ai_knowledge.scout[target_island.name].scouted + vehicle_update_tickrate / 4, 0, scout_requirement)
									end
								end
							end
						end
					else
						setSquadCommandDefend(squad, g_savedata.ai_base_island)
					end
				end

				local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)
				if vehicle_y <= BOAT_EXPLOSION_DEPTH and vehicle_object.ai_type == AI_TYPE_BOAT or vehicle_y <= HELI_EXPLOSION_DEPTH and vehicle_object.ai_type == AI_TYPE_HELI or vehicle_y <= PLANE_EXPLOSION_DEPTH and vehicle_object.ai_type == AI_TYPE_PLANE then
					killVehicle(squad_index, vehicle_id, true)
				end
				local ai_target = nil
				if ai_state ~= 2 then ai_state = 1 end
				local ai_speed_pseudo = (vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_BOAT) * vehicle_update_tickrate / 60

				if(vehicle_object.ai_type ~= AI_TYPE_TURRET) then

					if vehicle_object.state.s == VEHICLE_STATE_PATHING then

						if vehicle_object.ai_type == AI_TYPE_PLANE then
							ai_speed_pseudo = (vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_PLANE) * vehicle_update_tickrate / 60
						elseif vehicle_object.ai_type == AI_TYPE_HELI then
							ai_speed_pseudo = (vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_HELI) * vehicle_update_tickrate / 60
						elseif vehicle_object.ai_type == AI_TYPE_LAND then
							vehicle_object.terrain_type = "offroad"
							vehicle_object.is_aggressive = "normal"

							if squad.command == COMMAND_ENGAGE or squad.command == COMMAND_RESUPPLY or squad.command == COMMAND_STAGE or squad.command == COMMAND_ATTACK then
								vehicle_object.is_aggressive = "aggressive"
							end

							if s.isInZone(vehicle_object.transform, "land_ai_road") then
								vehicle_object.terrain_type = "road"
							elseif s.isInZone(vehicle_object.transform, "land_ai_bridge") then
								vehicle_object.terrain_type = "bridge"
							end

							ai_speed_pseudo = (vehicle_object.speed.land[vehicle_object.is_aggressive][vehicle_object.terrain_type] or vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_LAND) * vehicle_update_tickrate / 60
						else
							ai_speed_pseudo = (vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_BOAT) * vehicle_update_tickrate / 60
						end

						if #vehicle_object.path == 0 then
							vehicle_object.state.s = VEHICLE_STATE_HOLDING
						else
							if ai_state ~= 2 then ai_state = 1 end
							if vehicle_object.ai_type ~= AI_TYPE_LAND then 
								ai_target = m.translation(vehicle_object.path[1].x, vehicle_object.path[1].y, vehicle_object.path[1].z)
							else
								local veh_x, veh_y, veh_z = m.position(vehicle_object.transform)
								ai_target = m.translation(vehicle_object.path[1].x, veh_y, vehicle_object.path[1].z)
								setLandTarget(vehicle_id, vehicle_object)
							end
							if vehicle_object.ai_type == AI_TYPE_BOAT then ai_target[14] = 0 end
	
							local vehicle_pos = vehicle_object.transform
							local distance = m.distance(ai_target, vehicle_pos)
	
							if vehicle_object.ai_type == AI_TYPE_PLANE and distance < WAYPOINT_CONSUME_DISTANCE * 4 and vehicle_object.role == "scout" or distance < WAYPOINT_CONSUME_DISTANCE and vehicle_object.ai_type == AI_TYPE_PLANE or distance < WAYPOINT_CONSUME_DISTANCE and vehicle_object.ai_type == AI_TYPE_HELI or vehicle_object.ai_type == AI_TYPE_LAND and distance < 7 then
								if #vehicle_object.path > 1 then
									s.removeMapID(-1, vehicle_object.path[1].ui_id)
									table.remove(vehicle_object.path, 1)
									if vehicle_object.ai_type == AI_TYPE_LAND then
										setLandTarget(vehicle_id, vehicle_object)
									end
								elseif vehicle_object.role == "scout" then
									resetPath(vehicle_object)
									target_island, origin_island = getObjectiveIsland(true)
									if target_island then
										local holding_route = g_holding_pattern
										addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[1].x, CRUISE_HEIGHT * 2, holding_route[1].z)))
										addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[2].x, CRUISE_HEIGHT * 2, holding_route[2].z)))
										addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[3].x, CRUISE_HEIGHT * 2, holding_route[3].z)))
										addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[4].x, CRUISE_HEIGHT * 2, holding_route[4].z)))
									end
								elseif vehicle_object.ai_type ~= AI_TYPE_LAND then
									-- if we have reached last waypoint start holding there
									wpDLCDebug("set plane "..vehicle_id.." to holding", true, false)
									vehicle_object.state.s = VEHICLE_STATE_HOLDING
								end
							elseif vehicle_object.ai_type == AI_TYPE_BOAT and distance < WAYPOINT_CONSUME_DISTANCE then
								if #vehicle_object.path > 0 then
									s.removeMapID(-1, vehicle_object.path[1].ui_id)
									table.remove(vehicle_object.path, 1)
								else
									-- if we have reached last waypoint start holding there
									wpDLCDebug("set boat "..vehicle_id.." to holding", true, false)
									vehicle_object.state.s = VEHICLE_STATE_HOLDING
								end
							end
						end

						if squad.command == COMMAND_ENGAGE and vehicle_object.ai_type == AI_TYPE_HELI then
							ai_state = 3
						end

						refuel(vehicle_id)
					elseif vehicle_object.state.s == VEHICLE_STATE_HOLDING then

						ai_speed_pseudo = (vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_PLANE) * vehicle_update_tickrate / 60

						if vehicle_object.ai_type == AI_TYPE_BOAT then
							ai_state = 0
						elseif vehicle_object.ai_type == AI_TYPE_LAND then
							local target = nil
							if squad_index ~= RESUPPLY_SQUAD_INDEX then -- makes sure its not resupplying
								local squad_vision = squadGetVisionData(squad)
								if vehicle_object.target_vehicle_id ~= -1 and vehicle_object.target_vehicle_id and squad_vision.visible_vehicles_map[vehicle_object.target_vehicle_id] then
									target = squad_vision.visible_vehicles_map[vehicle_object.target_vehicle_id].obj
								elseif vehicle_object.target_player_id ~= -1 and vehicle_object.target_player_id ~= 65535 and vehicle_object.target_player_id and squad_vision.visible_players_map[vehicle_object.target_player_id] then
									target = squad_vision.visible_players_map[vehicle_object.target_player_id].obj
								end
								if target and m.distance(m.translation(0, 0, 0), target.last_known_pos) > 5 then
									ai_target = target.last_known_pos
									local distance = m.distance(vehicle_object.transform, ai_target)
									local possiblePaths = s.pathfindOcean(vehicle_object.transform, ai_target)
									local is_better_pos = false
									for path_index, path in pairs(possiblePaths) do
										if m.distance(matrix.translation(path.x, path.y, path.z), ai_target) < distance then
											is_better_pos = true
										end
									end
									if is_better_pos then
										addPath(vehicle_object, ai_target)
									else
										ai_state = 0
									end
								else
									ai_state = 0
								end
							end
						else
							if #vehicle_object.path == 0 then
								wpDLCDebugVehicle(vehicle_id, "Vehicle: "..vehicle_id.." has 0 paths, adding more", true, false)
								addPath(vehicle_object, vehicle_object.transform)
							end

							ai_state = 1
							ai_target = m.translation(vehicle_object.path[1].x + g_holding_pattern[vehicle_object.holding_index].x, vehicle_object.path[1].y, vehicle_object.path[1].z + g_holding_pattern[vehicle_object.holding_index].z)

							local vehicle_pos = vehicle_object.transform
							local distance = m.distance(ai_target, vehicle_pos)

							if distance < WAYPOINT_CONSUME_DISTANCE and vehicle_object.ai_type ~= AI_TYPE_LAND or distance < 7 and vehicle_object.ai_type == AI_TYPE_LAND then
								vehicle_object.holding_index = 1 + ((vehicle_object.holding_index) % 4);
							end
						end
					end

					--set ai behaviour
					if ai_target ~= nil then
						if vehicle_object.state.is_simulating then
							s.setAITarget(vehicle_object.survivors[1].id, ai_target)
							s.setAIState(vehicle_object.survivors[1].id, ai_state)
						else
							local ts_x, ts_y, ts_z = m.position(ai_target)
							local vehicle_pos = vehicle_object.transform
							local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_pos)
							local movement_x = ts_x - vehicle_x
							local movement_y = ts_y - vehicle_y
							local movement_z = ts_z - vehicle_z
							local length_xz = math.sqrt((movement_x * movement_x) + (movement_z * movement_z))

							local function clamp(value, min, max)
								return math.min(max, math.max(min, value))
							end

							local speed_pseudo = ai_speed_pseudo * g_debug_speed_multiplier
							movement_x = clamp(movement_x * speed_pseudo / length_xz, -math.abs(movement_x), math.abs(movement_x))
							movement_y = math.min(speed_pseudo, math.max(movement_y, -speed_pseudo))
							movement_z = clamp(movement_z * speed_pseudo / length_xz, -math.abs(movement_z), math.abs(movement_z))

							local rotation_matrix = m.rotationToFaceXZ(movement_x, movement_z)
							local new_pos = m.multiply(m.translation(vehicle_x + movement_x, vehicle_y + movement_y, vehicle_z + movement_z), rotation_matrix)

							if s.getVehicleLocal(vehicle_id) == false then
								s.setVehiclePos(vehicle_id, new_pos)

								for npc_index, npc_object in pairs(vehicle_object.survivors) do
									s.setObjectPos(npc_object.id, new_pos)
								end

								if vehicle_object.fire_id ~= nil then
									s.setObjectPos(vehicle_object.fire_id, new_pos)
								end
							end
						end
					end
				end
				if render_debug then
					local vehicle_pos = vehicle_object.transform
					local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_pos)
					local debug_data = ""
					debug_data = debug_data.."Role: "..vehicle_object.role.."\n"
					debug_data = debug_data.."Strategy: "..vehicle_object.strategy.."\n\n"
					debug_data = debug_data.."Movement State: "..vehicle_object.state.s .. "\n"
					debug_data = debug_data .. "Waypoints: " .. #vehicle_object.path .."\n\n"
					
					debug_data = debug_data .. "Squad: " .. squad_index .."\n"
					debug_data = debug_data .. "Command: " .. squad.command .."\n"
					debug_data = debug_data .. "AI State: ".. ai_state .. "\n"
					if squad.target_island then debug_data = debug_data.."\nTarget Island: " .. squad.target_island.name .. "\n" end

					debug_data = debug_data .. "Target Player: " .. vehicle_object.target_player_id .."\n"
					debug_data = debug_data .. "Target Vehicle: " .. vehicle_object.target_vehicle_id .."\n\n"

					if squad_index ~= RESUPPLY_SQUAD_INDEX then
						local squad_vision = squadGetVisionData(squad)
						debug_data = debug_data .. "squad visible players: " .. #squad_vision.visible_players .."\n"
						debug_data = debug_data .. "squad visible vehicles: " .. #squad_vision.visible_vehicles .."\n"
						debug_data = debug_data .. "squad investigate players: " .. #squad_vision.investigate_players .."\n"
						debug_data = debug_data .. "squad investigate vehicles: " .. #squad_vision.investigate_vehicles .."\n\n"
					end

					local hp = vehicle_object.health * g_savedata.settings.ENEMY_HP_MODIFIER
					
					debug_data = debug_data .. "hp: " .. vehicle_object.current_damage .. " / " .. hp .. "\n"

					local damage_dealt = 0
					for victim_vehicle, damage in pairs(vehicle_object.damage_dealt) do
						damage_dealt = damage_dealt + damage
					end
					debug_data = debug_data.."Damage Dealt: "..damage_dealt.."\n\n"
					local ai_speed_pseudo = "nil"

					debug_data = debug_data.."Base Visiblity Range: "..vehicle_object.vision.base_radius.."\n"
					debug_data = debug_data.."Current Visibility Range: "..vehicle_object.vision.radius.."\n"
					debug_data = debug_data.."Has Radar: "..(vehicle_object.vision.is_radar and "true" or "false").."\n"
					debug_data = debug_data.."Has Sonar: "..(vehicle_object.vision.is_sonar and "true" or "false").."\n\n"

					if vehicle_object.ai_type == AI_TYPE_BOAT then
						ai_speed_pseudo = vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_BOAT
					elseif vehicle_object.ai_type == AI_TYPE_PLANE then
						ai_speed_pseudo = vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_PLANE
					elseif vehicle_object.ai_type == AI_TYPE_HELI then
						ai_speed_pseudo = vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_HELI
					elseif vehicle_object.ai_type == AI_TYPE_LAND then
						if vehicle_object.is_aggressive and vehicle_object.terrain_type then
							ai_speed_pseudo = (vehicle_object.speed.land[vehicle_object.is_aggressive][vehicle_object.terrain_type] or vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_LAND)
						else
							ai_speed_pseudo = vehicle_object.speed.not_land.pseudo_speed or AI_SPEED_PSEUDO_LAND
						end
					end
					debug_data = debug_data.."Pseudo Speed: "..ai_speed_pseudo.." m/s\n"
					
					if vehicle_object.ai_type == AI_TYPE_LAND then
						debug_data = debug_data.."Is Agressive: "..tostring(vehicle_object.is_aggressive).."\n"
						debug_data = debug_data.."Terrain Type: "..tostring(vehicle_object.terrain_type).."\n"
					end

					debug_data = debug_data .. "\nPos: [" .. math.floor(vehicle_x) .. " ".. math.floor(vehicle_y) .. " ".. math.floor(vehicle_z) .. "]\n"
					if ai_target then
						local ts_x, ts_y, ts_z = m.position(ai_target)
						debug_data = debug_data .. "Dest: [" .. math.floor(ts_x) .. " ".. math.floor(ts_y) .. " ".. math.floor(ts_z) .. "]\n"

						local dist_to_dest = math.sqrt((ts_x - vehicle_x) ^ 2 + (ts_z - vehicle_z) ^ 2)
						debug_data = debug_data .. "Dist: " .. math.floor(dist_to_dest) .. "m\n"
					end

					if vehicle_object.state.is_simulating then
						debug_data = debug_data .. "\n\nSIMULATING\n"
						debug_data = debug_data .. "needs resupply: " .. tostring(isVehicleNeedsResupply(vehicle_id, "Resupply")) .. "\n"
					else
						debug_data = debug_data .. "\n\nPSEUDO\n"
						debug_data = debug_data .. "resupply on load: " .. tostring(vehicle_object.is_resupply_on_load) .. "\n"
					end

					local state_icons = {
						[COMMAND_ATTACK] = 18,
						[COMMAND_STAGE] = 2,
						[COMMAND_ENGAGE] = 5,
						[COMMAND_DEFEND] = 19,
						[COMMAND_PATROL] = 15,
						[COMMAND_TURRET] = 14,
						[COMMAND_RESUPPLY] = 11,
						[COMMAND_SCOUT] = 4,
						[COMMAND_INVESTIGATE] = 6,
					}
					local r = 55
					local g = 0
					local b = 200
					local vehicle_icon = debug_mode_blinker and 16 or state_icons[squad.command]
					if vehicle_object.ai_type == AI_TYPE_LAND then
						g = 255
						b = 125
						vehicle_icon = debug_mode_blinker and 12 or state_icons[squad.command]
					elseif vehicle_object.ai_type == AI_TYPE_HELI then
						r = 255
						b = 200
						vehicle_icon = debug_mode_blinker and 15 or state_icons[squad.command]
					elseif vehicle_object.ai_type == AI_TYPE_PLANE then
						g = 200
						vehicle_icon = debug_mode_blinker and 13 or state_icons[squad.command]
					elseif vehicle_object.ai_type == AI_TYPE_TURRET then
						r = 131
						g = 101
						b = 57
						vehicle_icon = debug_mode_blinker and 14 or state_icons[squad.command]
					end
					for player_id, is_debugging in pairs(g_savedata.playerData.isDebugging) do
						if is_debugging then
							s.removeMapObject(player_id, vehicle_object.map_id)
							s.addMapObject(player_id, vehicle_object.map_id, 1, vehicle_icon or 3, 0, 0, 0, 0, vehicle_id, 0, "AI " .. vehicle_object.ai_type .. " " .. vehicle_id.."\n"..vehicle_object.name, vehicle_object.vision.radius, debug_data, r, g, b, 255)

							if(#vehicle_object.path >= 1) then
								s.removeMapLine(player_id, vehicle_object.map_id)

								s.addMapLine(player_id, vehicle_object.map_id, vehicle_pos, m.translation(vehicle_object.path[1].x, vehicle_object.path[1].y, vehicle_object.path[1].z), 0.5, r, g, b, 255)

								for i = 1, #vehicle_object.path - 1 do
									local waypoint = vehicle_object.path[i]
									local waypoint_next = vehicle_object.path[i + 1]

									local waypoint_pos = m.translation(waypoint.x, waypoint.y, waypoint.z)
									local waypoint_pos_next = m.translation(waypoint_next.x, waypoint_next.y, waypoint_next.z)

									s.removeMapLine(player_id, waypoint.ui_id)
									s.addMapLine(player_id, waypoint.ui_id, waypoint_pos, waypoint_pos_next, 0.5, r, g, b, 255)
								end
							end
						end
					end
				end
			end
		end
	end
end

function tickUpdateVehicleData()
	for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
		for vehicle_id, vehicle_object in pairs(squad.vehicles) do
			if isTickID(vehicle_id, 30) then
				vehicle_object.transform = s.getVehiclePos(vehicle_id)
			end
		end
	end

	for player_vehicle_id, player_vehicle in pairs(g_savedata.player_vehicles) do
		if isTickID(player_vehicle_id, 30) then
			player_vehicle.transform = s.getVehiclePos(player_vehicle_id)
		end
	end
end

function tickTerrainScanners()
	for vehicle_id, terrain_scanner in pairs(g_savedata.terrain_scanner_links) do
		local vehicle_object = nil

		for squad_index, squad in pairs(g_savedata.ai_army.squadrons) do
			for vehicle_index, vehicle_data in pairs(squad.vehicles) do
				if vehicle_index == vehicle_id then
					vehicle_object = vehicle_data
				end
			end
		end

		local terrain_scanner_data = s.getVehicleData(terrain_scanner)

		if terrain_scanner_data then
			if vehicle_object then
				if hasTag(terrain_scanner_data.tags, "type=dlc_weapons_terrain_scanner") then
					wpDLCDebug("terrain scanner loading!", true, false)
					wpDLCDebug("ter id: "..terrain_scanner, true, false)
					wpDLCDebug("veh id: "..vehicle_id, true, false)
					dial_read_attempts = 0
					repeat
						dial_read_attempts = dial_read_attempts + 1
						terrain_height, success = s.getVehicleDial(terrain_scanner, "MEASURED_DISTANCE")
						if success and terrain_height.value ~= 0 then
							printTable(terrain_height, true, false)
							local new_terrain_height = (1000 - terrain_height.value) + 5
							local vehicle_x, vehicle_y, vehicle_z = m.position(vehicle_object.transform)
							local new_vehicle_matrix = m.translation(vehicle_x, new_terrain_height, vehicle_z)
							s.setVehiclePos(vehicle_id, new_vehicle_matrix)
							wpDLCDebug("set land vehicle to new y level!", true, false)
							g_savedata.terrain_scanner_links[vehicle_id] = "Just Teleported"
							s.despawnVehicle(terrain_scanner, true)
						else
							if success then
								wpDLCDebug("Unable to get terrain height checker's dial! "..dial_read_attempts.."x (read = 0)", true, true)
							else
								wpDLCDebug("Unable to get terrain height checker's dial! "..dial_read_attempts.."x (not success)", true, true)
							end
							
						end
						if dial_read_attempts >= 2 then return end
					until(success and terrain_height.value ~= 0)
				end
			else -- the vehicle seems to have been destroyed in some way
				g_savedata.terrain_scanner_links[vehicle_id] = nil
			end
		end
	end
end

function tickModifiers()
	if isTickID(g_savedata.tick_counter, time.hour / 2) then -- defence, if the player has attacked within the last 30 minutes, increase defence
		if g_savedata.tick_counter - g_savedata.ai_history.has_defended <= time.hour / 2 and g_savedata.ai_history.has_defended ~= 0 then -- if the last time the player attacked was equal or less than 30 minutes ago
			sm.train(REWARD, "defend", 4)
			sm.train(PUNISH, "attack", 3)
			wpDLCDebug("players have attacked within the last 30 minutes! increasing defence, decreasing attack!", true, false)
		end
	end
	if isTickID(g_savedata.tick_counter, time.hour) then -- attack, if the player has not attacked in the last one hour, raise attack
		if g_savedata.tick_counter - g_savedata.ai_history.has_defended > time.hour then -- if the last time the player attacked was more than an hour ago
			sm.train(REWARD, "attack", 3)
			wpDLCDebug("players have not attacked in the past hour! increasing attack!", true, false)
		end
	end
	if isTickID(g_savedata.tick_counter, time.hour * 2) then -- defence, if the player has not attacked in the last two hours, then lower defence
		if g_savedata.tick_counter - g_savedata.ai_history.has_defended > time.hour * 2 then -- if the last time the player attacked was more than two hours ago
			sm.train(PUNISH, "defend", 3)
			wpDLCDebug("players have not attacked in the last two hours! lowering defence!", true, false)
		end
	end

	-- checks if the player is nearby the ai's controlled islands, works like a capacitor, however the
	-- closer the player is, the faster it will charge up, once it hits its limit, it will then detect that the
	-- player is attacking, and will then use that to tell the ai to increase on defence
	for island_index, island in pairs(g_savedata.controllable_islands) do
		if isTickID(island_index * 30, time.minute / 2) then
			if island.faction == FACTION_AI then
				local player_list = s.getPlayers()
				for player_index, player in pairs(player_list) do
					player_pos = s.getPlayerPos(player)
					player_island_dist = xzDistance(player_pos, island.transform)
					if player_island_dist < 1000 then
						g_savedata.ai_history.defended_charge = g_savedata.ai_history.defended_charge + 3
					elseif player_island_dist < 2000 then
						g_savedata.ai_history.defended_charge = g_savedata.ai_history.defended_charge + 2
					elseif player_island_dist < 3000 then
						g_savedata.ai_history.defended_charge = g_savedata.ai_history.defended_charge + 1
					end
					if g_savedata.ai_history.defended_charge >= 6 then
						g_savedata.ai_history.defended_charge = 0
						g_savedata.ai_history.has_defended = g_savedata.tick_counter
						wpDLCDebug(player.name.." has been detected to be attacking "..island.name..", the ai will be raising their defences!", true, false)
					end
				end
			end
		end
	end
end

function tickOther()
	if g_savedata.playerData.isDoAsISay[0] then
		-- if its been 15 or more seconds since player did the ?impwep full_reload
		-- then cancel the command
		if (g_savedata.tick_counter - g_savedata.playerData.timers.isDoAsISay) >= time.second*15 then
			wpDLCDebug("Automatically cancelled full reload!", false, false, 0)
			g_savedata.playerData.isDoAsISay[0] = nil
			g_savedata.playerData.timers.isDoAsISay = 0
		end
	end
end

function onTick(tick_time)
	g_tick_counter = g_tick_counter + 1
	g_savedata.tick_counter = g_savedata.tick_counter + 1

	if is_dlc_weapons then
		tickUpdateVehicleData()
		tickVision()
		tickGamemode()
		tickAI()
		tickSquadrons()
		tickVehicles()
		tickModifiers()
		if tableLength(g_savedata.terrain_scanner_links) > 0 then
			tickTerrainScanners()
		end
		tickOther() -- not as important stuff
	end
end

function refuel(vehicle_id)
    s.setVehicleTank(vehicle_id, "Jet 1", 999, 2)
    s.setVehicleTank(vehicle_id, "Jet 2", 999, 2)
    s.setVehicleTank(vehicle_id, "Jet 3", 999, 2)
    s.setVehicleTank(vehicle_id, "Diesel 1", 999, 1)
    s.setVehicleTank(vehicle_id, "Diesel 2", 999, 1)
    s.setVehicleBattery(vehicle_id, "Battery 1", 1)
    s.setVehicleBattery(vehicle_id, "Battery 2", 1)
end

function reload(vehicle_id, from_storage)
	local i = 1
	repeat
		local ammo, success = s.getVehicleWeapon(vehicle_id, "Ammo "..i) -- get the number of ammo containers to reload
		if success then
			s.setVehicleWeapon(vehicle_id, "Ammo "..i, ammo.capacity) -- reload the ammo container
		end
		i = i + 1
	until (not success)
end

--[[
        Utility Functions
--]]

function build_locations(playlist_index, location_index)
    local location_data = s.getLocationData(playlist_index, location_index)

    local addon_components =
    {
        vehicles = {},
        survivors = {},
        objects = {},
		zones = {},
		fires = {},
    }

    local is_valid_location = false

    for object_index, object_data in iterObjects(playlist_index, location_index) do

        for tag_index, tag_object in pairs(object_data.tags) do

            if tag_object == "type=dlc_weapons" then
                is_valid_location = true
            end
			if tag_object == "type=dlc_weapons_terrain_scanner" then
				if object_data.type == "vehicle" then
					g_savedata.terrain_scanner_prefab = { playlist_index = playlist_index, location_index = location_index, object_index = object_index}
				end
			end
			if tag_object == "type=dlc_weapons_flag" then
				if object_data.type == "vehicle" then
					flag_prefab = { playlist_index = playlist_index, location_index = location_index, object_index = object_index}
				end
            end
        end

        if object_data.type == "vehicle" then
			table.insert(addon_components.vehicles, object_data)
        elseif object_data.type == "character" then
			table.insert(addon_components.survivors, object_data)
		elseif object_data.type == "fire" then
			table.insert(addon_components.fires, object_data)
        elseif object_data.type == "object" then
            table.insert(addon_components.objects, object_data)
		elseif object_data.type == "zone" then
			table.insert(addon_components.zones, object_data)
        end
    end

    if is_valid_location then
    	table.insert(built_locations, { playlist_index = playlist_index, location_index = location_index, data = location_data, objects = addon_components} )
    end
end

function spawnObjects(spawn_transform, playlist_index, location_index, object_descriptors, out_spawned_objects)
	local spawned_objects = {}

	for _, object in pairs(object_descriptors) do
		-- find parent vehicle id if set

		local parent_vehicle_id = 0
		if object.vehicle_parent_component_id > 0 then
			for spawned_object_id, spawned_object in pairs(out_spawned_objects) do
				if spawned_object.type == "vehicle" and spawned_object.component_id == object.vehicle_parent_component_id then
					parent_vehicle_id = spawned_object.id
				end
			end
		end

		spawnObject(spawn_transform, playlist_index, location_index, object, parent_vehicle_id, spawned_objects, out_spawned_objects)
	end

	return spawned_objects
end

function spawnObject(spawn_transform, playlist_index, location_index, object, parent_vehicle_id, spawned_objects, out_spawned_objects)
	-- spawn object

	local spawned_object_id = spawnObjectType(m.multiply(spawn_transform, object.transform), playlist_index, location_index, object, parent_vehicle_id)

	-- add object to spawned object tables

	if spawned_object_id ~= nil and spawned_object_id ~= 0 then

		local l_ai_type = AI_TYPE_HELI
		if hasTag(object.tags, "vehicle_type=wep_plane") then
			l_ai_type = AI_TYPE_PLANE
		end
		if hasTag(object.tags, "vehicle_type=wep_boat") then
			l_ai_type = AI_TYPE_BOAT
		end
		if hasTag(object.tags, "vehicle_type=wep_land") then
			l_ai_type = AI_TYPE_LAND
		end
		if hasTag(object.tags, "vehicle_type=wep_turret") then
			l_ai_type = AI_TYPE_TURRET
		end
		if hasTag(object.tags, "type=dlc_weapons_flag") then
			l_ai_type = "flag"
		end
		if hasTag(object.tags, "type=dlc_weapons_terrain_scanner") then
			wpDLCDebug("terrain scanner!", true, false)
			l_ai_type = "terrain_scanner"
		end

		local l_size = "small"
		for tag_index, tag_object in pairs(object.tags) do
			if string.find(tag_object, "size=") ~= nil then
				l_size = string.sub(tag_object, 6)
			end
		end

		local object_data = { name = object.display_name, type = object.type, id = spawned_object_id, component_id = object.id, ai_type = l_ai_type, size = l_size }

		if spawned_objects ~= nil then
			table.insert(spawned_objects, object_data)
		end

		if out_spawned_objects ~= nil then
			table.insert(out_spawned_objects, object_data)
		end

		return object_data
	end

	return nil
end

-- spawn an individual object descriptor from a playlist location
function spawnObjectType(spawn_transform, playlist_index, location_index, object_descriptor, parent_vehicle_id)
	local component, is_success = s.spawnAddonComponent(spawn_transform, playlist_index, location_index, object_descriptor.index, parent_vehicle_id)
	if is_success then
		return component.id
	else -- then it failed to spawn the addon component
		-- print info for use in debugging
		wpDLCDebug("Failed to spawn addon component! This is very likely due to you executing ?reload_scripts at some point, as of now theres a bug in stormworks and doing that will cause all of the workshop addon's data in scene.xml to be wiped, this is not a improved conquest mode specific issue, I'm so sorry for the inconvience, but the only fix at this time is to just create a new world. https://geometa.co.uk/support/stormworks/7077/", false, true)
		wpDLCDebug("To Avoid a possible CTD, Improved Conquest Mode is now disabled in this world", false, true)
		is_dlc_weapons = false
		return nil
	end
end

--------------------------------------------------------------------------------
--
-- VEHICLE HELPERS
--
--------------------------------------------------------------------------------

function isVehicleNeedsResupply(vehicle_id, button_name)
	local button_data, success = s.getVehicleButton(vehicle_id, button_name)
	return success and button_data.on
end

function isVehicleNeedsReloadMG(vehicle_id)
	local needing_reload = false
	local mg_id = 0
	for i=1,6 do
		local needs_reload, is_success_button = s.getVehicleButton(vehicle_id, "RELOAD_MG"..i)
		if needs_reload ~= nil then
			if needs_reload.on and is_success_button then
				needing_reload = true
				mg_id = i
			end
		end
	end
	local returnings = {}
	returnings[1] = needing_reload
	returnings[2] = mg_id
	return returnings
end



--------------------------------------------------------------------------------
--
-- SQUAD HELPERS
--
--------------------------------------------------------------------------------

function resetSquadTarget(squad)
	squad.target_island = nil
end

function setSquadCommandPatrol(squad, target_island)
	squad.target_island = target_island
	setSquadCommand(squad, COMMAND_PATROL)
end

function setSquadCommandStage(squad, target_island)
	squad.target_island = target_island
	setSquadCommand(squad, COMMAND_STAGE)
end

function setSquadCommandAttack(squad, target_island)
	squad.target_island = target_island
	setSquadCommand(squad, COMMAND_ATTACK)
end

function setSquadCommandDefend(squad, target_island)
	squad.target_island = target_island
	setSquadCommand(squad, COMMAND_DEFEND)
end

function setSquadCommandEngage(squad)
	setSquadCommand(squad, COMMAND_ENGAGE)
end

function setSquadCommandInvestigate(squad, investigate_transform)
	squad.investigate_transform = investigate_transform
	setSquadCommand(squad, COMMAND_INVESTIGATE)
end

function setSquadCommandScout(squad)
	setSquadCommand(squad, COMMAND_SCOUT)
end

function setSquadCommand(squad, command)
	if squad.command ~= command then
		if squad.command ~= COMMAND_SCOUT or squad.command == COMMAND_SCOUT and command == COMMAND_DEFEND then
			squad.command = command
		
			for vehicle_id, vehicle_object in pairs(squad.vehicles) do
				squadInitVehicleCommand(squad, vehicle_object)
			end

			if squad.command == COMMAND_NONE then
				resetSquadTarget(squad)
			elseif squad.command == COMMAND_INVESTIGATE then
				squad.target_players = {}
				squad.target_vehicles = {}
			end

			return true
		end
	end

	return false
end

function squadInitVehicleCommand(squad, vehicle_object)
	vehicle_object.target_vehicle_id = -1
	vehicle_object.target_player_id = -1

	wpDLCDebugVehicle(vehicle_object.id, "(squadInitVehicleCommand) Vehicle "..vehicle_object.id.." command: "..squad.command, true, false)

	if squad.command == COMMAND_PATROL then
		resetPath(vehicle_object)

		local patrol_route = g_patrol_route
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(patrol_route[1].x, CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), patrol_route[1].z)))
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(patrol_route[2].x, CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), patrol_route[2].z)))
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(patrol_route[3].x, CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), patrol_route[3].z)))
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(patrol_route[4].x, CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), patrol_route[4].z)))
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(patrol_route[5].x, CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), patrol_route[5].z)))
	elseif squad.command == COMMAND_ATTACK then
		-- go to island, once island is captured the command will be cleared
		resetPath(vehicle_object)
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(math.random(-100, 100), CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), math.random(-100, 100))))
	elseif squad.command == COMMAND_STAGE then
		resetPath(vehicle_object)
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(math.random(-500, 500), CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), math.random(-500, 500))))
	elseif squad.command == COMMAND_DEFEND then
		-- defend island
		resetPath(vehicle_object)
		addPath(vehicle_object, m.multiply(squad.target_island.transform, m.translation(math.random(-500, 500), CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), math.random(-500, 500))))
	elseif squad.command == COMMAND_INVESTIGATE then
		-- go to investigate location
		resetPath(vehicle_object)
		addPath(vehicle_object, m.multiply(squad.investigate_transform, m.translation(math.random(-500, 500), CRUISE_HEIGHT + (vehicle_object.id % 10 * 20), math.random(-500, 500))))
	elseif squad.command == COMMAND_ENGAGE then
		resetPath(vehicle_object)
	elseif squad.command == COMMAND_SCOUT then
		resetPath(vehicle_object)
		target_island, origin_island = getObjectiveIsland()
		if target_island then
			wpDLCDebug("Scout found a target island!", true, false)
			local holding_route = g_holding_pattern
			addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[1].x, CRUISE_HEIGHT * 2, holding_route[1].z)))
			addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[2].x, CRUISE_HEIGHT * 2, holding_route[2].z)))
			addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[3].x, CRUISE_HEIGHT * 2, holding_route[3].z)))
			addPath(vehicle_object, m.multiply(target_island.transform, m.translation(holding_route[4].x, CRUISE_HEIGHT * 2, holding_route[4].z)))
		else
			wpDLCDebug("Scout was unable to find a island to target!", true, true)
		end
	elseif squad.command == COMMAND_RETREAT then
	elseif squad.command == COMMAND_NONE then
	elseif squad.command == COMMAND_TURRET then
		resetPath(vehicle_object)
	elseif squad.command == COMMAND_RESUPPLY then
		resetPath(vehicle_object)
	end
end

function squadGetVisionData(squad)
	local vision_data = {
		visible_players_map = {},
		visible_players = {},
		visible_vehicles_map = {},
		visible_vehicles = {},
		investigate_players = {},
		investigate_vehicles = {},

		isPlayerVisible = function(self, id)
			return self.visible_players_map[id] ~= nil
		end,

		isVehicleVisible = function(self, id)
			return self.visible_vehicles_map[id] ~= nil
		end,

		getBestTargetPlayerID = function(self)
			return self.visible_players[math.random(1, #self.visible_players)].id
		end,

		getBestTargetVehicleID = function(self)
			return self.visible_vehicles[math.random(1, #self.visible_vehicles)].id
		end,

		getBestInvestigatePlayer = function(self)
			return self.investigate_players[math.random(1, #self.investigate_players)]
		end,

		getBestInvestigateVehicle = function(self)
			return self.investigate_vehicles[math.random(1, #self.investigate_vehicles)]
		end,

		is_engage = function(self)
			return #self.visible_players > 0 or #self.visible_vehicles > 0
		end,

		is_investigate = function(self)
			return #self.investigate_players > 0 or #self.investigate_vehicles > 0
		end,
	}

	for object_id, player_object in pairs(squad.target_players) do
		local player_data = { id = object_id, obj = player_object }

		if player_object.state == TARGET_VISIBILITY_VISIBLE then
			vision_data.visible_players_map[object_id] = player_data
			table.insert(vision_data.visible_players, player_data)
		elseif player_object.state == TARGET_VISIBILITY_INVESTIGATE then
			table.insert(vision_data.investigate_players, player_data)
		end
	end

	for vehicle_id, vehicle_object in pairs(squad.target_vehicles) do
		local vehicle_data = { id = vehicle_id, obj = vehicle_object }

		if vehicle_object.state == TARGET_VISIBILITY_VISIBLE then
			vision_data.visible_vehicles_map[vehicle_id] = vehicle_data
			table.insert(vision_data.visible_vehicles, vehicle_data)
		elseif vehicle_object.state == TARGET_VISIBILITY_INVESTIGATE then
			table.insert(vision_data.investigate_vehicles, vehicle_data)
		end
	end

	return vision_data
end


--------------------------------------------------------------------------------
--
-- UTILITIES
--
--------------------------------------------------------------------------------

---@param id integer the tick you want to check that it is
---@param rate integer the total amount of ticks, for example, a rate of 60 means it returns true once every second* (if the tps is not low)
---@return boolean isTick if its the current tick that you requested
function isTickID(id, rate)
	return (g_tick_counter + id) % rate == 0
end

-- iterator function for iterating over all playlists, skipping any that return nil data
function iterPlaylists()
	local playlist_count = s.getAddonCount()
	local playlist_index = 0

	return function()
		local playlist_data = nil
		local index = playlist_count

		while playlist_data == nil and playlist_index < playlist_count do
			playlist_data = s.getAddonData(playlist_index)
			index = playlist_index
			playlist_index = playlist_index + 1
		end

		if playlist_data ~= nil then
			return index, playlist_data
		else
			return nil
		end
	end
end

-- iterator function for iterating over all locations in a playlist, skipping any that return nil data
function iterLocations(playlist_index)
	local playlist_data = s.getAddonData(playlist_index)
	local location_count = 0
	if playlist_data ~= nil then location_count = playlist_data.location_count end
	local location_index = 0

	return function()
		local location_data = nil
		local index = location_count

		while not location_data and location_index < location_count do
			location_data = s.getLocationData(playlist_index, location_index)
			index = location_index
			location_index = location_index + 1
		end

		if location_data ~= nil then
			return index, location_data
		else
			return nil
		end
	end
end

-- iterator function for iterating over all objects in a location, skipping any that return nil data
function iterObjects(playlist_index, location_index)
	local location_data = s.getLocationData(playlist_index, location_index)
	local object_count = 0
	if location_data ~= nil then object_count = location_data.component_count end
	local object_index = 0

	return function()
		local object_data = nil
		local index = object_count

		while not object_data and object_index < object_count do
			object_data = s.getLocationComponentData(playlist_index, location_index, object_index)
			object_data.index = object_index
			index = object_index
			object_index = object_index + 1
		end

		if object_data ~= nil then
			return index, object_data
		else
			return nil
		end
	end
end

function hasTag(tags, tag)
	if type(tags) == "table" then
		for k, v in pairs(tags) do
			if v == tag then
				return true
			end
		end
	else
		wpDLCDebug("hasTag() was expecting a table, but got a "..type(tags).." instead! (this can be safely ignored)", true, true)
	end
	return false
end

-- gets the value of the specifed tag, returns nil if tag not found
function getTagValue(tags, tag, as_string)
	if type(tags) == "table" then
		for k, v in pairs(tags) do
			if string.match(v, tag.."=") then
				if not as_string then
					return tonumber(tostring(string.gsub(v, tag.."=", "")))
				else
					return tostring(string.gsub(v, tag.."=", ""))
				end
			end
		end
	else
		wpDLCDebug("getTagValue() was expecting a table, but got a "..type(tags).." instead! (this can be safely ignored)", true, true)
	end
	return nil
end

-- prints all in a table
function printTable(T, requiresDebugging, isError, toPlayer)
	for k, v in pairs(T) do
		if type(v) == "table" then
			wpDLCDebug("Table: "..tostring(k), requiresDebugging, isError, toPlayer)
			printTable(v, requiresDebugging, isError, toPlayer)
		else
			wpDLCDebug("k: "..tostring(k).." v: "..tostring(v), requiresDebugging, isError, toPlayer)
		end
	end
end

function tabulate(t,...) -- credit: woe | for this function
	local _ = table.pack(...)
	t[_[1]] = t[_[1]] or {}
	if _.n>1 then
		tabulate(t[_[1]], table.unpack(_, 2))
	end
end

function rand(x, y)
	return math.random()*(y-x)+x
end

function randChance(t)
	local total_mod = 0
	for k, v in pairs(t) do
		total_mod = total_mod + v
	end
	local win_name = ""
	local win_val = 0
	for k, v in pairs(t) do
		local chance = rand(0, v / total_mod)
		wpDLCDebug("chance: "..chance.." chance to beat: "..win_val.." k: "..k, true, false)
		if chance > win_val then
			win_val = chance
			win_name = k
		end
	end
	return win_name
end

function spawnModifiers.create() -- populates the constructable vehicles with their spawning modifiers
	for role, role_data in pairs(g_savedata.constructable_vehicles) do
		if type(role_data) == "table" then
			if role == "attack" or role == "general" or role == "defend" or role == "roaming" or role == "stealth" or role == "scout" or role == "turret" then
				for veh_type, veh_data in pairs(g_savedata.constructable_vehicles[role]) do
					if veh_type ~= "mod" and type(veh_data) == "table"then
						for strat, strat_data in pairs(veh_data) do
							if type(strat_data) == "table" and strat ~= "mod" then
								g_savedata.constructable_vehicles[role][veh_type][strat].mod = 1
								for vehicle_id, v in pairs(strat_data) do
									if type(v) == "table" and vehicle_id ~= "mod" then
										g_savedata.constructable_vehicles[role][veh_type][strat][vehicle_id].mod = 1
									end
								end
							end
						end
						g_savedata.constructable_vehicles[role][veh_type].mod = 1
					end
				end
				g_savedata.constructable_vehicles[role].mod = default_mods[role]
			end
		end
	end
end

---@param is_specified boolean true to specify what vehicle to spawn, false for random
---@param vehicle_list_id any vehicle to spawn if is_specified is true, integer to specify exact vehicle, string to specify the role of the vehicle you want
---@return prefab_data[] prefab_data the vehicle's prefab data
function spawnModifiers.spawn(is_specified, vehicle_list_id)
	local sel_role = nil
	local sel_veh_type = nil
	local sel_strat = nil
	local sel_vehicle = nil
	if is_specified == true and type(vehicle_list_id) == "number" and g_savedata.constructable_vehicles then
		sel_role = g_savedata.vehicle_list[vehicle_list_id].role
		sel_veh_type = g_savedata.vehicle_list[vehicle_list_id].vehicle_type
		sel_strat = g_savedata.vehicle_list[vehicle_list_id].strategy
		for vehicle_id, vehicle_object in pairs(g_savedata.constructable_vehicles[sel_role][sel_veh_type][sel_strat]) do
			if not sel_vehicle and vehicle_list_id == g_savedata.constructable_vehicles[sel_role][sel_veh_type][sel_strat][vehicle_id].id then
				sel_vehicle = vehicle_id
			end
		end
		if not sel_vehicle then
			return false
		end
	elseif is_specified == false and g_savedata.constructable_vehicles or type(vehicle_list_id) == "string" and g_savedata.constructable_vehicles then
		local role_chances = {}
		local veh_type_chances = {}
		local strat_chances = {}
		local vehicle_chances = {}
		if not vehicle_list_id then
			for role, v in pairs(g_savedata.constructable_vehicles) do
				if type(v) == "table" then
					if role == "attack" or role == "general" or role == "defend" or role == "roaming" then
						role_chances[role] = g_savedata.constructable_vehicles[role].mod
					end
				end
			end
			sel_role = randChance(role_chances)
		else
			sel_role = vehicle_list_id
		end
		wpDLCDebug("selected role: "..sel_role, true, false)

		for veh_type, v in pairs(g_savedata.constructable_vehicles[sel_role]) do
			if type(v) == "table" then
				veh_type_chances[veh_type] = g_savedata.constructable_vehicles[sel_role][veh_type].mod
			end
		end
		sel_veh_type = randChance(veh_type_chances)
		wpDLCDebug("selected vehicle type: "..sel_veh_type, true, false)

		for strat, v in pairs(g_savedata.constructable_vehicles[sel_role][sel_veh_type]) do
			if type(v) == "table" then
				strat_chances[strat] = g_savedata.constructable_vehicles[sel_role][sel_veh_type][strat].mod
			end
		end
		sel_strat = randChance(strat_chances)
		wpDLCDebug("selected strategy: "..sel_strat, true, false)
		
		for vehicle, v in pairs(g_savedata.constructable_vehicles[sel_role][sel_veh_type][sel_strat]) do
			if type(v) == "table" then
				vehicle_chances[vehicle] = g_savedata.constructable_vehicles[sel_role][sel_veh_type][sel_strat][vehicle].mod
			end
		end
		sel_vehicle = randChance(vehicle_chances)
		wpDLCDebug("selected vehicle: "..sel_vehicle, true, false)
	else
		if g_savedata.constructable_vehicles then
			wpDLCDebug("unknown arguments for choosing which ai vehicle to spawn!", true, true)
		else
			wpDLCDebug("g_savedata.constructable_vehicles is nil! This may be directly after a full reload, if so, ignore this error", true, true)
		end
		return false
	end
	return g_savedata.constructable_vehicles[sel_role][sel_veh_type][sel_strat][sel_vehicle]
end

---@param role string the role of the vehicle, such as attack, general or defend
---@param type string the vehicle type, such as boat, plane, heli, land or turret
---@param strategy string the strategy of the vehicle, such as strafe, bombing or general
---@param vehicle_list_id integer the index of the vehicle in the vehicle list
---@return integer constructable_vehicle_id the index of the vehicle in the constructable vehicle list, returns nil if not found
function spawnModifiers.getConstructableVehicleID(role, type, strategy, vehicle_list_id)
	local constructable_vehicle_id = nil
	if g_savedata.constructable_vehicles[role][type][strategy] then
		for vehicle_id, vehicle_object in pairs(g_savedata.constructable_vehicles[role][type][strategy]) do
			if not constructable_vehicle_id and vehicle_list_id == g_savedata.constructable_vehicles[role][type][strategy][vehicle_id].id then
				constructable_vehicle_id = vehicle_id
			end
		end
	end
	return constructable_vehicle_id -- returns the constructable_vehicle_id, if not found then it returns nil
end

---@param vehicle_name string the name of the vehicle
---@return integer vehicle_list_id the vehicle list id from the vehicle's name, returns nil if not found
function spawnModifiers.getVehicleListID(vehicle_name)
	local found_vehicle = nil
	for vehicle_id, vehicle_object in pairs(g_savedata.vehicle_list) do
		if vehicle_object.location.data.name == vehicle_name and not found_vehicle then
			found_vehicle = vehicle_id
		end
	end
	return found_vehicle
end

---@param reinforcement_type string \"punish\" to make it less likely to spawn, \"reward\" to make it more likely to spawn
---@param role string the role of the vehicle, such as attack, general or defend
---@param role_reinforcement integer how much to reinforce the role of the vehicle, 1-5
---@param type string the vehicle type, such as boat, plane, heli, land or turret
---@param type_reinforcement integer how much to reinforce the type of the vehicle, 1-5
---@param strategy string strategy of the vehicle, such as strafe, bombing or general
---@param strategy_reinforcement integer how much to reinforce the strategy of the vehicle, 1-5
---@param constructable_vehicle_id integer the index of the vehicle in the constructable vehicle list
---@param vehicle_reinforcement integer how much to reinforce the vehicle, 1-5
function spawnModifiers.train(reinforcement_type, role, role_reinforcement, type, type_reinforcement, strategy, strategy_reinforcement, constructable_vehicle_id, vehicle_reinforcement)
	if reinforcement_type == PUNISH then
		if role and role_reinforcement then
			wpDLCDebug("punished role:"..role.." | amount punished: "..ai_training.punishments[role_reinforcement], true, false)
			g_savedata.constructable_vehicles[role].mod = math.max(g_savedata.constructable_vehicles[role].mod + ai_training.punishments[role_reinforcement], 0)
			if type and type_reinforcement then 
				wpDLCDebug("punished type:"..type.." | amount punished: "..ai_training.punishments[type_reinforcement], true, false)
				g_savedata.constructable_vehicles[role][type].mod = math.max(g_savedata.constructable_vehicles[role][type].mod + ai_training.punishments[type_reinforcement], 0.05)
				if strategy and strategy_reinforcement then 
					wpDLCDebug("punished strategy:"..strategy.." | amount punished: "..ai_training.punishments[strategy_reinforcement], true, false)
					g_savedata.constructable_vehicles[role][type][strategy].mod = math.max(g_savedata.constructable_vehicles[role][type][strategy].mod + ai_training.punishments[strategy_reinforcement], 0.05)
					if constructable_vehicle_id and vehicle_reinforcement then 
						wpDLCDebug("punished vehicle:"..constructable_vehicle_id.." | amount punished: "..ai_training.punishments[vehicle_reinforcement], true, false)
						g_savedata.constructable_vehicles[role][type][strategy][constructable_vehicle_id].mod = math.max(g_savedata.constructable_vehicles[role][type][strategy][constructable_vehicle_id].mod + ai_training.punishments[vehicle_reinforcement], 0.05)
					end
				end
			end
		end
	elseif reinforcement_type == REWARD then
		if role and role_reinforcement then
			wpDLCDebug("rewarded role:"..role.." | amount rewarded: "..ai_training.rewards[role_reinforcement], true, false)
			g_savedata.constructable_vehicles[role].mod = math.min(g_savedata.constructable_vehicles[role].mod + ai_training.rewards[role_reinforcement], 1.5)
			if type and type_reinforcement then 
				wpDLCDebug("rewarded type:"..type.." | amount rewarded: "..ai_training.rewards[type_reinforcement], true, false)
				g_savedata.constructable_vehicles[role][type].mod = math.min(g_savedata.constructable_vehicles[role][type].mod + ai_training.rewards[type_reinforcement], 1.5)
				if strategy and strategy_reinforcement then 
					wpDLCDebug("rewarded strategy:"..strategy.." | amount rewarded: "..ai_training.rewards[strategy_reinforcement], true, false)
					g_savedata.constructable_vehicles[role][type][strategy].mod = math.min(g_savedata.constructable_vehicles[role][type][strategy].mod + ai_training.rewards[strategy_reinforcement], 1.5)
					if constructable_vehicle_id and vehicle_reinforcement then 
						wpDLCDebug("rewarded vehicle:"..constructable_vehicle_id.." | amount rewarded: "..ai_training.rewards[vehicle_reinforcement], true, false)
						g_savedata.constructable_vehicles[role][type][strategy][constructable_vehicle_id].mod = math.min(g_savedata.constructable_vehicles[role][type][strategy][constructable_vehicle_id].mod + ai_training.rewards[vehicle_reinforcement], 1.5)
					end
				end
			end
		end
	end
end

---@param user_peer_id integer the peer_id of the player who executed the command
---@param role string the role of the vehicle, such as attack, general or defend
---@param type string the vehicle type, such as boat, plane, heli, land or turret
---@param strategy string strategy of the vehicle, such as strafe, bombing or general
---@param constructable_vehicle_id integer the index of the vehicle in the constructable vehicle list
function spawnModifiers.debug(user_peer_id, role, type, strategy, constructable_vehicle_id)
	if not constructable_vehicle_id then
		if not strategy then
			if not type then
				wpDLCDebug("modifier of vehicles with role "..role..": "..g_savedata.constructable_vehicles[role].mod, false, false, user_peer_id)
			else
				wpDLCDebug("modifier of vehicles with role "..role..", with type "..type..": "..g_savedata.constructable_vehicles[role][type].mod, false, false, user_peer_id)
			end
		else
			wpDLCDebug("modifier of vehicles with role "..role..", with type "..type..", with strategy "..strategy..": "..g_savedata.constructable_vehicles[role][type][strategy].mod, false, false, user_peer_id)
		end
	else
		wpDLCDebug("modifier of role "..role..", type "..type..", strategy "..strategy..", with the id of "..constructable_vehicle_id..": "..g_savedata.constructable_vehicles[role][type][strategy][constructable_vehicle_id].mod, false, false, user_peer_id)
	end
end

---@param matrix1 Matrix the first matrix
---@param matrix2 Matrix the second matrix
function xzDistance(matrix1, matrix2) -- returns the distance between two matrixes, ignoring the y axis
	ox, oy, oz = m.position(matrix1)
	tx, ty, tz = m.position(matrix2)
	return m.distance(m.translation(ox, 0, oz), m.translation(tx, 0, tz))
end

---@param player_list Players[] the list of players to check
---@param target_pos Matrix the position that you want to check
---@param min_dist number the minimum distance between the player and the target position
---@param ignore_y boolean if you want to ignore the y level between the two or not
---@return boolean no_players_nearby returns true if theres no players which distance from the target_pos was less than the min_dist
function playersNotNearby(player_list, target_pos, min_dist, ignore_y)
	local players_clear = true
	for player_index, player in pairs(player_list) do
		if ignore_y and xzDistance(s.getPlayerPos(player_index), target_pos) < min_dist then
			players_clear = false
		elseif not ignore_y and m.distance(s.getPlayerPos(player_index), target_pos) < min_dist then
			players_clear = false
		end
	end
	return players_clear
end

---@param T table table to get the size of
---@return number count the size of the table
function tableLength(T)
	if T ~= nil then
		local count = 0
		for _ in pairs(T) do count = count + 1 end
		return count
	else return 0 end
end

---@param x number the number to clamp
---@param min number the minimum value
---@param max number the maximum value
---@return number clamped_x the number clamped between the min and max
function math.clamp(x, min, max)
    return max<x and max or min>x and min or x
end

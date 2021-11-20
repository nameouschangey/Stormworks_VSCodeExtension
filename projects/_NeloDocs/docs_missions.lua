-- Auto generated docs by StormworksLuaDocsGen (https://github.com/Rene-Sackers/StormworksLuaDocsGen)
-- Based on data in: https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y
-- Notice issues/missing info? Please contribute here: https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y, then create an issue on the GitHub repo

--- @diagnostic disable: lowercase-global

server = {}
property = {}
matrix = {}
debug = {}

--- @class Matrix
--- @field [1] number 
--- @field [2] number 
--- @field [3] number 
--- @field [4] number 
--- @field [5] number 
--- @field [6] number 
--- @field [7] number 
--- @field [8] number 
--- @field [9] number 
--- @field [10] number 
--- @field [11] number 
--- @field [12] number 
--- @field [13] number x
--- @field [14] number y
--- @field [15] number z
--- @field [16] number 

--- @class Player
--- @field id number The peer ID of the player (as seen in the server player list)
--- @field name string The name of the player
--- @field admin boolean Whether the player is an admin
--- @field auth boolean Whether the player has auth
--- @field steam_id number The player's Steam ID (convert to string as soon as possible to prevent loss of data)

--- @class Zone
--- @field name string The name of the zone
--- @field transform Matrix The location of the zone
--- @field size number The size of the zone
--- @field radius number The radius of the zone
--- @field type number The shape of the zone (0 = box/1 = sphere/2 = radius)
--- @field tags table<number, string> The tags on the zone

--- @class ZoneSize
--- @field x number The world X coordinate
--- @field y number The world Y coordinate
--- @field z number The world Z coordinate

--- @class AddonData
--- @field name string The name of the addon
--- @field path_id string 
--- @field file_store string 
--- @field location_count number The number of locations in the addon

--- @class LocationData
--- @field name number The name of the location
--- @field tile number The tile name of the location
--- @field env_spawn_count number The amount of environment spawns
--- @field env_mod boolean Whether the location is an environment mod
--- @field component_count number The amount of components in this location

--- @class ComponentData
--- @field name string The name of the component
--- @field display_name string The display name of the component
--- @field type number The type of the component (0 = zone, 1 = object, 2 = character, 3 = vehicle, 4 = flare, 5 = fire, 6 = loot, 7 = button, 8 = animal, 9 = ice, 10 = cargo_zone)
--- @field id number The ID of the component
--- @field dynamic_object_type number The object type of the component (See Object Type)
--- @field tags table<number, string> The tags on the component
--- @field transform Matrix The position of the component
--- @field character_outfit_type number The character outfit type (See Outfit type)

--- @class PathFindPoint
--- @field x number The X coordinate of the pathfinding point
--- @field y number The Y coordinate of the pathfinding point

--- @class VehicleData
--- @field tags_full string The tags as a string (ex. "tag1,tag2,tag3")
--- @field tags table<number, string> The tags of the vehicle
--- @field filename string The file name of the vehicle
--- @field transform Matrix The position of the vehicle
--- @field simulating boolean Whether the vehicle is simulating (loaded) or not
--- @field mass number The mass of the vehicle
--- @field voxels number The voxel count of the vehicle
--- @field characters table<number, number> What characters are seated in the vehicles

--- @class AddonComponent
--- @field tags_full string The tags as a string (ex. "tag1,tag2,tag3")
--- @field tags table<number, string> The tags of the component
--- @field display_name string The display name of the component
--- @field type string The type of the component
--- @field transform Matrix The location of the component
--- @field id number The ID of the component

--- @class TileData
--- @field name string The name of the tile (ex. ...)
--- @field sea_floor number The depth to the sea floor
--- @field cost number The cost of the tile if it's purchaseable
--- @field purchased boolean Whether the tile has been purchased

--- @class CharacterData
--- @field hp number The character's health points
--- @field incapacitated boolean Whether the character is incapacitated
--- @field dead boolean Whether the character is dead
--- @field interactible boolean Whether the character is interactible
--- @field ai boolean Whether the character is AI or not

--- @class GameSettings
--- @field third_person boolean The character's health points
--- @field third_person_vehicle boolean 
--- @field vehicle_damage boolean 
--- @field player_damage boolean 
--- @field npc_damage boolean 
--- @field sharks boolean 
--- @field fast_travel boolean 
--- @field teleport_vehicle boolean 
--- @field rogue_mode boolean 
--- @field auto_refuel boolean 
--- @field megalodon boolean 
--- @field map_show_players boolean 
--- @field map_show_vehicles boolean 
--- @field show_3d_waypoints boolean 
--- @field show_name_plates boolean 
--- @field day_night_length number currently cannot be written to
--- @field sunrise number currently cannot be written to
--- @field sunset number currently cannot be written to
--- @field infinite_money boolean 
--- @field settings_menu boolean 
--- @field unlock_all_islands boolean 
--- @field infinite_batteries boolean 
--- @field infinite_fuel boolean 
--- @field engine_overheating boolean 
--- @field no_clip boolean 
--- @field map_teleport boolean 
--- @field cleanup_vehicle boolean 
--- @field clear_fow boolean make entire map visible. cannot be undone
--- @field vehicle_spawning boolean off by default on dedicated servers
--- @field photo_mode boolean 
--- @field respawning boolean 
--- @field settings_menu_lock boolean Checkbox (un)checks properly for all players but players can still edit the settings regardless of the state set here.
--- @field despawn_on_leave boolean despawn players when they leave the server
--- @field unlock_all_components boolean 

--- Messages player(s) using the in-game chat
--- @param name string The display name of the user sending the message
--- @param message string The message to send the player(s)
--- @param peerID number|nil The peerID of the player you want to message. -1 messages all players. If ignored, it will message all players
function server.announce(name, message, peerID) end

--- Displays a notification for player(s) on the right side of the screen.
--- @param peerID number The peerID of the player you want to message. -1 messages all players
--- @param title string The title of the notification
--- @param message string The message you want to send the player(s)
--- @param notificationType number Changes how the notification looks. Refer to notificationTypes https://cutt.ly/Nmc3SrM
function server.notify(peerID, title, message, notificationType) end

--- Gets a unique ID to be used with other UI functions. Functions similar to a vehicle ID. A UI id can be used for multiple lines and map objects but each popup with a different text or position must have it's own ID
--- @return number ui_ID
function server.getMapID() end

--- Remove any UI type created with this ui_id. If you have drawn multiple lines on the map with one UI id, this command would remove all of them.
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The unique ui id to be removed
function server.removeMapID(peer_id, ui_id) end

--- Add a map marker for the specified peer(s). x, z represent the worldspace location of the marker, since the map is 2D a y coordinate is not required. If POSITION_TYPE is set to 1 or 2 (vehicle or object) then the marker will track the object/vehicle of object_id/vehicle_id and offset the position by parent_local_x, parent_local_z. 
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The unique ui id to use
--- @param position_type number Refer to POSTION_TYPE. Defines what type (object/vehicle) the marker should follow. Or if it should not follow anything. If the vehicle/object that object is set to follow cannot be found, this defaults to 0 meaning it becomes static, when the vehicle/object is reloacated, it reverts back to the previous value. https://cutt.ly/omc3FjC
--- @param marker_type number Refer to MARKER_TYPE https://cutt.ly/Amc3HCb
--- @param x number Refer to World Space. Overrides parent_local_x https://cutt.ly/smc3L3C
--- @param z number Refer to World Space. Overrrides parent_local_z https://cutt.ly/smc3L3C
--- @param parent_local_x number The x offset relative to the parent. Refer to World Space https://cutt.ly/smc3L3C
--- @param parent_local_z number The y offset relative to the parent. Refer to World Space https://cutt.ly/smc3L3C
--- @param vehicle_id number The vehicle to follow if POSITION_TYPE is set to 1. Set to 0 to ignore
--- @param object_id number The object to follow if POSITION_TYPE is set to 2. Set to 0 to ignore
--- @param label string The text that appears when mousing over the icon. Appears like a title
--- @param radius number The radius of the red dashed circle. Only applies if MARKER_TYPE = 8
--- @param hover_label string The text that appears when mousing over the icon. Appears like a subtitle or description
function server.addMapObject(peer_id, ui_id, position_type, marker_type, x, z, parent_local_x, parent_local_z, vehicle_id, object_id, label, radius, hover_label) end

--- 
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The unique ui id to use
function server.removeMapObject(peer_id, ui_id) end

--- 
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The unique ui id to use
--- @param LABEL_TYPE number Refer to LABEL_TYPE (Refer to cells "Types!A16:B31" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @param name string The text that appears on the label
--- @param x number Refer to World Space https://cutt.ly/smc3L3C
--- @param z number Refer to World Space https://cutt.ly/smc3L3C
function server.addMapLabel(peer_id, ui_id, LABEL_TYPE, name, x, z) end

--- 
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The ui id to use
function server.removeMapLabel(peer_id, ui_id) end

--- 
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The ui id to use
--- @param start_matrix table Line start position. Refer to World Space https://cutt.ly/smc3L3C
--- @param end_matrix table Line stop position
--- @param width number Line width
function server.addMapLine(peer_id, ui_id, start_matrix, end_matrix, width) end

--- 
--- @param peer_id number The peer id of the affected player
--- @param ui_id number The ui id to use
function server.removeMapLine(peer_id, ui_id) end

--- Displays a tooltip-like popup either in the world. If the popup does not exist, it will be created.
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number A unique ui_id to be used with this popup. You cannot re-use ui ids for popups, unless they have the same text and position, then they can be used for multiple players.
--- @param name string ? Appears to do nothing. Can be left as an empty string: ""
--- @param is_show boolean If the popup is currently being shown
--- @param text string The text inside the popup. You can fit 13 characters in a line before it will wrap.
--- @param x number X position of the popup. Refer to World Space https://cutt.ly/smc3L3C
--- @param y number Y position of the popup. Refer to World Space https://cutt.ly/smc3L3C
--- @param z number Z position of the popup. Refer to World Space https://cutt.ly/smc3L3C
--- @param render_distance number The distance the popup will be viewable from in meters
--- @param vehicle_parent_id number The vehicle to attach the popup to
--- @param object_parent_id number The object to attach the popup to
function server.setPopup(peer_id, ui_id, name, is_show, text, x, y, z, render_distance, vehicle_parent_id, object_parent_id) end

--- Creates a popup that appears on the player's screen, regardless of their look direction and location in the world.
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number A unique ui_id to be used with this popup. You cannot re-use ui ids for popups. One ui id per popup.
--- @param name string ?
--- @param is_show boolean If the popup is currently being shown
--- @param text string The text inside the popup. You can fit 13 characters in a line before it will wrap.
--- @param horizontal_offset number The offset on the horizontal axis. Ranges from -1 (left) to 1 (right)
--- @param vertical_offset number The offset on the vertical axis. Ranges from -1 (Bottom) to 1(Top)
function server.setPopupScreen(peer_id, ui_id, name, is_show, text, horizontal_offset, vertical_offset) end

--- Will remove popups that have been assigned to a player
--- @param peer_id number The peer id of the affected player. -1 affects all players
--- @param ui_id number The unique ui id to use
function server.removePopup(peer_id, ui_id) end

--- Returns the display name of the player
--- @param peer_id number The peer id of the player
--- @return string name, boolean is_success
function server.getPlayerName(peer_id) end

--- 
--- @return table<number, Player> players
function server.getPlayers() end

--- Returns the position of the requested player as a matrix
--- @param peer_id number The peer id of the player
--- @return table matrix, boolean is_success
function server.getPlayerPos(peer_id) end

--- Moves the player from their current location to the matrix provided
--- @param peer_id number The peer id of the player
--- @param matrix table The matrix that should be applied to the player
--- @return boolean is_success
function server.setPlayerPos(peer_id, matrix) end

--- This can only be called after a user has been in the server for a few seconds. Returns the direction the player is looking in. A player sitting in a seat will have their look direction reported relative to the seat. If the seat is upside down, looking "up" is down relative to the world. math.atan(x,z) will return the heading the player is facing.
--- @param peer_id number The peer id of the player
--- @return number x, number y, number z, boolean is_success
function server.getPlayerLookDirection(peer_id) end

--- Spawns a vehicle that is in an addon
--- @param matrix table The matrix the vehicle should be spawned at
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution.
--- @param component_id number NOT THE COMPONENT_INDEX. The component_id can be found using getLocationComponentData
--- @return number vehicle_id, boolean is_success
function server.spawnAddonVehicle(matrix, addon_index, component_id) end

--- Spawns a vehicle from your vehicle save folder. NOTE: will spawn an "empty" vehicle if a vehicle file cannot be found. It is impossible to distinguish from an actual vehicle server-wise. BUG REPORT
--- @param matrix table The matrix the vehicle should be spawned at
--- @param save_name string The name of the save file to spawn
--- @return number vehicle_id, boolean is_success
function server.spawnVehicle(matrix, save_name) end

--- Despawns a vehicle from the world
--- @param vehicle_id number The unique id of the vehicle
--- @param is_instant boolean If the vehicle should be despawned instantly (true) or when no one is near (false)
--- @return boolean is_success
function server.despawnVehicle(vehicle_id, is_instant) end

--- Returns the position of the vehicle as a matrix
--- @param vehicle_id number The unique id of the vehicle
--- @param voxel_x number 0,0,0 is the center of the vehicle (viewable with the move tool). Each "block" or 0.25m is a different voxel. 0,0.25,0 is one block above the start point.
--- @param voxel_y number 
--- @param voxel_z number 
--- @return table matrix, boolean is_success
function server.getVehiclePos(vehicle_id, voxel_x, voxel_y, voxel_z) end

--- Teleports a vehicle from it's current locaiton to the new matrix
--- @param vehicle_id number The unique id of the vehicle
--- @param matrix table The matrix to be applied to the vehicle
function server.setVehiclePos(vehicle_id, matrix) end

--- Returns the name of the vehicle
--- @param vehicle_id number The unique id of the vehicle
--- @return string name, boolean is_success
function server.getVehicleName(vehicle_id) end

--- Returns info on a vehicle
--- @param vehicle_id number The unique if of the vehicle
--- @return VehicleData vehicle_data, boolean is_success
function server.getVehicleData(vehicle_id) end

--- Removes all vehicles from the world
function server.cleanVehicles() end

--- Allows direct inputs to a chair from addon Lua
--- @param vehicle_id number The unique id of the vehicle
--- @param seat_name string The name of the seat as it apears on the vehicle. Editable using the select tool in the workbench
--- @param axis_ws number The W/S axis as it appears on the chair
--- @param axis_da number The D/A axis as it appears on the chair
--- @param axis_ud number The Up/Down axis as it appears on the chair
--- @param axis_rl number The Right/Left axis as it appears on the chair
--- @param button_1 boolean The chair button 1 state
--- @param button_2 boolean The chair button 2 state
--- @param button_3 boolean The chair button 3 state
--- @param button_4 boolean The chair button 4 state
--- @param button_5 boolean The chair button 5 state
--- @param button_6 boolean The chair button 6 state
function server.setVehicleSeat(vehicle_id, seat_name, axis_ws, axis_da, axis_ud, axis_rl, button_1, button_2, button_3, button_4, button_5, button_6) end

--- Returns the state of a vehicle button
--- @param vehicle_id number The unique id of the vehicle
--- @param button_name string The name of the button as it appears on the vehicle. Editable using the select tool in the workbench
--- @return boolean is_on, boolean is_success
function server.getVehicleButton(vehicle_id, button_name) end

--- Presses a button on a vehicle. Warning, can cause massive lag. LAG BUG REPORT Also note: Static vehicles can output values even when not powered BUG REPORT
--- @param vehicle_id number The unique id of the vehicle
--- @param button_name string The name of the button as it appears on the vehicle. Editable using the select tool in the workbench
function server.pressVehicleButton(vehicle_id, button_name) end

--- Sets a keypad's value
--- @param vehicle_id number The unique id of the vehicle
--- @param keypad_name string The name of the keypad as it appears on the vehicle. Editable using the select tool in the workbench
--- @param value number The value you want to set the keypad to
function server.setVehicleKeypad(vehicle_id, keypad_name, value) end

--- Returns the value of the specified dial
--- @param vehicle_id number The unique id of the vehicle
--- @param dial_name string The name of the dial as it appears on the vehicle. Editable using the select tool in the workbench
--- @return number value, boolean is_success
function server.getVehicleDial(vehicle_id, dial_name) end

--- Returns the amount of liters in the tank
--- @param vehicle_id number The unique id of the vehicle
--- @param tank_name string The name of the fuel tank as it appears on the vehicle. Editable using the select tool in the workbench
--- @return number tank_level, number tank_capacity, boolean is_success
function server.getVehicleTank(vehicle_id, tank_name) end

--- Fills a fluid tank with the specified liquid
--- @param vehicle_id number The unique id of the vehicle
--- @param tank_name string The name of the tank as it appears on the vehicle. Editable using the select tool in the workbench
--- @param amount number The amount you want to fill the tank in litres * 10 (example: 10 -> fills tank to 100L)
--- @param FLUID_TYPE number Refer to FLUID_TYPE (Refer to cells "Types!A173:B173" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
function server.setVehicleTank(vehicle_id, tank_name, amount, FLUID_TYPE) end

--- Gets a vehicle's sign voxel location
--- @param vehicle_id number The unique ID of the vehicle to get the sign on
--- @param sign_name number The name of the sign to get
--- @return boolean is_success, number voxel_x, number voxel_y, number voxel_z
function server.getVehicleSign(vehicle_id, sign_name) end

--- Sets the number of coal objects inside a hopper
--- @param vehicle_id number The vehicle ID to set the hopper on
--- @param hopper_name string The name of the hopper to set
--- @param amount number The amount to set the hopper to
function server.setVehicleHopper(vehicle_id, hopper_name, amount) end

--- Returns the coal count for the specified hopper
--- @param vehicle_id number The vehicle ID to get the hopper from
--- @param hopper_name string The name of the hopper to get
--- @return number coal_level, number hopper_capacity, boolean is_success
function server.getVehicleHopper(vehicle_id, hopper_name) end

--- Returns the charge level of the battery
--- @param vehicle_id number The unique id of the vehicle
--- @param battery_name string The name of the battery as it appears on the vehicle. Editable using the select tool in the workbench
--- @return number value, boolean is_success
function server.getVehicleBattery(vehicle_id, battery_name) end

--- Sets the charge level of the battery
--- @param vehicle_id number The unique id of the vehicle
--- @param battery_name string The name of the battery as it appears on the vehicle. Editable using the select tool in the workbench
--- @param amount number The amount you want to fill the battery to
function server.setVehicleBattery(vehicle_id, battery_name, amount) end

--- Returns the amount of surfaces that are on fire
--- @param vehicle_id number The unique id of the vehicle
--- @return number surface_count, boolean is_success
function server.getVehicleFireCount(vehicle_id) end

--- Only works on vehicles where "show on map" is off. Shows the text when looked directly at. Blocks with unique tooltips such as buttons will override this tooltip
--- @param vehicle_id number The unique id of the vehicle
--- @param text string The text that will appear in the tooltip
--- @return boolean is_success
function server.setVehicleTooltip(vehicle_id, text) end

--- Returns whether the specified vehicle has finished loading and is simulating. 
--- @param vehicle_id number The unique id of the vehicle
--- @return boolean is_simulating, boolean is_success
function server.getVehicleSimulating(vehicle_id) end

--- Will set the vehicle's transponder state. If a transponder does not exist on the vehicle, an invisible one will be created.
--- @param vehicle_id number The unique id of the vehicle
--- @param is_active boolean Turns the transponder on/off
--- @return boolean is_success
function server.setVehicleTransponder(vehicle_id, is_active) end

--- Allows a vehicle to be edited. NOTE: the vehicle will only be editable when next to a workbench. You can see it on the map but cannot teleport or remove it. BUG REPORT
--- @param vehicle_id number The unique id of the vehicle
--- @param is_editable boolean Sets whether or not the vehicle is able to be edited
--- @return boolean is_success
function server.setVehicleEditable(vehicle_id, is_editable) end

--- Applies impact damage to a vehicle at the specified voxel location
--- @param vehicle_id number The ID of the vehicle to apply damage to
--- @param amount number The amount of damage to apply (0-100)
--- @param voxel_x number The voxel's X position to apply damage to
--- @param voxel_y number The voxel's Y position to apply damage to
--- @param voxel_z number The voxel's Z position to apply damage to
--- @return boolean is_success
function server.addDamage(vehicle_id, amount, voxel_x, voxel_y, voxel_z) end

--- Sets a vehicle to show on the map
--- @param vehicle_id number The ID of the vehicle to show/hide on map
--- @param is_show_on_map boolean Whether to show/hide the vehicle on the map
--- @return boolean is_success
function server.setVehicleShowOnMap(vehicle_id, is_show_on_map) end

--- Returns the id of the player's character
--- @param peer_id number The peer id of the player
--- @return number object_id, boolean is_success
function server.getPlayerCharacterID(peer_id) end

--- Spawns an object at the specified matrix
--- @param matrix table The matrix that the object should be spawned at
--- @param object_type number Refer to OBJECT_TYPE (Refer to cells "Types!A90:B90" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @return number object_id, boolean is_success
function server.spawnObject(matrix, object_type) end

--- Spawns a fire at the given matrix. Can spawn explosions
--- @param matrix table The matrix the fire will be spawned at
--- @param size number The size of the fire (0-10)
--- @param magnitude number -1 explodes instantly. Nearer to 0 means the explosion takes longer to happen. Must be below 0 for explosions to work.
--- @param is_lit boolean Lights the fire. If the magnitude is >1, this will need to be true for the fire to first warm up before exploding.
--- @param is_explosive boolean If the fire is explosive
--- @param parent_vehicle_id number Can be 0 or nil. When given a vehicle id, the fire will follow the given vehicle.
--- @param explosion_magnitude number The size of the explosion (0-5)
--- @return number object_id, boolean is_success
function server.spawnFire(matrix, size, magnitude, is_lit, is_explosive, parent_vehicle_id, explosion_magnitude) end

--- Spawns an NPC.
--- @param matrix table The matrix the character will be spawned at
--- @param outfit_id number Refer to OUTFIT_TYPE. If is_interactable is false, outfit_id is the name that shows up when looking at the NPC . This is the only place to give the character a name. (Refer to cells "Types!A155:B155" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @return number object_id, boolean is_success
function server.spawnCharacter(matrix, outfit_id) end

--- Spawns an animal (penguin, shark, etc.)
--- @param matrix table The matrix the animal will be spawned at
--- @param animal_type number Refer to ANIMAL_TYPE (Refer to cells "Types!A168:B168" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @param size_multiplier number The scale multiplier of the animal
--- @return number object_id, boolean is_success
function server.spawnAnimal(matrix, animal_type, size_multiplier) end

--- Despawns objects. Can be used on characters and animals.
--- @param object_id number The unique id of the object/character/animal to be despawned
--- @param is_instant boolean If the object should be despawned instantly (true) or when no one is near (false)
--- @return boolean is_success
function server.despawnObject(object_id, is_instant) end

--- Get the positon of an object/character/animal
--- @param object_id number The unique id of the object/character/animal
--- @return Matrix matrix, boolean is_success
function server.getObjectPos(object_id) end

--- Sets the position of an object/character/animal
--- @param object_id number The unique id of the object/character/animal
--- @param matrix table The matrix to be applied to the object/character/animal
--- @return boolean is_success
function server.setObjectPos(object_id, matrix) end

--- Sets the position of an object/character/animalGet the simulating state of a specified object
--- @param object_id number The unique id of the object/character/animal
--- @return boolean is_simulating, boolean is_success
function server.getObjectSimulating(object_id) end

--- Sets the parameters for a fire
--- @param object_id number The unique id of the fire
--- @param is_lit boolean If the fire is ignited
--- @param is_explosive boolean If the fire is explosive
function server.setFireData(object_id, is_lit, is_explosive) end

--- Returns the is_lit parameter of a fire
--- @param object_id number The unique id of the fire
--- @return boolean is_lit, boolean is_success
function server.getFireData(object_id) end

--- Kills the given character
--- @param object_id number The unique object_id of the character you want to kill
function server.killCharacter(object_id) end

--- Revives the given character
--- @param object_id number The unique object_id of the character you want to revive
function server.reviveCharacter(object_id) end

--- Makes the provided character sit in the first seat found that has a matching name to that which is provided. Can seat player characters
--- @param object_id number The unique object_id of the character you want to seat
--- @param vehicle_id number The vehicle that the seat is a part of
--- @param seat_name string The name of the seat as it appears on the vehicle. Editable using the select tool in the workbench.
function server.setCharacterSeated(object_id, vehicle_id, seat_name) end

--- Returns the various parameters of the provided character
--- @param object_id number The unique object_id of the character you want to get data on
--- @return CharacterData character_data
function server.getCharacterData(object_id) end

--- Sets the various parameters of a character
--- @param object_id number The unique id of the character/object/animal to be affected
--- @param hp number Value from 0 to 100. Has no effect on objects. Value will still be saved regardless. While is_interactable is false, hp can be any value.
--- @param is_interactable boolean If this is false you cannot pickup or ask the character to follow. Their name will be outfit_id which can't be set here (must be set at spawnCharacter)
--- @param is_ai boolean lets the character do seat controls
function server.setCharacterData(object_id, hp, is_interactable, is_ai) end

--- Set the equipment a character has
--- @param object_id number The unique id of the character
--- @param slot number Refer to Character Slots https://cutt.ly/nmc3m02
--- @param EQUIPMENT_ID number Refer to EQUIPMENT_ID https://cutt.ly/7mc3IIN
--- @param is_active boolean Activates equipment such as strobe lights and fire exstinguishers.
--- @param integer_value number|nil Depending on the item, sets the integer value (charges, ammo, channel, etc.). See: Items int/float https://cutt.ly/7mc9QDb
--- @param float_value number|nil Depending on the item, sets the float value (ammo, battery, etc.). See: Items int/float https://cutt.ly/7mc9QDb
--- @return boolean is_success
function server.setCharacterItem(object_id, slot, EQUIPMENT_ID, is_active, integer_value, float_value) end

--- Returns the id of the equipment that the character has in the provided slot
--- @param object_id number The unique id of the character to check
--- @param SLOT_NUMBER number The slot to check on the character (Refer to cells "Returned Tables!A14:C14" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @return number equipment_id, boolean is_success
function server.getCharacterItem(object_id, SLOT_NUMBER) end

--- Get the current vehicle_id for a specified character object
--- @param object_id number The unique id of the character
--- @return number vehicle_id, boolean is_success
function server.getCharacterVehicle(object_id) end

--- Gets the target destination for an AI
--- @param object_id number The unique ID of the character object ID
--- @return number target_x, number target_y, number target_z
function server.getAITarget(object_id) end

--- Sets the AI state of a character
--- @param object_id number The unique id of the character
--- @param AI_STATE number 0 = none, 1 = path to destination
function server.setAIState(object_id, AI_STATE) end

--- Sets the target destination for the AI
--- @param object_id number The unique id of the character
--- @param matrix_destination table The matrix that the AI will try to reach
function server.setAITarget(object_id, matrix_destination) end

--- Get the internal index of an active addon (useful if you want to spawn objects from another script). Omitting the name argument will return this addon's index
--- @param name string|nil The name of the addon as it appears in xml file. Not the filename
--- @return number addon_index, boolean is_success
function server.getAddonIndex(name) end

--- Get the internal index of a location in the specified addon by its name (this index is local to the addon)
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution.
--- @param name string The name of the location as it appears in the addon
--- @return number location_index
function server.getLocationIndex(addon_index, name) end

--- The name of the location as it appears in the addon
--- @param name string 
--- @return boolean is_success
function server.spawnThisAddonLocation(name) end

--- Spawn a mission location at the given matrix
--- @param matrix table Matrix the mission location should spawn at. 0,0,0 matrix will spawn at a random location of the tile's type.
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution.
--- @param location_index number The index of the location as it appears in the addon.
--- @return Matrix matrix, boolean is_success
function server.spawnAddonLocation(matrix, addon_index, location_index) end

--- Get the filepath of a addon
--- @param addon_name string The name of the addon as it appears in the save file
--- @param is_rom boolean Only true for missions that are made by the developers (or at least put in the file path "Stormworks\rom\data\missions")
--- @return string path, boolean is_success
function server.getAddonPath(addon_name, is_rom) end

--- Returns a list of all env mod zones
--- @param tag string|nil Returns a list of all env mod zones that match the tag(s). Example: server.getZones("type=car,arctic")  Returns all zones that have exactly type=car AND arctic in it's tags
--- @return table<number, Zone> ZONE_LIST
function server.getZones(tag) end

--- Returns whether the matrix is within an env mod zone that matches the display name
--- @param matrix table The matrix to check
--- @param zone_display_name string The environment mod zone to test the matrix against
--- @return boolean is_in_zone, boolean is_success
function server.isInZone(matrix, zone_display_name) end

--- 
--- @param matrix table The matrix the mission object should be spawned at
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution.
--- @param location_index number The unique index of the location that the component is in
--- @param component_index number The index of the component that can be read from the COMPONENT_DATA table using server.getLocationComponentData()
--- @return AddonComponent component, boolean is_success
function server.spawnAddonComponent(matrix, addon_index, location_index, component_index) end

--- Returns the amount of addons that are enabled on this save
--- @return number count
function server.getAddonCount() end

--- Returns data about the addon
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution. INDEX STARTS AT 0
--- @return AddonData addon_data
function server.getAddonData(addon_index) end

--- Returns data on a specific location in the addon
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution. INDEX STARTS AT 0
--- @param location_index number The index of the location as it is found in the missions folder. There is no set order and it may not be the same next execution. INDEX STARTS AT 0
--- @return LocationData location_data, boolean is_success
function server.getLocationData(addon_index, location_index) end

--- Returns data on a specific mission component. returned data includes component_id which can be used with server.spawnVehicle()
--- @param addon_index number The index of the addon as it is found in the missions folder. There is no set order and it may not be the same next execution. INDEX STARTS AT 0
--- @param location_index number The index of the location in the addon
--- @param component_index number The index of the component in the addon
--- @return ComponentData component_data, boolean is_success
function server.getLocationComponentData(addon_index, location_index, component_index) end

--- Returns the world position of a random ocean tile within the selected search range
--- @param matrix table The matrix to start the search at
--- @param min_search_range number The mininum search range relative to the provided matrix. In meters
--- @param max_search_range number The maximum search range relative to the provided matrix. In meters
--- @return Matrix matrix, boolean is_success
function server.getOceanTransform(matrix, min_search_range, max_search_range) end

--- Returns the world position of a random tile of type tile_name closest to the supplied location
--- @param transform_matrix table The matrix to find the tile near
--- @param tile_name string The name of the tile to find
--- @param search_radius number|nil The radius in which to find the tile. Max is 50000
--- @return Matrix transform_matrix, boolean is_success
function server.getTileTransform(transform_matrix, tile_name, search_radius) end

--- Returns the data for th tile at the specified location
--- @param transform table The matrix to get the tile data for
--- @return table tile_data, boolean is_success
function server.getTile(transform) end

--- Returns whether the object transform is within a custom zone of the selected size
--- @param matrix_object table The matrix of the object
--- @param matrix_zone table The matrix of the zone to search within
--- @param zone_size_x number The size of the zone. Refer to World Space https://cutt.ly/smc3L3C
--- @param zone_size_y number The size of the zone. Refer to World Space https://cutt.ly/smc3L3C
--- @param zone_size_z number The size of the zone. Refer to World Space https://cutt.ly/smc3L3C
--- @return boolean is_in_area
function server.isInTransformArea(matrix_object, matrix_zone, zone_size_x, zone_size_y, zone_size_z) end

--- Returns a table of ocean tile waypoints that form a path from start to end
--- @param matrix_start table The starting point of the path. Refer to World Space https://cutt.ly/smc3L3C
--- @param matrix_end table The ending point of the path. Refer to World Space https://cutt.ly/smc3L3C
--- @return table<number, PathFindPoint> position_list
function server.pathfindOcean(matrix_start, matrix_end) end

--- Adds a checkbox to the settings of the addon
--- @param text string The text to show on the checkbox
--- @param default_value boolean The default value of the checkbox
--- @return boolean value
function property.checkbox(text, default_value) end

--- Adds a slider to the settings of the addon
--- @param text string The text to show on the checkbox
--- @param min number The min value of the slider
--- @param max number The max value of the slider
--- @param increment number The increment of the slider (step size)
--- @param default_value number The default value of the slider
--- @return number value
function property.slider(text, min, max, increment, default_value) end

--- Used to set game settings
--- @param GAME_SETTING string Refer to Game Settings (Refer to cells "null!A1" on https://docs.google.com/spreadsheets/d/1joiH8eu6LOE76lL0ijNoUe-3VsVDfMkAnfHY-trCt9Y)
--- @param value boolean The game setting state. True or False
function server.setGameSetting(GAME_SETTING, value) end

--- Returns a table of the game settings indexed by the GAME_SETTING string, this can be accessed inline eg. server.getGameSettings().third_person
--- @return GameSettings game_settings
function server.getGameSettings() end

--- Used to set the money and research points for the player
--- @param money number How much money the player will have
--- @param research_points number How many research points the player will have
function server.setCurrency(money, research_points) end

--- Returns how much money the player has
--- @return number money
function server.getCurrency() end

--- Returns how many research points the player has
--- @return number research_points
function server.getResearchPoints() end

--- Returns how many days the player has survived
--- @return number days_survived
function server.getDateValue() end

--- Gets the current game date
--- @return number d, number m, number y
function server.getDate() end

--- Returns the time the save has been running for in milliseconds
--- @return number time_millisec
function server.getTimeMillisec() end

--- Returns whether the tile at the given world coordinates is player owned
--- @param matrix table The matrix the tile can be found at. Doesn't have to be exact, just has to be within the tile.
--- @return boolean is_purchased
function server.getTilePurchased(matrix) end

--- Limited to one request per 2 ticks (32 requests/s). Any additional requests will be queued
--- @param port number The port you are making the request on
--- @param request string The URL to make the request to.
function server.httpGet(port, request) end

--- Bans a player from your server. There is no way to unban players from that save, choose wisely! A new save will have to be created before a banned player can rejoin.
--- @param peer_id number The peer id of the affected player
function server.banPlayer(peer_id) end

--- Kicks a player from your server. They can rejoin
--- @param peer_id number The peer id of the affected player. Kicking -1 will kick the host, closing the server.
function server.kickPlayer(peer_id) end

--- Makes a player an admin. (Able to kick, ban, auth)
--- @param peer_id number The peer id of the affected player
function server.addAdmin(peer_id) end

--- Removes the admin permissions from a player
--- @param peer_id number The peer id of the affected player
function server.removeAdmin(peer_id) end

--- Gives a player the ability to spawn in vehicles and edit unlocked game settings
--- @param peer_id number The peer id of the affected player
function server.addAuth(peer_id) end

--- Remove the auth permissions from a player
--- @param peer_id number The peer id of the affected player
function server.removeAuth(peer_id) end

--- Multiplies two matrices together
--- @param matrix1 table 
--- @param matrix2 table 
--- @return Matrix matrix
function matrix.multiply(matrix1, matrix2) end

--- Inverts the matrix
--- @param matrix table 
--- @return Matrix matrix
function matrix.invert(matrix) end

--- Transposes a matrix
--- @param matrix table 
--- @return Matrix matrix
function matrix.transpose(matrix) end

--- Returns an identity matrix
--- @return Matrix matrix
function matrix.identity() end

--- Converts radians to the x axis rotation in a matrix. Doesn't rotate the orientation. Rotates the point around the center of the world (0,0,0)
--- @param radians number The angle in radians you want to convert
--- @return Matrix matrix
function matrix.rotationX(radians) end

--- Converts radians to the y axis rotation in a matrix
--- @param radians number The angle in radians you want to convert
--- @return Matrix matrix
function matrix.rotationY(radians) end

--- Converts radians to the z axis rotation in a matrix
--- @param radians number The angle in radians you want to convert
--- @return Matrix matrix
function matrix.rotationZ(radians) end

--- Returns your x,y,z points as a matrix
--- @param x number 
--- @param y number 
--- @param z number 
--- @return Matrix matrix
function matrix.translation(x, y, z) end

--- Returns x,y,z when given a matrix
--- @param matrix table returns the location tuplets from the matrix provided. this is the same as MATRIX[13],MATRIX[14],MATRIX[15]
--- @return number x, number y, number z
function matrix.position(matrix) end

--- Returns the distance in meters between two matrices in 3D space
--- @param matrix1 table The first matrix
--- @param matrix2 table The second matrix
--- @return number dist
function matrix.distance(matrix1, matrix2) end

--- Multiplies a matrix by a vec 4.
--- @param matrix1 table The matrix to multiply
--- @param x number 
--- @param y number 
--- @param z number 
--- @param w number 
--- @return number out_x, number out_y, number out_z, number out_w
function matrix.multiplyXYZW(matrix1, x, y, z, w) end

--- Returns the rotation required to face an X Z vector
--- @param x number 
--- @param z number 
function matrix.rotationToFaceXZ(x, z) end

--- Get whether the game considers the tutorial active (Default missions check this before they spawn)
--- @return boolean tutorial_completed
function server.getTutorial() end

--- Sets whether the game considers the tutorial active (useful if you are making your own tutorial)
function server.setTutorial() end

--- Returns whether or not the user has been informed of the video tutorials that are on the main menu and pause screen.
--- @return boolean user_notified
function server.getVideoTutorial() end

--- Returns true of the host player is a developer of the game.
--- @return boolean is_dev
function server.isDev() end

--- Log a message to the console output
--- @param message string The string to log
function debug.log(message) end


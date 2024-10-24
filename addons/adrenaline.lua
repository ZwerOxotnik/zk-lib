--[[
Copyright (c) 2019-2021 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/adrenaline
Mod portal: https://mods.factorio.com/mod/adrenaline
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64617&p=395994

]]--

-- TODO: optimize!

local bonus_modifier = settings.global["adrenaline_bonus_modifier"].value or 2
local module = {}

local function reset_player_data(player)
	local player_modifiers_data = storage.adrenaline.players_modifiers[player.index]
	if player_modifier == nil then return end

	local value1 = player_modifiers_data.character_mining_speed_modifier
	if value1 then
		player.character_mining_speed_modifier = value1
	end
	local value = player_modifiers_data.character_running_speed_modifier
	if value then
		player.character_running_speed_modifier = value
	end
	player_modifier = nil
end

-- local function reset_force_data(name)
-- 	local force_modifier = storage.adrenaline.forces_modifiers[name]
-- 	if not force_modifier then return end

-- 	local force = game.forces[name]
-- 	if force then
-- 		for ammo_category, _ in pairs( prototypes.ammo_category ) do
-- 			if force_modifier.guns_speed[ammo_category] then
-- 				force.set_gun_speed_modifier(ammo_category, force_modifier.guns_speed[ammo_category])
-- 			end
-- 		end
-- 	else
-- 		force_modifier = nil
-- 	end
-- end

-- TODO: refactor
local function check_health(player)
	local character = player.character
	local health_ratio = character.get_health_ratio()
	if health_ratio > 0.1 then
		reset_player_data(player)
		return
	end

	local player_index = player.index
	local players_modifiers = storage.adrenaline.players_modifiers
	if players_modifiers[player_index] == nil then
		-- if #game.connected_players == 1 then
		-- 	adrenaline.forces_modifiers[force.name] = {}
		-- 	adrenaline.forces_modifiers[force.name].guns_speed = {}
		-- 	local guns_speed = adrenaline.forces_modifiers[force.name].guns_speed
		-- 	for name, _ in pairs( prototypes.ammo_category ) do
		-- 		guns_speed[name] = force.get_gun_speed_modifier(name)
		-- 	end
		-- end

		players_modifiers[player_index] = {}
		local player_modifiers_data = players_modifiers[player_index]
		player_modifiers_data.character_mining_speed_modifier = player.character_mining_speed_modifier
		player_modifiers_data.character_running_speed_modifier = player.character_running_speed_modifier
	end

	local init_player_modifiers = players_modifiers[player_index]
	local modifier = (1 - health_ratio * 10) * bonus_modifier
	character.character_running_speed_modifier = init_player_modifiers.character_mining_speed_modifier + modifier
	character.character_mining_speed_modifier = init_player_modifiers.character_running_speed_modifier + modifier

	-- local force_modifier = adrenaline.forces_modifiers[force.name]
	-- if force_modifier then
	-- 	local init_guns_speed = force_modifier.guns_speed
	-- 	for name, _ in pairs( prototypes.ammo_category ) do
	-- 		if init_guns_speed[name] then
	-- 			force.set_gun_speed_modifier(name, init_guns_speed[name] + modifier)
	-- 		end
	-- 	end
	-- 	force.set_gun_speed_modifier("melee", init_guns_speed["melee"] + modifier * 2)
	-- end
end

-- local function check_forces_data()
-- 	local adrenaline = storage.adrenaline
-- 	for _, force in pairs( game.forces ) do
-- 		local connected_players = force.connected_players
-- 		if #connected_players == 1 and adrenaline.players_modifiers[connected_players[1].index] then
-- 			reset_force_data(force.name)
-- 		end
-- 	end
-- end

local function check_all_players()
	for _, player in pairs( game.connected_players ) do
		if player.character then
			check_health(player)
		end
	end
end

local function on_player_joined_game(event)
	-- Validation of data
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	-- if #player.force.connected_players ~= 1 then
	-- 	reset_force_data(player.force.name)
	-- end

	if player.character then
		check_health(player)
	end
end

local function on_player_left_game(event)
	-- Validation of data
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end
	reset_player_data(player)
end

-- local function on_forces_merging(event)
-- 	local adrenaline = storage.adrenaline
-- 	adrenaline.forces_modifiers[event.source.name] = nil
-- 	local connected_players = #event.source.connected_players + #event.destination.connected_players
-- 	if connected_players ~= 1 then
-- 		reset_force_data(event.destination.name)
-- 	end
-- end

-- local function on_player_changed_force(event)
-- 	-- Validation of data
-- 	local player = game.get_player(event.player_index)
-- 	if not (player and player.valid) then return end

-- 	if #event.force.connected_players == 0 then
-- 		reset_force_data(event.force.name)
-- 	end
-- end

local function on_runtime_mod_setting_changed(event)
	-- if event.setting_type ~= "runtime-global" then return end

	if event.setting == "adrenaline_bonus_modifier" then
		bonus_modifier = settings.global[event.setting].value
	end
end

module.on_init = function()
	storage.adrenaline = storage.adrenaline or {}
	local data = storage.adrenaline
	data.players_modifiers = data.players_modifiers or {}
	-- data.forces_modifiers = data.forces_modifiers or {} -- it's not safe for MP
end

module.disable_addon = function()
	for _, player in pairs(game.players) do
		if player.valid then
			reset_player_data(player)
		end
	end
end

module.get_default_events = function()
	local events = {
		[defines.events.on_player_joined_game] = on_player_joined_game,
		[defines.events.on_player_left_game] = on_player_left_game,
		-- [defines.events.on_forces_merging] = on_forces_merging,
		-- [defines.events.on_player_changed_force] = on_player_changed_force,
		[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
	}

	local on_nth_tick = {
		[15] = check_all_players
		-- [700] = check_forces_data
	}

	return events, on_nth_tick
end

return module

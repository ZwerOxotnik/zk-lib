--[[
Copyright 2019-2021 ZwerOxotnik <zweroxotnik@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
]]--

-- You can write and receive any information on the links below.
-- Source: https://github.com/ZwerOxotnik/teams
-- Mod portal: https://mods.factorio.com/mod/teams-zo
-- Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=73013

local module = {}
module.self_events = require('addons/teams-zo/self_events')
local prohibited_forces = {neutral = true, player = true, enemy = true}

-- local function clear_player_data(event)
-- 	global.teams.players[event.player_index] = nil
-- end

local function trim(s)
	return s:match'^%s*(.*%S)' or ''
end

local function team_list_command(cmd)
	if cmd.player_index == 0 then
		for name, _ in pairs(game.forces) do
			print(name)
		end
		return
	end

	local caller = game.players[cmd.player_index]
	if not (caller and caller.valid) then return end

	local function get_forces(forces)
		local list = ""
		for _, force in pairs(forces) do
			if #force.players > 0 then
				list = list .. force.name .. '(' .. #force.connected_players .. '/' .. #force.players ')' .. ' '
			else
				list = list .. force.name .. ' '
			end
		end
		return list
	end

	local ally_forces = {}
	local neutral_forces = {}
	local enemy_forces = {}

	local caller_force = caller.force
	for _, force in pairs(game.forces) do
		if force ~= caller_force then
			if caller_force.get_friend(force) then
				ally_forces[#ally_forces + 1] = force
			elseif caller_force.get_cease_fire(force) then
				neutral_forces[#ally_forces + 1] = force
			else
				enemy_forces[#ally_forces + 1] = force
			end
		end
	end

	caller.print({"", "[font=default-large-bold][color=#FFFFFF]", {"gui-map-editor-title.force-editor"}, {"colon"}, " for \"" .. caller.force.name .. "\"[/color][/font]"})
	if #enemy_forces > 0 then
		caller.print({"", "  [font=default-large-bold][color=#880000]Enemies[/color][/font]", {"colon"}, ' ', get_forces(enemy_forces)})
	end
	if #neutral_forces > 0 then
		caller.print({"", "  [font=default-large-bold]Neutrals[/font]", {"colon"}, ' ', get_forces(neutral_forces)})
	end
	if #ally_forces > 0 then
		caller.print({"", "  [font=default-large-bold][color=green]Allies[/color][/font]", {"colon"}, ' ', get_forces(ally_forces)})
	end
end

local function show_team_command(cmd)
	if cmd.player_index == 0 then print("This command isn't suitable from server yet") return end
	local caller = game.players[cmd.player_index]
	if not (caller and caller.valid) then return end
	if cmd.parameter == nil then
		cmd.parameter = caller.force.name
	elseif #cmd.parameter > 50 then
		caller.print("Can't show because the team name is too long")
		return
	else
		cmd.parameter = trim(cmd.parameter)
	end

	local target_force = game.forces[cmd.parameter]
	if target_force == nil then
		caller.print("Can't find target force")
		return
	end

	local function get_players(force)
		local list = ""
		local count = 0
		for _, player in pairs(force.connected_players) do
			list = list .. player.name .. ' '
			count = count + 1
			if count > 40 then
				return list .. " +" .. tostring(#force.players - 40)
			end
		end
		for _, player in pairs(force.players) do
			if player.connected == false then
				list = list .. player.name .. ' '
				count = count + 1
				if count > 40 then
					return list .. " +" .. tostring(#force.players - 40)
				end
			end
		end
		return list
	end

	caller.print({"", {"gui-browse-games.games-headers-players"}, {"colon"}, ' ', get_players(target_force)})
end

local function kick_teammate_command(cmd)
	if cmd.player_index == 0 then print("This command isn't suitable from server yet") return end
	local caller = game.players[cmd.player_index]
	if not (caller and caller.valid) then return end
	if cmd.parameter == nil then caller.print({"", "/kick-teammate ", module.commands.kick_teammate.description}) return end
	if #cmd.parameter > 30 then
		caller.print("Such long name can't exist in Factorio")
		return
	end

	cmd.parameter = trim(cmd.parameter)
	local target_player = game.get_player(cmd.parameter)
	if not (target_player and target_player.valid) then caller.print("Can't do that") return end

	local player_force = game.forces["player"]
	if not (player_force and player_force.valid) then
		caller.print("Can't kick anybody because \"player\" force doesn't exist")
		return
	end

	if caller.admin then
		game.print(cmd.parameter .. " was kicked from \"" .. target_player.force.name .. "\" team by" .. caller.name)
		target_player.force = player_force
		script.raise_event(module.self_events.on_kick, {player_index = target_player.index, kicker = caller.index})
	elseif caller.force == target_player.force then
		if caller.force.players[1] == caller then
			game.print(cmd.parameter .. " was kicked from \"" .. target_player.force.name .. "\" team by" .. caller.name)
			target_player.force = player_force
			script.raise_event(module.self_events.on_kick, {player_index = target_player.index, kicker = caller.index})
		else
			caller.print("You don't have such permissions")
		end
	else
		caller.print("You can't kick a player from another force")
	end
end

local function create_new_team_command(cmd)
	if cmd.player_index == 0 then print("This command isn't suitable from server yet") return end
	local caller = game.players[cmd.player_index]
	if not (caller and caller.valid) then return end
	-- for compability with other mods/scenarios and forces count max = 64 (https://lua-api.factorio.com/0.17.54/LuaGameScript.html#LuaGameScript.create_force)
	if #game.forces >= 60 then caller.print({"teams.too_many"}) return end
	if cmd.parameter == nil then
		caller.print({"", "/create-team ", module.commands.create_team.description})
		return
	elseif #cmd.parameter > 35 then
		caller.print("Can't create new team because the team name is too long")
		return
	end
	cmd.parameter = trim(cmd.parameter)

	if game.forces[cmd.parameter] then
		caller.print({"teams.double_team", cmd.parameter})
	else
		local new_team = game.create_force(cmd.parameter)
		if #caller.force.players == 1 and not prohibited_forces[caller.force.name] then
			game.merge_forces(caller.force, new_team)
		else
			caller.force = new_team
		end
	end
end

local function remove_team_command(cmd)
	if cmd.player_index == 0 then print("This command isn't suitable from server yet") return end
	local caller = game.players[cmd.player_index]
	if not (caller and caller.valid) then return end
	if caller.admin == false then caller.print({"command-output.parameters-require-admin"}) return end
	if cmd.parameter == nil then
		caller.print({"", "/remove-team ", module.commands.remove_team.description})
		return
	elseif #cmd.parameter > 50 then
		caller.print("Can't remove the team because the team name is too long")
		return
	end
	cmd.parameter = trim(cmd.parameter)

	local target_force = game.forces[cmd.parameter]
	if target_force == nil then
		caller.print({"", "Can't find ", {"colon"}, ' ', cmd.parameter})
	elseif #target_force.players ~= 0 then
		caller.print("This forces isn't empty. There are still players in it")
	elseif prohibited_forces[target_force.name] then
		caller.print("You can't delete '" .. target_force.name .. "'")
	else
		local player_force = game.forces["player"]
		if player_force and player_force.valid then
			game.merge_forces(target_force, player_force)
		else
			caller.print("Can't delete '" .. cmd.parameter .."' because \"player\" force doesn't exist")
		end
	end
end

-- local function update_global_data()
-- 	global.teams = global.teams or {}
-- 	local data = global.teams
-- 	-- data.teams = data.teams or {}
-- 	-- data.players = data.players or {}
-- 	-- data.settings = data.settings or {}
-- end
-- module.on_init = update_global_data
-- module.on_configuration_changed = update_global_data

remote.remove_interface("zo-teams-core")
remote.add_interface("zo-teams-core", {
  get_event_name = function(name)
    return module.self_events[name]
  end
})

-- module.get_default_events = function()
-- 	local events = {}
-- 	local on_nth_tick = {}

-- 	return events, on_nth_tick
-- end

module.commands = {
	create_team = {name = "create-team", description = {"teams.create-team"}, func = create_new_team_command},
	remove_team = {name = "remove-team", description = {"teams.remove-team"}, func = remove_team_command},
	team_list = {name = "team-list", description = {"teams.team-list"}, func = team_list_command},
	show_team = {name = "show-team", description = {"teams.show-team"}, func = show_team_command},
	kick_teammate = {name = "kick-teammate", description = {"teams.kick-teammate"}, func = kick_teammate_command},
}

return module

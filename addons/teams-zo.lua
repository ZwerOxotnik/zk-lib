--[[
Copyright 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>

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
local prohibited_forces = {neutral = true, player = true, enemy = true}
local addon_name = "teams-zo"

local function create_new_team(cmd)
	if cmd.player_index == nil then return end
		local player = game.players[cmd.player_index]
		if #game.forces >= 60 then player.print({"teams.too_many"}) return end -- for compability with other mods/scenarios and forces count max = 64 (https://lua-api.factorio.com/0.17.54/LuaGameScript.html#LuaGameScript.create_force)
	if cmd.parameter == nil then player.print({"teams.create_team"}) return end

	if game.forces[cmd.parameter] then
		player.print({"teams.double_team", cmd.parameter})
	else
		local new_team = game.create_force(cmd.parameter)
		if #player.force.players == 1 and not prohibited_forces[player.force.name] then
			game.merge_forces(player.force, new_team)
		else
			player.force = new_team
		end
	end
end

module.add_commands = function()
	commands.add_command("create_team", {"teams.create_team"}, create_new_team)
end

module.remove_commands = function()
	commands.remove_command("create_team")
end

--[[ This part of a code to use it use it as an addon ]] --
-----------------------------------------------------------
local blacklist_events = {[defines.events.on_runtime_mod_setting_changed] = true, ["lib_id"] = true}

local function check_events()
	if (settings.startup["zk-lib_" .. addon_name].value == false)
		or (settings.startup["zk-lib_" .. addon_name].value == "mutable" and settings.global["zk-lib-during-game_" .. addon_name].value == false) then
		if module.events then
			for id, _ in pairs(module.events) do
				if blacklist_events[id] ~= true then
					module.events[id] = function() end
				end
			end
		end
		if module.on_nth_tick and #module.on_nth_tick > 0 then
			for tick, _ in pairs(module.events) do
				module.on_nth_tick[tick] = function() end
			end
		end
	end
end

local function update_events()
	if module.events then
		for id, _ in pairs(module.events) do
			if blacklist_events[id] ~= true then
				event_listener.update_event(module, id)
			end
		end
	end
	if module.on_nth_tick and #module.on_nth_tick > 0 then
		for tick, _ in pairs(module.events) do
			event_listener.update_nth_tick(module, tick)
		end
	end
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	-- comment next line if you need on_runtime_mod_setting_changed only to use it for "mutable" mode
	-- if settings.startup["zk-lib_" .. addon_name].value ~= "mutable" then return end
	if event.setting == "zk-lib-during-game_" .. addon_name then
		if settings.global[event.setting].value == true then
			if module.add_commands and module.remove_commands then module.add_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.add_remote_interface() end
			module.events = module.get_default_events()
			game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. addon_name}})
		else
			if module.add_commands and module.remove_commands then module.remove_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.remove_remote_interface() end
			check_events()
			game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. addon_name}})
		end
		update_events()
	end
end

module.get_default_events = function() -- your events
	local events = {}

	if settings.startup["zk-lib_" .. addon_name].value == "mutable" then
		table.insert(events, defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)
	end

	local on_nth_tick = {} -- your events on_nth_tick

	return events, on_nth_tick
end
module.events, module.on_nth_tick = module.get_default_events()

check_events()
-----------------------------------------------------------

return module

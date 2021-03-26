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
	if settings.global["zk-lib-during-game_" .. module.addon_name].value == false then return end
	commands.add_command("create_team", {"teams.create_team"}, create_new_team)
end

module.remove_commands = function()
	commands.remove_command("create_team")
end

module.get_default_events = function()
	local events = {}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

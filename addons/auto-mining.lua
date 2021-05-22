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
-- Source: https://github.com/ZwerOxotnik/auto-mining
-- Mod portal: https://mods.factorio.com/mod/auto-mining
-- Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=73117

local am_util = require("static-libs/lualibs/LuaPlayer")
local module = {}

local function clear_player_data(event)
	global.auto_mining.players_mining[event.player_index] = nil
end

local function on_tick(event)
	local players_mining = global.auto_mining.players_mining
	for k, data in pairs(players_mining) do -- something is wrong
		local player = game.get_player(k)
		if player and player.valid and player.connected then
			player.update_selected_entity(data.position)
			player.mining_state = {mining = true, position = data.position}
		else
			players_mining[k] = nil
		end
	end
end

local function on_pre_player_mined_item(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid and player.character and not player.cheat_mode) then return end

	local entity = event.entity
	if entity.type ~= "resource" then return end

	if entity.amount > 1 then
		global.auto_mining.players_mining[event.player_index] = {
			position = entity.position
		}
	else
		local player_data = global.auto_mining.players_mining[event.player_index]
		if player_data then
			local new_position = am_util.get_new_resource_position_by_player_resource(player, entity)
			if new_position == nil then
				global.auto_mining.players_mining[event.player_index] = nil
			else
				global.auto_mining.players_mining[event.player_index] = {
					position = new_position
				}
			end
		end
	end
end

local function on_player_mined_item(event)
	if not global.auto_mining.players_mining[event.player_index] then return end
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	if not player.can_insert(event.item_stack) then
		clear_player_data(event)
	end
end

local function clicked_stop_auto_mining_hotkey(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	if player.render_mode == defines.render_mode.game then
		clear_player_data(event)
	end
end

local function toggle_auto_mining(event)
	if event.player_index == 0 then return end
	local player = game.get_player(event.player_index)

	if global.auto_mining.players_mining[event.player_index] then
		clear_player_data(event)
	else
		local new_position = am_util.get_resource_position_for_player(player)
		if new_position == nil then
			global.auto_mining.players_mining[event.player_index] = nil
		else
			global.auto_mining.players_mining[event.player_index] = {
				position = new_position
			}
		end
	end
end

local function on_init()
	global.auto_mining = global.auto_mining or {}
	local data = global.auto_mining
	data.players_mining = data.players_mining or {}
end
module.on_init = on_init

module.get_default_events = function()
	local events = {
		[defines.events.on_tick] = on_tick,
		[defines.events.on_pre_player_mined_item] = on_pre_player_mined_item,
		[defines.events.on_player_mined_item] = on_player_mined_item,
		[defines.events.on_player_changed_surface] = clear_player_data,
		[defines.events.on_player_removed] = clear_player_data,
		[defines.events.on_pre_player_died] = clear_player_data,
		[defines.events.on_player_left_game] = clear_player_data,
		["move-down-event"] = clicked_stop_auto_mining_hotkey,
		["move-left-event"] = clicked_stop_auto_mining_hotkey,
		["move-right-event"] = clicked_stop_auto_mining_hotkey,
		["move-up-event"] = clicked_stop_auto_mining_hotkey,
		["mine-event"] = clicked_stop_auto_mining_hotkey,
		["toggle-map-event"] = toggle_auto_mining
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

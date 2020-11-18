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
-- Source: https://gitlab.com/ZwerOxotnik/random-gifts-for-nests-- Mod portal: https://mods.factorio.com/mod/random-gifts-for-nests


local module = {}
local addon_name = "kill-nest-get-gifts"

local function on_entity_died(event)
	local entity = event.entity
	if not (entity and entity.valid and entity.type == "unit-spawner") then return end --  and entity.type == "unit-spawner"
	local cause = event.cause
	if not (cause and cause.valid and cause.type == "character") then return end
	local player = cause.player
	if player.cheat_mode then return end
	if entity.force == cause.force then return end

	random_items.insert_random_item(player, 2)
end

-- it doesn't work as it should at the moment...
-- module.set_events_filters = function()
-- 	local filters = {{filter = "type", type = "unit-spawner"}}
-- 	script.set_event_filter(defines.events.on_entity_died, filters)
-- end

--[[ This part of a code to use it use it as an addon ]] --
-----------------------------------------------------------
local blacklist_events = {[defines.events.on_runtime_mod_setting_changed] = true, ["lib_id"] = true}

local function check_events()
	if (settings.startup["zk-lib_" .. addon_name].value == "disabled")
		or (settings.startup["zk-lib_" .. addon_name].value == "mutable" and settings.global["zk-lib-during-game_" .. addon_name].value == "disabled") then
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
		if settings.global[event.setting].value == "enabled" then
			if module.add_commands and module.remove_commands then module.add_commands() end
			module.events = module.get_default_events()
			game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. addon_name}})
		else
			if module.add_commands and module.remove_commands then module.remove_commands() end
			check_events()
			game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. addon_name}})
		end
		update_events()
	end
end

module.get_default_events = function() -- your events
	local events = {
		[defines.events.on_entity_died] = on_entity_died
	}

	if settings.startup["zk-lib_" .. addon_name].value == "mutable" then
		events[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
	end

	local on_nth_tick = {} -- your events on_nth_tick

	return events, on_nth_tick
end
module.events = module.get_default_events()

check_events()
-----------------------------------------------------------

return module

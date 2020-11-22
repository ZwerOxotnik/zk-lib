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

module.get_default_events = function() -- your events
	local events = {
		[defines.events.on_entity_died] = on_entity_died
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

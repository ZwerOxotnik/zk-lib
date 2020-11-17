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
local random_items

local function check_global_data()
	global.KNGG = global.KNGG or {}
	global.KNGG.random_items = global.KNGG.random_items or {}
end

-- Find all items and remove cheat items to save the item names
local function check_items()
	local KNGG = global.KNGG
	KNGG.random_items = {}
	for name, item in pairs(game.item_prototypes) do
		if not (name:find("creative") or name:find("hidden") or name:find("infinity")
			or name:find("infinity") or name:find("cheat"))and item.type ~= "mining-tool"
			and not item.has_flag("hidden") then
			table.insert(KNGG.random_items, name)
		end
	end
	random_items = KNGG.random_items
end

module.on_init = function()
	check_global_data()
	check_items()
end

module.on_load = function()
	random_items = global.KNGG.random_items
end

module.on_configuration_changed = function()
	check_items()
end

local function on_entity_died(event)
	local entity = event.entity
	if not (entity and entity.valid and entity.type == "unit-spawner") then return end --  and entity.type == "unit-spawner"
	local cause = event.cause
	if not (cause and cause.valid and cause.type == "character") then return end
	local player = cause.player
	if player.cheat_mode then return end
	if entity.force == cause.force then return end

	player.insert{name = random_items[math.random(#random_items)]}
	player.insert{name = random_items[math.random(#random_items)]}
end

module.set_events_filters = function()
	local filters = {{filter = "type", type = "unit-spawner"}}
	script.set_event_filter(defines.events.on_entity_died, filters)
end

module.events = {
	[defines.events.on_entity_died] = on_entity_died
}

return module

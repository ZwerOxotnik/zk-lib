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
-- Source: https://gitlab.com/ZwerOxotnik/random-gifts-by-timer
-- Mod portal: https://mods.factorio.com/mod/random-gifts-by-timer

local module = {}
local random_items

local function check_global_data()
	global.RGbT = global.RGbT or {}
	global.RGbT.random_items = global.RGbT.random_items or {}
end

-- Find all items and remove cheat items to save the item names
local function check_items()
	local RGbT = global.RGbT
	RGbT.random_items = {}
	for name, item in pairs(game.item_prototypes) do
		if not (name:find("creative") or name:find("hidden") or name:find("infinity")
			or name:find("infinity") or name:find("cheat"))and item.type ~= "mining-tool" 
			and not item.has_flag("hidden") then
			table.insert(RGbT.random_items, name)
		end
	end
	random_items = RGbT.random_items
end

module.on_init = function()
	check_global_data()
	check_items()
end

module.on_load = function()
	random_items = global.RGbT.random_items
end

module.on_configuration_changed = function()
	check_items()
end

-- giveaways for online players
local function give_random_items()
	-- if game == nil then return end

	for _, player in pairs(game.connected_players) do
		if player.valid and player.character and not player.cheat_mode then
			if player.insert{name = random_items[math.random(#random_items)]} then
				player.print("You got a gift")
			end
		end
	end
end

module.on_nth_tick = {
	[60 * 60 * 10] = give_random_items
}

return module

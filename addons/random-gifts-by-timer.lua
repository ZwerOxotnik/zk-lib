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

-- giveaways for online players
local function give_random_items()
	for _, player in pairs(game.connected_players) do
		if player.valid and player.character and not player.cheat_mode then
			random_items.insert_random_item(player, 1)
			player.print("You got a gift")
		end
	end
end

module.get_default_events = function()
	local events = {}

	local on_nth_tick = {
		[60 * 60 * 10] = give_random_items
	}

	return events, on_nth_tick
end

return module

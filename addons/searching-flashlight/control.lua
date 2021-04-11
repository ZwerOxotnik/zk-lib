--[[
-- "Searching Flashlight" rk84 fix Xagros
-- Copyright (c) 2013 rk84
-- The MIT License (MIT)
-- Homepage: https://forums.factorio.com/viewtopic.php?f=144&t=20712
-- Source: https://mods.factorio.com/mod/searching-flashlightR

-- "Searching Flashlight" version 1.3.0 from https://mods.factorio.com/download/searching-flashlightR/5a5f1ae6adcc441024d73d79:

-- Script modified by ZwerOxotnik <zweroxotnik@gmail.com>
]]--

local module = {}

local function worth_processing(player)
	return player.valid
		and not player.vehicle --> not driving a vehicle
		and player.selected --> they selected a target
		and player.character and player.character.valid --> they have valid avatar
		and not player.walking_state.walking --> which is not moving
end

local atan2, pi, floor = math.atan2, math.pi, math.floor

module.orient_players = function(event)
	for _, player in pairs(game.connected_players) do
		if worth_processing(player) then
			local location = player.position          --> where the player is
			local target   = player.selected.position --> what they should be looking at

			local angle = atan2(location.y - target.y, location.x - target.x)
						angle = (angle/pi + 1)*4 - 5.5
						angle = angle <  0 and angle + 8 or angle
						angle = angle >= 8 and angle - 8 or angle

			player.character.direction = floor(angle)
			-- should probably also set player.character.orientation for smoother
			-- direction but that will require more math...?
		end
	end
end

module.get_default_events = function()
	local events = {}

	local on_nth_tick = {
		[30] = module.orient_players
	}

	return events, on_nth_tick
end

return module

--[[
Copyright (C) 2018-2020, 2022-2023 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Source: github.com/ZwerOxotnik/zk-lib
]]--

---- Generates sounds etc for programmable speakers
---- Use https://github.com/ZwerOxotnik/Mod-generator


local puan2_api = {}



---@param sound table
---@param path string
puan2_api.check_and_get_sound = function(sound, path)
	local new_sound = {}

	new_sound.aggregation = sound.aggregation
	new_sound.audible_distance_modifier = sound.audible_distance_modifier
	if sound.variations then
		new_sound.variations = sound.variations
	else
		new_sound.filename = sound.filename or (path .. sound.name .. ".ogg")
		new_sound.volume = sound.volume
		new_sound.preload = sound.preload
	end

	return new_sound
end


---@param sound table
---@param path string
puan2_api.add_sound = function(sound, path)
	local new_sound = puan2_api.check_and_get_sound(sound, path)
	new_sound.type = "sound"
	new_sound.name = sound.name
	new_sound.category = "gui-effect"
	new_sound.volume = sound.volume or 1
	new_sound.audible_distance_modifier = 1e20

	data:extend{new_sound}
end


---@param sounds table
---@param path string
puan2_api.make_notes = function(sounds, path)
	local notes = {}
	for _, sound in pairs(sounds) do
		notes[#notes+1] = {
			name = sound.name,
			sound = puan2_api.check_and_get_sound(sound, path)
		}
	end
	return notes
end


local programmable_speaker = data.raw["programmable-speaker"]["programmable-speaker"].instruments
---@param sounds_list table
puan2_api.add_sounds = function(sounds_list)
	for _, sound in pairs(sounds_list.sounds) do
		puan2_api.add_sound(sound, sounds_list.path)
	end

	if sounds_list.name then
		local notes = puan2_api.make_notes(sounds_list.sounds, sounds_list.path)
		return table.insert(programmable_speaker, {name = sounds_list.name, notes = notes})
	end
end


return puan2_api

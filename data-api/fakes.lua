--[[
Copyright (C) 2018-2021 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Source: github.com/ZwerOxotnik/zk-lib
]]--

---- ####
---- The library generates various fake entities
---- ####

local fakes = {}

local corpses = data.raw["character-corpse"]
-- Creates a fake corpse using an entitty
-- WARNING: The corpses don't support collision and you can't modify their inventory
fakes.create_fake_corpse_by_entity = function(entity)
	if entity == nil then
		log("Can't create a fake corpse because parameter is nil")
		return false
	end

	local fake_corpse_name = "fake_" .. entity.name
	if corpses[fake_corpse_name] then
		log("\"" .. fake_corpse_name .. "\" already exists")
		return corpses[fake_corpse_name]
	end

	data:extend(
	{
		{
			type = "character-corpse",
			name = fake_corpse_name,
			icon = entity.icon,
			icon_size = entity.icon_size, icon_mipmaps = entity.icon_mipmaps,
			minable = {mining_time = 2},
			time_to_live = 4294967295,
			collision_box = entity.collision_box,
			selection_box = entity.selection_box,
			selection_priority = entity.selection_priority or 200, -- 0-255 value with 255 being on-top of everything else
			flags = entity.flags,
			open_sound = entity.open_sound,
			close_sound = entity.close_sound,
			picture = entity.picture,
			pictures = entity.pictures,
			render_layer = entity.render_layer,
			vehicle_impact_sound = entity.vehicle_impact_sound
		}
	})

	return corpses[fake_corpse_name]
end

local tiles = data.raw.tile
-- Creates a fake walkable tile using another tile by its name
fakes.create_fake_walkable_tile = function(name)
	if tiles[name] == nil then
		log("Tile \"" .. name .. "\" doesn't exists in the game")
		return false
	end

	local fake_tile_name = "fakeW_" .. name
	if tiles[fake_tile_name] then
		log("Tile \"" .. fake_tile_name .. "\" already exists")
		return tiles[fake_tile_name]
	end

	local new_tile = util.table.deepcopy(tiles[fake_tile_name])
	new_tile.name = fake_tile_name
	new_tile.collision_mask = {
		"water-tile",
		"ground-tile",
		"item-layer",
		"resource-layer",
		"object-layer"
	}
	new_tile.autoplace = nil
	new_tile.localised_name = {"", {"tile-name." .. name}, " [fake-W]"}

	return data:extend({new_tile})
end

return fakes

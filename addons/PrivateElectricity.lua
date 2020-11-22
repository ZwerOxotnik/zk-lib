--[[
Copyright (c) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
]]--

local module = {}

local function protect_from_theft_of_electricity(event)
	-- Validation of data
	local entity = event.created_entity
	if not (entity and entity.valid) then return end
	local force = entity.force
	if entity.type ~= "electric-pole" then return end

	local copper_neighbours = entity.neighbours["copper"]
	for _, neighbour in pairs(copper_neighbours) do
		if force ~= neighbour.force then
			if not force.get_cease_fire(neighbour.force) then
				entity.disconnect_neighbour(neighbour)
			end
		end
	end
end

module.get_default_events = function()
	local events = {
		[defines.events.on_built_entity] = protect_from_theft_of_electricity,
		[defines.events.on_robot_built_entity] = protect_from_theft_of_electricity
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

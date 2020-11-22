--[[
Copyright (c) 2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
]]--

local module = {}

local function on_chunk_generated(event)
	event.surface.destroy_decoratives{area = event.area}
end

module.get_default_events = function()
	local events = {
		[defines.events.on_chunk_generated] = on_chunk_generated
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

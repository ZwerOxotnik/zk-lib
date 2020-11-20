--[[
Copyright (c) 2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
]]--

local module = {}

local function on_chunk_generated(event)
	event.surface.destroy_decoratives{area = event.area}
end

--[[ This part of a code to use it use it as an addon and, probably, it'll will be changed ]] --
-----------------------------------------------------------
module.get_default_events = function() -- your events
	local events = {
		[defines.events.on_chunk_generated] = on_chunk_generated
	}

	if settings.startup["zk-lib_" .. module.addon_name].value == "mutable" then
		events[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
	end

	local on_nth_tick = {} -- your events on_nth_tick

	return events, on_nth_tick
end
-----------------------------------------------------------

return module

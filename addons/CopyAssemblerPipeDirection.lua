-- This script was created by IronCartographer and modified by ZwerOxotnik <zweroxotnik@gmail.com>.
-- Download original version from https://mods.factorio.com/mod/CopyAssemblerPipeDirection/downloads

local module = {}

local function paste_direction(event)
	local s = event.source
	local d = event.destination

	if s.supports_direction and d.supports_direction and ((s.prototype.fast_replaceable_group == "assembling-machine" and d.prototype.fast_replaceable_group == "assembling-machine") or (s.prototype.fast_replaceable_group == "furnace" and d.prototype.fast_replaceable_group == "furnace")) then
		d.direction = s.direction
	end
end

module.get_default_events = function()
	local events = {
		[defines.events.on_entity_settings_pasted] = paste_direction
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

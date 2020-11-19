--[[
Copyright (c) 2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;
]]--

local module = {}
local addon_name = "delete_decorations"

local function on_chunk_generated(event)
	event.surface.destroy_decoratives{area = event.area}
end

--[[ This part of a code to use it use it as an addon ]] --
-----------------------------------------------------------
local blacklist_events = {[defines.events.on_runtime_mod_setting_changed] = true, ["lib_id"] = true}

local function check_events()
	if (settings.startup["zk-lib_" .. addon_name].value == false)
		or (settings.startup["zk-lib_" .. addon_name].value == "mutable" and settings.global["zk-lib-during-game_" .. addon_name].value == false) then
		if module.events then
			for id, _ in pairs(module.events) do
				if blacklist_events[id] ~= true then
					module.events[id] = function() end
				end
			end
		end
		if module.on_nth_tick and #module.on_nth_tick > 0 then
			for tick, _ in pairs(module.events) do
				module.on_nth_tick[tick] = function() end
			end
		end
	end
end

local function update_events()
	if module.events then
		for id, _ in pairs(module.events) do
			if blacklist_events[id] ~= true then
				event_listener.update_event(module, id)
			end
		end
	end
	if module.on_nth_tick and #module.on_nth_tick > 0 then
		for tick, _ in pairs(module.events) do
			event_listener.update_nth_tick(module, tick)
		end
	end
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end

	-- comment next line if you need on_runtime_mod_setting_changed only to use it for "mutable" mode
	-- if settings.startup["zk-lib_" .. addon_name].value ~= "mutable" then return end
	if event.setting == "zk-lib-during-game_" .. addon_name then
		if settings.global[event.setting].value == true then
			if module.add_commands and module.remove_commands then module.add_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.add_remote_interface() end
			module.events = module.get_default_events()
			game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. addon_name}})
		else
			if module.add_commands and module.remove_commands then module.remove_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.remove_remote_interface() end
			check_events()
			game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. addon_name}})
		end
		update_events()
	end
end

module.get_default_events = function() -- your events
	local events = {
		[defines.events.on_chunk_generated] = on_chunk_generated
	}

	if settings.startup["zk-lib_" .. addon_name].value == "mutable" then
		events[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
	end

	local on_nth_tick = {} -- your events on_nth_tick

	return events, on_nth_tick
end
module.events = module.get_default_events()

check_events()
-----------------------------------------------------------

return module

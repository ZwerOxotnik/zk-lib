--[[
Copyright (c) 2017, 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;

Description: scans surface after launching a missile with radars

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/scan-rocket-with-radars
Mod portal: https://mods.factorio.com/mod/scan-rocket-with-radars
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64614

]]--

local module = {}

local function on_rocket_launched(event)
	local rocket = event.rocket
	local force = rocket.force
	local count = rocket.get_item_count("radar")
	if count > 20 then
		local radius = settings.global["radius-scan-rocket-with-radars"].value * count
		force.chart(rocket.surface, {
			{rocket.position.x - radius, rocket.position.y - radius},
			{rocket.position.x + radius, rocket.position.y + radius}
		})
	elseif count > 0 then
		local radius = settings.global["radius-scan-rocket-with-radars"].value * 19
		force.chart(rocket.surface, {
			{rocket.position.x - radius, rocket.position.y - radius},
			{rocket.position.x + radius, rocket.position.y + radius}
		})
	end
end

--[[ This part of a code to use it use it as an addon ]] --
-----------------------------------------------------------
local blacklist_events = {[defines.events.on_runtime_mod_setting_changed] = true, ["lib_id"] = true}

module.check_events = function()
	if (settings.startup["zk-lib_" .. module.addon_name].value == false)
		or (settings.startup["zk-lib_" .. module.addon_name].value == "mutable" and settings.global["zk-lib-during-game_" .. module.addon_name].value == false) then
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
	-- if settings.startup["zk-lib_" .. module.addon_name].value ~= "mutable" then return end
	if event.setting == "zk-lib-during-game_" .. module.addon_name then
		if settings.global[event.setting].value == true then
			if module.add_commands and module.remove_commands then module.add_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.add_remote_interface() end
			module.events = module.get_default_events()
			game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. module.addon_name}})
		else
			if module.add_commands and module.remove_commands then module.remove_commands() end
			if module.add_remote_interface and module.remove_remote_interface then module.remove_remote_interface() end
			module.check_events()
			game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. module.addon_name}})
		end
		update_events()
	end
end

module.get_default_events = function() -- your events
	local events = {
				[defines.events.on_rocket_launched] = on_rocket_launched
		}

	if settings.startup["zk-lib_" .. module.addon_name].value == "mutable" then
		table.insert(events, defines.events.on_runtime_mod_setting_changed, on_runtime_mod_setting_changed)
	end

	local on_nth_tick = {} -- your events on_nth_tick

	return events, on_nth_tick
end
-----------------------------------------------------------

return module

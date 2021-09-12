
--[[
	This is modification of event_handler.lua from Factorio 1.1.39
	This version allows you to have switchable events for mods.
	Modified by ZwerOxotnik
]]

local events_when_on = {}
local events_when_off = {}
local on_nth_tick_when_on = {}
local on_nth_tick_when_off = {}
local libraries = {}

local MOD_NAME = "mod_" .. script.mod_name
local state = settings.global[MOD_NAME].value
local setup_ran = false


local function register_events_when_off()
	for k in pairs(events_when_on) do
		script.on_event(k, nil)
	end
	for k in pairs(on_nth_tick_when_on) do
		script.on_nth_tick(k, nil)
	end

	for event, handlers in pairs (events_when_off) do
		local action = function(event)
			for _, handler in pairs (handlers) do
				handler(event)
			end
		end
		script.on_event(event, action)
	end

	for n, handlers in pairs (on_nth_tick_when_off) do
		local action = function(event)
			for _, handler in pairs (handlers) do
				handler(event)
			end
		end
		script.on_nth_tick(n, action)
	end
end

local function register_events_when_on()
	for k in pairs(events_when_off) do
		script.on_event(k, nil)
	end
	for k in pairs(on_nth_tick_when_off) do
		script.on_nth_tick(k, nil)
	end

	for event, handlers in pairs (events_when_on) do
		local action = function(event)
			for _, handler in pairs (handlers) do
				handler(event)
			end
		end
		script.on_event(event, action)
	end

	for n, handlers in pairs (on_nth_tick_when_on) do
		local action = function(event)
			for _, handler in pairs (handlers) do
				handler(event)
			end
		end
		script.on_nth_tick(n, action)
	end
end

local register_remote_interfaces = function()
	--Sometimes, in special cases, on_init and on_load can be run at the same time. Only register events once in this case.
	if setup_ran then return end
	setup_ran = true

	for _, lib in pairs (libraries) do
		if lib.add_remote_interface then
			lib.add_remote_interface()
		end

		if state then
			if lib.add_commands and lib.remove_commands then
				lib.add_commands()
			end
			if lib.set_event_filters and lib.set_event_filters_when_off then
				lib.set_event_filters()
			end
		else
			if lib.remove_commands then
				lib.remove_commands()
			end
			if lib.set_event_filters_when_off then
				lib.set_event_filters_when_off()
			end
		end
	end
end

local reregister_events = function()
	if state then
		for _, lib in pairs(libraries) do
			register_events_when_on()

			if lib.add_commands and lib.remove_commands then
				lib.add_commands()
			end
			if lib.set_event_filters and lib.set_event_filters_when_off then
				lib.set_event_filters()
			end
		end
	else
		for _, lib in pairs(libraries) do
			register_events_when_off()

			if lib.remove_commands then
				lib.remove_commands()
			end
			if lib.set_event_filters_when_off then
				lib.set_event_filters_when_off()
			end
		end
	end
end

local function on_mod_state_changed(event)
	if event.setting == MOD_NAME then
		state = settings.global[event.setting].valu
		reregister_events()

		if state then
			for _, lib in pairs(libraries) do
				if lib.on_mod_enabled then
					lib.on_mod_enabled()
				end
			end
		else
			for _, lib in pairs(libraries) do
				if lib.on_mod_disabled then
					lib.on_mod_disabled()
				end
			end
		end
	end
end

local register_events = function()
	events_when_on = {
		[defines.events.on_runtime_mod_setting_changed] = {core = on_mod_state_changed}
	}
	events_when_off = {
		[defines.events.on_runtime_mod_setting_changed] = {core = on_mod_state_changed}
	}
	on_nth_tick_when_on = {}
	on_nth_tick_when_off = {}

	for lib_name, lib in pairs (libraries) do
		if lib.events then
			for k, handler in pairs (lib.events) do
				events_when_on[k] = events_when_on[k] or {}
				events_when_on[k][lib_name] = handler
			end
		end

		if lib.events_when_off then
			for k, handler in pairs (lib.events_when_off) do
				events_when_off[k] = events_when_off[k] or {}
				events_when_off[k][lib_name] = handler
			end
		end

		if lib.on_nth_tick then
			for n, handler in pairs (lib.on_nth_tick) do
				on_nth_tick_when_on[n] = on_nth_tick_when_on[n] or {}
				on_nth_tick_when_on[n][lib_name] = handler
			end
		end

		if lib.on_nth_tick_when_off then
			for n, handler in pairs (lib.on_nth_tick_when_off) do
				on_nth_tick_when_off[n] = on_nth_tick_when_off[n] or {}
				on_nth_tick_when_off[n][lib_name] = handler
			end
		end
	end

	if state then
		register_events_when_on()
	else
		register_events_when_off()
	end
end

script.on_init(function()
	register_remote_interfaces()
	register_events()

	if state then
		for _, lib in pairs (libraries) do
			if lib.on_init then
				lib.on_init()
			end
		end
	else
		for _, lib in pairs (libraries) do
			if lib.on_init_when_off then
				lib.on_init_when_off()
			elseif lib.on_init then
				lib.on_init()
			end
		end
	end
end)

script.on_load(function()
	register_remote_interfaces()
	register_events()

	if state then
		for _, lib in pairs (libraries) do
			if lib.on_load then
				lib.on_load()
			end
		end
	else
		for _, lib in pairs (libraries) do
			if lib.on_load_when_off then
				lib.on_load_when_off()
			elseif lib.on_load then
				lib.on_load()
			end
		end
	end
end)

script.on_configuration_changed(function(data)
	for _, lib in pairs (libraries) do
		if lib.on_configuration_changed then
			lib.on_configuration_changed(data)
		end
	end
end)

local handler = {}

handler.add_lib = function(lib)
	for _, current in pairs (libraries) do
		if current == lib then
			error("Trying to register same lib twice")
		end
	end
	table.insert(libraries, lib)
end

handler.add_libraries = function(libs)
	for k, lib in pairs (libs) do
		handler.add_lib(lib)
	end
end

return handler

local addons_api = require("addons/core/addons_api")
event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")
LuaEntity = require("static-libs/lualibs/LuaEntity")

local insecure_addons_list = require("addons/core/insecure-addons-list")
local safe_addons_list = require("addons/core/safe-addons-list")
addons = {}
addons_check_modules = {}
mutable_addons_list = {}
disabled_addons_list = {}

-- Sorts modules
for name, addon_data in pairs(insecure_addons_list) do
	if settings.startup["zk-lib_" .. name] then
		if settings.startup["zk-lib_" .. name].value == false then
			insecure_addons_list[name] = nil
			table.insert(disabled_addons_list, name)
		else
			table.insert(mutable_addons_list, name)
		end
	else
		insecure_addons_list[name] = nil
	end
end

-- Check safe addons list
for name, addon_data in pairs(safe_addons_list) do
	if settings.global["zk-lib-during-game_" .. name] then
		table.insert(mutable_addons_list, name)
	else
		safe_addons_list[name] = nil
	end
end

local core_modules = {}
core_modules.random_items = random_items
core_modules.zk_lib = require("core/control")
-- core_modules.special_message = require("core/special-message")
-- core_modules.zk_commands = require("core/zk_commands")

-- Adds events of addons
for name, addon_data in pairs(safe_addons_list) do
	addons[name] = require(addon_data.path or "addons/" .. name)
	local addon = addons[name]
	addon.addon_name = name
	if addon.get_default_events then
		addon.blacklist_events = addon.blacklist_events or {}
		addon.events, addon.on_nth_tick = addon.get_default_events()

		addon.check_events = function()
			if settings.global["zk-lib-during-game_" .. name].value == false then
				if addon.events then
					for id, _ in pairs(addon.events) do
						if addon.blacklist_events[id] ~= true and id ~= "lib_id"  then
							addon.events[id] = function() end
						end
					end
				end
				if addon.on_nth_tick and table.maxn(addon.on_nth_tick) > 0 then
					for tick, _ in pairs(addon.on_nth_tick) do
						if type(tick) ~= "string" then
							addon.on_nth_tick[tick] = function() end
						end
					end
				end
			end
		end

		addon.check_events()
	end
end

for name, addon_data in pairs(insecure_addons_list) do
	addons[name] = require(addon_data.path or "addons/" .. name)
	local addon = addons[name]
	addon.addon_name = name
	if addon.get_default_events then
		addon.blacklist_events = addon.blacklist_events or {}
		addon.events, addon.on_nth_tick = addon.get_default_events()
		addon.check_events = function()
			if (settings.startup["zk-lib_" .. name].value == false)
				or (settings.startup["zk-lib_" .. name].value == true and settings.global["zk-lib-during-game_" .. name].value == false) then
				if addon.events then
					for id, _ in pairs(addon.events) do
						if addon.blacklist_events[id] ~= true and id ~= "lib_id"  then
							addon.events[id] = function() end
						end
					end
				end
				if addon.on_nth_tick and table.maxn(addon.on_nth_tick) > 0 then
					for tick, _ in pairs(addon.on_nth_tick) do
						if type(tick) ~= "string" then
							addon.on_nth_tick[tick] = function() end
						end
					end
				end
			end
		end

		addon.check_events()
	end
end

local function handle_commands(addon)	
	if settings.global["zk-lib-during-game_" .. addon.addon_name].value == true then
		for key, command in pairs(addon.commands) do
			commands.add_command(command.name or key, command.description, command.func)
		end
	else
		for key, command in pairs(addon.commands) do
			commands.remove_command(command.name or key)
		end
	end
end

local function is_events_table(T)
  local count = 0
  for _ in pairs(T)	do
		count = count + 1
		if count > 1 then
			return true
		end
	end
	return false
end

-- TODO: create and raise new events to addons
-- TODO: pack or refactor/change checks

local function mutable_addon_on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end
	if string.find(event.setting, "^zk.lib.during.game_") ~= 1 then return end
	local addon_name = string.gsub(event.setting, "^zk.lib.during.game_", "")
	local addon = addons[addon_name]
	if not addon then log("error") return end

	if settings.global[event.setting].value == true then
		if addon.commands then handle_commands(addon) end
		if addon.add_commands and addon.remove_commands then addon.add_commands() end
		if addon.add_remote_interface and addon.remove_remote_interface then addon.add_remote_interface() end
		if addon.get_default_events then
			addon.events, addon.on_nth_tick = addon.get_default_events()
		end
		if addon.enable_addon then addon.enable_addon() end
		if addon.init then -- it's a workaround to init global data because those addons don't init in some cases
			addon.init()
		elseif addon.on_init then
			addon.on_init()
		end
		game.print({"", {"gui-mod-info.status-enabled"}, {"colon"}, " ", {"mod-name." .. addon_name}})
	else
		if addon.add_commands and addon.remove_commands then addon.remove_commands() end
		if addon.add_remote_interface and addon.remove_remote_interface then addon.remove_remote_interface() end
		if addon.check_events then addon.check_events() end
		if addon.disable_addon then addon.disable_addon() end
		game.print({"", {"gui-mod-info.status-disabled"}, {"colon"}, " ", {"mod-name." .. addon_name}})
	end
	if is_events_table(addon.events) then
		for id, _ in pairs(addon.events) do
			if addon.blacklist_events[id] ~= true and id ~= "lib_id" then
				event_listener.update_event(addon, id)
			end
		end
	end
	if addon.on_nth_tick and table.maxn(addon.on_nth_tick) > 0 then
		for tick, _ in pairs(addon.on_nth_tick) do
			if type(tick) ~= "string" then
				event_listener.update_nth_tick(addon, tick)
			end
		end
	end
end

local function add_addons_commands()
	for _, addon in pairs(addons_check_modules) do
		if addon.commands then handle_commands(addon) end
	end

	for _, addon in pairs(addons) do
		if addon.commands then handle_commands(addon) end
	end
end

module.on_init = add_addons_commands
module.on_load = add_addons_commands

-- Adds additional checks etc for addons for stability
if #mutable_addons_list > 1 then
	table.insert(addons_check_modules, {
		events = {
			[defines.events.on_runtime_mod_setting_changed] = mutable_addon_on_runtime_mod_setting_changed
		}
	})
end

for _, module in pairs(core_modules) do
	event_listener.add_lib(module)
end

for _, module in pairs(addons_check_modules) do
	event_listener.add_lib(module)
end

for _, module in pairs(addons) do
	event_listener.add_lib(module)
end

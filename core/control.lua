local zk_lib = {}

zk_lib.add_remote_interface = function()
	remote.add_interface('zk-lib', {
		insert_random_item = random_items.insert_random_item,
		transfer_items = LuaEntity.transfer_items,
		change_setting = function(type, name, value)
			settings[type][name] = {value = value}
		end,
	})
end

zk_lib.remove_remote_interface = function()
	remote.remove_interface('zk-lib')
end

local function update_global_data()
	global.zk_lib = global.zk_lib or {}
	global.zk_lib.addons = global.zk_lib.addons or {}
	global.zk_lib.save_tick = global.zk_lib.save_tick or 0
end

local function on_init()
	update_global_data()

	for _, addon_name in pairs(disabled_addons_list) do
		if settings.global["zk-lib-during-game_" .. addon_name].value == true then
			settings.global["zk-lib-during-game_" .. addon_name] = {value = false}
		end
	end

	for name, _ in pairs(addons) do
		if global.zk_lib.addons[name] == nil then
			global.zk_lib.addons[name] = true
		end
	end
end

local function on_configuration_changed(mod_data)
	if global.zk_lib == nil or global.zk_lib.addons == nil then
		update_global_data()
		for name, addon in pairs(addons) do
			global.zk_lib.addons[name] = true
			if addon.init then -- it's a workaround to init global data because those addons don't init in some cases
				addon.init()
			elseif addon.on_init then
				addon.on_init()
			end
		end
	else
		for name, addon in pairs(addons) do
			if global.zk_lib.addons[name] == nil then
				global.zk_lib.addons[name] = true
				if addon.init then -- it's a workaround to init global data because those addons don't init in some cases
					addon.init()
				elseif addon.on_init then
					addon.on_init()
				end
			end
		end
	end

	for _, addon_name in pairs(disabled_addons_list) do
		global.zk_lib.addons[addon_name] = nil
	end
end

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end
	if string.find(event.setting, "^zk.lib.during.game_") ~= 1 then return end
	local addon_name = string.gsub(event.setting, "^zk.lib.during.game_", "")
	if not addon_name then return end

	if settings.startup["zk-lib_" .. addon_name] == nil or settings.startup["zk-lib_" .. addon_name].value == true then
		-- if safe mode is enabled then save game as an admin change state of an addon
		if settings.global["zk-lib_safe-mode"].value == false then return end
		if game.tick < global.zk_lib.save_tick then return end

		global.zk_lib.save_tick = game.tick + 4800
		game.auto_save()
	elseif settings.startup["zk-lib_" .. addon_name] and settings.startup["zk-lib_" .. addon_name].value == false then
		if event.player_index then
			game.print({"zk-lib.turn-on-addon-on-start", {"mod-name." .. addon_name}})
		end

		if settings.global["zk-lib-during-game_" .. addon_name].value == true then
			settings.global["zk-lib-during-game_" .. addon_name] = {value = false}
		end
	end
end

zk_lib.events = {
	[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
}

zk_lib.on_init = on_init
zk_lib.on_configuration_changed = on_configuration_changed

return zk_lib

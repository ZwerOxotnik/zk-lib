local zk_lib = {}
remote.remove_interface('zk-lib')
remote.add_interface('zk-lib', {
	insert_random_item = random_items.insert_random_item,
	transfer_items = LuaEntity.transfer_items
})

local function on_init()
	global.zk_lib = global.zk_lib or {}
	global.zk_lib.save_tick = global.zk_lib.save_tick or 0

	for _, addon_name in pairs(disabled_addons_list) do
		if settings.global["zk-lib-during-game_" .. addon_name].value == true then
			settings.global["zk-lib-during-game_" .. addon_name] = {value = false}
		end
	end
	for _, addon_name in pairs(addons_as_mods_list) do
		if settings.global["zk-lib-during-game_" .. addon_name].value == true then
			settings.global["zk-lib-during-game_" .. addon_name] = {value = false}
		end
	end
end

zk_lib.on_init = on_init
zk_lib.on_configuration_changed = set_global_data

local function on_runtime_mod_setting_changed(event)
	if event.setting_type ~= "runtime-global" then return end
	if string.find(event.setting, "^zk.lib.during.game_") ~= 1 then return end
	local addon_name = string.gsub(event.setting, "^zk.lib.during.game_", "")
	if not addon_name then return end

	if settings.startup["zk-lib_" .. addon_name].value == "mutable" then
		-- if safe mode is enabled then save game as an admin change state of a mutable addon
		if settings.global["zk-lib_safe-mode"].value == false then return end
		if game.tick < global.zk_lib.save_tick then return end

		global.zk_lib.save_tick = game.tick + 4800
		game.auto_save()
	else
		if settings.global["zk-lib-during-game_" .. addon_name].value == true then
			settings.global["zk-lib-during-game_" .. addon_name] = {value = false}
		end
	end
end

zk_lib.events = {
	[defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
}
return zk_lib

local zk_lib = {}
remote.remove_interface('zk-lib')
remote.add_interface('zk-lib', {
    insert_random_item = random_items.insert_random_item,
    transfer_items = ItemsLua.transfer_items
})

local function set_global_data()
    global.zk_lib = global.zk_lib or {}
    global.zk_lib.save_tick = global.zk_lib.save_tick or 0
end

zk_lib.on_init = set_global_data
zk_lib.on_configuration_changed = set_global_data

-- if safe mode is enabled then save game as an admin change state of a mutable addon
local function on_runtime_mod_setting_changed(event)
    if event.setting_type ~= "runtime-global" then return end
    if settings.global["zk-lib_safe-mode"].value == false then return end
    if game.tick < global.zk_lib.save_tick then return end

    if string.match(event.setting, "^zk.lib.during.game_") then
        global.zk_lib.save_tick = game.tick + 4800
        game.auto_save()
	end
end

zk_lib.events = {
    [defines.events.on_runtime_mod_setting_changed] = on_runtime_mod_setting_changed
}
return zk_lib

event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")
LuaEntity = require("static-libs/lualibs/LuaEntity")

local addons_list = require("addons/addons-list")
local addons = {}
local addons_check_modules = {}
addons_as_mods_list = {}
mutable_addons_list = {}
disabled_addons_list = {}

-- Sorts modules
for name, addon_data in pairs(addons_list) do
  if settings.startup["zk-lib_" .. name] then
    if settings.startup["zk-lib_" .. name].value == "disabled" then
      addons_list[name] = nil
      table.insert(disabled_addons_list, name)
    elseif settings.startup["zk-lib_" .. name].value == "enabled" then
      table.insert(addons_as_mods_list, name)
    else --if settings.startup["zk-lib_" .. name].value == "mutable" then
      table.insert(mutable_addons_list, name)
    end
  else
    addons_list[name] = nil
  end
end

local core_modules = {}
core_modules.random_items = random_items
core_modules.zk_lib = require("core/control")
core_modules.special_message = require("core/special-message")
-- core_modules.zk_commands = require("core/zk_commands")

-- Adds events of addons
for name, addon_data in pairs(addons_list) do
  addons[name] = require(addon_data.path or "addons/" .. name)
  local addon = addons[name]
  addon.addon_name = name
  addon.blacklist_events = addon.blacklist_events or {}
  addon.events, addon.on_nth_tick = addon.get_default_events()
  addon.check_events = function()
    if (settings.startup["zk-lib_" .. name].value == false)
      or (settings.startup["zk-lib_" .. name].value == "mutable" and settings.global["zk-lib-during-game_" .. name].value == false) then
      if addon.events then
        for id, _ in pairs(addon.events) do
          if addon.blacklist_events[id] ~= true and id ~= "lib_id"  then
            addon.events[id] = function() end
          end
        end
      end
      if addon.on_nth_tick and #addon.on_nth_tick > 0 then
        for tick, _ in pairs(addon.events) do
          addon.on_nth_tick[tick] = function() end
        end
      end
    end
  end

  addon.check_events()
end

-- TODO: create and raise new events to addons
-- TODO: pack or refactor/change checks

-- Adds additional checks etc for addons for stability
if #mutable_addons_list > 1 then
  table.insert(addons_check_modules, {
    events = {
      [defines.events.on_runtime_mod_setting_changed] = function(event)
        if event.setting_type ~= "runtime-global" then return end
        if string.find(event.setting, "^zk.lib.during.game_") ~= 1 then return end
        local addon_name = string.gsub(event.setting, "^zk.lib.during.game_", "")
        local addon = addons[addon_name]
        if not addon then log("error") return end

        if settings.global[event.setting].value == true then
          if addon.add_commands and addon.remove_commands then addon.add_commands() end
          if addon.add_remote_interface and addon.remove_remote_interface then addon.add_remote_interface() end
          addon.events = addon.get_default_events()
          if addon.enable_addon then addon.enable_addon() end
          if addon.init then -- it's a workaround to init global data because those addons don't init sometimes
            addon.init()
          elseif addon.on_init then
            addon.on_init()
          end
          game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. addon_name}})
        else
          if addon.add_commands and addon.remove_commands then addon.remove_commands() end
          if addon.add_remote_interface and addon.remove_remote_interface then addon.remove_remote_interface() end
          addon.check_events()
          if addon.disable_addon then addon.disable_addon() end
          game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. addon_name}})
        end
        if addon.events then
          for id, _ in pairs(addon.events) do
            if addon.blacklist_events[id] ~= true and id ~= "lib_id" then
              event_listener.update_event(addon, id)
            end
          end
        end
        if addon.on_nth_tick and #addon.on_nth_tick > 0 then
          for tick, _ in pairs(addon.events) do
            event_listener.update_nth_tick(addon, tick)
          end
        end
      end
    }
  })
end

-- Inits addons for special cases when they didn't use init function
-- (It's dirty but I didn't find more stable and simpler resolution at the moment for addons with such state)
if #addons_as_mods_list > 1 then
  local function spare_init(event)
    if #game.connected_players ~= 1 then return end
    for _, addon_name in pairs(addons_as_mods_list) do
      if addons[addon_name].init then
        addons[addon_name].init()
      elseif addons[addon_name].on_init then
        addons[addon_name].on_init()
      end
    end
  end

  table.insert(addons_check_modules, {
    events = {
      [defines.events.on_player_joined_game] = spare_init,
      [defines.events.on_player_created] = spare_init
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

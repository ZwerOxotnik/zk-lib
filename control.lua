event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")
LuaEntity = require("static-libs/lualibs/LuaEntity")

local modules = {}
modules.random_items = random_items
modules.zk_lib = require("core/control")
modules.special_message = require("core/special-message")
-- modules.zk_commands = require("core/zk_commands")

-- TODO: create and raise new events to addons
-- TODO: refactor this biggest mess :)
local addons_list = require("addons/addons-list")
for name, _ in pairs(addons_list) do
  if settings.startup["zk-lib_" .. name] and settings.startup["zk-lib_" .. name].value ~= "disabled" then
    modules[name] = require("addons/" .. name)
    local module = modules[name]
    module.addon_name = name
    module.blacklist_events = module.blacklist_events or {}
    module.events, module.on_nth_tick = module.get_default_events()
    module.check_events = function()
      if (settings.startup["zk-lib_" .. name].value == false)
        or (settings.startup["zk-lib_" .. name].value == "mutable" and settings.global["zk-lib-during-game_" .. name].value == false) then
        if module.events then
          for id, _ in pairs(module.events) do
            if module.blacklist_events[id] ~= true and id ~= "lib_id"  then
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

    module.check_events()

    if settings.startup["zk-lib_" .. name].value == "mutable" then
      table.insert(modules, {
        events = {[defines.events.on_runtime_mod_setting_changed] = function(event)
          if event.setting_type ~= "runtime-global" then return end

          if event.setting == "zk-lib-during-game_" .. name then
            if settings.global[event.setting].value == true then
              if module.add_commands and module.remove_commands then module.add_commands() end
              if module.add_remote_interface and module.remove_remote_interface then module.add_remote_interface() end
              module.events = module.get_default_events()
              game.print({"", {"gui-mod-info.status-enabled"}, ": ", {"mod-name." .. name}})
            else
              if module.add_commands and module.remove_commands then module.remove_commands() end
              if module.add_remote_interface and module.remove_remote_interface then module.remove_remote_interface() end
              module.check_events()
              game.print({"", {"gui-mod-info.status-disabled"}, ": ", {"mod-name." .. name}})
            end
            if module.events then
              for id, _ in pairs(module.events) do
                if module.blacklist_events[id] ~= true and id ~= "lib_id" then
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
        end}})
    end
  end
end

event_listener.add_libraries(modules)

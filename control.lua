event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")
LuaEntity = require("static-libs/lualibs/LuaEntity")

local modules = {}
modules.random_items = random_items
modules.zk_lib = require("core/control")
modules.special_message = require("core/special-message")
-- modules.zk_commands = require("core/zk_commands")

-- TODO: create and raise new events to addons
local addons_list = require("addons/addons-list")
for name, _ in pairs(addons_list) do
  if settings.startup["zk-lib_" .. name] and settings.startup["zk-lib_" .. name].value ~= "disabled" then
    modules[name] = require("addons/" .. name)
    modules[name].addon_name = name
    modules[name].events, modules[name].on_nth_tick = modules[name].get_default_events()
    modules[name].check_events()
  end
end

event_listener.add_libraries(modules)

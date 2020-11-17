event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")
ItemsLua = require("static-libs/lualibs/ItemsLua")

local modules = {}
modules.random_items = random_items
modules.zk_lib = require("core/control")
modules.special_message = require("addons/special-message")
-- modules.zk_commands = require("core/zk_commands")

local addons_list = require("addons/addons-list")
for k, name in pairs(addons_list) do
  if name and settings.startup["zk-lib_" .. name].value ~= "disabled" then
    modules[name] = require("addons/" .. name)
  end
end

event_listener.add_libraries(modules)

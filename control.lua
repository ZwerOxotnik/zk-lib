event_listener = require("__event-listener__/branch-3/stable-version")
random_items = require("static-libs/lualibs/random_items")
local modules = require("modules")

local modules = {}
modules.random_items = random_items
modules.zk_lib = require("zk-lib/control")
modules.zk_commands = require("zk-lib/zk_commands")

event_listener.add_libraries(modules)

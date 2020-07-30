event_listener = require("__zk-lib__/event-listener/branch-1/stable-version")
random_items = require("static-libs/lualibs/random_items")

local modules = {}
modules.random_items = random_items
modules.zk_lib = require("zk-lib/control")
modules.zk_commands = require("zk-lib/zk_commands")

event_listener.add_libraries(modules)

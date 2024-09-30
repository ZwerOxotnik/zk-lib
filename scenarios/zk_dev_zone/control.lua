event_listener = require("__zk-lib__/static-libs/lualibs/event_handler_vZO")
local modules = {
	free_research = require("models/free_research"),
	export = require("models/export"),
}

event_listener.add_libraries(modules)

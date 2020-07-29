local libs = {}
libs.module1 = require('module1/control')
libs.module2 = require('module2/control')
libs.module3 = require('module3/control')
libs.module4 = require('module4/control')
libs.module5 = require('module5/control')

libs.custom_events = {}
libs.custom_events.events = {}
libs.custom_events.handle_events = function()
	-- Searching events "on_round_start" and "on_round_end"
	for interface, _ in pairs( remote.interfaces ) do
		local function_name = "get_event_name"
		if remote.interfaces[interface][function_name] then
			local ID_1 = remote.call(interface, function_name, "on_round_start")
			local ID_2 = remote.call(interface, function_name, "on_round_end")
			if (type(ID_1) == "number") and (type(ID_2) == "number") then
				if (script.get_event_handler(ID_1) == nil) and (script.get_event_handler(ID_2) == nil) then
					-- script.on_event(ID_1, function() game.print("on_round_start") end)
					-- script.on_event(ID_2, function() game.print("on_round_end") end)
					libs.custom_events.events[ID_1] =  function() game.print("on_round_start") end, libs.custom_events
					libs.custom_events.events[ID_2] =  function() game.print("on_round_end") end, libs.custom_events
				end
			end
		end
	end
end
libs.custom_events.on_load = libs.custom_events.handle_events
libs.custom_events.on_init = libs.custom_events.handle_events

return libs

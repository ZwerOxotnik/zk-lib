local module = {}
module.events = {}
module.version = "1.0.0"

local function get_event(event)
	if type(event) == "number" then
		return event
	else
		return defines.events[event] --or event
	end
end

-- This function for compatibility with "Event listener" module and into other modules
local function put_event(event, func)
	event = get_event(event)
	if event then
		module.events[event] = func
		if Event then
			Event.register(event, func)
		end
		return true
	else
		log("The event is nil")
		-- error("The event is nil")
	end
	return false
end

-- For tests
local function on_player_joined_game()
	game.print('2nd test of event listener')
end

-- For attaching events
put_event("on_player_joined_game", on_player_joined_game)

return module

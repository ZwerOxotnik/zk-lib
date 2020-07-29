local module = {}
module.events = {}

-- For tests
local function on_player_joined_game()
	game.print('This scenario licensed under CC0 1.0 Universal (CC0 1.0)')
	return true -- for canceling the "on_player_joined_game" event
end

-- For attaching events
module.events[defines.events.on_player_joined_game] = on_player_joined_game

return module

local module = {}
module.events = {}
module.version = "1.0.0"

-- For tests
local function on_player_joined_game()
	game.print('2nd test of event listener')
end

-- For attaching events
module.events[defines.events.on_player_joined_game] = on_player_joined_game

return module

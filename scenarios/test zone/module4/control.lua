local module = {}
module.events = {}

-- For tests
local function on_player_joined_game()
	game.print('4th test of event listener. This message is must be canceled in the 3rd module')
end

-- For attaching events
module.events[defines.events.on_player_joined_game] = on_player_joined_game

return module

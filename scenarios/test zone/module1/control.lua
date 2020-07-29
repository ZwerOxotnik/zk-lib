local module = {}
module.events = {}

-- For tests
local function on_player_joined_game(event)
	game.print("player id - " .. event.player_index)
	game.print('1st test of event listener')
end

-- For attaching events
module.events[defines.events.on_player_joined_game] = on_player_joined_game

return module

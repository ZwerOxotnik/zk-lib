local module = {}

-- Responses on "/hi" command
local function say_hi(cmd)
	if cmd.player_index == nil then return end -- ignores server call
	local player = game.players[cmd.player_index]
	-- if cmd.parameter == nil then player.print({"", "/hi ", module.commands.hi.description}) return end

	game.print({"your_localization.hi"})
end

-- Responses on_player_joined_game event
local function say_hi_to_joined_player(event)
	-- Validation of data
	local player = game.players[event.player_index]
	if not (player and player.valid) then return end

	player.print({"your_localization.hi"})
end

-- your events (inside zk-lib auto-handles your events)
module.get_default_events = function()
	local events = {
		[defines.events.on_player_joined_game] = say_hi_to_joined_player
	}
	local on_nth_tick = {}

	return events, on_nth_tick
end

-- your events (inside zk-lib auto-handles your commands)
module.commands = {
	hi = {description = {"your_localization.hi_command"}, func = say_hi}
}

return module

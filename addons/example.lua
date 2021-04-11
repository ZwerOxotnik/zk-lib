local module = {}

-- Responses on "/hi" command
local function say_hi_command(cmd)
	if cmd.player_index == 0 then return end -- ignores server call
	local caller = game.get_player(cmd.player_index)
	-- if cmd.parameter == nil then caller.print({"", "/hi ", module.commands.hi.description}) return end

	caller.print({"your_localization.hi"})
end

-- Responses on_player_joined_game event
local function say_hi_to_joined_player(event)
	-- Validation of data
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	player.print({"your_localization.hi"})
end

-- [new][optional] your events (inside zk-lib auto-handles your events)
module.get_default_events = function()
	local events = {
		[defines.events.on_player_joined_game] = say_hi_to_joined_player
	}
	local on_nth_tick = {}

	return events, on_nth_tick
end

-- [new][optional] your commands (inside zk-lib auto-handles your commands)
module.commands = {
	hi = {name = "hi", description = {"your_localization.hi_command"}, func = say_hi_command}
}

return module

return {
	-- Called when someone/something was kicked from a team.
	--	Contains:
	--		player_index :: uint: The kicked player.
	--		kicker :: uint or nil: A player/server/script who kicked the player.
	on_kick = script.generate_event_name()
}

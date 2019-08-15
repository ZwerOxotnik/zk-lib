data:extend({
	{
		type = "bool-setting",
		name = "zo_commands",
		setting_type = "runtime-global",
		default_value = true
	},
	{
		type = "string-setting",
		name = "on_round_end_message",
		setting_type = "runtime-global",
		default_value = "The round is ended",
		allow_blank = true
	},
	{
		type = "string-setting",
		name = "on_round_start_message",
		setting_type = "runtime-global",
		default_value = "New round is started",
		allow_blank = true
	},
	{
		type = "string-setting",
		name = "on_team_lost_message",
		setting_type = "runtime-global",
		default_value = "lost",
		allow_blank = true
	},
	{
		type = "string-setting",
		name = "on_team_won_message",
		setting_type = "runtime-global",
		default_value = "won",
		allow_blank = true
	},
	{
		type = "string-setting",
		name = "on_player_joined_team_message",
		setting_type = "runtime-global",
		default_value = "joined to",
		allow_blank = true
	}
})
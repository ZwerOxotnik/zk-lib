-- Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

local zo_commands = {}
zo_commands.events = {}

local zo_factocord = require("zo-library/util/zo_factocord")

local function message_to_discord(cmd)
	if not cmd.parameter then return end

	if not cmd.player_index then
		zo_factocord.SendDiscordMessage(cmd.parameter)
	else
		local player = game.players[cmd.player_index]
		if player.admin then
			zo_factocord.SendDiscordMessage(cmd.parameter)
		else
			player.print({"cant-run-command-not-admin", cmd.name})
		end
	end
end

local function embed_message_to_discord(cmd)
	if not cmd.parameter then return end

	if not cmd.player_index then
		zo_factocord.SendDiscordEmbedMessage(cmd.parameter)
	else
		local player = game.players[cmd.player_index]
		if player.admin then
			zo_factocord.SendDiscordEmbedMessage(cmd.parameter)
		else
			player.print({"cant-run-command-not-admin", cmd.name})
		end
	end
end

local commands_list = {
	{name = "message-to-discord", help = {"zo-library.factocord.message-to-discord"}, func = message_to_discord},
	{name = "embed-message-to-discord", help = {"zo-library.factocord.embed-message-to-discord"}, func = embed_message_to_discord},
}

zo_commands.delete_commands = function()
	for _, command in pairs(commands_list) do
		commands.remove_command(command.name)
	end
end

zo_commands.add_commands = function()
	if settings.global["zo_commands"].value then
		for _, command in pairs(commands_list) do
			commands.add_command(command.name, command.help, command.func)
		end
	end
end

local function check_commands()
	if settings.global["zo_commands"].value then
		zo_commands.add_commands()
	else
		zo_commands.delete_commands()
	end
end

zo_commands.events[defines.events.on_runtime_mod_setting_changed] = function(event)
	-- if event.setting_type ~= "runtime-global" then return end

	if event.setting == "zo_commands" then check_commands() end
end

return zo_commands
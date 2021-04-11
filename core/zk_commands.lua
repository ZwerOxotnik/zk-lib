--[[
Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Source: github.com/ZwerOxotnik/zk-lib
]]

local zk_commands = {}
zk_commands.events = {}

-- local function message_to_discord(cmd)
-- 	if not cmd.parameter then return end

-- 	if not cmd.player_index then
-- 		.SendDiscordMessage(cmd.parameter)
-- 	else
-- 		local player = game.get_player(cmd.player_index)
-- 		if player.admin then
-- 			.SendDiscordMessage(cmd.parameter)
-- 		else
-- 			player.print({"cant-run-command-not-admin", cmd.name})
-- 		end
-- 	end
-- end

-- local function embed_message_to_discord(cmd)
-- 	if not cmd.parameter then return end

-- 	if not cmd.player_index then
-- 		.SendDiscordEmbedMessage(cmd.parameter)
-- 	else
-- 		local player = game.get_player(cmd.player_index)
-- 		if player.admin then
-- 			.SendDiscordEmbedMessage(cmd.parameter)
-- 		else
-- 			player.print({"cant-run-command-not-admin", cmd.name})
-- 		end
-- 	end
-- end

local commands_list = {
-- 	{name = "message-to-discord", help = {"zk-lib.message-to-discord"}, func = message_to_discord},
-- 	{name = "embed-message-to-discord", help = {"zk-lib.embed-message-to-discord"}, func = embed_message_to_discord},
}

zk_commands.delete_commands = function()
	for _, command in pairs(commands_list) do
		commands.remove_command(command.name)
	end
end

local is_commands_exist = settings.global["zk_commands"].value
zk_commands.add_commands = function()
	if is_commands_exist then
		for _, command in pairs(commands_list) do
			commands.add_command(command.name, command.help, command.func)
		end
	end
end

local function check_commands()
	if is_commands_exist then
		zk_commands.add_commands()
	else
		zk_commands.delete_commands()
	end
end

zk_commands.events[defines.events.on_runtime_mod_setting_changed] = function(event)
	-- if event.setting_type ~= "runtime-global" then return end

	if event.setting == "zk_commands" then check_commands() end
end

return zk_commands
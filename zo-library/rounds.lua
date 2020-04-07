--[[
Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
]]--

local zo_factocord = require("zo-library/util/zo_factocord")
local module = {}
module.events = {}

local function on_round_end()
	local message = settings.global.on_round_end_message.value
	if message == "" then return end

	zo_factocord.SendDiscordMessage(message)
end

local function on_round_start()
	local message = settings.global.on_round_start_message.value
	if message == "" then return end

	zo_factocord.SendDiscordMessage(message)
end

local function on_team_lost(event)
	local message = settings.global.on_team_lost_message.value
	if message == "" then return end
	if not event.name then return end

	message = event.name .. message
	local json = '{"embed":{"thumbnail":{"url":"http://www.myiconfinder.com/uploads/iconsets/64-64-38d8aa0ebb1fd129165a3251d25e99ac-ip.png"},"description":"' .. message .. '"}}'
	zo_factocord.SendDiscordEmbedMessage(json)
end

local function on_team_won(event)
	local message = settings.global.on_team_won_message.value
	if message == "" then return end
	if not event.name then return end

	message = event.name .. message
	local json = '{"embed":{"thumbnail":{"url":"https://clipart.wpblink.com/sites/default/files/wallpaper/winner-ribbon-clipart/84371/winner-ribbon-clipart-icon-84371-9138530.png"},"description":"' .. message .. '"}}'
	zo_factocord.SendDiscordEmbedMessage(json)
end

local function on_player_joined_team(event)
	local message = settings.global.on_player_joined_team_message.value
	if not (event.player_index and event.team and event.team.name) then return end
	if message == "" then return end

	local player = game.players[event.player_index]
	message = player.name .. " " .. message .. " " .. event.team.name

	zo_factocord.SendDiscordMessage(message)
end

local function handle_events()
	for interface_name, _ in pairs( remote.interfaces ) do
		local function_name = "get_event_name"
		if remote.interfaces[interface_name][function_name] then
			local event_ID
			event_ID = remote.call(interface_name, function_name, "on_round_end")
			if (type(event_ID) == "number") then
				if (script.get_event_handler(event_ID) == nil) then
					module.events[event_ID] = on_round_end
				end
			end

			event_ID = remote.call(interface_name, function_name, "on_round_start")
			if (type(event_ID) == "number") then
				if (script.get_event_handler(event_ID) == nil) then
					module.events[event_ID] = on_round_start
				end
			end

			event_ID = remote.call(interface_name, function_name, "on_team_lost")
			if (type(event_ID) == "number") then
				if (script.get_event_handler(event_ID) == nil) then
					module.events[event_ID] = on_team_lost
				end
			end

			event_ID = remote.call(interface_name, function_name, "on_team_won")
			if (type(event_ID) == "number") then
				if (script.get_event_handler(event_ID) == nil) then
					module.events[event_ID] = on_team_won
				end
			end

			event_ID = remote.call(interface_name, function_name, "on_player_joined_team")
			if (type(event_ID) == "number") then
				if (script.get_event_handler(event_ID) == nil) then
					module.events[event_ID] = on_player_joined_team
				end
			end
		end
	end
	event_listener.update_events()
end
module.on_load = handle_events
module.on_init = handle_events

return module

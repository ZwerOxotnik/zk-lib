-- Copyright (C) 2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

-- You can attach this file via \/
-- local zo_factocord = require("__zo_library__/zo_library/util/zo_factocord")

-- SEE https://github.com/maxsupermanhd/FactoCord-3.0/blob/master/support/chat.go
-- Example: '{"content":"test", "embed":{"thumbnail":{ "url": "https://cdn.discordapp.com/embed/avatars/0.png%22%7D, "title":"test"}}'

--[[
    Functions:

    GetServerDate()
    SendDiscordEmbedMessage(json) -- SEE for embed messages https://godoc.org/github.com/bwmarrin/discordgo#MessageSend (use json type)
    SendDiscordMessage(message)
    PlayerSayInDiscord(player, message)
    PlayerSayInGame(player, message)
    PlayerSay(player, message) -- PlayerSayInGame + PlayerSayInDiscord
]]

local zo_factocord = {}

local GetRealNickname = require("__zo-library__/zo-library/util/zo_player").GetRealNickname

local function GetServerDate()
    return "0000-00-00 00:00:00 "
end
zo_factocord.GetServerDate = GetServerDate

zo_factocord.SendDiscordEmbedMessage = function(json)
    print(GetServerDate() .. "[EMBED] " .. json)
end

zo_factocord.SendDiscordMessage = function(message)
    print(GetServerDate() .. "[EMBED] {\"content\":\"" .. message .. "\"}")
end

zo_factocord.PlayerSayInDiscord = function(player, message)
    print(GetServerDate() .. "[CHAT] " .. GetRealNickname(player) .. ": " .. message)
end

-- WIP
zo_factocord.PlayerSayInGame = function(player, message)
    game.print(player.name .. ": " .. message)
end

zo_factocord.PlayerSay = function(player, message)
    zo_factocord.PlayerSaysInDiscord(player, message)
    zo_factocord.PlayerSaysInGame(player, message)
end

return zo_factocord

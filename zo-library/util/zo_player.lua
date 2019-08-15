-- Copyright (C) 2019 ZwerOxotnik <zweroxotnik@gmail.com>
-- Licensed under the EUPL, Version 1.2 only (the "LICENCE");

-- You can attach this file via \/
-- local zo_player = require("__zo_library__/zo_library/util/zo_player")

local zo_player = {}

--[[
    Functions:

    GetRealNickname(player)
]]

zo_player.GetRealNickname = function(player)
    if game then
        local interface_name = "nick-changer"
        if remote.interfaces[interface_name] then
            return remote.call(interface_name, "get_real_name_by_player_index", player.index)
        end
    end

    return player.name
end

return zo_player
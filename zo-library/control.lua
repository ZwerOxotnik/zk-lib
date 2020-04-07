--[[
Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Author: ZwerOxotnik

You can attach this library via \/
local zo_library = require("__zo_library__/zo_library/util/list")
and turn on the "ZwerOxotnik's library" mod.
If you want to attach the file in a mod/scenario then don't forget about depencies in your info.json (https://wiki.factorio.com/Tutorial:Modding_FAQ)
OR copy and paste the file in any project/scenario for handling events.

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/zo-library
Mod portal: https://mods.factorio.com/mod/zo-library

]]--

-- local zo_util = require("zo-library/util/list")
local zo_library = {}
zo_library.events = {}

remote.remove_interface('zo-library')
remote.add_interface('zo-library', {})


-- TODO: handle events + setting
-- on_player_died(event) -- sends discord [embed] message

return zo_library

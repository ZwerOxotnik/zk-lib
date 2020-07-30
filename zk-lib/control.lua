--[[
Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
]]--

local zk_lib = {}
remote.remove_interface('zk-lib')
remote.add_interface('zk-lib', {})

zk_lib.on_init = function()
    global.zk_lib = global.zk_lib or {}
end

zk_lib.events = {}
return zk_lib

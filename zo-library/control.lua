--[[
Copyright (C) 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
]]--

local zk_library = {}
zk_library.events = {}

remote.remove_interface('zk-lib')
remote.add_interface('zk-lib', {})

return zk_library

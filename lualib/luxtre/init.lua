---@diagnostic disable: need-check-nil

--[[
    module name: luxtre

    luxtre.loadfile(filename) > loads file/returns chunk
    luxtre.dofile(filename) > runs file
    luxtre.loadstring / dostring > same as above with string input
    luxtre.compile_file(filename) > compiles file to .lua

    include require loader for .lux file extension
--]]

local path = (...):gsub("init", "")
local create_loaders = require(path .. "grammars/generate_loaders")
local data = require(path .. "utils/data")

local module = {VERSION = "0.6.1"}

local default_loaders = create_loaders( ".lux", {data.__binary_prefix .. path .. "grammars/luxtre_standard" })

-- module.loadfile = default_loaders.loadfile
-- module.dofile = default_loaders.dofile
module.loadstring = default_loaders.loadstring
module.dostring = default_loaders.dostring
-- module.compile_file = default_loaders.compile_file
module.register = default_loaders.register

module.create_loaders = create_loaders

module.auto_compile = function(bool)
    data.compile_files = bool
end

return module

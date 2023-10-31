IS_DATA_STAGE=true
ZKLIB_DEFINES = require("defines")
lazyAPI = require(ZKLIB_DEFINES.modules.lazyAPI)
simpleTiers = require(ZKLIB_DEFINES.modules.simpleTiers)
easyTemplates = require(ZKLIB_DEFINES.modules.easyTemplates)
puan_api = require(ZKLIB_DEFINES.modules.puan_api)
puan2_api = require(ZKLIB_DEFINES.modules.puan2_api)
fakes = require(ZKLIB_DEFINES.modules.fakes)
zk_lib = require(ZKLIB_DEFINES.modules.zk_lib)
zk_SPD = require(ZKLIB_DEFINES.modules.SPD)
zk_SPD.create_container("important-no-cheat-recipes")
require("sound/sounds_list")


compat = require(ZKLIB_DEFINES.modules.penlight.compat)
warn "@on"


require("prototypes/sprites")
require("prototypes/styles")


lazyAPI.attach_custom_input_event("move-down")
lazyAPI.attach_custom_input_event("move-left")
lazyAPI.attach_custom_input_event("move-right")
lazyAPI.attach_custom_input_event("move-up")
lazyAPI.attach_custom_input_event("mine")
lazyAPI.attach_custom_input_event("toggle-map")


-- TODO: create special scripts
-- lazyAPI.create_trigger_capsule({
--   name = "zk-select", -- this is fake cursor to find cursor position via https://lua-api.factorio.com/latest/events.html#on_script_trigger_effect
--   icon = "__zk-lib__/graphics/select.png", --"__core__/graphics/mouse-cursor.png",
--   radius_color = {0, 0, 0, 0}
-- })


if data.raw["speech-bubble"]["speech-bubble-no-fade"] == nil then
	data:extend({{
		type = "speech-bubble",
		name = "speech-bubble-no-fade",
		style = "compilatron_speech_bubble",
		wrapper_flow_style = "compilatron_speech_bubble_wrapper",
		fade_in_out_ticks = 5,
		flags = {"not-on-map", "placeable-off-grid"}
	}})
end


-- Add sprites from zk_sprite_list.lua
for mod_name in pairs(mods) do
	local is_ok, decal_list = pcall(require, string.format("__%s__/zk_sprite_list", mod_name))
	if is_ok then
		for _, _data in pairs(decal_list) do
			if _data.filename:sub(1,1) ~= "_" and _data.filename:sub(2,2) ~= "_" then
				_data.filename = string.format("__%s__/%s", mod_name, _data.filename)
			end
			---@diagnostic disable-next-line: redundant-parameter
			lazyAPI.add_prototype(table.deepcopy(_data))
		end
	end
end

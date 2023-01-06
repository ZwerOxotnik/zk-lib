lazyAPI = require("experimental/lazyAPI")
local lazyAPI = lazyAPI
simpleTiers = require("experimental/simpleTiers")
puan_api = require("data-api/puan_api")
fakes = require("data-api/fakes")
zk_lib = require("data-api/zk_lib")
zk_SPD = require("experimental/SPD")
zk_SPD.create_container("important-no-cheat-recipes")
require("sound/sounds_list")


require("prototypes/utility-sprites")
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

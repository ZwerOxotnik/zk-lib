puan_api = require("data-api/puan_api")
fakes = require("data-api/fakes")
zk_lib = require("data-api/zk_lib")
require("sound/sounds_list")


local MOD_PATH = "__zk-lib__"


require("prototypes/utility-sprites")


zk_lib.attach_custom_input_event("move-down")
zk_lib.attach_custom_input_event("move-left")
zk_lib.attach_custom_input_event("move-right")
zk_lib.attach_custom_input_event("move-up")
zk_lib.attach_custom_input_event("mine")
zk_lib.attach_custom_input_event("toggle-map")

-- TODO: create special scripts
-- zk_lib.create_tool({
--   name = "zk-select", -- this is fake cursor to find cursor position via https://lua-api.factorio.com/latest/events.html#on_script_trigger_effect
--   icon = MOD_PATH .. "/graphics/select.png", --"__core__/graphics/mouse-cursor.png",
--   radius_color = {0, 0, 0, 0}
-- })

if data.raw["speech-bubble"]["speech-bubble-no-fade"] == nil then
  data:extend({
    {
      type = "speech-bubble",
      name = "speech-bubble-no-fade",
      style = "compilatron_speech_bubble",
      wrapper_flow_style = "compilatron_speech_bubble_wrapper",
      fade_in_out_ticks = 5,
      flags = {"not-on-map", "placeable-off-grid"}
    }
  })
end

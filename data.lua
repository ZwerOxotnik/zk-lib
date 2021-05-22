puan_api = require("data-api/puan_api")
fakes = require("data-api/fakes")
zk_lib = require("data-api/zk_lib")
require("sound/sounds_list")

-- Extends game interactions, see https://wiki.factorio.com/Prototype/CustomInput#linked_game_control
zk_lib.attach_custom_input_event("move-down")
zk_lib.attach_custom_input_event("move-left")
zk_lib.attach_custom_input_event("move-right")
zk_lib.attach_custom_input_event("move-up")
zk_lib.attach_custom_input_event("mine")
zk_lib.attach_custom_input_event("toggle-map")

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

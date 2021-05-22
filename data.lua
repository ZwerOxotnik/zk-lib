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

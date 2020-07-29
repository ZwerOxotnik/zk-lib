require("data-api/puan_api")

local sounds_list = require("sound/sounds_list")
sounds_list.name = "zk-lib"
sounds_list.path = "__zk-lib__/sound/"
puan_api.add_sounds(sounds_list)
puan_api.add_sounds_in_programmable_speaker(sounds_list)

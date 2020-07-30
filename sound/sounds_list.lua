-- Please, do not change this file if you're not sure, except sounds_list.name!
-- More info: https://www.reddit.com/r/ZwerOxotnik/comments/dv7tpx/you_want_your_own_mod_stay_tuned/
-- You need require this file to your control.lua and add https://mods.factorio.com/mod/zk-lib in your dependencies
local sounds_list = { 
	name = "zk-lib", --change me, if you want add these sounds to programmable speakers
	path = "__zk-lib__/sound/", -- path to this folder
	sounds = { 
		{ 
			name = "flashlight-click", 
		}, 
		{ 
			name = "guiclick", 
		}, 
		{ 
			name = "infobleep", 
		}, 
		{
			name = "interface3", 
		}, 
		{ 
			name = "tone-beep-lower-slower", 
		}, 
	} 
} 
if puan_api then puan_api.add_sounds(sounds_list) end 
return sounds_list 

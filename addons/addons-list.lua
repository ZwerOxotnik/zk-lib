-- # Table of all addons
-- Contains
-- author :: string (optional): Author of the addon
-- mod_portal_page :: string (optional): mod portal of the addon
-- homepage :: string (optional): Homepage of the addon
-- path :: string (optional): loads custom path of your addon (default is __zk-lib__/addons/%your-mod-name%.lua)
-- have_settings :: boolean (optional): loads file __zk-lib__/addons/settings/%your-mod-name%.lua
-- blacklist :: array of strings (optional): incompatible mods (not addons!)

-- Note: some parameters will be changed in the future.

return {
	["delete_decorations"] = {author = "ZwerOxotnik"},
	["kill-nest-get-gifts"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/kill-nest-get-gift", blacklist = {"kill-nest-get-gift"}},
	["random-gifts-by-timer"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/random-gifts-by-timer", blacklist = {"random-gifts-by-timer"}},
	["scan-rocket-with-radars"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/scan-rocket-with-radars", have_settings = true, blacklist = {"scan-rocket-with-radars"}},
	["teams-zo"] = {author = "ZwerOxotnik", blacklist = {"teams-zo"}},
	["auto-mining"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/auto-mining", blacklist = {"auto-mining"}},
	["timesaver-for-crafting"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/timesaver-for-crafting", path = "addons/timesaver-for-crafting/control", blacklist = {"timesaver-for-crafting"}},
	["searching-flashlight"] = {author = "rk84", mod_portal_page = "https://mods.factorio.com/mod/searching-flashlightR", homepage = "https://forums.factorio.com/viewtopic.php?f=144&t=20712", path = "addons/searching-flashlight/control", blacklist = {"searching-flashlightR"}},
	["PrivateElectricity"] = {author = "ZwerOxotnik"},
	["restrict_building"] = {author = "ZwerOxotnik", have_settings = true}
}
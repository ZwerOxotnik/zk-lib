-- # Table of insecure addons
-- Contains
-- author :: string (optional): Author of the addon
-- mod_portal_page :: string (optional): mod portal of the addon
-- homepage :: string (optional): Homepage of the addon
-- path :: string (optional): loads custom path of your addon (default is __zk-lib__/addons/%your-mod-name%.lua)
-- have_settings :: boolean (optional): loads file __zk-lib__/addons/settings/%your-mod-name%.lua
-- blacklist :: array of strings (optional): incompatible mods (not addons!)

-- Note: some parameters will be changed in the future.

return {
	["CopyAssemblerPipeDirection"] = {author = "IronCartographer", blacklist = {"CopyAssemblerPipeDirection"}, mod_portal_page = "https://mods.factorio.com/mod/CopyAssemblerPipeDirection"},
	["scan-rocket-with-radars"] = {author = "ZwerOxotnik", mod_portal_page = "mods.factorio.com/mod/scan-rocket-with-radars", have_settings = true, blacklist = {"scan-rocket-with-radars"}},
	["delete_decorations"] = {author = "ZwerOxotnik"},
	["teams-zo"] = {author = "ZwerOxotnik", blacklist = {"teams-zo"}, path = "addons/teams-zo/control"},
	["PrivateElectricity"] = {author = "ZwerOxotnik"},
	["restrict_building"] = {author = "ZwerOxotnik", have_settings = true}
}
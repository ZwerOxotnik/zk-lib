data:extend({
	{
		type = "bool-setting",
		name = "zk-lib-warn-about-addons",
		setting_type = "startup",
		default_value = true
	},
	-- {
	-- 	type = "bool-setting",
	-- 	name = "zk_commands",
	-- 	setting_type = "runtime-global",
	-- 	default_value = true
	-- },
	{
		type = "bool-setting",
		name = "EL_debug-mode",
		setting_type = "runtime-global",
		default_value = false
	},
	{
		type = "bool-setting",
		name = "EL_logs-mode",
		setting_type = "runtime-global",
		default_value = false
	},
	{
		type = "bool-setting",
		name = "zk-lib_safe-mode",
		setting_type = "runtime-global",
		default_value = true
	},
	{
		type = "bool-setting",
		name = "zk-lib_special-message",
		setting_type = "runtime-per-user",
		default_value = true
	}
})

local addons_list = require("addons/addons-list")

local function check_blacklist(blacklist, name)
	for _, x_mod_name in pairs(blacklist) do
		for mod_name, _ in pairs(mods) do
			if x_mod_name == mod_name then
				addons_list[name] = nil
				return
			end
		end
	end
end

for name, addon in pairs(addons_list) do
	if addon.blacklist then
		check_blacklist(addon.blacklist, name)
	end
end

addons_settings = {}
for name, addon in pairs(addons_list) do
	table.insert(addons_settings, {
		type = "bool-setting",
		name = "zk-lib_" .. name,
		setting_type = "startup",
		default_value = false,
    localised_name = {"", "[color=orange]", {"zk-lib.addons"}, {"colon"}, "[/color] ", {"mod-name." .. name}},
		localised_description = {"", {"gui-mod-info.description"} , {"colon"}, " ", {"mod-description." .. name}, "\n\n",
			{"gui-mod-info.author"} , {"colon"}, " ", addon.author or "", "\n",
			{"gui-mod-info.mod-portal-page"} , {"colon"}, " ", addon.mod_portal_page or "", "\n",
			{"gui-mod-info.homepage"} , {"colon"}, " ", addon.homepage or ""
		}
	})
end
data:extend(addons_settings)

require("addons/settings/scan-rocket-with-radars")

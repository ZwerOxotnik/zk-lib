local addons_api = require("addons/core/addons_api")

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

local insecure_addons_list = require("addons/core/insecure-addons-list")
addons_api.remove_duplicate_addons(insecure_addons_list)

local addons_settings = {}
for name, addon in pairs(insecure_addons_list) do
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
if #addons_settings > 0 then
	data:extend(addons_settings)
end

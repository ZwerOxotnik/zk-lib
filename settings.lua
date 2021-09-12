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
data:extend(addons_settings)

local mods_settings = {}
for name in pairs(mods) do
	local is_ok = pcall(require, "__" .. name .. "__/switchable_mod")
	if is_ok then
		local setting_name = "mod_" .. name
		table.insert(mods_settings, {
			type = "bool-setting",
			name = setting_name,
			order = setting_name,
			setting_type = "runtime-global",
			default_value = true,
			localised_name = {"", "[color=orange]", "Mod", {"colon"}, "[/color] ", {"mod-name." .. name}},
		})
	end
end
if #mods_settings > 0 then
	data:extend(mods_settings)
end

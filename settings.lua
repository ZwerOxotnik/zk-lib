data:extend({
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
		name = "zk-lib_special-message",
		setting_type = "runtime-per-user",
		default_value = true
	}
})

local addons_list = require("addons/addons-list")

addons_settings = {}
for _, name in pairs(addons_list) do
	table.insert(addons_settings, {
		type = "string-setting",
		name = "zk-lib_" .. name,
		setting_type = "startup",
		default_value = "disabled",
		allowed_values = {"disabled", "enabled", "mutable"}
	})
end
data:extend(addons_settings)
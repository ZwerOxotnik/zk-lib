IS_SETTING_STAGE = true
local addons_api = require("addons/core/addons_api")
ZKSettings = require("__zk-lib__/experimental/ZKSettings")
local ZKSettings = ZKSettings

ZKSettings.create_bool_setting("zk-lib-warn-about-addons")
ZKSettings.create_bool_setting("EL_debug-mode", "runtime-global", false)
ZKSettings.create_bool_setting("EL_logs-mode", "runtime-global", false)
-- ZKSettings.create_bool_setting("zk_commands", "runtime-global", true)
ZKSettings.create_bool_setting("zk-lib_safe-mode", "runtime-global", true)
ZKSettings.create_bool_setting("zk-lib_special-message", "runtime-per-user", true)

local insecure_addons_list = require("addons/core/insecure-addons-list")
addons_api.remove_duplicate_addons(insecure_addons_list)


local COLON = {"colon"}


for name, addon in pairs(insecure_addons_list) do
	ZKSettings.create_bool_setting("zk-lib_" .. name, "startup", false, {
    localised_name = {'', "[color=orange]", {"zk-lib.addons"}, COLON, "[/color] ", {"mod-name." .. name}},
		localised_description = {'', {"gui-mod-info.description"}, COLON, " ", {"mod-description." .. name}, "\n\n",
			{"gui-mod-info.author"}, COLON, " " .. (addon.author or '') .. "\n",
			{"gui-mod-info.mod-portal-page"}, COLON, " " .. (addon.mod_portal_page or '') .. "\n",
			{"gui-mod-info.homepage"} , COLON, " " .. (addon.homepage or '')
		}
	})
end

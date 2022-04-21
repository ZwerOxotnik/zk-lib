ZKSettings.set_default_colors()

local addons_api = require("addons/core/addons_api")
local insecure_addons_list = require("addons/core/insecure-addons-list")
local safe_addons_list = require("addons/core/safe-addons-list")
addons_api.remove_duplicate_addons(safe_addons_list)


local COLON = {"colon"}


for name, addon in pairs(insecure_addons_list) do
  if data.raw["bool-setting"]["zk-lib_" .. name] then
    ZKSettings.create_bool_setting("zk-lib-during-game_" .. name, "runtime-global", false, {
      localised_name = {'', "[color=orange]! ", {"zk-lib.addons"}, COLON, "[/color] ", {"mod-name." .. name}},
      localised_description = {'', "[color=orange]", {"zk-lib.insecure-addon"}, "[/color]\n\n",
        {"gui-mod-info.description"} , COLON, {"mod-description." .. name}, "\n\n",
        {"gui-mod-info.author"} , COLON, (addon.author or '') .. "\n",
        {"gui-mod-info.mod-portal-page"} , COLON, (addon.mod_portal_page or '') .. "\n",
        {"gui-mod-info.homepage"} , COLON, addon.homepage or ''
      }
    })
    if addon.have_settings then
      require("addons/settings/" .. name)
    end
  end
end

for name, addon in pairs(safe_addons_list) do
  ZKSettings.create_bool_setting("zk-lib-during-game_" .. name, "runtime-global", false, {
    localised_name = {'', "[color=orange]", {"zk-lib.addons"}, COLON, "[/color] ", {"mod-name." .. name}},
    localised_description = {'', {"gui-mod-info.description"} , COLON, " ", {"mod-description." .. name}, "\n\n",
      {"gui-mod-info.author"} , COLON, " " .. (addon.author or '') .. "\n",
      {"gui-mod-info.mod-portal-page"} , COLON, " " .. (addon.mod_portal_page or '') .. "\n",
      {"gui-mod-info.homepage"} , COLON, " " .. (addon.homepage or '')
    }
  })
  if addon.have_settings then
    require("addons/settings/" .. name)
  end
end

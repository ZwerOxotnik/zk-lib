local addons_api = require("addons/core/addons_api")
local insecure_addons_list = require("addons/core/insecure-addons-list")
local safe_addons_list = require("addons/core/safe-addons-list")
addons_api.remove_duplicate_addons(safe_addons_list)

for name, addon in pairs(insecure_addons_list) do
  if data.raw["bool-setting"]["zk-lib_" .. name] then
    data:extend({{
      type = "bool-setting",
      name = "zk-lib-during-game_" .. name,
      setting_type = "runtime-global",
      default_value = false,
      localised_name = {"", "[color=orange]! ", {"zk-lib.addons"}, {"colon"}, "[/color] ", {"mod-name." .. name}},
      localised_description = {"", "[color=orange]", {"zk-lib.insecure-addon"}, "[/color]\n\n",
        {"gui-mod-info.description"} , {"colon"}, {"mod-description." .. name}, "\n\n",
        {"gui-mod-info.author"} , {"colon"}, addon.author or "", "\n",
        {"gui-mod-info.mod-portal-page"} , {"colon"}, addon.mod_portal_page or "", "\n",
        {"gui-mod-info.homepage"} , {"colon"}, addon.homepage or ""
      }
    }})
    if addon.have_settings then
      require("addons/settings/" .. name)
    end
  end
end

for name, addon in pairs(safe_addons_list) do
  data:extend({{
    type = "bool-setting",
    name = "zk-lib-during-game_" .. name,
    setting_type = "runtime-global",
    default_value = false,
    localised_name = {"", "[color=orange]", {"zk-lib.addons"}, {"colon"}, "[/color] ", {"mod-name." .. name}},
    localised_description = {"", {"gui-mod-info.description"} , {"colon"}, " ", {"mod-description." .. name}, "\n\n",
      {"gui-mod-info.author"} , {"colon"}, " ", addon.author or "", "\n",
      {"gui-mod-info.mod-portal-page"} , {"colon"}, " ", addon.mod_portal_page or "", "\n",
      {"gui-mod-info.homepage"} , {"colon"}, " ", addon.homepage or ""
    }
  }})
  if addon.have_settings then
    require("addons/settings/" .. name)
  end
end

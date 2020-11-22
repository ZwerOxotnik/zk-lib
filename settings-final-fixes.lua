local addons_list = require("addons/addons-list")

for name, addon in pairs(addons_list) do
  if data.raw["bool-setting"]["zk-lib_" .. name] then
    data:extend({{
      type = "bool-setting",
      name = "zk-lib-during-game_" .. name,
      setting_type = "runtime-global",
      default_value = true,
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
end

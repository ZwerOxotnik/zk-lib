local addons_list = require("addons/addons-list")

for name, addon in pairs(addons_list) do
  if data.raw["string-setting"]["zk-lib_" .. name] then
    data:extend({{
      type = "bool-setting",
      name = "zk-lib-during-game_" .. name,
      setting_type = "runtime-global",
      default_value = true,
      localised_name = {"", {"zk-lib.addons"}, " ", {"mod-name." .. name}},
      localised_description = {"mod-description." .. name}
    }})
    if addon.have_settings then
      require("addons/settings/" .. name)
    end
  end
end

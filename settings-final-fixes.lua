local addons_list = require("addons/addons-list")

addons_settings = {}
for _, name in pairs(addons_list) do
  table.insert(addons_settings, {
    type = "string-setting",
    name = "zk-lib-during-game_" .. name,
    setting_type = "runtime-global",
    default_value = "enabled",
    allowed_values = {"disabled", "enabled"},
    localised_name = {"mod-setting-name.zk-lib_" .. name},
    localised_description = {"mod-setting-description.zk-lib_" .. name}
  })
end
data:extend(addons_settings)

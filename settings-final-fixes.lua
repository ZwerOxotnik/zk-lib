local addons_list = require("addons/addons-list") --TODO: add blaclist of mods and add setting path within

addons_settings = {}
for _, name in pairs(addons_list) do
  if data.raw["string-setting"]["zk-lib_" .. name] then
    table.insert(addons_settings, {
      type = "string-setting",
      name = "zk-lib-during-game_" .. name,
      setting_type = "runtime-global",
      default_value = "enabled",
      allowed_values = {"disabled", "enabled"},
      localised_name = {"mod-name." .. name},
      localised_description = {"mod-description." .. name}
    })
  end
end
data:extend(addons_settings)

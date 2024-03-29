-- Currently, this is an experimental library with new features for settings. (anything can be changed, removed, added etc.)
---@module "__zk-lib__/experimental/ZKSettings"
---@class ZKSettings
local ZKSettings = {}
ZKSettings.source = "https://github.com/ZwerOxotnik/zk-lib"
ZKSettings.sections = {}
ZKSettings.setting_descriptions = {
	["int-setting"] = {},
	["double-setting"] = {},
	["string-setting"] = {},
	["bool-setting"] = {}
}
ZKSettings.title_color = "green"
ZKSettings.note_color = "gray"


local Version = require("static-libs/lualibs/version")
local Locale = require("static-libs/lualibs/locale")
ZKSettings.array_to_locale = Locale.array_to_locale
ZKSettings.array_to_locale_as_new = Locale.array_to_locale_as_new
ZKSettings.locale_to_array = Locale.locale_to_array
ZKSettings.merge_locales = Locale.merge_locales
ZKSettings.merge_locales_as_new = Locale.merge_locales_as_new


---@alias setting_type "int-setting" | "double-setting" | "string-setting" | "bool-setting"


---@param name string
ZKSettings.sections.if_mod_detected = function(name)
	--WIP
end


---@param name string
ZKSettings.sections.if_not_mod_detected = function(name)
	--WIP
end


ZKSettings.sections.add_subsections = function(name)
	--WIP
end


ZKSettings.sections.add_section = function(title)
	--WIP
end


---@return setting table
ZKSettings.show_default_value = function(setting)
	local name = setting.name
	local type = setting.type
	local setting_description = ZKSettings.setting_descriptions[type][name]
	if setting_description == nil then
		ZKSettings.setting_descriptions[type][name] = {}
		setting_description = ZKSettings.setting_descriptions[type][name]
	end
	setting_description.default_value = {"[color=yellow](", {"map-gen-preset-name.default"}, {"colon"}, ' ' .. tostring(setting.default_value) .. ")[/color]"}
end


-- Use ZKSettings.get_description_localization(setting) to get localization
---@param setting table
---@return table?
ZKSettings.get_setting_description = function(setting)
	return ZKSettings.setting_descriptions[setting.type][setting.name]
end


---@param setting table
---@return table?
ZKSettings.get_description_localization = function(setting)
	local setting_description = ZKSettings.setting_descriptions[setting.type][setting.name]
	if setting_description == nil then return end

	local default_localised_description = setting_description.default_localised_description
	if setting_description.default_value then
		local array = {}
		for i, v in pairs(setting_description.default_value) do
			array[i] = v
		end
		table.insert(array, 1, '')
		local locale = ZKSettings.array_to_locale(array)
		if default_localised_description then
			array[2] = "\n\n" .. array[2]
			return ZKSettings.merge_locales(default_localised_description, locale)
		else
			return locale
		end
	else
		return default_localised_description
	end
end


---@param setting table
ZKSettings.remember_setting = function(setting)
	local name = setting.name
	local type = setting.type
	local setting_description = ZKSettings.setting_descriptions[type][name]
	if setting_description == nil then
		ZKSettings.setting_descriptions[type][name] = {
			default_localised_description = setting.localised_description
		}
	end
end


---@param setting table
ZKSettings.forget_setting = function(setting)
	ZKSettings.setting_descriptions[setting.type][setting.name] = nil
end


---@param setting table
ZKSettings.delete_setting = function(setting)
	local name = setting.name
	local type = setting.type
	data.raw[type][name] = nil
	ZKSettings.setting_descriptions[type][name] = nil
end


-- https://wiki.factorio.com/Tutorial:Mod_settings
---@param name string
---@param _type string
---@param setting_type? setting_type #"startup" by default
---@param default_value any
---@param setting_data? table
---@return table setting_data
ZKSettings.create_setting = function(name, _type, setting_type, default_value, setting_data)
	setting_data = setting_data or {}
	setting_data.type = _type
	setting_data.name = name
	setting_type = setting_type or setting_data.setting_type or "startup"
	setting_data.setting_type = setting_type
	if type(default_value) == "nil" then
		default_value = setting_data.default_value
	end
	setting_data.default_value = default_value

	if _type == "bool-setting" then
		-- Don't mess with boolean logic
		if default_value or default_value == nil then
			setting_data.default_value = true
		else
			setting_data.default_value = false
		end
	end

	data:extend({setting_data})
	ZKSettings.remember_setting(setting_data)
	if Version.get_mod_version("base") < Version.string_to_version("1.1.61") then
		ZKSettings.show_default_value(setting_data)
	end
	setting_data.localised_description = ZKSettings.get_description_localization(setting_data)
	return setting_data
end


-- https://wiki.factorio.com/Tutorial:Mod_settings
---@param name string
---@param setting_type? setting_type #"startup" by default
---@param default_value? boolean #true by default
---@param setting_data? table
---@return table setting_data
ZKSettings.create_bool_setting = function(name, setting_type, default_value, setting_data)
	return ZKSettings.create_setting(name, "bool-setting", setting_type, default_value, setting_data)
end


---@param prefix string
---@param commands_data table
ZKSettings.create_setting_for_commands = function(prefix, commands_data)
	--WIP
end


ZKSettings.set_default_colors = function()
	ZKSettings.title_color = "green"
	ZKSettings.note_color = "gray"
end


return ZKSettings

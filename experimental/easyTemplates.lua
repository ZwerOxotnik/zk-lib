-- easyTemplates is a experimental part of lazyAPI


---@class easyTemplates
---@module "__zk-lib__/experimental/easyTemplates"
local easyTemplates = {_VERSION = "0.0.1"}
local lazyAPI = require("experimental/lazyAPI")


local log, debug = log, debug


---@class easyTemplate
---@field prototype table
---@field output_prototypes table[]
---@field create_from_template function(table)

---@type table<string, table<string, easyTemplate>>
easyTemplates.templates = {}
for _type in pairs(data.raw) do
	easyTemplates.templates[_type] = {}
end


---@param template easyTemplate
---@param new_data table
easyTemplates._create_from_template = function(template, new_data)
	if new_data.name == nil then
		log(("New prototype doesn't have new name (easyTemplate)"):format(_type, name))
		log(debug.traceback())
	end

	local new_prototype = table.deepcopy(template.prototype)
	for k, v in pairs(new_data) do
		new_prototype[k] = v
	end

	local _, wrapped_new_prototype = lazyAPI.add_prototype(new_prototype)
	lazyAPI.base.add_to_array(template.output_prototypes, new_prototype)
	return new_prototype, wrapped_new_prototype
end

---@param _type string
---@param name string
---@param prototype_data table
---@return easyTemplate
easyTemplates.add_template = function(_type, name, prototype_data)
	local template_group = easyTemplates.templates[_type]
	local prev_template = template_group[name]
	if prev_template then
		log(("WARNING: template with type \"%s\" and name \"%s\" will be overwritten in easyTemplates"):format(_type, name))
		log(debug.traceback())
		lazyAPI.notify_on_pre_template_removed(_type, name, prev_template)
	end

	local template = {
		prototype = prototype_data,
		output_prototypes = {},
		create_from_template = easyTemplates._create_from_template -- Perhaps, I should use a metatable instead
	}
	template_group[name] = template
	lazyAPI.notify_on_new_template(_type, name, template)

	return template
end


---@param _type string
---@param name string
---@return easyTemplate?
easyTemplates.get_template = function(_type, name)
	return easyTemplates.templates[_type][name]
end


---@param _type string
---@param name string
---@return table[]?
easyTemplates.get_output_prototypes = function(_type, name)
	local template = easyTemplates.templates[_type][name]
	if template then
		return template.output_prototypes
	end
end


---@param _type string
---@param name string
---@param new_data table
easyTemplates.create_from_template = function(_type, name, new_data)
	if new_data.name == nil then
		log(("New prototype with type \"%s\" and name \"%s\" doesn't have new name (easyTemplate)"):format(_type, name))
		log(debug.traceback())
	end

	local template = easyTemplates.templates[_type][name]
	local new_prototype = table.deepcopy(template.prototype)
	for k, v in pairs(new_data) do
		new_prototype[k] = v
	end

	local _, wrapped_new_prototype = lazyAPI.add_prototype(new_prototype)
	local _, is_added = lazyAPI.base.add_to_array(template.output_prototypes, new_prototype)
	if is_added then
		lazyAPI.notify_on_new_prototype_from_template(_type, name, template, new_prototype)
	end

	return new_prototype, wrapped_new_prototype
end


return easyTemplates

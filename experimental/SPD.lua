-- NOT TESTED, WIP
-- Simple postdate data
local SPD = {}


local tinsert = table.insert
local assert = assert
local type = type


SPD.containers = {}
local containers = SPD.containers
local performer_name

---@param func function
---@param container_name string
---@param func_name string # Use it for identification
---@param position? number
---@return boolean # is added?
SPD.add_function = function(container_name, func, func_name, position)
	local container = containers[container_name]
	if container == nil then return false end
	assert(type(func_name) == "string", "The func_name isn't string")
	if position then
		tinsert(container.functions, position, {func, func_name})
	else
		local functions = container.functions
		functions[#functions+1] = {func, func_name}
	end
	return true
end

---@param container_name string
---@param element any
---@return boolean # is added?
SPD.add_element = function(container_name, element)
	local container = containers[container_name]
	if container == nil then return false end
	local data = container.data
	data[#data+1] = element
	return true
end

---@param name string
---@return table # container
SPD.create_container = function(name)
	containers[name] = containers[name] or {}
	local container = containers[name]
	container.data = container.data or {}
	container.functions = container.functions or {}
	return container
end

---@param name string
SPD.get_container = function(name)
	return containers[name]
end

---@param mod_name string
SPD.register_mod = function(mod_name)
	performer_name = mod_name
end

---@param mod_name string
---@return boolean # is performed?
SPD.process = function(mod_name)
	if performer_name ~= mod_name then return false end

	for name, container in pairs(containers) do
		local data = container.data
		local functions = container.functions
		for i=1, #functions do
			local func = functions[i][1]
			for j=#data, 1, -1 do
				func(data[j], container, name, j)
			end
		end
	end

	SPD.containers = {}
	containers = SPD.containers
	return true
end

return SPD

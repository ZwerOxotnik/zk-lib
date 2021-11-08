-- NOT TESTED, WIP
-- Simple postdate data
local SPD = {}

local tunpack = table.unpack
local assert = assert
local type = type

SPD.containers = {}
local containers = SPD.containers

---@param func function
---@param container_name string
---@param func_name string # Use it for identification
---@return boolean # is added?
SPD.add_function = function(container_name, func, func_name)
	local container = containers[container_name]
	if container == nil then return false end
	local functions = container.functions
	functions[#functions+1] = {func, func_name}
	return true
end

---@param container_name string
---@param element table
---@return boolean # is added?
SPD.add_element = function(container_name, element)
	local container = containers[container_name]
	if container == nil then return false end
	assert(type(element) == "table", "The element isn't table")
	local data = container.data
	data[#data+1] = element
	return true
end

---@param name string
---@return table # empty container
SPD.create_container = function(name)
	containers[name] = containers[name] or {}
	local container = containers[name]
	container.data = container.data or {}
	container.functions = container.functions or {}
	return container
end

SPD.get_container = function(name)
	return containers[name]
end

SPD.process = function()
	for _, container in pairs(containers) do
		local data = container.data
		local functions = container.functions
		for i=1, #functions do
			local func = functions[i][1]
			for j=1, #data do
				local element = data[j]
				func(tunpack(element))
			end
		end
	end

	SPD.containers = {}
	containers = SPD.containers
end

return SPD

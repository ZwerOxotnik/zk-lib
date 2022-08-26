return [[
{%
local function check_localness(out, varname)
	if not out.data.__setup_env then
		local ln = out:push_header()
]] ..
"		ln:append([[\n" .. [[
local _ENV = _ENV
if _VERSION < "Lua 5.2" then
    _ENV = (getfenv and getfenv()) or _G
end
]] ..
"	]], 0)" .. [[
		out:pop()
		out.data.__setup_env = true
	end
	if not out.scope.__variable_states then out.scope.__variable_states = {} end

	if out.scope.__variable_states[varname] == "global" then
		return false
	elseif out.scope.__variable_states[varname] == "local" then
		return true
	else
		return
	end
end

local function set_global(out, name)
	if not out.scope.__variable_states then out.scope.__variable_states = {} end
	out.scope.__variable_states[name] = "global"
end
local function set_local(out, name)
	if not out.scope.__variable_states then out.scope.__variable_states = {} end
	out.scope.__variable_states[name] = "local"
end
local function reset_scope(out, name)
	if not out.scope.__variable_states then out.scope.__variable_states = {} end
	out.scope.__variable_states[name] = nil
end

local function get_hastemp(out, name)
	if not out.scope.__TEMP_variable_states then out.scope.__TEMP_variable_states = {} end
	return out.scope.__TEMP_variable_states[name]
end
local function toggle_temps(out, bool)
	out.scope.__TEMP_variable_enabled = bool
end
local function temp_local(out, name)
	if not out.scope.__TEMP_variable_states then out.scope.__TEMP_variable_states = {} end
	out.scope.__TEMP_variable_states[name] = "local"
end
local function temp_global(out, name)
	if not out.scope.__TEMP_variable_states then out.scope.__TEMP_variable_states = {} end
	out.scope.__TEMP_variable_states[name] = "global"
end
local function push_temp_vars(out)
	if not out.scope.__TEMP_variable_states then out.scope.__TEMP_variable_states = {} end
	for name, val in pairs(out.scope.__TEMP_variable_states) do
		if val == "local" then
			set_local(out, name)
		else
			set_global(out, name)
		end
	end
	out.scope.__TEMP_variable_states = {}
end
local function clear_temp_vars(out)
	out.scope.__TEMP_variable_states = {}
end
%}
]]

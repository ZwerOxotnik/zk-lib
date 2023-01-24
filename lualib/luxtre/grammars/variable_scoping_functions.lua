return [[
@setup {%
	if not out.data.__setup_scoping_funcs then
		out.data.__default_scope_assignment = {}
		out.data.__default_scope_index = {}
		out.data.__scopes_info = {}
		out.scope.__variable_states = {}
		out.scope.__TEMP_variable_states = {}
		out.scope.__TEMP_variable_enabled = false
		out.data.__setup_scoping_funcs = true
	end
%}


{%
--[[
	Valid prefix modes:
	"always": always insert before var name
	"line_start": only insert at start of line (used for local)
]] .. "--]]" .. [[
local function add_scope(out, scopename, prefix, prefixmode)
	local infotab = out.data.__scopes_info
	if infotab[scopename] then
		error(("variable scope '%s' already exists"):format(scopename))
	end
	if not prefix then
		error("no scope prefix provided")
	end
	prefixmode = prefixmode or "always"
	infotab[scopename] = {prefix, prefixmode}
	-- print("scinf", scopename, infotab[scopename], infotab[scopename][1], infotab[scopename][2])
end

local function scope_info(out, scopename)
	local infotab = out.data.__scopes_info
	return infotab[scopename]
end

local function set_default_assignment(out, scope)
	out.data.__default_scope_assignment = scope
end

local function get_default_assignment(out)
	return out.data.__default_scope_assignment
end

local function set_default_index(out, scope)
	out.data.__default_scope_index = scope
end

local function get_default_index(out)
	return out.data.__default_scope_index
end

local function toggle_temps(out, bool)
	if bool == nil then
		bool = false
	end
	out.scope.__TEMP_variable_enabled = bool
end

local function get_temps_enabled(out)
	return out.scope.__TEMP_variable_enabled
end

local function print_with_temps(out, child, ...)
	local states = out.scope.__TEMP_variable_states
	local enablestatus = get_temps_enabled(out)
	toggle_temps(out, true)
	child:print(out, ...)
	toggle_temps(out, enablestatus)
end

local function get_scope(out, varname)
	local states
	if get_temps_enabled(out) and out.scope.__TEMP_variable_states[varname] ~= nil then
		states = out.scope.__TEMP_variable_states
	else
		states = out.scope.__variable_states
	end
	return states[varname]
end

local function set_scope(out, varname, scope)
	local states = out.scope.__variable_states
	states[varname] = scope
end

local function get_temp(out, varname)
	local states = out.scope.__TEMP_variable_states
	return states[varname]
end

local function set_temp(out, varname, scope)
	local states = out.scope.__TEMP_variable_states
	states[varname] = scope
end

local function push_temps(out)
	local tstates = out.scope.__TEMP_variable_states
	local states = out.scope.__variable_states
	for name, val in pairs(tstates) do
		states[name] = val
		tstates[name] = nil
	end
end

local function print_name_with_scope(out, name, pos)
	-- local name = self.children[1].value
	local scope = get_scope(out, name)
	if scope == nil then
		scope = get_default_index(out)
	end

	local scopedata = scope_info(out, scope)

	if scopedata[2] == "always" then
		out:line():append(scopedata[1] .. name, pos)
	else
		out:line():append(name, pos)
	end
	-- self.children[1]:print(out)
end

local function get_name_with_scope(out, name)
	-- local name = self.children[1].value
	local scope = get_scope(out, name)
	if scope == nil then
		scope = get_default_index(out)
	end

	local scopedata = scope_info(out, scope)

	if scopedata[2] == "always" then
		return scopedata[1] .. name
	else
		return name
	end
	-- self.children[1]:print(out)
end


%}
]]

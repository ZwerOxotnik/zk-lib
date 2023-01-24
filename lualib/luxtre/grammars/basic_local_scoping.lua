return [[
# local path = filename:gsub("basic_local_scoping", "")
# include (path .. "variable_scoping_functions")

@ keywords {"global"}

@setup {%
	if not out.data.__setup_basic_scoping then
		add_scope(out, "local", "local", "line_start")
		add_scope(out, "global", "_ENV.", "always")
		set_default_assignment(out, "local")
		set_default_index(out, "global")

		local ln = out:push_header()
		ln:append([[
local _ENV = _ENV
if _VERSION < "Lua 5.2" then
	_ENV = (getfenv and getfenv()) or _G
]] ..
"end		]], 0)" .. [[
		out:pop()
		out.data.__setup_basic_scoping = true
		set_scope(out, "_ENV", "local")
	end
%}

@reset variable

variable -> prefix_expression '[' expression ']'
    | prefix_expression '.' Name

variable -> Name {%
	print_name_with_scope(out, self.children[1].value, self.children[1].position[1])
%}

@reset function_name
function_name -> Name {'.' Name} [':' Name] {%
	local name = self.children[1].value

	local scope = get_scope(out, name)
	if scope == nil then
		scope = get_default_index(out)
	end

	local scopedata = scope_info(out, scope)

	if scopedata[2] == "always" then
		out:line():append(scopedata[1])
	end
	self.children[1]:print(out)
	self.children[2]:print(out)
	self.children[3]:print(out)
%}

@reset assignment
assignment -> variable_list '=' expression_list {%
	local lhtab = { self.children[1].children[1] }
	local gathertab = self.children[1].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	local def_assign_as = get_default_assignment(out)
	local push_back = false
	local undefined_locals = {}
	local name_involved = false
	for _, var in ipairs(lhtab) do
		if var.children[1].rule == "Name" then
			name_involved = true
			local name = var.children[1].value
			local scope = get_scope(out, name)
			if scope == nil then
				has_undefined_locals = true
				table.insert(undefined_locals, name)
				set_temp(out, name, def_assign_as)
			else
				push_back = true
			end
		else
			push_back = true
		end
	end
	local scinfo = scope_info(out, def_assign_as)
	if #undefined_locals > 0 and scinfo[2] == "line_start" then
		if push_back then
			local ln = out:push_prior()
			ln:append(scinfo[1] .. " " .. table.concat(undefined_locals, ", "))
			out:pop()
		else
			out:line():append(scinfo[1])
		end
	end

	print_with_temps(out, self.children[1])
	self.children[2]:print(out)
	self.children[3]:print(out)
	push_temps(out)
%}

@reset local_assignment
local_assignment -> local name_list ['=' expression_list] {%
	self.children[1]:print(out)
	local lhtab = { self.children[2].children[1].value }
	--local lhtab = { }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2].value)
	end
	for _, val in ipairs(lhtab) do
		set_temp(out, val, "local")
	end
	print_with_temps(out, self.children[2])
	self.children[3]:print(out)
	push_temps(out)
%}

statement -> global_assignment
global_assignment -> global name_list ['=' expression_list] {%
	local lhtab = { self.children[2].children[1].value }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2].value)
	end
	for _,val in ipairs(lhtab) do
		set_temp(out, val, "global")
		lhtab[_] = "_ENV." .. val
	end
	if #self.children[3].children > 0 then
		local ln = out:line()
		ln:append(table.concat(lhtab, ", "))
	end
	self.children[3]:print(out)
	push_temps(out)
%}

@reset for_numeric
for_numeric -> for Name '=' expression ',' expression [',' expression] do_block {%
	out.scope:push()
	set_scope(out, self.children[2].value, "local")
	for _,child in ipairs(self.children) do
		child:print(out)
	end
	out.scope:pop()
%}

@reset for_in
for_in -> for name_list in expression_list do_block {%
	out.scope:push()
	local lhtab = { self.children[2].children[1] }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	for i,v in ipairs(lhtab) do
		set_scope(out, v.value, "local")
	end
	for _, child in ipairs(self.children) do
		child:print(out)
	end
	out.scope:pop()
%}

@reset function_assignment
function_assignment -> function function_name function_body {%
	local fname = self.children[2].children[1].value
	local scope = get_scope(out, fname)
	if scope == nil then
		if #self.children[2].children[2].children == 0
		 and #self.children[2].children[3].children == 0 then
		 local defsc = get_default_assignment(out)
		 local scinf = scope_info(out, defsc)
		 	if scinf[2] == "line_start" then
				out:line():append(scinf[1])
			end
			set_temp(out, fname, defsc)
		end
	end

	out.scope:push()
	if #self.children[2].children[3].children > 0 then
		set_scope(out, "self", "local")
	end

	self.children[1]:print(out)
	print_with_temps(out, self.children[2])
	self.children[3]:print(out)
	out.scope:pop()
	push_temps(out)
%}

@reset local_function_assignment
local_function_assignment -> local function Name function_body {%
	for _,child in ipairs(self.children) do
		child:print(out)
	end
	set_scope(out, self.children[3].value, "local")
%}

statement -> global_function_assignment
global_function_assignment -> global function Name function_body {%
	for _, child in ipairs(self.children) do
		if _ == 1 then
		elseif _ == 3 then
			out:line():append("_ENV.")
			child:print(out)
		else
			child:print(out)
		end
	end
	set_scope(out, self.children[3].value, "global")
%}

@reset paramlist
paramlist -> '...'
paramlist -> name_list [',' '...'] {%
	local lhtab = { self.children[1].children[1] }
	local gathertab = self.children[1].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	for i,v in ipairs(lhtab) do
		set_scope(out, v.value, "local")
	end
	for _, child in ipairs(self.children) do
		child:print(out)
	end
%}

@reset function_body
function_body -> '(' [paramlist] ')' block end {%
	out.scope:push()
	for _,child in ipairs(self.children) do
		child:print(out)
	end
	out.scope:pop()
%}
]]

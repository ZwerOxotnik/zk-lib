return [[
# local path = filename:gsub("basic_local_scoping", "")
# include (path .. "variable_scoping_functions")

@ keywords {"global"}
@reset variable

variable -> prefix_expression '[' expression ']'
    | prefix_expression '.' Name

variable -> Name {%
	local name = self.children[1].value
	local append_env
	local was_temp = false
	if out.scope.__TEMP_variable_enabled then
		local type = get_hastemp(out, name)
		if type == "global" then
			was_temp = true
			append_env = true
		elseif type == "local" then
			was_temp = true
			append_env = false
		end
	end
	if not was_temp then
		local is_local = check_localness(out, name)
		if is_local ~= true then
			append_env = true
		end
	end
	if append_env then
		out:line():append("_ENV.")
	end
	self.children[1]:print(out)
%}

@reset function_name
function_name -> Name {'.' Name} [':' Name] {%
	local name = self.children[1].value
	local append_env
	local was_temp = false
	if out.scope.__TEMP_variable_enabled then
		local type = get_hastemp(out, name)
		if type == "global" then
			was_temp = true
			append_env = true
		elseif type == "local" then
			was_temp = true
			append_env = false
		end
	end
	if not was_temp then
		local is_local = check_localness(out, name)
		if is_local == false then
			append_env = true
		end
	end
	if append_env then
		out:line():append("_ENV.")
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

	local pop_back = false
	local name_involved = false
	local add_local = true
	local to_set_local = {}
	for _, var in ipairs(lhtab) do
		if var.children[1].rule == "Name" then
			name_involved = true
			local vname = var.children[1].value
			local islocal = check_localness(out, vname)
			if islocal == nil then
				table.insert(to_set_local, vname)
				temp_local(out, vname)
			elseif islocal == false then
				pop_back = true
				add_local = false
			else
				pop_back = true
			end
		end
	end
	if pop_back then
		for _,name in ipairs(to_set_local) do
			local ln = out:push_prior()
			ln:append("local " .. name)
			out:pop()
		end
	elseif name_involved and add_local then
		out:line():append("local")
	end
	toggle_temps(out, true)
	self.children[1]:print(out)
	toggle_temps(out, false)

	self.children[2]:print(out)
	self.children[3]:print(out)
	push_temp_vars(out)

%}

@reset local_assignment
local_assignment -> local name_list ['=' expression_list] {%
	self.children[1]:print(out)
	local lhtab = { self.children[2].children[1] }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	local prev_scopes = {}
	for i,v in ipairs(lhtab) do
		--table.insert(prev_scopes, {v.value, check_localness(out, v.value)})
		temp_local(out, v.value)
	end
	toggle_temps(out, true)
	self.children[2]:print(out)
	toggle_temps(out, false)
	self.children[3]:print(out)
	push_temp_vars(out)
%}

statement -> global_assignment
global_assignment -> global name_list ['=' expression_list] {%
	local lhtab = { self.children[2].children[1] }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	for i,v in ipairs(lhtab) do
		temp_global(out, v.value)
		if #self.children[3].children > 0 then
			local ln = out:line()
			ln:append "_ENV."
			v:print(out)
			if i < #lhtab then
				ln:append ","
			end
		end
	end
	self.children[3]:print(out)
	push_temp_vars(out)
%}

@reset for_numeric
for_numeric -> for Name '=' expression ',' expression [',' expression] do_block {%
	out.scope:push()
	set_local(out, self.children[2].value)
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
		set_local(out, v.value)
	end
	for _, child in ipairs(self.children) do
		child:print(out)
	end
	out.scope:pop()
%}

@reset function_assignment
function_assignment -> function function_name function_body {%
	local fname = self.children[2].children[1].value
	local is_local = check_localness(out, fname)
	if is_local == nil then
		if #self.children[2].children[2].children == 0
		and #self.children[2].children[3].children == 0 then
			out:line():append "local"
			temp_local(out, fname)
		end
	end
	out.scope:push()
	if #self.children[2].children[3].children > 0 then
		set_local(out, "self")
	end

	self.children[1]:print(out)
	toggle_temps(out, true)
	self.children[2]:print(out)
	toggle_temps(out, false)
	self.children[3]:print(out)
	out.scope:pop()
	push_temp_vars(out)
%}

@reset local_function_assignment
local_function_assignment -> local function Name function_body {%
	for _,child in ipairs(self.children) do
		child:print(out)
	end
	set_local(out, self.children[3].value)
%}

statement -> global_function_assignment
global_function_assignment -> global function Name function_body {%
	for _,child in ipairs(self.children) do
		if _ == 1 then
		elseif _ == 3 then
			out:line():append("_ENV.")
			child:print(out)
		else
			child:print(out)
		end
	end
	set_global(out, self.children[3].value)
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
		set_local(out, v.value)
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

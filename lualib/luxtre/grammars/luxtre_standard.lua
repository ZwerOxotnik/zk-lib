return [[@import "$basic_lua"

@operators {
	'->',
    '=>',
    '+=',
    '-=',
    '/=',
    '*=',
    '%=',
    '^=',
	'&=',
	'|=',
	'..=',
--    '++',
	'!=',
}

@keywords {
	"let",
}
]] ..
--[[ Variable Scoping Crimes ]]--
[[
# local path = filename:gsub("luxtre_standard", "")
# include (path .. "variable_scoping_functions")
@import "$basic_local_scoping"
]] ..
--[[ Let Assignment ]]--
[[
statement -> let_assignment

let_assignment -> let name_list ['=' expression_list] {%
	local lhtab = { self.children[2].children[1] }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	for i,v in ipairs(lhtab) do
		-- print(v.value)
		-- set_scope(out, v.value, "local")
		set_temp(out, v.value, "local")
		local ln = out:push_prior()
		ln:append( ("local %s"):format(v.value), self.children[1].position[1] )
		out:pop()
	end
	if #self.children[3].children > 0 then
		self.children[2]:print(out)
		self.children[3]:print(out)
	end
	push_temps(out)
%}

]] ..
--[[ Export Scope ]]--
[[
@setup {%
	if not out.data.__setup_export_scope then
		local ln = out:push_header()
		ln:append([[
local __export = {}
]] ..
		"]], 0)" .. [[
		out:pop()
		out.data.__setup_export_scope = true
	end
	add_scope(out, "export", "__export.", "always")
	set_scope(out, "__export", "local")
%}

@cleanup {%
	if not out.data.__cleanup_export_scope and out.data.__add_ending_export == true then
		local ln = out:push_footer()
		ln:append([[
return __export
]] ..
		"]], 0)" .. [[
		out:pop()
		out.data.__cleanup_export_scope = true
	end
%}

@ keywords {"export"}

statement -> export_assignment

export_assignment -> export name_list ['=' expression_list] {%
	local lhtab = { self.children[2].children[1].value }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2].value)
	end
	for _,val in ipairs(lhtab) do
		set_temp(out, val, "export")
		if #self.children[3].children > 0 then
			lhtab[_] = "__export." .. val
		end
	end
	if #self.children[3].children > 0 then
		local ln = out:line()
		ln:append(table.concat(lhtab, ", "))
	else

	end
	self.children[3]:print(out)
	push_temps(out)
	out.data.__add_ending_export = true
%}


]] ..
--[[ != Syntax ]]--
[[
binop -> '!=' {% out:line():append("~=") %}

]] ..
--[[ Table/String Colon-Syntax ]]--
[[
function_call -> (table_constructor | String) ':' Name arguments {%
		local ln = out:line()
		ln:append("(")
		self.children[1]:print(out)
		ln:append(")")
		self.children[2]:print(out)
		self.children[3]:print(out)
		self.children[4]:print(out)
	%}


]] ..
--[[ Augmented Assignment ]]--
[[
statement -> augmented_assignment
augmented_assignment -> variable_list augmented_op expression_list {%
	local lhtab = { self.children[1].children[1] }
	local gathertab = self.children[1].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end

	local rhtab = { self.children[3].children[1] }
	local gathertab = self.children[3].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(rhtab, child.children[2])
	end

	local op = self.children[2]:print()
	local ln = out:line()

	self.children[1]:print(out)
	ln:append("=")

	for i, var in ipairs(lhtab) do
		rhvar = rhtab[i]
		var:print(out)
		ln:append(op .. " (")
		if rhvar then
			rhvar:print(out)
		else
			ln:append("nil")
		end
		ln:append(")")
		if i ~= #lhtab then
			ln:append(",")
		end
	end
%}

augmented_op -> '+=' {% return "+" %}
augmented_op -> '-=' {% return "-" %}
augmented_op -> '/=' {% return "/" %}
augmented_op -> '*=' {% return "*" %}
augmented_op -> '%=' {% return "%" %}
augmented_op -> '^=' {% return "^" %}
augmented_op -> '&=' {% return "and" %}
augmented_op -> '|=' {% return "or" %}
augmented_op -> '..=' {% return ".." %}


]] ..
--[[ Table Constructors ]]--
[[

@reset field
field -> field_lh field_assignment expression
    | expression

field_lh -> Name | '[' expression ']'
field_lh -> true | false | Number | String | function_call {%
	local ln = out:line()
	ln:append "["
	self.children[1]:print(out)
	ln:append "]"
%}

field_assignment -> '='
	| ':'
	{% out:line():append("=") %}

]] ..
--[[ Arrow Lambdas ]]--
[[
anonymous_function -> lambda
statement -> lambda_function_assignment
statement -> lambda_local_function_assignment
statement -> lambda_global_function_assignment

lambda_function_assignment -> function_name lambda {%
	local fname = self.children[1].children[1].value
	-- local is_local = check_localness(out, fname)
	local scope = get_scope(out, fname)
	if scope == nil then
		if #self.children[1].children[2].children == 0
		and #self.children[1].children[3].children == 0 then
			local def_assign_as = get_default_assignment(out)
			local scinfo = scope_info(out, def_assign_as)
			if scinfo[2] == "line_start" then
				out:line():append(scinfo[1])
			end
			set_temp(out, fname, def_assign_as)
			-- temp_local(out, fname)
		end
	end
	-- toggle_temps(out, true)
	-- self.children[1]:print(out)
	-- toggle_temps(out, false)
	print_with_temps(out, self.children[1])
	out:line():append "="
	self.children[2]:print(out)
	-- push_temp_vars(out)
	push_temps(out)
%}


lambda_local_function_assignment -> local Name lambda {%
	local ln = out:line()
	self.children[1]:print(out)
	self.children[2]:print(out)
	ln:append "="
	self.children[3]:print(out)
	-- set_local(out, self.children[2].value)
	set_scope(out, self.children[2].value, "local")
%}

lambda_global_function_assignment -> global Name lambda {%
	local ln = out:line()
	ln:append("_ENV.")
	self.children[2]:print(out)
	ln:append "="
	self.children[3]:print(out)
	-- set_global(out, self.children[2].value)
	set_scope(out, self.children[2].value, "global")
%}

lambda ->  ['(' [paramlist] ')' ] ('->' | '=>') ((['('] statement [')']) | return_statement | expression) {%
	out.scope:push()
	local params
	if #self.children[1].children > 0 then
		params = self.children[1].children[2].children
	else
		params = {}
	end
	local arrow_type = self.children[2].children[1].value
	local ln = out:line()

	ln:append "function("
	if arrow_type == "=>" then
		ln:append "self"
		-- set_local(out, "self")
		set_scope(out, "self", "local")
	end
	if #params > 0 then
		if arrow_type == "=>" then
			ln:append ","
		end
		self.children[1].children[2]:print(out)
	end
	ln:append ")"
	if self.children[3].children[1].rule == "expression" then
		ln:append "return"
	elseif self.children[3].children[1].rule == "(['(']_statement_[')'])" then
		self.children[3] = self.children[3].children[1].children[2]
	end
	if self.children[3].children[1].rule == "do_block" then
		self.children[3] = self.children[3].children[1].children[2]
	elseif self.children[3].children[1].value == ";" then
		self.children[3].children[1] = nil
	end

	self.children[3]:print(out)
	ln = out:line()
	ln:append "end"
	out.scope:pop()
%}


]] ..
--[[ Function Decorators ]]--
[[

statement -> decorated_func

func_decorator -> '@' function_name [arguments] {%
	self.children[2]:print(out)
	local ln = out:line()
	local argtype = (self.children[3].children[1] and self.children[3].children[1].children[1].rule)
	if argtype == "String" or argtype == "table_constructor" then
		ln:append("(")
		self.children[3]:print(out)
		ln:append(")")
	else
		self.children[3]:print(out)
	end
%}

decorated_func -> func_decorator {func_decorator} (function_assignment
									| local_function_assignment
									| global_function_assignment
									| lambda_function_assignment
									| lambda_local_function_assignment
									| lambda_global_function_assignment
								) {%
	local assignment = self.children[3].children[1]

	local lhtab = { self.children[1] }
	local gathertab = self.children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[1])
	end
	local func_name
	local func_body

	local ln = out:line()
	local setfunc, setval
	if assignment.rule == "function_assignment" then
		setval = assignment.children[2].children[1].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	elseif assignment.rule == "local_function_assignment" then
		ln:append("local")
		setfunc, setval = "local", assignment.children[3].value
		func_name = assignment.children[3]
		func_body = assignment.children[4]
	elseif assignment.rule == "global_function_assignment" then
		ln:append("_ENV.")
		setfunc, setval = "local", assignment.children[3].value
		func_name = assignment.children[3]
		func_body = assignment.children[4]
	elseif assignment.rule == "lambda_function_assignment" then
		setval = assignment.children[1].children[1].value
		func_name = assignment.children[1]
		func_body = assignment.children[2]
	elseif assignment.rule == "lambda_local_function_assignment" then
		ln:append("local")
		setfunc, setval = "local", assignment.children[2].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	elseif assignment.rule == "lambda_global_function_assignment" then
		ln:append("_ENV.")
		setfunc, setval = "global", assignment.children[2].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	end

	if setfunc == nil then
		-- local status = check_localness(out, setval)
		local status = get_scope(out, name)
		if status == nil then
			-- ln:append("local")
			-- temp_local(out, setval)
			-- setfunc = "local"
			local def_assign_as = get_default_assignment(out)
			local scinfo = scope_info(out, def_assign_as)
			if scinfo[2] == "line_start" then
				out:line():append(scinfo[1])
			end
			set_temp(out, setval, def_assign_as)
			setfunc = def_assign_as

		elseif status == "global" then
			setfunc = "global"
			ln:append("_ENV.")
		elseif status == true then
			setfunc = "global"
		end
	end
	toggle_temps(out, true)
	func_name:print(out)
	toggle_temps(out, false)
	ln:append "="
	-- self.children[1].children[2]:print(out)
	-- ln:append "("
	for _, deco in ipairs(lhtab) do
		deco:print(out)
		-- deco.children[2]:print(out)
		-- deco.children[3]:print(out)
		ln:append "("
	end
	if assignment.rule ~= "lambda_function_assignment"
	and assignment.rule ~= "lambda_local_function_assignment"
	and assignment.rule ~= "lambda_global_function_assignment" then
		ln:append "function"
	end
	func_body:print(out)
	for _, deco in ipairs(lhtab) do
		out:line():append ")"
	end

	-- setfunc(out, setval)
	set_scope(out, setval, setfunc)
	-- push_temp_vars(out)
	push_temps(out)
	return func_name
%}

]] ..
--[[ Try-Catch Blocks ]]--
[[

@keywords {"try", "catch"}

--try_block -> [variable_list '='] try block end {%
try_block -> try block end {%
	local block = self.children[2]
	local pc_txt = get_name_with_scope(out, "pcall")

	local ln = out:line()

	ln:append(pc_txt .. "(function() ", self.children[1].position[1])

	block:print(out)

	ln = out:line()

	ln:append("end )", self.children[3].position[1])
%}


try_block -> try block catch [Name] block end {%
	out.scope:push()

	local block = self.children[2]
	local errname = self.children[4]
	local block2 = self.children[5]
	local pc_txt = get_name_with_scope(out, "pcall")

	if #errname.children == 0 then
		errname = "err"
	else
		errname = errname.children[1].value
	end

	local ln = out:line()

	ln:append("do")

	ln:append("local __TEMP_status__,")
	ln:append(errname)
	ln:append("= " .. pc_txt .. "(function() ", self.children[1].position[1])

	block:print(out)

	ln = out:line()

	ln:append("end )")

	set_scope(out, errname, "local")

	ln:append("if __TEMP_status__ == false then", self.children[3].position[1])

	block2:print(out)

	ln = out:line()
	ln:append("end")


	ln:append("end", self.children[6].position[1])
	out.scope:pop()
%}

try_block -> try block catch [Name] block else block end {%
	out.scope:push()

	local block = self.children[2]
	local errname = self.children[4]
	local block2 = self.children[5]
	local block3 = self.children[7]
	local pc_txt = get_name_with_scope(out, "pcall")

	if #errname.children == 0 then
		errname = "err"
	else
		errname = errname.children[1].value
	end

	local ln = out:line()

	ln:append("do")

	ln:append("local __TEMP_status__,")
	ln:append(errname)
	ln:append("= " .. pc_txt .. "(function() ", self.children[1].position[1])

	block:print(out)

	ln = out:line()

	ln:append("end )")

	set_scope(out, errname, "local")

	ln:append("if __TEMP_status__ == false then", self.children[3].position[1])

	block2:print(out)

	ln = out:line()
	ln:append("else", self.children[6].position[1])
	block3:print(out)

	ln = out:line()
	ln:append("end")


	ln:append("end", self.children[8].position[1])
	out.scope:pop()
%}

statement -> try_block
]]

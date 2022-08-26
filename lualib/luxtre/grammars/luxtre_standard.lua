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

--\[\[ Variable Scoping Crimes \]\]--

# local path = filename:gsub("luxtre_standard", "")
# include (path .. "variable_scoping_functions")
@import "$basic_local_scoping"

--\[\[ != Syntax \]\]--
binop -> '!=' {% out:line():append("~=") %}

--\[\[ Table/String Colon-Syntax \]\]--
function_call -> (table_constructor | String) ':' Name arguments {%
		local ln = out:line()
		ln:append("(")
		self.children[1]:print(out)
		ln:append(")")
		self.children[2]:print(out)
		self.children[3]:print(out)
		self.children[4]:print(out)
	%}


--\[\[ Augmented Assignment \]\]--
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

	-- local pop_back = false
	-- local name_involved = false
	-- local add_local = true
	-- local to_set_local = {}
	-- for _, var in ipairs(lhtab) do
	-- 	if var.children[1].rule == "Name" then
	-- 		name_involved = true
	-- 		local vname = var.children[1].value
	-- 		local islocal = check_localness(out, vname)
	-- 		if islocal == nil then
	-- 			table.insert(to_set_local, vname)
	-- 			temp_local(out, vname)
	-- 		elseif islocal == false then
	-- 			pop_back = true
	-- 			add_local = false
	-- 		else
	-- 			pop_back = true
	-- 		end
	-- 	end
	-- end
	-- if pop_back then
	-- 	for _,name in ipairs(to_set_local) do
	-- 		local ln = out:push_prior()
	-- 		ln:append("local " .. name)
	-- 		out:pop()
	-- 	end
	-- elseif name_involved and add_local then
	-- 	out:line():append("local")
	-- end

	-- toggle_temps(out, true)
	self.children[1]:print(out)
	-- toggle_temps(out, false)
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

	-- push_temp_vars(out)
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


--\[\[ Table Constructors \]\]--

@reset field
field -> field_lh field_assignment expression
    | expression

field_lh -> Name | '[' expression ']'
field_lh -> true | false | Number | String {%
	local ln = out:line()
	ln:append "["
	self.children[1]:print(out)
	ln:append "]"
%}

field_assignment -> '='
	| ':'
	{% out:line():append("=") %}


--\[\[ Arrow Lambdas \]\]--
anonymous_function -> lambda
statement -> lambda_function_assignment
statement -> lambda_local_function_assignment
statement -> lambda_global_function_assignment

lambda_function_assignment -> function_name lambda {%
	local fname = self.children[1].children[1].value
	local is_local = check_localness(out, fname)
	if is_local == nil then
		if #self.children[1].children[2].children == 0
		and #self.children[1].children[3].children == 0 then
			out:line():append "local"
			temp_local(out, fname)
		end
	end
	toggle_temps(out, true)
	self.children[1]:print(out)
	toggle_temps(out, false)
	out:line():append "="
	self.children[2]:print(out)
	push_temp_vars(out)
%}

lambda_local_function_assignment -> local Name lambda {%
	local ln = out:line()
	self.children[1]:print(out)
	self.children[2]:print(out)
	ln:append "="
	self.children[3]:print(out)
	set_local(out, self.children[2].value)
%}

lambda_global_function_assignment -> global Name lambda {%
	local ln = out:line()
	ln:append("_ENV.")
	self.children[2]:print(out)
	ln:append "="
	self.children[3]:print(out)
	set_global(out, self.children[2].value)
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
		set_local(out, "self")
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
	end

	self.children[3]:print(out)
	ln = out:line()
	ln:append "end"
	out.scope:pop()
%}


--\[\[ Function Decorators \]\]--

statement -> decorated_func

func_decorator -> '@' function_name

decorated_func -> func_decorator (function_assignment
									| local_function_assignment
									| global_function_assignment
									| lambda_function_assignment
									| lambda_local_function_assignment
									| lambda_global_function_assignment
									| decorated_func
								) {%
	local assignment = self.children[2].children[1]
	local func_name
	local func_body

	if assignment.rule == "decorated_func" then
		--local ln = out:push_next()
		--out:pop()

		local assign_name = assignment:print(out)
		--table.insert(out._stack, ln)

		local ln = out:push_next()
		assign_name:print(out)
		ln:append "="
		self.children[1].children[2]:print(out)
		ln:append "("
		assign_name:print(out)
		ln:append ")"
		return assign_name
	end

	local ln = out:line()
	local setfunc, setval
	if assignment.rule == "function_assignment" then
		setval = assignment.children[2].children[1].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	elseif assignment.rule == "local_function_assignment" then
		ln:append("local")
		setfunc, setval = set_local, assignment.children[3].value
		func_name = assignment.children[3]
		func_body = assignment.children[4]
	elseif assignment.rule == "global_function_assignment" then
		ln:append("_ENV.")
		setfunc, setval = set_global, assignment.children[3].value
		func_name = assignment.children[3]
		func_body = assignment.children[4]
	elseif assignment.rule == "lambda_function_assignment" then
		setval = assignment.children[1].children[1].value
		func_name = assignment.children[1]
		func_body = assignment.children[2]
	elseif assignment.rule == "lambda_local_function_assignment" then
		ln:append("local")
		setfunc, setval = set_local, assignment.children[2].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	elseif assignment.rule == "lambda_global_function_assignment" then
		ln:append("_ENV.")
		setfunc, setval = set_global, assignment.children[2].value
		func_name = assignment.children[2]
		func_body = assignment.children[3]
	end

	if setfunc == nil then
		local status = check_localness(out, setval)
		if status == nil then
			ln:append("local")
			temp_local(out, setval)
			setfunc = set_local
		elseif status == false then
			setfunc = set_global
			ln:append("_ENV.")
		elseif status == true then
			setfunc = set_local
		end
	end
	toggle_temps(out, true)
	func_name:print(out)
	toggle_temps(out, false)
	ln:append "="
	self.children[1].children[2]:print(out)
	ln:append "("
	if assignment.rule ~= "lambda_function_assignment"
	and assignment.rule ~= "lambda_local_function_assignment"
	and assignment.rule ~= "lambda_global_function_assignment" then
		ln:append "function"
	end
	func_body:print(out)
	out:line():append ")"

	setfunc(out, setval)
	push_temp_vars(out)
	return func_name
%}


--\[\[ Let Assignment \]\]--

statement -> let_assignment

let_assignment -> let name_list ['=' expression_list] {%
	local lhtab = { self.children[2].children[1] }
	local gathertab = self.children[2].children[2]:print(out,true)
	for i, child in ipairs(gathertab) do
		table.insert(lhtab, child.children[2])
	end
	for i,v in ipairs(lhtab) do
		set_local(out, v.value)
		local ln = out:push_prior()
		ln:append( ("local %s"):format(v.value) )
		out:pop()
	end
	if #self.children[3].children > 0 then
		self.children[2]:print(out)
		self.children[3]:print(out)
	end
%}
]]

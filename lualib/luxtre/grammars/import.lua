return [[
# local path = filename:gsub("import", "")
# include (path .. "variable_scoping_functions")

--\[\[ python-like import statement \]\]--

@keywords {"import", "as", "from"}

import_name -> Name {'.' Name}

import_statement -> [from import_name] import import_name [as import_name] {%
	local rootpos = self.children[2].position[1]
	local modname, exportname, subname
	-- as
	if self.children[4].children[2] then
		exportname = self.children[4].children[2]
	else
		exportname = self.children[3]
	end
	-- from
	if self.children[1].children[2] then
		modname = self.children[1].children[2]
		subname = self.children[3]
	else
		modname = self.children[3]
	end

	out:push_catch()
		exportname:print(out)
	exportname = out:pop()

	out:push_catch()
		modname:print(out)
	modname = out:pop()

	if subname then
		out:push_catch()
			subname:print(out)
		subname = out:pop()
	end

	--print("export", exportname)
	--print("module", modname)
	--print("sub", subname)

	-- We now have the text, let's go forward

	-- First we have to ensure the module table exists.
	local mods = {}
	for m in string.gmatch(exportname, "(%.?[^.]+)") do
		m = m:gsub("[%c%s]", "")
		--print("|" .. m .. "|")
		table.insert(mods, m)
	end

	if #mods > 1 then
		local exp_prefix = ""
		local name_is_defined = false
		for i = 1, #mods do
			exp_prefix = exp_prefix .. mods[i]
			if i == 1 then
				local ln = out:push_prior()
				local scope = get_scope(out, exp_prefix)
				if scope == nil then
					ln:append( ("local %s ="):format(exp_prefix), rootpos)
					print_name_with_scope(out, exp_prefix, rootpos)
				else
					name_is_defined = true
				end
				out:pop()
			end
			if not (i == 1 and name_is_defined) then
				local ln = out:push_prior()
				ln:append( ("if %s == nil then %s = {} end"):format(exp_prefix, exp_prefix), rootpos )
				out:pop()
			end
		end
	end

	-- Preemptively set the main table to local scope.
	set_scope(out, mods[1], "local")

	-- Now we can set the value...
	local ln = out:line()
	if #mods == 1 then
		ln:append("local")
	end
	ln:append( ("%s = require('%s')"):format(exportname, modname), rootpos )
	if subname then
		ln:append( "." .. subname, rootpos )
	end

%}

statement -> import_statement
]]

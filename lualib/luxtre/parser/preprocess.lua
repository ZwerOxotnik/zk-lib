local path = (...):gsub("parser[./\\]preprocess", "")

local load_func = require(path .. "utils/safeload")

local new_sandbox = require(path .. "utils/sandbox")


local export = {}

--states:
-- need_left_parens (look for leftparen)
-- between_args (ignore spaces)
-- non_string (match chars and split on commas)
-- in_string (try to exit the string)
-- gather_multiline (for gathering the brackets)
-- gather_multiline_closing
-- in_multiline (try to exit the string)
local function extract_args(iter_str)
    local args = {}
    local curr_arg = {}
    local full_iter = {}
    local current_state = "need_left_parens"
    local string_type, last_char
    local eq_count = 0
    for char in iter_str:gmatch(".") do
        table.insert(full_iter, char)
        -- print(char)
        if current_state == "need_left_parens" then
            if not ( char:match("%s") or (char == "(") ) then
                return false
            elseif char == "(" then
                current_state = "non_string"
            end

        elseif current_state == "inbetween_args" then
            if not char:match("%s") then
                current_state = "non_string"
                    -- hotpatch in main state behavior
                    if char == "," then
                        table.insert(args, table.concat(curr_arg) or "")
                        curr_arg = {}
                        current_state = "inbetween_args"
                    elseif char == ")" then
                        table.insert(args, table.concat(curr_arg) or "")
                        return args, table.concat(full_iter)
                    elseif char == '"' or char == "'" then
                        current_state = "in_string"
                        string_type = char
                        table.insert(curr_arg, char)
                    elseif char == "[" then
                        string_type = 0
                        current_state = "gather_multiline"
                        table.insert(curr_arg, char)
                    else
                        table.insert(curr_arg, char)
                    end
            end

        elseif current_state == "non_string" then
            if char == "," then
                table.insert(args, table.concat(curr_arg) or "")
                curr_arg = {}
                current_state = "inbetween_args"
            elseif char == ")" then
                table.insert(args, table.concat(curr_arg) or "")
                return args, table.concat(full_iter)
            elseif char == '"' or char == "'" then
                current_state = "in_string"
                string_type = char
                table.insert(curr_arg, char)
            elseif char == "[" then
                string_type = 0
                current_state = "gather_multiline"
                table.insert(curr_arg, char)
            else
                table.insert(curr_arg, char)
            end

        elseif current_state == "in_string" then
            table.insert(curr_arg, char)
            if char == string_type then
                if last_char ~= "\\" then
                    current_state = "non_string"
                end
            end

        elseif current_state == "gather_multiline" then
            if char == "=" then
                string_type = string_type + 1
                table.insert(curr_arg, char)
            elseif char == "[" then
                current_state = "in_multiline"
                table.insert(curr_arg, char)
            else
                current_state = "non_string" -- quickpatch main state behavior
                if char == "," then
                    table.insert(args, table.concat(curr_arg) or "")
                    curr_arg = {}
                    current_state = "inbetween_args"
                elseif char == ")" then
                    table.insert(args, table.concat(curr_arg) or "")
                    return args
                elseif char == '"' or char == "'" then
                    current_state = "in_string"
                    string_type = char
                    table.insert(curr_arg, char)
                else
                    table.insert(curr_arg, char)
                end
            end

        elseif current_state == "in_multiline" then
            if char == "]" and last_char ~= "\\" then
                current_state = "gather_multiline_closing"
            end
            table.insert(curr_arg, char)

        elseif current_state == "gather_multiline_closing" then
            if char == "=" then
                eq_count = eq_count + 1
                if eq_count > string_type then
                    eq_count = 0
                    current_state = "in_multiline"
                end
            elseif char == "]" then
                if eq_count == string_type then
                    current_state = "non_string"
                    eq_count = 0
                else
                    current_state = "in_multiline"
                end
            end
            table.insert(curr_arg, char)
        end
        last_char = char
    end
    -- print("end of input")
end

local function change_macros(ppenv, line, count, name)
    for _, macro in ipairs(ppenv.macros.__listed) do
        local res = ppenv.macros[macro]
        local fixedmacro = macro:gsub("([%^$()%.[%]*+%-%?%%])", "%%%1")

        if type(res) == "string" then
            line = line:gsub(fixedmacro, ( res:gsub("%%", "%%%%")) )

        elseif type(res) == "table" then
            local s, e = 1,1
            repeat
                s, e = string.find(line, fixedmacro .. "%s*%(", e)
                if s then
                    local after = line:sub(e, -1)
                    local args, full = extract_args(after)
                    if args then
                        -- print('args found')
                        local fulltext = (fixedmacro .. full:gsub("([%^$()%.[%]*+%-%?%%])", "%%%1"))
                        line = line:gsub(fulltext, function()
                           local result = res._res
                        --    print(result)
                            if #args < # res._args then
                                for i = 1, #res._args - #args do
                                    args[#args+1] = ""
                                end
                            end
                            for i, argument in ipairs(args) do
                                local argname = res._args[i]
                                if argname and argname ~= "..." then
                                    result = result:gsub(argname, (argument:gsub("%%","%%%%")) )
                                elseif argname == "..." then
                                    result = result:gsub("%.%.%.", table.concat(args, ", ", i))
                                end
                            end
                           e = 1
                           return result
                        end)

                    end
                end
            until s == nil

        elseif type(res) == "function" then
            local s, e = 1,1
            repeat
                s, e = string.find(line, fixedmacro .. "%s*%(", e)
                if s then
                    local after = line:sub(e, -1)
                    local args, full = extract_args(after)
                    if args then
                        local full_match = fixedmacro .. full:gsub("([%^$()%.[%]*+%-%?%%])", "%%%1")
                        line = line:gsub(full_match, function()
                            local chunk = string.rep("\n", count) .. string.format("return macros[\"%s\"]( %s )", macro, table.concat(args, ", "))
                            local f, err = load_func(chunk, name .. " (preprocessor", "t", ppenv)
                            if err then
                                error(err,2)
                            end
                            local res = tostring(f())
                            if res == "" or res == nil then
                                res = " "
                            end
                            return res
                        end)
                    end
                end
            until s == nil
        end

    end
    return line
end

local macros_mt = {
    __newindex = function(t,k,v)
        local s, e, parens = k:find("(%b())$")
        if s then
            k = k:sub(1, s-1)
            -- print(k)
            parens = parens:sub(2,-1)
            -- print(parens)
            local argnames = {}

            for arg in parens:gmatch("%s*([%a%d_ %.]+)[,)]") do
                -- print(arg)
                table.insert(argnames, arg)
            end
            v = {_args = argnames, _res = v}
            -- print(v._res)
        end

        table.insert(t.__listed, k)
        rawset(t,k,v)
    end
}

local function setup_sandbox(name)
    local sandbox = new_sandbox()
    sandbox.filename = name or ""
    sandbox.macros = setmetatable({__listed = {}}, macros_mt)
    sandbox._output = {}
    sandbox._write_lines = {}
    sandbox._linemap = {}
    sandbox.__extra_grammars = {}
    sandbox.__special_positions = {}

    sandbox._write = function(num)
        local line = sandbox._write_lines[num]
        line = change_macros(sandbox, line, sandbox.__count, name)
        table.insert(sandbox._output, line)
        sandbox._linemap[#sandbox._output] = num
    end

    sandbox.include = function(filename)
        local filename = filename:gsub("%.", "/")
        -- filename = filename .. ".lua"
		local fulltxt = require(filename)
        local count = 0
        ---@diagnostic disable-next-line: need-check-nil
        for line in fulltxt:gmatch("[^\r\n]+") do
            count = count + 1
            local position = sandbox.__count + count
            table.insert(sandbox.__lines, position, line)
            sandbox.__special_positions[position] = tostring(sandbox.__count - 1) .. (" ( %s:%s: )"):format(filename, count)
        end
    end

    sandbox.add_grammar = function(grammar)
        if type(grammar) ~= "string" then
            error("given filepath must be a string",2)
        end
        local found = false
        for _,v in ipairs(sandbox.__extra_grammars) do
            if v == grammar then
                found = true
                break
            end
        end
        table.insert(sandbox.__extra_grammars, grammar)
    end

    return sandbox
end

local function multiline_status(line, in_string, eqs)
    local s, e = 1, nil
    repeat
        if not in_string then
            s, e, eqs = line:find("%[(=*)%[", s)
            if s then
                in_string = true
            end
        else
            s, e = line:find(("]%s]"):format(eqs), s, true)
            if s then
                in_string = false
                eqs = ""
            end
        end
    until s == nil
    return in_string, eqs
end

local function find_invalid_block_positions(input)
    local cache = {}
    local s, e = 0, nil -- uniline
    repeat
        s, e = string.find(input, "(['\"])[^\n]-[^\\]%1", s)
        if s then
            table.insert(cache, {s, e})
            s = e
        end
    until s == nil

    s, e = 0, nil -- multiline
    repeat
        s, e = string.find(input, "%[(=-)%[.-%]%1%]", s)
        if s then
            table.insert(cache, {s, e})
            s = e
        end
    until s == nil
    s, e = 0, nil -- comments
    repeat
        s, e = string.find(input, "-%-[^\n]*\n?", s)
        -- print("cm", s, e)
        if s then
            table.insert(cache, {s, e})
            s = e
        end
    until s == nil
    return cache
end

local function is_block_pos_invalid(position, invalid_pos_map)
    for i,v in ipairs(invalid_pos_map) do
        local is_in = (position >= v[1]) and (position <= v[2])
        if is_in == true then
            return true
        end
    end
    return false
end

local function check_conditional(line, hanging_conditional, invalid_pos_map, sline_cols)
    local s = 1
    repeat
        local had_result = false
        local r1 = {line:find("then", s)}
        -- local r2 = {line:find("else", s)}
        local r3 = {line:find("do", s)}
        local r4 = {line:find("repeat", s)}
        local r5 = {line:find("function%s+[%d%a_%.:]-%s-%b()", s)}
        local r6 = {line:find("end", s)}
        local r7 = {line:find("until", s)}

        local results_tab = {}
        if r1[1] then table.insert(results_tab, r1) end
        -- if r2[1] then table.insert(results_tab, r2) end
        if r3[1] then table.insert(results_tab, r3) end
        if r4[1] then table.insert(results_tab, r4) end
        if r5[1] then table.insert(results_tab, r5) end
        if r6[1] then table.insert(results_tab, r6) end
        if r7[1] then table.insert(results_tab, r7) end
        table.sort(results_tab, function(a, b) return a[1] < b[1] end)
        local result = results_tab[1]

        if result then
            if is_block_pos_invalid(result[1] + sline_cols, invalid_pos_map) == false then
                if (result ~= r6) and (result ~= r7) then
                    hanging_conditional = hanging_conditional + 1
                else
                    hanging_conditional = hanging_conditional - 1
                end
            end
            s = result[2]
            had_result = true
        end

    until had_result == false
    return hanging_conditional
end

function export.compile_lines(text, name, path)
	name = name or "<lux input>"

    local ppenv = setup_sandbox(name)
    ppenv.__count = 1
    local positions_count = 0
    local in_string, eqs = false, ""
    local hanging_conditional = 0
    local direc_lines = {}
    local sline_colcount = 0
    local invalid_pos_map = find_invalid_block_positions(text)

    ppenv.__lines = {}
	for line in (text .. "\n"):gmatch(".-\n") do
        table.insert(ppenv.__lines, line)
    end

    while ppenv.__count <= #ppenv.__lines do
        local line = ppenv.__lines[ppenv.__count]
        local special_count
        if ppenv.__special_positions[ppenv.__count] then
            special_count = ppenv.__special_positions[ppenv.__count]
        else
            positions_count = positions_count + 1
        end

        line = line:gsub("\n", "")
        if ppenv.__count == 1 and line:match("^#!") then
            table.insert(ppenv._output, "")
            ppenv._linemap[#ppenv._output] = special_count or positions_count
        elseif line:match("^%s*#")
          and not in_string then -- DIRECTIVES

            -- Special Directives
            -- #define syntax
            line = line:gsub("^%s*#%s*define%s+([^%s()]+)%s+(.+)$", "macros[\"%1\"] = [===[%2]===]")
            -- function-like define
            line = line:gsub("^%s*#%s*define%s+([^%s]+%b())%s+(.+)$", "macros[\"%1\"] = [===[%2]===]")
            -- blank define
            line = line:gsub("^%s*#%s*define%s+([^%s()]+)%s*$", "macros[\"%1\"] = ''")
            line = line:gsub("^%s*#%s*define%s+([^%s]+%b())%s*$", "macros[\"%1\"] = ''")

            -- if-elseif-else chain handling
            hanging_conditional = check_conditional(line, hanging_conditional, invalid_pos_map, sline_colcount)
            local stripped = line:gsub("^%s*#", "")
            table.insert(direc_lines, stripped)
            table.insert(ppenv._output, "")
            ppenv._linemap[#ppenv._output] = special_count or positions_count

        else --normal lines

            -- write blocks
            if hanging_conditional > 0 then
                ppenv._write_lines[ppenv.__count] = line
                table.insert(direc_lines,("_write(%d)"):format(ppenv.__count))
                table.insert(ppenv._output, "")
                ppenv._linemap[#ppenv._output] = special_count or positions_count
            else
            	if #direc_lines > 0 then -- execution
					local chunk = string.rep("\n", ppenv.__count-1-#direc_lines) .. table.concat(direc_lines, "\n")
					direc_lines = {}
                    local func, err = load_func(chunk, name .. " (preprocessor)", "t", ppenv)
                    if err then
                        error(err,2)
                    end
                    func()

				end

                line = change_macros(ppenv, line, ppenv.__count, name)
                in_string, eqs = multiline_status(line, in_string, eqs)
                table.insert(ppenv._output, line)
                ppenv._linemap[#ppenv._output] = special_count or positions_count
            end
        end
        ppenv.__count = ppenv.__count + 1
        sline_colcount = sline_colcount + string.len(line) + 1
    end
    return ppenv
end

return export.compile_lines

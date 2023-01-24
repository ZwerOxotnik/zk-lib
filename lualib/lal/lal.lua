--[[
Copyright (C) 2017 Weird Constructor

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

local Parser   = require '__zk-lib__/lualib/lal/lang/parser'
local Compiler = require '__zk-lib__/lualib/lal/lang/compiler'
local util     = require '__zk-lib__/lualib/lal/lang/util'

local lal = {
	VERSION = "05.20.2017",
	DOCUMENTATION_LINK = "https://github.com/WeirdConstructor/lal/tree/38aaa0c426a9b52cd8d74d375f9a11e117be2007/doc",
	ORIGINAL_SOURCE_LINK = "https://github.com/WeirdConstructor/lal/tree/38aaa0c426a9b52cd8d74d375f9a11e117be2007"
}

function lal.eval(lal_code, input_file)
    local lua_code = Compiler.compile_lal_code(lal_code, nil, input_file)
--    print ("LUA CODE: " .. lua_code)
    return util.exec_lua(lua_code, input_file)
end

function lal.eval_file(filepath)
    local fh, error_str = io.open(filepath, "r")
    if (not fh) then
        error("Couldn't open '" .. filepath .. "': " .. error_str)
    end
    local lal_code = fh:read("*a")
    return lal.eval(lal_code, filepath)
end

return lal

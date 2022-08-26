---@diagnostic disable: need-check-nil

local path = (...):gsub("grammars[./\\]generate_loaders", "")

local newGrammar = require(path .. "parser/grammar")
local load_grammar = require(path .. "grammars/read_grammars").load_grammar
local preprocess = require(path .. "parser/preprocess")
local tokenate = require(path .. "parser/tokenate")
local parse = require(path .. "parser/parse")
local ast = require(path .. "parser/ast")
local new_output = require(path .. "parser/output")

local load_func = require(path .. "utils/safeload")
local deepcopy = require(path .. "utils/deepcopy")
local data = require(path .. "utils/data")

-- local std_grammar = require(path .. "grammars/std")
-- local std_grammar = load_grammar(path .. "grammars/luxtre_standard")

local unpack = unpack
if _VERSION > "Lua 5.1" then
    unpack = table.unpack
end

-- [ file loading ] --

local function create_grammar(apply_grammars)
    local grammar = newGrammar()
    -- if not apply_grammars[1] then
    --     apply_grammars[1] = std_grammar
    -- end
    for _, gfunc in ipairs(apply_grammars) do
        gfunc(grammar)
    end

    return grammar
end

local function process_input(source, isfile)
    local origname = source
    local fixedname = source:gsub("%.([^.\\/]-%.)", "/%1")
    if isfile then
        local concat = {}
        local file = io.open(fixedname, "r")
        if file == nil then
            error("file " .. source .. " does not exist", 3)
        end
        for line in file:lines() do
            table.insert(concat, line)
        end
        source = table.concat(concat,"\n")
    else
        origname = "<string>"
    end
    local ppenv = preprocess(source, origname)

    local inpstream = tokenate.inputstream_from_ppenv(ppenv)

    return inpstream, ppenv
end


local function generic_compile(inputstream, grammar)
    -- local grammar = create_grammar(grammars)
    local tokenstream = tokenate.new_tokenstream()
    tokenstream:tokenate_stream(inputstream, grammar)

    local status, res = pcall(parse.earley_parse, grammar, tokenstream, "START")
    if status == false then
        error(res, 3)
    end

    local f_ast = ast.earley_extract(res)
    local output = new_output()
    f_ast:print(output)
    --print(output:print())
    return output:print()
end

local function wrap_errors(linemap, outputchunk) -- change later
    local check_err = function(...)
        local status = { pcall(outputchunk, ...) }
        if status[1] == false then
            local err = status[2]
            local _,_,cap = string.find(err, "%]:(%d+):")
            local realline = linemap[tonumber(cap)] or cap
            err = err:gsub("%]:%d+:", ("]:%s:"):format(realline))
            error(err, 0)
        else
            return unpack(status, 2)
        end
    end
    return check_err
end

local function fix_filename(filename, filetype)
    if type(filename) ~= "string" then
        error("filename must be a string", 3)
    end
    filename = filename .. filetype
    return filename
end


local function load_chunk(compiled_text, linemap, filename, env)
    env = env or _G
    local chunk, err = load_func(compiled_text, filename, "t", env)
    if err then
        error(err, 0)
    end
    local safe_chunk = wrap_errors(linemap, chunk)
    return safe_chunk
end

local function filepath_search(filepath, filetype)
    for path in package.path:gmatch("[^;]+") do
        local fixed_path = path:gsub("%.lua", filetype):gsub("%?", (filepath:gsub("%.", "/")))
        local file = io.open(fixed_path)
        if file then file:close() return fixed_path end
    end
end

---@param filetype string
---The file extension (including dot) to search for.
---@param grammars table
---A table of grammars to apply
-- Take a list of grammars and make a set of load funcs for them
local function create_loaders(filetype, grammars)
    if type(filetype) ~= "string" then
        error("invalid first argument; expected string",2)
    end
    if type(grammars) ~= "table" then
        error("invalid second argument; expected table",2)
    end
    -- filetype = filetype or ".lux"
    -- grammars = grammars or { path .. "grammars/luxtre_standard" }
    for i,v in ipairs(grammars) do
        local status, res = pcall(load_grammar, v)
        if status == false then
            error(res, 2)
        end
        grammars[i] = res
    end
    local loaders = {}

    loaders.loadfile = function(filename, env)
        filename = fix_filename(filename, filetype)
        local grammar = create_grammar(grammars)

        local inpstream, ppenv = process_input(filename, true)
        for _,g in ipairs(ppenv.__extra_grammars) do
            local appg = load_grammar(g)
            appg(grammar)
        end

        -- local inputstream = create_inpstream(filename)
        local compiled_text, linemap = generic_compile(inpstream, grammar)
        local chunk = load_chunk(compiled_text, linemap, filename, env)
        return chunk
    end

    loaders.dofile = function(filename, env)
        local status, res = pcall(loaders.loadfile, filename, env)
        if status == false then
            error(res, 2)
        end
        return res()
    end

    loaders.loadstring = function (str, env)
        if type(str) ~= "string" then
            error("input must be a string", 2)
        end
        local grammar = create_grammar(grammars)

        local inpstream, ppenv = process_input(str, false)
        for _,g in ipairs(ppenv.__extra_grammars) do
            local appg = load_grammar(g)
            appg(grammar)
        end

        local compiled_text, linemap = generic_compile(inpstream, grammar)
        local chunk = load_chunk(compiled_text, linemap, str, env)
        return chunk
    end

    loaders.dostring = function(str, env)
        local status, res = pcall(loaders.loadstring, str, env)
        if status == false then
            error(res, 2)
        end
        return res()
    end

    loaders.compile_file = function(filename, outputname)
        local outputname = (outputname or filename):gsub("%.", data.sep)
        local filename = filename:gsub("%.", "/")
        outputname = outputname .. ".lua"
        local adjusted_filename = fix_filename(filename, filetype)
        local grammar = create_grammar(grammars)

        local inpstream, ppenv = process_input(adjusted_filename, true)
        for _,g in ipairs(ppenv.__extra_grammars) do
            local appg = load_grammar(g)
            appg(grammar)
        end

        -- local inputstream = create_inpstream(filename)
        local compiled_text = generic_compile(inpstream, grammar)

        local file = io.open(outputname, "w+")
        file:write(compiled_text)
        file:flush()
        file:close()
    end

    local load_compile = function(filename, env)
        local outputname = filename:gsub("%.", data.sep) .. ".lua"
        filename = fix_filename(filename, filetype)
        local grammar = create_grammar(grammars)

        local inpstream, ppenv = process_input(filename, true)
        for _,g in ipairs(ppenv.__extra_grammars) do
            local appg = load_grammar(g)
            appg(grammar)
        end

        -- local inputstream = create_inpstream(filename)
        local compiled_text, linemap = generic_compile(inpstream, grammar)
        local file = io.open(outputname, "w+")
        file:write(compiled_text)
        file:flush()
        file:close()

        local chunk = load_chunk(compiled_text, linemap, filename, env)
        return chunk
    end


    -- Based partially on code from Candran
    -- Thanks for having an implementation to reference
    -- https://github.com/Reuh/candran

    local function luxtre_searcher(modulepath)
        local filepath = filepath_search(modulepath, filetype)
        if filepath then
            return function(filepath)
                local status, res
                if not data.compile_files then
                    status, res = pcall(loaders.loadfile, filepath, _G)
                else
                    status, res = pcall(load_compile, filepath)
                end
                if status == true then
                    return res(modulepath)
                else
                    error("error loading module '" .. modulepath .. "'\n" .. res, 3)
                end
            end
        else
            local err = ("no file '%s' in package.path"):format(modulepath .. filetype)
            if _VERSION < "Lua 5.4" then
                err = "\n\t" .. err
            end
            return err
        end
    end

    loaders.register = function()
        local searchers
        if _VERSION == "Lua 5.1" then
            searchers = package.loaders
        else
    ---@diagnostic disable-next-line: deprecated
            searchers = package.searchers
        end
        for _, s in ipairs(searchers) do
            if s == luxtre_searcher then
                return
            end
        end
        table.insert(searchers, 1, luxtre_searcher)
    end


    return loaders
end

return create_loaders

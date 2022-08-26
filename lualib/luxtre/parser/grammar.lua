--[[

rule structure:
  terminals:
    {type = "match_type", value = "typename"}
    {type = "match_keyw", value = "keyword"}
    {type = "match_syms", value = "..."}
  nonterminals:
    {type = "match_rule", value = "rulename"}

--]]

local load_string_function
if _VERSION > "Lua 5.1" then
    load_string_function = load
else
    load_string_function = loadstring
end


local function generate_pattern(str, grammar)
    local split_str = {}
    for w in string.gmatch(tostring(str), "%S+") do
        table.insert(split_str, w)
    end

    local full_pattern = {}
    local split_pos = 1
    while split_pos <= #split_str do
        local v = split_str[split_pos]
        local subrule = {}

        if v == 'Name'
        or v == 'Number'
        or v == 'String'
        or v == 'Symbol'
        or v == 'Keyword'
        or v == 'Operator'
        then
            subrule.type = "match_type"
            subrule.value = v

        elseif grammar._keywords[v] then
          subrule.type = "match_keyw"
          subrule.value = v

        elseif (string.sub(v,1,1) == "'" and string.sub(v,-1,-1) == "'") or (string.sub(v,1,1) == '"' and string.sub(v,-1,-1) == '"') then
            subrule.type = "match_syms"
            subrule.value = string.sub(v,2,-2)

        elseif v == "<eof>" then
          subrule.type = "match_eof"
          subrule.value = "<eof>"

        else
            subrule.type = "match_rule"
            subrule.value = v
        end
        table.insert(full_pattern, subrule)

        split_pos = split_pos + 1
    end
    return full_pattern
end


--[[
grammar:
  _keywords: -set of keywords
  _operators: -list of multi-character operators, sorted by length
  _list:
    <token_name>:
      array of lists:
        {1: rule, 2: postprocessing function}
]]

---@class lux_grammar
---@field _keywords table
---@field _operators table
---@field _list table
---@field _nullable table
---@field _used table
local grammar_core = {}
grammar_core.__index = grammar_core

-- local generic_post = function(self)
--     local concat = {}
--     for _,v in ipairs(self.children) do
--         table.insert(concat, v:print())
--     end
--     return table.concat(concat, "")
-- end

local generic_post = function(self, outp)
  local ln = outp:line()
  for i = 1, #self.children do
    local child = self.children[i]
    child:print(outp)
  end
end

---@param name string
---@param rule string
---@param post? function | nil
---Add a rule to the grammar.
function grammar_core:addRule(name, rule, post)
  -- if type(post) ~= "function" and post ~= nil then
  --   error("invalid argument: expected nil or function, got " .. type(post))
  -- end
  -- local hash = name .. ">>" .. rule
  if not self._used[name] 
    then self._used[name] = {}
  end
  if self._used[name][rule] then
    return
  else
    self._used[name][rule] = true
  end
  if not self._list[name] then
    self._list[name] = {}
  end
  local final = generate_pattern(rule, self)
  -- if post then
  --   post = post:gsub("%$(%d)", "self.children[%1]:print()")
  --   local post_func = "return function(self) return " 
  --     .. post .. " end"
  --   final.post = load_string_function(post_func)()
  -- else
  --   final.post = generic_post
  -- end
  if post then
    final.post = post
  else
     final.post = generic_post
  end
  final.pattern = rule
  final._result = name
  table.insert(self._list[name], final)
end

---@param input string | table
--Add multiple rules to the grammar.
--The elements of each sub-table are used as arguments for individual calls.
function grammar_core:addRules(input)
  if type(input) == "table" then
    for _,v in ipairs(input) do
      self:addRule(v[1], v[2], v[3])
    end
  else
    error("argument must be a string or list of rules",2)
  end
end

---@param keyword string
--Add a keyword to the grammar.
function grammar_core:addKeyword(keyword)
  if type(keyword) == "string" then
    self._keywords[keyword] = true
  else
    error("given argument must be a string", 2)
  end
end

---@param keywords table
--Add multiple keywords to the grammar.
function grammar_core:addKeywords(keywords)
if type(keywords) == "table" then
    for _,v in ipairs(keywords) do
      if type(v) == "string" then
        self._keywords[v] = true
      else
        error("given table contains non-string argument " .. tostring(v),2)
      end
    end
  else
    error("given argument must be a list of strings",2)
  end
end

---@param operator string
function grammar_core:addOperator(operator)
  if type(operator) == "string" then
    table.insert(self._operators, operator)
    table.sort(self._operators, function(a,b) return #b < #a end)
  else
    error("given argument must be a string",2)
  end
end

---@param operators table
--Add several multi-character operators to the grammar.
function grammar_core:addOperators(operators)
if type(operators) == "table" then
    for _,v in ipairs(operators) do
      if type(v) == "string" then
        table.insert(self._operators, v)
      else
        error("given table contains non-string argument " .. tostring(v),2)
      end
    end
    table.sort(self._operators, function(a,b) return #b < #a end)
  else
    error("given argument must be a list of strings",2)
  end
end

local function is_nullable(grammar, rule)
  for i = 1, #rule do
    if not grammar._nullable[rule] then
      return false
    end
  end
  return true
end

local function add_nullable(grammar, rule)
  if grammar._nullable[rule] == true then
    return false
  else
    grammar._nullable[rule] = true
    return true
  end
end

function grammar_core:_generate_nullable()
  local added_nullable = false
  repeat
    added_nullable = false
    -- print("loop")
    for _, set in pairs(self._list) do
      for _, rule in ipairs(set) do
        if is_nullable(self, rule) then
          added_nullable = added_nullable or add_nullable(self, rule)
        end
      end
    end
  until added_nullable == false
end


---@param detailed boolean | nil
--Prints all the keywords, operators, and rules contained in the grammar to stdout.
function grammar_core:_debug(detailed)
  print("---keywords---")
  for i,v in pairs(self._keywords) do
    print(i)
  end
  print("---operators---")
  for i,v in ipairs(self._operators) do
    print(i,v)
  end
  print("---nullable---")
  for i,v in pairs(self._nullable) do
    print(i._result)
  end
  print("---rules---")
  for name,list in pairs(self._list) do
    print("  " .. name)
    for num,rule in ipairs(list) do
      print(string.format("    %s: | length %s | %s", num, #rule, rule.pattern))
      if detailed then
        for _, tok in ipairs(rule) do
          print(string.format("      type: %s | value: %s", tok.type, tok.value))
        end
      end
    end
  end
end

---@return lux_grammar
--Creates a blank grammar object.
local function newGrammar()
  local output = setmetatable({}, grammar_core)
  output._keywords = {}
  output._operators = {}
  output._list = {}
  output._nullable = {}
  output._used = {}

  return output
end


-- Ast format definition

---@class lux_ast_item
---@field type string
---@field position number[2]
---@field print function
---@field item earley_item
---@field children lux_ast_item[] | nil
local lux_ast_item_base = {}

---@class lux_ast
---@field output string[]
---@field posmap table[]
---@field tree lux_ast_item[]
local lux_ast_base = {}
lux_ast_base.__index = lux_ast_base

function lux_ast_base:output(str, pos)
    table.insert(self.output, str)
end

---@return lux_ast
local function new_ast()
    return setmetatable({}, lux_ast_base)
end

---@return lux_ast_item
local function new_ast_item(type, children, print, position)
  local tab = { type = type,
                position = position,
                print = print,
                children = children }
  return tab
end




return newGrammar

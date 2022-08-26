
local path = (...):gsub("ast", "")
local parse = require(path .. "parse")
local reverse_array = parse.reverse_array

local ipairs = ipairs
local pairs = pairs
local table_remove = table.remove
local table_insert = table.insert

--- [[ AST GENERATION ]] ---

local function testscan(nextsym, next_token)
  if next_token then
    return (nextsym.type == "match_type" and nextsym.value == next_token.type)
        or (nextsym.value == next_token.value)
        -- or (nextsym.type == "match_syms" and nextsym.value == next_token.value)
  else
     return (nextsym.type == "match_eof")
  end
end

local export = {}

local stackmt = {}
stackmt.__index = stackmt
function stackmt:pop()
  local val = self[#self]
  table_remove(self, #self)
  return val
end
function stackmt:push(val)
  self[#self+1] = val
end
function stackmt:gettop()
  return self[#self]
end
local function newstack()
  return setmetatable({}, stackmt)
end

local st_push = stackmt.push
local st_pop = stackmt.pop
local st_top = stackmt.gettop

local function bfs_find(array, root, explored)
  local queue = {}
  local explored = {}
  local prod_rule = root.production_rule
  local start, goal = root.begins_at, root.ends_at

  if #prod_rule == 0 then
    --return {start, 1, {"nil", {type = "nil", value = ""}}, {1, 1, {"rule", root}} }
  end

  queue[#queue + 1] = {start, 1, {"rule", root} }
  explored[start] = true

  while #queue > 0 do
    local task = queue[#queue]
    queue[#queue] = nil
    if (task[1] == goal and task[2] == #prod_rule + 1) or (#prod_rule == 0) then
      return task
    end
    local next_path = prod_rule[task[2]]
    
    if next_path then
      if next_path.type == "match_rule" then
        local linkset = array.links[task[1]][next_path.value]
        if linkset then
          if not explored[linkset] then
            explored[linkset] = true
          end
          for i = 1, #linkset do
            local edge = linkset[i]
            if not explored[edge] then
              explored[edge] = true
              local e, r = edge[2], edge[1]
              queue[#queue + 1] = {e, task[2] + 1, {"rule", r}, task}
            end
          end
        end
      else
        local current_token = array.tokenstr.tokens[task[1]]
        local matches = testscan(next_path, current_token)
        if matches then
          queue[#queue + 1] = {task[1] + 1, task[2] + 1, {"scan", current_token}, task}
        end
      end
    end
  end
end

local generic_print = function(self, outp)
  outp:line():append(self.value, self.position and self.position[1])
end

local function bfs_iterate(revarray, root)
  local roottask = {root, type = "root", rule = root.result, children = {}, print = root.production_rule.post }
  local findqueue = {roottask}
  while #findqueue > 0 do
    local task = findqueue[#findqueue]
    findqueue[#findqueue] = nil
    local found = bfs_find(revarray, task[1])

    if found then
      local items = {}
      -- repeat
      while found and found[3][2] ~= task[1] do
        table_insert(items, 1, found[3])
        found = found[4]
      -- until (not found) or found[3][2] == task.rule
      end

      for i = 1, #items do
        local v = items[i]
        if v[1] == "rule" then
          local pushrule = {v[2], type = "non-terminal", rule = v[2].result, children = {}, print = v[2].production_rule.post }
          task.children[#task.children+1] = pushrule
          findqueue[#findqueue+1] = pushrule
        elseif v[1] == "scan" then
          if v[2] then
            task.children[#task.children+1] = {type = "terminal", value = v[2].value, rule = v[2].type, 
                                                position = v[2].position, print = generic_print}
          end
        elseif v[1] == "nil" then
          task.children[#task.children + 1] = {type = "nil", value = "", print = generic_print}
        end
      end
    end
  end
  return roottask
end

function export.earley_extract(array)
  local revarray = reverse_array(array)
  array.final_item.ends_at = #array
  return bfs_iterate(revarray, array.final_item)
end

return export
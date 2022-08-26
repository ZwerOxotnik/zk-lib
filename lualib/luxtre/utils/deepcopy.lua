--[[
	This function comes directly from a stackoverflow answer by islet8.
	https://stackoverflow.com/a/16077650
--]]
local deepcopy
function deepcopy(o, seen)
    seen = seen or {}
    if o == nil then return nil end
    if seen[o] then return seen[o] end
  
    local no = {}
    seen[o] = no
    setmetatable(no, deepcopy(getmetatable(o), seen))
  
    for k, v in next, o, nil do
      k = (type(k) == 'table') and deepcopy(k, seen) or k
      v = (type(v) == 'table') and deepcopy(v, seen) or v
      no[k] = v
    end
    return no
  end

  return deepcopy
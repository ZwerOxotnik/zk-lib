--[[
  Are you lazy to code/check some stuff in the data stage? Use this library then.
  Currently, this is a experimental library. (anything can be changed, removed, added etc.)
]]

lazyAPI = {}
lazyAPI.source = "https://github.com/ZwerOxotnik/zk-lib"


-- lazyAPI.add_flag
-- lazyAPI.remove_flag
-- lazyAPI.has_flag


local tremove = table.remove


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
lazyAPI.add_flag = function(prototype, flag)
  local flags = prototype.flags
  if flags then
    flags[#flags+1] = flag
  else
    prototype.flags = {flag}
  end
end


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
lazyAPI.remove_flag = function(prototype, flag)
  local flags = prototype.flags
  for i=#flags, 1, -1 do
    if flags[i] == flag then
      tremove(flags, i)
    end
  end
  for i, _flag in next, flags, #flags do
    if _flag == flag then
      tremove(flags, i)
    end
  end
end


---Checks if a prototype has a flag
---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return number? # index of the flag in prototype.flags
lazyAPI.has_flag = function(prototype, flag)
  local flags = prototype.flags
  if flags == nil then
    return
  end

  for i=#flags, 1, -1 do
    if flags[i] == flag then
      return i
    end
  end
  for i, _flag in next, flags, #flags do
    if _flag == flag then
      return i
    end
  end
end

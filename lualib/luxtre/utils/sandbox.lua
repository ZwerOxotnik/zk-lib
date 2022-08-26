local unpack = unpack
if _VERSION > "Lua 5.1" then
    unpack = table.unpack
end

local export = {}

local function copy(tab)
    local newtab = {}
    for key, value in pairs(tab) do
        if type(value) == "table" then
            newtab[key] = copy(value)
        else
            newtab[key] = value
        end
    end
    return newtab
end

  -- A safe sandbox for directives.
  -- This will be copied anew for each new file being processed.
  local sandbox_blueprint = {
      _VERSION = _VERSION,
      math = copy(math),
      string = copy(string),
      table = copy(table),
      assert = assert,
      error = error,
      ipairs = ipairs,
      next = next,
      pairs = pairs,
      pcall = pcall,
      print = print,
      select = select,
      tonumber = tonumber,
      tostring = tostring,
      type = type,
      unpack = unpack,
      xpcall = xpcall
}

return function()
    return copy(sandbox_blueprint)
end

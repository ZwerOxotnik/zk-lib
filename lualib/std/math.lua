--[[
 General Lua Libraries for Lua 5.1, 5.2 & 5.3
 Copyright (C) 2002-2018 stdlib authors
]]
--[[--
 Additions to the core math module.

 The module table returned by `std.math` also contains all of the entries from
 the core math table.   An hygienic way to import this module, then, is simply
 to override the core `math` locally:

      local math = require '__zk-lib__/lualib/std/math'

 @corelibrary std.math
]]


local _ = require '__zk-lib__/lualib/std/_base'

local argscheck = _.typecheck and _.typecheck.argscheck

_ = nil


local _ENV = require '__zk-lib__/lualib/std/normalize' {
   'math',
   merge = 'table.merge',
}



--[[ ================= ]]--
--[[ Implementatation. ]]--
--[[ ================= ]]--


local M


local _floor = math.floor

local function floor(n, p)
   if(p or 0) == 0 then
      return _floor(n)
   end
   local e = 10 ^ p
   return _floor(n * e) / e
end


local function round(n, p)
   local e = 10 ^(p or 0)
   return _floor(n * e + 0.5) / e
end



--[[ ================= ]]--
--[[ Public Interface. ]]--
--[[ ================= ]]--


local function X(decl, fn)
   return argscheck and argscheck('std.math.' .. decl, fn) or fn
end


M = {
   --- Core Functions
   -- @section corefuncs

   --- Extend `math.floor` to take the number of decimal places.
   -- @function floor
   -- @number n number
   -- @int[opt=0] p number of decimal places to truncate to
   -- @treturn number `n` truncated to `p` decimal places
   -- @usage
   --    tenths = floor(magnitude, 1)
   floor = X('floor(number, ?int)', floor),

   --- Round a number to a given number of decimal places.
   -- @function round
   -- @number n number
   -- @int[opt=0] p number of decimal places to round to
   -- @treturn number `n` rounded to `p` decimal places
   -- @usage
   --    roughly = round(exactly, 2)
   round = X('round(number, ?int)', round),
}


return merge(math, M)

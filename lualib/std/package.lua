--[[
 General Lua Libraries for Lua 5.1, 5.2 & 5.3
 Copyright (C) 2002-2018 stdlib authors
]]
--[[--
 Additions to the core package module.

 The module table returned by `std.package` also contains all of the entries
 from the core `package` table.   An hygienic way to import this module, then, is
 simply to override core `package` locally:

      local package = require '__zk-lib__/lualib/std/package'

 Manage `package.path` with normalization, duplicate removal,
 insertion & removal of elements and automatic folding of '/' and '?'
 onto `package.dirsep` and `package.pathmark`, for easy addition of
 new paths. For example, instead of all this:

      lib = std.io.catfile('.', 'lib', package.pathmark .. '.lua')
      paths = std.string.split(package.path, package.pathsep)
      for i, path in ipairs(paths) do
         -- ... lots of normalization code...
      end
      i = 1
      while i <= #paths do
         if paths[i] == lib then
            table.remove(paths, i)
         else
            i = i + 1
         end
      end
      table.insert(paths, 1, lib)
      package.path = table.concat(paths, package.pathsep)

 You can now write just:

      package.path = package.normalize('./lib/?.lua', package.path)

 @corelibrary std.package
]]


local _ = require '__zk-lib__/lualib/std/_base'

local argscheck = _.typecheck and _.typecheck.argscheck
local catfile = _.io.catfile
local escape_pattern = _.string.escape_pattern
local invert = _.table.invert
local split = _.string.split

_ = nil

local _ENV = require '__zk-lib__/lualib/std/normalize' {
   'package',
   concat = 'table.concat',
   dirsep = 'package.dirsep',
   gsub = 'string.gsub',
   merge = 'table.merge',
   pathmark = 'package.pathmark',
   pathsep = 'package.pathsep',
   string_find = 'string.find',
   table_insert = 'table.insert',
   table_remove = 'table.remove',
}



--[[ =============== ]]--
--[[ Implementation. ]]--
--[[ =============== ]]--


--- Make named constants for `package.config`
-- (undocumented in 5.1; see luaconf.h for C equivalents).
-- @table package
-- @string dirsep directory separator
-- @string pathsep path separator
-- @string pathmark string that marks substitution points in a path template
-- @string execdir(Windows only) replaced by the executable's directory in a path
-- @string igmark Mark to ignore all before it when building `luaopen_` function name.


local function pathsub(path)
   return gsub(path, '%%?.', function(capture)
      if capture == '?' then
         return pathmark
      elseif capture == '/' then
         return dirsep
      else
         return gsub(capture, '^%%', '', 1)
      end
   end)
end


local function find(pathstrings, patt, init, plain)
   local paths = split(pathstrings, pathsep)
   if plain then
      patt = escape_pattern(patt)
   end
   init = init or 1
   if init < 0 then
      init = #paths - init
   end
   for i = init, #paths do
      if string_find(paths[i], patt) then
         return i, paths[i]
      end
   end
end


local function normalize(...)
   local i, paths, pathstrings = 1, {}, concat({...}, pathsep)
   for _, path in ipairs(split(pathstrings, pathsep)) do
      path = gsub(pathsub(path), catfile('^[^', ']'), catfile('.', '%0'))
      path = gsub(path, catfile('', '%.', ''), dirsep)
      path = gsub(path, catfile('', '%.$'), '')
      path = gsub(path, catfile('^%.', '%..', ''), catfile('..', ''))
      path = gsub(path, catfile('', '$'), '')

      -- Carefully remove redundant /foo/../ matches.
      repeat
         local again = false
         path = gsub(path, catfile('', '([^', ']+)', '%.%.', ''),
            function(dir1)
               if dir1 == '..' then   -- don't remove /../../
                  return catfile('', '..', '..', '')
               else
                  again = true
                  return dirsep
               end
            end)
         path = gsub(path, catfile('', '([^', ']+)', '%.%.$'),
               function(dir1)
                  if dir1 == '..' then -- don't remove /../..
                     return catfile('', '..', '..')
                  else
                     again = true
                     return ''
                  end
               end)
      until again == false

      -- Build an inverted table of elements to eliminate duplicates after
      -- normalization.
      if not paths[path] then
         paths[path], i = i, i + 1
      end
   end
   return concat(invert(paths), pathsep)
end


local function insert(pathstrings, ...)
   local paths = split(pathstrings, pathsep)
   table_insert(paths, ...)
   return normalize(unpack(paths, 1, len(paths)))
end


local function mappath(pathstrings, callback, ...)
   for _, path in ipairs(split(pathstrings, pathsep)) do
      local r = callback(path, ...)
      if r ~= nil then
         return r
      end
   end
end


local function remove(pathstrings, pos)
   local paths = split(pathstrings, pathsep)
   table_remove(paths, pos)
   return concat(paths, pathsep)
end



--[[ ================= ]]--
--[[ Public Interface. ]]--
--[[ ================= ]]--


local function X(decl, fn)
   return argscheck and argscheck('std.package.' .. decl, fn) or fn
end


local M = {
   --- Look for a path segment match of *patt* in *pathstrings*.
   -- @function find
   -- @string pathstrings `pathsep` delimited path elements
   -- @string patt a Lua pattern to search for in *pathstrings*
   -- @int[opt=1] init element(not byte index!) to start search at.
   --    Negative numbers begin counting backwards from the last element
   -- @bool[opt=false] plain unless false, treat *patt* as a plain
   --    string, not a pattern. Note that if *plain* is given, then *init*
   --    must be given as well.
   -- @return the matching element number(not byte index!) and full text
   --    of the matching element, if any; otherwise nil
   -- @usage
   --    i, s = find(package.path, '^[^' .. package.dirsep .. '/]')
   find = X('find(string, string, ?int, ?boolean|:plain)', find),

   --- Insert a new element into a `package.path` like string of paths.
   -- @function insert
   -- @string pathstrings a `package.path` like string
   -- @int[opt=n+1] pos element index at which to insert *value*, where `n` is
   --    the number of elements prior to insertion
   -- @string value new path element to insert
   -- @treturn string a new string with the new element inserted
   -- @usage
   --    package.path = insert(package.path, 1, install_dir .. '/?.lua')
   insert = X('insert(string, [int], string)', insert),

   --- Call a function with each element of a path string.
   -- @function mappath
   -- @string pathstrings a `package.path` like string
   -- @tparam mappathcb callback function to call for each element
   -- @param ... additional arguments passed to *callback*
   -- @return nil, or first non-nil returned by *callback*
   -- @usage
   --    mappath(package.path, searcherfn, transformfn)
   mappath = X('mappath(string, function, [any...])', mappath),

   --- Normalize a path list.
   -- Removing redundant `.` and `..` directories, and keep only the first
   -- instance of duplicate elements.   Each argument can contain any number
   -- of `pathsep` delimited elements; wherein characters are subject to
   -- `/` and `?` normalization, converting `/` to `dirsep` and `?` to
   -- `pathmark`(unless immediately preceded by a `%` character).
   -- @function normalize
   -- @param ... path elements
   -- @treturn string a single normalized `pathsep` delimited paths string
   -- @usage
   --    package.path = normalize(user_paths, sys_paths, package.path)
   normalize = X('normalize(string...)', normalize),

   --- Remove any element from a `package.path` like string of paths.
   -- @function remove
   -- @string pathstrings a `package.path` like string
   -- @int[opt=n] pos element index from which to remove an item, where `n`
   --    is the number of elements prior to removal
   -- @treturn string a new string with given element removed
   -- @usage
   --    package.path = remove(package.path)
   remove = X('remove(string, ?int)', remove),
}


return merge(package, M)


--- Types
-- @section Types

--- Function signature of a callback for @{mappath}.
-- @function mappathcb
-- @string element an element from a `pathsep` delimited string of
--    paths
-- @param ... additional arguments propagated from @{mappath}
-- @return non-nil to break, otherwise continue with the next element

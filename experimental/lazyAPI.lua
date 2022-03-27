--[[
  Are you lazy to change/add/remove/check some prototypes in the data stage? Use this library then.
  Currently, this is a experimental library. (anything can be changed, removed, added etc.)
  No messy data, efficient API.
]]

lazyAPI = {}
lazyAPI.tech = {}
lazyAPI.source = "https://github.com/ZwerOxotnik/zk-lib"


-- lazyAPI.add_flag(prototype, flag)
-- lazyAPI.remove_flag(prototype, flag)
-- lazyAPI.find_flag(prototype, flag)
-- lazyAPI.remove_ingredient(ingredients, item_name)
-- lazyAPI.remove_ingredient_everywhere(prototype, item_name)
-- lazyAPI.find_ingredient_by_name(prototype, item_name)
-- lazyAPI.remove_recipe_result(prototype, result_name)
-- lazyAPI.find_recipe_result_by_name(prototype, result_name)

-- lazyAPI.tech.unlock_recipe(prototype, recipe_name)
-- lazyAPI.tech.add_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_prerequisite(prototype, tech_name)


local tremove = table.remove


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
lazyAPI.add_flag = function(prototype, flag)
  local flags = prototype.flags
  if flags == nil then
    log("There are no flags")
    return
  end

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
  if flags == nil then
    log("There are no flags")
    return
  end

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


---Checks if a prototype has a certain flag
---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return number? # index of the flag in prototype.flags
lazyAPI.find_flag = function(prototype, flag)
  local flags = prototype.flags
  if flags == nil then
    log("There are no flags")
    return
  end

  for i=1, #flags do
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


---@param ingredients table
---@param ingredient_name string
lazyAPI.remove_ingredient = function(ingredients, ingredient_name)
  if ingredients == nil then
    log("There are no ingredients")
    return
  end

  for i=#ingredients, 1, -1 do
    local ingredient = ingredients[i]
    if ingredient[1] == ingredient_name or ingredient["name"] == ingredient_name then
      tremove(ingredients, i)
    end
  end
  for i, ingredient in next, ingredients, #ingredients do
    if ingredient[1] == ingredient_name or ingredient["name"] == ingredient_name then
      tremove(ingredients, i)
    end
  end
end


---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param ingredient_name string
lazyAPI.remove_ingredient_everywhere = function(prototype, ingredient_name)
  if prototype.normal then
    lazyAPI.remove_ingredient(prototype.normal.ingredients, ingredient_name)
  end
  if prototype.expensive then
    lazyAPI.remove_ingredient(prototype.expensive.ingredients, ingredient_name)
  end
  if prototype.ingredients then
    lazyAPI.remove_ingredient(prototype.ingredients, ingredient_name)
  end
end


---@param ingredients table
---@param ingredient_name string
---@return table? # table from ingredients with the ingredient
lazyAPI.find_ingredient_by_name = function(ingredients, ingredient_name)
  if ingredients == nil then
    log("There are no ingredients")
    return
  end

  for i=#ingredients, 1, -1 do
    local ingredient = ingredients[i]
    if ingredient[1] == ingredient_name or ingredient["name"] == ingredient_name then
      return ingredient
    end
  end
  for _, ingredient in next, ingredients, #ingredients do
    if ingredient[1] == ingredient_name or ingredient["name"] == ingredient_name then
      return ingredient
    end
  end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param result_name string
lazyAPI.remove_recipe_result = function(prototype, result_name)
  local results = prototype.results
  if results == nil then
    log("There are no results in the prototype")
    return
  end

  for i=#results, 1, -1 do
    if results[i]["name"] == result_name then
      tremove(results, i)
    end
  end
  for i, result in next, results, #results do
    if result["name"] == result_name then
      tremove(results, i)
    end
  end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param result_name string
---@return table? # table from prototype.results with the result
lazyAPI.find_recipe_result_by_name = function(prototype, result_name)
  local results = prototype.results
  if results == nil then
    log("There are no results in the prototype")
    return
  end

  for i=#results, 1, -1 do
    local result = results[i]
    if result["name"] == result_name then
      return result
    end
  end
  for _, result in next, results, #results do
    if result["name"] == result_name then
      return result
    end
  end
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
lazyAPI.tech.unlock_recipe = function(prototype, recipe_name)
  if prototype.effects == nil then
    prototype.effects = {
      {
        type  = "unlock-recipe",
        recipe = recipe_name
      }
    }
    return
  end
  local effects = prototype.effects

  for i=1, #effects do
    local effect = effects[i]
    if effect["recipe"] == recipe_name then
      return
    end
  end
  for _, effect in next, effects, #effects do
    if effect["recipe"] == recipe_name then
      return
    end
  end

  effects[#effects+1] = {
    type   = "unlock-recipe",
    recipe = recipe_name
  }
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe_name string
lazyAPI.tech.add_effect = function(prototype, type, recipe_name)
  if prototype.effects == nil then
    prototype.effects = {
      {
        type   = type,
        recipe = recipe_name
      }
    }
    return
  end
  local effects = prototype.effects

  for i=1, #effects do
    local effect = effects[i]
    if effect["type"] == type and effect["recipe"] == recipe_name then
      return
    end
  end
  for _, effect in next, effects, #effects do
    if effect["type"] == type and effect["recipe"] == recipe_name then
      return
    end
  end

  effects[#effects+1] = {
    type   = type,
    recipe = recipe_name
  }
end

---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe_name string
---@return number? # index of the effect in prototype.effects
lazyAPI.tech.find_effect = function(prototype, type, recipe_name)
  local effects = prototype.effects
  if effects == nil then
    log("There are no effects in the prototype")
    return
  end

  for i=1, #effects do
    local effect = effects[i]
    if effect["type"] == type and effect["recipe"] == recipe_name then
      return i
    end
  end
  for i, effect in next, effects, #effects do
    if effect["type"] == type and effect["recipe"] == recipe_name then
      return i
    end
  end
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech_name string
---@return number? # index of the prerequisite in prototype.prerequisites
lazyAPI.tech.find_prerequisite = function(prototype, tech_name)
  local prerequisites = prototype.prerequisites
  if prerequisites == nil then
    log("There are no prerequisites in the prototype")
    return
  end

  for i=1, #prerequisites do
    if prerequisites[i] == tech_name then
      return i
    end
  end
  for i, prerequisite in next, prerequisites, #prerequisites do
    if prerequisite == tech_name then
      return i
    end
  end
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech_name string
lazyAPI.tech.add_prerequisite = function(prototype, tech_name)
  if prototype.prerequisites == nil then
    prototype.prerequisites = {tech_name}
    return
  end

  local prerequisites = prototype.prerequisites
  for i=1, #prerequisites do
    if prerequisites[i] == tech_name then
      return
    end
  end
  for _, prerequisite in next, prerequisites, #prerequisites do
    if prerequisite == tech_name then
      return
    end
  end

  prerequisites[#prerequisites+1] = tech_name
end
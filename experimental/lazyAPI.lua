--[[
	Are you lazy to change/add/remove/check some prototypes in the data stage? Use this library then.
	Currently, this is an experimental library, not everything is stable yet. (anything can be changed, removed, added etc.)
	No messy data, efficient API.
]]

lazyAPI = {}
lazyAPI.tech = {}
lazyAPI.source = "https://github.com/ZwerOxotnik/zk-lib"


-- lazyAPI.fix_inconsistent_array(array) | lazyAPI.fix_array(array)
-- lazyAPI.add_flag(prototype, flag)
-- lazyAPI.remove_flag(prototype, flag)
-- lazyAPI.find_flag(prototype, flag)
-- lazyAPI.add_item_ingredient(prototype, item_name, amount)
-- lazyAPI.add_fluid_ingredient(prototype, fluid_name, amount)
-- lazyAPI.add_ingredient(prototype, target, amount)
-- lazyAPI.set_item_ingredient(prototype, item_name, amount)
-- lazyAPI.set_fluid_ingredient(prototype, fluid_name, amount)
-- lazyAPI.set_ingredient(prototype, target, amount)
-- lazyAPI.remove_ingredient(ingredients, item_name, type)
-- lazyAPI.remove_ingredient_everywhere(prototype, item_name, type)
-- lazyAPI.find_ingredient_by_name(prototype, item_name)
-- lazyAPI.remove_item_from_result(prototype, item_name)
-- lazyAPI.remove_fluid_from_result(prototype, fluid_name)
-- lazyAPI.find_item_in_result(prototype, item_name)
-- lazyAPI.find_fluid_in_result(prototype, fluid_name)

-- lazyAPI.tech.unlock_recipe(prototype, recipe_name)
-- lazyAPI.tech.add_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_tool(prototype, tool_name, amount)
-- lazyAPI.tech.set_tool(prototype, tool_name, amount)


local tremove = table.remove


--- Fixes keys with positive numbers only
---@param array table<number, any>
---@return number? # first fixed index
lazyAPI.fix_inconsistent_array = function(array)
	local len_before = #array
	if next(array, len_before) == nil then
		return
	end

	local temp_arr, last_key
	for k, v in next, array do
		if k > len_before then
			array[k] = nil
			if next(array, k) == nil then
				array[len_before+1] = v
				return len_before + 1
			end
			last_key = k
			temp_arr = {v}
			break
		end
	end

	if temp_arr == nil then return end

	for k, v in next, array, last_key do
		if k > len_before then
			array[k] = nil
			temp_arr[#temp_arr+1] = v
		end
	end
	for i=1, #temp_arr do
		array[#array+1] = temp_arr[i]
	end
	return len_before + 1
end
lazyAPI.fix_array = lazyAPI.fix_inconsistent_array
local fix_array = lazyAPI.fix_array


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return table #prototype
lazyAPI.add_flag = function(prototype, flag)
	local flags = prototype.flags
	if flags == nil then
		prototype.flags = {flag}
		return prototype
	end

	fix_array(flags)
	for i=1, #flags do
		if flags[i] == flag then
			return prototype
		end
	end

	flags[#flags+1] = flag
	return prototype
end


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return table #prototype
lazyAPI.remove_flag = function(prototype, flag)
	local flags = prototype.flags
	if flags == nil then
		log("There are no flags")
		return prototype
	end

	fix_array(flags)
	for i=#flags, 1, -1 do
		if flags[i] == flag then
			tremove(flags, i)
		end
	end
	return prototype
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

	fix_array(flags)
	for i=1, #flags do
		if flags[i] == flag then
			return i
		end
	end
end


---Adds an item ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.add_item_ingredient = function(prototype, item_name, amount)
	amount = amount or 1
	local ingredients = prototype.ingredients
	if prototype == nil then
		prototype.ingredients = {{item_name, amount}}
		return prototype.ingredients[1]
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == item_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		elseif ingredient["type"] == "item" and ingredient["name"] == item_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	ingredients[#ingredients+1] = {item_name, amount}
	return ingredients[#ingredients]
end


---Adds a fluid ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.add_fluid_ingredient = function(prototype, fluid_name, amount)
	amount = amount or 1
	local ingredients = prototype.ingredients
	if prototype == nil then
		prototype.ingredients = {{type = "fluid", name = fluid_name, amount = amount}}
		return prototype.ingredients[1]
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient["type"] == "fluid" and ingredient["name"] == fluid_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	ingredients[#ingredients+1] = {type = "fluid", name = fluid_name, amount = amount}
	return ingredients[#ingredients]
end


---Adds an ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.add_ingredient = function(prototype, target, amount)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.add_item_ingredient(prototype, target.name, amount)
	elseif type == "item" then
		return lazyAPI.add_fluid_ingredient(prototype, target.name, amount)
	end
end


---Sets an item ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.set_item_ingredient = function(prototype, item_name, amount)
	amount = amount or 1
	local ingredients = prototype.ingredients
	if prototype == nil then
		prototype.ingredients = {{item_name, amount}}
		return prototype
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == item_name then
			ingredient[2] = amount
			return prototype
		elseif ingredient["type"] == "item" and ingredient["name"] == item_name then
			ingredient[2] = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {item_name, amount}
	return prototype
end


---Sets a fluid ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.set_fluid_ingredient = function(prototype, fluid_name, amount)
	amount = amount or 1
	local ingredients = prototype.ingredients
	if prototype == nil then
		prototype.ingredients = {{type = "fluid", name = fluid_name, amount = amount}}
		return prototype
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient["type"] == "fluid" and ingredient["name"] == fluid_name then
			ingredient[2] = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {type = "fluid", name = fluid_name, amount = amount}
	return prototype
end


---Sets an ingredient in prototype.ingredients
---https://wiki.factorio.com/Prototype/Recipe#ingredients
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.set_ingredient = function(prototype, target, amount)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.set_item_ingredient(prototype, target.name, amount)
	elseif type == "item" then
		return lazyAPI.set_fluid_ingredient(prototype, target.name, amount)
	end
end


---@param ingredients table<number, any>
---@param ingredient_name string
---@param type? "item"|"fluid" #"item" by default
---@return table #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.remove_ingredient = function(ingredients, ingredient_name, type)
	type = type or "item"
	if ingredients == nil then
		log("There are no ingredients")
		return
	end

	fix_array(ingredients)
	if type == "item" then
		for i=#ingredients, 1, -1 do
			local ingredient = ingredients[i]
			if ingredient[1] == ingredient_name then
				return tremove(ingredients, i)
			elseif ingredient["type"] == "item" and ingredient["name"] == ingredient_name then
				return tremove(ingredients, i)
			end
		end
	end
	if type == "fluid" then
		for i=#ingredients, 1, -1 do
			local ingredient = ingredients[i]
			if ingredient["type"] == "fluid" and ingredient["name"] == ingredient_name then
				return tremove(ingredients, i)
			end
		end
	end
end
local remove_ingredient = lazyAPI.remove_ingredient


---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param ingredient_name string
---@param type? "item"|"fluid" #"item" by default
---@return table #prototype
lazyAPI.remove_ingredient_everywhere = function(prototype, ingredient_name, type)
	type = type or "item"
	if prototype.normal then
		remove_ingredient(prototype.normal.ingredients, ingredient_name, type)
	end
	if prototype.expensive then
		remove_ingredient(prototype.expensive.ingredients, ingredient_name, type)
	end
	if prototype.ingredients then
		remove_ingredient(prototype.ingredients, ingredient_name, type)
	end
	return prototype
end


---@param ingredients table<number, any>
---@param ingredient_name string
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.find_ingredient_by_name = function(ingredients, ingredient_name)
	if ingredients == nil then
		log("There are no ingredients")
		return
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == ingredient_name or ingredient["name"] == ingredient_name then
			return ingredient
		end
	end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param item_name string
---@return table #prototype
lazyAPI.remove_item_from_result = function(prototype, item_name)
	local results = prototype.results
	if results == nil then
		log("There are no results in the prototype")
		return prototype
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result[1] == item_name then
			tremove(results, i)
		elseif result["type"] == "item" and result["name"] == item_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param fluid_name string
---@return table #prototype
lazyAPI.remove_fluid_from_result = function(prototype, fluid_name)
	local results = prototype.results
	if results == nil then
		log("There are no results in the prototype")
		return prototype
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result[1] == fluid_name then
			tremove(results, i)
		elseif result["type"] == "item" and result["name"] == fluid_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param item_name string
---@return table? #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.find_item_in_result = function(prototype, item_name)
	local results = prototype.results
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result[1] == item_name then
			return result
		elseif result["type"] == "item" and result["name"] == item_name then
			return result
		end
	end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param fluid_name string
---@return table? #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.find_fluid_in_result = function(prototype, fluid_name)
	local results = prototype.results
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result["type"] == "fluid" and result["name"] == fluid_name then
			return result
		end
	end
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@return table #prototype
lazyAPI.tech.unlock_recipe = function(prototype, recipe_name)
	local effects = prototype.effects
	if effects == nil then
		prototype.effects = {
			{
				type  = "unlock-recipe",
				recipe = recipe_name
			}
		}
		return prototype
	end

	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["recipe"] == recipe_name then
			return prototype
		end
	end

	effects[#effects+1] = {
		type   = "unlock-recipe",
		recipe = recipe_name
	}
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe_name string
---@return table #prototype
lazyAPI.tech.add_effect = function(prototype, type, recipe_name)
	local effects = prototype.effects
	if effects == nil then
		prototype.effects = {
			{
				type   = type,
				recipe = recipe_name
			}
		}
		return prototype
	end

	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["type"] == type and effect["recipe"] == recipe_name then
			return prototype
		end
	end

	effects[#effects+1] = {
		type   = type,
		recipe = recipe_name
	}
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe_name string
---@return table? #https://wiki.factorio.com/Types/ModifierPrototype
lazyAPI.tech.find_effect = function(prototype, type, recipe_name)
	local effects = prototype.effects
	if effects == nil then
		log("There are no effects in the prototype")
		return
	end

	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["type"] == type and effect["recipe"] == recipe_name then
			return effect
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

	fix_array(prerequisites)
	for i=1, #prerequisites do
		if prerequisites[i] == tech_name then
			return i
		end
	end
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech_name string
---@return table #prototype
lazyAPI.tech.add_prerequisite = function(prototype, tech_name)
	local prerequisites = prototype.prerequisites
	if prerequisites == nil then
		prototype.prerequisites = {tech_name}
		return prototype
	end

	fix_array(prerequisites)
	for i=1, #prerequisites do
		if prerequisites[i] == tech_name then
			return prototype
		end
	end

	prerequisites[#prerequisites+1] = tech_name
	return prototype
end


---Adds an ingredient for the research
---https://wiki.factorio.com/Prototype/Technology#unit
---https://wiki.factorio.com/Types/ItemIngredientPrototype
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tool_name string #https://wiki.factorio.com/Prototype/Tool#name
---@param amount? number #1 by default
---@return table? #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.tech.add_tool = function(prototype, tool_name, amount)
	local unit = prototype.unit
	if unit == nil then
		log("There are no unit in the prototype")
		return
	end

	local ingredients = unit.ingredients
	fix_array(ingredients)
	amount = amount or 1
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == tool_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		elseif ingredient["name"] == tool_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	ingredients[#ingredients+1] = {tool_name, amount}
	return ingredients[#ingredients]
end


---Sets a tool for the research
---https://wiki.factorio.com/Prototype/Technology#unit
---https://wiki.factorio.com/Types/ItemIngredientPrototype
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tool_name string #https://wiki.factorio.com/Prototype/Tool#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.tech.set_tool = function(prototype, tool_name, amount)
	local unit = prototype.unit
	if unit == nil then
		log("There are no unit in the prototype")
		return prototype
	end

	amount = amount or 1
	local ingredients = unit.ingredients
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == tool_name then
			ingredient[2] = amount
			return prototype
		elseif ingredient["name"] == tool_name then
			ingredient[2] = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {tool_name, amount}
	return prototype
end

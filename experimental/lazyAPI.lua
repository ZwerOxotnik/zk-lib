-- Are you lazy to change/add/remove/check some prototypes in the data stage? Use this library then.\
-- Currently, this is an experimental library, not everything is stable yet. (anything can be changed, removed, added etc.)\
-- No messy data, efficient API.
--- @class lazyAPI
lazyAPI = {}
lazyAPI.tech = {}
lazyAPI.flags = {}
lazyAPI.recipe = {}
lazyAPI.source = "https://github.com/ZwerOxotnik/zk-lib"


-- Add your functions in lazyAPI.add_extension(function) and
-- lazyAPI.apply_wrapper will pass wrapped prototype into your function
---@type table<number, function>
local extensions = {}


-- lazyAPI.add_extension(function)
-- lazyAPI.apply_wrapper(prototype)
-- lazyAPI.fix_inconsistent_array(array) | lazyAPI.fix_array(array)

-- lazyAPI.flags.add_flag(prototype, flag)
-- lazyAPI.flags.remove_flag(prototype, flag)
-- lazyAPI.flags.find_flag(prototype, flag)

-- lazyAPI.recipe.add_item_ingredient(ingredients, item_name, amount)
-- lazyAPI.recipe.add_fluid_ingredient(ingredients, fluid_name, amount)
-- lazyAPI.recipe.add_ingredient(ingredients, target, amount)
-- lazyAPI.recipe.set_item_ingredient(ingredients, item_name, amount)
-- lazyAPI.recipe.set_fluid_ingredient(ingredients, fluid_name, amount)
-- lazyAPI.recipe.set_ingredient(ingredients, target, amount)
-- lazyAPI.recipe.remove_ingredient(ingredients, item_name, type)
-- lazyAPI.recipe.remove_ingredient_everywhere(prototype, item_name, type)
-- lazyAPI.recipe.find_ingredient_by_name(ingredients, item_name)
-- lazyAPI.recipe.remove_item_from_result(ingredients, item_name)
-- lazyAPI.recipe.remove_fluid_from_result(ingredients, fluid_name)
-- lazyAPI.recipe.find_item_in_result(prototype, item_name)
-- lazyAPI.recipe.find_fluid_in_result(prototype, fluid_name)

-- lazyAPI.tech.unlock_recipe(prototype, recipe_name)
-- lazyAPI.tech.add_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_tool(prototype, tool_name, amount)
-- lazyAPI.tech.set_tool(prototype, tool_name, amount)


local tremove = table.remove


---@param func function #your function
lazyAPI.add_extension = function(func)
	extensions[#extensions+1] = func
end


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
lazyAPI.flags.add_flag = function(prototype, flag)
	local flags = (prototype.prototype or prototype).flags
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
lazyAPI.flags.remove_flag = function(prototype, flag)
	local flags = (prototype.prototype or prototype).flags
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
lazyAPI.flags.find_flag = function(prototype, flag)
	local flags = (prototype.prototype or prototype).flags
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


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.recipe.add_item_ingredient = function(ingredients, item_name, amount)
	amount = amount or 1
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


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.recipe.add_fluid_ingredient = function(ingredients, fluid_name, amount)
	amount = amount or 1
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


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.add_ingredient = function(ingredients, target, amount)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.recipe.add_item_ingredient(ingredients, target.name, amount)
	elseif type == "item" then
		return lazyAPI.recipe.add_fluid_ingredient(ingredients, target.name, amount)
	end
end


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.recipe.set_item_ingredient = function(ingredients, item_name, amount)
	amount = amount or 1
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == item_name then
			ingredient[2] = amount
			return ingredients
		elseif ingredient["type"] == "item" and ingredient["name"] == item_name then
			ingredient[2] = amount
			return ingredients
		end
	end

	ingredients[#ingredients+1] = {item_name, amount}
	return ingredients
end


---https://wiki.factorio.com/Prototype/Recipe
---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param ingredients table<number, any>
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #ingredients
lazyAPI.recipe.set_fluid_ingredient = function(ingredients, fluid_name, amount)
	amount = amount or 1
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient["type"] == "fluid" and ingredient["name"] == fluid_name then
			ingredient[2] = amount
			return ingredients
		end
	end

	ingredients[#ingredients+1] = {type = "fluid", name = fluid_name, amount = amount}
	return ingredients
end


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@return table #prototype
lazyAPI.recipe.set_ingredient = function(ingredients, target, amount)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.recipe.set_item_ingredient(ingredients, target.name, amount)
	elseif type == "item" then
		return lazyAPI.recipe.set_fluid_ingredient(ingredients, target.name, amount)
	end
end


---@param ingredients table<number, any>
---@param ingredient_name string
---@param type? "item"|"fluid" #"item" by default
---@return table? #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.remove_ingredient = function(ingredients, ingredient_name, type)
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
local remove_ingredient = lazyAPI.recipe.remove_ingredient


---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param ingredient_name string
---@param type? "item"|"fluid" #"item" by default
---@return table #prototype
lazyAPI.recipe.remove_ingredient_everywhere = function(prototype, ingredient_name, type)
	type = type or "item"
	local prot = prototype.prototype or prototype
	if prot.normal then
		remove_ingredient(prot.normal.ingredients, ingredient_name, type)
	end
	if prototype.expensive then
		remove_ingredient(prot.expensive.ingredients, ingredient_name, type)
	end
	if prototype.ingredients then
		remove_ingredient(prot.ingredients, ingredient_name, type)
	end

	return prototype
end


---@param ingredients table<number, any>
---@param ingredient_name string
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.find_ingredient_by_name = function(ingredients, ingredient_name)
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
lazyAPI.recipe.remove_item_from_result = function(prototype, item_name)
	local results = (prototype.prototype or prototype).results
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
lazyAPI.recipe.remove_fluid_from_result = function(prototype, fluid_name)
	local results = (prototype.prototype or prototype).results
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
lazyAPI.recipe.find_item_in_result = function(prototype, item_name)
	local results = (prototype.prototype or prototype).results
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
lazyAPI.recipe.find_fluid_in_result = function(prototype, fluid_name)
	local results = (prototype.prototype or prototype).results
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
	local effects = (prototype.prototype or prototype).effects
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
	local effects = (prototype.prototype or prototype).effects
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
	local effects = (prototype.prototype or prototype).effects
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
	local prerequisites = (prototype.prototype or prototype).prerequisites
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
	local prerequisites = (prototype.prototype or prototype).prerequisites
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
	local unit = (prototype.prototype or prototype).unit
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
	local unit = (prototype.prototype or prototype).unit
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


local function give_flag_funcs(o)
	for k, f in pairs(lazyAPI.flags) do
		o[k] = f
	end
end

local prot_funcs = {
	["techology"] = function(o)
		for k, f in pairs(lazyAPI.tech) do
			o[k] = f
		end
	end,
	["recipe"] = function(o)
		for k, f in pairs(lazyAPI.recipe) do
			o[k] = f
		end
	end
}

---@param prototype table
---@return table # wrapped prototype with lazyAPI functions
lazyAPI.apply_wrapper = function(prototype)
	local type = prototype.type
	if type == nil then
		error("lazyAPI.apply_wrapper(prototype) got not a prototype")
	end

	local wrapped_prot = {
		prototype = prototype
	}

	local f = prot_funcs[type]
	if f then f(wrapped_prot) end

	-- I'm lazy to check all prototypes :/
	give_flag_funcs(wrapped_prot)

	for _, _f in pairs(extensions) do
		_f(wrapped_prot)
	end

	return wrapped_prot
end

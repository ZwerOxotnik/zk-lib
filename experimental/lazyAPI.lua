-- Are you lazy to change/add/remove/check some prototypes/stuff in the data stage? Use this library then.\
-- Currently, this is an experimental library, not everything is stable yet. (anything can be changed, removed, added etc.)\
-- No messy data, efficient API.
---@module "__zk-lib__/experimental/lazyAPI"
---@class lazyAPI
local lazyAPI = {}
lazyAPI.base = {}
lazyAPI.resistance = {}
lazyAPI.flags = {}
lazyAPI.recipe = {}
lazyAPI.tech = {}
lazyAPI["mining-drill"] = {}
lazyAPI.source = "https://github.com/ZwerOxotnik/zk-lib"


local locale = require("static-libs/lualibs/locale")


-- Add your functions in lazyAPI.add_extension(function) and
-- lazyAPI.wrap_prototype will pass wrapped prototype into your function
---@type function[]
local extensions = {}


local listeners = {
	remove_prototype = {}
}
local subscriptions = {
	remove_prototype = {}
}


-- lazyAPI.add_extension(function)
-- lazyAPI.add_listener(action_name, name, types, func)
-- lazyAPI.remove_listener(action_name, name)
-- lazyAPI.wrap_prototype(prototype)
-- lazyAPI.fix_inconsistent_array(array) | lazyAPI.fix_array(array)
-- lazyAPI.array_to_locale(array)
-- lazyAPI.array_to_locale_as_new(array)
-- lazyAPI.merge_locales(...)
-- lazyAPI.merge_locales_as_new(...)
-- lazyAPI.create_trigger_capsule(tool_data)
-- lazyAPI.attach_custom_input_event(name)

-- lazyAPI.base.remove_prototype(prototype)

-- lazyAPI.resistance.set(prototype, type, percent, decrease)
-- lazyAPI.resistance.remove(prototype, type)

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
-- lazyAPI.recipe.count_item_in_result(prototype, item_name)
-- lazyAPI.recipe.find_fluid_in_result(prototype, fluid_name)
-- lazyAPI.recipe.count_fluid_in_result(prototype, fluid_name)

-- lazyAPI.tech.unlock_recipe(prototype, recipe_name, difficulty)
-- lazyAPI.tech.find_unlock_recipe_effect(prototype, recipe_name, difficulty)
-- lazyAPI.tech.remove_unlock_recipe_effect(prototype, recipe_name, difficulty)
-- lazyAPI.tech.remove_unlock_recipe_effect_everywhere(prototype, recipe_name)
-- lazyAPI.tech.add_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_tool(prototype, tool_name, amount)
-- lazyAPI.tech.set_tool(prototype, tool_name, amount)

-- lazyAPI["mining-drill"].find_resource_category(prototype, name)
-- lazyAPI["mining-drill"].add_resource_category(prototype, name)
-- lazyAPI["mining-drill"].remove_resource_category(prototype, name)


local tremove = table.remove
local technologies = data.raw.technology


lazyAPI.array_to_locale = locale.array_to_locale
lazyAPI.array_to_locale_as_new = locale.array_to_locale_as_new
lazyAPI.merge_locales = locale.merge_locales
lazyAPI.merge_locales_as_new = locale.merge_locales_as_new


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


---@param action_name function #name of your
---@param types string[] #https://wiki.factorio.com/Data.raw or "all"
---@param name function #name of your listener
---@param func function #your function
---@return boolean #is added?
lazyAPI.add_listener = function(action_name, types, name, func)
	if next(types) == nil then
		return false
	end

	for _, listener in ipairs(listeners[action_name]) do
		if listener.name == name then
			return false
		end
	end

	table.insert(
		listeners[action_name],
		{
			name = name,
			types = types,
			action_name = action_name,
			func = func
		}
	)
	for _, type in ipairs(types) do
		subscriptions[action_name][type] = subscriptions[action_name][type] or {}
		local subscription = subscriptions[action_name][type]
		table.insert(subscription, func)
	end
	return true
end
lazyAPI.add_listener("remove_prototype", {"recipe"}, "lazyAPI_remove_recipe", function(prototype, recipe_name, type)
	fix_array(technologies)
	for i=1, #technologies do
		lazyAPI.tech.remove_unlock_recipe_effect_everywhere(technologies[i], recipe_name)
	end
end)
lazyAPI.add_listener("remove_prototype", {"item"}, "lazyAPI_remove_item", function(prototype, item_name, type)
	local recipes = data.raw.recipes
	fix_array(recipes)
	for i=1, #recipes do
		local recipe = recipes[i]
		if recipe.result == item_name then
			recipes[recipe.name] = nil
		else
			lazyAPI.recipe.remove_ingredient_everywhere(recipe, item_name, "item")
		end
	end

	local achievements = data.raw["produce-per-hour-achievement"]
	fix_array(achievements)
	for i=1, #achievements do
		local achievement = achievements[i]
		if achievement.item_product == item_name then
			achievements[achievement.name] = nil
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"fluid"}, "lazyAPI_remove_fluid", function(prototype, fluid_name, type)
	local recipes = data.raw.recipes
	fix_array(recipes)
	for i=1, #recipes do
		lazyAPI.recipe.remove_ingredient_everywhere(recipes[i], fluid_name, "fluid")
	end
end)
lazyAPI.add_listener("remove_prototype", {"resource"}, "lazyAPI_remove_resource", function(prototype, resource_name, type)
	local autoplace = data.raw["autoplace-control"][resource_name]
	if autoplace.category == "resource" then
		data.raw["autoplace-control"][resource_name] = nil
	end

	local presets = data.raw["map-gen-presets"]
	fix_array(presets)
	for i=1, #presets do
		local autoplace_controls = presets[i]["rich-resources"].basic_settings.autoplace_controls
		autoplace_controls[resource_name] = nil
	end
end)

lazyAPI.remove_listener = function(action_name, name)
	for i, listener in ipairs(listeners[action_name]) do
		if listener.name == name then
			tremove(listeners[action_name], i)
			for _, type in ipairs(listener.types) do
				local funks = subscriptions[action_name][type]
				for j, func in ipairs(funks) do
					if func == listener.func then
						tremove(subscriptions[action_name][type], j)
						break
					end
				end
				if #funks == 0 then
					subscriptions[action_name][type] = nil
				end
			end
			return
		end
	end
end


-- Creates tool as capsule to interact with defines.events.on_script_trigger_effect
---@param tool_data table
---@return table capsule, table projectile
lazyAPI.create_trigger_capsule = function(tool_data)
	local name = tool_data.name
	local flags = tool_data.flags
	if flags == nil then
		if tool_data.stack_size and tool_data.stack_size > 1 then
			flags = {"hidden", "only-in-cursor"}
		else
			flags = {"hidden", "not-stackable", "only-in-cursor"}
		end
	end
	data:extend({
		{
			type = "projectile",
			name = name,
			flags = {"not-on-map"},
			acceleration = tool_data.acceleration or 100,
			action =
			{{
				-- runs the script when projectile lands:
				type = "direct",
				action_delivery =
				{{
					type = "instant",
					target_effects =
					{
						type = "script",
						effect_id = name
					}
				}}
			}},
		},
		{
			type = "capsule",
			name = name,
			subgroup = tool_data.subgroup or "tool",
			order = tool_data.order or name,
			icon = tool_data.icon,
			icons = tool_data.icons,
			icon_size = tool_data.icon_size or 32,
			icon_mipmaps = tool_data.icon_mipmaps,
			stack_size = tool_data.stack_size or 1,
			flags = flags,
			radius_color = tool_data.radius_color,
			capsule_action =
			{
				type = "throw",
				attack_parameters =
				{
					type = "projectile",
					activation_type = "throw",
					ammo_category = "capsule",
					cooldown = tool_data.cooldown or 10,
					projectile_creation_distance = 0,
					range = tool_data.range or 64,
					ammo_type =
					{
						category = "capsule",
						target_type = "position",
						action =
						{{
							type = "direct",
							action_delivery =
							{{
								type = "projectile",
								projectile = name,
								starting_speed = tool_data.starting_speed or 100
							}}
						}}
					}
				}
			}
		}
	})

	return data.raw.capsule[name], data.raw.projectile[name]
end


local custom_input = data.raw["custom-input"]
-- Extends game interactions, see https://wiki.factorio.com/Prototype/CustomInput#linked_game_control
---@return table #custom-input
lazyAPI.attach_custom_input_event = function(name)
	local new_name = name .. "-event"
	if custom_input[new_name] then
		log("\"" .. new_name .. "\" already exists as a custom-input")
		return custom_input[new_name]
	end

	data:extend({{
		type = 'custom-input',
		name = new_name,
		key_sequence = '',
		linked_game_control = name,
		consuming = 'none',
		enabled = true
	}})

	return custom_input[new_name]
end


---@param prototype table
---@return table #prototype
lazyAPI.base.remove_prototype = function(prototype)
	local prot = prototype.prototype or prototype
	local name = prot.name
	local category_type = prot.type
	if subscriptions.remove_prototype[category_type] then
		for _, func in pairs(subscriptions.remove_prototype[category_type]) do
			func(prot, name, category_type)
		end
	end
	if subscriptions.remove_prototype.all then
		for _, func in pairs(subscriptions.remove_prototype.all) do
			func(prot, name, category_type)
		end
	end
	data.raw[category_type][name] = nil
	return prototype
end


-- https://wiki.factorio.com/Types/Resistances
-- https://wiki.factorio.com/Damage#Resistance
---@param prototype table
---@param type string
---@param percent number
---@param decrease? number
---@return table #prototype
lazyAPI.resistance.set = function(prototype, type, percent, decrease)
	local prot = prototype.prototype or prototype
	local resistances = prot.resistances
	if resistances == nil then
		prot.resistances = {{type = type, percent = percent, decrease = decrease}}
		return prototype
	end

	fix_array(resistances)
	for i=1, #resistances do
		local resistance = resistances[i]
		if resistance.type == type then
			resistance.percent = percent
			resistance.decrease = decrease
			return prototype
		end
	end


	resistances[#resistances+1] = {type = type, percent = percent, decrease = decrease}
	return prototype
end


-- https://wiki.factorio.com/Types/Resistances
-- https://wiki.factorio.com/Damage#Resistance
---@param prototype table
---@return table #prototype
lazyAPI.resistance.remove = function(prototype, type)
	local prot = prototype.prototype or prototype
	local resistances = prot.resistances
	if resistances == nil then
		return prototype
	end

	fix_array(resistances)
	for i=#resistances, 1, -1 do
		local resistance = resistances[i]
		if resistance.type == type then
			tremove(resistances, i)
		end
	end

	return prototype
end


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
	if prot.expensive then
		remove_ingredient(prot.expensive.ingredients, ingredient_name, type)
	end
	if prot.ingredients then
		remove_ingredient(prot.ingredients, ingredient_name, type)
	end

	return prot
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
---@param item_name string
---@return number #amount
lazyAPI.recipe.count_item_in_result = function(prototype, item_name)
	local results = (prototype.prototype or prototype).results
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	local amount = 0
	for i=#results, 1, -1 do
		local result = results[i]
		if result[1] == item_name then
			amount = amount + result[2]
		elseif result["type"] == "item" and result["name"] == item_name then
			amount = amount + result["amount"]
		end
	end
	return amount
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


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table
---@param fluid_name string
---@return number #amount
lazyAPI.recipe.count_fluid_in_result = function(prototype, fluid_name)
	local results = (prototype.prototype or prototype).results
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	local amount = 0
	for i=#results, 1, -1 do
		local result = results[i]
		if result["type"] == "fluid" and result["name"] == fluid_name then
			amount = amount + result["amount"]
		end
	end
	return amount
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@param difficulty? string
---@return table #prototype
lazyAPI.tech.unlock_recipe = function(prototype, recipe_name, difficulty)
	local effects
	local prot = (prototype.prototype or prototype)
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty] = {}
		end
		effects = prot[difficulty].effects
	else
		effects = prot.effects
	end
	if effects == nil then
		local new_effect = {type = "unlock-recipe", recipe = recipe_name}
		if difficulty then
			prototype[difficulty].effects = {new_effect}
		else
			prototype.effects = {new_effect}
		end
		return prototype
	end

	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["recipe"] == recipe_name and effect["type"] == "unlock-recipe" then
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
---@param recipe_name string
---@param difficulty? string
---@return number? #index effect
lazyAPI.tech.find_unlock_recipe_effect = function(prototype, recipe_name, difficulty)
	local effects
	local prot = (prototype.prototype or prototype)
	if difficulty then
		effects = prot[difficulty] and prot[difficulty].effects
	else
		effects = prot.effects
	end
	if effects == nil then
		return
	end

	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["recipe"] == recipe_name and effect["type"] == "unlock-recipe" then
			return i
		end
	end
end


local function remove_unlock_recipe_effect(effects, recipe_name)
	if effects == nil then return end
	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect["recipe"] == recipe_name and effect["type"] == "unlock-recipe" then
			tremove(effects, i)
		end
	end
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@param difficulty? string
---@return table #prototype
lazyAPI.tech.remove_unlock_recipe_effect = function(prototype, recipe_name, difficulty)
	local effects
	local prot = (prototype.prototype or prototype)
	if difficulty then
		effects = prot[difficulty] and prot[difficulty].effects
	else
		effects = prot.effects
	end

	remove_unlock_recipe_effect(effects, recipe_name)
	return prototype
end

---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@return table #prototype
lazyAPI.tech.remove_unlock_recipe_effect_everywhere = function(prototype, recipe_name)
	local prot = (prototype.prototype or prototype)
	remove_unlock_recipe_effect(prot.effects, recipe_name)
	if prot.normal then
		remove_unlock_recipe_effect(prot.normal.effects, recipe_name)
	end
	if prot.expensive then
		remove_unlock_recipe_effect(prot.expensive.effects, recipe_name)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe_name string
---@param difficulty? string
---@return table #prototype
lazyAPI.tech.add_effect = function(prototype, type, recipe_name, difficulty)
	local effects
	local prot = (prototype.prototype or prototype)
	effects = (difficulty and prot[difficulty] and prot[difficulty].effects) or prot.effects
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


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name from https://wiki.factorio.com/Prototype/ResourceCategory
---@return number? #index of resource_category in the resource_categories
lazyAPI["mining-drill"].find_resource_category = function(prototype, name)
	local resource_categories = (prototype.prototype or prototype).resource_categories
	if resource_categories == nil then
		log("There are no resource_categories in the prototype")
		return
	end

	fix_array(resource_categories)
	for i=1, #resource_categories do
		if resource_categories[i] == name then
			return i
		end
	end
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name from https://wiki.factorio.com/Prototype/ResourceCategory
---@return table #prototype
lazyAPI["mining-drill"].add_resource_category = function(prototype, name)
		local resource_categories = (prototype.prototype or prototype).resource_categories
	if resource_categories == nil then
		log("There are no resource_categories in the prototype")
		return prototype
	end

	fix_array(resource_categories)
	for i=1, #resource_categories do
		if resource_categories[i] == name then
			return prototype
		end
	end

	resource_categories[#resource_categories+1] = name
	return prototype
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name from https://wiki.factorio.com/Prototype/ResourceCategory
---@return table #prototype
lazyAPI["mining-drill"].remove_resource_category = function(prototype, name)
		local resource_categories = (prototype.prototype or prototype).resource_categories
	if resource_categories == nil then
		log("There are no resource_categories in the prototype")
		return prototype
	end

	fix_array(resource_categories)
	for i=#resource_categories, 1, -1 do
		if resource_categories[i] == name then
			tremove(resource_categories, i)
		end
	end

	return prototype
end


local prot_funcs = {
	["technology"] = function(o)
		for k, f in pairs(lazyAPI.tech) do
			o[k] = f
		end
	end,
	["recipe"] = function(o)
		for k, f in pairs(lazyAPI.recipe) do
			o[k] = f
		end
	end,
	["mining-drill"] = function(o)
		for k, f in pairs(lazyAPI["mining-drill"]) do
			o[k] = f
		end
	end
}

---@param prototype table
---@return table # wrapped prototype with lazyAPI functions
lazyAPI.wrap_prototype = function(prototype)
	local type = prototype.type
	if type == nil then
		error("lazyAPI.wrap_prototype(prototype) got not a prototype")
	end

	local wrapped_prot = {
		prototype = prototype
	}

	local f = prot_funcs[type]
	if f then f(wrapped_prot) end

	-- Sets base functions
	for k, _f in pairs(lazyAPI.base) do
		wrapped_prot[k] = _f
	end
	wrapped_prot.remove = lazyAPI.base.remove_prototype

	-- Sets flags functions
	-- I'm lazy to check all prototypes :/
	for k, _f in pairs(lazyAPI.flags) do
		wrapped_prot[k] = _f
	end

	-- Let extensions to use the wrapped prototype
	for _, _f in pairs(extensions) do
		_f(wrapped_prot)
	end

	return wrapped_prot
end

return lazyAPI

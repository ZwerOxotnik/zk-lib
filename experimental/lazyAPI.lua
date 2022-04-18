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
lazyAPI.module = {}
lazyAPI.tech = {}
lazyAPI.technology = lazyAPI.tech
lazyAPI.mining_drill = {}
lazyAPI["mining-drill"] = lazyAPI.mining_drill
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
-- lazyAPI.get_barrel_recipes(name)
-- lazyAPI.remove_prototypes_by_name(name)
-- lazyAPI.create_trigger_capsule(tool_data)
-- lazyAPI.attach_custom_input_event(name)

-- lazyAPI.base.get_type(prototype)
-- lazyAPI.base.set_subgroup(prototype, subgroup, order)
-- lazyAPI.base.remove_prototype(prototype)
-- lazyAPI.base.find_in_array(prototype, field, data)
-- lazyAPI.base.has_in_array(prototype, field, data)
-- lazyAPI.base.remove_from_array(prototype, field, data)
-- lazyAPI.base.replace_in_prototype(prototype, field, old_data, new_data)
-- lazyAPI.base.replace_in_prototypes(prototypes, field, old_data, new_data)

-- lazyAPI.resistance.find(prototype, type)
-- lazyAPI.resistance.set(prototype, type, percent, decrease)
-- lazyAPI.resistance.remove(prototype, type)

-- lazyAPI.flags.add_flag(prototype, flag)
-- lazyAPI.flags.remove_flag(prototype, flag)
-- lazyAPI.flags.find_flag(prototype, flag)

--# There are several issues still
-- lazyAPI.recipe.set_subgroup(prototype, subgroup, order)
-- lazyAPI.recipe.add_item_ingredient(prototype, item_name, amount, difficulty)
-- lazyAPI.recipe.add_fluid_ingredient(prototype, fluid_name, amount, difficulty)
-- lazyAPI.recipe.add_ingredient(ingredients, target, amount, difficulty)
-- lazyAPI.recipe.set_item_ingredient(prototype, item_name, amount, difficulty)
-- lazyAPI.recipe.set_fluid_ingredient(prototype, fluid_name, amount, difficulty)
-- lazyAPI.recipe.set_ingredient(prototype, target, amount, difficulty)
-- lazyAPI.recipe.remove_ingredient(prototype, ingredient_name, type, difficulty)
-- lazyAPI.recipe.remove_ingredient_everywhere(prototype, item_name, type)
-- lazyAPI.recipe.find_ingredient_by_name(prototype, ingredient_name, difficulty)
-- lazyAPI.recipe.remove_item_from_result(prototype, item_name, difficulty)
-- lazyAPI.recipe.remove_fluid_from_result(prototype, fluid_name, difficulty)
-- lazyAPI.recipe.find_item_in_result(prototype, item_name, difficulty)
-- lazyAPI.recipe.count_item_in_result(prototype, item_name, difficulty)
-- lazyAPI.recipe.find_fluid_in_result(prototype, fluid_name, difficulty)
-- lazyAPI.recipe.count_fluid_in_result(prototype, fluid_name, difficulty)

-- lazyAPI.module.is_recipe_allowed(prototype, recipe_name)
-- lazyAPI.module.find_allowed_recipe_index(prototype, recipe_name)
-- lazyAPI.module.find_blacklisted_recipe_index(prototype, recipe_name)
-- lazyAPI.module.allow_recipe(prototype, recipe_name)
-- lazyAPI.module.prohibit_recipe(prototype, recipe_name)
-- lazyAPI.module.remove_allowed_recipe(prototype, recipe_name)
-- lazyAPI.module.remove_blacklisted_recipe(prototype, recipe_name)
-- lazyAPI.module.replace_recipe(prototype, old_recipe, new_recipe)
-- lazyAPI.module.replace_recipe_everywhere(prototype, old_recipe, new_recipe)

-- lazyAPI.tech.unlock_recipe(prototype, recipe_name, difficulty)
-- lazyAPI.tech.find_unlock_recipe_effect(prototype, recipe_name, difficulty)
-- lazyAPI.tech.remove_unlock_recipe_effect(prototype, recipe_name, difficulty)
-- lazyAPI.tech.remove_unlock_recipe_effect_everywhere(prototype, recipe_name)
-- lazyAPI.tech.add_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_effect(prototype, type, recipe_name)
-- lazyAPI.tech.find_prerequisite(prototype, tech_name)
-- lazyAPI.tech.add_prerequisite(prototype, tech_name)
-- lazyAPI.tech.remove_prerequisite(prototype, tech_name)
-- lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech)
-- lazyAPI.tech.replace_prerequisite_everywhere(old_tech, new_tech)
-- lazyAPI.tech.add_tool(prototype, tool_name, amount)
-- lazyAPI.tech.set_tool(prototype, tool_name, amount)

-- lazyAPI.mining_drill.find_resource_category(prototype, name)
-- lazyAPI.mining_drill.add_resource_category(prototype, name)
-- lazyAPI.mining_drill.remove_resource_category(prototype, name)
-- lazyAPI.mining_drill.replace_resource_category(prototype, old_category, new_category)
-- lazyAPI.mining_drill.replace_resource_category_everywhere(prototype, old_category, new_category)


local tremove = table.remove
local technologies = data.raw.technology
local recipes = data.raw.recipes
local modules = data.raw.module
local mining_drills = data.raw["mining-drill"]
---@alias ingredient_type "item" | "fluid"
---@alias difficulty "normal" | "expensive"


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


---@param prototype table
---@param field string
---@param data any
---@return number? #index
lazyAPI.base.find_in_array = function(prototype, field, data)
	local array = (prototype.prototype or prototype)[field]
	if array == nil then
		log("There are no " .. field .. " in the prototype")
		return
	end

	fix_array(array)
	for i=1, #array do
		if array[i] == data then
			return i
		end
	end
end
local find_in_array = lazyAPI.base.find_in_array


---@param prototype table
---@param field string
---@param data any
---@return boolean
lazyAPI.base.has_in_array = function(prototype, field, data)
	local array = (prototype.prototype or prototype)[field]
	if array == nil then
		log("There are no " .. field .. " in the prototype")
		return false
	end

	fix_array(array)
	for i=1, #array do
		if array[i] == data then
			return true
		end
	end
	return false
end
local has_in_array = lazyAPI.base.has_in_array


---@param prototype table
---@param field string
---@param data any
---@return table prototype
lazyAPI.base.remove_from_array = function(prototype, field, data)
	local array = (prototype.prototype or prototype)[field]
	if array == nil then
		log("There are no " .. field .. " in the prototype")
		return prototype
	end

	fix_array(array)
	for i=#array, 1, -1 do
		if array[i] == data then
			tremove(array, i)
		end
	end
	return prototype
end
local remove_from_array = lazyAPI.base.remove_from_array


---@param prototype table
---@param field string
---@param data any
---@return table prototype
lazyAPI.base.add_to_array = function(prototype, field, data)
	local prot = prototype.prototype or prototype
	local array = prot[field]
	if array == nil then
		prot[field] = {data}
		return prototype
	end

	fix_array(array)
	for i=1, #array do
		if array[i] == data then
			return prototype
		end
	end

	array[#array+1] = data
	return prototype
end
local add_to_array = lazyAPI.base.add_to_array


---@param prototype table
---@param field string
---@param old_data any
---@param new_data any
---@return table prototype
lazyAPI.base.replace_in_prototype = function(prototype, field, old_data, new_data)
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return prototype end

	fix_array(array)
	for i=1, #array do
		if array[i] == old_data then
			array[i] = new_data
		end
	end
	return prototype
end
local replace_in_prototype = lazyAPI.base.replace_in_prototype


---@param prototypes table #https://wiki.factorio.com/Data.raw or similar structure
---@param field string
---@param old_data any
---@param new_data any
---@return table prototypes
lazyAPI.base.replace_in_prototypes = function(prototypes, field, old_data, new_data)
	for _, prototype in pairs(prototypes) do
		local array = prototype[field]
		if array then
			fix_array(array)
			for i=1, #array do
				if array[i] == old_data then
					array[i] = new_data
				end
			end
		end
	end
	return prototypes
end
local replace_in_prototypes = lazyAPI.base.replace_in_prototypes


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


---@param name string #barrel name without prefix
---@return table filled_barrel, table empty_barrel
lazyAPI.get_barrel_recipes = function(name)
	return recipes["fill-" .. name], recipes["empty-" .. name]
end


---@param name string
lazyAPI.remove_prototypes_by_name = function(name)
	for _, prototypes in pairs(data.raw) do
		for _name, prototype in pairs(prototypes) do
			if _name == name then
				lazyAPI.base.remove_prototype(prototype)
			end
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
---@return string #https://wiki.factorio.com/Data.raw
lazyAPI.base.get_type = function(prototype)
	return (prototype.prototype or prototype).type
end


---@param prototype table
---@param subgroup string
---@param order? string
lazyAPI.base.set_subgroup = function(prototype, subgroup, order)
	local prot = prototype.prototype or prototype
	prot.subgroup = subgroup
	if order then
		prot.order = order
	end
end


---@param prototype table
---@return table prototype
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
---@param prototype table
---@param type string
---@return table? #https://wiki.factorio.com/Types/Resistances
lazyAPI.resistance.find = function(prototype, type)
	local prot = prototype.prototype or prototype
	local resistances = prot.resistances
	if resistances == nil then
		return
	end

	fix_array(resistances)
	for i=1, #resistances do
		local resistance = resistances[i]
		if resistance.type == type then
			return resistance
		end
	end
end


-- https://wiki.factorio.com/Types/Resistances
-- https://wiki.factorio.com/Damage#Resistance
---@param prototype table
---@param type string
---@param percent number
---@param decrease? number
---@return table prototype
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
---@return table prototype
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
---@return table prototype
lazyAPI.flags.add_flag = function(prototype, flag)
	return add_to_array(prototype, "flags", flag)
end


---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return table prototype
lazyAPI.flags.remove_flag = function(prototype, flag)
	return remove_from_array(prototype, "flags", flag)
end


---Checks if a prototype has a certain flag
---@param prototype table
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return number? # index of the flag in prototype.flags
lazyAPI.flags.find_flag = function(prototype, flag)
	return find_in_array(prototype, "flags", flag)
end


---https://wiki.factorio.com/Prototype/Recipe
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.recipe.add_item_ingredient = function(prototype, item_name, amount, difficulty)
	amount = amount or 1
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty] = {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
		if ingredients == nil then
			prot.ingredients = {}
		end
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

	local ingredient = {item_name, amount}
	ingredients[#ingredients+1] = {item_name, amount}
	return ingredient
end


---https://wiki.factorio.com/Prototype/Recipe
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.recipe.add_fluid_ingredient = function(prototype, fluid_name, amount, difficulty)
	amount = amount or 1
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty] = {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
		if ingredients == nil then
			prot.ingredients = {}
		end
	end

	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient["type"] == "fluid" and ingredient["name"] == fluid_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	local ingredient = {type = "fluid", name = fluid_name, amount = amount}
	ingredients[#ingredients+1] = ingredient
	return ingredient
end


---@param prototype table
---@param subgroup string
---@param order? string
---@return table prototype
lazyAPI.recipe.set_subgroup = function(prototype, subgroup, order)
	local target_name = (prototype.prototype or prototype).name
	for _, prototypes in pairs(data.raw) do
		for name, prot in pairs(prototypes) do
			if name == target_name then
				prot.subgroup = subgroup
				if order then
					prot.order = order
				end
			end
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe
---@param ingredients table<number, any>
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.add_ingredient = function(ingredients, target, amount, difficulty)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.recipe.add_item_ingredient(ingredients, target.name, amount, difficulty)
	elseif type == "item" then
		return lazyAPI.recipe.add_fluid_ingredient(ingredients, target.name, amount, difficulty)
	end
end


---https://wiki.factorio.com/Prototype/Recipe
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string #https://wiki.factorio.com/Prototype/Item#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_item_ingredient = function(prototype, item_name, amount, difficulty)
	amount = amount or 1
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty] = {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
		if ingredients == nil then
			prot.ingredients = {}
		end
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


---https://wiki.factorio.com/Prototype/Recipe
---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string #https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_fluid_ingredient = function(prototype, fluid_name, amount, difficulty)
	amount = amount or 1
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty] = {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
		if ingredients == nil then
			prot.ingredients = {}
		end
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


---https://wiki.factorio.com/Prototype/Recipe
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid#name
---@param amount? number #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_ingredient = function(prototype, target, amount, difficulty)
	local type = target.type
	if type == "fluid" then
		return lazyAPI.recipe.set_item_ingredient(prototype, target.name, amount, difficulty)
	elseif type == "item" then
		return lazyAPI.recipe.set_fluid_ingredient(prototype, target.name, amount, difficulty)
	end
end


---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param ingredient_name string
---@param type? ingredient_type #"item" by default
---@param difficulty? difficulty
---@return table? #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.remove_ingredient = function(prototype, ingredient_name, type, difficulty)
	type = type or "item"
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
	end
	if ingredients == nil then
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
---@param type? ingredient_type #"item" by default
---@return table prototype
lazyAPI.recipe.remove_ingredient_everywhere = function(prototype, ingredient_name, type)
	type = type or "item"
	local prot = prototype.prototype or prototype
	if prot.normal then
		remove_ingredient(prot, ingredient_name, type, "normal")
	end
	if prot.expensive then
		remove_ingredient(prot, ingredient_name, type, "expensive")
	end
	if prot.ingredients then
		remove_ingredient(prot, ingredient_name, type)
	end

	return prot
end


---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param ingredient_name string
---@param difficulty? difficulty
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.recipe.find_ingredient_by_name = function(prototype, ingredient_name, difficulty)
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
	end
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
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.remove_item_from_result = function(prototype, item_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return prototype end
		results = prot[difficulty].results
	else
		results = prot.results
	end
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
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.remove_fluid_from_result = function(prototype, fluid_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return prototype end
		results = prot[difficulty].results
	else
		results = prot.results
	end
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
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string
---@param difficulty? difficulty
---@return table? #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_item_in_result = function(prototype, item_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		results = prot[difficulty].results
	else
		results = prot.results
	end
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result[1] == item_name then
			return result
		elseif result["type"] == "item" and result["name"] == item_name then
			return result
		end
	end
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item_name string
---@param difficulty? difficulty
---@return number #amount
lazyAPI.recipe.count_item_in_result = function(prototype, item_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		results = prot[difficulty].results
	else
		results = prot.results
	end
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	local amount = 0
	for i=1, #results do
		local result = results[i]
		if result[1] == item_name then
			amount = amount + result[2]
		elseif result["type"] == "item" and result["name"] == item_name then
			amount = amount + result["amount"]
		end
	end
	return amount
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string
---@param difficulty? difficulty
---@return table? #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_fluid_in_result = function(prototype, fluid_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			results = prot[difficulty].results
		end
	else
		results = prot.results
	end
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result["type"] == "fluid" and result["name"] == fluid_name then
			return result
		end
	end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid_name string
---@param difficulty? difficulty
---@return number #amount
lazyAPI.recipe.count_fluid_in_result = function(prototype, fluid_name, difficulty)
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			results = prot[difficulty].results
		end
	else
		results = prot.results
	end
	if results == nil then
		log("There are no results in the prototype")
		return
	end

	fix_array(results)
	local amount = 0
	for i=1, #results do
		local result = results[i]
		if result["type"] == "fluid" and result["name"] == fluid_name then
			amount = amount + result["amount"]
		end
	end
	return amount
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe_name string
---@return boolean
lazyAPI.module.is_recipe_allowed = function(prototype, recipe_name)
	local prot = prototype.prototype or prototype
	if prot.limitation then
		if find_in_array(prototype, "limitation", recipe_name) then
			return true
		end
		return false
	elseif prot.limitation_blacklist then
		if find_in_array(prototype, "limitation_blacklist", recipe_name) then
			return false
		end
		return true
	end
	return true
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe_name string
---@return number? #index from https://wiki.factorio.com/Prototype/Module#limitation
lazyAPI.module.find_allowed_recipe_index = function(prototype, recipe_name)
	return find_in_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe_name string
---@return table prototype
lazyAPI.module.allow_recipe = function(prototype, recipe_name)
	local prot = prototype.prototype or prototype
	local blacklist = prot.limitation_blacklist
	if blacklist then
		fix_array(blacklist)
		for i=#blacklist, 1, -1 do
			if blacklist[i] == recipe_name then
				tremove(blacklist, i)
			end
		end
	end

	local limitation = prot.limitation
	if limitation == nil then
		prot.limitation = {recipe_name}
		return prototype
	end

	fix_array(limitation)
	for i=1, #limitation do
		if limitation[i] == recipe_name then
			return prototype
		end
	end
	limitation[#limitation+1] = recipe_name
	return prototype
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param recipe_name string
---@return table prototype
lazyAPI.module.prohibit_recipe = function(prototype, recipe_name)
	local prot = prototype.prototype or prototype
	local limitation = prot.limitation
	if limitation then
		fix_array(limitation)
		for i=#limitation, 1, -1 do
			if limitation[i] == recipe_name then
				tremove(limitation, i)
			end
		end
	end

	local blacklist = prot.limitation_blacklist
	if blacklist == nil then
		prot.limitation_blacklist = {recipe_name}
		return prototype
	end

	fix_array(blacklist)
	for i=1, #blacklist do
		if blacklist[i] == recipe_name then
			return prototype
		end
	end
	blacklist[#blacklist+1] = recipe_name
	return prototype
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param recipe_name string
---@return number? #index from https://wiki.factorio.com/Prototype/Module#limitation_blacklist
lazyAPI.module.find_blacklisted_recipe_index = function(prototype, recipe_name)
	return find_in_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe_name string
---@return table prototype
lazyAPI.module.remove_allowed_recipe = function(prototype, recipe_name)
	return remove_from_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param recipe_name string
---@return table prototype
lazyAPI.module.remove_blacklisted_recipe = function(prototype, recipe_name)
	return remove_from_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param old_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@param new_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@return table prototype
lazyAPI.module.replace_recipe = function(prototype, old_recipe, new_recipe)
	if type(old_tech) == "table" then
		old_tech = old_tech.name
	end
	if type(new_tech) == "table" then
		new_tech = new_tech.name
	end

	replace_in_prototype(prototype, "limitation", old_recipe, new_recipe)
	replace_in_prototype(prototype, "limitation_blacklist", old_recipe, new_recipe)
	return prototype
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype? table
---@param old_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@param new_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@return table? prototype
lazyAPI.module.replace_recipe_everywhere = function(prototype, old_recipe, new_recipe)
	if type(old_tech) == "table" then
		old_tech = old_tech.name
	end
	if type(new_tech) == "table" then
		new_tech = new_tech.name
	end

	replace_in_prototypes(modules, "limitation", old_recipe, new_recipe)
	replace_in_prototypes(modules, "limitation_blacklist", old_recipe, new_recipe)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.unlock_recipe = function(prototype, recipe_name, difficulty)
	local effects
	local prot = prototype.prototype or prototype
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


-- https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe_name string
---@param difficulty? difficulty
---@return table? #https://wiki.factorio.com/Types/UnlockRecipeModifierPrototype
lazyAPI.tech.find_unlock_recipe_effect = function(prototype, recipe_name, difficulty)
	local effects
	local prot = prototype.prototype or prototype
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
			return effect
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
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.remove_unlock_recipe_effect = function(prototype, recipe_name, difficulty)
	local effects
	local prot = prototype.prototype or prototype
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
---@return table prototype
lazyAPI.tech.remove_unlock_recipe_effect_everywhere = function(prototype, recipe_name)
	local prot = prototype.prototype or prototype
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
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.add_effect = function(prototype, type, recipe_name, difficulty)
	local prot = prototype.prototype or prototype
	local effects
	if difficulty then
		if prot[difficulty] then
			effects = prot[difficulty].effects
		else
			prot[difficulty].effects = {{
				type   = type,
				recipe = recipe_name
			}}
			return prototype
		end
	else
		effects = prot.effects
	end
	if effects == nil then
		prot[difficulty].effects = {{
				type   = type,
				recipe = recipe_name
		}}
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
	return find_in_array(prototype, "prerequisites", tech_name)
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech_name string
---@return table prototype
lazyAPI.tech.add_prerequisite = function(prototype, tech_name)
	return add_to_array(prototype, "prerequisites", tech_name)
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech_name string
---@return table prototype
lazyAPI.tech.remove_prerequisite = function(prototype, tech_name)
	return remove_from_array(prototype, "prerequisites", tech_name)
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
---@return table prototype
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


-- https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param old_tech  string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param new_tech  string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return table prototype
function lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech)
	if type(old_tech) == "table" then
		old_tech = old_tech.name
	end
	if type(new_tech) == "table" then
		new_tech = new_tech.name
	end

	if type(prototype) == "string" then
		local technology = technologies[prototype]
		if technology == nil then
			log("there's no \"" .. prototype .. "\" prerequisites")
			return
		end
		replace_in_prototype(technology, "prerequisites", old_tech, new_tech)
	else
		replace_in_prototype(prototype,  "prerequisites", old_tech, new_tech)
	end

	return prototype
end


-- https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param old_tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param new_tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
function lazyAPI.tech.replace_prerequisite_everywhere(old_tech, new_tech)
	if type(old_tech) == "table" then
		old_tech = old_tech.name
	end
	if type(new_tech) == "table" then
		new_tech = new_tech.name
	end

	replace_in_prototypes(technologies, "prerequisites", old_tech, new_tech)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return number? #index of resource_category in the resource_categories
lazyAPI.mining_drill.find_resource_category = function(prototype, name)
	return find_in_array(prototype, "resource_categories", name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return table prototype
lazyAPI.mining_drill.add_resource_category = function(prototype, name)
	return add_to_array(prototype, "resource_categories", name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param name string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return table prototype
lazyAPI.mining_drill.remove_resource_category = function(prototype, name)
	return remove_from_array(prototype, "resource_categories", name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param old_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@param new_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return table prototype
lazyAPI.mining_drill.replace_resource_category = function(prototype, old_category, new_category)
	replace_in_prototype(mining_drills, "resource_categories", old_category, new_category)
	return prototype
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype? table
---@param old_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@param new_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return table? #prototype
lazyAPI.mining_drill.replace_resource_category_everywhere = function(prototype, old_category, new_category)
	replace_in_prototypes(prototype, "resource_categories", old_category, new_category)
	return prototype
end


---@param prototype table
---@return table # wrapped prototype with lazyAPI functions
lazyAPI.wrap_prototype = function(prototype)
	local type = prototype.type
	if type == nil then
		error("lazyAPI.wrap_prototype(prototype) got not a prototype")
	end

	local wrapped_prot = {prototype = prototype}

	-- Sets flags functions
	-- I'm lazy to check all prototypes :/
	for k, _f in pairs(lazyAPI.flags) do
		wrapped_prot[k] = _f
	end

	-- Sets resistance functions
	-- I should check prototypes though
	wrapped_prot.find_resistance = lazyAPI.resistance.find
	wrapped_prot.set_resistance = lazyAPI.resistance.set
	wrapped_prot.remove_resistance = lazyAPI.resistance.remove

	-- Sets base functions
	for k, _f in pairs(lazyAPI.base) do
		wrapped_prot[k] = _f
	end
	wrapped_prot.remove = lazyAPI.base.remove_prototype

	-- Sets functions for the type
	local lazy_funks = lazyAPI[type]
	if lazy_funks then
		for k, _f in pairs(lazy_funks) do
			wrapped_prot[k] = _f
		end
	end

	-- Let extensions to use the wrapped prototype
	for _, _f in pairs(extensions) do
		_f(wrapped_prot)
	end

	return wrapped_prot
end

return lazyAPI

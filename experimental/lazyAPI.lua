-- Are you lazy to change/add/remove/check some prototypes/stuff in the data stage? Use this library then.\
-- Currently, this is an experimental library, not everything is stable yet. (anything can be changed, removed, added etc.)\
-- No messy data, efficient API.
---@module "__zk-lib__/experimental/lazyAPI"
---@class lazyAPI
local lazyAPI = {_SOURCE = "https://github.com/ZwerOxotnik/zk-lib"}


local type, table, rawget, rawset, log = type, table, rawget, rawset, log -- There's a chance something overwrite it
local debug = debug -- I'm pretty sure, some mod did overwrite it
local deepcopy = table.deepcopy
local tremove = table.remove
local data_raw = data.raw
local add_prototypes = data.extend
local technologies = data_raw.technology
local recipes = data_raw.recipe
local modules = data_raw.module
local mining_drills = data_raw["mining-drill"]
---@alias ingredient_type "item" | "fluid"
---@alias product_type ingredient_type
---@alias difficulty "normal" | "expensive"


---@type table<string, integer>
lazyAPI.error_types = {
	mixed_array = 1, -- Don't add different keys for arrays. It's difficult to check and use messy tables.
	element_is_nil = 2 -- Be careful with tables like: {nil, 2} because their length will be inconsistent.
}
local error_types = lazyAPI.error_types
lazyAPI.error_messages = {
	[error_types.mixed_array] = "a mixed array, some keys aren't numbers",
	[error_types.element_is_nil] = "an array had been initialized with nils and keeped them"
}
---@type table<table, lazyAPI.error_types>
lazyAPI.tables_with_errors = {}
setmetatable(lazyAPI.tables_with_errors, {
	__newindex = function(self, k, v)
		if rawget(self, k) then return end -- No multiple errors etc in the table
		log("lazyAPI detected an error: " .. (lazyAPI.error_messages[v] or 'unknown error'))
		log(debug.traceback())
		rawset(self, k, v)
	end
})

lazyAPI.base = {}
lazyAPI.resistance = {}
lazyAPI.ingredients = {}
lazyAPI.loot = {}
lazyAPI.flags = {}
lazyAPI.entity = {}
lazyAPI.EntityWithHealth = {}
lazyAPI.product = {}
lazyAPI.recipe = {}
lazyAPI.module = {}
lazyAPI.tech = {}
lazyAPI.technology = lazyAPI.tech
lazyAPI.mining_drill = {}
lazyAPI["mining-drill"] = lazyAPI.mining_drill
lazyAPI.character = {}
lazyAPI.all_rolling_stocks = {
	["artillery-wagon"] = data_raw["artillery"],
	["cargo-wagon"] = data_raw["cargo-wagon"],
	["fluid-wagon"] = data_raw["fluid-wagon"],
	["locomotive"] = data_raw["locomotive"]
}
lazyAPI.all_vehicles = {
	["car"] = data_raw["car"],
	["spider-vehicle"] = data_raw["spider-vehicle"]
}
for rolling_stock_type, prototypes in pairs(lazyAPI.all_rolling_stocks) do
	lazyAPI.all_vehicles[rolling_stock_type] = prototypes
end
lazyAPI.all_surrets = {
	["turret"] = data_raw["turret"],
	["ammo-turret"] = data_raw["ammo-turret"],
	["electric-turret"] = data_raw["electric-turret"],
	["fluid-turret"] = data_raw["fluid-turret"],
}
lazyAPI.all_transport_belt_connectable = {
	["linked-belt"] = data_raw["linked-belt"],
	["loader-1x1"] = data_raw["loader-1x1"],
	["loader"] = data_raw["loader"],
	["splitter"] = data_raw["splitter"],
	["transport-belt"] = data_raw["transport-belt"],
	["underground-belt"] = data_raw["underground-belt"]
}
lazyAPI.all_craftine_machines = {
	["assembling-machine"] = data_raw["assembling-machine"],
	["rocket-silo"] = data_raw["rocket-silo"],
	["furnace"] = data_raw["furnace"]
}
lazyAPI.entities_with_health = {
	["accumulator"] = data_raw["accumulator"],
	["artillery-turret"] = data_raw["artillery-turret"],
	["beacon"] = data_raw["beacon"],
	["boiler"] = data_raw["boiler"],
	["burner-generator"] = data_raw["burner-generator"],
	["character"] = data_raw["character"],
	["arithmetic-combinator"] = data_raw["arithmetic-combinator"],
	["decider-combinator"] = data_raw["decider-combinator"],
	["constant-combinator"] = data_raw["constant-combinator"],
	["container"] = data_raw["container"],
	["logistic-container"] = data_raw["logistic-container"],
	["infinity-container"] = data_raw["infinity-container"],
	["electric-energy-interface"] = data_raw["electric-energy-interface"],
	["electric-pole"] = data_raw["electric-pole"],
	["unit-spawner"] = data_raw["unit-spawner"],
	["combat-robot"] = data_raw["combat-robot"],
	["construction-robot"] = data_raw["construction-robot"],
	["logistic-robot"] = data_raw["logistic-robot"],
	["gate"] = data_raw["gate"],
	["generator"] = data_raw["generator"],
	["heat-interface"] = data_raw["heat-interface"],
	["heat-pipe"] = data_raw["heat-pipe"],
	["inserter"] = data_raw["inserter"],
	["lab"] = data_raw["lab"],
	["lamp"] = data_raw["lamp"],
	["land-mine"] = data_raw["land-mine"],
	["linked-container"] = data_raw["linked-container"],
	["market"] = data_raw["market"],
	["mining-drill"] = data_raw["mining-drill"],
	["offshore-pump"] = data_raw["offshore-pump"],
	["pipe"] = data_raw["pipe"],
	["infinity-pipe"] = data_raw["infinity-pipe"],
	["pipe-to-ground"] = data_raw["pipe-to-ground"],
	["player-port"] = data_raw["player-port"],
	["power-switch"] = data_raw["power-switch"],
	["programmable-speaker"] = data_raw["programmable-speaker"],
	["pump"] = data_raw["pump"],
	["radar"] = data_raw["radar"],
	["curved-rail"] = data_raw["curved-rail"],
	["straight-rail"] = data_raw["straight-rail"],
	["rail-chain-signal"] = data_raw["rail-chain-signal"],
	["rail-signal"] = data_raw["rail-signal"],
	["reactor"] = data_raw["reactor"],
	["roboport"] = data_raw["roboport"],
	["simple-entity-with-owner"] = data_raw["simple-entity-with-owner"],
	["simple-entity-with-force"] = data_raw["simple-entity-with-force"],
	["solar-panel"] = data_raw["solar-panel"],
	["storage-tank"] = data_raw["storage-tank"],
	["train-stop"] = data_raw["train-stop"],
	["unit"] = data_raw["unit"],
	["wall"] = data_raw["wall"],
	["fish"] = data_raw["fish"],
	["simple-entity"] = data_raw["simple-entity"],
	["spider-leg"] = data_raw["spider-leg"],
	["tree"] = data_raw["tree"]
}
for turret_type, prototypes in pairs(lazyAPI.all_surrets) do
	lazyAPI.entities_with_health[turret_type] = prototypes
end
for vehicle_type, prototypes in pairs(lazyAPI.all_vehicles) do
	lazyAPI.entities_with_health[vehicle_type] = prototypes
end
for transport_belt_type, prototypes in pairs(lazyAPI.all_transport_belt_connectable) do
	lazyAPI.entities_with_health[transport_belt_type] = prototypes
end
for machine_type, prototypes in pairs(lazyAPI.all_craftine_machines) do
	lazyAPI.entities_with_health[machine_type] = prototypes
end

lazyAPI.all_explosions = {
	["explosion"] = data_raw["explosion"],
	["flame-thrower-explosion"] = data_raw["flame-thrower-explosion"]
}
lazyAPI.all_entities = {
	["arrow"] = data_raw["arrow"],
	["artillery-flare"] = data_raw["artillery-flare"],
	["artillery-projectile"] = data_raw["artillery-projectile"],
	["beam"] = data_raw["beam"],
	["character-corpse"] = data_raw["character-corpse"],
	["cliff"] = data_raw["cliff"],
	["corpse"] = data_raw["corpse"],
	["deconstructible-tile-proxy"] = data_raw["deconstructible-tile-proxy"],
	["particle"] = data_raw["particle"], --TODO: Recheck
	["leaf-particle"] = data_raw["leaf-particle"], --TODO: Recheck
	["fire"] = data_raw["fire"],
	["flying-text"] = data_raw["flying-text"],
	["highlight-box"] = data_raw["highlight-box"],
	["item-entity"] = data_raw["item-entity"],
	["item-request-proxy"] = data_raw["item-request-proxy"],
	["particle-source"] = data_raw["particle-source"],
	["projectile"] = data_raw["projectile"],
	["resource"] = data_raw["resource"],
	["rocket-silo-rocket"] = data_raw["rocket-silo-rocket"],
	["rocket-silo-rocket-shadow"] = data_raw["rocket-silo-rocket-shadow"],
	["smoke"] = data_raw["smoke"], --TODO: Recheck
	["smoke-with-trigger"] = data_raw["smoke-with-trigger"],
	["speech-bubble"] = data_raw["speech-bubble"],
	["sticker"] = data_raw["sticker"],
	["tile-ghost"] = data_raw["tile-ghost"]
}
for _type, prototypes in pairs(lazyAPI.entities_with_health) do
	lazyAPI.all_entities[_type] = prototypes
end
for explosion_type, prototypes in pairs(lazyAPI.all_explosions) do
	lazyAPI.all_entities[explosion_type] = prototypes
end

lazyAPI.all_equipments = {
	["active-defense-equipment"] = data_raw["active-defense-equipment"],
	["battery-equipment"] = data_raw["battery-equipment"],
	["belt-immunity-equipment"] = data_raw["belt-immunity-equipment"],
	["energy-shield-equipment"] = data_raw["energy-shield-equipment"],
	["generator-equipment"] = data_raw["generator-equipment"],
	["movement-bonus-equipment"] = data_raw["movement-bonus-equipment"],
	["night-vision-equipment"] = data_raw["night-vision-equipment"],
	["roboport-equipment"] = data_raw["roboport-equipment"],
	["solar-panel-equipment"] = data_raw["solar-panel-equipment"]
}

lazyAPI.all_achievements = {
	["achievement"] = data_raw["achievement"],
	["build-entity-achievement"] = data_raw["build-entity-achievement"],
	["combat-robot-count"] = data_raw["combat-robot-count"],
	["construct-with-robots-achievement"] = data_raw["construct-with-robots-achievement"],
	["deconstruct-with-robots-achievement"] = data_raw["deconstruct-with-robots-achievement"],
	["deliver-by-robots-achievement"] = data_raw["deliver-by-robots-achievement"],
	["dont-build-entity-achievement"] = data_raw["dont-build-entity-achievement"],
	["dont-craft-manually-achievement"] = data_raw["dont-craft-manually-achievement"],
	["dont-use-entity-in-energy-production-achievement"] = data_raw["dont-use-entity-in-energy-production-achievement"],
	["finish-the-game-achievement"] = data_raw["finish-the-game-achievement"],
	["group-attack-achievement"] = data_raw["group-attack-achievement"],
	["kill-achievement"] = data_raw["kill-achievement"],
	["player-damaged-achievement"] = data_raw["player-damaged-achievement"],
	["produce-achievement"] = data_raw["produce-achievement"],
	["produce-per-hour-achievement"] = data_raw["produce-per-hour-achievement"],
	["research-achievement"] = data_raw["research-achievement"],
	["train-path-achievement"] = data_raw["train-path-achievement"]
}


lazyAPI.all_selection_tools = {
	["selection-tool"] = data_raw["selection-tool"],
	["blueprint"] = data_raw["blueprint"],
	["copy-paste-tool"] = data_raw["copy-paste-tool"],
	["deconstruction-item"] = data_raw["deconstruction-item"],
	["upgrade-item"] = data_raw["upgrade-item"]
}
lazyAPI.all_tools = {
	["armor"] = data_raw["armor"],
	["mining-tool"] = data_raw["mining-tool"], -- TODO: recheck
	["repair-tool"] = data_raw["repair-tool"]
}
lazyAPI.all_items = {
	["item"] = data_raw["item"],
	["ammo"] = data_raw["ammo"],
	["capsule"] = data_raw["capsule"],
	["gun"] = data_raw["gun"],
	["item-with-entity-data"] = data_raw["item-with-entity-data"],
	["item-with-label"] = data_raw["item-with-label"],
	["item-with-inventory"] = data_raw["item-with-inventory"],
	["blueprint-book"] = data_raw["blueprint-book"],
	["item-with-tags"] = data_raw["item-with-tags"],
	["module"] = data_raw["module"],
	["rail-planner"] = data_raw["rail-planner"],
	["spidertron-remote"] = data_raw["spidertron-remote"],
	["tool"] = data_raw["tool"]
}
for selection_tool_type, prototypes in pairs(lazyAPI.all_selection_tools) do
	lazyAPI.all_items[selection_tool_type] = prototypes
end
for tool_type, prototypes in pairs(lazyAPI.all_tools) do
	lazyAPI.all_items[tool_type] = prototypes
end

local Locale = require("static-libs/lualibs/locale")
local Version = require("static-libs/lualibs/version")


-- Add your functions in lazyAPI.add_extension(function) and
-- lazyAPI.wrap_prototype will pass wrapped prototype into your function
---@type function[]
local extensions = {}


local listeners = {
	pre_remove_prototype = {},
	remove_prototype = {},
	rename_prototype = {},
	add_prototype = {}
}
local subscriptions = {
	pre_remove_prototype = {},
	remove_prototype = {},
	rename_prototype = {},
	add_prototype = {}
}


-- lazyAPI.format_special_symbols(string): string
-- lazyAPI.add_extension(function)
-- lazyAPI.add_listener(action_name, name, types, func): boolean
-- lazyAPI.remove_listener(action_name, name)
-- lazyAPI.wrap_prototype(prototype): table
-- lazyAPI.add_prototype(type, name, prototype_data): table, table
-- lazyAPI.fix_inconsistent_array(array): integer? | lazyAPI.fix_array(array): integer?
-- lazyAPI.fix_messy_table(array): integer? | -- lazyAPI.fix_table(array): integer?
-- lazyAPI.array_to_locale(array): table?
-- lazyAPI.array_to_locale_as_new(array): table?
-- lazyAPI.locale_to_array(array): table
-- lazyAPI.merge_locales(...): table
-- lazyAPI.merge_locales_as_new(...): table
-- lazyAPI.string_to_version(str): integer | lazyAPI.string_to_version()
-- lazyAPI.get_mod_version(mod_name): integer | lazyAPI.get_mod_version()
-- lazyAPI.remove_entity_from_action_delivery(action, action_delivery, entity_name)
-- lazyAPI.remove_entity_from_action(action, entity_name)
-- lazyAPI.get_barrel_recipes(name): recipe, recipe
-- lazyAPI.create_trigger_capsule(tool_data): capsule, projectile
-- lazyAPI.create_techs(name, max_level = 1, tech_data): tech, techs
-- lazyAPI.attach_custom_input_event(name): CustomInput
-- lazyAPI.make_empty_sprite(frame_count): table
-- lazyAPI.make_empty_sprites(): table
-- lazyAPI.remove_item_ingredient_everywhere(item_name)
-- lazyAPI.remove_items_by_entity(entity)
-- lazyAPI.replace_items_by_entity(entity, new_entity)
-- lazyAPI.remove_items_by_tile(tile)
-- lazyAPI.replace_items_by_tile(tile, new_tile)
-- lazyAPI.remove_items_by_equipment(equipment)
-- lazyAPI.replace_items_by_equipment(battery_equipment, new_battery_equipment)
-- lazyAPI.remove_equipment_by_item(item): boolean
-- lazyAPI.remove_recipes_by_fluid(fluid)
-- lazyAPI.remove_recipes_by_item(item)
-- lazyAPI.remove_loot_everywhere(item)
-- lazyAPI.replace_loot_everywhere(item, new_item)
-- lazyAPI.remove_entities_by_name(name)
-- lazyAPI.has_entities_by_name(name)
-- lazyAPI.find_entities_by_name(name)
-- lazyAPI.remove_items_by_name(name)
-- lazyAPI.has_items_by_name(name)
-- lazyAPI.find_items_by_name(name)
-- lazyAPI.remove_recipe_from_modules(recipe)
-- lazyAPI.replace_recipe_in_all_modules(old_recipe, new_recipe)
-- lazyAPI.replace_prerequisite_in_all_techs(old_tech, new_tech)
-- lazyAPI.replace_resource_category_in_all_mining_drills(old_resource_category, new_resource_category)
-- lazyAPI.can_i_create(_type, name): boolean
-- lazyAPI.remove_fluid(fluid_name)
-- lazyAPI.remove_tool_everywhere(tool)
-- lazyAPI.rename_tool(prev_tool, new_tool)
-- lazyAPI.remove_tile(tile_name)


-- lazyAPI.base.does_exist(prototype): boolean
-- lazyAPI.base.get_field(prototype, field_name): any
-- lazyAPI.base.rename(prototype, new_name) | lazyAPI.base.rename_prototype(prototype, new_name)
-- lazyAPI.base.set_subgroup(prototype, subgroup, order?)
-- lazyAPI.base.remove_prototype(prototype): prototype | lazyAPI.base.remove_prototype()
-- lazyAPI.base.find_in_array(prototype, field, data): integer?
-- lazyAPI.base.has_in_array(prototype, field, data): boolean
-- lazyAPI.base.remove_from_array(prototype, field, data): prototype
-- lazyAPI.base.replace_in_prototype(prototype, field, old_data, new_data): prototype
-- lazyAPI.base.replace_in_prototypes(prototypes, field, old_data, new_data): prototypes
-- lazyAPI.base.is_cheat_prototype(prototype): boolean


-- lazyAPI.flags.add_flag(prototype, flag): prototype
-- lazyAPI.flags.remove_flag(prototype, flag): prototype
-- lazyAPI.flags.find_flag(prototype, flag): integer?


-- lazyAPI.ingredients.add_item_ingredient(prototype, item, amount = 1, difficulty?): ItemIngredientPrototype
-- lazyAPI.ingredients.add_fluid_ingredient(prototype, fluid, amount = 1, difficulty?): FluidIngredientPrototype
-- lazyAPI.ingredients.add_ingredient(prototype, target, amount = 1, difficulty?): IngredientPrototype
-- lazyAPI.ingredients.set_item_ingredient(prototype, item, amount = 1, difficulty?): prototype
-- lazyAPI.ingredients.set_fluid_ingredient(prototype, fluid, amount = 1, difficulty?): prototype
-- lazyAPI.ingredients.set_ingredient(prototype, target, amount = 1, difficulty?): prototype
-- lazyAPI.ingredients.get_item_ingredients(prototype, item, difficulty?): ItemIngredientPrototype[]
-- lazyAPI.ingredients.get_fluid_ingredients(prototype, fluid, difficulty?): FluidIngredientPrototype[]
-- lazyAPI.ingredients.remove_ingredient(prototype, ingredient, type?, difficulty?): IngredientPrototype?
-- lazyAPI.ingredients.remove_ingredient_everywhere(prototype, ingredient, type?): prototype
-- lazyAPI.ingredients.replace_ingredient(prototype, old_ingredient, new_ingredient, type?, difficulty?): prototype
-- lazyAPI.ingredients.replace_ingredient_everywhere(prototype, old_ingredient, new_ingredient, type?): prototype
-- lazyAPI.ingredients.find_ingredient_by_name(prototype, ingredient, difficulty?): IngredientPrototype?


-- lazyAPI.resistance.find(prototype, type): Resistances?
-- lazyAPI.resistance.set(prototype, type, percent, decrease?): prototype
-- lazyAPI.resistance.remove(prototype, type): prototype


-- lazyAPI.loot.find(prototype, item): Loot?
-- lazyAPI.loot.replace(prototype, item): prototype
-- lazyAPI.loot.set(prototype, type, count_min?, count_max? percent?, decrease?): prototype
-- lazyAPI.loot.remove(prototype, item): prototype


-- lazyAPI.entity.has_item(entity): boolean


-- lazyAPI.EntityWithHealth.find_resistance(prototype, type)
-- lazyAPI.EntityWithHealth.set_resistance(prototype, type, percent, decrease)
-- lazyAPI.EntityWithHealth.remove_resistance(prototype, type)
-- lazyAPI.EntityWithHealth.find_loot(prototype, item): Loot?
-- lazyAPI.EntityWithHealth.replace_loot(prototype, item): prototype
-- lazyAPI.EntityWithHealth.set_loot(prototype, type, count_min?, count_max? percent?, decrease?): prototype
-- lazyAPI.EntityWithHealth.remove_loot(prototype, item): prototype


--# There are several issues still
-- lazyAPI.recipe.set_subgroup(prototype, subgroup, order?): prototype
-- lazyAPI.recipe.have_ingredients(recipe): boolean

-- lazyAPI.recipe.add_item_ingredient(prototype, item, amount = 1, difficulty?): ItemIngredientPrototype
-- lazyAPI.recipe.add_fluid_ingredient(prototype, fluid, amount = 1, difficulty?): FluidIngredientPrototype
-- lazyAPI.recipe.add_ingredient(prototype, target, amount = 1, difficulty?): IngredientPrototype
-- lazyAPI.recipe.set_item_ingredient(prototype, item, amount = 1, difficulty?): prototype
-- lazyAPI.recipe.set_fluid_ingredient(prototype, fluid, amount = 1, difficulty?): prototype
-- lazyAPI.recipe.set_ingredient(prototype, target, amount = 1, difficulty?): prototype
-- lazyAPI.recipe.get_item_ingredients(prototype, item, difficulty?): ItemIngredientPrototype[]
-- lazyAPI.recipe.get_fluid_ingredients(prototype, fluid, difficulty?): FluidIngredientPrototype[]
-- lazyAPI.recipe.remove_ingredient(prototype, ingredient, type?, difficulty?): IngredientPrototype?
-- lazyAPI.recipe.remove_ingredient_everywhere(prototype, ingredient, type?): prototype
-- lazyAPI.recipe.replace_ingredient(prototype, old_ingredient, new_ingredient, type?, difficulty?): prototype
-- lazyAPI.recipe.replace_ingredient_everywhere(prototype, old_ingredient, new_ingredient, type?): prototype
-- lazyAPI.recipe.find_ingredient_by_name(prototype, ingredient, difficulty?): IngredientPrototype?

-- lazyAPI.product.make_product_prototype(item_product, product_type, show_details_in_recipe_tooltip): ProductPrototype
-- lazyAPI.product.make_item_product_prototype(item_product, show_details_in_recipe_tooltip): ItemProductPrototype
-- lazyAPI.product.make_fluid_product_prototype(fluid_product, show_details_in_recipe_tooltip): FluidProductPrototype

-- lazyAPI.recipe.has_result(prototype): boolean
-- lazyAPI.recipe.add_item_in_result(prototype, item, item_product, difficulty): prototype
-- lazyAPI.recipe.add_fluid_in_result(prototype, fluid, fluid_product, difficulty): prototype
-- lazyAPI.recipe.add_product_in_result(prototype, product, product_prototype, difficulty): prototype
-- lazyAPI.recipe.set_item_in_result(prototype, item, item_product, difficulty): prototype
-- lazyAPI.recipe.set_fluid_in_result(prototype, fluid, fluid_product, difficulty): prototype
-- lazyAPI.recipe.set_product_in_result(prototype, product, product_prototype, difficulty): prototype
-- lazyAPI.recipe.remove_if_empty_result(prototype): prototype?
-- lazyAPI.recipe.remove_item_from_result(prototype, item, difficulty?): prototype
-- lazyAPI.recipe.remove_item_from_result_everywhere(prototype, item): prototype
-- lazyAPI.recipe.remove_fluid_from_result(prototype, fluid, difficulty?): prototype
-- lazyAPI.recipe.remove_fluid_from_result_everywhere(prototype, fluid): prototype
-- lazyAPI.recipe.find_item_in_result(prototype, item, difficulty?): ProductPrototype|string?
-- lazyAPI.recipe.count_item_in_result(prototype, item, difficulty?): integer
-- lazyAPI.recipe.find_fluid_in_result(prototype, fluid, difficulty?): ProductPrototype
-- lazyAPI.recipe.count_fluid_in_result(prototype, fluid, difficulty?): integer


-- lazyAPI.module.is_recipe_allowed(prototype, recipe): boolean
-- lazyAPI.module.find_allowed_recipe_index(prototype, recipe): integer?
-- lazyAPI.module.find_blacklisted_recipe_index(prototype, recipe): integer?
-- lazyAPI.module.allow_recipe(prototype, recipe): prototype
-- lazyAPI.module.prohibit_recipe(prototype, recipe): prototype
-- lazyAPI.module.remove_allowed_recipe(prototype, recipe): prototype
-- lazyAPI.module.remove_blacklisted_recipe(prototype, recipe): prototype
-- lazyAPI.module.replace_recipe(prototype, old_recipe, new_recipe): prototype


-- lazyAPI.tech.remove_if_no_effects(prototype): prototype?
-- lazyAPI.tech.unlock_recipe(prototype, recipe, difficulty?): prototype
-- lazyAPI.tech.find_unlock_recipe_effect(prototype, recipe, difficulty?): UnlockRecipeModifierPrototype?
-- lazyAPI.tech.add_effect(prototype, type, recipe, difficulty?): prototype?
-- lazyAPI.tech.find_effect(prototype, type, recipe, difficulty?): ModifierPrototype?
-- lazyAPI.tech.remove_unlock_recipe_effect(prototype, recipe, difficulty?): prototype
-- lazyAPI.tech.remove_unlock_recipe_effect_everywhere(prototype, recipe_name): prototype
-- lazyAPI.tech.remove_effect(prototype, type, recipe, difficulty?): prototype
-- lazyAPI.tech.remove_effect_everywhere(prototype, type, recipe): prototype

-- lazyAPI.tech.find_prerequisite(prototype, tech): integer?
-- lazyAPI.tech.add_prerequisite(prototype, tech): prototype
-- lazyAPI.tech.remove_prerequisite(prototype, tech): prototype
-- lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech): prototype

-- lazyAPI.tech.add_tool(prototype, tool, amount = 1): ItemIngredientPrototype?
-- lazyAPI.tech.set_tool(prototype, tool, amount = 1): prototype
-- lazyAPI.tech.remove_tool(prototype, tool): IngredientPrototype
-- lazyAPI.tech.replace_tool(prototype, old_tool, new_tool): prototype

-- lazyAPI.tech.is_contiguous_tech(tech): boolean
-- lazyAPI.tech.get_last_tech_level(tech): integer?
-- lazyAPI.tech.get_last_valid_contiguous_tech_level(tech): integer?
-- lazyAPI.tech.remove_contiguous_techs(tech): tech


-- lazyAPI.mining_drill.find_resource_category(prototype, resource_category): integer?
-- lazyAPI.mining_drill.add_resource_category(prototype, resource_category): prototype
-- lazyAPI.mining_drill.remove_resource_category(prototype, resource_category): prototype
-- lazyAPI.mining_drill.replace_resource_category(prototype, old_resource_category, new_resource_category): prototype


-- lazyAPI.character.remove_armor(prototype, armor): prototype


-- It's weird and looks wrong but it should work
data.extend = function(self, new_prototypes, ...)
	add_prototypes(self, new_prototypes, ...) -- original data.extend
	for _, prototype in pairs(new_prototypes) do
		local prototype_type = prototype.type
		local name = prototype.name
		if data_raw[prototype_type][name] then
			if subscriptions.add_prototype[prototype_type] then
				for _, func in pairs(subscriptions.add_prototype[prototype_type]) do
					func(prototype, name, prototype_type)
				end
			end
			if subscriptions.add_prototype.all then
				for _, func in pairs(subscriptions.add_prototype.all) do
					func(prototype, name, prototype_type)
				end
			end
		end
	end
end

local function tmemoize(t, func)
	return setmetatable(t, {
		__index = function(self, k)
			local v = func(k)
			self[k] = v
			return v
		end
	})
end

local strings_for_patterns = {[''] = ''}
tmemoize(strings_for_patterns, function(str)
	return (
		str:gsub('%%', '%%%%')
		:gsub('^%^', '%%^')
		:gsub('%$$', '%%$')
		:gsub('%(', '%%(')
		:gsub('%)', '%%)')
		:gsub('%.', '%%.')
		:gsub('%[', '%%[')
		:gsub('%]', '%%]')
		:gsub('%*', '%%*')
		:gsub('%+', '%%+')
		:gsub('%-', '%%-')
		:gsub('%?', '%%?')
	)
end)


lazyAPI.array_to_locale = Locale.array_to_locale
lazyAPI.array_to_locale_as_new = Locale.array_to_locale_as_new
lazyAPI.locale_to_array = Locale.locale_to_array
lazyAPI.merge_locales = Locale.merge_locales
lazyAPI.merge_locales_as_new = Locale.merge_locales_as_new


---@type table<string, integer>
local memorized_versions = {}
tmemoize(memorized_versions, Version.string_to_version)
-- Supports strings like: "5", "5.5", "5.5.5"
---@param str string
---@return integer version
---@overload fun()
lazyAPI.string_to_version = function(str)
	return memorized_versions[str]
end

---@param mod_name string
---@return version
---@overload fun()
lazyAPI.get_mod_version = function(mod_name)
	local str_version = mods[mod_name]
	if str_version then
		return memorized_versions(str_version)
	end
end


---@param str string
---@return string
lazyAPI.format_special_symbols = function(str)
	return strings_for_patterns[str]
end


---@param func function #your function
lazyAPI.add_extension = function(func)
	extensions[#extensions+1] = func
end


--- Fixes keys with positive integers only
---@param array table<integer, any>
---@return integer? # first fixed index
lazyAPI.fix_inconsistent_array = function(array)
	local len_before = #array
	if len_before > 0 then
		for i=len_before, 1, -1 do
			if array[i] == nil then
				lazyAPI.tables_with_errors[array] = error_types.element_is_nil
				tremove(array, i)
			end
		end
		if next(array, len_before) == nil then
			return
		end
	else
		if next(array) == nil then
			return
		end
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


--- Fixes keys with positive integers only
---@param t table
---@return integer? # first fixed index
lazyAPI.fix_messy_table = function(t)
	local len_before = #t
	if len_before > 0 then
		for i=len_before, 1, -1 do
			if t[i] == nil then
				lazyAPI.tables_with_errors[t] = error_types.element_is_nil
				tremove(t, i)
			end
		end
		if next(t, len_before) == nil then
			return
		end
	else
		if next(t) == nil then
			return
		end
	end

	local temp_arr, last_key
	for k, v in next, t do
		if type(k) == "number" and k > len_before then
			t[k] = nil
			if next(t, k) == nil then
				t[len_before+1] = v
				return len_before + 1
			end
			last_key = k
			temp_arr = {v}
			break
		else
			lazyAPI.tables_with_errors[t] = error_types.mixed_array
		end
	end

	if temp_arr == nil then return end

	for k, v in next, t, last_key do
		if type(k) == "number" then
			if k > len_before then
				t[k] = nil
				temp_arr[#temp_arr+1] = v
			end
		else
			lazyAPI.tables_with_errors[t] = error_types.mixed_array
		end
	end
	for i=1, #temp_arr do
		t[#t+1] = temp_arr[i]
	end
	return len_before + 1
end
lazyAPI.fix_table = lazyAPI.fix_messy_table
local fix_messy_table = lazyAPI.fix_messy_table


---@param prototype table
---@param field string
---@param data any
---@return integer? #index
lazyAPI.base.find_in_array = function(prototype, field, data)
	if data == nil then error("data is nil") end
	if field == nil then error("field is nil") end
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return end

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
	if data == nil then error("data is nil") end
	if field == nil then error("field is nil") end
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return false end

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
	if prototype == nil then return end
	if data == nil then error("data is nil") end
	if field == nil then error("field is nil") end
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return prototype end

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
---@param old_name string
---@param new_name string
---@return table prototype
lazyAPI.base.rename_in_array = function(prototype, field, old_name, new_name)
	if prototype == nil then return end
	if old_name == nil then error("old_name is nil") end
	if new_name == nil then error("new_name is nil") end
	if field == nil then error("field is nil") end
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return prototype end

	fix_array(array)
	for i=#array, 1, -1 do
		if array[i] == old_name then
			array[i] = new_name
		end
	end
	return prototype
end
local rename_in_array = lazyAPI.base.rename_in_array


---@param prototype table
---@param field string
---@param data any
---@return table prototype
lazyAPI.base.add_to_array = function(prototype, field, data)
	if data == nil then error("data is nil") end
	if field == nil then error("field is nil") end
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


---@param prototypes table #https://wiki.factorio.com/data_raw or similar structure
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


-- TODO: improve (there are many ways to change it)
---@type table<table, boolean>
local cheat_prototypes = {}
tmemoize(cheat_prototypes, function(prototype)
	local name = prototype.name
	return (not (
		name:find("creative") -- for https://mods.factorio.com/mod/creative-mode etc
		and name:find("hidden")
		and name:find("infinity")
		and name:find("cheat")
		and name:find("[xX]%d+_") -- for https://mods.factorio.com/mod/X100_assembler etc
		and name:find("^osp_") -- for mods.factorio.com/mod/m-spell-pack
		and name:find("^ee%-") -- for https://mods.factorio.com/mod/EditorExtensions
	))
end)
---@param prototype table
---@return boolean
lazyAPI.base.is_cheat_prototype = function(prototype)
	return cheat_prototypes[prototype]
end


---@param action_name function #name of your
---@param types string[] #https://wiki.factorio.com/data_raw or "all"
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


lazyAPI.add_listener("remove_prototype", {"technology"}, "lazyAPI_remove_technology", function(prototype, tech_name, tech_type)
	lazyAPI.tech.remove_contiguous_techs(prototype)
	for _, technology in pairs(technologies) do
		lazyAPI.tech.remove_prerequisite(technology, tech_name)
	end

	for _, shortcut in pairs(data_raw.shortcut) do
		if shortcut.technology_to_unlock == tech_name then
			shortcut.technology_to_unlock = nil
		end
	end

	for _, achievement in pairs(data_raw["research-achievement"]) do
		if achievement.technology == tech_name then
			lazyAPI.base.remove_prototype(achievement)
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"recipe"}, "lazyAPI_remove_recipe", function(prototype, recipe_name, type)
	lazyAPI.remove_recipe_from_modules(recipe_name)

	for _, technology in pairs(technologies) do
		lazyAPI.tech.remove_unlock_recipe_effect_everywhere(technology, recipe_name)
	end

	for _, silo in pairs(data_raw["rocket-silo"]) do
		if silo.fixed_recipe == recipe_name then
			silo.fixed_recipe = nil -- is it right?
			-- lazyAPI.base.remove_prototype(silo)
		end
	end
		for _, machine in pairs(data_raw["assembling-machine"]) do
		if machine.fixed_recipe == recipe_name then
			machine.fixed_recipe = nil -- is it right?
			-- lazyAPI.base.remove_prototype(machine)
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"fluid"}, "lazyAPI_remove_fluid", function(prototype, fluid_name, type)
	lazyAPI.remove_fluid(fluid_name)
end)
lazyAPI.add_listener("remove_prototype", {"tool"}, "lazyAPI_remove_tool", function(prototype, tool_name, type)
	lazyAPI.remove_tool_everywhere(tool_name)
end)
lazyAPI.add_listener("rename_prototype", {"tool"}, "lazyAPI_rename_tool", function(prototype, prev_name, new_name, prototype_type)
	lazyAPI.rename_tool(prev_name, prototype.name)
end)
lazyAPI.add_listener("remove_prototype", {"underground-belt"}, "lazyAPI_remove_underground-belt", function(prototype, underground_belt_name, type)
	for _, belt in pairs(data_raw["transport-belt"]) do
		if belt.related_underground_belt == underground_belt_name then
			belt.related_underground_belt = nil
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"assembling-machine"}, "lazyAPI_remove_assembling-machine", function(prototype, machine_name, type)
	for _, tt in pairs(data_raw["tips-and-tricks-item"]) do
		if tt.trigger then
			local triggers = tt.trigger.triggers
			if triggers then
				fix_array(triggers)
				for i=#triggers, 1, -1 do
					local trigger = triggers[i]
					if trigger.machine and trigger.machine == machine_name then
						tremove(triggers, i)
					end
				end
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"armor"}, "lazyAPI_remove_armor", function(prototype, armor_name, armor_type)
	for _, character in pairs(data_raw.character) do
		lazyAPI.character.remove_armor(character, armor_name)
	end
end)
lazyAPI.add_listener("remove_prototype", {"tips-and-tricks-item"}, "lazyAPI_remove_tips-and-tricks-item", function(prototype, tt_name, tt_type)
	for _, tt in pairs(data_raw["tips-and-tricks-item"]) do
		if tt.dependencies then
			remove_from_array(tt, "dependencies", tt_name)
			if #tt.dependencies <= 0 then
				tt.dependencies = nil
			end
		end
	end
end)

--TODO: Refactor!
local function remove_tile_from_action(action, tile_name)
	local action_delivery = action.action_delivery
	if action_delivery then
		local target_effects = action_delivery.target_effects
		if target_effects then
			local _tile_name = target_effects.tile_name
			if _tile_name then
				if _tile_name == tile_name then
					action_delivery.target_effects = nil
				end
			elseif type(next(target_effects)) == "number" then
				fix_messy_table(target_effects)
				for i=#target_effects, 1, -1 do
					local effect = target_effects[i]
					if effect.tile_name == tile_name then
						tremove(target_effects, i)
					elseif effect.action then
						remove_tile_from_action(effect.action, tile_name)
					end
				end
				if #target_effects <= 0 then
					action_delivery.target_effects = nil
				end
			end
		end
	end
end
lazyAPI.add_listener("remove_prototype", {"tile"}, "lazyAPI_remove_tile", function(prototype, tile_name, tile_type)
	lazyAPI.remove_tile(tile_name)
end)
lazyAPI.add_listener("remove_prototype", {"equipment-grid"}, "lazyAPI_remove_equipment-grid", function(prototype, EGrid_name, grid_type)
	for _, prototypes in pairs(lazyAPI.all_vehicles) do
		for _, vehicle in pairs(prototypes) do
			if vehicle.equipment_grid == EGrid_name then
				vehicle.equipment_grid = nil
			end
		end
	end
end)
lazyAPI.add_listener("rename_prototype", {"equipment-grid"}, "lazyAPI_rename_equipment-grid", function(prototype, prev_name, new_name, prototype_type)
	for _, prototypes in pairs(lazyAPI.all_vehicles) do
		for _, vehicle in pairs(prototypes) do
			if vehicle.equipment_grid == prev_name then
				vehicle.equipment_grid = new_name
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"optimized-decorative"}, "lazyAPI_remove_optimized-decorative", function(prototype, decorative_name, decorative_type)
	for _, prototypes in pairs(lazyAPI.all_surrets) do
		for _, entity in pairs(prototypes) do
			local spawn_decoration = entity.spawn_decoration
			if spawn_decoration then
				fix_array(spawn_decoration)
				for i=#spawn_decoration, 1, -1 do
					if spawn_decoration[i].decorative == decorative_name then
						tremove(spawn_decoration, i)
					end
				end
			end
		end
	end
	for _, entity in pairs(data_raw["unit-spawner"]) do
		local spawn_decoration = entity.spawn_decoration
		if spawn_decoration then
			fix_array(spawn_decoration)
			for i=#spawn_decoration, 1, -1 do
				if spawn_decoration[i].decorative == decorative_name then
					tremove(spawn_decoration, i)
				end
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"virtual-signal"}, "lazyAPI_remove_virtual-signal", function(prototype, vSignal_name, signal_type)
	for _, lamp in pairs(data_raw.lamp) do
		local signal_to_color_mapping = lamp.signal_to_color_mapping
		if signal_to_color_mapping then
			fix_array(signal_to_color_mapping)
			for i=#signal_to_color_mapping, 1, -1 do
			 	if signal_to_color_mapping[i].name == vSignal_name then
					tremove(signal_to_color_mapping, i)
				end
			end
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, inserter in pairs(data_raw["inserter"]) do
		if inserter.default_stack_control_input_signal and inserter.default_stack_control_input_signal.name == vSignal_name then
			inserter.default_stack_control_input_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, inserter in pairs(data_raw["wall"]) do
		if inserter.default_output_signal and inserter.default_output_signal.name == vSignal_name then
			inserter.default_output_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, inserter in pairs(data_raw["accumulator"]) do
		if inserter.default_output_signal and inserter.default_output_signal.name == vSignal_name then
			inserter.default_output_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, RCSignal in pairs(data_raw["rail-chain-signal"]) do
		if RCSignal.default_red_output_signal and RCSignal.default_red_output_signal.name == vSignal_name then
			RCSignal.default_red_output_signal = nil
		end
		if RCSignal.default_orange_output_signal and RCSignal.default_orange_output_signal.name == vSignal_name then
			RCSignal.default_orange_output_signal = nil
		end
		if RCSignal.default_green_output_signal and RCSignal.default_green_output_signal.name == vSignal_name then
			RCSignal.default_green_output_signal = nil
		end
		if RCSignal.default_blue_output_signal and RCSignal.default_blue_output_signal.name == vSignal_name then
			RCSignal.default_blue_output_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, train_stop in pairs(data_raw["train-stop"]) do
		if train_stop.default_train_stopped_signal and train_stop.default_train_stopped_signal.name == vSignal_name then
			train_stop.default_train_stopped_signal = nil
		end
		if train_stop.default_trains_count_signal and train_stop.default_trains_count_signal.name == vSignal_name then
			train_stop.default_trains_count_signal = nil
		end
		if train_stop.default_trains_limit_signal and train_stop.default_trains_limit_signal.name == vSignal_name then
			train_stop.default_trains_limit_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, rail_signal in pairs(data_raw["rail-signal"]) do
		if rail_signal.default_red_output_signal and rail_signal.default_red_output_signal.name == vSignal_name then
			rail_signal.default_red_output_signal = nil
		end
		if rail_signal.default_orange_output_signal and rail_signal.default_orange_output_signal.name == vSignal_name then
			rail_signal.default_orange_output_signal = nil
		end
		if rail_signal.default_green_output_signal and rail_signal.default_green_output_signal.name == vSignal_name then
			rail_signal.default_green_output_signal = nil
		end
	end

	-- Perhaps, I should add a default replacement.
	for _, roboport in pairs(data_raw["roboport"]) do
		if roboport.default_available_logistic_output_signal and roboport.default_available_logistic_output_signal.name == vSignal_name then
			roboport.default_available_logistic_output_signal = nil
		end
		if roboport.default_total_logistic_output_signal and roboport.default_total_logistic_output_signal.name == vSignal_name then
			roboport.default_total_logistic_output_signal = nil
		end
		if roboport.default_available_construction_output_signal and roboport.default_available_construction_output_signal.name == vSignal_name then
			roboport.default_available_construction_output_signal = nil
		end
		if roboport.default_total_construction_output_signal and roboport.default_total_construction_output_signal.name == vSignal_name then
			roboport.default_total_construction_output_signal = nil
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"unit"}, "lazyAPI_remove_unit", function(prototype, unit_name, unit_type)
	for _, spawner in pairs(data_raw["unit-spawner"]) do
		local result_units = spawner.result_units
		if result_units then
			fix_array(result_units)
			for i=#result_units, 1, -1 do
			 	if result_units[i][1] == unit_name then
					tremove(result_units, i)
				end
			end
		end
	end
end)
lazyAPI.add_listener("rename_prototype", {"unit"}, "lazyAPI_rename_unit", function(prototype, prev_name, new_name, prototype_type)
	for _, spawner in pairs(data_raw["unit-spawner"]) do
		local result_units = spawner.result_units
		if result_units then
			fix_array(result_units)
			for i=1, #result_units do
				local result = result_units[i]
			 	if result[1] == prev_name then
					result[1] = new_name
				end
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"resource"}, "lazyAPI_remove_resource", function(prototype, resource_name, resource_type)
	local autoplace = data_raw["autoplace-control"][resource_name]
	if autoplace and autoplace.category == "resource" then
		lazyAPI.base.remove_prototype(autoplace)
	end

	for _, preset in pairs(data_raw["map-gen-presets"]) do
		for _, preset_data in pairs(preset) do
			local basic_settings = preset_data.basic_settings
			if basic_settings and basic_settings.autoplace_controls then
				basic_settings.autoplace_controls[resource_name] = nil
			end
		end
	end
end)

--TODO: Refactor!
---@param action table
---@param action_delivery table
---@param entity_name string
lazyAPI.remove_entity_from_action_delivery = function(action, action_delivery, entity_name)
	-- Weird. TODO: recheck
	if action_delivery.projectile == entity_name then
		-- very ugly
		if action.action_delivery == action_delivery then
			action.action_delivery = nil
		else
			for i=#action.action_delivery, 1, -1 do
				if _action_del == action_delivery then
					tremove(action.action_delivery, i)
				end
			end
		end
		return
	end

	local source_effects = action_delivery.source_effects
	if source_effects then
		if source_effects.entity_name == entity_name then
			action_delivery.source_effects = nil
		else
			if type(next(source_effects)) == "number" then
				fix_array(source_effects)
				for i=#source_effects, 1, -1 do
					local effect = source_effects[i]
					if effect.entity_name == entity_name then
						tremove(source_effects, i)
					elseif effect.action then
						lazyAPI.remove_entity_from_action(effect.action, entity_name)
					end
				end
				if #source_effects <= 0 then
					action_delivery.source_effects = nil
				end
			end
		end
	end
	local target_effects = action_delivery.target_effects
	if target_effects then
		-- I'm not sure how it's useful but bobwarfare has such data
		for k, effect in pairs(target_effects) do
			if type(k) ~= "number" and type(effect) == "table" then
				if effect.entity_name == entity_name then
					target_effects[k] = nil
				elseif effect.action then
					lazyAPI.remove_entity_from_action(effect.action, entity_name)
				end
			end
		end
		local _entity_name = target_effects.entity_name
		if _entity_name then
			if _entity_name == entity_name then
				action_delivery.target_effects = nil
			end
		elseif type(next(target_effects)) == "number" then -- TODO: Recheck!
			fix_messy_table(target_effects)
			for i=#target_effects, 1, -1 do
				local effect = target_effects[i]
				if effect.entity_name == entity_name then -- TODO: recheck, something is wrong
					tremove(target_effects, i)
				elseif effect.action then
					lazyAPI.remove_entity_from_action(effect.action, entity_name)
				end
			end
			if #target_effects <= 0 then
				action_delivery.target_effects = nil
			end
		end
	end
end

---@param action table
---@param entity_name string
lazyAPI.remove_entity_from_action = function(action, entity_name)
	local action_delivery = action.action_delivery
	if action_delivery == nil then return end
	if type(next(action_delivery)) == number then
		fix_messy_table(action_delivery)
		for i=#action_delivery, 1, -1 do
			lazyAPI.remove_entity_from_action_delivery(action, action_delivery[i], entity_name)
		end
	else
		lazyAPI.remove_entity_from_action_delivery(action, action_delivery, entity_name)
	end
end
lazyAPI.add_listener("remove_prototype", {"all"}, "lazyAPI_remove_explosions", function(prototype, explosion_name, explosion_type)
	if not lazyAPI.all_explosions[explosion_type] then return end

	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _, entity in pairs(prototypes) do
			if entity.dying_explosion == explosion_name then
				entity.dying_explosion = nil
			end
		end
	end
end)
lazyAPI.add_listener("rename_prototype", {"all"}, "lazyAPI_rename_explosions", function(prototype, prev_name, new_name, prototype_type)
	if not lazyAPI.all_explosions[explosion_type] then return end

	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _, entity in pairs(prototypes) do
			if entity.dying_explosion == prev_name then
				entity.dying_explosion = new_name
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"all"}, "lazyAPI_remove_entities", function(prototype, entity_name, entity_type)
	if not lazyAPI.all_entities[entity_type] then return end

	lazyAPI.remove_items_by_entity(entity_name)

	for _, entity in pairs(data_raw[entity_type]) do
		if entity.next_upgrade == entity_name then
			entity.next_upgrade = nil
		end
	end

	for _, achievement in pairs(data_raw["dont-build-entity-achievement"]) do
		local dont_build = achievement.dont_build
		if dont_build then
			if type(dont_build) == "string" then
				if dont_build == entity_name then
					achievement.dont_build = nil
				end
			else
				remove_from_array(achievement, "dont_build", entity_name)
			end
		end
	end

	for _, achievement in pairs(data_raw["build-entity-achievement"]) do
		if achievement.to_build == entity_name then
			lazyAPI.base.remove_prototype(achievement)
		end
	end

	-- This looks weird
	for _, achievement in pairs(data_raw["dont-use-entity-in-energy-production-achievement"]) do
		if achievement.included == entity_name then
			achievement.included = nil -- It works
		end
		local excluded = achievement.excluded
		if excluded then
			if type(excluded) == "string" then
				if excluded == entity_name then
					lazyAPI.base.remove_prototype(achievement)
				end
			else
				remove_from_array(achievement, "excluded", entity_name)
				if #excluded <= 0 then
					lazyAPI.base.remove_prototype(achievement)
				end
			end
		end
	end

	for _, entity in pairs(data_raw.ammo) do
		local ammo_type = entity.ammo_type
		if ammo_type then
			local actions = ammo_type.action
			if actions then
				if type(next(actions)) == "number" then
					for i=#actions, 1, -1 do
						lazyAPI.remove_entity_from_action(actions[i], entity_name)
					end
				else
					lazyAPI.remove_entity_from_action(actions, entity_name)
				end
			end
		end
	end

	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _, entity in pairs(prototypes) do
			if entity.corpse == entity_name then
				entity.corpse = nil
			end
			if entity.remains_when_mined == entity_name then
				entity.remains_when_mined = nil
			end
			if entity.damaged_trigger_effect and entity.damaged_trigger_effect.entity_name == entity_name then
				entity.damaged_trigger_effect = nil
			end
			if entity.dying_trigger_effect and entity.dying_trigger_effect.entity_name == entity_name then
				entity.dying_trigger_effect = nil
			end
			local actions = entity.action
			if actions then
				if type(next(actions)) == "number" then
					for i=#actions, 1, -1 do
						lazyAPI.remove_entity_from_action(actions[i], entity_name)
					end
				else
					lazyAPI.remove_entity_from_action(actions, entity_name)
				end
			end
			local final_actions = entity.final_action
			if final_actions then
				if type(next(final_actions)) == "number" then
					for i=#final_actions, 1, -1 do
						lazyAPI.remove_entity_from_action(final_actions[i], entity_name)
					end
				else
					lazyAPI.remove_entity_from_action(final_actions, entity_name)
				end
			end
			-- I'm lazy to check all prototypes
			local attack_parameters = entity.attack_parameters
			if attack_parameters then
				local ammo_type = attack_parameters.ammo_type
				if ammo_type then
					local actions = ammo_type.action
					if actions then
						if type(next(actions)) == "number" then
							for i=#actions, 1, -1 do
								lazyAPI.remove_entity_from_action(actions[i], entity_name)
							end
						else
							lazyAPI.remove_entity_from_action(actions, entity_name)
						end
					end
				end
			end
		end
	end

	-- Is it excessive? I added it because of corpses
	for _, entity in pairs(data_raw["optimized-particle"]) do
		local effects = entity.ended_on_ground_trigger_effect
		if effects then
			if type(next(effects)) == "number" then
				fix_array(effects)
				for i=#effects, 1, -1 do
					if effects[i].entity_name == entity_name then
						tremove(effects, i)
					end
				end
			end
		end
		effects = entity.ended_in_water_trigger_effect
		if effects then
			if type(next(effects)) == "number" then
				fix_array(effects)
				for i=#effects, 1, -1 do
					if effects[i].entity_name == entity_name then
						tremove(effects, i)
					end
				end
			end
		end
		effects = entity.regular_trigger_effect
		if effects then
			if type(next(effects)) == "number" then
				fix_array(effects)
				for i=#effects, 1, -1 do
					if effects[i].entity_name == entity_name then
						tremove(effects, i)
					end
				end
			end
		end
	end

	for _, tt in pairs(data_raw["tips-and-tricks-item"]) do
		local trigger = tt.trigger
		if trigger then
			local entity = trigger.entity
			if entity then
				if entity == entity_name then
					tt.trigger = nil
				end
			else
				local triggers = trigger.triggers
				if triggers then
					fix_array(triggers)
					for i=#triggers, 1, -1 do
						local _trigger = triggers[i]
						if _trigger.entity == entity_name then
							tremove(triggers, i)
						end
					end
				end
			end
		end
		local skip_trigger = tt.skip_trigger
		if skip_trigger then
			if skip_trigger.entity == entity_name then
				skip_trigger.entity = nil
			end
			if skip_trigger.target == entity_name then
				skip_trigger.target = nil
			end
			if skip_trigger.source == entity_name then
				skip_trigger.source = nil
			end
			local triggers = skip_trigger.triggers
			if triggers then
				fix_array(triggers)
				for i=#triggers, 1, -1 do
					local _trigger = triggers[i]
					if _trigger.target == entity_name then
						_trigger.target = nil
					end
					if _trigger.source == entity_name then
						_trigger.source = nil
					end
				end
			end
		end
	end

	for _, equipment in pairs(data_raw["active-defense-equipment"]) do
		local attack_parameters = equipment.attack_parameters
		if attack_parameters then
			local ammo_type = attack_parameters.ammo_type
			if ammo_type then
				local actions = ammo_type.action
				if actions then
					if type(next(actions)) == "number" then
						for i=#actions, 1, -1 do
							lazyAPI.remove_entity_from_action(actions[i], entity_name)
						end
					else
						lazyAPI.remove_entity_from_action(actions, entity_name)
					end
				end
			end
		end
	end
end)
lazyAPI.add_listener("remove_prototype", {"all"}, "lazyAPI_remove_equipments", function(prototype, equipment_name, equipment_type)
	if not lazyAPI.all_equipments[equipment_type] then return end

	lazyAPI.remove_items_by_equipment(equipment_name)

	for _, capsule in pairs(data_raw.capsule) do
		local capsule_action = capsule.capsule_action
		if capsule_action and capsule_action.equipment == equipment_name then
			lazyAPI.base.remove_prototype(capsule)
		end
	end
end)


lazyAPI.add_listener("remove_prototype", {"all"}, "lazyAPI_remove_turrets", function(prototype, turret_name, turret_type)
	if not lazyAPI.all_surrets[turret_type] then return end

	for _, technology in pairs(technologies) do
		lazyAPI.tech.remove_effect_everywhere(technology, "turret-attack", turret_name)
	end
end)
lazyAPI.add_listener("remove_prototype", {"all"}, "lazyAPI_remove_items", function(prototype, item_name, item_type)
	if not lazyAPI.all_items[item_type] then return end

	lazyAPI.remove_recipes_by_item(item_name)
	lazyAPI.remove_loot_everywhere(item_name)
	lazyAPI.remove_equipment_by_item(item_name)

	for _, item in pairs(data_raw.item) do
		if item.burnt_result == item_name then
			item.burnt_result = nil
		end
	end

	for _, shortcut in pairs(data_raw.shortcut) do
		if shortcut.item_to_spawn == item_name then
			shortcut.item_to_spawn = nil
			if shortcut.action == "spawn-item" then
				lazyAPI.base.remove_prototype(shortcut) -- Perhaps, it's wrong
			end
		end
	end

	for _, cliff in pairs(data_raw.cliff) do
		if cliff.cliff_explosive == item_name then
			lazyAPI.base.remove_prototype(cliff)
		end
	end

	for _, prototypes in pairs(lazyAPI.all_vehicles) do
		for _, vehicle in pairs(prototypes) do
			remove_from_array(vehicle, "guns", item_name)
		end
	end

	for _, tile in pairs(data_raw.tile) do
		if tile.minable and tile.minable.result == item_name then
			tile.minable = nil
		end
	end

	for _, tt in pairs(data_raw["tips-and-tricks-item"]) do
		if tt.trigger and tt.trigger.entity == recipe_name then
			lazyAPI.base.remove_prototype(tt)
		end
	end

	for _, achievement in pairs(data_raw["produce-per-hour-achievement"]) do
		if achievement.item_product == item_name then
			lazyAPI.base.remove_prototype(achievement)
		end
	end

	for _, achievement in pairs(data_raw["produce-achievement"]) do
		if achievement.item_product == item_name then
			lazyAPI.base.remove_prototype(achievement)
		end
	end

	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _, entity in pairs(prototypes) do
			if entity.name == item_name then
				lazyAPI.base.remove_prototype(entity)
			end

			local placeable_by = entity.placeable_by
			if placeable_by and placeable_by.item == item_name then
				entity.placeable_by = nil -- is it right?
			end

			local minable = entity.minable
			if minable then
				if minable.result == item_name then
					minable.result = nil
					minable.count = nil
				end
				local results = minable.results
				if results and #results > 0 then
					fix_array(results)
					if #results > 0 then
						for i=#results, 1, -1 do
							local result = results[i]
							if result.name == item_name and result.type ~= "fluid" then
								tremove(results, i)
							end
						end
					end
				end
			end
		end
	end
end)


lazyAPI.remove_listener = function(action_name, name)
	local action_listeners = listeners[action_name]
	for i=#action_listeners, 1, -1 do
		local listener = action_listeners[i]
		if listener.name == name then
			tremove(action_listeners, i)
			for _, type in ipairs(listener.types) do
				local funks = subscriptions[action_name][type]
				for j=1, #funks do
					if funks[j] == listener.func then
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
lazyAPI.remove_entities_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _name, prototype in pairs(prototypes) do
			if _name == name then
				lazyAPI.base.remove_prototype(prototype)
			end
		end
	end
end


---@param name string
---@return boolean
lazyAPI.has_entities_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_entities) do
		if prototypes[name] then
			return true
		end
	end
	return false
end


---@param name string
---@return table[]
lazyAPI.find_entities_by_name = function(name)
	local result = {}
	for _, prototypes in pairs(lazyAPI.all_entities) do
		for entity_name, entity in pairs(prototypes) do
			if entity_name == name then
				result[#result+1] = entity
			end
		end
	end
	return result
end


---@param name string
lazyAPI.remove_items_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_items) do
		for item_name, item in pairs(prototypes) do
			if item_name == name then
				lazyAPI.base.remove_prototype(item)
			end
		end
	end
end


---@param name string
---@return boolean
lazyAPI.has_items_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_items) do
		for item_name in pairs(prototypes) do
			if item_name == name then
				return true
			end
		end
	end
	return false
end


---@param name string
---@return table[]
lazyAPI.find_items_by_name = function(name)
	local result = {}
	for _, prototypes in pairs(lazyAPI.all_items) do
		for item_name, item in pairs(prototypes) do
			if item_name == name then
				result[#result+1] = item
			end
		end
	end
	return result
end


---@param recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
lazyAPI.remove_recipe_from_modules = function(recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	for _, prototype in pairs(data_raw.module) do
		remove_from_array(prototype, "limitation", recipe_name)
		remove_from_array(prototype, "limitation_blacklist", recipe_name)
	end
end


-- https://wiki.factorio.com/Prototype/Module#limitation
-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param old_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@param new_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
lazyAPI.replace_recipe_in_all_modules = function(old_recipe, new_recipe)
	local old_recipe_name = (type(old_recipe) == "string" and old_recipe) or old_recipe.name
	local new_recipe_name = (type(new_recipe) == "string" and new_recipe) or new_recipe.name
	replace_in_prototypes(modules, "limitation", old_recipe_name, new_recipe_name)
	replace_in_prototypes(modules, "limitation_blacklist", old_recipe_name, new_recipe_name)
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
			action = {{
				-- runs the script when projectile lands:
				type = "direct",
				action_delivery = {{
					type = "instant",
					target_effects = {
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
						action = {{
							type = "direct",
							action_delivery = {{
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

	return data_raw.capsule[name], data_raw.projectile[name]
end


---@param name string
---@param max_level integer?
---@param tech_data table
---@return table tech, table[]
lazyAPI.create_techs = function(name, max_level, tech_data)
	local main_tech = {
    type = "technology",
    name = name,
		icon = tech_data.icon,
    icon_size = tech_data.icon_size, icon_mipmaps = icon_mipmaps.icon_size,
    icons = tech_data.icons and deepcopy(tech_data.icons),
    effects = (tech_data.effects and deepcopy(tech_data.effects)) or {},
    prerequisites = (tech_data.prerequisites and deepcopy(tech_data.prerequisites)) or {},
    unit = (tech_data.unit and deepcopy(tech_data.unit)) or {},
    upgrade = tech_data.upgrade,
    order = tech_data.order
  }
	local techs = {main_tech}
	if max_level and max_level > 1 then
		for i=1, max_level do
			local prerequisites = (tech_data.prerequisites and deepcopy(tech_data.prerequisites)) or {}
			if i > 2 then
				prerequisites[#prerequisites+1] = name .. "-" .. (i - 1)
			else
				prerequisites[#prerequisites+1] = name
			end
			local tech = {
				type = "technology",
				name = name .. "-" .. i,
				icon = tech_data.icon,
				icon_size = tech_data.icon_size, icon_mipmaps = icon_mipmaps.icon_size,
				icons = tech_data.icons and deepcopy(tech_data.icons),
				effects = (tech_data.effects and deepcopy(tech_data.effects)) or {},
				prerequisites = prerequisites,
				unit = (tech_data.unit and deepcopy(tech_data.unit)) or {},
				upgrade = tech_data.upgrade,
				order = tech_data.order
			}
			techs[#techs+1] = tech
		end
	end
	data:extend(techs)

	return main_tech, techs
end


local custom_input = data_raw["custom-input"]
-- Extends game interactions, see https://wiki.factorio.com/Prototype/CustomInput#linked_game_control
---@return table CustomInput
lazyAPI.attach_custom_input_event = function(name)
	local new_name = name .. "-event"
	if custom_input[new_name] then
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


---@param frame_count? integer #1 by default
---@return table #https://wiki.factorio.com/Types/Sprite
function lazyAPI.make_empty_sprite(frame_count)
	return {
		filename = "__core__/graphics/empty.png",
		size = 1, frame_count = frame_count or 1
	}
end


---@return table #https://wiki.factorio.com/Types/SpriteVariations
function lazyAPI.make_empty_sprites()
	return {{
		filename = "__core__/graphics/empty.png",
		height = 1, width = 1
	}}
end


---@param item_name string
lazyAPI.remove_item_ingredient_everywhere = function(item_name)
	for _, recipe in pairs(recipes) do
		lazyAPI.recipe.remove_ingredient_everywhere(recipe, item_name, "item")
	end
end


---@param entity string|table #https://wiki.factorio.com/Prototype/Entity or its name
lazyAPI.remove_items_by_entity = function(entity)
	local entity_name = (type(entity) == "string" and entity) or entity.name
	for _, prototypes in pairs(lazyAPI.all_items) do
		for _, item in pairs(prototypes) do
			if item.place_result == entity_name then
				lazyAPI.base.remove_prototype(item)
			end
		end
	end
end


---@param entity string|table #https://wiki.factorio.com/Prototype/Entity or its name
---@param new_entity string|table #https://wiki.factorio.com/Prototype/Entity or its name
lazyAPI.replace_items_by_entity = function(entity, new_entity)
	local entity_name = (type(entity) == "string" and entity) or entity.name
	local new_entity_name = (type(new_entity) == "string" and new_entity) or new_entity.name
	for _, prototypes in pairs(lazyAPI.all_items) do
		for _, item in pairs(prototypes) do
			if item.place_result == entity_name then
				item.place_result = new_entity_name
			end
		end
	end
end


---@param tile string|table #https://wiki.factorio.com/Prototype/Entity or its name
lazyAPI.remove_items_by_tile = function(tile)
	local tile_name = (type(tile) == "string" and tile) or tile.name
	for _, prototypes in pairs(lazyAPI.all_items) do --TODO: recheck, seems excessive
		for _, item in pairs(prototypes) do
			local place_as_tile = item.place_as_tile
			if place_as_tile and place_as_tile.result == tile_name then
				lazyAPI.base.remove_prototype(item)
			end
		end
	end
end


---@param tile string|table #https://wiki.factorio.com/Prototype/Entity or its name
---@param new_tile string|table #https://wiki.factorio.com/Prototype/Entity or its name
lazyAPI.replace_items_by_tile = function(tile, new_tile)
	local tile_name = (type(tile) == "string" and tile) or tile.name
	local new_tile_name = (type(new_tile) == "string" and new_tile) or new_tile.name
	for _, prototypes in pairs(lazyAPI.all_items) do --TODO: recheck, seems excessive
		for _, item in pairs(prototypes) do
			local place_as_tile = item.place_as_tile
			if place_as_tile and place_as_tile.result == tile_name then
				place_as_tile.result = new_tile_name
			end
		end
	end
end


---@param equipment string|table #https://wiki.factorio.com/Prototype/Equipment or its name
lazyAPI.remove_items_by_equipment = function(equipment)
	local equipment_name = (type(equipment) == "string" and equipment) or equipment.name
	for _, prototypes in pairs(lazyAPI.all_items) do --TODO: recheck, seems excessive
		for _, item in pairs(prototypes) do
			if item.placed_as_equipment_result == equipment_name then
				lazyAPI.base.remove_prototype(item)
			end
		end
	end
end


---@param item string|table #https://wiki.factorio.com/Prototype/Item or its name
---@return boolean
lazyAPI.remove_equipment_by_item = function(item)
	local item_name = (type(item) == "string" and item) or item.name
	for _, prototypes in pairs(lazyAPI.all_equipments) do
		local equipment = prototypes[item_name]
		if equipment then
			lazyAPI.base.remove_prototype(equipment)
			return true
		end
	end
	return false
end


---@param equipment string|table #https://wiki.factorio.com/Prototype/Entity or its name
---@param new_equipment string|table #https://wiki.factorio.com/Prototype/Entity or its name
lazyAPI.replace_items_by_equipment = function(equipment, new_equipment)
	local equipment_name = (type(equipment) == "string" and equipment) or equipment.name
	local new_equipment_name = (type(new_equipment) == "string" and new_equipment) or new_equipment.name
	for _, prototypes in pairs(lazyAPI.all_items) do --TODO: recheck, seems excessive
		for _, item in pairs(prototypes) do
			if item.placed_as_equipment_result == equipment_name then
				item.placed_as_equipment_result = new_equipment_name
			end
		end
	end
end


---@param fluid string|table
lazyAPI.remove_recipes_by_fluid = function(fluid)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	for _, recipe in pairs(recipes) do
		if recipe.main_product == fluid_name then
			lazyAPI.base.remove_prototype(recipe)
		else
			lazyAPI.recipe.remove_ingredient_everywhere(recipe, fluid_name, "fluid")
			lazyAPI.recipe.remove_fluid_from_result_everywhere(recipe, fluid_name)
			lazyAPI.recipe.remove_if_empty_result(recipe)
		end
	end
end


---@param item string|table
lazyAPI.remove_recipes_by_item = function(item)
	local item_name = (type(item) == "string" and item) or item.name
	for _, recipe in pairs(recipes) do
		if recipe.main_product == item_name then
			lazyAPI.base.remove_prototype(recipe)
		else
			lazyAPI.recipe.remove_ingredient_everywhere(recipe, item_name, "item")
			lazyAPI.recipe.remove_item_from_result_everywhere(recipe, item_name)
			lazyAPI.recipe.remove_if_empty_result(recipe)
		end
	end
end


---@param item string|table
lazyAPI.remove_loot_everywhere = function(item)
	for _, prototypes in pairs(lazyAPI.entities_with_health) do
		for _, prototype in pairs(prototypes) do
			lazyAPI.loot.remove(prototype, item)
		end
	end
end

---@param item string|table
lazyAPI.replace_loot_everywhere = function(item, new_item)
	for _, prototypes in pairs(lazyAPI.entities_with_health) do
		for _, prototype in pairs(prototypes) do
			lazyAPI.loot.replace(prototype, item, new_item)
		end
	end
end


-- https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param old_tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param new_tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
lazyAPI.replace_prerequisite_in_all_techs = function(old_tech, new_tech)
	local old_tech_name = (type(old_tech) == "string" and old_tech) or old_tech.name
	local new_tech_name = (type(new_tech) == "string" and new_tech) or new_tech.name
	replace_in_prototypes(technologies, "prerequisites", old_tech_name, new_tech_name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param old_resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
---@param new_resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
lazyAPI.replace_resource_category_in_all_mining_drills = function(old_resource_category, new_resource_category)
	local old_resource_category_name = (type(old_resource_category) == "string" and old_resource_category) or old_resource_category.name
	local new_resource_category_name = (type(new_resource_category) == "string" and new_resource_category) or new_resource_category.name
	replace_in_prototype(mining_drills, "resource_categories", old_resource_category_name, new_resource_category_name)
end


-- Not fully tested
---@param _type string
---@param name string
---@return boolean
lazyAPI.can_i_create = function(_type, name)
	if data_raw[_type][name] then
		return false
	end

	local is_entity = lazyAPI.all_entities[_type]
	if is_entity then
		return not lazyAPI.has_entities_by_name(name)
	end

	local is_item = lazyAPI.all_items[_type]
	if is_item then
		for _, prototypes in pairs(lazyAPI.all_items) do
			if prototypes[name] then
				return false
			end
		end
		return true
	end

	local is_equipment = lazyAPI.all_equipments[_type]
	if is_equipment then
		for _, prototypes in pairs(lazyAPI.all_equipments) do
			if prototypes[name] then
				return false
			end
		end
		return true
	end

	local is_achievement = lazyAPI.all_achievements[_type]
	if is_achievement then
		for _, prototypes in pairs(lazyAPI.all_achievements) do
			if prototypes[name] then
				return false
			end
		end
		return true
	end

	return true
end


---@param fluid_name string
lazyAPI.remove_fluid = function(fluid_name)
	lazyAPI.remove_recipes_by_fluid(fluid_name)

	for _, resource in pairs(data_raw.resource) do
		local minable = resource.minable
		if minable then
			if minable.required_fluid == fluid_name then
				minable.required_fluid = nil
			end
			local results = minable.results
			if results then
				fix_array(results)
				for i=#results, 1, -1 do
					local result = results[i]
					if result.type == "fluid" and result.name == fluid_name then
						tremove(results, i)
					end
				end
			end
		end
	end

	for _, generator in pairs(data_raw.generator) do
		if generator.fluid_box and generator.fluid_box.filter == fluid_name then
			lazyAPI.base.remove_prototype(generator)
		end
	end

	for _, boiler in pairs(data_raw.boiler) do
		if boiler.fluid_box and boiler.fluid_box.filter == fluid_name then
			lazyAPI.base.remove_prototype(boiler)
		end
		if boiler.output_fluid_box and boiler.output_fluid_box.filter == fluid_name then
			boiler.output_fluid_box.filter = nil
		end
	end

	for _, pump in pairs(data_raw["offshore-pump"]) do
		if pump.fluid == fluid_name then
			lazyAPI.base.remove_prototype(pump)
		else
			if pump.fluid_box and pump.fluid_box.filter == fluid_name then
				pump.fluid_box.filter = nil
			end
		end
	end

	for _, turret in pairs(data_raw["fluid-turret"]) do
		local attack_parameters = turret.attack_parameters
		if attack_parameters then
			local fluids = attack_parameters.fluids
			fix_array(fluids)
			for i=#fluids, 1, -1 do
				if fluids[i].type == fluid_name then
					tremove(fluids, i)
				end
			end
		end
	end
end


---@param tool string|table
lazyAPI.remove_tool_everywhere = function(tool)
	local tool_name = (type(tool) == "string" and tool) or tool.name
	for _, lab in pairs(data_raw["lab"]) do
		remove_from_array(lab, "inputs", tool_name)
	end

	for _, techonology in pairs(technologies) do
		local unit = techonology.unit
		if unit then
			local ingredients = unit.ingredients
			if ingredients then
				fix_array(ingredients)
				for i=#ingredients, 1, -1 do
					if ingredients[i][1] == tool_name then
						tremove(ingredients, i)
					end
				end
			end
		end
	end
end


---@param prev_tool string|table
---@param new_tool string|table
lazyAPI.rename_tool = function(prev_tool, new_tool)
	local prev_name = (type(prev_tool) == "string" and prev_tool) or prev_tool.name
	local new_name = (type(new_tool) == "string" and new_tool) or new_tool.name
	for _, lab in pairs(data_raw["lab"]) do
		rename_in_array(lab, "inputs", prev_name, new_name)
	end

	for _, techonology in pairs(technologies) do
		local unit = techonology.unit
		if unit then
			local ingredients = unit.ingredients
			if ingredients then
				fix_array(ingredients)
				for i=#ingredients, 1, -1 do
					local ingredient = ingredients[i]
					if ingredient[1] == prev_name then
						ingredient[1] = prev_name
					end
				end
			end
		end
	end
end


---@param tile_name string
lazyAPI.remove_tile = function(tile_name)
	lazyAPI.remove_items_by_tile(tile_name)

	for _, decorative in pairs(data_raw["optimized-decorative"]) do
		remove_from_array(decorative.autoplace, "tile_restriction", tile_name)
	end

	for _, fire in pairs(data_raw.fire) do
		local burnt_patch_alpha_variations = fire.burnt_patch_alpha_variations
		if burnt_patch_alpha_variations then
			fix_array(burnt_patch_alpha_variations)
			for i=#burnt_patch_alpha_variations, 1, -1 do
				if burnt_patch_alpha_variations[i].tile == tile_name then
					tremove(burnt_patch_alpha_variations, i)
				end
			end
		end
	end

	for _, tile in pairs(data_raw.tile) do
		remove_from_array(tile, "allowed_neighbors", tile_name)
		if tile.transition_merges_with_tile == tile_name then
			tile.transition_merges_with_tile = nil
		end
		if tile.next_direction == tile_name then
			tile.next_direction = nil
		end
		local transitions = tile.transitions
		if transitions then
			for _, transition in pairs(transitions) do
				remove_from_array(transition, "to_tiles", tile_name)
			end
		end
	end

	for _, character in pairs(data_raw.character) do
		local footprint_particles = character.footprint_particles
		if footprint_particles then
			fix_array(footprint_particles)
			for i=#footprint_particles, 1, -1 do
				remove_from_array(footprint_particles[i], "tiles", tile_name)
			end
		end
		local synced_footstep_particle_triggers = character.synced_footstep_particle_triggers
		if synced_footstep_particle_triggers then
			fix_array(synced_footstep_particle_triggers)
			for i=#synced_footstep_particle_triggers, 1, -1 do
				remove_from_array(synced_footstep_particle_triggers[i], "tiles", tile_name)
			end
		end
	end

	for _, car in pairs(data_raw.car) do
		local track_particle_triggers = car.track_particle_triggers
		if track_particle_triggers then
			fix_array(track_particle_triggers)
			for i=#track_particle_triggers, 1, -1 do
				remove_from_array(track_particle_triggers[i], "tiles", tile_name)
			end
		end
	end

	for _, projectile in pairs(data_raw.projectile) do
		local actions = projectile.action
		if actions then
			if type(next(actions)) == "number" then
				for i=#actions, 1, -1 do
					remove_tile_from_action(actions[i], tile_name)
				end
			else
				remove_tile_from_action(actions, tile_name)
			end
		end
		local final_actions = projectile.final_action
		if final_actions then
			if type(next(final_actions)) == "number" then
				for i=#final_actions, 1, -1 do
					remove_tile_from_action(final_actions[i], tile_name)
				end
			else
				remove_tile_from_action(final_actions, tile_name)
			end
		end
	end
end


-- Checks its existence in data.raw by name and type
---@param prototype table
---@return boolean
lazyAPI.base.does_exist = function(prototype)
	return (data_raw[prototype.type][prototype.name] ~= nil)
end


---@param prototype table
---@param field_name string
---@return any
lazyAPI.base.get_field = function(prototype, field_name)
	return (prototype.prototype or prototype)[field_name]
end


---@param prototype table
---@param new_name string
---@return table prototype
lazyAPI.base.rename = function(prototype, new_name)
	local prot = prototype.prototype or prototype
	local prototype_type = prot.type
	local prev_name = prot.name

	data_raw[prototype_type][prev_name] = nil
	add_prototypes(data, {prot})

	prot.name = new_name
	if subscriptions.rename_prototype[prototype_type] then
		for _, func in pairs(subscriptions.rename_prototype[prototype_type]) do
			func(prot, prev_name, new_name, prototype_type)
		end
	end
	if subscriptions.rename_prototype.all then
		for _, func in pairs(subscriptions.rename_prototype.all) do
			func(prot, prev_name, new_name, prototype_type)
		end
	end

	return prot
end
lazyAPI.base.rename_prototype = lazyAPI.base.rename


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
---@overload fun()
lazyAPI.base.remove_prototype = function(prototype)
	if prototype == nil then return end
	local prot = prototype.prototype or prototype
	local name = prot.name
	local prototype_type = prot.type
	if data_raw[prototype_type][name] == nil then
		return prototype
	end

	if subscriptions.pre_remove_prototype[prototype_type] then
		for _, func in pairs(subscriptions.pre_remove_prototype[prototype_type]) do
			func(prot, name, prototype_type)
		end
	end
	if subscriptions.pre_remove_prototype.all then
		for _, func in pairs(subscriptions.pre_remove_prototype.all) do
			func(prot, name, prototype_type)
		end
	end
	data_raw[prototype_type][name] = nil
	if subscriptions.remove_prototype[prototype_type] then
		for _, func in pairs(subscriptions.remove_prototype[prototype_type]) do
			func(prot, name, prototype_type)
		end
	end
	if subscriptions.remove_prototype.all then
		for _, func in pairs(subscriptions.remove_prototype.all) do
			func(prot, name, prototype_type)
		end
	end
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
---@param percent float
---@param decrease? float
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
---@param type string
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


-- Perhaps, not reliable
---@param prototype table
---@preturn boolean
lazyAPI.ingredients.have_ingredients = function(prototype)
	local prot = prototype.prototype or prototype
	if prot.ingredients and next(prot.ingredients) then
		return true
	end
	local normal = prot.normal
	if normal and (normal.ingredients and next(normal.ingredients)) then
		return true
	end
	local expensive = prot.expensive
	if expensive and (expensive.ingredients and next(expensive.ingredients)) then
		return true
	end

	return false
end


---@param prototype table
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table ItemIngredientPrototype #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.ingredients.add_item_ingredient = function(prototype, item, amount, difficulty)
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

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == item_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		elseif ingredient.type == "item" and ingredient.name == item_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	local ingredient = {item_name, amount}
	ingredients[#ingredients+1] = {item_name, amount}
	return ingredient
end


---@param prototype table
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table FluidIngredientPrototype #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.ingredients.add_fluid_ingredient = function(prototype, fluid, amount, difficulty)
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

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type == "fluid" and ingredient.name == fluid_name then
			ingredient[2] = ingredient[2] + amount
			return ingredient
		end
	end

	local ingredient = {type = "fluid", name = fluid_name, amount = amount}
	ingredients[#ingredients+1] = ingredient
	return ingredient
end


---@param prototype table
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table IngredientPrototype #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.add_ingredient = function(prototype, target, amount, difficulty)
	local _type = target.type
	if _type == "fluid" then
		return lazyAPI.ingredients.add_fluid_ingredient(prototype, target.name, amount, difficulty)
	else --item
		return lazyAPI.ingredients.add_item_ingredient(prototype, target.name, amount, difficulty)
	end
end


---@param prototype table
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.ingredients.set_item_ingredient = function(prototype, item, amount, difficulty)
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
			ingredients = prot.ingredients
		end
	end

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient[1] == item_name then
			ingredient[2] = amount
			return prototype
		elseif ingredient.type == "item" and ingredient.name == item_name then
			ingredient[2] = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {item_name, amount}
	return prototype
end


---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.ingredients.set_fluid_ingredient = function(prototype, fluid, amount, difficulty)
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
			ingredients = prot.ingredients
		end
	end

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type == "fluid" and ingredient.name == fluid_name then
			ingredient[2] = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {type = "fluid", name = fluid_name, amount = amount}
	return prototype
end


---@param prototype table
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.ingredients.set_ingredient = function(prototype, target, amount, difficulty)
	local _type = target.type
	if _type == "fluid" then
		return lazyAPI.recipe.set_item_ingredient(prototype, target.name, amount, difficulty)
	else -- item
		return lazyAPI.recipe.set_fluid_ingredient(prototype, target.name, amount, difficulty)
	end
end


---@param prototype table
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param difficulty? difficulty
---@return table[] #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.ingredients.get_item_ingredients = function(prototype, item, difficulty)
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			return {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
	end
	if ingredients == nil then
		return {}
	end

	local fluid_name = (type(item) == "string" and item) or item.name
	local result = {}
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if result[1] == item_name then
			result[#result+1] = ingredient
		elseif ingredient.type ~= "fluid" and ingredient.name == fluid_name then
			result[#result+1] = ingredient
		end
	end

	return result
end


---@param prototype table
---@param fluid string #https://wiki.factorio.com/Prototype/Fluid#name
---@param difficulty? difficulty
---@return table[] #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.ingredients.get_fluid_ingredients = function(prototype, fluid, difficulty)
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then
			return {}
		end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
	end
	if ingredients == nil then
		return {}
	end

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	local result = {}
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type == "fluid" and ingredient.name == fluid_name then
			result[#result+1] = ingredient
		end
	end

	return result
end


---@param prototype table
---@param ingredient string|table
---@param _type? ingredient_type #"item" by default
---@param difficulty? difficulty
---@return table? IngredientPrototype #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.remove_ingredient = function(prototype, ingredient, _type, difficulty)
	_type = _type or "item"
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

	local ingredient_name = (type(ingredient) == "string" and ingredient) or ingredient.name
	fix_array(ingredients)
	if _type == "fluid" then
		for i=#ingredients, 1, -1 do
			local _ingredient = ingredients[i]
			if _ingredient.type == "fluid" and _ingredient.name == ingredient_name then
				return tremove(ingredients, i)
			end
		end
	else -- item
		for i=#ingredients, 1, -1 do
			local _ingredient = ingredients[i]
			if _ingredient[1] == ingredient_name then
				return tremove(ingredients, i)
			elseif _ingredient.type == "item" and _ingredient.name == ingredient_name then
				return tremove(ingredients, i)
			end
		end
	end
end


---@param prototype table
---@param ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table prototype
lazyAPI.ingredients.remove_ingredient_everywhere = function(prototype, ingredient, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	local ingredient_name = (type(ingredient) == "string" and ingredient) or ingredient.name
	if prot.ingredients then
		lazyAPI.ingredients.remove_ingredient(prot, ingredient_name, _type)
	end
	if prot.normal then
		lazyAPI.ingredients.remove_ingredient(prot, ingredient_name, _type, "normal")
	end
	if prot.expensive then
		lazyAPI.ingredients.remove_ingredient(prot, ingredient_name, _type, "expensive")
	end
	return prototype
end


---@param prototype table
---@param old_ingredient string|table
---@param new_ingredient string|table
---@param _type? ingredient_type #"item" by default
---@param difficulty? difficulty
---@return table prototype
lazyAPI.ingredients.replace_ingredient = function(prototype, old_ingredient, new_ingredient, _type, difficulty)
	_type = _type or "item"
	local ingredients
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		ingredients = prot[difficulty].ingredients
	else
		ingredients = prot.ingredients
	end
	if ingredients == nil then
		return prototype
	end

	local old_ingredient_name = (type(old_ingredient) == "string" and old_ingredient) or old_ingredient.name
	local new_ingredient_name = (type(new_ingredient) == "string" and new_ingredient) or new_ingredient.name
	fix_array(ingredients)
	if _type == "fluid" then
		for i=#ingredients, 1, -1 do
			local ingredient = ingredients[i]
			if ingredient.type == "fluid" and ingredient.name == old_ingredient_name then
				ingredient.name = new_ingredient_name
			end
		end
	else -- item
		for i=#ingredients, 1, -1 do
			local ingredient = ingredients[i]
			if ingredient[1] == old_ingredient_name then
				ingredient[1] = new_ingredient_name
			elseif ingredient.type == "item" and ingredient.name == old_ingredient_name then
				ingredient.name = new_ingredient_name
			end
		end
	end
	return prototype
end


---@param prototype table
---@param old_ingredient string|table
---@param new_ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table prototype
lazyAPI.ingredients.replace_ingredient_everywhere = function(prototype, old_ingredient, new_ingredient, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type)
	if prot.normal then
		lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type, "normal")
	end
	if prot.expensive then
		lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type, "expensive")
	end
	return prototype
end


-- Perhaps, it's not a good idea to use it
---@param prototype table
---@param ingredient string|table
---@param difficulty? difficulty
---@return table? IngredientPrototype #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.find_ingredient_by_name = function(prototype, ingredient, difficulty)
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

	local ingredient_name = (type(ingredient) == "string" and ingredient) or ingredient.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local _ingredient = ingredients[i]
		if _ingredient[1] == ingredient_name or _ingredient.name == ingredient_name then
			return _ingredient
		end
	end
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
---@param prototype table
---@param item string|table
---@return table? #https://wiki.factorio.com/Types/Loot
lazyAPI.loot.find = function(prototype, item)
	local prot = prototype.prototype or prototype
	local loot = prot.loot
	if loot == nil then
		return
	end

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(loot)
	for i=1, #loot do
		local iLoot = loot[i]
		if iLoot.item == item_name then
			return iLoot
		end
	end
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
-- https://wiki.factorio.com/Types/Loot
---@param prototype table
---@param item string|table
---@param new_item string|table
---@return table prototype
lazyAPI.loot.replace = function(prototype, item, new_item)
	local prot = prototype.prototype or prototype
	local loot = prot.loot
	if loot == nil then
		return prototype
	end

	local item_name = (type(item) == "string" and item) or item.name
	local new_item_name = (type(new_item) == "string" and new_item) or new_item.name
	fix_array(loot)
	for i=1, #loot do
		local iLoot = loot[i]
		if iLoot.item == item_name then
			iLoot.item = new_item_name
		end
	end
	return prototype
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
-- https://wiki.factorio.com/Types/Loot
---@param prototype table
---@param item string|table
---@param count_min? integer
---@param count_max? integer
---@param probability? float
---@return table prototype
lazyAPI.loot.set = function(prototype, item, count_min, count_max, probability)
	local prot = prototype.prototype or prototype
	local item_name = (type(item) == "string" and item) or item.name
	local loot = prot.loot
	if loot == nil then
		prot.loot = {{item = item_name, count_min = count_min, count_max = count_max, probability = probability}}
		return prototype
	end

	fix_array(loot)
	for i=1, #loot do
		local iLoot = loot[i]
		if iLoot.item == item_name then
			iLoot.count_min = count_min
			iLoot.count_max = count_max
			iLoot.probability = probability
			return prototype
		end
	end

	loot[#loot+1] = {item = item_name, count_min = count_min, count_max = count_max, probability = probability}
	return prototype
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
---@param prototype table
---@param item string|table
---@return table prototype
lazyAPI.loot.remove = function(prototype, item)
	local prot = prototype.prototype or prototype
	local loot = prot.loot
	if loot == nil then
		return prototype
	end

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(loot)
	for i=#loot, 1, -1 do
		local iLoot = loot[i]
		if iLoot.item == item_name then
			tremove(loot, i)
		end
	end
	return prototype
end


---@param entity string|table
---@return boolean
lazyAPI.entity.has_item = function(entity)
	local item_name = (type(entity) == "string" and entity) or entity.name
	for _, prototypes in pairs(data_raw.item) do
		if prototypes[item_name] then
			return true
		end
	end
	return false
end


lazyAPI.EntityWithHealth.find_resistance = lazyAPI.resistance.find
lazyAPI.EntityWithHealth.set_resistance = lazyAPI.resistance.set
lazyAPI.EntityWithHealth.remove_resistance = lazyAPI.resistance.find
lazyAPI.EntityWithHealth.find_loot = lazyAPI.loot.find
lazyAPI.EntityWithHealth.replace_loot = lazyAPI.loot.replace
lazyAPI.EntityWithHealth.set_loot = lazyAPI.loot.set
lazyAPI.EntityWithHealth.remove_loot = lazyAPI.loot.remove


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
---@return integer? # index of the flag in prototype.flags
lazyAPI.flags.find_flag = function(prototype, flag)
	return find_in_array(prototype, "flags", flag)
end


lazyAPI.recipe.have_ingredients = lazyAPI.ingredients.have_ingredients
lazyAPI.recipe.add_item_ingredient = lazyAPI.ingredients.add_item_ingredient
lazyAPI.recipe.add_fluid_ingredient = lazyAPI.ingredients.add_fluid_ingredient
lazyAPI.recipe.add_ingredient = lazyAPI.ingredients.add_ingredient
lazyAPI.recipe.set_item_ingredient = lazyAPI.ingredients.set_item_ingredient
lazyAPI.recipe.set_fluid_ingredient = lazyAPI.ingredients.set_fluid_ingredient
lazyAPI.recipe.set_ingredient = lazyAPI.ingredients.set_ingredient
lazyAPI.recipe.get_item_ingredients = lazyAPI.ingredients.get_item_ingredients
lazyAPI.recipe.get_fluid_ingredients = lazyAPI.ingredients.get_fluid_ingredients
lazyAPI.recipe.remove_ingredient = lazyAPI.ingredients.remove_ingredient
lazyAPI.recipe.remove_ingredient_everywhere = lazyAPI.ingredients.remove_ingredient_everywhere
lazyAPI.recipe.replace_ingredient = lazyAPI.ingredients.replace_ingredient
lazyAPI.recipe.replace_ingredient_everywhere = lazyAPI.ingredients.replace_ingredient_everywhere
lazyAPI.recipe.find_ingredient_by_name = lazyAPI.ingredients.find_ingredient_by_name


---@param prototype table
---@param subgroup string
---@param order? string
---@return table prototype
lazyAPI.recipe.set_subgroup = function(prototype, subgroup, order)
	local target_name = (prototype.prototype or prototype).name
	for _, prototypes in pairs(data_raw) do
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


---@param item_product table
---@param product_type? product_type
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table ProductPrototype #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.product.make_product_prototype = function(item_product, product_type, show_details_in_recipe_tooltip)
	if item_product.amount_min == nil or item_product.amount_max == nil then
		item_product.amount_min = nil
		item_product.amount_max = nil
		item_product.amount = item_product.amount or 1
	end
	return {
		item = ItemProduct.item, type = product_type or ItemProduct.type or "item",
		show_details_in_recipe_tooltip = show_details_in_recipe_tooltip,
		amount_min = ItemProduct.amount_min, amount_max = ItemProduct.amount_max,
		amount = ItemProduct.amount,
		probability = ItemProduct.probability,
		catalyst_amount = ItemProduct.catalyst_amount
	}
end
local make_product_prototype = lazyAPI.product.make_product_prototype


---@param item_product table
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table ItemProductPrototype #https://wiki.factorio.com/Types/ItemProductPrototype
lazyAPI.product.make_item_product_prototype = function(item_product, show_details_in_recipe_tooltip)
	return lazyAPI.product.make_product_prototype(item_product, "item", show_details_in_recipe_tooltip)
end
local make_item_product_prototype = lazyAPI.product.make_item_product_prototype


---@param fluid_product table
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table FluidProductPrototype #https://wiki.factorio.com/Types/FluidProductPrototype
lazyAPI.product.make_fluid_product_prototype = function(fluid_product, show_details_in_recipe_tooltip)
	return lazyAPI.product.make_product_prototype(fluid_product, "fluid", show_details_in_recipe_tooltip)
end
local make_fluid_product_prototype = lazyAPI.product.make_fluid_product_prototype


-- Perhaps, not reliable
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@return boolean
lazyAPI.recipe.has_result = function(prototype)
	local prot = prototype.prototype or prototype
	if (prot.results and next(prot.results)) or prot.result then
		return true
	elseif prot.normal and ((prot.normal.results and next(prot.normal.results)) or prot.normal.result) then
		return true
	elseif prot.expensive and ((prot.expensive.results and next(prot.expensive.results)) or prot.expensive.result) then
		return true
	end
	return false
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.add_item_in_result = function(prototype, item, item_product, difficulty)
	if item == nil then error("item is nil") end
	local results
	local prot = prototype.prototype or prototype
	if (item_product.amount_min == nil or item_product.amount_max == nil)
		and item_product.amount and item_product.amount > 65535
	then
		item_product.amount = item_product.amount - 65535
		lazyAPI.recipe.add_item_in_result(prot, item, item_product, difficulty)
		if item_product.amount <= 0 then return prototype end
	end
	item_product.item = (type(item_product.item) == "string" and item_product.item) or item_product.item.name
	local is_simple_data = (next(item_product, next(item_product)) == nil) -- Improve
	if difficulty then
		if prot[difficulty] == nil then
			if is_simple_data then
				prot[difficulty].results = {{item, item_product.amount or 1}}
			else
				prot[difficulty].results = {make_product_prototype(item_product)}
			end
			results = prot[difficulty].results
			if prot[difficulty].result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot[difficulty].result = nil
				prot[difficulty].result_count = nil
			else
			end
			return prototype
		end
		results = prot[difficulty].results
	else
		results = prot.results
		if results == nil then
			if is_simple_data then
				prot.results = {{item, item_product.amount or 1}}
			else
				prot.results = {make_product_prototype(item_product)}
			end
			results = prot.results
			if prot.result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot.result = nil
				prot.result_count = nil
			end
			return prototype
		end
	end

	fix_array(results)
	if is_simple_data then
		results[#results+1] = {item, item_product.amount or 1}
	else
		results[#results+1] = make_product_prototype(item_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.add_fluid_in_result = function(prototype, fluid, fluid_product, difficulty)
	if fluid == nil then error("item is nil") end
	local results
	local prot = prototype.prototype or prototype
	if (fluid_product.amount_min == nil or fluid_product.amount_max == nil)
		and fluid_product.amount and fluid_product.amount > 65535
	then
		fluid_product.amount = fluid_product.amount - 65535
		lazyAPI.recipe.add_fluid_in_result(prot, fluid, fluid_product, difficulty)
		if fluid_product.amount <= 0 then return prototype end
	end
	fluid_product.item = (type(fluid_product.item) == "string" and fluid_product.item) or fluid_product.item.name
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty].results = {make_fluid_product_prototype(fluid_product)}
			results = prot[difficulty].results
			if prot[difficulty].result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot[difficulty].result = nil
				prot[difficulty].result_count = nil
			end
			return prototype
		end
		results = prot[difficulty].results
	else
		results = prot.results
		if results == nil then
			prot.results = {make_fluid_product_prototype(fluid_product)}
			results = prot.results
			if prot.result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot.result = nil
				prot.result_count = nil
			end
			return prototype
		end
	end

	fix_array(results)
	results[#results+1] = make_fluid_product_prototype(fluid_product)
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table #https://wiki.factorio.com/Types/ProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.add_product_in_result = function(prototype, product, product_prototype, difficulty)
	if product.type == "fluid" then
		lazyAPI.recipe.add_fluid_in_result(prototype, product, product_prototype, difficulty)
	else
		lazyAPI.recipe.add_item_in_result(prototype, product, product_prototype, difficulty)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_item_in_result = function(prototype, item, item_product, difficulty)
	if item == nil then error("item is nil") end
	local results
	local prot = prototype.prototype or prototype
	item_product.item = (type(item_product.item) == "string" and item_product.item) or item_product.item.name
	local is_simple_data = (next(item_product, next(item_product)) == nil) -- Improve
	if difficulty then
		if prot[difficulty] == nil then
			if is_simple_data then
				prot[difficulty].results = {{item, item_product.amount or 1}}
			else
				prot[difficulty].results = {make_product_prototype(item_product)}
			end
			results = prot[difficulty].results
			if prot[difficulty].result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot[difficulty].result = nil
				prot[difficulty].result_count = nil
			else
			end
			return prototype
		end
		results = prot[difficulty].results
	else
		results = prot.results
		if results == nil then
			if is_simple_data then
				prot.results = {{item, item_product.amount or 1}}
			else
				prot.results = {make_product_prototype(item_product)}
			end
			results = prot.results
			if prot.result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot.result = nil
				prot.result_count = nil
			end
			return prototype
		end
	end

	lazyAPI.recipe.remove_item_from_result(prot, item, difficulty)
	fix_array(results)
	if is_simple_data then
		results[#results+1] = {item, item_product.amount or 1}
	else
		results[#results+1] = make_product_prototype(item_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_fluid_in_result = function(prototype, fluid, fluid_product, difficulty)
	if fluid == nil then error("item is nil") end
	local results
	local prot = prototype.prototype or prototype
	fluid_product.item = (type(fluid_product.item) == "string" and fluid_product.item) or fluid_product.item.name
	if difficulty then
		if prot[difficulty] == nil then
			prot[difficulty].results = {make_fluid_product_prototype(fluid_product)}
			results = prot[difficulty].results
			if prot[difficulty].result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot[difficulty].result = nil
				prot[difficulty].result_count = nil
			end
			return prototype
		end
		results = prot[difficulty].results
	else
		results = prot.results
		if results == nil then
			prot.results = {make_fluid_product_prototype(fluid_product)}
			results = prot.results
			if prot.result then
				results[#results+1] = {prot.result, prot.result_count or 1}
				prot.result = nil
				prot.result_count = nil
			end
			return prototype
		end
	end

	lazyAPI.recipe.remove_fluid_from_result(prototype, fluid, difficulty)
	fix_array(results)
	results[#results+1] = make_fluid_product_prototype(fluid_product)
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table #https://wiki.factorio.com/Types/ProductPrototype
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.set_product_in_result = function(prototype, product, product_prototype, difficulty)
	if product.type == "fluid" then
		lazyAPI.recipe.set_fluid_in_result(prototype, product, product_prototype, difficulty)
	else
		lazyAPI.recipe.set_item_in_result(prototype, product, product_prototype, difficulty)
	end
	return prototype
end


-- THIS SEEMS WRONG
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@return table? prototype
lazyAPI.recipe.remove_if_empty_result = function(prototype)
	local prot = prototype.prototype or prototype
	if (prot.results and next(prot.results)) or prot.result then
		return prototype
	elseif prot.normal and ((prot.normal.results and next(prot.normal.results)) or prot.normal.result) then
		return prototype
	elseif prot.expensive and ((prot.expensive.results and next(prot.expensive.results)) or prot.expensive.result) then
		return prototype
	end
	lazyAPI.base.remove_prototype(prot)
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.remove_item_from_result = function(prototype, item, difficulty)
	if item == nil then error("item is nil") end
	local item_name = (type(item) == "string" and item) or item.name
	local results
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return prototype end
		results = prot[difficulty].results
	else
		results = prot.results
	end

	if difficulty then
		if prot[difficulty].result == item_name then
			prot[difficulty].result = nil
			prot[difficulty].result_count = nil
		end
	else
		if prot.result == item_name then
			prot.result = nil
			prot.result_count = nil
		end
	end
	if results == nil then
		return prototype
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result[1] == item_name then
			tremove(results, i)
		elseif result.type ~= "fluid" and result.name == item_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@return table prototype
lazyAPI.recipe.remove_item_from_result_everywhere = function(prototype, item)
	local prot = prototype.prototype or prototype
	local item_name = (type(item) == "string" and item) or item.name
	if prot.results or prot.result then -- TODO: improve
		lazyAPI.recipe.remove_item_from_result(prototype, item_name)
	end
	if prot.normal then
		lazyAPI.recipe.remove_item_from_result(prototype, item_name, "normal")
	end
	if prot.expensive then
		lazyAPI.recipe.remove_item_from_result(prototype, item_name, "expensive")
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.recipe.remove_fluid_from_result = function(prototype, fluid, difficulty)
	local results
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return prototype end
		results = prot[difficulty].results
	else
		results = prot.results
	end
	if results == nil then
		return prototype
	end

	fix_array(results)
	for i=#results, 1, -1 do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@return table prototype
lazyAPI.recipe.remove_fluid_from_result_everywhere = function(prototype, fluid)
	local prot = prototype.prototype or prototype
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	if prot.results then
		lazyAPI.recipe.remove_fluid_from_result(prototype, fluid_name)
	end
	if prot.normal then
		lazyAPI.recipe.remove_fluid_from_result(prototype, fluid_name, "normal")
	end
	if prot.expensive then
		lazyAPI.recipe.remove_fluid_from_result(prototype, fluid_name, "expensive")
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param difficulty? difficulty
---@return table|string? #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_item_in_result = function(prototype, item, difficulty)
	local results
	local item_name = (type(item) == "string" and item) or item.name
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		results = prot[difficulty].results
	else
		results = prot.results
	end
	if results == nil then
		if difficulty then
			if prot[difficulty].result == item_name then
				return prot[difficulty].result
			end
		else
			if prot.result == item_name then
				return prot.result
			end
		end
		return
	end

	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result[1] == item_name then
			return result
		elseif result.type ~= "fluid" and result.name == item_name then
			return result
		end
	end
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param difficulty? difficulty
---@return integer #amount
lazyAPI.recipe.count_item_in_result = function(prototype, item, difficulty)
	local results
	local item_name = (type(item) == "string" and item) or item.name
	local prot = prototype.prototype or prototype
	if difficulty then
		if prot[difficulty] == nil then return end
		results = prot[difficulty].results
	else
		results = prot.results
	end
	if results == nil then
		if difficulty then
			if prot[difficulty].result == item_name then
				return 1
			end
		else
			if prot.result == item_name then
				return 1
			end
		end
		return 0
	end

	fix_array(results)
	local amount = 0
	for i=1, #results do
		local result = results[i]
		if result[1] == item_name then
			amount = amount + result[2]
		elseif result.type ~= "fluid" and result.name == item_name then
			amount = amount + result["amount"]
		end
	end
	return amount
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param difficulty? difficulty
---@return table? ProductPrototype #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_fluid_in_result = function(prototype, fluid, difficulty)
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
		return
	end

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			return result
		end
	end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param difficulty? difficulty
---@return integer #amount
lazyAPI.recipe.count_fluid_in_result = function(prototype, fluid, difficulty)
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
		return
	end

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(results)
	local amount = 0
	for i=1, #results do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			amount = amount + result["amount"]
		end
	end
	return amount
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe string|table
---@return boolean
lazyAPI.module.is_recipe_allowed = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
---@param recipe string|table
---@return integer? #index from https://wiki.factorio.com/Prototype/Module#limitation
lazyAPI.module.find_allowed_recipe_index = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return find_in_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe string|table
---@return table prototype
lazyAPI.module.allow_recipe = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
---@param recipe string|table
---@return table prototype
lazyAPI.module.prohibit_recipe = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
---@param recipe string|table
---@return integer? #index from https://wiki.factorio.com/Prototype/Module#limitation_blacklist
lazyAPI.module.find_blacklisted_recipe_index = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return find_in_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table
---@param recipe string|table
---@return table prototype
lazyAPI.module.remove_allowed_recipe = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return remove_from_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param recipe string|table
---@return table prototype
lazyAPI.module.remove_blacklisted_recipe = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return remove_from_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table
---@param old_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@param new_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@return table prototype
lazyAPI.module.replace_recipe = function(prototype, old_recipe, new_recipe)
	old_tech = (type(old_tech) == "string" and old_tech) or old_tech.name
	new_tech = (type(new_tech) == "string" and new_tech) or new_tech.name

	replace_in_prototype(prototype, "limitation", old_recipe, new_recipe)
	replace_in_prototype(prototype, "limitation_blacklist", old_recipe, new_recipe)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.unlock_recipe = function(prototype, recipe, difficulty)
	local effects
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
		if effect.recipe == recipe_name and effect.type == "unlock-recipe" then
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
---@param recipe string|table
---@param difficulty? difficulty
---@return table? UnlockRecipeModifierPrototype #https://wiki.factorio.com/Types/UnlockRecipeModifierPrototype
lazyAPI.tech.find_unlock_recipe_effect = function(prototype, recipe, difficulty)
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

	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	fix_array(effects)
	for i=1, #effects do
		local effect = effects[i]
		if effect.recipe == recipe_name and effect.type == "unlock-recipe" then
			return effect
		end
	end
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.remove_unlock_recipe_effect = function(prototype, recipe, difficulty)
	local effects
	local prot = prototype.prototype or prototype
	if difficulty then
		effects = prot[difficulty] and prot[difficulty].effects
	else
		effects = prot.effects
	end
	if effects == nil then return end

	lazyAPI.tech.remove_effect(prototype, "unlock-recipe", recipe, difficulty)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@return table? prototype
lazyAPI.tech.remove_if_no_effects = function(prototype)
	local prot = prototype.prototype or prototype
	if prot.effects and next(prot.effects) then
		return prototype
	elseif prot.normal and prot.normal.effects and next(prot.normal.effects) then
		return prototype
	elseif prot.expensive and prot.expensive.effects and next(prot.expensive.effects) then
		return prototype
	end
	lazyAPI.base.remove_prototype(prot)
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param recipe string
---@return table prototype
lazyAPI.tech.remove_unlock_recipe_effect_everywhere = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	if prot.effects then
		lazyAPI.tech.remove_effect(prototype, "unlock-recipe", recipe_name)
	end
	if prot.normal then
		lazyAPI.tech.remove_effect(prototype, "unlock-recipe", recipe_name, "normal")
	end
	if prot.expensive then
		lazyAPI.tech.remove_effect(prototype, "unlock-recipe", recipe_name, "expensive")
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.add_effect = function(prototype, type, recipe, difficulty)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
		if effect.type == type and effect.recipe == recipe_name then
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
---@param recipe string|table
---@param difficulty? difficulty
---@return table? ModifierPrototype #https://wiki.factorio.com/Types/ModifierPrototype
lazyAPI.tech.find_effect = function(prototype, type, recipe, difficulty)
	local prot = prototype.prototype or prototype
	local effects
	if difficulty then
		if prot[difficulty] then
			effects = prot[difficulty].effects
		else
			return
		end
	else
		effects = prot.effects
	end
	if effects == nil then return end

	fix_array(effects)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	for i=1, #effects do
		local effect = effects[i]
		if effect.type == type and effect.recipe == recipe_name then
			return effect
		end
	end
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param effect_type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@param difficulty? difficulty
---@return table prototype
lazyAPI.tech.remove_effect = function(prototype, effect_type, recipe, difficulty)
	local prot = prototype.prototype or prototype
	local effects
	if difficulty then
		if prot[difficulty] then
			effects = prot[difficulty].effects
		else
			return prototype
		end
	else
		effects = prot.effects
	end
	if effects == nil then return prototype end

	fix_array(effects)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	for i=#effects, 1, -1 do
		local effect = effects[i]
		if effect.type == effect_type and effect.recipe == recipe_name then
			tremove(effects, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@return table prototype
lazyAPI.tech.remove_effect_everywhere = function(prototype, type, recipe)
	lazyAPI.tech.remove_effect(prototype, type, recipe)
	lazyAPI.tech.remove_effect(prototype, type, recipe, "normal")
	lazyAPI.tech.remove_effect(prototype, type, recipe, "expensive")
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
---@return integer? # index of the prerequisite in prototype.prerequisites
lazyAPI.tech.find_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	return find_in_array(prototype, "prerequisites", tech_name)
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
---@return table prototype
lazyAPI.tech.add_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	return add_to_array(prototype, "prerequisites", tech_name)
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
---@return table prototype
lazyAPI.tech.remove_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	return remove_from_array(prototype, "prerequisites", tech_name)
end


---Adds an ingredient for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table? ItemIngredientPrototype #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.tech.add_tool = function(prototype, tool, amount)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return end
	return lazyAPI.ingredients.add_item_ingredient(unit, tool, amount)
end


---Sets a tool for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table prototype
lazyAPI.tech.set_tool = function(prototype, tool, amount)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return prototype end
	lazyAPI.ingredients.set_item_ingredient(unit, tool, amount)
	return prototype
end


---Removes a tool from the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@return table? IngredientPrototype #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.tech.remove_tool = function(prototype, tool)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return prototype end
	return lazyAPI.ingredients.remove_ingredient(prototype, tool, "item")
end


---Repalces a tool in the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table #https://wiki.factorio.com/Prototype/Technology
---@param old_tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param new_tool string|table #https://wiki.factorio.com/Prototype/Tool
---@return table prototype
lazyAPI.tech.replace_tool = function(prototype, old_tool, new_tool)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return prototype end
	lazyAPI.ingredients.replace_ingredient(prototype, old_tool, new_tool, "item")
	return prototype
end


---@param tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return boolean
lazyAPI.tech.is_contiguous_tech = function(tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	if tech_name:match(".+%-(%d+)$") then
		return true
	else
		return false
	end
end


---@param tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return integer?
lazyAPI.tech.get_last_tech_level = function(tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	local pattern = strings_for_patterns[tech_name] .. "%-(%d+)$"
	local last_tech_level
	for _, technology in pairs(technologies) do
		local level = technology.name:match(pattern)
		if level then
			level = tonumber(level)
			if level > (last_tech_level or 0) then
				last_tech_level = level
			end
		end
	end
	return last_tech_level
end


-- Doesn't work with a contiguous technology.
---@param tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return integer?
lazyAPI.tech.get_last_valid_contiguous_tech_level = function(tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	local last_tech_level = lazyAPI.tech.get_last_tech_level(tech_name)
	if not last_tech_level then return end

	tech_name = tech_name .. '-'
	for i=1, last_tech_level do
		if technologies[tech_name .. i] == nil then
			if i > 1 then
				return i - 1
			end
			return
		end
	end
	return last_tech_level
end


---@param tech string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return table tech
lazyAPI.tech.remove_contiguous_techs = function(tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	local main_name, tech_level = tech_name:match("^(.+)%-(%d+)$")
	if tech_level then
		tech_level = tonumber(tech_level)
		local pattern = strings_for_patterns[main_name] .. "%-(%d+)$"
		for _, technology in pairs(technologies) do
			local level = technology.name:match(pattern)
			if level and tonumber(level) > tech_level then
				lazyAPI.base.remove_prototype(technology)
			end
		end
		return tech
	end

	local pattern = strings_for_patterns[tech_name] .. "%-(%d+)$"
	for _, technology in pairs(technologies) do
		if technology.name:match(pattern) then
			lazyAPI.base.remove_prototype(technology)
		end
	end
	return tech
end


-- https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param old_tech  string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@param new_tech  string|table #https://wiki.factorio.com/Prototype/Technology or its name
---@return table prototype
function lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech)
	local old_tech_name = (type(old_tech) == "string" and old_tech) or old_tech.name
	local new_tech_name = (type(new_tech) == "string" and new_tech) or new_tech.name

	if type(prototype) == "string" then
		local technology = technologies[prototype]
		if technology == nil then
			return prototype
		end
		replace_in_prototype(technology, "prerequisites", old_tech_name, new_tech_name)
	else
		---@cast prototype table
		local prot = prototype.prototype or prototype
		replace_in_prototype(prot, "prerequisites", old_tech_name, new_tech_name)
	end

	return prototype
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param resource_category string #https://wiki.factorio.com/Prototype/ResourceCategory
---@return integer? #index of resource_category in the resource_categories
lazyAPI.mining_drill.find_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	return find_in_array(prototype, "resource_categories", resource_category_name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
---@return table prototype
lazyAPI.mining_drill.add_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	return add_to_array(prototype, "resource_categories", resource_category_name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table
---@param resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
---@return table prototype
lazyAPI.mining_drill.remove_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	return remove_from_array(prototype, "resource_categories", resource_category_name)
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
---@param armor string|table
---@return table prototype
lazyAPI.character.remove_armor = function(prototype, armor)
	local prot = prototype.prototype or prototype
	local armor_name = (type(armor) == "string" and armor) or armor.name

	for _, corpse in pairs(data_raw["character-corpse"]) do
		local armor_picture_mapping = corpse.armor_picture_mapping
		if armor_picture_mapping then
			for _armor_name in pairs(armor_picture_mapping) do
				if _armor_name == armor_name then
					armor_picture_mapping[_armor_name] = nil
				end
			end
		end
	end

	local animations = prot.animations
	fix_array(animations)
	for i=#animations, 1, -1 do
		local animation = animations[i]
		if animation.armors then
			remove_from_array(animation, "armors", armor_name)
			if #animation.armors <= 0 then
				tremove(animations, i)
			end
		end
	end

	return prototype
end


prototype_mt = {}
prototype_mt.__index = function(self, key)
	return self.prototype[key]
end
prototype_mt.__newindex = function(self, key, value)
	if key == "name" then
		self.rename(self, value)
	else
		self.prototype[key] = value
	end
end
local wrapped_prototypes = {}
tmemoize(wrapped_prototypes, function(prototype)
	local _type = prototype.type
	if _type == nil then
		error("lazyAPI.wrap_prototype(prototype) got not a prototype")
	end

	local wrapped_prot = {prototype = prototype}

	-- Sets flags functions
	-- I'm lazy to check all prototypes :/
	for k, f in pairs(lazyAPI.flags) do
		wrapped_prot[k] = f
	end

	if lazyAPI.all_entities[_type] then
		for k, f in pairs(lazyAPI.entity) do
			wrapped_prot[k] = f
		end
		if lazyAPI.entities_with_health[_type] then
			for k, f in pairs(lazyAPI.EntityWithHealth) do
				wrapped_prot[k] = f
			end
		end
	end

	-- Sets base functions
	for k, f in pairs(lazyAPI.base) do
		wrapped_prot[k] = f
	end
	wrapped_prot.remove = lazyAPI.base.remove_prototype

	-- Sets functions for the type
	local lazy_funks = lazyAPI[_type]
	if lazy_funks then
		for k, f in pairs(lazy_funks) do
			wrapped_prot[k] = f
		end
	end

	-- Let extensions to use the wrapped prototype
	for _, f in pairs(extensions) do
		f(wrapped_prot)
	end

	setmetatable(wrapped_prot, prototype_mt)
	return wrapped_prot
end)


---@param prototype table
---@return table # wrapped prototype with lazyAPI functions
lazyAPI.wrap_prototype = function(prototype)
	return wrapped_prototypes[prototype]
end

---@param type? string
---@param name? string
---@param prototype_data? table
---@return table prototype_data, table wrapped_prototype
function lazyAPI.add_prototype(type, name, prototype_data)
	prototype_data = prototype_data or {}
	prototype_data.type = type or prototype_data.type
	prototype_data.name = name or prototype_data.name
	data:extend({prototype_data})
	return prototype_data, lazyAPI.wrap_prototype(prototype_data)
end


return lazyAPI

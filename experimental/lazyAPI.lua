---@diagnostic disable: undefined-field
--[[
Are you lazy to change/add/remove/check some prototypes/stuff in the data stage? Use this library then.\
Currently, this is an experimental framework, not everything is stable yet. (anything can be changed, removed, added etc.)\
No messy data, efficient API.

Supports:
simpleTiers (__zk_lib__/experimental/simpleTiers.lua)
easyTemplates (__zk_lib__/experimental/easyTemplates.lua)

Please, don't change/create/delete prototypes in data.lua file
in order to improve and simplify mod development and mod compatibility, thanks.
Please, don't use this module as a new library.

The short name for this framework is "LAPI".
]]--
---@class lazyAPI
---@module "__zk-lib__/experimental/lazyAPI"
local lazyAPI = {_SOURCE = "https://github.com/ZwerOxotnik/zk-lib", _VERSION = "0.0.2"}


--- Perhaps, I should auto generate annotations like LAPIWrappedPrototype etc.

--- WARNING: annotations aren't fully ready
---@class LAPIWrappedPrototype
---@field prototype table
---@field name string
---@field type string
---@field override_data fun(self: LAPIWrappedPrototype, new_data: table): self
---@field raise_change_event fun(self: LAPIWrappedPrototype): self
---@field does_exist fun(self: LAPIWrappedPrototype): boolean
---@field get_mod_source fun(self: LAPIWrappedPrototype): string?
---@field set_mod_source fun(self: LAPIWrappedPrototype, mod_name: string): self
---@field recreate_prototype fun(self: LAPIWrappedPrototype): self, boolean
---@field force_recreate_prototype fun(self: LAPIWrappedPrototype): self, boolean
---@field get_field fun(self: LAPIWrappedPrototype, field_name: string): any
---@field rename fun(self: LAPIWrappedPrototype, new_name: string): self
---@field rename_prototype fun(self: LAPIWrappedPrototype, new_name: string): self
---@field set_subgroup fun(self: LAPIWrappedPrototype, subgroup: string, order?: string): self
---@field remove_prototype fun(self: LAPIWrappedPrototype): self
---@field find_in_array fun(self: LAPIWrappedPrototype, field: any, data: any): integer?
---@field has_in_array fun(self: LAPIWrappedPrototype, field: any, data: any|any[]): boolean
---@field remove_from_array fun(self: LAPIWrappedPrototype, field: any, data: any): self, integer
---@field rename_in_array fun(self: LAPIWrappedPrototype, field: any, old_name: any, new_name: any): self, boolean
---@field replace_in_array fun(self: LAPIWrappedPrototype, field: any, old_name: any, new_name: any): self, boolean
---@field add_to_array fun(self: LAPIWrappedPrototype, field: any, data: any|any[]): self, boolean
---@field insert_after_element fun(self: LAPIWrappedPrototype, field: any, data: any|any[], target_data: any|any[]): self, integer?
---@field insert_before_element fun(self: LAPIWrappedPrototype, field: any, data: any|any[], target_data: any|any[]): self, integer?
---@field replace_in_prototype fun(self: LAPIWrappedPrototype, field: any, old_name: any, new_name: any): self, boolean
---@field is_cheat_prototype fun(self: LAPIWrappedPrototype): boolean
---@field get_alternative_prototypes fun(self: LAPIWrappedPrototype): table[]
---@field set_alternative_prototypes fun(self: LAPIWrappedPrototype, alt_prototype: table[]): self
---@field rawset_alternative_prototypes fun(self: LAPIWrappedPrototype, alt_prototype: table[]): self
---@field add_alternative_prototype fun(self: LAPIWrappedPrototype, alt_prototype: table): self
---@field add_alternative_prototypes fun(self: LAPIWrappedPrototype, alt_prototypes: table[]): self
---@field remove_alternative_prototype fun(self: LAPIWrappedPrototype, alt_prototype: table): self
---@field copy_icons fun(self: LAPIWrappedPrototype, from_prototype: table|LAPIWrappedPrototype): self
---@field copy_sounds fun(self: LAPIWrappedPrototype, from_prototype: table|LAPIWrappedPrototype): self
---@field copy_graphics fun(self: LAPIWrappedPrototype, from_prototype: table|LAPIWrappedPrototype): self
---@field get_tags fun(self: LAPIWrappedPrototype): string[]
---@field find_tags fun(self: LAPIWrappedPrototype, tags: string|string[]): boolean?
---@field add_tags fun(self: LAPIWrappedPrototype, tags: string|string[]): boolean?
---@field remove_tags fun(self: LAPIWrappedPrototype, tags: string|string[]): boolean?
---@field scale? fun(self: LAPIWrappedPrototype, size: number): self
---@field scale_sprite fun(self: LAPIWrappedPrototype, size: number, sprite_fields: string|string[]?): self
---@field scale_Animation4Way fun(self: LAPIWrappedPrototype, size: number, sprite_fields: string|string[]?): self
---@field scale_Sprite4Way fun(self: LAPIWrappedPrototype, size: number, sprite_fields: string|string[]?): self
---@field scale_SpriteVariations fun(self: LAPIWrappedPrototype, size: number, sprite_fields: string|string[]?): self

--[[

lazyAPI.get_current_mod(): string
lazyAPI.get_stage(): 1|1.5|2|2.5|3
lazyAPI.raise_event(event_name, prototype_type, event_data)
lazyAPI.override_data(data, new_data)
lazyAPI.format_special_symbols(string): string
lazyAPI.get_sprite_by_path(string): Sprite?
lazyAPI.expand_bounding_box(BoundingBox, value): BoundingBox
lazyAPI.increase_bounding_box(BoundingBox, value): BoundingBox
lazyAPI.increase_bounding_box(nil, value)
lazyAPI.decrease_bounding_box(BoundingBox, value): BoundingBox
lazyAPI.decrease_bounding_box(nil, value)
lazyAPI.multiply_bounding_box(BoundingBox, value): BoundingBox
lazyAPI.multiply_bounding_box(nil, value)
lazyAPI.add_extension(function)
lazyAPI.add_listener(action_name, name, types, func): boolean
lazyAPI.remove_listener(action_name, name)
lazyAPI.wrap_prototype(prototype): table
lazyAPI.add_prototype(prototype_type, name, prototype_data): table, table
lazyAPI.add_prototype(prototype_data): table, table
lazyAPI.fix_inconsistent_array(array): integer? | lazyAPI.fix_array(array): integer?
lazyAPI.fix_messy_table(array): integer? | -- lazyAPI.fix_table(array): integer?
lazyAPI.array_to_locale(array): table?
lazyAPI.array_to_locale_as_new(array): table?
lazyAPI.locale_to_array(array): table
lazyAPI.merge_locales(...): table
lazyAPI.merge_locales_as_new(...): table
lazyAPI.string_to_version(str): integer | lazyAPI.string_to_version()
lazyAPI.get_mod_version(mod_name): integer? | lazyAPI.get_mod_version()
lazyAPI.remove_entity_from_action_delivery(action, action_delivery, entity_name)
lazyAPI.remove_entity_from_action(action, entity_name)
lazyAPI.get_barrel_recipes(name): recipe, recipe
lazyAPI.create_trigger_capsule(tool_data): capsule, projectile
lazyAPI.create_invisible_mine(name, trigger_radius = 1): prototype, LAPIWrappedPrototype
lazyAPI.create_techs(name, max_level = 1, tech_data): tech, techs
lazyAPI.attach_custom_input_event(name): CustomInput
lazyAPI.make_empty_sprite(frame_count): table
lazyAPI.make_empty_sprites(): table
lazyAPI.remove_item_ingredient_everywhere(item_name)
lazyAPI.remove_items_by_entity(entity)
lazyAPI.replace_items_by_entity(entity, new_entity)
lazyAPI.remove_items_by_tile(tile)
lazyAPI.replace_items_by_tile(tile, new_tile)
lazyAPI.remove_items_by_equipment(equipment)
lazyAPI.replace_items_by_equipment(battery_equipment, new_battery_equipment)
lazyAPI.remove_equipment_by_item(item): boolean
lazyAPI.remove_recipes_by_fluid(fluid)
lazyAPI.remove_recipes_by_item(item)
lazyAPI.remove_loot_everywhere(item)
lazyAPI.replace_loot_everywhere(item, new_item)
lazyAPI.remove_entities_by_name(name)
lazyAPI.has_entities_by_name(name)
lazyAPI.find_entities_by_name(name)
lazyAPI.remove_items_by_name(name)
lazyAPI.has_items_by_name(name)
lazyAPI.find_items_by_name(name)
lazyAPI.remove_recipe_from_modules(recipe)
lazyAPI.replace_recipe_in_all_modules(old_recipe, new_recipe)
lazyAPI.replace_prerequisite_in_all_techs(old_tech, new_tech)
lazyAPI.replace_resource_category_in_all_mining_drills(old_resource_category, new_resource_category)
lazyAPI.can_i_create(_type, name): boolean
lazyAPI.remove_fluid(fluid_name)
lazyAPI.remove_tool_everywhere(tool)
lazyAPI.rename_tool(prev_tool, new_tool)
lazyAPI.remove_tile(tile_name)
lazyAPI.is_product_valid(product): boolean
lazyAPI.find_prototypes_by_product(product): table[]?
lazyAPI.make_fake_simple_entity_with_owner(prototype)
lazyAPI.find_prototypes_filtered(prototype_filter): table[]
lazyAPI.replace_in_prototypes(prototypes, field, old_data, new_data): prototypes
lazyAPI.scale_sprite(table?, size)
lazyAPI.scale_pipes(prototype, fluid_box, size, string|string[]?): prototype
lazyAPI.scale_vector(table?, size)
lazyAPI.scale_pipe_sprite(table?, size)


lazyAPI.base.override_data(table): prototype
lazyAPI.base.raise_change_event(prototype): prototype
lazyAPI.base.does_exist(type, name): boolean
lazyAPI.base.does_exist(prototype): boolean
lazyAPI.base.get_mod_source(prototype): string?
lazyAPI.base.set_mod_source(prototype, string): prototype
lazyAPI.base.recreate_prototype(prototype): prototype, boolean
lazyAPI.base.force_recreate_prototype(prototype): prototype, boolean
lazyAPI.base.get_field(prototype, field_name): any
lazyAPI.base.rename(prototype, new_name): prototype | lazyAPI.base.rename_prototype(prototype, new_name): prototype
lazyAPI.base.set_subgroup(prototype, subgroup, order?): set_subgroup
lazyAPI.base.remove_prototype(prototype): prototype | lazyAPI.base.remove_prototype()
lazyAPI.base.find_in_array(source, field, data): integer?
lazyAPI.base.find_in_array(source, data): integer?
lazyAPI.base.has_in_array(source, field, data): boolean
lazyAPI.base.has_in_array(source, data): boolean
lazyAPI.base.remove_from_array(source, field, data): prototype, integer
lazyAPI.base.remove_from_array(source, data): prototype, integer
lazyAPI.base.rename_in_array(source, field, old_name, new_name): prototype, boolean | lazyAPI.base.rename_in_array()
lazyAPI.base.rename_in_array(source, old_name, new_name): prototype, boolean | lazyAPI.base.rename_in_array()
lazyAPI.base.replace_in_array(source, field, old_name, new_name): prototype, boolean | lazyAPI.base.replace_in_array()
lazyAPI.base.replace_in_array(source, old_name, new_name): prototype, boolean | lazyAPI.base.replace_in_array()
lazyAPI.base.add_to_array(source, field, data): prototype, boolean
lazyAPI.base.add_to_array(source, data): prototype, boolean
lazyAPI.base.insert_after_element(source, field, data, target_data): prototype, integer?
lazyAPI.base.insert_after_element(source, data, target_data): prototype, integer?
lazyAPI.base.insert_before_element(source, field, data, target_data): prototype, integer?
lazyAPI.base.insert_before_element(source, data, target_data): prototype, integer?
lazyAPI.base.replace_in_prototype(prototype, field, old_data, new_data): prototype, boolean
lazyAPI.base.is_cheat_prototype(prototype): boolean
lazyAPI.base.get_alternative_prototypes(prototype): table[]?
lazyAPI.base.set_alternative_prototypes(prototype, alternative_prototypes): prototype
lazyAPI.base.rawset_alternative_prototypes(prototype, alternative_prototypes): prototype
lazyAPI.base.add_alternative_prototype(prototype, alternative_prototype): prototype
lazyAPI.base.add_alternative_prototypes(prototype, alternative_prototypes): prototype
lazyAPI.base.remove_alternative_prototype(prototype, alternative_prototype): prototype
lazyAPI.base.copy_icons(to_prototype, from_prototype): to_prototype
lazyAPI.base.copy_sounds(to_prototype, from_prototype): to_prototype
lazyAPI.base.copy_graphics(to_prototype, from_prototype): to_prototype
lazyAPI.base.get_tags(prototype?): string[]?
lazyAPI.base.find_tags(prototype?, string|string[]): boolean
lazyAPI.base.add_tags(prototype?, string|string[]): prototype
lazyAPI.base.remove_tags(prototype?, string|string[]): prototype
lazyAPI.base.scale_sprite(prototype, size, string|string[]?): prototype
lazyAPI.base.scale_Animation4Way(prototype, size, string|string[]?): prototype
lazyAPI.base.scale_Sprite4Way(prototype, size, string|string[]?): prototype
lazyAPI.base.scale_SpriteVariations(prototype, size, string|string[]?): prototype
lazyAPI.flags.add_flag(prototype, flag): prototype
lazyAPI.flags.remove_flag(prototype, flag): prototype
lazyAPI.flags.find_flag(prototype, flag): integer?
lazyAPI.ingredients.add_item_ingredient(prototype, item, amount = 1): ItemIngredientPrototype
lazyAPI.ingredients.add_fluid_ingredient(prototype, fluid, amount = 1): FluidIngredientPrototype
lazyAPI.ingredients.add_ingredient(prototype, target, amount = 1): IngredientPrototype
lazyAPI.ingredients.add_valid_item_ingredient(prototype, item, amount = 1): ItemIngredientPrototype?
lazyAPI.ingredients.add_valid_fluid_ingredient(prototype, fluid, amount = 1): FluidIngredientPrototype?
lazyAPI.ingredients.add_valid_ingredient(prototype, target, amount = 1): IngredientPrototype?
lazyAPI.ingredients.set_item_ingredient(prototype, item, amount = 1): prototype
lazyAPI.ingredients.set_fluid_ingredient(prototype, fluid, amount = 1): prototype
lazyAPI.ingredients.set_ingredient(prototype, target, amount = 1): prototype
lazyAPI.ingredients.set_valid_item_ingredient(prototype, item, amount = 1): prototype
lazyAPI.ingredients.set_valid_fluid_ingredient(prototype, fluid, amount = 1): prototype
lazyAPI.ingredients.set_valid_ingredient(prototype, target, amount = 1): prototype
lazyAPI.ingredients.get_item_ingredients(prototype, item): ItemIngredientPrototype[]
lazyAPI.ingredients.get_fluid_ingredients(prototype, fluid): FluidIngredientPrototype[]
lazyAPI.ingredients.remove_ingredient(prototype, ingredient, type?): IngredientPrototype?
lazyAPI.ingredients.remove_ingredient_everywhere(prototype, ingredient, type?): prototype
lazyAPI.ingredients.remove_all_ingredients(prototype): prototype
lazyAPI.ingredients.remove_non_existing_ingredients(prototype): prototype
lazyAPI.ingredients.replace_ingredient(prototype, old_ingredient, new_ingredient, type?): prototype
lazyAPI.ingredients.replace_ingredient_everywhere(prototype, old_ingredient, new_ingredient, type?): prototype
lazyAPI.ingredients.find_ingredient_by_name(prototype, ingredient): IngredientPrototype?
lazyAPI.resistance.find(prototype, type): Resistances?
lazyAPI.resistance.set(prototype, type, percent, decrease?): prototype
lazyAPI.resistance.remove(prototype, type): prototype
lazyAPI.loot.find(prototype, item): Loot?
lazyAPI.loot.replace(prototype, item): prototype
lazyAPI.loot.set(prototype, item, count_min?, count_max? percent?, decrease?): prototype
lazyAPI.loot.set_if_exist(prototype, item, count_min?, count_max? percent?, decrease?): prototype
lazyAPI.loot.remove(prototype, item): prototype
lazyAPI.loot.remove_non_existing_loot(prototype): prototype
lazyAPI.entity.has_item(entity): boolean
lazyAPI.entity.scale(prototype, size): prototype?
-- TODO: add lazyAPI.entity.copy_bounding_size or something like that
lazyAPI.EntityWithHealth.find_resistance(prototype, type)
lazyAPI.EntityWithHealth.set_resistance(prototype, type, percent, decrease)
lazyAPI.EntityWithHealth.remove_resistance(prototype, type)
lazyAPI.EntityWithHealth.find_loot(prototype, item): Loot?
lazyAPI.EntityWithHealth.replace_loot(prototype, item): prototype
lazyAPI.EntityWithHealth.set_loot(prototype, item, count_min?, count_max? percent?, decrease?): prototype
lazyAPI.EntityWithHealth.set_valid_loot(prototype, item, count_min?, count_max? percent?, decrease?): prototype
lazyAPI.EntityWithHealth.remove_loot(prototype, item): prototype
lazyAPI.EntityWithHealth.remove_non_existing_loot(prototype): prototype
lazyAPI.item.find_main_recipes(item): table[]
-- There are several issues still
lazyAPI.recipe.set_subgroup(prototype, subgroup, order?): prototype
lazyAPI.recipe.have_ingredients(recipe): boolean
lazyAPI.recipe.add_item_ingredient(prototype, item, amount = 1): ItemIngredientPrototype
lazyAPI.recipe.add_fluid_ingredient(prototype, fluid, amount = 1): FluidIngredientPrototype
lazyAPI.recipe.add_ingredient(prototype, target, amount = 1): IngredientPrototype
lazyAPI.recipe.add_valid_item_ingredient(prototype, item, amount = 1): ItemIngredientPrototype?
lazyAPI.recipe.add_valid_fluid_ingredient(prototype, fluid, amount = 1): FluidIngredientPrototype?
lazyAPI.recipe.add_valid_ingredient(prototype, target, amount = 1): IngredientPrototype?
lazyAPI.recipe.set_item_ingredient(prototype, item, amount = 1): prototype
lazyAPI.recipe.set_fluid_ingredient(prototype, fluid, amount = 1): prototype
lazyAPI.recipe.set_valid_item_ingredient(prototype, item, amount = 1): prototype
lazyAPI.recipe.set_valid_fluid_ingredient(prototype, fluid, amount = 1): prototype
lazyAPI.recipe.set_ingredient(prototype, target, amount = 1): prototype
lazyAPI.recipe.set_valid_ingredient(prototype, target, amount = 1): prototype
lazyAPI.recipe.get_item_ingredients(prototype, item): ItemIngredientPrototype[]
lazyAPI.recipe.get_fluid_ingredients(prototype, fluid): FluidIngredientPrototype[]
lazyAPI.recipe.remove_ingredient(prototype, ingredient, type?): IngredientPrototype?
lazyAPI.recipe.remove_ingredient_everywhere(prototype, ingredient, type?): prototype
lazyAPI.recipe.remove_non_existing_ingredients(prototype): prototype
lazyAPI.recipe.replace_ingredient(prototype, old_ingredient, new_ingredient, type?): prototype
lazyAPI.recipe.replace_ingredient_everywhere(prototype, old_ingredient, new_ingredient, type?): prototype
lazyAPI.recipe.find_ingredient_by_name(prototype, ingredient): IngredientPrototype?
lazyAPI.product.make_product_prototype(product, product_type, show_details_in_recipe_tooltip): ProductPrototype
lazyAPI.product.make_item_product_prototype(item_product, show_details_in_recipe_tooltip): ItemProductPrototype
lazyAPI.product.make_fluid_product_prototype(fluid_product, show_details_in_recipe_tooltip): FluidProductPrototype
lazyAPI.recipe.has_result(prototype): boolean
lazyAPI.recipe.find_main_result(prototype, item): boolean
lazyAPI.recipe.add_item_in_result(prototype, item, item_product): prototype
lazyAPI.recipe.add_fluid_in_result(prototype, fluid, fluid_product): prototype
lazyAPI.recipe.add_product_in_result(prototype, product, product_prototype): prototype
lazyAPI.recipe.add_valid_item_in_result(prototype, item, item_product): prototype
lazyAPI.recipe.add_valid_fluid_in_result(prototype, fluid, fluid_product): prototype
lazyAPI.recipe.add_valid_product_in_result(prototype, product, product_prototype): prototype
lazyAPI.recipe.set_item_in_result(prototype, item, item_product): prototype
lazyAPI.recipe.set_fluid_in_result(prototype, fluid, fluid_product): prototype
lazyAPI.recipe.set_product_in_result(prototype, product, product_prototype): prototype
lazyAPI.recipe.set_valid_item_in_result(prototype, item, item_product): prototype
lazyAPI.recipe.set_valid_fluid_in_result(prototype, fluid, fluid_product): prototype
lazyAPI.recipe.set_valid_product_in_result(prototype, product, product_prototype): prototype
lazyAPI.recipe.replace_result(prototype, item, new_item, _type): prototype
lazyAPI.recipe.replace_result_everywhere(prototype, item, new_item, _type): prototype
lazyAPI.recipe.remove_if_no_result(prototype): prototype?
lazyAPI.recipe.remove_if_no_ingredients(prototype): prototype?
lazyAPI.recipe.remove_item_from_result(prototype, item): prototype
lazyAPI.recipe.remove_item_from_result_everywhere(prototype, item): prototype
lazyAPI.recipe.remove_fluid_from_result(prototype, fluid): prototype
lazyAPI.recipe.remove_fluid_from_result_everywhere(prototype, fluid): prototype
lazyAPI.recipe.remove_non_existing_results(prototype): prototype
lazyAPI.recipe.find_items_in_result(prototype, item): ProductPrototype[]|string
lazyAPI.recipe.count_item_in_result(prototype, item): integer, integer
lazyAPI.recipe.find_fluids_in_result(prototype, fluid): ProductPrototype[]
lazyAPI.recipe.count_fluid_in_result(prototype, fluid): integer, integer
lazyAPI.module.is_recipe_allowed(prototype, recipe): boolean
lazyAPI.module.find_allowed_recipe_index(prototype, recipe): integer?
lazyAPI.module.find_blacklisted_recipe_index(prototype, recipe): integer?
lazyAPI.module.allow_recipe(prototype, recipe): prototype
lazyAPI.module.prohibit_recipe(prototype, recipe): prototype
lazyAPI.module.remove_allowed_recipe(prototype, recipe): prototype
lazyAPI.module.remove_blacklisted_recipe(prototype, recipe): prototype
lazyAPI.module.replace_recipe(prototype, old_recipe, new_recipe): prototype
lazyAPI.tech.remove_if_no_effects(prototype): prototype?
lazyAPI.tech.unlock_recipe(prototype, recipe): prototype
lazyAPI.tech.find_unlock_recipe_effect(prototype, recipe): UnlockRecipeModifierPrototype?
lazyAPI.tech.add_effect(prototype, type, recipe): prototype?
lazyAPI.tech.find_effect(prototype, type, recipe): ModifierPrototype?
lazyAPI.tech.remove_unlock_recipe_effect(prototype, recipe): prototype
lazyAPI.tech.remove_unlock_recipe_effect_everywhere(prototype, recipe_name): prototype
lazyAPI.tech.remove_effect(prototype, type, recipe): prototype
lazyAPI.tech.remove_effect_everywhere(prototype, type, recipe): prototype
lazyAPI.tech.find_prerequisite(prototype, tech): integer?
lazyAPI.tech.add_prerequisite(prototype, tech): prototype
lazyAPI.tech.remove_prerequisite(prototype, tech): prototype
lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech): prototype
lazyAPI.tech.add_tool(prototype, tool, amount = 1): ItemIngredientPrototype?
lazyAPI.tech.add_valid_tool(prototype, tool, amount = 1): ItemIngredientPrototype?
lazyAPI.tech.set_tool(prototype, tool, amount = 1): prototype
lazyAPI.tech.set_valid_tool(prototype, tool, amount = 1): prototype
lazyAPI.tech.remove_tool(prototype, tool): IngredientPrototype
lazyAPI.tech.replace_tool(prototype, old_tool, new_tool): prototype
lazyAPI.tech.is_contiguous_tech(tech): boolean
lazyAPI.tech.get_last_tech_level(tech): integer?
lazyAPI.tech.get_last_valid_contiguous_tech_level(tech): integer?
lazyAPI.tech.remove_contiguous_techs(tech): technology?
lazyAPI.mining_drill.find_resource_category(prototype, resource_category): integer?
lazyAPI.mining_drill.add_resource_category(prototype, resource_category): prototype
lazyAPI.mining_drill.remove_resource_category(prototype, resource_category): prototype
lazyAPI.mining_drill.replace_resource_category(prototype, old_resource_category, new_resource_category): prototype
lazyAPI.mining_drill.replace_resource_category_everywhere(prototype, old_category, new_category): prototype
lazyAPI.resource.add_inf_version(prototype): prototype, new_prototype?
lazyAPI.character.remove_armor(prototype, armor): prototype

]]


local type, table, rawget, rawset = type, table, rawget, rawset -- There's a chance something overwrites it
local debug, error, log = debug, error, log -- I'm pretty sure, some mod did overwrite it
local traceback = debug.traceback
---@diagnostic disable-next-line: undefined-field
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


---@type table<string, integer>
lazyAPI._warning_types = {
	mixed_array = 1, -- Don't add different keys for arrays. It's difficult to check and use messy tables.
	table_has_gaps = 2 -- Be careful with tables like: {nil, 2} because their length will be inconsistent.
}
local _warning_types = lazyAPI._warning_types
lazyAPI._warnings = {
	[_warning_types.mixed_array] = "a mixed array, some keys aren't numbers",
	[_warning_types.table_has_gaps] = "an array had been initialized with nils and keeped them"
}
---@type table<table, integer>
lazyAPI._warning_for_fixed_tables = {}
setmetatable(lazyAPI._warning_for_fixed_tables, {
	__newindex = function(self, k, v)
		if rawget(self, k) then return end -- No multiple errors etc in the table
		log("lazyAPI detected an inconsistency: " .. (lazyAPI._warnings[v] or 'unknown case'))
		log(debug.traceback())
		rawset(self, k, v)
	end
})


---@type table<string, Sprite>
lazyAPI.sprite_by_path = {
	["__core__/graphics/empty.png"] = {
		filename = "__core__/graphics/empty.png",
		width = 1, height = 1
	}
}
local _sprite_by_path_mt = {}
_sprite_by_path_mt.__index = function(t,k)
	return table.deepcopy(rawget(t, k))
end
setmetatable(lazyAPI.sprite_by_path, _sprite_by_path_mt)


---@type table[]
lazyAPI.all_data = {} -- Prototypes from lazyAPI.deleted_data and raw.data
lazyAPI.vanilla_data = {} -- WARNING: NOT RELIABLE AT ALL (it should contain original data from raw.data and yet changable indirectly still)

---@type table<string, table<string, table>>
lazyAPI.deleted_data = {} -- Deleted prototypes
for key in pairs(data_raw) do
	lazyAPI.deleted_data[key] = {}
end
lazyAPI.deleted_data.sound     = lazyAPI.deleted_data.sound or {}
lazyAPI.deleted_data.animation = lazyAPI.deleted_data.animation or {}


---@type table<table, string>
lazyAPI.prototypes_mod_source = {}


lazyAPI.base = {}
lazyAPI.resistance = {}
lazyAPI.ingredients = {}
lazyAPI.loot = {}
lazyAPI.flags = {}
lazyAPI.entity = {}
lazyAPI.EntityWithHealth = {}
lazyAPI.item = {}
lazyAPI.product = {}
lazyAPI.recipe = {}
lazyAPI.module = {}
lazyAPI.tech = {}
lazyAPI.technology = lazyAPI.tech
lazyAPI.mining_drill = {}
lazyAPI.resource = {}
lazyAPI["mining-drill"] = lazyAPI.mining_drill
lazyAPI.character = {}

lazyAPI.materials = {"iron", "steel", "copper", "gold", "brass", "tin", "invar",
	"chromium", "nickel", "carbon", "titanium", "lead", "bronze", "diamond",
	"stone", "coal", "wood", "uranium", "ruby", "rubber", "sulphur", "electrum",
	"plastic", "silicon", "charcoal", "coal", "glass", "manganese", "bismuth",
	"silver", "platinum", "platinum", "palladium", "zirconium", "tungsten",
	"silica", "quartz", "sand", "salt", "chlorine", "graphite", "aluminum",
	"alumina", "zircon", "zink"
}

--- type = { name = { tags }}
---@type table<string <string, string[]>>
lazyAPI.tags = {}

---@type table<table, table[]>
local __all_alternative_prototypes = {}

lazyAPI.all_utility_sound_fields = {
	"gui_click", "list_box_click", "build_small", "build_medium",
	"build_large", "cannot_build", "build_blueprint_small",
	"build_blueprint_medium", "build_blueprint_large", "deconstruct_small",
	"deconstruct_medium", "deconstruct_big", "deconstruct_robot",
	"rotated_small", "rotated_medium", "rotated_big", "axe_mining_ore",
	"mining_wood", "axe_fighting", "alert_destroyed", "console_message",
	"scenario_message", "new_objective", "game_lost", "game_won",
	"metal_walking_sound", "research_completed", "default_manual_repair",
	"crafting_finished", "inventory_click", "inventory_move",
	"clear_cursor", "armor_insert", "armor_remove", "achievement_unlocked",
	"wire_connect_pole", "wire_disconnect", "wire_pickup", "tutorial_notice",
	"smart_pipette", "switch_gun", "picked_up_item",
	"blueprint_selection_ended", "blueprint_selection_started",
	"deconstruction_selection_started", "deconstruction_selection_ended",
	"cancel_deconstruction_selection_started", "cancel_deconstruction_selection_ended",
	"upgrade_selection_started", "upgrade_selection_ended",
	"copy_activated", "cut_activated", "paste_activated",
	"item_deleted", "entity_settings_pasted", "entity_settings_copied",
	"item_spawned", "confirm", "undo", "drop_item", "rail_plan_start"
}
lazyAPI.all_common_sound_fields = {
	"open_sound", "close_sound", "build_sound", "mined_sound",
	"mining_sound", "rotated_sound", "vehicle_impact_sound",
	"working_sound", "large_build_sound", "medium_build_sound",
	"repair_sound", "sound", "animation_sound",
	"activate_sound", "deactivate_sound", "walking_sound",
	"alarm_sound", "clamps_off_sound", "clamps_on_sound",
	"doors_sound", "flying_sound", "raise_rocket_sound",
	"dying_sound", "folding_sound", "prepared_alternative_sound",
	"prepared_sound", "preparing_sound", "starting_attack_sound",
	"achievement_unlocked", "repairing_sound", "heartbeat",
	"sound_no_fuel", "eat", "rotating_stopped_sound", "rotating_stopped_sound"
}
lazyAPI.all_sound_fields = {}
for _, sound_name in pairs(lazyAPI.all_utility_sound_fields) do
	lazyAPI.all_sound_fields[#lazyAPI.all_sound_fields+1] = sound_name
end
for _, sound_name in pairs(lazyAPI.all_common_sound_fields) do
	lazyAPI.all_sound_fields[#lazyAPI.all_sound_fields+1] = sound_name
end

-- TODO: update for Factorio 2.0!!!
-- TODO: add more functions to compare these values etc.
-- https://lua-api.factorio.com/latest/types/RenderLayer.html
-- The order from lowest to highest:
lazyAPI.RenderLayers = {
	"water_tile", "ground_tile", "tile-transition", "decals",
	"lower-radius-visualization", "radius-visualization",
	"transport-belt-integration", "resource", "building-smoke",
	"decorative", "ground-patch", "ground-patch-higher",
	"ground-patch-higher2", "remnants", "floor", "transport-belt",
	"transport-belt-endings", "floor-mechanics-under-corpse", "corpse",
	"floor-mechanics", "item", "lower-object",
	"transport-belt-circuit-connector", "lower-object-above-shadow",
	"object", "higher-object-under", "higher-object-above",
	"item-in-inserter-hand", "wires", "wires-above", "entity-info-icon",
	"entity-info-icon-above", "explosion", "projectile", "smoke",
	"air-object", "air-entity-info-icon", "light-effect",
	"selection-box", "higher-selection-box", "collision-selection-box",
	"arrow", "cursor"
}
-- https://wiki.factorio.com/Types/LightDefinition
lazyAPI.all_LightDefinition_fields = {
	"charge_light", "discharge_light", "light", "activity_led_light",
	"screen_light", "working_light", "ground_light", "stream_light",
	"enough_fuel_indicator_light", "muzzle_light",
	"not_enough_fuel_indicator_light", "light_when_colored",
	"front_light", "blue_light", "green_light", "orange_light",
	"red_light", "recharging_light", "base_engine_light",
	"base_light", "glow_light", "back_light", "stand_by_light",
	"wall_diode_green_light_bottom", "wall_diode_green_light_left",
	"wall_diode_green_light_right", "wall_diode_green_light_top",
	"wall_diode_red_light_bottom", "wall_diode_red_light_left",
	" wall_diode_red_light_right", "wall_diode_red_light_top"
}
-- https://wiki.factorio.com/Types/RenderLayer
lazyAPI.all_RenderLayer_fields = {
	"render_layer", "render_layer_when_on_ground", "base_picture_render_layer",
	"animation_overlay_final_render_layer", "animation_overlay_render_layer",
	"animation_render_layer", "final_render_layer",
	"ground_patch_render_layer", "splash_render_layer",
	"integration_patch_render_layer", "initial_render_layer",
	"secondary_render_layer", "structure_render_layer", "base_render_layer",
	"gun_animation_render_layer"
}
-- https://wiki.factorio.com/Types/Sprite4Way
-- Perhaps, it's not all of them
-- Actually, "pictures" can be an misleading or exception https://wiki.factorio.com/Prototype/Wall
lazyAPI.all_Sprite4Way_fields = {
	"pipe_covers", "heat_pipe_covers", "heat_picture",
	"heat_glow", "platform_picture", "picture", "pictures",
	"glass_pictures", "integration_patch", "ending_patch",
	"activity_led_sprites", "enough_fuel_indicator_picture",
	"not_enough_fuel_indicator_picture", "wall_diode_green",
	"wall_diode_red", "equal_symbol_sprites",
	"greater_or_equal_symbol_sprites", "greater_symbol_sprites",
	"less_or_equal_symbol_sprites", "less_symbol_sprites",
	"not_equal_symbol_sprites", "and_symbol_sprites",
	"divide_symbol_sprites", "left_shift_symbol_sprites",
	"minus_symbol_sprites", "modulo_symbol_sprites",
	"multiply_symbol_sprites", "or_symbol_sprites",
	"plus_symbol_sprites", "power_symbol_sprites",
	"right_shift_symbol_sprites", "xor_symbol_sprites"
}
-- https://wiki.factorio.com/Types/Sprite4Way
-- Perhaps, it should be named differently
lazyAPI.all_unique_Sprite4Way_fields = {
	"structure", "light1", "light2"
}
-- https://wiki.factorio.com/Types/Animation4Way
-- Perhaps, it's not all of them
lazyAPI.all_Animation4Way_fields = {
	"animation", "animations", "idle_animation", "base_picture", "structure_patch",
	"structure", "rail_overlay_animations", "top_animations", "fluid_animation",
}
-- https://wiki.factorio.com/Types/SpriteVariations
lazyAPI.all_spriteVariations_fields = {
	"picture", "pictures", "integration", "burnt_patch_pictures",
	"connection_patches_connected", "connection_patches_disconnected",
	"heat_connection_patches_connected", "heat_connection_patches_disconnected",
	"overlay"
}
-- https://wiki.factorio.com/Types/Sprite
-- It's not clear where "graphics_set" should be. Perhaps new table should be created.
lazyAPI.all_unique_sprite_fields = {"cursor_box", "graphics_set"}
-- Probably, I didn't find all
lazyAPI.all_unique_animation_fields = {"belt_animation_set", "graphics_set"}
-- https://wiki.factorio.com/Prototype/UtilitySprites
lazyAPI.all_utility_animations_fields = {
	"clouds", "arrow_button", "explosion_chart_visualization", "refresh_white"
}
-- Table fields with east, west, south, north referring to https://wiki.factorio.com/Types/Animation
lazyAPI.directory_animation_fields = {
	"structure", "fire", "fire_glow",
}
-- Table fields with east, west, south, north referring to https://wiki.factorio.com/Types/Sprite
lazyAPI.directory_sprite_fields = {
	"patch"
}
-- https://wiki.factorio.com/Prototype/UtilitySprites
lazyAPI.all_utility_sprite_fields = {
	"center", "check_mark", "check_mark_white", "check_mark_green",
	"check_mark_dark_green", "not_played_yet_green", "not_played_yet_dark_green",
	"played_green", "played_dark_green", "close_fat", "close_white",
	"close_black", "close_map_preview", "color_picker", "change_recipe",
	"dropdown", "downloading", "downloading_white", "downloaded",
	"downloaded_white", "equipment_grid", "expand_dots", "expand_dots_white",
	"export", "import", "map", "map_exchange_string", "missing_mod_icon",
	"not_available", "play", "stop", "preset", "refresh", "reset",
	"reset_white", "shuffle", "station_name", "search",
	"sync_mods", "trash", "trash_white", "copy", "reassign", "warning",
	"warning_white", "list_view", "grid_view", "reference_point", "mouse_cursor",
	"mod_dependency_arrow", "add", "clone", "go_to_arrow", "pause",
	"speed_down", "speed_up", "editor_speed_down", "editor_pause",
	"editor_play", "editor_speed_up", "tick_once", "tick_sixty", "tick_custom",
	"search_icon", "too_far", "shoot_cursor_green", "shoot_cursor_red",
	"electricity_icon", "fuel_icon", "ammo_icon", "fluid_icon", "warning_icon",
	"danger_icon", "destroyed_icon", "recharge_icon",
	"too_far_from_roboport_icon", "pump_cannot_connect_icon",
	"not_enough_repair_packs_icon", "not_enough_construction_robots_icon",
	"no_building_material_icon", "no_storage_space_icon",
	"electricity_icon_unplugged", "game_stopped_visualization",
	"health_bar_green_pip", "health_bar_yellow_pip", "health_bar_red_pip",
	"ghost_bar_pip", "bar_gray_pip", "shield_bar_pip", "hand", "hand_black",
	"entity_info_dark_background", "medium_gui_arrow", "small_gui_arrow",
	"light_medium", "light_small", "light_cone", "color_effect", "clock",
	"default_ammo_damage_modifier_icon", "default_gun_speed_modifier_icon",
	"default_turret_attack_modifier_icon", "hint_arrow_up", "hint_arrow_down",
	"hint_arrow_right", "hint_arrow_left", "fluid_indication_arrow",
	"fluid_indication_arrow_both_ways", "heat_exchange_indication",
	"indication_arrow", "rail_planner_indication_arrow",
	"rail_planner_indication_arrow_too_far", "rail_path_not_possible",
	"indication_line", "short_indication_line", "short_indication_line_green",
	"slot_icon_module", "slot_icon_module_black", "slot_icon_armor",
	"slot_icon_armor_black", "slot_icon_gun", "slot_icon_gun_black",
	"slot_icon_ammo", "slot_icon_ammo_black", "slot_icon_resource",
	"slot_icon_resource_black", "slot_icon_fuel", "slot_icon_fuel_black",
	"slot_icon_result", "slot_icon_result_black", "slot_icon_robot",
	"slot_icon_robot_black", "slot_icon_robot_material",
	"slot_icon_robot_material_black", "slot_icon_inserter_hand",
	"slot_icon_inserter_hand_black", "upgrade_blueprint", "slot",
	"equipment_slot", "equipment_collision", "battery", "green_circle",
	"green_dot", "robot_slot", "set_bar_slot", "missing_icon",
	"deconstruction_mark", "upgrade_mark", "confirm_slot", "export_slot",
	"import_slot", "none_editor_icon", "cable_editor_icon",
	"tile_editor_icon", "decorative_editor_icon", "resource_editor_icon",
	"entity_editor_icon", "item_editor_icon", "force_editor_icon",
	"clone_editor_icon", "scripting_editor_icon", "paint_bucket_icon",
	"surface_editor_icon", "time_editor_icon", "cliff_editor_icon",
	"brush_icon", "spray_icon", "cursor_icon", "area_icon", "line_icon",
	"variations_tool_icon", "lua_snippet_tool_icon", "editor_selection",
	"brush_square_shape", "brush_circle_shape", "player_force_icon",
	"neutral_force_icon", "enemy_force_icon", "nature_icon",
	"no_nature_icon", "multiplayer_waiting_icon", "spawn_flag",
	"questionmark", "copper_wire", "green_wire", "red_wire",
	"green_wire_hightlight", "red_wire_hightlight", "wire_shadow",
	"and_or", "left_arrow", "right_arrow", "down_arrow", "enter",
	"side_menu_blueprint_library_icon", "side_menu_production_icon",
	"side_menu_bonus_icon", "side_menu_tutorials_icon",
	"side_menu_train_icon", "side_menu_achievements_icon",
	"side_menu_menu_icon", "side_menu_map_icon",
	"side_menu_blueprint_library_hover_icon",
	"side_menu_production_hover_icon", "side_menu_bonus_hover_icon",
	"side_menu_tutorials_hover_icon", "side_menu_train_hover_icon",
	"side_menu_achievements_hover_icon", "side_menu_menu_hover_icon",
	"side_menu_map_hover_icon", "circuit_network_panel_black",
	"circuit_network_panel_white", "logistic_network_panel_black",
	"logistic_network_panel_white", "rename_icon_small_black",
	"rename_icon_small_white", "rename_icon_normal",
	"achievement_label_locked", "achievement_label_unlocked_off",
	"achievement_label_unlocked", "achievement_label_failed",
	"rail_signal_placement_indicator", "train_stop_placement_indicator",
	"placement_indicator_leg", "grey_rail_signal_placement_indicator",
	"grey_placement_indicator_leg", "logistic_radius_visualization",
	"construction_radius_visualization", "track_button",
	"show_logistics_network_in_map_view", "show_electric_network_in_map_view",
	"show_turret_range_in_map_view", "show_pollution_in_map_view",
	"show_train_station_names_in_map_view", "show_player_names_in_map_view",
	"show_tags_in_map_view", "show_worker_robots_in_map_view",
	"show_rail_signal_states_in_map_view", "show_recipe_icons_in_map_view",
	"show_logistics_network_in_map_view_black",
	"show_electric_network_in_map_view_black",
	"show_turret_range_in_map_view_black", "show_pollution_in_map_view_black",
	"show_train_station_names_in_map_view_black",
	"show_player_names_in_map_view_black", "show_tags_in_map_view_black",
	"show_worker_robots_in_map_view_black",
	"show_rail_signal_states_in_map_view_black",
	"show_recipe_icons_in_map_view_black", "train_stop_in_map_view",
	"train_stop_disabled_in_map_view", "train_stop_full_in_map_view",
	"custom_tag_in_map_view", "covered_chunk", "white_square", "white_mask",
	"favourite_server_icon", "crafting_machine_recipe_not_unlocked",
	"gps_map_icon", "custom_tag_icon", "underground_remove_belts",
	"underground_remove_pipes", "underground_pipe_connection",
	"ghost_cursor", "tile_ghost_cursor", "expand", "expand_dark",
	"collapse", "collapse_dark", "status_working", "status_not_working",
	"status_yellow", "gradient", "output_console_gradient",
	"select_icon_black", "select_icon_white", "notification", "alert_arrow",
	"technology_black", "technology_white",
	"inserter_stack_size_bonus_modifier_icon",
	"inserter_stack_size_bonus_modifier_constant",
	"bulk_inserter_capacity_bonus_modifier_icon", --TODO: recheck
	"bulk_inserter_capacity_bonus_modifier_constant", --TODO: recheck
	"laboratory_speed_modifier_icon", "laboratory_speed_modifier_constant",
	"character_logistic_slots_modifier_icon",
	"character_logistic_slots_modifier_constant",
	"character_logistic_trash_slots_modifier_icon",
	"character_logistic_trash_slots_modifier_constant",
	"maximum_following_robots_count_modifier_icon",
	"maximum_following_robots_count_modifier_constant",
	"worker_robot_speed_modifier_icon", "worker_robot_speed_modifier_constant",
	"worker_robot_storage_modifier_icon",
	"worker_robot_storage_modifier_constant",
	"ghost_time_to_live_modifier_icon", "ghost_time_to_live_modifier_constant",
	"turret_attack_modifier_icon", "turret_attack_modifier_constant",
	"ammo_damage_modifier_icon", "ammo_damage_modifier_constant",
	"give_item_modifier_icon", "give_item_modifier_constant",
	"gun_speed_modifier_icon", "gun_speed_modifier_constant",
	"unlock_recipe_modifier_icon", "unlock_recipe_modifier_constant",
	"character_crafting_speed_modifier_icon",
	"character_crafting_speed_modifier_constant",
	"character_mining_speed_modifier_icon",
	"character_mining_speed_modifier_constant",
	"character_running_speed_modifier_icon",
	"character_running_speed_modifier_constant",
	"character_build_distance_modifier_icon",
	"character_build_distance_modifier_constant",
	"character_item_drop_distance_modifier_icon",
	"character_item_drop_distance_modifier_constant",
	"character_reach_distance_modifier_icon",
	"character_reach_distance_modifier_constant",
	"character_resource_reach_distance_modifier_icon",
	"character_resource_reach_distance_modifier_constant",
	"character_item_pickup_distance_modifier_icon",
	"character_item_pickup_distance_modifier_constant",
	"character_loot_pickup_distance_modifier_icon",
	"character_loot_pickup_distance_modifier_constant",
	"character_inventory_slots_bonus_modifier_icon", "character_inventory_slots_bonus_modifier_constant",
	"deconstruction_time_to_live_modifier_icon", "deconstruction_time_to_live_modifier_constant",
	"max_failed_attempts_per_tick_per_construction_queue_modifier_icon",
	"max_failed_attempts_per_tick_per_construction_queue_modifier_constant",
	"max_successful_attempts_per_tick_per_construction_queue_modifier_icon",
	"max_successful_attempts_per_tick_per_construction_queue_modifier_constant", "character_health_bonus_modifier_icon",
	"character_health_bonus_modifier_constant", "mining_drill_productivity_bonus_modifier_icon",
	"mining_drill_productivity_bonus_modifier_constant", "train_braking_force_bonus_modifier_icon",
	"train_braking_force_bonus_modifier_constant", "zoom_to_world_enabled_modifier_icon",
	"zoom_to_world_enabled_modifier_constant", "zoom_to_world_ghost_building_enabled_modifier_icon",
	"zoom_to_world_ghost_building_enabled_modifier_constant", "zoom_to_world_blueprint_enabled_modifier_icon",
	"zoom_to_world_blueprint_enabled_modifier_constant", "zoom_to_world_deconstruction_planner_enabled_modifier_icon",
	"zoom_to_world_deconstruction_planner_enabled_modifier_constant", "zoom_to_world_upgrade_planner_enabled_modifier_icon",
	"zoom_to_world_upgrade_planner_enabled_modifier_constant", "zoom_to_world_selection_tool_enabled_modifier_icon",
	"zoom_to_world_selection_tool_enabled_modifier_constant", "worker_robot_battery_modifier_icon",
	"worker_robot_battery_modifier_constant", "laboratory_productivity_modifier_icon",
	"laboratory_productivity_modifier_constant", "follower_robot_lifetime_modifier_icon",
	"follower_robot_lifetime_modifier_constant", "artillery_range_modifier_icon", "artillery_range_modifier_constant",
	"nothing_modifier_icon", "nothing_modifier_constant", "character_additional_mining_categories_modifier_icon",
	"character_additional_mining_categories_modifier_constant", "character_logistic_requests_modifier_icon",
	"character_logistic_requests_modifier_constant"
}
-- https://wiki.factorio.com/Types/Sprite
lazyAPI.all_common_sprite_fields = {
	"picture", "pictures", "active_picture", "arrow_picture", "circle_picture",
	"chart_picture", "shadow", "base_picture", "radius_visualisation_picture",
	"sprite", "out_of_ammo_alert_icon", "hand_base_picture", "hand_base_shadow",
	"hand_closed_picture", "hand_closed_shadow", "hand_open_picture",
	"hand_open_shadow", "picture_off", "picture_on", "picture_safe",
	"picture_set", "picture_set_enemy", "placeable_position_visualization",
	"led_off", "led_on", "heat_lower_layer_picture", "lower_layer_picture",
	"working_light_picture", "base", "base_patch", "base_day_sprite",
	"base_front_sprite", "base_night_sprite", "door_back_sprite",
	"door_front_sprite", "hole_light_sprite", "hole_sprite",
	"red_lights_back_sprites", "red_lights_front_sprites",
	"rocket_glow_overlay_sprite", "rocket_shadow_overlay_sprite",
	"shadow_sprite", "rocket_glare_overlay_sprite", "rocket_shadow_sprite",
	"rocket_sprite", "disabled_icon", "disabled_small_icon",
	"icon", "small_icon", "picture", "hr_version", "layers", "texture",
	"integration", "underground_remove_belts_sprite", "underground_sprite"
}

-- https://wiki.factorio.com/Types/SpriteVariations
lazyAPI.all_SpriteVariations_fields = {
	"single", "straight_vertical", "straight_horizontal", "corner_right_down",
	"corner_left_down", "t_up", "ending_right", "ending_left", "filling",
	"water_connection_patch", "gate_connection_patch"
}


-- https://wiki.factorio.com/Types/CollisionMask
lazyAPI.collision_mask_layers = {
	"ground_tile", "water_tile", "resource", "doodad",
	"floor", "rail", "transport_belt", "item",
	"ghost", "object", "player", "train",
}
for i=13, 55 do
	table.insert(lazyAPI.collision_mask_layers, "layer-" .. i)
end

-- https://wiki.factorio.com/Types/CollisionMask
lazyAPI.collision_mask_options = {
	"not-colliding-with-itself", "consider-tile-transitions", "colliding-with-tiles-only"
}

-- https://wiki.factorio.com/Types/WireConnectionPoint
lazyAPI.circuit_wire_connection_point_fields = {
	"circuit_wire_connection_point", "left_wire_connection_point", "right_wire_connection_point"
}
lazyAPI.cardinal_directions = {
	"west", "east", "south", "north"
}


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
lazyAPI.all_turrets = {
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
	["legacy-curved-rail"] = data_raw["legacy-curved-rail"],
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
for turret_type, prototypes in pairs(lazyAPI.all_turrets) do
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
	["combat-robot-count-achievement"] = data_raw["combat-robot-count-achievement"],
	["construct-with-robots-achievement"] = data_raw["construct-with-robots-achievement"],
	["deconstruct-with-robots-achievement"] = data_raw["deconstruct-with-robots-achievement"],
	["deliver-by-robots-achievement"] = data_raw["deliver-by-robots-achievement"],
	["dont-build-entity-achievement"] = data_raw["dont-build-entity-achievement"],
	["dont-craft-manually-achievement"] = data_raw["dont-craft-manually-achievement"],
	["dont-use-entity-in-energy-production-achievement"] = data_raw["dont-use-entity-in-energy-production-achievement"],
	["complete-objective-achievement"] = data_raw["complete-objective-achievement"],
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
	["rts-tool"] = data_raw["rts-tool"],
	["tool"] = data_raw["tool"]
}
for selection_tool_type, prototypes in pairs(lazyAPI.all_selection_tools) do
	lazyAPI.all_items[selection_tool_type] = prototypes
end
for tool_type, prototypes in pairs(lazyAPI.all_tools) do
	lazyAPI.all_items[tool_type] = prototypes
end


---@type ZOlocale_util
local locale_util = require("static-libs/lualibs/locale")
---@type ZOversion_util
local version_util = require("static-libs/lualibs/version")
---@type MFlauxlib
local _lauxlib = require("static-libs/lualibs/lauxlib")


-- Add your functions in lazyAPI.add_extension(function) and
-- lazyAPI.wrap_prototype will pass wrapped prototype into your function
---@type function[]
local extensions = {}

--[[
lazyAPI.add_listener(action_name, types, name, func): boolean
lazyAPI.remove_listener(action_name, name)
Each event contains:\
	on_pre_prototype_removed: {prototype: table}\
	on_pre_new_prototype: {prototype: table}\
	on_new_prototype: {prototype: table}\
	on_pre_new_prototype_via_lazyAPI: {prototype: table}\
	on_new_prototype_via_lazyAPI: {prototype: table}\
	on_prototype_removed: {prototype: table}\
	on_prototype_renamed: {prototype: table, prev_name: string}\
	on_pre_prototype_replaced: {prototype: table, prev_instance: table}\
	on_prototype_replaced: {prototype: table, prev_instance: table}\
	on_prototype_changed: {prototype: table}\
	on_tag_added: {prototype: table, tag: string}\
	on_tag_removed: {prototype: table, alt_prototype: table}\
	on_new_alternative_prototype: {prototype: table, alt_prototype: table}\
	on_alternative_prototype_removed: {prototype: table, alt_prototype: table}\
	on_new_tier: {prototype: table, tier: table}\
	on_tier_removed: {tier_prototype: table, tier: table}\
	on_new_prototype_in_tier: {tier_prototype: table, prototype: table, tier: table}\
	on_prototype_removed_in_tier: {tier_prototype: table, prototype: table, tier: table}\
	on_prototype_replaced_in_tier: {tier_prototype: table, old_prototype: table, new_prototype: table, tier: table}\
	on_new_template: {template_type: string, template_name: string, new_prototype: table, template: easyTemplate}\
	on_pre_template_removed: {prev_template: easyTemplate, template_type: string, template_name: string}\
	on_new_prototype_from_template: {template_type: string, template_name: string, new_prototype: table, template: easyTemplate}\
]]
local listeners = {
	on_pre_prototype_removed = {},
	on_pre_new_prototype = {},
	on_new_prototype = {},
	on_pre_new_prototype_via_lazyAPI = {},
	on_new_prototype_via_lazyAPI = {},
	on_prototype_removed = {},
	on_prototype_renamed = {},
	on_pre_prototype_replaced = {},
	on_prototype_replaced = {},
	on_prototype_changed = {},
	on_tag_added = {},
	on_tag_removed = {},
	on_new_alternative_prototype = {},
	on_alternative_prototype_removed = {},
	on_new_tier = {},
	on_tier_removed = {},
	on_new_prototype_in_tier = {},
	on_prototype_removed_in_tier = {},
	on_prototype_replaced_in_tier = {},
	on_new_template = {},
	on_pre_template_removed = {},
	on_new_prototype_from_template = {}
}
local _subscriptions = {}
for k in pairs(listeners) do
	_subscriptions[k] = {}
end


-- It's weird and looks wrong but it should work
---@diagnostic disable-next-line: duplicate-set-field
data.extend = function(self, new_prototypes, ...)
	if type(new_prototypes) ~= "table" then
		add_prototypes(self, new_prototypes, ...) -- original data.extend
		return
	end

	-- Let's check if something will be overwritten
	for k, prototype in pairs(new_prototypes) do
		if type(k) == "number" and type(prototype) == "table" and prototype.type then
			local _type = prototype.type
			local name  = prototype.name
			data_raw[_type] = data_raw[_type] or {}
			lazyAPI.deleted_data[_type] = lazyAPI.deleted_data[_type] or {}

			local prev_instance = data_raw[_type][name]
			-- Perhaps it should verify this case later instead
			if prev_instance and prev_instance ~= prototype then
				lazyAPI.deleted_data[_type][prototype.name] = prototype -- TODO: recheck, perhaps I should use a metamethod instead

				local event_data = {prototype = prototype, prev_instance = prev_instance}
				lazyAPI.raise_event("on_pre_prototype_replaced", _type, event_data)
			else
				local event_data = {prototype = prototype}
				lazyAPI.raise_event("on_pre_new_prototype", prototype_type, event_data)
			end
		end
	end

	add_prototypes(self, new_prototypes, ...) -- original data.extend

	local current_mod_name = lazyAPI.get_current_mod()
	for k, prototype in pairs(new_prototypes) do
		if type(k) == "number" and type(prototype) == "table" and prototype.type then
			local prototypes_mod_source = lazyAPI.prototypes_mod_source
			local mod_name = prototypes_mod_source[prototype]
			if mod_name == nil then
				prototypes_mod_source[prototype] = current_mod_name
			end

			local prototype_type = prototype.type
			local name = prototype.name
			local is_added = (data_raw[prototype_type][name] == prototype)
			if is_added then
				local removed_prot = lazyAPI.deleted_data[prototype_type][name]
				if removed_prot == prot then
					lazyAPI.deleted_data[prototype_type][name] = nil
				end

				local event_data = {prototype = prototype}
				lazyAPI.raise_event("on_new_prototype", prototype_type, event_data)
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


lazyAPI.array_to_locale = locale_util.array_to_locale
lazyAPI.array_to_locale_as_new = locale_util.array_to_locale_as_new
lazyAPI.locale_to_array = locale_util.locale_to_array
lazyAPI.merge_locales = locale_util.merge_locales
lazyAPI.merge_locales_as_new = locale_util.merge_locales_as_new


lazyAPI.setting_stages = {
	["settings"] = 1,
	["settings-updates"] = 2,
	["settings-final-fixes"] = 3,
}
lazyAPI.data_stages = {
	["data"] = 1,
	["data-updates"] = 2,
	["data-final-fixes"] = 3,
}
local _current_stage = 1
if not IS_SETTING_STAGE then
	---@return 1|1.5|2|2.5|3 # (by default) 1: data, 2: data-updates, 3: data-final-fixes, 1.5, 2.5, 3.5 etc: for undetermined cases between stages
	---[View Factorio lifecycle](https://lua-api.factorio.com/latest/Data-Lifecycle.html)
	lazyAPI.get_stage = function()
		local source = _lauxlib.get_first_lua_func_info().source
		-- must start with an @ which indicates that it is a file name
		if not source:find("^@") then
			if _current_stage == lazyAPI.data_stages["data-final-fixes"] then
				return _current_stage
			end
			return _current_stage + 0.5
		end

		-- %f[^/\0] is a frontier pattern matching anywhere
		-- right past a / or at the beginning of the string
		-- extra non escaped dot at the end to make sure
		-- the file has any extension
		if _current_stage == lazyAPI.data_stages["data-final-fixes"] then
			return lazyAPI.data_stages["data-final-fixes"]
		elseif _current_stage < lazyAPI.data_stages["data-updates"]
			and source:find("%f[^/\0]data%..")
		then
			_current_stage = lazyAPI.data_stages["data"]
			return _current_stage
		elseif _current_stage < lazyAPI.data_stages["data-final-fixes"]
			and source:find("%f[^/\0]data%-updates%..")
		then
			_current_stage = lazyAPI.data_stages["data-updates"]
			return _current_stage
		elseif _current_stage < lazyAPI.data_stages["data-final-fixes"] + 1
			and source:find("%f[^/\0]data%-final%-fixes%..")
		then
			_current_stage = lazyAPI.data_stages["data-final-fixes"]
			return _current_stage
		else
			return _current_stage + 0.5
		end
		-- patterns by JanSharp (https://github.com/JanSharp/phobos/issues/4)
	end
else
	---@return 1|1.5|2|2.5|3 # (by default) 1: settings, 2: settings-updates, 3: settings-final-fixes, 1.5, 2.5, 3.5 etc: for undetermined cases between stages
	---[View Factorio lifecycle](https://lua-api.factorio.com/latest/Data-Lifecycle.html)
	lazyAPI.get_stage = function()
		local source = _lauxlib.get_first_lua_func_info().source
		-- must start with an @ which indicates that it is a file name
		if not source:find("^@") then
			if _current_stage == lazyAPI.setting_stages["settings-final-fixes"] then
				return _current_stage
			end
			return _current_stage + 0.5
		end

		-- %f[^/\0] is a frontier pattern matching anywhere
		-- right past a / or at the beginning of the string
		-- extra non escaped dot at the end to make sure
		-- the file has any extension
		if _current_stage == lazyAPI.setting_stages["settings-final-fixes"] then
			return _current_stage
		elseif _current_stage < lazyAPI.setting_stages["settings-updates"]
			and source:find("%f[^/\0]settings%..")
		then
			return lazyAPI.setting_stages["settings"]
		elseif _current_stage < lazyAPI.setting_stages["settings-final-fixes"]
			and source:find("%f[^/\0]settings%-updates%..")
		then
			_current_stage = lazyAPI.setting_stages["settings-updates"]
			return _current_stage
		elseif _current_stage < lazyAPI.setting_stages["settings-final-fixes"] + 1
			and source:find("%f[^/\0]settings%-final%-fixes%..")
		then
			_current_stage = lazyAPI.setting_stages["settings-final-fixes"]
			return _current_stage
		else
			return _current_stage + 0.5
		end
		-- patterns by JanSharp (https://github.com/JanSharp/phobos/issues/4)
	end
end

---@return string
lazyAPI.get_current_mod = function()
	local f_info = _lauxlib.get_first_lua_func_info()
  	-- spaces in mod names for legacy support
	return f_info.source:match("^@__([a-zA-Z0-9 _-]-)__") or "?"
	-- Got some help from JanSharp (https://github.com/JanSharp/phobos/issues/4)
end

---@param event_name string
---@param prototype_type string
---@param event_data table
lazyAPI.raise_event = function(event_name, prototype_type, event_data)
	local subscription_group = _subscriptions[event_name]
	if subscription_group[prototype_type] then
		for _, func in pairs(subscription_group[prototype_type]) do
			func(event_data)
		end
	end
	if subscription_group.all then
		for _, func in pairs(subscription_group.all) do
			func(event_data)
		end
	end
end


---@type table<string, integer>
local memorized_versions = {}
tmemoize(memorized_versions, version_util.string_to_version)
-- Supports strings like: "5", "5.5", "5.5.5"
---@param str string
---@return integer #version
---@overload fun()
lazyAPI.string_to_version = function(str)
	return memorized_versions[str]
end

---@param mod_name string
---@return integer? #version
---@overload fun()
lazyAPI.get_mod_version = function(mod_name)
	local str_version = mods[mod_name]
	if str_version then
		return memorized_versions[str_version]
	end
end


---@param data table|LAPIWrappedPrototype
---@param new_data table
lazyAPI.override_data = function(data, new_data)
	if type(new_data) == "table" then
		for key, new_value in pairs(new_data) do
			if type(new_value) == "table" then
				data[key] = deepcopy(new_value)
			else
				data[key] = new_value
			end
		end
	else
		error("ERROR: new_data has invalid type")
	end
end

---@param str string
---@return string
lazyAPI.format_special_symbols = function(str)
	return strings_for_patterns[str]
end

---@param path string
---@return Sprite?
lazyAPI.get_sprite_by_path = function(path)
	return lazyAPI.sprite_by_path[path]
end

---@param box BoundingBox?
---@param value number
---@return BoundingBox?
lazyAPI.expand_bounding_box = function(box, value)
	if box == nil then return end

	local leftTop = box[1]
	local rightBottom = box[2]
	value = value * 0.5
	leftTop[1] = leftTop[1] + value
	leftTop[2] = leftTop[2] + value
	rightBottom[1] = rightBottom[1] + value
	rightBottom[2] = rightBottom[2] + value

	return box
end
lazyAPI.increase_bounding_box = lazyAPI.expand_bounding_box

---@param box BoundingBox?
---@param value number
---@return BoundingBox?
lazyAPI.decrease_bounding_box = function(box, value)
	if box == nil then return end

	local leftTop = box[1]
	local rightBottom = box[2]
	value = value * 0.5
	leftTop[1] = leftTop[1] - value
	leftTop[2] = leftTop[2] - value
	rightBottom[1] = rightBottom[1] - value
	rightBottom[2] = rightBottom[2] - value

	return box
end

---@param box BoundingBox?
---@param value number
---@return BoundingBox?
lazyAPI.multiply_bounding_box = function(box, value)
	if box == nil then return end

	local leftTop = box[1]
	local rightBottom = box[2]
	leftTop[1] = leftTop[1] * value
	leftTop[2] = leftTop[2] * value
	rightBottom[1] = rightBottom[1] * value
	rightBottom[2] = rightBottom[2] * value

	return box
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
				lazyAPI._warning_for_fixed_tables[array] = _warning_types.table_has_gaps
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
				lazyAPI._warning_for_fixed_tables[t] = _warning_types.table_has_gaps
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
			lazyAPI._warning_for_fixed_tables[t] = _warning_types.mixed_array
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
			lazyAPI._warning_for_fixed_tables[t] = _warning_types.mixed_array
		end
	end
	for i=1, #temp_arr do
		t[#t+1] = temp_arr[i]
	end
	return len_before + 1
end
lazyAPI.fix_table = lazyAPI.fix_messy_table
local fix_messy_table = lazyAPI.fix_messy_table


-- TODO: refactor
---@param prot table
---@param fluid_box table
---@param scale number
---@param prev_collision_box table
---@param sprite_fields string|string[]?
lazyAPI.scale_pipes = function(prot, fluid_box, scale, prev_collision_box, sprite_fields)
	if scale == nil then
		error("scale is nil")
		return
	end

	if sprite_fields == nil then
		sprite_fields = {"pipe_picture", "pipe_covers"}
	elseif type(sprite_fields) == "string" then
		sprite_fields = {sprite_fields} -- TODO: refactor
		---@cast sprite_fields string[]
	end

	for _, sprite_field in pairs(sprite_fields) do
		local _data = fluid_box[sprite_field]
		if _data then
			_data = table.deepcopy(_data)
			fluid_box[sprite_field] = _data

			for _, direction in ipairs(lazyAPI.cardinal_directions) do
				if _data[direction] then
					_data[direction] = table.deepcopy(_data[direction])
					lazyAPI.scale_pipe_sprite(_data[direction], scale)
				end
			end
			if _data.sheet then
				_data.sheet = table.deepcopy(_data.sheet)
				lazyAPI.scale_sprite(_data.sheet, scale)
			end
			if _data.sheets then
				_data.sheets = table.deepcopy(_data.sheets)
				for _, sprite in pairs(_data.sheets) do
					lazyAPI.scale_sprite(sprite, scale)
				end
			end
		end
	end

	local function change_pipe_position(position)
		local left_top_x_diff = position[1] + prev_collision_box[1][1]
		local left_top_y_diff = position[2] - prev_collision_box[1][2]
		local right_down_x_diff = position[1] + prev_collision_box[2][1]
		local right_down_y_diff = position[2] - prev_collision_box[2][2]
		if position[1] < 0 and position[1] < prev_collision_box[1][1] then
			position[1] = prot.collision_box[1][1] + left_top_x_diff
		elseif position[1] > prev_collision_box[2][1] then
			position[1] = prot.collision_box[2][1] + right_down_x_diff
		else
			position[1] = position[1] * scale
		end
		if position[2] < 0 and position[2] < prev_collision_box[1][2] then
			position[2] = prot.collision_box[1][2] + left_top_y_diff
		elseif position[2] > prev_collision_box[2][2] then
			position[2] = prot.collision_box[2][2] + right_down_y_diff
		else
			position[2] = position[2] * scale
		end
	end

	local pipe_connections = fluid_box.pipe_connections
	for _, pipe_connection in pairs(pipe_connections) do
		if pipe_connection.position then
			change_pipe_position(pipe_connection.position)
		end
		if pipe_connection.positions then
			for _, position in pairs(pipe_connection.positions) do
				change_pipe_position(position)
			end
		end
	end
end


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any
---@return integer? #index
---@overload fun(prototype, data): integer? #index
lazyAPI.base.find_in_array = function(source, field, data)
	if field == nil then error("Second parameter is nil") end
	local array
	if data then
		array = (source.prototype or source)[field]
	else
		data = field
		array = source
	end
	if array == nil then return end

	fix_array(array)
	for i=1, #array do
		if array[i] == data then
			return i
		end
	end
end
local find_in_array = lazyAPI.base.find_in_array


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any|any[]
---@return boolean
---@overload fun(prototype, data): boolean
lazyAPI.base.has_in_array = function(source, field, data)
	if field == nil then error("Second parameter is nil") end
	local array
	if data then
		array = (source.prototype or source)[field]
	else
		data = field
		array = source
	end
	if array == nil then return false end

	fix_array(array)
	if type(data) ~= "table" then
		for i=1, #array do
			if array[i] == data then
				return true
			end
		end
		return false
	end

	for i=1, #data do
		local target_data = data[i]
		for j=1, #array do
			if array[j] == target_data then
				goto has_data
			end
		end
		do return false end
		:: has_data ::
	end
	return true
end
local has_in_array = lazyAPI.base.has_in_array


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any
---@return table|LAPIWrappedPrototype, integer #source, removed_count
---@overload fun(prototype, data): table|LAPIWrappedPrototype, integer
---@overload fun(): nil, integer
lazyAPI.base.remove_from_array = function(source, field, data)
	if field == nil then error("Second parameter is nil") end
	local array
	if data then
		array = (source.prototype or source)[field]
	else
		data = field
		array = source
	end
	if array == nil then return source, 0 end

	fix_array(array)
	if type(data) ~= "table" then
		local removed_count = 0
		for i=#array, 1, -1 do
			if array[i] == data then
				tremove(array, i)
				removed_count = removed_count + 1
			end
		end
		return source, removed_count
	end

	local removed_count = 0
	for i=1, #data do
		local target_data = data[i]
		for j=#array, 1, -1 do
			if array[j] == target_data then
				tremove(array, i)
				removed_count = removed_count + 1
			end
		end
	end
	return source, removed_count
end
local remove_from_array = lazyAPI.base.remove_from_array


---@param source table|LAPIWrappedPrototype
---@param field any
---@param old_name any
---@param new_name any
---@return table|LAPIWrappedPrototype, boolean #source, is_replaced
---@overload fun(source, old_name, new_name): table|LAPIWrappedPrototype, boolean
---@overload fun()
lazyAPI.base.rename_in_array = function(source, field, old_name, new_name)
	if field == nil then error("Second parameter is nil") end
	local array
	if new_name then
		array = (source.prototype or source)[field]
	else
		new_name = old_name
		old_name = field
		array = source
	end
	if array == nil then return source, false end

	local is_replaced = false
	fix_array(array)
	for i=#array, 1, -1 do
		if array[i] == old_name then
			array[i] = new_name
			is_replaced = true
		end
	end
	return source, is_replaced
end
local rename_in_array = lazyAPI.base.rename_in_array
lazyAPI.base.replace_in_array = lazyAPI.base.rename_in_array


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any|any[]
---@return table|LAPIWrappedPrototype, boolean #source, is_added_new_data
---@overload fun(prototype, data): table, boolean
lazyAPI.base.add_to_array = function(source, field, data)
	if field == nil then error("Second parameter is nil") end
	local array
	if data then
		array = (source.prototype or source)[field]
		if array == nil then
			prot[field] = {data}
			return source, true
		end
	else
		data = field
		array = source
	end

	fix_array(array)
	if type(data) ~= "table" then
		for i=1, #array do
			if array[i] == data then
				return source, false
			end
		end

		array[#array+1] = data
		return source, true
	end

	local is_added_new_data = false
	for i=1, #data do
		local target_data = data[i]
		for j=1, #array do
			if array[j] == target_data then
				goto has_data
			end
		end
		is_added_new_data = true
		array[#array+1] = target_data
		:: has_data ::
	end

	return source, is_added_new_data
end
local add_to_array = lazyAPI.base.add_to_array


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any|any[]
---@param target_data any|any[]
---@return table|LAPIWrappedPrototype, integer? #source, (Last) index of new element(s)
---@overload fun(prototype, data, target_data): table, boolean
lazyAPI.base.insert_after_element = function(source, field, data, target_data)
	if field == nil then error("Second parameter is nil") end
	local array
	if target_data then
		array = (source.prototype or source)[field]
		if array == nil then
			return source
		end
	else
		target_data = data
		data = field
		array = source
	end

	fix_array(array)
	if type(data) ~= "table" then
		if type(target_data) ~= "table" then
			for i=1, #array do
				if array[i] == target_data then
					local iE = i+1
					table.insert(array, iE, data)
					return source, iE
				end
			end

			return source
		else
			fix_array(target_data)
			for i=1, #target_data do
				local _target_data = target_data[i]
				for j=1, #array do
					if array[j] == _target_data then
						local jE = j+1
						table.insert(array, jE, data)
						return source, jE
					end
				end
			end

			return source
		end
	end

	if type(target_data) ~= "table" then
		for i=1, #array do
			if array[i] == target_data then
				fix_array(data)
				local iE = i+#data -- WARNING: perhaps I should check on element existence
				for j=#data, 1, -1 do
					table.insert(array, i+1, data[j])
				end
				return source, iE
			end
		end
	else
		for i=1, #target_data do
			local _target_data = target_data[i]
			for j=1, #array do
				if array[j] == _target_data then
					fix_array(data)
					local jE = j+#data -- WARNING: perhaps I should check on element existence
					for j2=#data, 1, -1 do
						table.insert(array, j+1, data[j2])
					end
					return source, jE
				end
			end
		end
	end

	return source
end


---@param source table|LAPIWrappedPrototype
---@param field any
---@param data any|any[]
---@param target_data any|any[]
---@return table|LAPIWrappedPrototype, integer? #source, (Last) index of new element(s)
---@overload fun(prototype, data, target_data): table, boolean
lazyAPI.base.insert_before_element = function(source, field, data, target_data)
	if field == nil then error("Second parameter is nil") end
	local array
	if target_data then
		array = (source.prototype or source)[field]
		if array == nil then
			return source
		end
	else
		target_data = data
		data = field
		array = source
	end

	fix_array(array)
	if type(data) ~= "table" then
		if type(target_data) ~= "table" then
			for i=1, #array do
				if array[i] == target_data then
					table.insert(array, i, data)
					return source, i
				end
			end

			return source
		else
			fix_array(target_data)
			for i=1, #target_data do
				local _target_data = target_data[i]
				for j=1, #array do
					if array[j] == _target_data then
						table.insert(array, j, data)
						return source, j
					end
				end
			end

			return source
		end
	end

	if type(target_data) ~= "table" then
		for i=1, #array do
			if array[i] == target_data then
				fix_array(data)
				local iE = i+#data -- WARNING: perhaps I should check on element existence
				for j=#data, 1, -1 do
					table.insert(array, i, data[j])
				end
				return source, iE
			end
		end
	else
		for i=1, #target_data do
			local _target_data = target_data[i]
			for j=1, #array do
				if array[j] == _target_data then
					fix_array(data)
					local jE = j+#data -- WARNING: perhaps I should check on element existence
					for j2=#data, 1, -1 do
						table.insert(array, j, data[j2])
					end
					return source, jE
				end
			end
		end
	end

	return source
end


for _type, prototypes in pairs(data_raw) do
	lazyAPI.vanilla_data[_type] = lazyAPI.vanilla_data[_type] or {}
	local vanilla_prototypes = lazyAPI.vanilla_data[_type]
	for name, prototype in pairs(prototypes) do
		add_to_array(lazyAPI.all_data, prototype)
		vanilla_prototypes[name] = prototype
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param field any
---@param old_data any
---@param new_data any
---@return table|LAPIWrappedPrototype, boolean
lazyAPI.base.replace_in_prototype = function(prototype, field, old_data, new_data)
	local array = (prototype.prototype or prototype)[field]
	if array == nil then return prototype, false end

	local is_replaced = false
	fix_array(array)
	for i=1, #array do
		if array[i] == old_data then
			array[i] = new_data
			is_replaced = true
		end
	end
	return prototype, is_replaced
end
local replace_in_prototype = lazyAPI.base.replace_in_prototype


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
---@param prototype table|LAPIWrappedPrototype
---@return boolean
lazyAPI.base.is_cheat_prototype = function(prototype)
	local prot = prototype.prototype or prototype
	return lazyAPI.base.find_tags(prot, "cheat") or cheat_prototypes[prot] or false
end


---@param prototype table|LAPIWrappedPrototype
---@return table[]?
lazyAPI.base.get_alternative_prototypes = function(prototype)
	local prot = prototype.prototype or prototype
	return __all_alternative_prototypes[prot]
end


---@param prototype table|LAPIWrappedPrototype
---@param alt_prototypes table[]
---@return table|LAPIWrappedPrototype
lazyAPI.base.set_alternative_prototypes = function(prototype, alt_prototypes)
	if type(alt_prototypes) ~= "table" then
		error("lazyAPI.base.set_alternative_prototypes got incorrect data")
		return prototype
	end
	local prot = prototype.prototype or prototype
	__all_alternative_prototypes[prot] = {}
	lazyAPI.base.add_alternative_prototypes(prototype, alt_prototypes)
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param alt_prototypes table[]
---@return table|LAPIWrappedPrototype
lazyAPI.base.rawset_alternative_prototypes = function(prototype, alt_prototypes)
	if type(alt_prototypes) ~= "table" then
		error("lazyAPI.base.rawset_alternative_prototypes got incorrect data")
		return prototype
	end
	local prot = prototype.prototype or prototype
	fix_array(alt_prototypes)
	for i=1, #alt_prototypes do
		local alt_prototype = alt_prototypes[i]
		if prot.type ~= alt_prototype.type then
			error("Expected \"" .. prot.type .. "\" type for \"" .. alt_prototype.name  .. "\" prototype")
			return prototype
		end
	end
	__all_alternative_prototypes[prot] = alt_prototypes

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param alt_prototype table
---@return table|LAPIWrappedPrototype
lazyAPI.base.add_alternative_prototype = function(prototype, alt_prototype)
	if type(alt_prototype) ~= "table" then
		error("lazyAPI.base.add_alternative_prototype got incorrect data")
		return prototype
	end
	local prot = prototype.prototype or prototype
	if prot == alt_prototype then return prototype end
	if prot.type ~= alt_prototype.type then
		error("Expected \"" .. prot.type .. "\" type for \"" .. alt_prototype.name  .. "\" prototype")
		return prototype
	end
	local _, is_new = add_to_array(__all_alternative_prototypes, prot, alt_prototype)
	if is_new then
		local event_data = {prototype = prot, alt_prototype = alt_prototype}
		lazyAPI.raise_event("on_new_alternative_prototype", prot.type, event_data)
	end

	return prototype
end


--- TODO: recheck
---@param prototype table|LAPIWrappedPrototype
---@param alt_prototypes table[]
---@return table|LAPIWrappedPrototype
lazyAPI.base.add_alternative_prototypes = function(prototype, alt_prototypes)
	if type(alt_prototypes) ~= "table" then
		error("lazyAPI.base.add_alternative_prototypes got incorrect data")
		return prototype
	end
	local prot = prototype.prototype or prototype
	__all_alternative_prototypes[prot] = __all_alternative_prototypes[prot] or {}
	local _alt_prototypes = alt_prototypes[prot]
	fix_array(alt_prototypes)
	for i=1, #alt_prototypes do
		local alt_prototype = alt_prototypes[i]
		if alt_prototype ~= prot then
			if prot.type ~= alt_prototype.type then
				error("Expected \"" .. prot.type .. "\" type for \"" .. alt_prototype.name  .. "\" prototype")
				return prototype
			end
			local _, is_new = add_to_array(__all_alternative_prototypes, prot, alt_prototype)
			if is_new then
				local event_data = {prototype = prot, alt_prototype = alt_prototype}
				lazyAPI.raise_event("on_new_alternative_prototype", prot.type, event_data)
			end
			_, is_new = add_to_array(__all_alternative_prototypes, alt_prototype, prot)
			if is_new then
				local event_data = {prototype = alt_prototype, alt_prototype = prot}
				lazyAPI.raise_event("on_new_alternative_prototype", prot.type, event_data)
			end

			for j=1, #alt_prototypes do
				local alt_prototype2 = alt_prototypes[j]
				if alt_prototype2 ~= alt_prototype then
					_, is_new = add_to_array(__all_alternative_prototypes, alt_prototype, alt_prototype2)
					if is_new then
						local event_data = {prototype = alt_prototype2, alt_prototype = alt_prototype}
						lazyAPI.raise_event("on_new_alternative_prototype", prot.type, event_data)
					end
				end
			end
		end
	end

	if #_alt_prototypes == 0 then
		__all_alternative_prototypes[prot] = nil
	end
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param alt_prototype table
---@return table|LAPIWrappedPrototype
lazyAPI.base.remove_alternative_prototype = function(prototype, alt_prototype)
	if type(alt_prototype) ~= "table" then
		error("lazyAPI.base.remove_alternative_prototype got incorrect data")
		return prototype
	end
	local prot = prototype.prototype or prototype
	if prot == alt_prototype then return prototype end
	local _, removed_count = remove_from_array(__all_alternative_prototypes, prot, alt_prototype)
	if removed_count > 0 then
		local event_data = {prototype = prot, alt_prototype = alt_prototype}
		lazyAPI.raise_event("on_alternative_prototype_removed", prot.type, event_data)
		for _, v in pairs(__all_alternative_prototypes[prot]) do
			_, removed_count = remove_from_array(__all_alternative_prototypes, v, alt_prototype)
			if removed_count > 0 then
				local event_data2 = {prototype = v, alt_prototype = alt_prototype}
				lazyAPI.raise_event("on_alternative_prototype_removed", v.type, event_data2)
			end
		end
	end
	return prototype
end


---@param to_prototype table|LAPIWrappedPrototype
---@param from_prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.base.copy_icons = function(to_prototype, from_prototype)
	local to_prot = to_prototype.prototype or to_prototype
	local from_prot = from_prototype.prototype or from_prototype
	if to_prot == from_prot then return to_prototype end

	-- Perhaps, I should copy icons from shortcut prototypes etc.
	if from_prot.icons then
		to_prot.icons = table.deepcopy(from_prot.icons)
	else
		to_prot.icons = nil
	end
	if from_prot.dark_background_icons then
		to_prot.dark_background_icons = table.deepcopy(from_prot.dark_background_icons)
	else
		to_prot.dark_background_icons = nil
	end

	to_prot.dark_background_icon = from_prot.dark_background_icon
	to_prot.icon = from_prot.icon
	to_prot.icon_size = from_prot.icon_size
	to_prot.icon_mipmaps = from_prot.icon_mipmaps

	return to_prototype
end


---@param to_prototype table|LAPIWrappedPrototype
---@param from_prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.base.copy_sounds = function(to_prototype, from_prototype)
	local to_prot = to_prototype.prototype or to_prototype
	local from_prot = from_prototype.prototype or from_prototype
	if to_prot == from_prot then return to_prototype end

	for _, field_name in ipairs(lazyAPI.all_sound_fields) do
		if from_prot[field_name] then
			to_prot[field_name] = table.deepcopy(from_prot[field_name])
		else
			to_prot[field_name] = nil
		end
	end

	return to_prototype
end


-- Perhaps, it works wrong or/and doesn't copy all stuff. (I didn't test it at all)
---@param to_prototype table|LAPIWrappedPrototype
---@param from_prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.base.copy_graphics = function(to_prototype, from_prototype)
	local to_prot = to_prototype.prototype or to_prototype
	local from_prot = from_prototype.prototype or from_prototype
	if to_prot == from_prot then return to_prototype end

	local all_main_fields = {
		"all_common_sprite_fields", "all_utility_sprite_fields",
		"all_utility_animations_fields", "all_unique_sprite_fields",
		"all_spriteVariations_fields", "all_RenderLayer_fields",
		"all_unique_animation_fields", "all_Animation4Way_fields",
		"all_unique_Sprite4Way_fields", "all_LightDefinition_fields",
		"all_Sprite4Way_fields" --etc...
	}
	for _, main_field_name in ipairs(all_main_fields) do
		for _, field_name in ipairs(lazyAPI[main_field_name]) do
			if from_prot[field_name] then
				to_prot[field_name] = table.deepcopy(from_prot[field_name])
			else
				to_prot[field_name] = nil
			end
		end
	end

	return to_prototype
end


---@param prototype table|LAPIWrappedPrototype?
---@return string[]?
lazyAPI.base.get_tags = function(prototype)
	if not prototype then return end
	local prot = prototype.prototype or prototype
	local __data = lazyAPI.tags[prot.type]
	if __data then
		return __data[prot.name]
	end
end


---@param prototype table|LAPIWrappedPrototype?
---@param tags string|string[]
---@return boolean?
lazyAPI.base.find_tags = function(prototype, tags)
	if not prototype then return false end
	local prot = prototype.prototype or prototype
	local __data = lazyAPI.tags[prot.type]
	if __data == nil then
		return false
	end
	local name = prot.name
	local _tags = __data[name]
	if _tags == nil then
		return false
	end

	return has_in_array(__data, name, tags)
end


---@param prototype table|LAPIWrappedPrototype?
---@param tags string|string[]
---@return table|LAPIWrappedPrototype?
lazyAPI.base.add_tags = function(prototype, tags)
	if not prototype then return end
	local prot = prototype.prototype or prototype
	local __data = lazyAPI.tags[prot.type]
	if __data == nil then
		lazyAPI.tags[prot.type] = {}
		__data = lazyAPI.tags[prot.type]
	end
	local name = prot.name
	local _tags = __data[name]
	if _tags == nil then
		__data[name] = {}
		_tags = __data[name]
	end

	fix_array(_tags)
	if type(tags) ~= "table" then
		local tag = tags
		---@cast tag string
		for i=1, #_tags do
			if _tags[i] == tag then
				return prototype
			end
		end
		_tags[#_tags+1] = tag

		local event_data = {prototype = prototype, tag = tag}
		lazyAPI.raise_event("on_tag_added", prototype.type, event_data)

		return prototype
	end

	for i=1, #data do
		local tag = data[i]
		for j=1, #_tags do
			if _tags[j] == tag then
				goto has_data
			end
		end
		_tags[#_tags+1] = tag

		local event_data = {prototype = prototype, tag = tag}
		lazyAPI.raise_event("on_tag_added", prototype.type, event_data)

		:: has_data ::
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype?
---@param tags string|string[]
---@return table|LAPIWrappedPrototype?
lazyAPI.base.remove_tags = function(prototype, tags)
	if not prototype then return end
	local prot = prototype.prototype or prototype
	local __data = lazyAPI.tags[prot.type]
	if __data == nil then
		return prototype
	end
	local name = prot.name
	local _tags = __data[name]
	if _tags == nil then
		return prototype
	end

	fix_array(_tags)
	if type(tags) ~= "table" then
		local tag = tags
		---@cast tag string
		local is_tag_removed = false
		for i=#_tags, 1, -1 do
			if _tags[i] == tag then
				tremove(_tags, i)
				is_tag_removed = true
			end
		end
		if is_tag_removed then
			local event_data = {prototype = prototype, tag = tag}
			lazyAPI.raise_event("on_tag_removed", prototype.type, event_data)
		end
		return prototype
	end

	for i=1, #tags do
		local tag = tags[i]
		local is_tag_removed = false
		for j=#_tags, 1, -1 do
			if _tags[j] == tag then
				tremove(_tags, i)
				is_tag_removed = true
			end
		end
		if is_tag_removed then
			local event_data = {prototype = prototype, tag = tag}
			lazyAPI.raise_event("on_tag_removed", prototype.type, event_data)
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param size number
---@param sprite_fields string|string[]?
---@return table|LAPIWrappedPrototype
lazyAPI.base.scale_sprite = function(prototype, size, sprite_fields)
	if size == nil then
		error("size is nil")
		return prototype
	end

	if sprite_fields == nil then
		sprite_fields = lazyAPI.all_spriteVariations_fields
	elseif type(sprite_fields) == "string" then
		sprite_fields = {sprite_fields} -- TODO: refactor
		---@cast sprite_fields string[]
	end

	local prot = prototype.prototype or prototype

	for _, sprite_field in pairs(sprite_fields) do
		local sprite = prot[sprite_field]
		if sprite then
			sprite = table.deepcopy(sprite)
			prot[sprite_field] = sprite
			lazyAPI.scale_sprite(sprite, size)
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param size number
---@param sprite_fields string|string[]?
---@return table|LAPIWrappedPrototype
lazyAPI.base.scale_Animation4Way = function(prototype, size, sprite_fields)
	if size == nil then
		error("size is nil")
		return prototype
	end

	if sprite_fields == nil then
		sprite_fields = lazyAPI.all_Animation4Way_fields
	elseif type(sprite_fields) == "string" then
		sprite_fields = {sprite_fields} -- TODO: refactor
		---@cast sprite_fields string[]
	end

	local prot = prototype.prototype or prototype

	for _, sprite_field in pairs(sprite_fields) do
		local _data = prot[sprite_field]
		if _data then
			_data = table.deepcopy(_data)
			prot[sprite_field] = _data

			lazyAPI.scale_sprite(_data, size)

			for _, direction in ipairs(lazyAPI.cardinal_directions) do
				if _data[direction] then
					_data[direction] = table.deepcopy(_data[direction])
					lazyAPI.scale_sprite(_data[direction], size)
				end
			end
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param size number
---@param sprite_fields string|string[]?
---@return table|LAPIWrappedPrototype
lazyAPI.base.scale_Sprite4Way = function(prototype, size, sprite_fields)
	if size == nil then
		error("size is nil")
		return prototype
	end

	if sprite_fields == nil then
		sprite_fields = lazyAPI.all_Sprite4Way_fields
	elseif type(sprite_fields) == "string" then
		sprite_fields = {sprite_fields} -- TODO: refactor
		---@cast sprite_fields string[]
	end

	local prot = prototype.prototype or prototype

	for _, sprite_field in pairs(sprite_fields) do
		local _data = prot[sprite_field]
		if _data then
			_data = table.deepcopy(_data)
			prot[sprite_field] = _data

			for _, direction in ipairs(lazyAPI.cardinal_directions) do
				if _data[direction] then
					_data[direction] = table.deepcopy(_data[direction])
					lazyAPI.scale_sprite(_data[direction], size)
				end
			end
			if _data.sheet then
				_data.sheet = table.deepcopy(_data.sheet)
				lazyAPI.scale_sprite(_data.sheet, size)
			end
			if _data.sheets then
				_data.sheets = table.deepcopy(_data.sheets)
				for _, sprite in pairs(_data.sheets) do
					lazyAPI.scale_sprite(sprite, size)
				end
			end
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param size number
---@param sprite_fields string|string[]?
---@return table|LAPIWrappedPrototype
function lazyAPI.base.scale_SpriteVariations(prototype, size, sprite_fields)
	if size == nil then
		error("size is nil")
		return prototype
	end

	local prot = prototype.prototype or prototype
	local pictures = prot.pictures
	if pictures == nil then return prototype end

	if sprite_fields == nil then
		sprite_fields = lazyAPI.all_SpriteVariations_fields
	elseif type(sprite_fields) == "string" then
		sprite_fields = {sprite_fields} -- TODO: refactor
		---@cast sprite_fields string[]
	end


	for _, sprite_field in pairs(sprite_fields) do
		local sprite = pictures[sprite_field]
		if sprite then
			sprite = table.deepcopy(sprite)
			pictures[sprite_field] = sprite
			lazyAPI.scale_sprite(sprite, size)
		end
	end

	return prototype
end


-- TODO: event_name should be string|string[]
---@param event_name string #name of an event
---@param types string|string[] #https://wiki.factorio.com/data_raw or "all"
---@param name string #name of your listener
---@param func function #your function
---@return boolean #is added?
lazyAPI.add_listener = function(event_name, types, name, func)
	if types == nil then return false end
	if type(types) == "table" then
		if next(types) == nil then
			return false
		end
	else
		types = {types}
	end

	for _, listener in ipairs(listeners[event_name]) do
		if listener.name == name then
			return false
		end
	end

	table.insert(
		listeners[event_name],
		{
			name = name,
			types = types,
			action_name = event_name,
			func = func
		}
	)
	for _, _type in ipairs(types) do
		_subscriptions[event_name][_type] = _subscriptions[event_name][_type] or {}
		local subscription_group = _subscriptions[event_name][_type]
		table.insert(subscription_group, func)
	end
	return true
end


lazyAPI.add_listener("on_new_prototype", "all", "lazyAPI_store_prototype", function(event)
	add_to_array(lazyAPI.all_data, event.prototype)
end)
lazyAPI.add_listener("on_new_prototype_via_lazyAPI", "all", "lazyAPI_store_prototype", function(event)
	add_to_array(lazyAPI.all_data, event.prototype)
end)
lazyAPI.add_listener("on_prototype_removed", "all", "lazyAPI_store_removed_prototype", function(event)
	local prototype = event.prototype
	add_to_array(lazyAPI.all_data, prototype)
	local all_deleted_prototypes = lazyAPI.deleted_data[prototype.type]
	if all_deleted_prototypes then
		all_deleted_prototypes[prototype.name] = prototype
	end
end)
-- TODO: recheck
lazyAPI.add_listener("on_alternative_prototype_removed", "all", "lazyAPI_store_removed_prototype", function(event)
	local prototype = event.prototype
	add_to_array(lazyAPI.all_data, prototype)
	local all_deleted_prototypes = lazyAPI.deleted_data[prototype.type]
	if all_deleted_prototypes then
		all_deleted_prototypes[prototype.name] = prototype
	end
end)


lazyAPI.add_listener("on_prototype_removed", "technology", "lazyAPI_remove_technology", function(event)
	local prototype = event.prototype
	local tech_name = prototype.name

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
lazyAPI.add_listener("on_prototype_removed", "recipe", "lazyAPI_remove_recipe", function(event)
	local prototype = event.prototype
	local recipe_name = prototype.name

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
lazyAPI.add_listener("on_prototype_removed", "fluid", "lazyAPI_remove_fluid", function(event)
	lazyAPI.remove_fluid(event.prototype.name)
end)
lazyAPI.add_listener("on_prototype_removed", "tool", "lazyAPI_remove_tool", function(event)
	lazyAPI.remove_tool_everywhere(event.prototype.name)
end)
lazyAPI.add_listener("on_prototype_renamed", "tool", "lazyAPI_rename_tool", function(event)
	local prototype = event.prototype
	lazyAPI.rename_tool(event.prev_name, prototype.name)
end)
lazyAPI.add_listener("on_prototype_removed", "underground-belt", "lazyAPI_remove_underground-belt", function(event)
	local underground_belt_name = event.prototype.name
	for _, belt in pairs(data_raw["transport-belt"]) do
		if belt.related_underground_belt == underground_belt_name then
			belt.related_underground_belt = nil
		end
	end
end)
lazyAPI.add_listener("on_prototype_removed", "assembling-machine", "lazyAPI_remove_assembling-machine", function(event)
	local machine_name = event.prototype.name
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
lazyAPI.add_listener("on_prototype_removed", "armor", "lazyAPI_remove_armor", function(event)
	local armor_name = event.prototype.name
	for _, character in pairs(data_raw.character) do
		lazyAPI.character.remove_armor(character, armor_name)
	end
end)
lazyAPI.add_listener("on_prototype_removed", "tips-and-tricks-item", "lazyAPI_remove_tips-and-tricks-item", function(event)
	local tt_name = event.prototype.name
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

lazyAPI.add_listener("on_prototype_removed", "tile", "lazyAPI_remove_tile", function(event)
	lazyAPI.remove_tile(event.prototype.name)
end)
lazyAPI.add_listener("on_prototype_removed", "equipment-grid", "lazyAPI_remove_equipment-grid", function(event)
	local EGrid_name = event.prototype.name
	for _, prototypes in pairs(lazyAPI.all_vehicles) do
		for _, vehicle in pairs(prototypes) do
			if vehicle.equipment_grid == EGrid_name then
				vehicle.equipment_grid = nil
			end
		end
	end
end)
lazyAPI.add_listener("on_prototype_renamed", "equipment-grid", "lazyAPI_rename_equipment-grid", function(event)
	local prev_name = event.prev_name
	local new_name = event.prototype.name
	for _, prototypes in pairs(lazyAPI.all_vehicles) do
		for _, vehicle in pairs(prototypes) do
			if vehicle.equipment_grid == prev_name then
				vehicle.equipment_grid = new_name
			end
		end
	end
end)
lazyAPI.add_listener("on_prototype_removed", "optimized-decorative", "lazyAPI_remove_optimized-decorative", function(event)
	local decorative_name = event.prototype.name
	for _, prototypes in pairs(lazyAPI.all_turrets) do
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
lazyAPI.add_listener("on_prototype_removed", "virtual-signal", "lazyAPI_remove_virtual-signal", function(event)
	local vSignal_name = event.prototype.name
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
lazyAPI.add_listener("on_prototype_removed", "unit", "lazyAPI_remove_unit", function(event)
	local unit_name = event.prototype.name
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
lazyAPI.add_listener("on_prototype_renamed", "unit", "lazyAPI_rename_unit", function(event)
	local prev_name = event.prev_name
	local new_name = event.prototype.name
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
lazyAPI.add_listener("on_prototype_removed", "resource", "lazyAPI_remove_resource", function(event)
	local resource_name = event.prototype.name
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
	--- TODO: recheck, perhaps, I should check all data
	if type(next(action_delivery)) == "number" then
		fix_messy_table(action_delivery)
		for i=#action_delivery, 1, -1 do
			lazyAPI.remove_entity_from_action_delivery(action, action_delivery[i], entity_name)
		end
	else
		lazyAPI.remove_entity_from_action_delivery(action, action_delivery, entity_name)
	end
end
lazyAPI.add_listener("on_prototype_removed", "all", "lazyAPI_remove_explosions", function(event)
	local prototype = event.prototype
	local prototype_name = prototype.name
	local _type = prototype.type
	if lazyAPI.all_explosions[_type] then
		for _, prototypes in pairs(lazyAPI.all_entities) do
			for _, entity in pairs(prototypes) do
				if entity.dying_explosion == prototype_name then
					entity.dying_explosion = nil
				end
			end
		end
		return
	end

	if lazyAPI.all_entities[_type] then
		for _, item in pairs(data_raw.item) do
			if item.place_result == prototype_name then
				item.place_result = nil
			end
		end
	end
end)
lazyAPI.add_listener("on_prototype_renamed", "all", "lazyAPI_rename_explosions", function(event)
	local prototype = event.prototype
	local prev_name = event.prev_name
	local new_name = event.prototype.name
	if not lazyAPI.all_explosions[prototype.type] then return end

	for _, prototypes in pairs(lazyAPI.all_entities) do
		for _, entity in pairs(prototypes) do
			if entity.dying_explosion == prev_name then
				entity.dying_explosion = new_name
			end
		end
	end
end)
lazyAPI.add_listener("on_prototype_removed", "all", "lazyAPI_remove_entities", function(event)
	local prototype = event.prototype
	local entity_name = prototype.name
	local entity_type = prototype.type
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
lazyAPI.add_listener("on_prototype_removed", "all", "lazyAPI_remove_equipments", function(event)
	local prototype = event.prototype
	local equipment_type = prototype.name
	local equipment_name = prototype.type
	if not lazyAPI.all_equipments[equipment_type] then return end

	lazyAPI.remove_items_by_equipment(equipment_name)

	for _, capsule in pairs(data_raw.capsule) do
		local capsule_action = capsule.capsule_action
		if capsule_action and capsule_action.equipment == equipment_name then
			lazyAPI.base.remove_prototype(capsule)
		end
	end
end)


lazyAPI.add_listener("on_prototype_removed", {"all"}, "lazyAPI_remove_turrets", function(event)
	local prototype = event.prototype
	local turret_type = prototype.name
	local turret_name = prototype.type
	if not lazyAPI.all_turrets[turret_type] then return end

	for _, technology in pairs(technologies) do
		lazyAPI.tech.remove_effect_everywhere(technology, "turret-attack", turret_name)
	end
end)
lazyAPI.add_listener("on_prototype_removed", "all", "lazyAPI_remove_items", function(event)
	local prototype = event.prototype
	local item_type = prototype.name
	local item_name = prototype.type
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
				local funks = _subscriptions[action_name][type]
				for j=1, #funks do
					if funks[j] == listener.func then
						tremove(_subscriptions[action_name][type], j)
						break
					end
				end
				if #funks == 0 then
					_subscriptions[action_name][type] = nil
				end
			end
			return
		end
	end
end


--- NOT RELIABLE AT ALL
---@param name string #barrel name without prefix
---@return table, table #filled_barrel, empty_barrel
lazyAPI.get_barrel_recipes = function(name)
	return recipes["fill-" .. name], recipes["empty-" .. name]
end


---@param name string
lazyAPI.remove_entities_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_entities) do
		local entity = prototypes[name]
		if entity then
			lazyAPI.base.remove_prototype(entity)
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
		local entity = prototypes[name]
		if entity then
			result[#result+1] = entity
		end
	end
	return result
end


---@param name string
lazyAPI.remove_items_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_items) do
		local item = prototypes[name]
		if item then
			lazyAPI.base.remove_prototype(item)
		end
	end
end


---@param name string
---@return boolean
lazyAPI.has_items_by_name = function(name)
	for _, prototypes in pairs(lazyAPI.all_items) do
		if prototypes[name] then
			return true
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
---@return table, table #capsule, projectile
lazyAPI.create_trigger_capsule = function(tool_data)
	local name = tool_data.name
	local flags = tool_data.flags
	if flags == nil then
		if tool_data.stack_size and tool_data.stack_size > 1 then
			flags = {"only-in-cursor"}
		else
			flags = {"not-stackable", "only-in-cursor"}
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
			hidden = true,
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
---@param trigger_radius number?
lazyAPI.create_invisible_mine = function(name, trigger_radius)
	trigger_radius = trigger_radius or 1
	local prototype_data = {
		icon = "__base__/graphics/icons/land-mine.png",
		icon_size = 64, icon_mipmaps = 4,
		flags = {
			"placeable-enemy",
			"placeable-off-grid",
			"not-on-map",
			"not-selectable-in-game",
			"not-in-kill-statistics",
			"not-in-made-in",
			"not-blueprintable",
			"not-deconstructable",
			"hide-alt-info",
			"not-flammable"
		},
		hidden = true,
		max_health = 15,
		trigger_radius = trigger_radius,
		picture_safe = lazyAPI.get_sprite_by_path("__core__/graphics/empty.png"),
		picture_set = lazyAPI.get_sprite_by_path("__core__/graphics/empty.png")
	}

	return lazyAPI.add_prototype("land-mine", name, prototype_data)
end

---@param name string
---@param max_level integer?
---@param tech_data table
---@return table, table[] #main_tech, techs
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
---@return table #CustomInput
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
	local remove_prototype = lazyAPI.base.remove_prototype
	for _, prototypes in pairs(lazyAPI.all_items) do
		for _, item in pairs(prototypes) do
			if item.place_result == entity_name then
				remove_prototype(item)
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
			if item.place_as_equipment_result == equipment_name then
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
			if item.place_as_equipment_result == equipment_name then
				item.place_as_equipment_result = new_equipment_name
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
			lazyAPI.recipe.remove_if_no_result(recipe)
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
			lazyAPI.recipe.remove_if_no_result(recipe)
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
		return not lazyAPI.has_items_by_name(name)
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


---@param product table #https://wiki.factorio.com/Types/ProductPrototype or https://wiki.factorio.com/Types/IngredientPrototype
---@return boolean
lazyAPI.is_product_valid = function(product)
	if product.type ~= "fluid" then -- item
		return lazyAPI.has_items_by_name(product.name)
	else
		return (data_raw.fluid[product.name] ~= nil)
	end
end


---@param product table #https://wiki.factorio.com/Types/ProductPrototype or https://wiki.factorio.com/Types/IngredientPrototype
---@return table[]? #Array of https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
lazyAPI.find_prototypes_by_product = function(product)
	if product.type == "item" then
		return lazyAPI.find_items_by_name(product.name)
	else -- TODO: recheck
		local fluid = data_raw.fluid[product.name]
		if fluid then
			return {fluid}
		end
		return
	end
end

-- INSTABLE!!! Doesn't create new prototype!
---@param prototype table|LAPIWrappedPrototype
lazyAPI.make_fake_simple_entity_with_owner = function(prototype)
  prototype.energy_source = nil
  prototype.energy_usage = nil
  prototype.animations = nil
  prototype.vector_to_place_result = nil
  prototype.mining_speed = nil
  prototype.resource_searching_radius = nil
  prototype.allowed_effects = nil
  prototype.base_productivity = nil
  prototype.resource_categories = nil
  prototype.resource_searching_radius = nil
  prototype.output_fluid_box = nil
  prototype.radius_visualisation_picture = nil
  prototype.monitor_visualization_tint = nil
  prototype.graphics_set = nil -- TODO: check
  prototype.wet_mining_graphics_set = nil
  prototype.module_specification = nil
  prototype.circuit_connector_sprites = nil
  prototype.circuit_wire_connection_points = nil
  prototype.circuit_wire_max_distance = nil
  prototype.input_fluid_box = nil
  prototype.draw_copper_wires = nil
  prototype.draw_circuit_wires = nil
  prototype.picture = prototype.base_picture -- TODO: check
  prototype.base_picture = nil
  prototype.base_render_layer = nil -- TODO: check
end


---@class prototype_filter
---@field type string|string[]?
---@field name string|string[]?
---@field limit integer?
---@field invert boolean? #Whether the filters should be inverted


---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_names = function(prototype_filter, results)
	local target_names = prototype_filter.name
	---@cast target_names string[]
	if prototype_filter.invert then
		for _, prototypes in (data_raw) do
			for _, prototype in (prototypes) do
				if not has_in_array(prototype_filter, "name", prototype.name) then
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	else
		for _, prototypes in (data_raw) do
			for _, prototype_name in (target_names) do
				local prototype = prototypes[prototype_name]
				if prototype then
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_types_and_names = function(prototype_filter, results)
	local target_types = prototype_filter.type
	---@cast target_types string[]
	local target_names = prototype_filter.name
	---@cast target_names string[]
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if not has_in_array(prototype_filter, "type", _type) then
				for _, prototype in (prototypes) do
					if not has_in_array(target_names, "name", prototype.name) then
						results[#results+1] = prototype
						if prototype_filter.limit and #results >= prototype_filter.limit then
							return
						end
					end
				end
			end
		end
	else
		for _, _type in (target_types) do
			for _, prototypes in (data_raw[_type]) do
				for _, prototype in (prototypes) do
					if has_in_array(target_names, "name", prototype.name) then -- TODO: improve
						results[#results+1] = prototype
						if prototype_filter.limit and #results >= prototype_filter.limit then
							return
						end
					end
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_types_and_name = function(prototype_filter, results)
	local target_types = prototype_filter.type
	---@cast target_types string[]
	local target_name = prototype_filter.name
	---@cast target_name string
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if not has_in_array(prototype_filter, "type", _type) then
				for _, prototype in (prototypes) do
					if prototype.name ~= target_name then
						results[#results+1] = prototype
						if prototype_filter.limit and #results >= prototype_filter.limit then
							return
						end
					end
				end
			end
		end
	else
		for _, _type in (target_types) do
			for _, prototypes in (data_raw[_type]) do
				local prototype = prototypes[target_name]
				if prototype then
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_types = function(prototype_filter, results)
	local target_types = prototype_filter.type
	---@cast target_types string[]
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if not has_in_array(prototype_filter, "type", _type) then
				for _, prototype in (prototypes) do
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	else
		for _, _type in (target_types) do
			for _, prototypes in (data_raw[_type]) do
				for _, prototype in (prototypes) do
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_name = function(prototype_filter, results)
	local target_name = prototype_filter.name
	---@cast target_name string
	if prototype_filter.invert then
		for _, prototypes in (data_raw) do
			for _, prototype in (prototypes) do
				if prototype.name ~= target_name then
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return
					end
				end
			end
		end
	else
		for _, prototypes in (data_raw) do
			local prototype = prototypes[target_name]
			if prototype then
				results[#results+1] = prototype
				if prototype_filter.limit and #results >= prototype_filter.limit then
					return
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_type_and_names = function(prototype_filter, results)
	local target_type = prototype_filter.type
	---@cast target_type string
	local target_names = prototype_filter.name
	---@cast target_names string[]
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if _type ~= target_type then
				for _, prototype in (prototypes) do
					if not has_in_array(prototype_filter, "name", prototype.name) then
						results[#results+1] = prototype
						if prototype_filter.limit and #results >= prototype_filter.limit then
							return
						end
					end
				end
			end
		end
		return
	end
	for _, prototypes in (data_raw[target_type]) do
		for _, prototype_name in (target_names) do
			local prototype = prototypes[prototype_name]
			if prototype then
				results[#results+1] = prototype
				if prototype_filter.limit and #results >= prototype_filter.limit then
					return
				end
			end
		end
	end
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_type_and_name = function(prototype_filter, results)
	local target_type = prototype_filter.type
	---@cast target_type string
	local target_name = prototype_filter.name
	---@cast target_name string
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if _type ~= target_type then
				for _, prototype in (prototypes) do
					if prototype.name ~= target_name then
						results[#results+1] = prototype
						if prototype_filter.limit and #results >= prototype_filter.limit then
							return
						end
					end
				end
			end
		end
		return
	end
	local prototypes = data_raw[target_type]
	if prototypes == nil then return end
	local prototype = prototypes[target_name]
	if prototype == nil then return end
	results[#results+1] = prototype
end

---@param prototype_filter prototype_filter
---@param results table
local find_prototypes_by_type = function(prototype_filter, results)
	local target_type = prototype_filter.type
	---@cast target_type string
	if prototype_filter.invert then
		for _type, prototypes in (data_raw) do
			if _type ~= target_type then
				for _, prototype in (prototypes) do
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return results
					end
				end
			end
		end
	else
		for _, prototypes in (data_raw[target_type]) do
			for _, prototype in (prototypes) do
				if prototype then
					results[#results+1] = prototype
					if prototype_filter.limit and #results >= prototype_filter.limit then
						return results
					end
				end
			end
		end
	end
end


---@param prototype_filter prototype_filter
---@return table[]
lazyAPI.find_prototypes_filtered = function(prototype_filter)
	local results = {}
	if prototype_filter.type then
		if type(prototype_filter.type) == "table" then
				find_prototypes_by_types_and_names(prototype_filter, results)
			if type(prototype_filter.name) == "table" then
				find_prototypes_by_types_and_name(prototype_filter, results)
			elseif type(prototype_filter.name) == "string" then
			else -- prototype_filter.name == nil
				find_prototypes_by_types(prototype_filter, results)
			end
		else -- string
			if type(prototype_filter.name) == "table" then
				find_prototypes_by_type_and_names(prototype_filter, results)
			elseif type(prototype_filter.name) == "string" then
				find_prototypes_by_type_and_name(prototype_filter, results)
			else -- prototype_filter.name == nil
				find_prototypes_by_type(prototype_filter, results)
			end
		end
	elseif prototype_filter.name then
		if type(prototype_filter.name) == "table" then
			find_prototypes_by_names(prototype_filter, results)
		else -- string
			find_prototypes_by_name(prototype_filter, results)
		end
	elseif not prototype_filter.invert then
		for _, prototypes in (data_raw) do
			for _, prototype in (prototypes) do
				results[#results+1] = prototype
				if prototype_filter.limit and #results >= prototype_filter.limit then
					return results
				end
			end
		end
	end
	return results
end

---@param prototypes table #https://wiki.factorio.com/data_raw or similar structure
---@param field any
---@param old_data any
---@param new_data any
---@return table|LAPIWrappedPrototypes
lazyAPI.replace_in_prototypes = function(prototypes, field, old_data, new_data)
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
local replace_in_prototypes = lazyAPI.replace_in_prototypes


---@param image_data table?
---@param scale_size number
lazyAPI.scale_sprite = function(image_data, scale_size)
	if image_data == nil then return end
	if scale_size == nil then
		error("size is nil")
		return
	end

	---@params shift table # https://wiki.factorio.com/Types/vector
	local function scale_shift(shift)
		if not shift then return end
		shift[1] = shift[1] * scale_size
		shift[2] = shift[2] * scale_size
	end

	local function scale(_image_data)
		if _image_data == nil then return end

		if _image_data.filename or _image_data.filenames or _image_data.stripes then
			_image_data.scale = (_image_data.scale and _image_data.scale * scale_size) or scale_size
		end
		-- https://wiki.factorio.com/Types/vector
		scale_shift(_image_data.shift)
		local hr_version = _image_data.hr_version
		if hr_version then
			hr_version.scale = (hr_version.scale and hr_version.scale * scale_size) or scale_size
			scale_shift(hr_version.shift)
		end
	end

	scale(image_data)
	scale(image_data.picture)
	if image_data.layers then
		for _, _data in pairs(image_data.layers) do
			scale(_data)
		end
	end
	if image_data.pictures then
		for _, _data in pairs(image_data.pictures) do
			scale(_data)
		end
	end
end


-- WARNING: it's wrong \/, not fully tested
lazyAPI.pipe_scales = {
	["__base__/graphics/entity/pipe-covers/pipe-cover-north.png"] = function(image_data, scale)
		-- WARNING: it's wrong for sure
		if scale > 1 then
			image_data.shift = util.by_pixel(0, -8 * scale * (scale / 1.95))
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0,  8 / scale / (scale * 1.95))
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-north.png"] = function(image_data, scale)
		-- WARNING: it's wrong for sure
		if scale > 1 then
			image_data.shift = util.by_pixel(0, -8 * scale * (scale / 1.95))
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0,  8 / scale / (scale * 1.95))
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-north-shadow.png"] = function(image_data, scale)
		-- WARNING: it's wrong for sure
		if scale > 1 then
			image_data.shift = util.by_pixel(0, -8 * scale * (scale / 1.95))
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0,  8 / scale / (scale * 1.95))
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-north-shadow.png"] = function(image_data, scale)
		 -- WARNING: it's wrong for sure
		if scale > 1 then
			image_data.shift = util.by_pixel(0, -8 * scale * (scale / 1.95))
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0,  8 / scale / (scale * 1.95))
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-south.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(0,  5.5 * scale * scale)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0, -5.5 / scale / scale)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-south.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(0,  6 * scale * scale)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0, -6 / scale / scale)
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-south-shadow.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(0,  5.5 * scale * scale)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0, -5.5 / scale / scale)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-south-shadow.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(0,  6 * scale * scale)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(0, -6 / scale / scale)
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-west.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(-4 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel( 4 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-west.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(-4.5 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel( 4.5 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-west-shadow.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(-4 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel( 4 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-west-shadow.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel(-4.5 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel( 4.5 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-east.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel( 4 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(-4 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-east.png"] = function(image_data, scale)
		image_data.shift = util.by_pixel(4.5 * scale * scale, 0)
	end,
	["__base__/graphics/entity/pipe-covers/pipe-cover-east-shadow.png"] = function(image_data, scale)
		if scale > 1 then
			image_data.shift = util.by_pixel( 4 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(-4 / scale / scale, 0)
		end
	end,
	["__base__/graphics/entity/pipe-covers/hr-pipe-cover-east-shadow.png"] = function(image_data, scale)

		if scale > 1 then
			image_data.shift = util.by_pixel( 4.5 * scale * scale, 0)
		elseif scale < 1 then
			image_data.shift = util.by_pixel(-4.5 / scale / scale, 0)
		end
	end,
}


---@param image_data table?
---@param scale number
lazyAPI.scale_pipe_sprite = function(image_data, scale)
	if image_data == nil then return end
	if scale == nil then
		error("size is nil")
		return
	end

	---@params shift table # https://wiki.factorio.com/Types/vector
	local function scale_shift(_image_data)
		local f = lazyAPI.pipe_scales[_image_data.filename]
		if f then
			f(_image_data, scale)
			return
		end

		if _image_data.shift then
			local shift = _image_data.shift
			shift[1] = shift[1] * scale
			shift[2] = shift[2] * scale
			return
		end
	end

	local function _scale(_image_data)
		if _image_data == nil then return end

		if _image_data.filename or _image_data.filenames or _image_data.stripes then
			_image_data.scale = (_image_data.scale and _image_data.scale * scale) or scale
		end
		scale_shift(_image_data)
		local hr_version = _image_data.hr_version
		if hr_version then
			hr_version.scale = (hr_version.scale and hr_version.scale * scale) or scale
			scale_shift(hr_version)
		end
	end

	_scale(image_data)
	_scale(image_data.picture)
	if image_data.layers then
		for _, _data in pairs(image_data.layers) do
			_scale(_data)
		end
	end
	if image_data.pictures then
		for _, _data in pairs(image_data.pictures) do
			_scale(_data)
		end
	end
end


---@param vector table?
---@param size number
lazyAPI.scale_vector = function(vector, size)
	if vector == nil then return end
	if size == nil then
		error("size is nil")
		return
	end

	vector[1] = vector[1] * size
	vector[2] = vector[2] * size
end


---@param new_data table
---@return table|LAPIWrappedPrototype
lazyAPI.base.override_data = function(prototype, new_data)
	local prot = prototype.prototype or prototype
	lazyAPI.override_data(prot, new_data)
	lazyAPI.base.raise_change_event(prototype)

	return prototype
end

---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.base.raise_change_event = function(prototype)
	local prot = prototype.prototype or prototype
	local prototype_type = prot.type

	local event_data = {prototype = prot}
	lazyAPI.raise_event("on_prototype_changed", prototype_type, event_data)

	return prototype
end


-- Checks a prototype existence in data.raw by type and name
---@param type_prot string|table|LAPIWrappedPrototype
---@param name string
---@overload fun(table): boolean
---@return boolean
lazyAPI.base.does_exist = function(type_prot, name)
	if name then
		return (data_raw[type_prot][name] ~= nil)
	end

	---@cast type_prot table
	local prototype = type_prot
	local prot = prototype.prototype or prototype
	local prot_in_data = data_raw[prot.type][prot.name]
	if prot_in_data == prot then
		return true
	end

	local removed_prot = lazyAPI.deleted_data[prot.type][prot.name]
	if removed_prot == nil then
		lazyAPI.deleted_data[prot.type][prot.name] = prot
	end
	return false
end


-- WARNING: It's not reliable
---@param prototype table|LAPIWrappedPrototype
---@return string?
lazyAPI.base.get_mod_source = function(prototype)
	local prot = prototype.prototype or prototype
	return lazyAPI.prototypes_mod_source[prot]
end


---@param prototype table|LAPIWrappedPrototype
---@param mod_name string
---@return table|LAPIWrappedPrototype
lazyAPI.base.set_mod_source = function(prototype, mod_name)
	local prot = prototype.prototype or prototype
	lazyAPI.prototypes_mod_source[prot] = mod_name
	return prototype
end


-- Adds a prototype in data.raw
---@param prototype table|LAPIWrappedPrototype
---@return table, boolean #prototype, boolean
lazyAPI.base.recreate_prototype = function(prototype)
	local prot = prototype.prototype or prototype
	local prot_in_data = data_raw[prot.type][prot.name]
	if prot_in_data then
		return prototype, false
	end

	lazyAPI.add_prototype(prot)

	local is_added = (data_raw[prot.type][prot.name] == prot)
	return prototype, is_added
end


-- Adds a prototype in data.raw
---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype, boolean #prototype, is_added
lazyAPI.base.force_recreate_prototype = function(prototype)
	local prot = prototype.prototype or prototype
	local prot_in_data = data_raw[prot.type][prot.name]
	if prot_in_data ~= prot then
		lazyAPI.base.remove_prototype(prot_in_data)
	end

	lazyAPI.add_prototype(prot)

	local is_added = (data_raw[prot.type][prot.name] == prot)
	return prototype, is_added
end


--- WARNING: Perhaps, I should rename it
---@param prototype table|LAPIWrappedPrototype
---@param field_name string
---@return any
lazyAPI.base.get_field = function(prototype, field_name)
	local prot = prototype.prototype or prototype
	return prot[field_name]
end


---@param prototype table|LAPIWrappedPrototype
---@param new_name string
---@return table|LAPIWrappedPrototype
lazyAPI.base.rename = function(prototype, new_name)
	local prot = prototype.prototype or prototype
	local prototype_type = prot.type
	local prev_name = prot.name

	data_raw[prototype_type][prev_name] = nil
	add_prototypes(data, {prot})

	prot.name = new_name

	local event_data = {prototype = prot, prev_name = prev_name}
	lazyAPI.raise_event("on_prototype_renamed", prototype_type, event_data)

	return prot
end
lazyAPI.base.rename_prototype = lazyAPI.base.rename


---@param prototype table|LAPIWrappedPrototype
---@param subgroup string
---@param order? string
---@return table|LAPIWrappedPrototype
lazyAPI.base.set_subgroup = function(prototype, subgroup, order)
	local prot = prototype.prototype or prototype
	prot.subgroup = subgroup
	if order then
		prot.order = order
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
---@overload fun()
lazyAPI.base.remove_prototype = function(prototype)
	if prototype == nil then return end
	local prot = prototype.prototype or prototype
	local name = prot.name
	local prototype_type = prot.type
	if data_raw[prototype_type][name] == nil then
		return prototype
	end

	local event_data = {prototype = prot}
	lazyAPI.raise_event("on_pre_prototype_removed", prototype_type, event_data)

	data_raw[prototype_type][name] = nil

	local event_data2 = {prototype = prot}
	lazyAPI.raise_event("on_prototype_removed", prototype_type, event_data2)

	return prototype
end


-- https://wiki.factorio.com/Types/Resistances
---@param prototype table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param _type string
---@param percent float
---@param decrease? float
---@return table|LAPIWrappedPrototype
lazyAPI.resistance.set = function(prototype, _type, percent, decrease)
	local prot = prototype.prototype or prototype
	local resistances = prot.resistances
	if resistances == nil then
		prot.resistances = {{type = _type, percent = percent, decrease = decrease}}
		return prototype
	end

	fix_array(resistances)
	for i=1, #resistances do
		local resistance = resistances[i]
		if resistance.type == _type then
			resistance.percent = percent
			resistance.decrease = decrease
			return prototype
		end
	end


	resistances[#resistances+1] = {type = _type, percent = percent, decrease = decrease}
	return prototype
end


-- https://wiki.factorio.com/Types/Resistances
-- https://wiki.factorio.com/Damage#Resistance
---@param prototype table|LAPIWrappedPrototype
---@param type string
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@return boolean
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


---@param prototype table|LAPIWrappedPrototype
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.ingredients.add_item_ingredient = function(prototype, item, amount)
	if prototype == nil then error("prototype is nil") end
	amount = amount or 1

	local prot = prototype.prototype or prototype
	if prot.ingredients == nil then
		prot.ingredients = {}
	end
	local ingredients = prot.ingredients

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type ~= "fluid" and ingredient.name == item_name then
			ingredient.amount = ingredient.amount + amount
			return ingredient
		end
	end

	local ingredient = {type = "item", name = item_name, amount = amount}
	ingredients[#ingredients+1] = ingredient
	return ingredient
end


---@param prototype table|LAPIWrappedPrototype
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.ingredients.add_valid_item_ingredient = function(prototype, item, amount)
	local item_name = (type(item) == "string" and item) or item.name
	if lazyAPI.has_items_by_name(item_name) then
		return lazyAPI.ingredients.add_item_ingredient(prototype, item_name, amount)
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.ingredients.add_fluid_ingredient = function(prototype, fluid, amount)
	amount = amount or 1
	local prot = prototype.prototype or prototype

	if prot.ingredients == nil then --TODO: recheck
		prot.ingredients = {}
	end
	local ingredients = prot.ingredients

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type == "fluid" and ingredient.name == fluid_name then
			ingredient.amount = ingredient.amount + amount
			return ingredient
		end
	end

	local ingredient = {type = "fluid", name = fluid_name, amount = amount}
	ingredients[#ingredients+1] = ingredient
	return ingredient
end


---@param prototype table|LAPIWrappedPrototype
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.ingredients.add_valid_fluid_ingredient = function(prototype, fluid, amount)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	if data_raw.fluid[fluid_name] then
		return lazyAPI.ingredients.add_fluid_ingredient(prototype, fluid_name, amount)
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.add_ingredient = function(prototype, target, amount)
	local _type = target.type
	if _type == "fluid" then
		return lazyAPI.ingredients.add_fluid_ingredient(prototype, target.name, amount)
	else --item
		return lazyAPI.ingredients.add_item_ingredient(prototype, target.name, amount)
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.add_valid_ingredient = function(prototype, target, amount)
	if data_raw[target.type][target.name] == nil then return end
	return lazyAPI.ingredients.add_ingredient(prototype, target, amount)
end


---@param prototype table|LAPIWrappedPrototype
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_item_ingredient = function(prototype, item, amount)
	amount = amount or 1
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
	if ingredients == nil then
		prot.ingredients = {}
		ingredients = prot.ingredients
	end

	local item_name = (type(item) == "string" and item) or item.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type ~= "fluid" and ingredient.name == item_name then
			ingredient.amount = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {type = "item", name = item_name, amount = amount}
	return prototype
end



---@param prototype table|LAPIWrappedPrototype
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_valid_item_ingredient = function(prototype, item, amount)
	local item_name = (type(item) == "string" and item) or item.name
	if lazyAPI.has_items_by_name(item_name) then
		lazyAPI.ingredients.set_item_ingredient(prototype, item_name, amount)
	end
	return prototype
end


---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table|LAPIWrappedPrototype
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_fluid_ingredient = function(prototype, fluid, amount)
	amount = amount or 1
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
	if ingredients == nil then
		prot.ingredients = {}
		ingredients = prot.ingredients
	end

	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type == "fluid" and ingredient.name == fluid_name then
			ingredient.amount = amount
			return prototype
		end
	end

	ingredients[#ingredients+1] = {type = "fluid", name = fluid_name, amount = amount}
	return prototype
end


---https://wiki.factorio.com/Types/FluidIngredientPrototype
---@param prototype table|LAPIWrappedPrototype
---@param fluid string|table #https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_valid_fluid_ingredient = function(prototype, fluid, amount)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	if data_raw.fluid[fluid_name] then
		lazyAPI.ingredients.set_fluid_ingredient(prototype, fluid_name, amount)
	end
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_ingredient = function(prototype, target, amount)
	local _type = target.type
	if _type == "fluid" then
		return lazyAPI.recipe.set_item_ingredient(prototype, target.name, amount)
	else -- item
		return lazyAPI.recipe.set_fluid_ingredient(prototype, target.name, amount)
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param target table #https://wiki.factorio.com/Prototype/Item or https://wiki.factorio.com/Prototype/Fluid
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.set_valid_ingredient = function(prototype, target, amount)
	if data_raw[target.type][target.name] == nil then return prototype end
	lazyAPI.ingredients.set_ingredient(prototype, target, amount)
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param item string|table #https://wiki.factorio.com/Prototype/Item
---@return table[] #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.ingredients.get_item_ingredients = function(prototype, item)
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
	if ingredients == nil then
		return {}
	end

	local fluid_name = (type(item) == "string" and item) or item.name
	local result = {}
	fix_array(ingredients)
	for i=1, #ingredients do
		local ingredient = ingredients[i]
		if ingredient.type ~= "fluid" and ingredient.name == fluid_name then
			result[#result+1] = ingredient
		end
	end

	return result
end


---@param prototype table|LAPIWrappedPrototype
---@param fluid string #https://wiki.factorio.com/Prototype/Fluid#name
---@return table[] #https://wiki.factorio.com/Types/FluidIngredientPrototype
lazyAPI.ingredients.get_fluid_ingredients = function(prototype, fluid)
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
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


---@param prototype table|LAPIWrappedPrototype
---@param ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table? #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.remove_ingredient = function(prototype, ingredient, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
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
			if _ingredient.type ~= "fluid" and _ingredient.name == ingredient_name then
				return tremove(ingredients, i)
			end
		end
	end
end


---@param prototype table|LAPIWrappedPrototype
---@param ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table|LAPIWrappedPrototype
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


---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.remove_all_ingredients = function(prototype)
	if prototype == nil then error("prototype is nil") end
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	prot.ingredients = nil
	if type(prot.normal) == "table" then
		prot.normal.ingredients = nil
	end
	if type(prot.expensive) == "table" then
		prot.expensive.ingredients = nil
	end
	return prototype
end


---@param t table
---@param field string
local function check_products(t, field)
	local array = t[field]
	if array == nil then return end
	fix_array(array)
	for i=1, #array do
		local ingredient = array[i]
		local item_name = _ingredient.name
		if item_name and not lazyAPI.has_items_by_name(item_name) then
			tremove(array, i)
		elseif (ingredient.type ~= "fluid" and not lazyAPI.has_items_by_name(ingredient.name))
			or (ingredient.type == "fluid" and dat_raw.fluid[ingredient.name] == nil)
		then
			tremove(array, i)
		end
	end
end


---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.remove_non_existing_ingredients = function(prototype)
	local prot = prototype.prototype or prototype
	check_products(prot, "ingredients")
	check_products(prot.normal, "ingredients")
	check_products(prot.expensive, "ingredients")
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param old_ingredient string|table
---@param new_ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.replace_ingredient = function(prototype, old_ingredient, new_ingredient, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
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
			if ingredient.type ~= "fluid" and ingredient.name == old_ingredient_name then
				ingredient.name = new_ingredient_name
			end
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param old_ingredient string|table
---@param new_ingredient string|table
---@param _type? ingredient_type #"item" by default
---@return table|LAPIWrappedPrototype
lazyAPI.ingredients.replace_ingredient_everywhere = function(prototype, old_ingredient, new_ingredient, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	if prot.ingredients then
		lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type)
	end
	if prot.normal then
		lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type, "normal")
	end
	if prot.expensive then
		lazyAPI.ingredients.replace_ingredient(prot, old_ingredient, new_ingredient, _type, "expensive")
	end
	return prototype
end


-- Perhaps, it's not a good idea to use it
---@param prototype table|LAPIWrappedPrototype
---@param ingredient string|table
---@return table? #https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.ingredients.find_ingredient_by_name = function(prototype, ingredient)
	local prot = prototype.prototype or prototype
	local ingredients = prot.ingredients
	if ingredients == nil then
		return
	end

	local ingredient_name = (type(ingredient) == "string" and ingredient) or ingredient.name
	fix_array(ingredients)
	for i=1, #ingredients do
		local _ingredient = ingredients[i]
		if _ingredient.name == ingredient_name then
			return _ingredient
		end
	end
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
---@param prototype table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param item string|table
---@param new_item string|table
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param item string|table
---@param count_min? integer
---@param count_max? integer
---@param probability? float
---@return table|LAPIWrappedPrototype
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
-- https://wiki.factorio.com/Types/Loot
---@param prototype table|LAPIWrappedPrototype
---@param item table
---@param count_min? integer
---@param count_max? integer
---@param probability? float
---@return table|LAPIWrappedPrototype
lazyAPI.loot.set_if_exist = function(prototype, item, count_min, count_max, probability)
	if data_raw[target.type][target.name] == nil then return prototype end
	lazyAPI.loot.set(prototype, item, count_min, count_max, probability)
	return prototype
end


-- https://wiki.factorio.com/Prototype/EntityWithHealth#loot
---@param prototype table|LAPIWrappedPrototype
---@param item string|table
---@return table|LAPIWrappedPrototype
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


---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.loot.remove_non_existing_loot = function(prototype)
	local loot = prot.loot
	if loot == nil then
		return prototype
	end
	for i=#loot, 1, -1 do
		if lazyAPI.has_items_by_name(loot[i].item) then
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


-- WARNING: WIP, doesn't scale everything properly, doesn't scale some images yet
---@param prototype table|LAPIWrappedPrototype
---@param size number
---@return table|LAPIWrappedPrototype?
lazyAPI.entity.scale = function(prototype, size)
	if prototype == nil then
		log("prototype is nil")
		return
	end
	if size == nil then
		error("size is nil")
		return prototype
	end

	-- TODO: fix smoke from energy_source, circuit_wire_connection_point,
	--	graphics_set, Animation, RotatedAnimation4Way,
	--	working_visualisations
	--	circuit_wire_max_distance
	--	https://wiki.factorio.com/Prototype/TrainStop#light2
	--	etc.

	local prot = prototype.prototype or prototype

	local prev_collision_box = table.deepcopy(prot.collision_box)
	lazyAPI.multiply_bounding_box(prot.map_generator_bounding_box, size)
	lazyAPI.multiply_bounding_box(prot.hit_visualization_box, size)
	lazyAPI.multiply_bounding_box(prot.collision_box, size)
	lazyAPI.multiply_bounding_box(prot.selection_box, size) -- TODO: change, it should depend on collision_box
	lazyAPI.multiply_bounding_box(prot.drawing_box,   size)
	lazyAPI.multiply_bounding_box(prot.sticker_box,   size)
	if prot.drawing_boxes then
		prot.drawing_boxes = table.deepcopy(prot.drawing_boxes)
		lazyAPI.multiply_bounding_box(prot.drawing_boxes.east,  size)
		lazyAPI.multiply_bounding_box(prot.drawing_boxes.west,  size)
		lazyAPI.multiply_bounding_box(prot.drawing_boxes.south, size)
		lazyAPI.multiply_bounding_box(prot.drawing_boxes.north, size)
	end
	if prot.circuit_wire_connection_point then
		prot.circuit_wire_connection_point = table.deepcopy(prot.circuit_wire_connection_point)
		local points = prot.circuit_wire_connection_point
		lazyAPI.multiply_bounding_box(points.east,  size)
		lazyAPI.multiply_bounding_box(points.west,  size)
		lazyAPI.multiply_bounding_box(points.south, size)
		lazyAPI.multiply_bounding_box(points.north, size)
	end

	-- Scale sprites (perhaps, it's wrong because it used the same fields several times)
	--	Probably, I'm gonna store tables of scales images or use another method temporarily.
	lazyAPI.base.scale_sprite(prot, size)
	lazyAPI.base.scale_Animation4Way(prot, size)
	lazyAPI.base.scale_Sprite4Way(prot, size)
	lazyAPI.base.scale_SpriteVariations(prot, size)
	for _, field_name in pairs(lazyAPI.directory_animation_fields) do
		local data = prot[field_name]
		if data then
			lazyAPI.scale_sprite(data.east,  size)
			lazyAPI.scale_sprite(data.west,  size)
			lazyAPI.scale_sprite(data.north, size)
			lazyAPI.scale_sprite(data.south, size)
		end
	end
	for _, field_name in pairs(lazyAPI.directory_sprite_fields) do
		local data = prot[field_name]
		if data then
			lazyAPI.scale_sprite(data.east,  size)
			lazyAPI.scale_sprite(data.west,  size)
			lazyAPI.scale_sprite(data.north, size)
			lazyAPI.scale_sprite(data.south, size)
		end
	end

	-- Circuit sprites
	if prot.circuit_connector_sprites then
		prot.circuit_connector_sprites = table.deepcopy(prot.circuit_connector_sprites)
		local ccs = prot.circuit_connector_sprites
		lazyAPI.scale_sprite(ccs.led_red,   size)
		lazyAPI.scale_sprite(ccs.led_green, size)
		lazyAPI.scale_sprite(ccs.led_blue,  size)
		lazyAPI.scale_sprite(ccs.led_light, size)
		lazyAPI.scale_sprite(ccs.wire_pins, size)
		lazyAPI.scale_sprite(ccs.led_blue_off, size)
		lazyAPI.scale_sprite(ccs.connector_main,   size)
		lazyAPI.scale_sprite(ccs.connector_shadow, size)
		lazyAPI.scale_sprite(ccs.wire_pins_shadow, size)
		lazyAPI.scale_vector(ccs.blue_led_light_offset, size)
		lazyAPI.scale_vector(ccs.red_green_led_light_offset, size)
	end


	local function scale_fluid_box(fluid_box)
		if not (fluid_box and type(fluid_box) == "table" and fluid_box.pipe_connections) then
			return
		end

		lazyAPI.scale_pipes(prot, fluid_box, size, prev_collision_box)
	end

	-- Scale fluid_boxes
	if prot.fluid_box and type(prot.fluid_box) == "table" then
		prot.fluid_box = table.deepcopy(prot.fluid_box)
		scale_fluid_box(prot.fluid_box)
	end
	if prot.input_fluid_box and type(prot.input_fluid_box) == "table" then
		prot.input_fluid_box = table.deepcopy(prot.input_fluid_box)
		scale_fluid_box(prot.input_fluid_box)
	end
	if prot.output_fluid_box and type(prot.output_fluid_box) == "table" then
		prot.input_fluid_box = table.deepcopy(prot.output_fluid_box)
		scale_fluid_box(prot.output_fluid_box)
	end
	if prot.fluid_boxes and type(prot.fluid_boxes) == "table" then
		prot.fluid_boxes = table.deepcopy(prot.fluid_boxes)
		for _, fluid_box in pairs(prot.fluid_boxes) do
			scale_fluid_box(fluid_box)
		end
	end

	-- Scale circuit_wire_connection_point
	if prot.circuit_wire_connection_point then
		prot.circuit_wire_connection_point = table.deepcopy(prot.circuit_wire_connection_point)
		for _, points in pairs(prot.circuit_wire_connection_point) do
			for _, point in pairs(points) do
				lazyAPI.scale_vector(point, size)
			end
		end
	end

	return prototype
end


lazyAPI.EntityWithHealth.find_resistance = lazyAPI.resistance.find
lazyAPI.EntityWithHealth.set_resistance = lazyAPI.resistance.set
lazyAPI.EntityWithHealth.remove_resistance = lazyAPI.resistance.find
lazyAPI.EntityWithHealth.find_loot = lazyAPI.loot.find
lazyAPI.EntityWithHealth.replace_loot = lazyAPI.loot.replace
lazyAPI.EntityWithHealth.set_loot = lazyAPI.loot.set
lazyAPI.EntityWithHealth.set_valid_loot = lazyAPI.loot.set_if_exist
lazyAPI.EntityWithHealth.remove_loot = lazyAPI.loot.remove
lazyAPI.EntityWithHealth.remove_non_existing_loot = lazyAPI.loot.remove_non_existing_loot


---@param item table|string
---@return table[] #recipes
lazyAPI.item.find_main_recipes = function(item)
	local prot = item.prototype or item
	local item_name = (type(prot) == "string" and prot) or prot.name
	local results = {}
	for _, recipe in pairs(recipes) do
		if lazyAPI.recipe.find_main_result(recipe, item_name) then
			results[#results+1] = recipe
		end
	end
	return results
end


---@param prototype table|LAPIWrappedPrototype
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return table|LAPIWrappedPrototype
lazyAPI.flags.add_flag = function(prototype, flag)
	add_to_array(prototype, "flags", flag)
	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
lazyAPI.flags.remove_flag = function(prototype, flag)
	return remove_from_array(prototype, "flags", flag)
end


---Checks if a prototype has a certain flag
---@param prototype table|LAPIWrappedPrototype
---@param flag string #https://wiki.factorio.com/Types/ItemPrototypeFlags
---@return integer? # index of the flag in prototype.flags
lazyAPI.flags.find_flag = function(prototype, flag)
	return find_in_array(prototype, "flags", flag)
end


for k, f in pairs(lazyAPI.ingredients) do
	lazyAPI.recipe[k] = f
end

---@param prototype table|LAPIWrappedPrototype
---@param subgroup string
---@param order? string
---@return table|LAPIWrappedPrototype
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


---@param product table
---@param product_type? product_type
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.product.make_product_prototype = function(product, product_type, show_details_in_recipe_tooltip)
	if product.amount_min == nil or product.amount_max == nil then
		product.amount_min = nil
		product.amount_max = nil
		product.amount = product.amount or 1
	end
	return {
		type = product_type or product.type or "item",
		item = product.item,
		show_details_in_recipe_tooltip = show_details_in_recipe_tooltip,
		amount_min = product.amount_min, amount_max = product.amount_max,
		amount = product.amount,
		probability = product.probability,
		temperature = product.temperature,
		catalyst_amount = product.catalyst_amount
	}
end
local make_product_prototype = lazyAPI.product.make_product_prototype


---@param item_product table
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table #https://wiki.factorio.com/Types/ItemProductPrototype
lazyAPI.product.make_item_product_prototype = function(item_product, show_details_in_recipe_tooltip)
	return lazyAPI.product.make_product_prototype(item_product, "item", show_details_in_recipe_tooltip)
end
local make_item_product_prototype = lazyAPI.product.make_item_product_prototype


---@param fluid_product table
---@param show_details_in_recipe_tooltip? boolean #(true by default) When hovering over a recipe in the crafting menu the recipe tooltip will be shown. An additional item tooltip will be shown for every product, as a separate tooltip, if the item tooltip has a description and/or properties to show and if show_details_in_recipe_tooltip is true.
---@return table #https://wiki.factorio.com/Types/FluidProductPrototype
lazyAPI.product.make_fluid_product_prototype = function(fluid_product, show_details_in_recipe_tooltip)
	return lazyAPI.product.make_product_prototype(fluid_product, "fluid", show_details_in_recipe_tooltip)
end
local make_fluid_product_prototype = lazyAPI.product.make_fluid_product_prototype


-- Perhaps, not reliable
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@return boolean
lazyAPI.recipe.has_result = function(prototype)
	local prot = prototype.prototype or prototype
	if (prot.results and next(prot.results)) then
		return true
	elseif prot.normal and ((prot.normal.results and next(prot.normal.results)) or prot.normal.result) then
		return true
	elseif prot.expensive and ((prot.expensive.results and next(prot.expensive.results)) or prot.expensive.result) then
		return true
	end
	return false
end


-- Perhaps, not reliable
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item table|string
---@return boolean
lazyAPI.recipe.find_main_result = function(prototype, item)
	local prot = prototype.prototype or prototype
	if prot.results then
		local item_name = (type(item) == "string" and item) or item.name
		local _, result = next(prot.results)
		return (result and result.name == item_name) or false
	end
	return false
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_item_in_result = function(prototype, item, item_product)
	if item == nil then error("item is nil") end
	local prot = prototype.prototype or prototype

	if (item_product.amount_min == nil or item_product.amount_max == nil)
		and item_product.amount and item_product.amount > 65535
	then
		item_product.amount = item_product.amount - 65535
		lazyAPI.recipe.add_item_in_result(prot, item, item_product)
		if item_product.amount <= 0 then return prototype end
	end

	item_product.item = (type(item_product.item) == "string" and item_product.item) or item_product.item.name
	local is_simple_data = (next(item_product, next(item_product)) == nil) -- Improve
	local results = prot.results
	if results == nil then
		if is_simple_data then
			prot.results = {{type = "item", name = item, amount = item_product.amount or 1}}
		else
			prot.results = {make_product_prototype(item_product), "item"}
		end
		results = prot.results
		return prototype
	end

	fix_array(results)

	if is_simple_data then
		-- TODO: recheck
		results[#results+1] = {type = "item", name = item, amount = item_product.amount or 1}
	else
		results[#results+1] = make_product_prototype(item_product, "item")
	end
	return prototype
end

---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_valid_item_in_result = function(prototype, item, item_product)
	local item_name = (type(item) == "string" and item) or item.name
	if lazyAPI.has_items_by_name(item_name) then
		lazyAPI.recipe.add_item_in_result(prototype, item_name, item_product)
	end
	return prototype
end

---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_fluid_in_result = function(prototype, fluid, fluid_product)
	if fluid == nil then error("item is nil") end

	local prot = prototype.prototype or prototype

	if (fluid_product.amount_min == nil or fluid_product.amount_max == nil)
		and fluid_product.amount and fluid_product.amount > 65535
	then
		fluid_product.amount = fluid_product.amount - 65535
		lazyAPI.recipe.add_fluid_in_result(prot, fluid, fluid_product)
		if fluid_product.amount <= 0 then return prototype end
	end
	fluid_product.item = (type(fluid_product.item) == "string" and fluid_product.item) or fluid_product.item.name
	local results = prot.results
	if results == nil then
		prot.results = {make_fluid_product_prototype(fluid_product)}
		results = prot.results
		return prototype
	end

	fix_array(results)
	-- TODO: recheck \/
	results[#results+1] = make_fluid_product_prototype(fluid_product)
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_valid_fluid_in_result = function(prototype, fluid, fluid_product)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	if data_raw.fluid[fluid_name] then
		lazyAPI.recipe.add_fluid_in_result(prototype, fluid_name, fluid_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Types/ProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_product_in_result = function(prototype, product, product_prototype)
	if product.type == "fluid" then
		lazyAPI.recipe.add_fluid_in_result(prototype, product, product_prototype)
	else
		lazyAPI.recipe.add_item_in_result (prototype, product, product_prototype)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Types/ProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.add_valid_product_in_result = function(prototype, product, product_prototype)
	if data_raw[product.type][product.name] == nil then return prototype end
	lazyAPI.recipe.add_product_in_result(prototype, product, product_prototype)
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_item_in_result = function(prototype, item, item_product)
	if item == nil then error("item is nil") end
	local results
	local prot = prototype.prototype or prototype
	item_product.item = (type(item_product.item) == "string" and item_product.item) or item_product.item.name
	lazyAPI.recipe.remove_item_from_result(prot, item)
	local is_simple_data = (next(item_product, next(item_product)) == nil) -- Improve
	local results = prot.results
	if results == nil then
		if is_simple_data then
			prot.results = {{type = "item", name = item, amount = item_product.amount or 1}}
		else
			prot.results = {make_product_prototype(item_product)}
		end
		results = prot.results
		return prototype
	end

	fix_array(results)
	if is_simple_data then
		results[#results+1] = {type = "item", name = item, amount = item_product.amount or 1}
	else
		results[#results+1] = make_product_prototype(item_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@param item_product table #https://wiki.factorio.com/Types/ItemProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_valid_item_in_result = function(prototype, item, item_product)
	local item_name = (type(item) == "string" and item) or item.name
	if lazyAPI.has_items_by_name(item_name) then
		lazyAPI.recipe.set_item_in_result(prototype, item_name, item_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_fluid_in_result = function(prototype, fluid, fluid_product)
	if fluid == nil then error("item is nil") end

	local prot = prototype.prototype or prototype
	fluid_product.item = (type(fluid_product.item) == "string" and fluid_product.item) or fluid_product.item.name
	lazyAPI.recipe.remove_fluid_from_result(prototype, fluid)
	local results = prot.results
	if results == nil then
		prot.results = {make_fluid_product_prototype(fluid_product)}
		results = prot.results
		return prototype
	end

	fix_array(results)
	results[#results+1] = make_fluid_product_prototype(fluid_product)
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@param fluid_product table #https://wiki.factorio.com/Types/FluidProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_valid_fluid_in_result = function(prototype, fluid, fluid_product)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	if data_raw.fluid[fluid_name] then
		lazyAPI.recipe.set_fluid_in_result(prototype, fluid_name, fluid_product)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Types/ProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_product_in_result = function(prototype, product, product_prototype)
	if product.type == "fluid" then
		lazyAPI.recipe.set_fluid_in_result(prototype, product, product_prototype)
	else
		lazyAPI.recipe.set_item_in_result(prototype, product, product_prototype)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param product table
---@param product_prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Types/ProductPrototype
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.set_valid_product_in_result = function(prototype, product, product_prototype)
	if data_raw[product.type][product.name] == nil then return prototype end
	lazyAPI.recipe.set_product_in_result(prototype, product, product_prototype)
	return prototype
end

---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param old_item string|table
---@param new_item string|table
---@param _type? ingredient_type #"item" by default
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.replace_result = function(prototype, old_item, new_item, _type)
	if old_item == nil then error("item is nil") end
	if new_item == nil then error("new_item is nil") end

	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return prototype
	end

	fix_array(results)
	local old_item_name = (type(old_item) == "string" and old_item) or old_item.name
	local new_item_name = (type(new_item) == "string" and new_item) or new_item.name
	if _type == "fluid" then
		for i=1, #results do
			local result = results[i]
			if result.type == "fluid" and result.name == old_item_name then
				result.name = new_item_name
			end
		end
	else -- item
		for i=1, #results do
			local result = results[i]
			if result.type ~= "fluid" and result.name == old_item_name then
				result.name = new_item_name
			end
		end
	end

	return prototype
end


---@param prototype table|LAPIWrappedPrototype
---@param old_item string|table
---@param new_item string|table
---@param _type? ingredient_type #"item" by default
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.replace_result_everywhere = function(prototype, old_item, new_item, _type)
	_type = _type or "item"
	local prot = prototype.prototype or prototype
	if prot.ingredients then
		lazyAPI.recipe.replace_result(prot, old_item, new_item, _type)
	end
	if prot.normal then
		lazyAPI.recipe.replace_result(prot, old_item, new_item, _type, "normal")
	end
	if prot.expensive then
		lazyAPI.recipe.replace_result(prot, old_item, new_item, _type, "expensive")
	end

	return prototype
end

-- THIS SEEMS WRONG
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@return table|LAPIWrappedPrototype?
lazyAPI.recipe.remove_if_no_result = function(prototype)
	local prot = prototype.prototype or prototype
	if (prot.results and next(prot.results)) then
		return prototype
	end
	lazyAPI.base.remove_prototype(prot)
end

-- THIS SEEMS WRONG
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@return table|LAPIWrappedPrototype?
lazyAPI.recipe.remove_if_no_ingredients = function(prototype)
	if not lazyAPI.ingredients.have_ingredients(prototype) then
		lazyAPI.base.remove_prototype(prot)
	else
		return prototype
	end
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.remove_item_from_result = function(prototype, item)
	if item == nil then error("item is nil") end


	local prot = prototype.prototype or prototype
	local results = prot.results

	if results == nil then
		return prototype
	end

	fix_array(results)
	local item_name = (type(item) == "string" and item) or item.name
	for i=#results, 1, -1 do
		local result = results[i]
		if result.type ~= "fluid" and result.name == item_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.remove_item_from_result_everywhere = function(prototype, item)
	local prot = prototype.prototype or prototype
	local item_name = (type(item) == "string" and item) or item.name
	if prot.results then -- TODO: improve
		lazyAPI.recipe.remove_item_from_result(prototype, item_name)
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.remove_fluid_from_result = function(prototype, fluid)
	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return prototype
	end

	fix_array(results)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	for i=#results, 1, -1 do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			tremove(results, i)
		end
	end
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@return table|LAPIWrappedPrototype
lazyAPI.recipe.remove_non_existing_results = function(prototype)
	local prot = prototype.prototype or prototype
	check_products(prot, "results")
	check_products(prot.normal, "results")
	check_products(prot.expensive, "results")
	return prototype
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@return table[]|string #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_items_in_result = function(prototype, item)
	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return {}
	end

	local found_fluids = {}
	local item_name = (type(item) == "string" and item) or item.name
	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result.type ~= "fluid" and result.name == item_name then
			found_fluids[#found_fluids+1] = result
		end
	end
	return found_fluids
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param item string|table
---@return integer, integer #min_amount, max_amount
lazyAPI.recipe.count_item_in_result = function(prototype, item)
	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return 0, 0
	end

	fix_array(results)
	local item_name = (type(item) == "string" and item) or item.name
	local min_amount = 0
	local max_amount = 0
	for i=1, #results do
		local result = results[i]
		if result.type ~= "fluid" and result.name == item_name then
			if result.amount_min and result.amount_max then
				min_amount = min_amount + count
				max_amount = max_amount + count
			else
				local count = result["amount"] or 1
				min_amount = min_amount + count
				max_amount = max_amount + count
			end
		end
	end
	return min_amount, max_amount
end


-- https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@return table[] #https://wiki.factorio.com/Types/ProductPrototype
lazyAPI.recipe.find_fluids_in_result = function(prototype, fluid)
	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return {}
	end

	local found_fluids = {}
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	fix_array(results)
	for i=1, #results do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			found_fluids[#found_fluids+1] = result
		end
	end
	return found_fluids
end


---https://wiki.factorio.com/Prototype/Recipe#results
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Recipe
---@param fluid string|table
---@return integer, integer #min_amount, max_amount
lazyAPI.recipe.count_fluid_in_result = function(prototype, fluid)
	local prot = prototype.prototype or prototype
	local results = prot.results
	if results == nil then
		return 0, 0
	end

	fix_array(results)
	local fluid_name = (type(fluid) == "string" and fluid) or fluid.name
	local min_amount = 0
	local max_amount = 0
	for i=1, #results do
		local result = results[i]
		if result.type == "fluid" and result.name == fluid_name then
			if result.amount_min and result.amount_max then
				min_amount = min_amount + count
				max_amount = max_amount + count
			else
				local count = result["amount"] or 1
				min_amount = min_amount + count
				max_amount = max_amount + count
			end
		end
	end
	return min_amount, max_amount
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
---@return integer? #index from https://wiki.factorio.com/Prototype/Module#limitation
lazyAPI.module.find_allowed_recipe_index = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return find_in_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
---@return integer? #index from https://wiki.factorio.com/Prototype/Module#limitation_blacklist
lazyAPI.module.find_blacklisted_recipe_index = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return find_in_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
lazyAPI.module.remove_allowed_recipe = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return remove_from_array(prototype, "limitation", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table|LAPIWrappedPrototype
---@param recipe string|table
lazyAPI.module.remove_blacklisted_recipe = function(prototype, recipe)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	return remove_from_array(prototype, "limitation_blacklist", recipe_name)
end


-- https://wiki.factorio.com/Prototype/Module#limitation_blacklist
---@param prototype table|LAPIWrappedPrototype
---@param old_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@param new_recipe string|table #https://wiki.factorio.com/Prototype/Recipe or its name
---@return table|LAPIWrappedPrototype
lazyAPI.module.replace_recipe = function(prototype, old_recipe, new_recipe)
	old_tech = (type(old_tech) == "string" and old_tech) or old_tech.name
	new_tech = (type(new_tech) == "string" and new_tech) or new_tech.name

	replace_in_prototype(prototype, "limitation", old_recipe, new_recipe)
	replace_in_prototype(prototype, "limitation_blacklist", old_recipe, new_recipe)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param recipe string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.unlock_recipe = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local effects = prot.effects
	if effects == nil then
		local new_effect = {type = "unlock-recipe", recipe = recipe_name}
		prototype.effects = {new_effect}
		return prototype
	end

	fix_array(effects)
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param recipe string|table
---@return table? #https://wiki.factorio.com/Types/UnlockRecipeModifierPrototype
lazyAPI.tech.find_unlock_recipe_effect = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local effects = prot.effects
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param recipe string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.remove_unlock_recipe_effect = function(prototype, recipe)
	local prot = prototype.prototype or prototype
	local effects = prot.effects
	if effects == nil then return prototype end

	lazyAPI.tech.remove_effect(prototype, "unlock-recipe", recipe)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#effects
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@return table|LAPIWrappedPrototype?
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param recipe string
---@return table|LAPIWrappedPrototype
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.add_effect = function(prototype, type, recipe)
	local prot = prototype.prototype or prototype
	local recipe_name = (type(recipe) == "string" and recipe) or recipe.name
	local effects = prot.effects
	if effects == nil then
		prot.effects = {{
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@return table? #https://wiki.factorio.com/Types/ModifierPrototype
lazyAPI.tech.find_effect = function(prototype, type, recipe)
	local prot = prototype.prototype or prototype
	local effects = prot.effects
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param effect_type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.remove_effect = function(prototype, effect_type, recipe)
	local prot = prototype.prototype or prototype
	local effects = prot.effects
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
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param type string #https://wiki.factorio.com/Types/ModifierPrototype
---@param recipe string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.remove_effect_everywhere = function(prototype, type, recipe)
	lazyAPI.tech.remove_effect(prototype, type, recipe)
	lazyAPI.tech.remove_effect(prototype, type, recipe, "normal")
	lazyAPI.tech.remove_effect(prototype, type, recipe, "expensive")
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
---@return integer? # index of the prerequisite in prototype.prerequisites
lazyAPI.tech.find_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	return find_in_array(prototype, "prerequisites", tech_name)
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
---@return table|LAPIWrappedPrototype
lazyAPI.tech.add_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	add_to_array(prototype, "prerequisites", tech_name)
	return prototype
end


---https://wiki.factorio.com/Prototype/Technology#prerequisites
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tech string|table
lazyAPI.tech.remove_prerequisite = function(prototype, tech)
	local tech_name = (type(tech) == "string" and tech) or tech.name
	return remove_from_array(prototype, "prerequisites", tech_name)
end


---Adds an ingredient for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.tech.add_tool = function(prototype, tool, amount)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return end
	return lazyAPI.ingredients.add_item_ingredient(unit, tool, amount)
end


---Adds an ingredient for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table? #https://wiki.factorio.com/Types/ItemIngredientPrototype
lazyAPI.tech.add_valid_tool = function(prototype, tool, amount)
	local tool_name = (type(tool) == "string" and tool) or tool.name
	if data_raw["tool"][tool_name] then return end
	return lazyAPI.tech.add_tool(prototype, tool, amount)
end


---Sets a tool for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.tech.set_tool = function(prototype, tool, amount)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return prototype end
	lazyAPI.ingredients.set_item_ingredient(unit, tool, amount)
	return prototype
end


---Sets a tool for the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param amount? integer #1 by default
---@return table|LAPIWrappedPrototype
lazyAPI.tech.set_valid_tool = function(prototype, tool, amount)
	local tool_name = (type(tool) == "string" and tool) or tool.name
	if data_raw["tool"][tool_name] then return prototype end
	lazyAPI.tech.set_tool(prototype, tool, amount)
	return prototype
end


---Removes a tool from the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param tool string|table #https://wiki.factorio.com/Prototype/Tool
---@return table? #Removed https://wiki.factorio.com/Types/IngredientPrototype
lazyAPI.tech.remove_tool = function(prototype, tool)
	local unit = (prototype.prototype or prototype).unit
	if unit == nil then return prototype end
	return lazyAPI.ingredients.remove_ingredient(prototype, tool, "item")
end


---Repalces a tool in the technology
---https://wiki.factorio.com/Prototype/Technology#unit
---@param prototype table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology
---@param old_tool string|table #https://wiki.factorio.com/Prototype/Tool
---@param new_tool string|table #https://wiki.factorio.com/Prototype/Tool
---@return table|LAPIWrappedPrototype
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
---@return table? tech
lazyAPI.tech.remove_contiguous_techs = function(tech)
	local tech_name
	if type(tech) == "string" then
		tech_name = tech
		tech = technologies[tech_name]
	else
		tech_name = tech.name
	end

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
---@param prototype string|table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology or its name
---@param old_tech  string|table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology or its name
---@param new_tech  string|table|LAPIWrappedPrototype #https://wiki.factorio.com/Prototype/Technology or its name
---@return string|table|LAPIWrappedPrototype
function lazyAPI.tech.replace_prerequisite(prototype, old_tech, new_tech)
	local old_tech_name = (type(old_tech) == "string" and old_tech) or old_tech.name
	local new_tech_name = (type(new_tech) == "string" and new_tech) or new_tech.name

	if type(prototype) == "string" then
		local technology = technologies[prototype]
		if technology == nil then
			return prototype
		end
		replace_in_prototype(technology, "prerequisites", old_tech_name, new_tech_name)
		return technology
	else
		---@cast prototype table|LAPIWrappedPrototype
		local prot = prototype.prototype or prototype
		replace_in_prototype(prot, "prerequisites", old_tech_name, new_tech_name)
		return prototype
	end
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table|LAPIWrappedPrototype
---@param resource_category string #https://wiki.factorio.com/Prototype/ResourceCategory
---@return integer? #index of resource_category in the resource_categories
lazyAPI.mining_drill.find_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	return find_in_array(prototype, "resource_categories", resource_category_name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table|LAPIWrappedPrototype
---@param resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
---@return table|LAPIWrappedPrototype
lazyAPI.mining_drill.add_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	add_to_array(prototype, "resource_categories", resource_category_name)
	return prototype
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table|LAPIWrappedPrototype
---@param resource_category string|table #https://wiki.factorio.com/Prototype/ResourceCategory
lazyAPI.mining_drill.remove_resource_category = function(prototype, resource_category)
	local resource_category_name = (type(resource_category) == "string" and resource_category) or resource_category.name
	return remove_from_array(prototype, "resource_categories", resource_category_name)
end


-- https://wiki.factorio.com/Prototype/MiningDrill#resource_categories
---@param prototype table|LAPIWrappedPrototype
---@param old_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@param new_category string #Name of https://wiki.factorio.com/Prototype/ResourceCategory
---@return table|LAPIWrappedPrototype
lazyAPI.mining_drill.replace_resource_category_everywhere = function(prototype, old_category, new_category)
	replace_in_prototypes(prototype, "resource_categories", old_category, new_category)
	return prototype
end


-- TODO: recheck, perhaps, I should track both in a table for compatibility
-- https://wiki.factorio.com/Prototype/ResourceEntity
---@param prototype table|LAPIWrappedPrototype
---@return table|LAPIWrappedPrototype, table? #prototype, new_prototype
lazyAPI.resource.add_inf_version = function(prototype)
	local prot = prototype.prototype or prototype
	if prot.infinite then
		log('"' .. prot.name .. '" is already infinite')
		return prototype
	end
	if data_raw.resource["inf-" .. prot.name] then
		return prototype, new_prototype
	end

	local new_prot = table.deepcopy(prot)
	new_prot.name = "inf-" .. prot.name
	new_prot.infinite_depletion_amount = 0
	new_prot.infinite  = true
	new_prot.minimum   = 15
	new_prot.normal    = 100
	new_prot.autoplace = nil
	-- TODO: change localised_name
	new_prot.localised_name = new_prot.localised_name or {"entity-name." .. prot.name}
	lazyAPI.add_prototype(prot.type, new_prot.name, new_prot)
	return prototype, new_prot
end


---@param prototype table|LAPIWrappedPrototype
---@param armor string|table
---@return table|LAPIWrappedPrototype
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
	---@type string?
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

	-- Sets base functions
	for k, f in pairs(lazyAPI.base) do
		wrapped_prot[k] = f
	end
	wrapped_prot.remove = lazyAPI.base.remove_prototype

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

	if lazyAPI.all_items[_type] then
		for k, f in pairs(lazyAPI.item) do
			wrapped_prot[k] = f
		end
	end

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


---@param prototype table|LAPIWrappedPrototype
---@return LAPIWrappedPrototype # wrapped prototype with lazyAPI functions
lazyAPI.wrap_prototype = function(prototype)
	return wrapped_prototypes[prototype]
end

---@param prototype_type? string
---@param name? string
---@param prototype? table
---@return table, LAPIWrappedPrototype #prototype_data, LAPIWrappedPrototype
---@overload fun(prototype): table, table
function lazyAPI.add_prototype(prototype_type, name, prototype)
	if prototype == nil then
		---@cast prototype_type table?
		prototype = prototype_type
		prototype_type = nil
	end
	prototype = prototype or {}
	prototype.type = prototype_type or prototype.type
	prototype.name = name or prototype.name

	-- Let's check if something will be overwritten
	local prev_instance = data_raw[prototype.type][prototype.name]
	-- Perhaps it should verify this case later instead
	local is_replaced = false
	if prev_instance and prev_instance ~= prototype then
		lazyAPI.deleted_data[prototype.type][prototype.name] = prototype -- TODO: recheck, perhaps I should use a metamethod instead

		local event_data = {prototype = prototype, prev_instance = prev_instance}
		lazyAPI.raise_event("on_pre_prototype_replaced", prototype.type, event_data)

		is_replaced = true
	else
		local event_data = {prototype = prototype}
		lazyAPI.raise_event("on_pre_new_prototype_via_lazyAPI", prototype.type, event_data)
	end

	add_prototypes(data, {prototype}) -- original data.extend

	if is_replaced then
		local event_data = {prototype = prototype, prev_instance = prev_instance}
		lazyAPI.raise_event("on_prototype_replaced", prototype.type, event_data)
	end

	local is_added = (data_raw[prototype.type][prototype.name] == prototype)
	if is_added then
		local removed_prot = lazyAPI.deleted_data[prototype.type][prototype.name]
		if removed_prot == prot then
			lazyAPI.deleted_data[prototype.type][prototype.name] = nil
		end

		local event_data = {prototype = prototype}
		lazyAPI.raise_event("on_new_prototype_via_lazyAPI", prototype.type, event_data)
	end

	return prototype, lazyAPI.wrap_prototype(prototype)
end


return lazyAPI

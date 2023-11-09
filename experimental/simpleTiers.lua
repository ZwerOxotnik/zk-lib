-- STiers is a experimental part of lazyAPI


--- WARNING: perhaps not reliable and perhaphs it'll be changed
---@class STiers
---@module "__zk-lib__/experimental/simpleTiers"
local STiers = {_VERSION = "0.0.1"}


local error = error


STiers.tiers = {
	items = {},
	entities = {},
	units = {},
	vehicles = {},
	ammo = {},
	turrets = {},
	equipments = {},
	tools = {},
	raftine_machines = {},
	rolling_stocks = {}
}


local __data_relations = {
	[lazyAPI.all_items] = STiers.tiers.items,
	[lazyAPI.all_entities] = STiers.tiers.entities,
	[lazyAPI.all_vehicles] = STiers.tiers.vehicles,
	[lazyAPI.all_turrets] = STiers.tiers.turrets,
	[lazyAPI.all_equipments] = STiers.tiers.equipments,
	[lazyAPI.all_tools] = STiers.tiers.tools,
	[lazyAPI.all_craftine_machines] = STiers.tiers.craftine_machines,
	[lazyAPI.all_rolling_stocks] = STiers.tiers.rolling_stocks
}


STiers._types_to_data = {}
for prototypes, tiers in pairs(__data_relations) do
	for _type in pairs(prototypes) do
		STiers._types_to_data[_type] = tiers
	end
end
STiers._types_to_data["unit"] = STiers.units_tiers
STiers._types_to_data["ammo"] = STiers.ammo_tiers
--- TODO: recheck ammo-turret


---@return table?
STiers.get_tier = function(prot)
	local tier = STiers._types_to_data[prot.type][prot]
	if tier == nil then
		error("There's no support for type:" .. prot.type)
		return
	end
	return tier
end


---@param prototype table
---@param source_prototype? table
---@return prototype
STiers.add_to_tiers = function(prototype, source_prototype)
	local prot = prototype.prototype or prototype
	local source_prot = source_prototype.prototype or prototype
	local tiers = STiers.get_tier(source_prot or prot)
	if tiers == nil then
		return prototype
	end

	if source_prototype == nil then
		local tier = tiers[prot]
		if tier == nil then
			tier = {}
			tiers[prot] = tier -- Perhaps, I should use metamethods instead

			local event_data = {prototype = prot, tier = tier}
			lazyAPI.raise_event("on_new_tier", prot.type, event_data)
		end
		return prototype
	end

	local _, is_added = lazyAPI.base.add_to_array(tiers, prototype)
	if is_added then
		local event_data = {tier_prototype = source_prot, prototype = prot, tier = tier}
		lazyAPI.raise_event("on_new_prototype_in_tier", prot.type, event_data)
	end

	return prototype
end

---@param prototype table
---@param source_prototype? table
---@return prototype
STiers.remove_from_tiers = function(prototype, source_prototype)
	local prot = prototype.prototype or prototype
	local source_prot = source_prototype.prototype or prototype
	local tiers = STiers.get_tier(source_prot or prot)
	if tiers == nil then
		return prototype
	end

	if source_prototype == nil then
		local tier = tiers[prot]
		if tier then
			tiers[prot] = nil -- Perhaps, I should use metamethods instead

			local event_data = {tier_prototype = prot, tier = tier}
			lazyAPI.raise_event("on_tier_removed", prot.type, event_data)
		end
		return prototype
	end

	local tier = tiers[prot]
	if tier then
		local _, removed_count = lazyAPI.base.remove_from_array(tier, prot)
		if removed_count > 0 then
			local event_data = {tier_prototype = source_prot, prototype = prot, tier = tier}
			lazyAPI.raise_event("on_prototype_removed_in_tier", prot.type, event_data)
		end
	end

	return prototype
end

---@param source_prototype table
---@param old_prototype table
---@param new_prototype table
STiers.replace_in_tiers = function(source_prototype, old_prototype, new_prototype)
	local source_prot = source_prototype.prototype or old_prototype
	local old_prot = old_prototype.prototype or old_prototype
	local new_prot = new_prototype.prototype or new_prototype
	local tier = STiers.get_tier(source_prot)
	if tier == nil then return end

	local _, is_replaced = lazyAPI.base.replace_in_array(tier, source_prot.name, old_prot, new_prot)
	if is_replaced then
		local event_data = {tier_prototype = source_prot, old_prototype = old_prot, new_prototype = new_prot, tier = tier}
		lazyAPI.raise_event("on_prototype_replaced_in_tier", old_prot.type, event_data) -- TODO: recheck, ambgious case for type
	end
end


return STiers

local container = zk_SPD.containers["important-no-cheat-recipes"]
if #container.functions > 0 then
	local BLACKLISTED_NAMES = {
		-- ["artillery-targeting-remote"] = true
	}
	local function have_ingredients(recipe)
		if recipe.ingredients then return true end
		if recipe.normal and recipe.normal.ingredients then return true end
		if recipe.expensive and recipe.expensive.ingredients then return true end

		return false
	end

	local _data = container.data
	for name, recipe in pairs(data.raw.recipe) do
		if not (recipe.hidden
			and have_ingredients(recipe)
			and BLACKLISTED_NAMES[name]
			and name:find("creative") -- for https://mods.factorio.com/mod/creative-mode etc
			and name:find("hidden")
			and name:find("infinity")
			and name:find("cheat")
			and name:find("[xX]%d+_") -- for https://mods.factorio.com/mod/X100_assembler etc
			and name:find("^osp_") -- for mods.factorio.com/mod/m-spell-pack
			and name:find("^ee%-") -- for https://mods.factorio.com/mod/EditorExtensions
		) then
			_data[#_data+1] = name
		end
	end
end

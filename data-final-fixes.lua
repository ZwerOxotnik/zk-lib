lazyAPI.get_stage() -- in order to get this stage internally

local container = zk_SPD.containers["important-no-cheat-recipes"]
if #container.functions > 0 then
	local _data = container.data
	for name, recipe in pairs(data.raw.recipe) do
		if not (recipe.hidden
			and lazyAPI.recipe.have_ingredients(recipe)
			and lazyAPI.base.is_cheat_prototype(recipe)
		) then
			_data[#_data+1] = name
		end
	end
end

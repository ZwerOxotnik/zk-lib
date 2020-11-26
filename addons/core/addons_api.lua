local module = {}

module.remove_duplicate_addons = function(addons_list)
  for name, addon in pairs(addons_list) do
    if addon.blacklist then
      for _, x_mod_name in pairs(addon.blacklist) do
        for mod_name, _ in pairs(mods) do
          if x_mod_name == mod_name then
            addons_list[name] = nil
            return
          end
        end
      end
		end
	end
end

return module

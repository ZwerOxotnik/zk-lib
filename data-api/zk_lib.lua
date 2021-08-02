local zk_lib = {}


local ceil = math.ceil


local custom_input = data.raw["custom-input"]
-- Extends game interactions, see https://wiki.factorio.com/Prototype/CustomInput#linked_game_control
zk_lib.attach_custom_input_event = function(name)
	local new_name = name .. "-event"
	if custom_input[new_name] then
		log("\"" .. new_name .. "\" already exists")
		return custom_input[new_name]
	end

	data:extend(
	{{
		type = 'custom-input',
		name = new_name,
		key_sequence = '',
		linked_game_control = name,
		consuming = 'none',
		enabled = true
	}})

	return custom_input[new_name]
end

-- Creates tool as capsule to interact with defines.events.on_script_trigger_effect
zk_lib.create_tool = function(tool_data)
	local name = tool_data.name
	local flags = tool_data.flags
	if flags == nil then
		if tool_data.stack_size and tool_data.stack_size > 1 then
			flags = {"hidden", "only-in-cursor"}
		else
			flags = {"hidden", "not-stackable", "only-in-cursor"}
		end
	end
	data:extend(
	{
		{
			type = "projectile",
			name = name,
			flags = {"not-on-map"},
			acceleration = 100,
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
								starting_speed = 100
							}}
						}}
					}
				}
			}
		}
	})
end

---@param raw_data table
---@return table|boolean
zk_lib.merge_localization = function(raw_data)
	local final_data = {}
	if #raw_data > 399 then
			log("Too much data")
			return false
	elseif #raw_data > 10 then
		for i=1, ceil(#raw_data/20)+1 do
			final_data[i] = {""}
		end
		local i1 = 1
		local i2 = 2
		for _, _data in pairs(raw_data) do
			final_data[i1][i2] = _data
			if i2 >= 20 then
		    i1 = i1 + 1
		    i2 = 2
			else
		    i2 = i2 + 1
			end
		end
	else
		final_data = raw_data
	end

	return final_data
end

return zk_lib

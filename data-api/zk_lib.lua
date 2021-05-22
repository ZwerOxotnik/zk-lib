local zk_lib = {}


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

return zk_lib

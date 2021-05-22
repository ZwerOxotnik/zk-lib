local zk_lib = {}


local custom_input = data.raw["custom-input"]
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


return zk_lib

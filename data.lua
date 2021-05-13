puan_api = require("data-api/puan_api")
fakes = require("data-api/fakes")
require("sound/sounds_list")

-- Extends game interactions, see https://wiki.factorio.com/Prototype/CustomInput#linked_game_control
data:extend(
{
	{
		type = 'custom-input',
		name = 'event-move-down',
		key_sequence = '',
		linked_game_control = 'move-down',
		consuming = 'none',
		enabled = true
	},
	{
		type = 'custom-input',
		name = 'event-move-left',
		key_sequence = '',
		linked_game_control = 'move-left',
		consuming = 'none',
		enabled = true
	},
	{
		type = 'custom-input',
		name = 'event-move-right',
		key_sequence = '',
		linked_game_control = 'move-right',
		consuming = 'none',
		enabled = true
	},
	{
		type = 'custom-input',
		name = 'event-move-up',
		key_sequence = '',
		linked_game_control = 'move-up',
		consuming = 'none',
		enabled = true
	},
	{
		type = 'custom-input',
		name = 'event-mine',
		key_sequence = '',
		linked_game_control = 'mine',
		consuming = 'none',
		enabled = true
	},
	{
		type = 'custom-input',
		name = 'event-toggle-map',
		key_sequence = '',
		linked_game_control = 'toggle-map',
		consuming = 'none',
		enabled = true
	}
})

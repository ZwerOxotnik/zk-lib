
---@class ExportModule : module
local M = {}


--#region Global data
--local _players_data
--#endregion


--#region Constants
--local ABS = math.abs
--#endregion


--#region Functions of events

---@param cmd CustomCommandData
function M.export_command(cmd)
	local player_index = cmd.player_index
	local player = game.get_player(player_index)
	local force
	if not player.valid then
		player = nil
		force = game.forces.player
	else
		force = player.force
	end

	local function export(name, data)
		game.write_file("zk_dev_output/" .. name .. ".lua",  serpent.block(data),      false, player_index)
		game.write_file("zk_dev_output/" .. name .. ".json", game.table_to_json(data), false, player_index)
	end

	local all_force_techs = {}
	local not_researched_force_techs = {}
	local researched_force_techs     = {}
	local enabled_force_techs  = {}
	local disabled_force_techs = {}
	local upgradable_force_techs     = {}
	local not_upgradable_force_techs = {}

	for _, tech in pairs(force.technologies) do
		local name = tech.name
		all_force_techs[#all_force_techs+1] = name

		if tech.researched then
			researched_force_techs[#researched_force_techs+1] = name
		else
			not_researched_force_techs[#not_researched_force_techs+1] = name
		end

		if tech.enabled then
			enabled_force_techs[#enabled_force_techs+1]   = name
		else
			disabled_force_techs[#disabled_force_techs+1] = name
		end

		if tech.upgrade then
			upgradable_force_techs[#upgradable_force_techs+1] = name
		else
			not_upgradable_force_techs[#not_upgradable_force_techs+1] = name
		end
	end

	local all_force_recipes = {}
	local enabled_force_recipes  = {}
	local disabled_force_recipes = {}
	for _, recipe in pairs(force.recipes) do
		local name = recipe.name
		all_force_recipes[#all_force_recipes+1] = name

		if recipe.enabled then
			enabled_force_recipes[#enabled_force_recipes+1] = name
		else
			disabled_force_recipes[#disabled_force_recipes+1] = name
		end
	end

	export("all_force_techs", all_force_techs)
	export("not_researched_force_techs", not_researched_force_techs)
	export("researched_force_techs", researched_force_techs)
	export("enabled_force_techs", enabled_force_techs)
	export("disabled_force_techs", disabled_force_techs)
	export("upgradable_force_techs", upgradable_force_techs)
	export("not_upgradable_force_techs", not_upgradable_force_techs)
	export("all_force_recipes", all_force_recipes)
	export("enabled_force_recipes", enabled_force_recipes)
	export("disabled_force_recipes", disabled_force_recipes)
end

function M.on_player_joined_game(event)
	local player = game.get_player(event.player_index)
	if not (player and player.valid) then return end

	player.print("Use /export command to export data into /script-output/zk_dev_output folder (auto export on first join is on)")
	M.export_command(event)
end

--#endregion


--#region Pre-game stage

local function link_data()
	--_players_data = global.players
end

local function update_global_data()
	--global.players = global.players or {}
	--

	link_data()


	--for player_index, player in pairs(game.players) do
	--	-- delete UIs
	--end
end


M.on_init = update_global_data
M.on_configuration_changed = update_global_data
M.on_load = link_data
M.update_global_data_on_disabling = update_global_data -- for safe disabling of this mod

--#endregion


M.events = {
	[defines.events.on_player_joined_game] = M.on_player_joined_game,
}


commands.add_command("export", "exports data into /script-output/zk_dev_output folder", M.export_command)


return M

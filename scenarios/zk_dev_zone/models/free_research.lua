
---@class FreeResearchModule : module
local M = {}


--#region Global data
--local _players_data
--#endregion


--#region Constants
--local ABS = math.abs
--#endregion


--#region Functions of events

function M.on_research_started(event)
	local research = event.research
	if not research.valid then return end

	research.researched = true
	-- TODO: update guis
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
	[defines.events.on_research_started] = M.on_research_started,
}

M.commands = {
	-- set_spawn = set_spawn_command, -- Delete this example
}


return M

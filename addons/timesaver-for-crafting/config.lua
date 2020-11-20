local config = {}

config.update_player = function(player)
  local player_index = player.index
  local mod = global.timesaver_for_crafting
  mod.players[player_index] = mod.players[player_index] or {}

  local player_data = mod.players[player_index]
  player_data.accumulated = player_data.accumulated or 0
  player_data.last_craft_tick = player_data.last_craft_tick or player.online_time
  if player.character and not player.cheat_mode then
    player_data.crafting_state = player_data.crafting_state or (player.crafting_queue ~= nil)
  else
    player_data.crafting_state = false
  end
end

config.init = function()
  global.timesaver_for_crafting = global.timesaver_for_crafting or {}
  local mod = global.timesaver_for_crafting
  mod.players = mod.players or {}

  if game then
    for _, player in pairs( game.players ) do
      config.update_player(player)
    end
  end
end

return config

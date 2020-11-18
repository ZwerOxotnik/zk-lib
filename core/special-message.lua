local module = {}

local function on_player_joined_or_created(event)
    local player = game.players[event.player_index]
    if not (player and player.valid) then return end
    if player.mod_settings["zk-lib_special-message"].value ~= true then return end

    player.mod_settings["zk-lib_special-message"] = {value = false}
    player.print({"mod-setting-description.zk-lib_special-message"})
end

module.events = {
    [defines.events.on_player_joined_game] = on_player_joined_or_created,
    [defines.events.on_player_created] = on_player_joined_or_created
}

return module

--[[
Copyright (C) 2018-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the EUPL, Version 1.2 only (the "LICENCE");
Source: github.com/ZwerOxotnik/zk-lib
]]--

---- Generates sounds etc in programmable speakers
---- Use https://github.com/ZwerOxotnik/Mod-generator

local puan_api = {}

puan_api.check_and_get_sound = function(sound, path)
    local new_sound = {}

    new_sound.aggregation = sound.aggregation
    new_sound.audible_distance_modifier = sound.audible_distance_modifier
    if sound.variations then
        new_sound.variations = sound.variations
    else
        new_sound.filename = sound.filename or path .. sound.name .. ".ogg"
        new_sound.volume = sound.volume
        new_sound.preload = sound.preload
    end

    return new_sound
end

-- Add dummy entities so we can use their sounds to play mod speech sounds using factorio api play_sound()
-- Must use dummy entities because we're limited to playing entity/tile sounds, utility sounds (not extensible), and ambient sounds (counts as music, people often mute ingame music, would have to reenable it etc... )
puan_api.add_dummy_entity = function(name, path, sound)
    data:extend{
    {
        type = "simple-entity",
        name = name,
        flags = {"not-on-map"},
        mined_sound = puan_api.check_and_get_sound(sound, path),
        pictures = {
        {
            filename = "__zk-lib__/graphics/IconDummy.png",
            height = 1,
            width = 1
        }}
    }}
end

puan_api.make_notes = function(sounds, path)
    local notes = {}

    for _, sound in pairs(sounds) do
        table.insert(notes, {
            name = sound.name,
            sound = puan_api.check_and_get_sound(sound, path)
        })
    end

    return notes
end

local programmable_speaker = data.raw["programmable-speaker"]["programmable-speaker"].instruments
puan_api.add_sounds = function(sounds_list)
    for _, sound in pairs(sounds_list.sounds) do
        puan_api.add_dummy_entity("", sounds_list.path, sound)
    end

    if sounds_list.name then
        local notes = puan_api.make_notes(sounds_list.sounds, sounds_list.path)
        return table.insert(programmable_speaker, {name = sounds_list.name, notes = notes})
    end
end

return puan_api

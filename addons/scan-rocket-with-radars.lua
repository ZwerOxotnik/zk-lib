--[[
Copyright (c) 2017, 2019-2020 ZwerOxotnik <zweroxotnik@gmail.com>
Licensed under the MIT licence;

Description: scans surface after launching a missile with radars

You can write and receive any information on the links below.
Source: https://gitlab.com/ZwerOxotnik/scan-rocket-with-radars
Mod portal: https://mods.factorio.com/mod/scan-rocket-with-radars
Homepage: https://forums.factorio.com/viewtopic.php?f=190&t=64614

]]--

local module = {}

local function on_rocket_launched(event)
	local rocket = event.rocket
	local force = rocket.force
	local count = rocket.get_item_count("radar")
	if count > 20 then
		local radius = settings.global["radius-scan-rocket-with-radars"].value * count
		force.chart(rocket.surface, {
			{rocket.position.x - radius, rocket.position.y - radius},
			{rocket.position.x + radius, rocket.position.y + radius}
		})
	elseif count > 0 then
		local radius = settings.global["radius-scan-rocket-with-radars"].value * 19
		force.chart(rocket.surface, {
			{rocket.position.x - radius, rocket.position.y - radius},
			{rocket.position.x + radius, rocket.position.y + radius}
		})
	end
end

module.get_default_events = function()
	local events = {
		[defines.events.on_rocket_launched] = on_rocket_launched
	}

	local on_nth_tick = {}

	return events, on_nth_tick
end

return module

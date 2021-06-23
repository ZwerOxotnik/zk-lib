
local module = {}


local function destroy_gui(element)
	if element.name == "zk-close" then
		element.parent.parent.destroy()
	end
end


---@type table<number|string, function>
module.events = {
	[defines.events.on_gui_click] = function(event)
		pcall(destroy_gui, event.element)
	end
}


return module

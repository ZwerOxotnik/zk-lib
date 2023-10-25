lazyAPI.get_stage() -- in order to get this stage internally


--#region set tags
local materials = {"iron", "steel", "copper", "gold", "brass", "tin", "invar",
	"chromium", "nickel", "carbon", "titanium", "lead", "bronze", "diamond",
	"stone", "coal", "wood", "uranium", "ruby", "rubber", "sulphur", "electrum",
	"plastic", "silicon", "charcoal", "coal", "glass"
}
local add_tags = lazyAPI.base.add_tags
local recipes = data.raw.recipe
local items = data.raw.item
for _, v in pairs(materials) do
	local name = v .. "-gear-wheel"
	add_tags(recipes[name], "gear")
	add_tags(items[name],   "gear")
	name = v .. "-plate"
	add_tags(recipes[name], "plate")
	add_tags(items[name],   "plate")
	name = v .. "-plate-heavy"
	add_tags(recipes[name], "plate")
	add_tags(items[name],   "plate")
	name = v .. "-cartridge"
	add_tags(recipes[name], "cartridge")
	add_tags(items[name],   "cartridge")
	name = v .. "-magazine"
	add_tags(recipes[name], "magazine")
	add_tags(data.raw.ammo[name],   "magazine")
	name = v .. "-ingot"
	add_tags(recipes[name], "ingot")
	add_tags(items[name],   "ingot")
	name = v .. "-stick"
	add_tags(recipes[name], "rod")
	add_tags(items[name],   "rod")
	name = v .. "-rod"
	add_tags(recipes[name], "rod")
	add_tags(items[name],   "rod")
	name = v .. "-beam"
	add_tags(recipes[name], "beam")
	add_tags(items[name],   "beam")
	name = v .. "-pellet"
	add_tags(recipes[name], "pellet")
	add_tags(items[name],   "pellet")
	name = v .. "-frame-small"
	add_tags(recipes[name], "frame")
	add_tags(items[name],   "frame")
	name = v .. "-frame-medium"
	add_tags(recipes[name], "frame")
	add_tags(items[name],   "frame")
	name = v .. "-frame-large"
	add_tags(recipes[name], "frame")
	add_tags(items[name],   "frame")
	name = v .. "-motor"
	add_tags(recipes[name], "motor")
	add_tags(items[name],   "motor")
	name = v .. "-piston"
	add_tags(recipes[name], "piston")
	add_tags(items[name],   "piston")
	name = v .. "-board"
	add_tags(recipes[name], "circuit") -- perhaps wrong
	add_tags(items[name],   "circuit") -- perhaps wrong
end

for _, v in pairs{"advanced", "electronic"} do
	local name = v .. "-circuit"
	add_tags(recipes[name], "circuit")
	add_tags(items[name],   "circuit")
end
add_tags(recipes["processing-unit"], "circuit")
add_tags(items["processing-unit"],   "circuit")
--#endregion

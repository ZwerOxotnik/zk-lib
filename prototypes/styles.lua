local styles = data.raw["gui-style"].default -- TODO: add via easyAPI


styles.zk_action_button_dark = {
  type = "button_style",
  parent = "slot_button",
	default_font_color = {1, 1, 1},
	height = 30
}


styles.zk_transparent_frame = {
	type = "frame_style",
	vertically_stretchable = "on",
	horizontally_stretchable = "on",
	graphical_set = {
		base = {
			center = {position = {336, 0}, size = {1, 1}},
			opacity = 0.1,
			background_blur = false,
			blend_mode = "multiplicative-with-alpha"
		},
		shadow = default_glow(hard_shadow_color, 1)
	}
}


styles.zk_dark_transparent_frame = {
	type = "frame_style",
	left_padding = 6,
	right_margin = 10,
	maximal_height = 20,
	graphical_set = {
		base = {
			center = {position = {336, 0}, size = {1, 1}},
			opacity = 0.4,
			background_blur = true,
			background_blur_sigma = 0.5,
			blend_mode = "additive-soft-with-alpha"
		},
		shadow = default_glow(default_shadow_color, 0.5)
	}
}

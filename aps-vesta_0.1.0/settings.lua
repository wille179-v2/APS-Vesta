APS.add_choice("vesta")

data:extend({
	{
		type = "int-setting",
		name = "vesta-rock-multiplier",
		setting_type = "startup",
		default_value = 5,
		minimum_value = 1,
		maximum_value = 10
	}
})
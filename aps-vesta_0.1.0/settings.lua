APS.add_choice("vesta")

local hideComplexMode = false -- Hides complex mode and related setting while I'm still building that part.

data:extend({
	{
		type = "int-setting",
		name = "vesta-rock-multiplier",
		setting_type = "startup",
		default_value = 6,
		minimum_value = 1,
		maximum_value = 10
	},
	{
		type = "bool-setting",
		name = "complex-filters-do-not-break",
		setting_type = "startup",
		default_value = true,
		hidden = hideComplexMode 
	},
	{
		type = "bool-setting",
		name = "complex-mode-bonus-items",
		setting_type = "startup",
		default_value = false,
		hidden = hideComplexMode
	},
})

data.raw["bool-setting"]["ske_vesta_legacy_recipes"].hidden = hideComplexMode
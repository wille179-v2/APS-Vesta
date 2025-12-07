local utils = require("utils")

-- remove prerequisites for "s1_cluster_processing"
-- put "electronics" & "steam-power" behind "s1_cluster_processing"
-- Increase yield for mining entities "vesta-petrite" & "vesta_rock_huge" by 10x
-- Make crude cryogenic plant and crude biochamber unlocked earlier
-- Earthly Roots and Dreaming of Greener Pastures swap order.
-- Fluid Tank and Medium Power Pole unlock with Steel processing
-- Rework Crude Oil process... somehow?

local vestaGraphics1 = "__skewer_planet_vesta_assets__/graphics/"
local vestaGraphics2 = "__skewer_planet_vesta_assets_2__/graphics/"

local rockMult = settings.startup["vesta-rock-multiplier"].value

-- Update Rock mining results
data.raw["simple-entity"]["vesta_rock_huge"].minable.results = {
	{type = "item", name = "stone",  amount_min = 2*rockMult, amount_max = 6*rockMult},
	{type = "item", name = "algea_nutrient_clump", amount_min = 0, amount_max = 2*rockMult},
	{type = "item", name = "calcized-iron-plate", amount_min = 3*rockMult, amount_max = 15*rockMult},
	{type = "item", name = "calcized-copper-plate", amount_min = 1*rockMult, amount_max = 8*rockMult},
}
data.raw["simple-entity"]["vesta-petrite"].minable.results = {
	{type = "item", name = "ske_algea_clump_petrite",  amount_min = 2*rockMult, amount_max = 6*rockMult},
	{type = "item", name = "algea_nutrient_clump", amount_min = 0, amount_max = 1*rockMult},
	{type = "item", name = "calcized-iron-plate", amount_min = 1*rockMult, amount_max = 3*rockMult},
	{type = "item", name = "calcized-copper-plate", amount_min = 1*rockMult, amount_max = 3*rockMult},
}


-- Add basic smelting recipe
data:extend{
	{
		type = "recipe",
		name = "smelt-iron-algae",
		icons = {
			{icon = vestaGraphics1 .. "icons/algea_clump_iron.png"},
			{icon = "__base__/graphics/icons/signal/signal-fire.png", scale = .3, shift = {8,8}}
		},
		enabled = false,
		ingredients = {
			{type = "item", name = "ske_algea_clump_iron", amount = 1}
		},
		results = {
			{type = "item", name = "iron-ore", amount = 1}
		},
		category = "smelting",
		energy_required = 1.6,
		allow_productivity = true,
		allow_decomposition = false,
		subgroup = "vesta-items-organic"
	},
	{
		type = "recipe",
		name = "smelt-copper-algae",
		icons = {
			{icon = vestaGraphics1 .. "icons/algea_clump_copper.png"},
			{icon = "__base__/graphics/icons/signal/signal-fire.png", scale = .3, shift = {8,8}}
		},
		enabled = false,
		ingredients = {
			{type = "item", name = "ske_algea_clump_copper", amount = 1}
		},
		results = {
			{type = "item", name = "copper-ore", amount = 1}
		},
		category = "smelting",
		energy_required = 1.6,
		allow_productivity = true,
		allow_decomposition = false,
		subgroup = "vesta-items-organic"
	},
	{
		type = "recipe",
		name = "smelt-stone-algae",
		icons = {
			{icon = vestaGraphics1 .. "icons/algea_clump_stonite.png"},
			{icon = "__base__/graphics/icons/signal/signal-fire.png", scale = .3, shift = {8,8}}
		},
		enabled = false,
		ingredients = {
			{type = "item", name = "ske_algea_clump_stonite", amount = 1}
		},
		results = {
			{type = "item", name = "stone", amount = 1}
		},
		category = "smelting",
		energy_required = 1.6,
		allow_productivity = true,
		allow_decomposition = false,
		subgroup = "vesta-items-organic"
	},
}

-- Broaden recipe categories for ease of use
data.raw["recipe"]["ske_algea_clump_iron"].category = "organic-or-chemistry"
data.raw["recipe"]["ske_algea_clump_copper"].category = "organic-or-chemistry"
data.raw["recipe"]["ske_algea_clump_stonite"].category = "organic-or-chemistry"
data.raw["recipe"]["ske-carbon-super-cooling"].category = "chemistry-or-cryogenics"


-- Alter tech tree
if settings.startup["ske_vesta_legacy_recipes"].value then -- Complex Mode (the Default)
	utils.set_prerequisites("s1_cluster_processing", {})
	--s1_cluster_processing("steam_power",{"s1_cluster_processing"})
	--s1_cluster_processing("electronics",{"s1_cluster_processing"})

else -- Simple Mode
	utils.set_prerequisites("s1_cluster_processing", {})
	utils.remove_recipes("s1_dueterium",{"nutrients-from-co2"})
	utils.add_recipes("s1_algea_discovery",{"nutrients-from-co2","nutrients-from-spoilage"})
	utils.add_recipes("s1_algea_culturing",{"smelt-iron-algae","smelt-copper-algae","smelt-stone-algae"})

	utils.remove_recipes("oil-processing",{"chemical-plant"})
	utils.add_recipes("automation-2",{"chemical-plant"})
	utils.remove_recipes("cat-dreaming-of-greener-pastures",{"burnt-spoilage"})
	utils.add_recipes("s1_algea_discovery",{"burnt-spoilage"})
	utils.remove_recipes("fluid-handling",{"storage-tank"})
	utils.add_recipes("steel-processing",{"storage-tank"})
	utils.remove_recipes("electric-energy-distribution-1",{"medium-electric-pole"})
	utils.add_recipes("steel-processing",{"medium-electric-pole"})

	utils.add_prerequisites("s1_gas_manipulation_science_pack",{"advanced-circuit"})
	
	utils.set_prerequisites("cat-dreaming-of-greener-pastures",{"landfill","automation"})
	utils.set_prerequisites("cat-earthly-roots",{"cat-dreaming-of-greener-pastures"})
	utils.remove_packs("cat-dreaming-of-greener-pastures",{"chemical-science-pack"})

	utils.remove_packs("cat-frozen-dreams",{"production-science-pack","utility-science-pack","space-science-pack"})
	utils.set_prerequisites("cat-frozen-dreams",{"cat-energize-innovation"})

	utils.set_trigger("oil-processing",{type = "craft-fluid",fluid="methane"})
	utils.remove_recipes("s1_algea_extracting",{"ske_methane_petro"})
	utils.add_recipes("oil-processing",{"ske_methane_petro"})
	utils.set_prerequisites("oil-processing",{"fluid-handling"})

	utils.set_unit("carbon-dioxide",{
		time = 30,
		count = 500,
		ingredients = {
			{"automation-science-pack",1},
			{"logistic-science-pack",1},
			{"chemical-science-pack",1},
			{"gas-manipulation-science-pack",1},
		}
	})
	utils.set_unit("hydrogen-sulfide",{
		time = 30,
		count = 500,
		ingredients = {
			{"automation-science-pack",1},
			{"logistic-science-pack",1},
			{"chemical-science-pack",1},
			{"gas-manipulation-science-pack",1},
		}
	})

	utils.remove_packs("s2_plateworkings",{"utility-science-pack","electromagnetic-science-pack"})

	

end
local utils = require("utils")

-- remove prerequisites for "s1_cluster_processing"
-- put "electronics" & "steam-power" behind "s1_cluster_processing"
--X Increase yield for mining entities "vesta-petrite" & "vesta_rock_huge" by 10x
-- Make crude cryogenic plant and crude biochamber unlocked earlier
-- Earthly Roots and Dreaming of Greener Pastures swap order.
--X Fluid Tank and Medium Power Pole unlock with Steel processing
--X Rework Crude Oil process... somehow?

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

-- Add single very crude resource sifting recipe

data:extend({
	{
		type = "recipe",
		name = "gas-sifting",
		enabled = false,
		icons = {
			{icon = vestaGraphics1 .. "icons/algea_nutrient_clump.png", scale = .25, shift = {-8,-8}},
			{icon = vestaGraphics2 .. "icons/calcized-copper-1.png", scale = .25, shift = {8,-8}},
			{icon = vestaGraphics2 .. "icons/calcized-iron-1.png", scale = .25, shift = {8,8}},
			{icon = "__base__/graphics/icons/stone.png", scale = .25, shift = {-8,8}},
		},
		ingredients = {
			{type = "fluid", name = "carbon-dioxide", amount = 100},
			{type = "fluid", name = "nitrogen", amount = 100},
		},
		results = {
			{type = "item", name = "calcized-copper-plate", amount = 1, probability = .5},
			{type = "item", name = "calcized-iron-plate", amount = 1, probability = .5},
			{type = "item", name = "stone", amount = 1, probability = .1},
			{type = "item", name = "ske_algea_clump_petrite", amount = 1, probability = .05},
			{type = "item", name = "algea_nutrient_clump", amount = 1, probability = .02},
		},
		energy_required = 1.75,
		category = "organic-or-chemistry",
		subgroup = "vesta-items-organic",
		allow_productivity = true,
		allow_decomposition = false
	}
})

utils.add_recipes("s1_cluster_processing",{"gas-sifting"})

-- Broaden shared recipe categories for ease of use
data.raw["recipe"]["ske_algea_clump_iron"].category = "organic-or-chemistry"
data.raw["recipe"]["ske_algea_clump_copper"].category = "organic-or-chemistry"
data.raw["recipe"]["ske_algea_clump_stonite"].category = "organic-or-chemistry"

-- Make cluster processing immediately available
utils.set_prerequisites("s1_cluster_processing", {})

--Move chemical plant earlier
utils.remove_recipes("oil-processing",{"chemical-plant"})
utils.add_recipes("automation-2",{"chemical-plant"})

-- Move medium power poles and fluid tanks earlier
utils.remove_recipes("fluid-handling",{"storage-tank"})
utils.remove_recipes("electric-energy-distribution-1",{"medium-electric-pole","iron-stick"})
utils.add_recipes("steel-processing",{"storage-tank","medium-electric-pole","iron-stick"})

-- Makes the biochamber available much earlier
utils.set_prerequisites("cat-dreaming-of-greener-pastures",{"automation"})
utils.add_recipes("cat-dreaming-of-greener-pastures",{"landfill"})
utils.set_prerequisites("cat-earthly-roots",{"cat-dreaming-of-greener-pastures"})
utils.set_unit("cat-dreaming-of-greener-pastures",{
	time = 30,
	count = 50,
	ingredients = {
		{"automation-science-pack",1},
		{"logistic-science-pack",1}
	}
})

-- Frozen Dreams now only requires the bare minimum needed to produce the crude cryogenic plant
utils.remove_packs("cat-frozen-dreams",{"production-science-pack","utility-science-pack","space-science-pack"})
utils.set_prerequisites("cat-frozen-dreams",{"cat-energize-innovation"})

-- Alter tech tree
if settings.startup["ske_vesta_legacy_recipes"].value then -- Complex Mode (the Default)
	
	-- Broaden complex recipe categories for ease of use
	data.raw["recipe"]["ske_carbon_super_cooling"].category = "chemistry-or-cryogenics"
	data.raw["recipe"]["ske_ammonia_vesta"].category = "chemistry-or-cryogenics"
	data.raw["recipe"]["ske_algea_clump"].category = "organic-or-chemistry"

	utils.remove_recipes("s1_brine",{"vesta-lithium-solidification"})
	utils.add_recipes("lithium-processing",{"vesta-lithium-solidification"})

	utils.add_recipes("s1_algea_culturing",{"ske_algea_clump_iron","ske_algea_clump_copper"})
	utils.remove_recipes("s1_algea_treatment",{"ske_algea_clump_iron","ske_algea_clump_copper"})

	utils.add_recipes("s1_algea_filtering",{"iron-stick"})

	-- Makes it possible to hand-craft sand.
	local sandRecipe = data.raw["recipe"]["sand"]
	sandRecipe.ingredients = {
		{type = "item", name = "stone", amount = 2}
	}
	sandRecipe.results = {
		{type = "item", name = "sand", amount = 4}
	}
	sandRecipe.category = "crafting"

	-- Make algae filters not break
	if settings.startup["complex-filters-do-not-break"].value then 
		--local petriteAlgae = data.raw["recipe"]["ske_algea_clump_petrite"]
		local algaeProd = data.raw["recipe"]["ske_algea_clump"]
		local filterTreatment = data.raw["recipe"]["ske_algea_filter_cleaning"]

		--petriteAlgae.results[3].probability = 1
		algaeProd.results[3].probability = 1
		filterTreatment.results[3].probability = 1
	end



else -- Simple Mode

	-- Broaden simple recipe categories for ease of use
	data.raw["recipe"]["ske-carbon-super-cooling"].category = "chemistry-or-cryogenics"


	-- Make nutrients available earlier
	utils.remove_recipes("s1_dueterium",{"nutrients-from-co2"})
	utils.add_recipes("s1_algea_discovery",{"nutrients-from-co2","nutrients-from-spoilage"})

	-- Move burnt spoilage earlier
	utils.remove_recipes("cat-dreaming-of-greener-pastures",{"burnt-spoilage"})
	utils.add_recipes("s1_algea_discovery",{"burnt-spoilage"})

	utils.add_prerequisites("s1_gas_manipulation_science_pack",{"advanced-circuit"})
	

	-- Reworks basic oil tech to work on Vesta
	utils.set_trigger("oil-processing",{type = "craft-fluid",fluid="methane"})
	utils.remove_recipes("s1_algea_extracting",{"ske_methane_petro"})
	utils.add_recipes("oil-processing",{"ske_methane_petro"})
	utils.set_prerequisites("oil-processing",{"fluid-handling"})

	-- deuterium needs the oil refinery
	utils.add_prerequisites("s1_dueterium",{"oil-processing"})

	-- carbon dioxide and hydrogen sulfide are craftable earlier
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

	-- Makes combustion furnaces available earlier
	utils.remove_packs("s2_plateworkings",{"utility-science-pack","electromagnetic-science-pack"})

	-- Allows heavy oil to be crafted
	utils.remove_recipes("s1_gas_manipulation_science_pack",{"ske_crude_solution"})
	utils.add_recipes("s1_algea_extracting",{"ske_crude_solution"})
	utils.add_prerequisites("advanced-oil-processing",{"s1_algea_extracting"})


	-- Changes lithium-processing from trigger to unit
	utils.set_trigger("lithium-processing",nil)
	utils.set_unit("lithium-processing",{
		time = 30,
		count = 250,
		ingredients = {
			{"automation-science-pack",1},
			{"logistic-science-pack",1},
			{"chemical-science-pack",1},
			{"production-science-pack",1},
			{"space-science-pack",1},
		}
	})

	-- Gas manipulation Science Pack requires Energize innovation for holmium solution
	utils.add_prerequisites("s1_gas_manipulation_science_pack",{"cat-energize-innovation"})

	-- Fusion Robots do not require fulgora, but do require basic bots
	utils.remove_packs("s2_fusion_enhancements",{"electromagnetic-science-pack"})
	utils.remove_packs("s2_fusion_robots",{"electromagnetic-science-pack"})
	utils.add_prerequisites("s2_fusion_robots",{"logistic-robotics","construction-robotics"})
	-- Bot upgrade no longer requires gleba

	if pcall(function() utils.remove_packs("worker-robot-storage-vesta",{"agricultural-science-pack"}) end) then
		log("Something happened with Agri pack again...")
	end

	utils.add_prerequisites("cat-energize-innovation",{"advanced-oil-processing"})

end

-- Makes crude cryoplant able to handle plasma
crudeCryoplant = data.raw["assembling-machine"]["cat-cryogenic-plant-mk1"]
crudeCryoplant.fluid_boxes[1].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
crudeCryoplant.fluid_boxes[2].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
crudeCryoplant.fluid_boxes[3].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
crudeCryoplant.fluid_boxes[4].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
crudeCryoplant.fluid_boxes[5].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
crudeCryoplant.fluid_boxes[6].pipe_connections[1].connection_category = {"fusion-plasma", "default"}
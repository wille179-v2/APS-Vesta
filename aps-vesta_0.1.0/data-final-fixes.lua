local utils = require("utils")

-- Loosen prerequisites on heating tower
utils.set_prerequisites("heating-tower",{"concrete"})

-- Fix holmium processing
if settings.startup["ske_vesta_legacy_recipes"].value then
	utils.set_prerequisites("holmium-processing", {"s1_exotic_algae"})
end
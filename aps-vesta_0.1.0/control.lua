
script.on_init(function()
    local vestaStart = (settings.startup["aps-planet"].value == "vesta")
    local bonusItems = settings.startup["complex-mode-bonus-items"].value and settings.startup["ske_vesta_legacy_recipes"].value
    local bonusMult = bonusItems and 2 or 1

    if not remote.interfaces["freeplay"] then return end
    if not vestaStart then return end

    remote.call("freeplay", "set_ship_items", {
	    ["iron-plate"] = 100 * bonusMult,
        ["copper-plate"] = 50 * bonusMult,
        ["stone"] = 50 * bonusMult
    })
    remote.call("freeplay", "set_created_items", {
        ["cat-biochamber-mk1"] = 5 * bonusMult,
	    ["cat-cryogenic-plant-mk1"] = 5 * bonusMult,
        ["chemical-plant"] = 5 * bonusMult,
        ["medium-electric-pole"] = 20,
        ["solar-panel"] = 5 * bonusMult,
        ["accumulator"] = 2 * bonusMult,
        ["stone-furnace"] = 1 * bonusMult,
        ["storage-tank"] = 4 * bonusMult,
        ["offshore-pump"] = 2 * bonusMult,
        ["efficiency-module"] = bonusItems and 2 or 0
    })
    remote.call("freeplay", "set_debris_items", {
        ["iron-plate"] = 50 * bonusMult,
        ["copper-plate"] = 50 * bonusMult,
    })


end)
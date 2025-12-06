
script.on_init(function()
    local vestaStart = (settings.startup["aps-planet"].value == "vesta")

    if not remote.interfaces["freeplay"] then return end
    if not vestaStart then return end

    remote.call("freeplay", "set_ship_items", {
	    ["iron-plate"] = 100,
        ["copper-plate"] = 50,
        ["stone"] = 50
    })
    remote.call("freeplay", "set_created_items", {
        ["cat-biochamber-mk1"] = 5,
	    ["cat-cryogenic-plant-mk1"] = 5,
        ["medium-electric-pole"] = 20,
        ["solar-panel"] = 5,
        ["accumulator"] = 2
    })
    remote.call("freeplay", "set_debris_items", {
        ["iron-plate"] = 50,
        ["copper-plate"] = 50,
    })


end)
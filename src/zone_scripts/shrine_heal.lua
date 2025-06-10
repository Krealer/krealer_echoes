-- Ritual healing shrine interaction
local M = {}

function M.run()
    local utils = require("src.utils")
    utils.healPlayer(combat.player.maxHp, combat.player.maxMp)
    print("A calm voice whispers: 'Return to the fight.'")
    if journal then
        journal:addEntry("shrine_heal", "Wounds closed at shrine without standard medicine.", {"anomaly"})
    end
    return { state = "echo", context = { text = "Your wounds close in eerie silence", duration = 2 } }
end

return M

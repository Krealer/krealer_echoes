-- Ritual healing shrine interaction
local M = {}

function M.run()
    local utils = require("src.utils")
    utils.healPlayer(combat.player.maxHp, combat.player.maxMp)
    print("A calm voice whispers: 'Return to the fight.'")
    return { state = "echo", context = { text = "Your wounds close in eerie silence", duration = 2 } }
end

return M

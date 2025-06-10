-- Example zone script: shrine01
-- Heals the player and triggers a brief memory flash
local M = {}

function M.run()
    print("You feel a serene warmth from the unseen shrine.")
    combat.player.hp = combat.player.maxHp
    combat.player.mp = combat.player.maxMp
    if game and game.addReputation then
        game:addReputation("faith", 1)
    end
    -- Return state change instruction
    return { state = "echo", context = { text = "An ancient shrine shimmers in your mind", duration = 2 } }
end

return M

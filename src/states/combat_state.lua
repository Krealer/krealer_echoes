--========================================
-- combat_state.lua
-- State handler for turn-based combat
-- Connects to combat.lua and isolates its logic
--========================================

local combat_state = {}

-- Called when the combat state begins
function combat_state:enter(context)
    -- Optional: receive data like enemy type, terrain, music, etc.
    print("[Combat state entered]")
    
    -- Start combat with passed enemy data, fallback dummy
    local enemyData = context.enemy or { name = "Null Agent", hp = 60, dmg = 10 }
    combat:start(enemyData)
end

-- Called every frame while in combat
function combat_state:update(dt)
    combat:update(dt)
end

-- Renders combat UI
function combat_state:draw()
    combat:draw()
end

-- Handles input during combat
function combat_state:keypressed(key)
    combat:keypressed(key)
end

return combat_state

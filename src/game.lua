--========================================
-- game.lua
-- Core game initializer and global flags
-- Tracks session state, debug tools, and progression
--========================================

game = {}

--========================================
-- Global Flags & Persistent Data
--========================================
game.flags = {
    debug = true,
    version = "alpha-0.1",
    playerName = "Krealer",          -- Future: allow player rename
    introCompleted = false,
    currentMap = "map01",
    firstCombatWon = false,
    hasMetJayson = false,
    nullMentioned = false,
    reputation = 0,
    dialogueHistory = {},
    npc = {},                -- per-NPC persistent memory
    sharedFlags = {},        -- optional flags shared between NPCs
    showFOV = false,
    echoFlags = {}
}

--========================================
-- Game boot logic (call in love.load)
--========================================
function game:init()
    print("== Krealer: Echoes of the Null ==")
    print("Initializing...")
    print("Version: " .. game.flags.version)
end

--========================================
-- Global reset utility
--========================================
function game:reset()
    print("== Game Reset ==")
    game.flags.introCompleted = false
    game.flags.firstCombatWon = false
    game.flags.hasMetJayson = false
    game.flags.nullMentioned = false
    inventory:clear()
    player.x, player.y = 1, 1
    local map = require("src.maps." .. game.flags.currentMap)
    currentMap = map
    currentMap:load()
    state:set("exploration")
end

--========================================
-- Debug overlay (shown when debug=true)
--========================================
function game:drawDebug(x, y)
    if not game.flags.debug then return end

    love.graphics.setColor(0.9, 0.9, 0.9)
    love.graphics.print("== DEBUG MODE ==", x, y)
    love.graphics.print("FPS: " .. love.timer.getFPS(), x, y + 15)
    love.graphics.print("State: " .. state:get(), x, y + 30)
    love.graphics.print("Player: " .. player.x .. "," .. player.y, x, y + 45)
    love.graphics.print("Map: " .. tostring(game.flags.currentMap), x, y + 60)
    love.graphics.print("HP: " .. combat.player.hp .. " | MP: " .. combat.player.mp, x, y + 75)
end

--========================================
-- Draw fields of view for debugging
--========================================
function game:drawFOVOverlay()
    if not game.flags.showFOV then return end
    local tile = config.tileSize
    love.graphics.setColor(0, 0.6, 1, 0.3)
    for _, e in ipairs(entityManager.entities) do
        if e.visionRange then
            local tiles = utils.getTilesInViewCone(e.x, e.y, e.facing, e.visionRange)
            for _, t in ipairs(tiles) do
                love.graphics.rectangle("line", (t.x - 1) * tile, (t.y - 1) * tile, tile, tile)
            end
        end
    end
end

--========================================
-- map01.lua
-- First playable map for Krealer: Echoes of the Null
-- Contains grid layout and starting entities
--========================================

local map = {}

-- Map dimensions (same as config unless overridden)
map.width = config.mapWidth
map.height = config.mapHeight

-- Simple tile data (0 = empty, 1 = wall)
map.tiles = {
    {1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
}

-- Load function: spawns entities on the map
function map:load()
    entityManager:clear()

    -- Place NPCs
    entityManager:add({ x = 2, y = 2, type = "npc", name = "Jayson" })

    -- Place objects
    entityManager:add({ x = 4, y = 4, type = "object", name = "Chest", opened = false })
    entityManager:add({ x = 5, y = 6, type = "object", name = "Healing Pit" })

    -- Place enemies
    entityManager:add({ x = 7, y = 7, type = "enemy", name = "Null Agent", hp = 60, dmg = 12 })

    -- Optional: override player spawn
    player.x = 1
    player.y = 1
end

return map

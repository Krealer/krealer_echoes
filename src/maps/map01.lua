--========================================
-- map01.lua
-- First playable map for Krealer: Echoes of the Null
-- Contains grid layout and starting entities
--========================================

local entityManager = require("src.entities.entity_manager")

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
    {1,0,0,0,{tile=0, zone="shrine01"},0,0,0,0,1},
    {1,0,0,0,{tile=0, echo_trigger=true, id="trace01", text="A distant scream echoes."},0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
}

-- Zones monitored by Null surveillance
map.surveillanceZones = {
    { x1 = 3, y1 = 4, x2 = 7, y2 = 6 }
}

map.exits = {
    { x = 10, y = 5, map = "map02", toX = 2, toY = 5 }
}

-- Load function: spawns entities on the map
function map:load()
    entityManager:clear()

    -- Place NPCs
    entityManager:add({ x = 2, y = 2, type = "npc", name = "Jayson" })

    -- Place objects
    entityManager:add({ x = 4, y = 4, type = "object", name = "Chest", opened = false })
    -- Ritual pit that fully restores HP/MP when interacted with
    entityManager:add({ x = 5, y = 6, type = "shrine", name = "Healing Pit" })

    -- Place enemies
    entityManager:add({ x = 7, y = 7, type = "enemy", name = "Null Agent", hp = 60, dmg = 12 })

    -- Optional: override player spawn
    player.x = 1
    player.y = 1
end

return map

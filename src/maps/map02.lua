--========================================
-- map02.lua
-- Second test map - continues from map01
--========================================

local map = {}

map.width = config.mapWidth
map.height = config.mapHeight

map.tiles = {
    {1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,1,1,1,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,1,1,0,0,1,1,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1}
}

map.exits = {
    { x = 1, y = 5, map = "map01", toX = 9, toY = 5 }
}

function map:load()
    entityManager:clear()

    -- Add a hostile NPC (test)
    entityManager:add({ x = 3, y = 3, type = "npc", name = "Watchman" })
    entityManager:add({ x = 5, y = 4, type = "object", name = "Healing Pit" })
    entityManager:add({ x = 7, y = 7, type = "enemy", name = "Null Hunter", hp = 70, dmg = 18 })

    -- Optional door back to map01
    entityManager:add({ x = 1, y = 1, type = "object", name = "Door", destination = "map01" })

    player.x = 8
    player.y = 8
end

return map

--========================================
-- entity_manager.lua
-- Manages all NPCs, enemies, and objects on the map
-- Provides lookup, spawn, draw, and clear logic
--========================================

local entityManager = {}

-- Holds all active entities on the current map
entityManager.entities = {}

--========================================
-- Add a new entity to the map
-- Required fields: x, y, type = "npc"/"enemy"/"object"/"shrine", name
--========================================
function entityManager:add(entity)
    assert(entity.x and entity.y, "Entity must have x and y")
    assert(entity.type, "Entity must have a type")

    if entity.type == "npc" or entity.type == "enemy" then
        entity.visionRange = entity.visionRange or 3
        entity.facing = entity.facing or "down"
        entity.seenPlayer = entity.seenPlayer or false
    end

    table.insert(self.entities, entity)
end

--========================================
-- Reset all entities (e.g., when changing map)
--========================================
function entityManager:clear()
    self.entities = {}
end

--========================================
-- Return entity at a given tile position (x, y)
-- Only one entity per tile assumed
--========================================
function entityManager:getAt(x, y)
    for _, e in ipairs(entityManager.entities) do
        if e.x == x and e.y == y then
            return e
        end
    end
    return nil
end

--========================================
-- Draw all entities on the map (as symbols)
-- Symbols:
--  🟢 NPC = "N", 🔴 Enemy = "E", 🟡 Object = "O"
--========================================
function entityManager:draw()
    local tile = config.tileSize

    for _, e in ipairs(entityManager.entities) do
        local char = "?"
        local color = config.color.object

        if e.type == "npc" then
            char = "N"
            color = config.color.npc
        elseif e.type == "enemy" then
            char = "E"
            color = config.color.enemy
        elseif e.type == "object" then
            char = "O"
            color = config.color.object
        elseif e.type == "shrine" then
            char = "S"
            color = config.color.shrine or config.color.object
        end

        love.graphics.setColor(color)
        love.graphics.print(char, e.x * tile + 8, e.y * tile + 8)
    end
end

return entityManager

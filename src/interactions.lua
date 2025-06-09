--========================================
-- interactions.lua
-- Handles proximity-based interaction logic
-- Scans adjacent tiles for NPCs, enemies, or objects
--========================================

-- Dependencies
local utils = require("src.utils")

--========================================
-- Get any entity at a given position
-- (Typically defined in entity_manager)
--========================================
function getEntityAt(x, y)
    for _, entity in ipairs(entityManager.entities) do
        if entity.x == x and entity.y == y then
            return entity
        end
    end
    return nil
end

--========================================
-- Main interaction logic:
-- Checks tiles around Krealer
-- Triggers proper state/module
--========================================
function checkInteraction()
    for _, dir in ipairs(utils.directions) do
        local tx = player.x + dir.x
        local ty = player.y + dir.y

        local entity = getEntityAt(tx, ty)
        if entity then
            if entity.type == "npc" then
                local npc = require("src.npc." .. entity.name:lower())
                npc:onInteract()
                return
            elseif entity.type == "enemy" then
                print("[!] Combat initiated with " .. (entity.name or "Unknown Enemy"))
                state:set("combat", { enemy = entity })
                return
            elseif entity.type == "object" then
                local objects = require("src.entities.objects")
                objects.interact(entity)
                return
            end
        end
    end

    -- No valid interaction found
    print("There's nothing to engage with.")
end

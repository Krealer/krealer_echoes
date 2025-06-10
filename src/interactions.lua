--========================================
-- interactions.lua
-- Handles proximity-based interaction logic
-- Scans adjacent tiles for NPCs, enemies, or objects
--========================================

-- Dependencies
local utils = require("src.utils")
local entityManager = require("src.entities.entity_manager")

local interactions = {}

--========================================
-- Main interaction logic:
-- Checks tiles around Krealer
-- Triggers proper state/module
--========================================
function interactions.check()
    for _, dir in ipairs(utils.directions) do
        local tx = player.x + dir.x
        local ty = player.y + dir.y

        local entity = entityManager:getAt(tx, ty)
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
            elseif entity.type == "shrine" then
                local zone = require("src.zone")
                zone.trigger("shrine_heal")
                game.flags.shrinesVisited[entity.name] = true
                return
            end
        end
    end

    -- No valid interaction found
    print("There's nothing to engage with.")
end

--========================================
-- Called when a hostile entity spots the player
--========================================
function interactions.alert(entity)
    print("[!] " .. (entity.name or "Enemy") .. " spotted you!")
    state:set("combat", { enemy = entity })
end

return interactions

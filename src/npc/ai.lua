--========================================
-- ai.lua
-- Basic roaming and hostile behaviour for NPCs
--========================================

local entityManager = require("src.entities.entity_manager")
local map = require("src.map")
local utils = require("src.utils")

local npc_ai = {}

-- Update all NPCs each frame
function npc_ai:update(dt)
    for _, e in ipairs(entityManager.entities) do
        if e.type == "npc" then
            -- Initialise AI fields
            e.aiTimer = (e.aiTimer or 0) - dt
            e.aiState = e.aiState or "idle"
            e.dirIndex = e.dirIndex or math.random(#utils.directions)

            if e.aiTimer <= 0 then
                if e.aiState == "idle" then
                    -- Idle: either rotate or start walking
                    if math.random() < 0.5 then
                        e.dirIndex = (e.dirIndex % #utils.directions) + 1
                        e.aiTimer = 1
                    else
                        e.aiState = "walk"
                    end
                elseif e.aiState == "walk" then
                    local dir = utils.directions[e.dirIndex]
                    local nx, ny = e.x + dir.x, e.y + dir.y
                    if map.isWalkable(nx, ny) and not entityManager:getAt(nx, ny) then
                        e.x, e.y = nx, ny
                    end
                    e.aiState = "idle"
                    e.aiTimer = 1
                end
            end

            -- Hostile NPCs engage Krealer if adjacent
            if e.hostile then
                local dx = math.abs(player.x - e.x)
                local dy = math.abs(player.y - e.y)
                if dx + dy <= 1 then
                    state:set("combat", { enemy = e })
                end
            end
        end
    end
end

return npc_ai

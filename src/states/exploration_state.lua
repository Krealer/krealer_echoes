--========================================
-- exploration_state.lua
-- Main free-roam exploration mode
-- Handles movement, interaction proximity, and map rendering
--========================================

local exploration_state = {}
local map = require("src.map")
local interactions = require("src.interactions")
local npcAI = require("src.npc.ai")
local entityManager = require("src.entities.entity_manager")
local utils = require("src.utils")

-- Optional: track time since last interaction or event
local interactionCooldown = 0.1
local timer = 0

function exploration_state:enter()
    print("[Entered exploration state]")
end

function exploration_state:update(dt)
    timer = timer - dt

    player:update(dt)
    npcAI:update(dt)
    map.update(dt)

    for _, e in ipairs(entityManager.entities) do
        if e.visionRange then
            if player:isInFOV(e) then
                e.seenPlayer = true
                if e.hostile then
                    interactions.alert(e)
                end
            else
                e.seenPlayer = false
            end
        end
    end
end

function exploration_state:draw()
    if currentMap and currentMap.tiles then
        map.draw(currentMap.tiles)
    end

    if config.debug then
        game:drawDebug(10, 10)
    end
end

function exploration_state:keypressed(key)
    if timer > 0 then return end

    player:keypressed(key)

    -- Interaction
    if input:matches(key, config.controls.interact) then
        interactions.check()
        timer = interactionCooldown
    elseif key == "f2" then
        state:set("controls")
    elseif input:isJournalToggle(key) then
        state:set("journal", { returnTo = "exploration" })
    end
end

return exploration_state

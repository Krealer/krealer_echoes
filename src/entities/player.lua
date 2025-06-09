--========================================
-- player.lua
-- Controls Krealer's position, movement, and interaction logic
--========================================

local map = require("src.map")
local entityManager = require("src.entities.entity_manager")
local interactions = require("src.interactions")

player = {}

-- Position (in tile coordinates)
player.x = config.playerStartX
player.y = config.playerStartY

-- Movement cooldown timer
local moveCooldown = 0.15
local moveTimer = 0

--========================================
-- Update (handles movement cooldown)
--========================================
function player:update(dt)
    moveTimer = moveTimer - dt

    if moveTimer <= 0 then
        if input:isPressed("up") then
            self:tryMove(0, -1)
        elseif input:isPressed("down") then
            self:tryMove(0, 1)
        elseif input:isPressed("left") then
            self:tryMove(-1, 0)
        elseif input:isPressed("right") then
            self:tryMove(1, 0)
        end
    end
end

--========================================
-- Attempt to move (checks map bounds and collisions later)
--========================================
function player:tryMove(dx, dy)
    local newX = self.x + dx
    local newY = self.y + dy

    -- Map boundaries are one-based like map.isWalkable
    if newX < 1 or newY < 1 or newX > config.mapWidth or newY > config.mapHeight then
        return
    end

    -- Block movement into walls or occupied tiles
    if not map.isWalkable(newX, newY) then return end
    if entityManager:getAt(newX, newY) then return end

    -- Move
    self.x = newX
    self.y = newY
    moveTimer = moveCooldown
end

--========================================
-- Key pressed: used for interaction trigger
--========================================
function player:keypressed(key)
    if key == "space" or key == "return" then
        interactions.check()
    elseif key == "i" then
        state:set("inventory")
    end
end

--========================================
-- Draw player symbol on map
--========================================
function player:draw()
    local tile = config.tileSize
    love.graphics.setColor(config.color.player)
    love.graphics.print(config.playerSymbol, self.x * tile + 8, self.y * tile + 8)
end

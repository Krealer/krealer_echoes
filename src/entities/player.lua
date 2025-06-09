--========================================
-- player.lua
-- Controls Krealer's position, movement, and interaction logic
--========================================

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

    -- Map boundaries
    if newX < 0 or newY < 0 or newX >= config.mapWidth or newY >= config.mapHeight then
        return
    end

    -- TODO: block movement into solid tiles if needed

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
        checkInteraction()
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

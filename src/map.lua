--========================================
-- map.lua
-- Grid rendering + logic for map tiles
-- Includes dynamic centering and scaling
--========================================

local entityManager = require("src.entities.entity_manager")

local map = {}

-- Draw the tile grid with centering and scaling
function map.draw(tileGrid)
    local tileSize = config.tileSize
    local mapWidth = config.mapWidth * tileSize
    local mapHeight = config.mapHeight * tileSize

    local screenWidth, screenHeight = love.graphics.getDimensions()

    -- Integer scale factor for pixel-perfect rendering
    local scale = math.floor(math.min(screenWidth / mapWidth, screenHeight / mapHeight))

    -- Centered offset after scaling
    local offsetX = math.floor((screenWidth - (mapWidth * scale)) / 2)
    local offsetY = math.floor((screenHeight - (mapHeight * scale)) / 2)

    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    -- Draw map tiles
    for y = 1, #tileGrid do
        for x = 1, #tileGrid[y] do
            local tile = tileGrid[y][x]
            if tile == 1 then
                love.graphics.setColor(0.2, 0.2, 0.2) -- Wall
            else
                love.graphics.setColor(0.1, 0.1, 0.1) -- Floor
            end
            love.graphics.rectangle("fill", (x - 1) * tileSize, (y - 1) * tileSize, tileSize, tileSize)
        end
    end

    -- Draw entities + player in scaled space
    entityManager:draw()
    player:draw()

    love.graphics.pop() -- Reset transform for UI
end

-- Check if a tile is walkable
function map.isWalkable(x, y)
    if x < 1 or y < 1 or x > config.mapWidth or y > config.mapHeight then
        return false
    end
    return currentMap.tiles[y][x] == 0
end

return map

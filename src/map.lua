--========================================
-- map.lua
-- Grid rendering + logic for map tiles
-- Includes dynamic centering and scaling
--========================================

local entityManager = require("src.entities.entity_manager")
local state = require("src.state")

local map = {}

-- Load a map by name and optionally position the player
function map.loadMap(name, spawn)
    local newMap = require("src.maps." .. name)
    currentMap = newMap
    game.flags.currentMap = name
    currentMap:load()
    if spawn then
        player.x = spawn.x or player.x
        player.y = spawn.y or player.y
    end
end

-- Check if player is on an exit tile and trigger transition
function map.checkExit(x, y)
    if not currentMap.exits then return end
    for _, ex in ipairs(currentMap.exits) do
        if ex.x == x and ex.y == y then
            map.loadMap(ex.map, { x = ex.toX, y = ex.toY })
            break
        end
    end
end

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
            local tileData = tileGrid[y][x]
            local tile = type(tileData) == "table" and tileData.tile or tileData
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
    game:drawFOVOverlay()

    love.graphics.pop() -- Reset transform for UI
end

-- Update per-frame for map triggers
function map.update(dt)
    if not currentMap or not currentMap.tiles then return end

    local tileData = currentMap.tiles[player.y] and currentMap.tiles[player.y][player.x]
    if type(tileData) == "table" then
        if tileData.echo_trigger then
            local id = tileData.id or (game.flags.currentMap .. ":" .. player.x .. ":" .. player.y)
            if not game.flags.echoFlags[id] then
                game.flags.echoFlags[id] = true
                state:set("echo", { text = tileData.text, duration = tileData.duration or 1.5 })
            end
        end

        if tileData.zone then
            utils.triggerZone(tileData.zone)
        end
    end
end

-- Check if a tile is walkable
function map.isWalkable(x, y)
    if x < 1 or y < 1 or x > config.mapWidth or y > config.mapHeight then
        return false
    end
    local data = currentMap.tiles[y][x]
    local tile = type(data) == "table" and data.tile or data
    return tile == 0
end

return map

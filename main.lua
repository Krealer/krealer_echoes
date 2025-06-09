--========================================
-- main.lua
-- Entry point for Krealer: Echoes of the Null
-- Initializes subsystems, draws game loop, delegates input
--========================================

-- Core modules
local config        = require("src.config")
local state         = require("src.state")
local game          = require("src.game")
local utils         = require("src.utils")
local input         = require("src.input")
local map           = require("src.map")
local player        = require("src.entities.player")
local entityManager = require("src.entities.entity_manager")
local interactions  = require("src.interactions")
local dialogue      = require("src.dialogue")
local inventory     = require("src.inventory")
local combat        = require("src.combat")

--========================================
-- love.load: Called once on game startup
--========================================
function love.load()
    love.graphics.setFont(love.graphics.newFont(12))
    love.window.setTitle("Krealer: Echoes of the Null")

    -- Boot core systems
    game:init()

    -- Load default map
    local initialMap = require("src.maps.map01")
    currentMap = initialMap
    currentMap:load()

    -- Position player
    player.x, player.y = 5, 5

    -- Set default state
    state:set("exploration")
end

--========================================
-- love.update: Called every frame
--========================================
function love.update(dt)
    state:update(dt)
end

--========================================
-- love.draw: Called every frame to render visuals
--========================================
function love.draw()
    state:draw()
    game:drawDebug(280, 10) -- Debug overlay (if enabled)
end

--========================================
-- love.keypressed: Handles key inputs
--========================================
function love.keypressed(key)
    -- Toggle fullscreen on [F]
    if key == "f" then
        local fullscreen = love.window.getFullscreen()
        love.window.setFullscreen(not fullscreen)
        print("Fullscreen: " .. tostring(not fullscreen))
        return
    end

    -- Pass other keys to state manager
    state:keypressed(key)
end

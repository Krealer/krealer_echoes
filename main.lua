--========================================
-- main.lua
-- Entry point for Krealer: Echoes of the Null
-- Initializes subsystems, draws game loop, delegates input
--========================================

-- Core modules (loaded in global scope)
require("src.config")
require("src.state")                      -- State manager
require("src.game")                       -- Global flags/init
require("src.utils")                      -- Direction helpers
require("src.input")                      -- Input handling
require("src.map")                        -- Map loading
require("src.entities.player")            -- Player entity
require("src.entities.entity_manager")    -- All interactables
require("src.interactions")               -- Tile interaction logic
require("src.dialogue")                   -- Dialogue system
require("src.inventory")                  -- Inventory logic
require("src.combat")                     -- Combat engine

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

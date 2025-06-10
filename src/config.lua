--========================================
-- config.lua
-- Global game configuration and constants
-- Used by all systems (map, player, grid size, etc.)
--========================================

config = {}

-- TILE SYSTEM
config.tileSize = 32             -- Each tile is 32x32 pixels
config.mapWidth = 10            -- Width of the map in tiles
config.mapHeight = 10           -- Height of the map in tiles

-- PLAYER
config.playerStartX = 5         -- Starting X tile
config.playerStartY = 5         -- Starting Y tile
config.playerSymbol = "@"       -- Drawn on map as pure text

-- UI / COLORS (optional)
config.color = {
    npc    = {0, 1, 0},         -- Green
    enemy  = {1, 0, 0},         -- Red
    object = {1, 1, 0},         -- Yellow
    player = {1, 1, 1},         -- White
    grid   = {0.3, 0.3, 0.3}    -- Grey grid lines
}

-- SYSTEM BEHAVIOR FLAGS
config.interactionRange = 1     -- Max distance (in tiles) to interact
config.textSpeed = 1            -- Placeholder for timed text effects
config.debug = true             -- Master toggle for debug print/overlay

-- CONTROLS (for custom remapping later if needed)
config.controls = {
    up       = {"w", "up"},
    down     = {"s", "down"},
    left     = {"a", "left"},
    right    = {"d", "right"},
    interact = {"space", "return"},
    cancel   = {"escape"},
    confirm  = {"return"},
    inventory = {"i"}
}

return config

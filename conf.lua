--========================================
-- conf.lua
-- LOVE configuration (called before love.load)
-- Sets resolution, title, modules
--========================================
function love.conf(t)
    t.identity = "krealer_echoes"        -- Save directory
    t.version = "11.4"                   -- LOVE2D version
    t.console = false                    -- Set to true if debugging on PC

    -- Window settings
    t.window.title = "Krealer: Echoes of the Null"
    t.window.width = 400
    t.window.height = 240
    t.window.resizable = false
    t.window.vsync = true
    t.window.fullscreen = false

    -- Modules to disable if unused
    t.modules.joystick = true
    t.modules.physics  = false
    t.modules.audio    = false
end

--========================================
-- input.lua
-- Abstracts input from keyboard and gamepad
-- Used for universal direction + action detection
--========================================

input = {}

-- Active gamepad (if connected)
local gamepad = nil

-- Called when a joystick is plugged in
function love.joystickadded(j)
    gamepad = j
    print("Gamepad connected: " .. j:getName())
end

-- Called when joystick removed
function love.joystickremoved(j)
    if j == gamepad then
        gamepad = nil
        print("Gamepad disconnected.")
    end
end

--========================================
-- Real-time directional/action input checks
-- Called in love.update or per-frame polling
--========================================
function input:isPressed(action)
    local k = love.keyboard.isDown
    local binds = config.controls[action] or {}
    for _, b in ipairs(binds) do
        if k(b) then return true end
    end
    return false
end

--========================================
-- One-shot key event match
-- Use in love.keypressed(key) or menu selection
--========================================
function input:matches(key, action)
    local valid = config.controls[action]
    if not valid then return false end

    for _, v in ipairs(valid) do
        if key == v then return true end
    end

    return false
end

--========================================
-- Inventory: parse keys 1-9 into index
--========================================
function input:getNumberPressed(key)
    local index = tonumber(key)
    if index and index >= 1 and index <= 9 then
        return index
    end
    return nil
end

--========================================
-- Convenience for journal toggle
--========================================
function input:isJournalToggle(key)
    return self:matches(key, "journal")
end

-- Optional stealth modifier key
function input:isStealth()
    return love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") or love.keyboard.isDown("l")
end

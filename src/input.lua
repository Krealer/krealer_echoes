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
    local g = gamepad and gamepad.isGamepadDown and gamepad.isGamepadDown

    if action == "up" then
        return k("w") or k("up") or (g and gamepad:isGamepadDown("dpup"))
    elseif action == "down" then
        return k("s") or k("down") or (g and gamepad:isGamepadDown("dpdown"))
    elseif action == "left" then
        return k("a") or k("left") or (g and gamepad:isGamepadDown("dpleft"))
    elseif action == "right" then
        return k("d") or k("right") or (g and gamepad:isGamepadDown("dpright"))
    elseif action == "interact" then
        return k("space") or k("return") or (g and gamepad:isGamepadDown("y"))
    elseif action == "confirm" then
        return k("return") or (g and gamepad:isGamepadDown("a"))
    elseif action == "cancel" then
        return k("escape") or (g and gamepad:isGamepadDown("b"))
    elseif action == "inventory" then
        return k("i") or (g and gamepad:isGamepadDown("x"))
    end

    return false
end

--========================================
-- One-shot key event match
-- Use in love.keypressed(key) or menu selection
--========================================
function input:matches(key, action)
    local keymap = {
        up = { "w", "up" },
        down = { "s", "down" },
        left = { "a", "left" },
        right = { "d", "right" },
        interact = { "space", "return", "y" },
        confirm = { "return", "a" },
        cancel = { "escape", "b" },
        inventory = { "i", "x" }
    }

    local valid = keymap[action]
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

--========================================
-- inventory_state.lua
-- Displays and interacts with the player's inventory
-- Simple list view for healing and utility items
--========================================

local inventory_state = {}

local selectedIndex = 1

function inventory_state:enter()
    print("[Inventory opened]")
    selectedIndex = 1
end

function inventory_state:update(dt)
    -- No animation or timers needed
end

function inventory_state:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("== INVENTORY ==", 20, 20)

    local items = inventory.items
    if #items == 0 then
        love.graphics.print("Empty.", 40, 60)
        return
    end

    for i, item in ipairs(items) do
        local prefix = (i == selectedIndex) and "→ " or "   "
        love.graphics.print(prefix .. item.name .. " [" .. item.type .. "]", 40, 40 + i * 20)
    end

    love.graphics.print("[Enter] Use | [Esc] Exit", 20, 320)
end

function inventory_state:keypressed(key)
    local items = inventory.items
    if key == "up" and selectedIndex > 1 then
        selectedIndex = selectedIndex - 1
    elseif key == "down" and selectedIndex < #items then
        selectedIndex = selectedIndex + 1
    elseif key == "return" or key == "space" then
        local item = items[selectedIndex]
        if item then
            inventory:use(item)
        end
    elseif key == "escape" then
        state:set("exploration")
    end
end

return inventory_state

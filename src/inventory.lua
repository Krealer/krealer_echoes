--========================================
-- inventory.lua
-- Krealer's item management system (no assets)
-- Supports add/remove/use logic for various item types
--========================================

inventory = {}

local game = rawget(_G, "game")

-- Holds item entries like:
-- { name = "Null Salve", type = "healing", effect = 25 }
inventory.items = {}

--========================================
-- Add an item to the inventory
--========================================
function inventory:add(item)
    table.insert(self.items, item)
    print("Picked up: " .. (item.name or "Unknown Item"))
end

--========================================
-- Remove an item by index
--========================================
function inventory:remove(index)
    if self.items[index] then
        print("Removed: " .. self.items[index].name)
        table.remove(self.items, index)
    end
end

--========================================
-- Use logic based on item type
--========================================
function inventory:use(item)
    if not item then return end

    if item.type == "healing" then
        local gain = item.effect or 0
        combat.player.hp = math.min(combat.player.hp + gain, combat.player.maxHp)
        print("Used " .. item.name .. ". Healed " .. gain .. " HP.")
        self:remove(self:indexOf(item))

    elseif item.type == "key" then
        print("Used " .. item.name .. ". It fits something...") -- key logic handled elsewhere
        self:remove(self:indexOf(item))

    elseif item.type == "focus" then
        local gain = item.effect or 0
        combat.player.mp = math.min(combat.player.mp + gain, combat.player.maxMp)
        print("Consumed " .. item.name .. ". Restored " .. gain .. " MP.")
        self:remove(self:indexOf(item))

    elseif item.type == "boost" then
        local stat = item.stat
        local amount = item.effect or 0
        if stat and combat.player[stat] then
            combat.player[stat] = combat.player[stat] + amount
            print("Used " .. item.name .. ". " .. stat .. " increased by " .. amount .. ".")
        else
            print("Used " .. item.name .. ".")
        end
        self:remove(self:indexOf(item))

    else
        print("Used " .. item.name .. ".")
        self:remove(self:indexOf(item))
    end
end

--========================================
-- Helper: get index of item in table
--========================================
function inventory:indexOf(item)
    for i, it in ipairs(self.items) do
        if it == item then return i end
    end
    return nil
end

--========================================
-- Clear entire inventory (e.g. on reset)
--========================================
function inventory:clear()
    self.items = {}
    print("Inventory cleared.")
end

--========================================
-- Draw inventory contents (called from state)
--========================================
function inventory:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("== INVENTORY ==", 20, 30)

    local y = 40
    if #self.items == 0 then
        love.graphics.print("Empty.", 40, y)
    else
        for i, item in ipairs(self.items) do
            love.graphics.print(i .. ". " .. item.name .. " [" .. item.type .. "]", 40, y + i * 20)
        end
    end

    y = y + (#self.items + 2) * 20
    love.graphics.print("== SKILLS ==", 20, y)
    local skills = (game and game.skillsUnlocked) or {}
    local offset = y + 20
    if next(skills) == nil then
        love.graphics.print("None unlocked.", 40, offset)
    else
        for name,_ in pairs(skills) do
            love.graphics.print("- " .. name, 40, offset)
            offset = offset + 20
        end
    end

    love.graphics.print("[Enter] Use  |  [Esc] Back", 20, offset + 20)
end

--========================================
-- Input handler (used by inventory_state)
--========================================
function inventory:keypressed(key)
    local index = tonumber(key)
    if index and self.items[index] then
        self:use(self.items[index])
    elseif key == "escape" then
        state:set("exploration")
    end
end

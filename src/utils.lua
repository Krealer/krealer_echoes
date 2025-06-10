--========================================
-- utils.lua
-- Shared helper functions used throughout the game
--========================================

utils = {}
local zone = require("src.zone")

-- Clamp a value between a min and max
function utils.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Check if two positions match
function utils.isSamePos(x1, y1, x2, y2)
    return x1 == x2 and y1 == y2
end

-- Deep copy a table (used to duplicate templates without linking)
function utils.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for k, v in pairs(orig) do
            copy[utils.deepcopy(k)] = utils.deepcopy(v)
        end
    else
        copy = orig
    end
    return copy
end

-- Safe table access: returns default if key is nil
function utils.get(tbl, key, default)
    if tbl[key] ~= nil then
        return tbl[key]
    else
        return default
    end
end

-- Print a table for debugging
function utils.debugTable(tbl, indent)
    indent = indent or 0
    for k, v in pairs(tbl) do
        local spacing = string.rep("  ", indent)
        if type(v) == "table" then
            print(spacing .. tostring(k) .. ":")
            utils.debugTable(v, indent + 1)
        else
            print(spacing .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

-- Directional lookup table for adjacency scans
utils.directions = {
    {x = 0, y = -1}, -- up
    {x = 0, y = 1},  -- down
    {x = -1, y = 0}, -- left
    {x = 1, y = 0}   -- right
}

-- Direction name lookup
utils.directionVectors = {
    up    = { x = 0, y = -1 },
    down  = { x = 0, y = 1 },
    left  = { x = -1, y = 0 },
    right = { x = 1, y = 0 }
}

--========================================
-- Return tiles in a simple vision cone
-- Expands one tile to the sides per step
--========================================
function utils.getTilesInViewCone(x, y, direction, range)
    local dir = utils.directionVectors[direction]
    if not dir then return {} end

    local tiles = {}
    local perp = { x = -dir.y, y = dir.x }

    for i = 1, range do
        local cx = x + dir.x * i
        local cy = y + dir.y * i
        table.insert(tiles, { x = cx, y = cy })
        table.insert(tiles, { x = cx + perp.x, y = cy + perp.y })
        table.insert(tiles, { x = cx - perp.x, y = cy - perp.y })
    end

    return tiles
end

-- Simple delay helper storing callbacks
local pendingDelays = {}

function utils.delay(seconds, callback)
    table.insert(pendingDelays, {t = seconds, cb = callback})
end

function utils.updateDelays(dt)
    for i = #pendingDelays, 1, -1 do
        local d = pendingDelays[i]
        d.t = d.t - dt
        if d.t <= 0 then
            d.cb()
            table.remove(pendingDelays, i)
        end
    end
end

-- Debug helper to display reputation values
function utils.drawReputation(x, y)
    if not game or not game.flags or not game.flags.reputation then return end
    local offset = 0
    love.graphics.setColor(1,1,1)
    for region, value in pairs(game.flags.reputation) do
        love.graphics.print(region .. ": " .. tostring(value), x, y + offset)
        offset = offset + 15
    end
end

-- Trigger a zone event by name
function utils.triggerZone(name)
    zone.trigger(name)
end

return utils

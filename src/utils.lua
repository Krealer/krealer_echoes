--========================================
-- utils.lua
-- Shared helper functions used throughout the game
--========================================

utils = {}

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

return utils

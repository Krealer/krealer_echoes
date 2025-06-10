--========================================
-- zone.lua
-- Handles invisible event zones triggered when stepping on certain tiles
-- Loads and executes scripts once per zone
--========================================

local zone = {}

-- Trigger a zone by name
function zone.trigger(name)
    if not name then return end
    game.flags.zonesTriggered = game.flags.zonesTriggered or {}

    -- Prevent repeat triggers unless explicitly reset
    if game.flags.zonesTriggered[name] then return end

    local ok, script = pcall(require, "src.zone_scripts." .. name)
    if not ok then
        print("[Zone] Missing script for " .. name)
        game.flags.zonesTriggered[name] = true
        return
    end

    local result
    if type(script) == "function" then
        result = script()
    elseif type(script) == "table" and script.run then
        result = script.run()
    end

    game.flags.zonesTriggered[name] = true

    state:processZoneResult(result)
end

return zone

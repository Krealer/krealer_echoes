--========================================
-- controls_state.lua
-- Simple key rebinding interface
--========================================

local controls_state = {}
local actions = { "up","down","left","right","interact","inventory" }
local selected = 1
local waiting = false

function controls_state:enter()
    selected = 1
    waiting = false
end

function controls_state:update(dt) end

function controls_state:draw()
    love.graphics.setColor(1,1,1)
    love.graphics.print("== CONTROLS ==",20,20)
    for i, act in ipairs(actions) do
        local prefix = (i==selected) and "-> " or "   "
        local bind = table.concat(config.controls[act] or {}, ",")
        love.graphics.print(prefix..act..": "..bind,40,40+i*20)
    end
    if waiting then
        love.graphics.print("Press a key...",20,280)
    end
    love.graphics.print("[Enter] Rebind  [Esc] Back",20,300)
end

function controls_state:keypressed(key)
    if waiting then
        config.controls[actions[selected]] = { key }
        waiting = false
        return
    end
    if key == "up" and selected>1 then
        selected = selected -1
    elseif key=="down" and selected<#actions then
        selected = selected +1
    elseif key=="return" or key=="space" then
        waiting = true
    elseif key=="escape" then
        state:set("exploration")
    end
end

return controls_state

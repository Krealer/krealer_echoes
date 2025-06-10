--========================================
-- echo_state.lua
-- Brief hallucination/flashback when stepping on special tiles
--========================================

local exploration = require("src.states.exploration_state")

local echo_state = {}
local timer = 0
local text = ""
local returnState = "exploration"

function echo_state:enter(context)
    timer = (context and context.duration) or 1.5
    text = context and context.text or "Echoes of the Null..."
    returnState = (context and context.returnState) or "exploration"
    print("[Echo trace triggered]")
end

function echo_state:update(dt)
    timer = timer - dt
    if timer <= 0 then
        state:set(returnState)
    end
end

function echo_state:draw()
    exploration:draw()
    love.graphics.setColor(1,1,1,0.6)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,0.8,0.8)
    love.graphics.print(text, 20, 20)
end

function echo_state:keypressed(key)
    -- input disabled during echo
end

return echo_state

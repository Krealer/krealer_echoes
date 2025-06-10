--========================================
-- journal_state.lua
-- View Krealer's analytical journal
--========================================

local journal_state = {}
local returnState = "exploration"

function journal_state:enter(context)
    returnState = (context and context.returnTo) or "exploration"
end

function journal_state:update(dt) end

function journal_state:draw()
    journal:draw()
end

function journal_state:keypressed(key)
    if input:matches(key, config.controls.journal) or key == "escape" then
        state:set(returnState)
    end
end

return journal_state

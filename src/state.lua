--========================================
-- state.lua
-- Manages high-level game states (exploration, dialogue, combat, inventory)
-- Routes update/draw/input calls to the proper active subsystem
--========================================

state = {}

-- Current game state
local currentState = "exploration"

-- Optional: context shared when switching states (e.g., current enemy, NPC, map info)
state.context = {}

-- All available state modules
local exploration = require("src.states.exploration_state")
local dialogue    = require("src.states.dialogue_state")
local combat      = require("src.states.combat_state")
local inventoryUI = require("src.states.inventory_state")
local controlsUI  = require("src.states.controls_state")
local echo        = require("src.states.echo_state")

--========================================
-- Set the current state and optional context
--========================================
function state:set(newState, context)
    if currentState == "dialogue" and newState ~= "dialogue" then
        local ctx = state.context or {}
        if ctx.onExit then ctx.onExit() end
    end

    currentState = newState
    state.context = context or {}

    print("== STATE: " .. newState .. " ==")

    -- Initialize if needed
    if newState == "dialogue" then
        local target = context and context.tree
        dialogue:enter({ tree = target, start = context and context.start, npc = context and context.npc })
    elseif newState == "combat" then
        combat:start(context.enemy)
    elseif newState == "inventory" then
        inventoryUI:enter(context)
    elseif newState == "controls" then
        controlsUI:enter(context)
    elseif newState == "echo" then
        echo:enter(context)
    end
end

--========================================
-- Return the current state name
--========================================
function state:get()
    return currentState
end

-- Called by zone scripts to enact state changes
function state:processZoneResult(result)
    if type(result) == "table" and result.state then
        self:set(result.state, result.context)
    end
end

--========================================
-- Update dispatcher
--========================================
function state:update(dt)
    if currentState == "exploration" then
        exploration:update(dt)
    elseif currentState == "dialogue" then
        dialogue:update(dt)
    elseif currentState == "combat" then
        combat:update(dt)
    elseif currentState == "inventory" then
        inventoryUI:update(dt)
    elseif currentState == "controls" then
        controlsUI:update(dt)
    elseif currentState == "echo" then
        echo:update(dt)
    end
end

--========================================
-- Draw dispatcher
--========================================
function state:draw()
    if currentState == "exploration" then
        exploration:draw()
    elseif currentState == "dialogue" then
        exploration:draw() -- background stays visible
        dialogue:draw()
    elseif currentState == "combat" then
        exploration:draw() -- keep map visible
        combat:draw()
    elseif currentState == "inventory" then
        exploration:draw() -- underlying map stays
        inventoryUI:draw()
    elseif currentState == "controls" then
        controlsUI:draw()
    elseif currentState == "echo" then
        echo:draw()
    end
end

--========================================
-- Input dispatcher
--========================================
function state:keypressed(key)
    if currentState == "exploration" then
        exploration:keypressed(key)
    elseif currentState == "dialogue" then
        dialogue:keypressed(key)
    elseif currentState == "combat" then
        combat:keypressed(key)
    elseif currentState == "inventory" then
        inventoryUI:keypressed(key)
    elseif currentState == "controls" then
        controlsUI:keypressed(key)
    elseif currentState == "echo" then
        echo:keypressed(key)
    end
end

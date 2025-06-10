--========================================
-- dialogue_state.lua
-- Manages active dialogue interaction with an NPC
-- Supports branching choices, psychological expression
--========================================

local dialogue_state = {}

local inventory = require("src.inventory")
local game = require("src.game")
local traits = require("src.traits")

-- Dialogue context (set when state is entered)
local dialogueTree = nil
local currentNode = nil

-- Called when dialogue begins
function dialogue_state:enter(context)
    if not context or not context.tree then
        print("[Dialogue state received no tree]")
        return
    end

    dialogueTree = context.tree

    if not dialogueTree.start then
        print("[Dialogue error] Tree missing 'start' node")
        state:set("exploration")
        return
    end

    currentNode = dialogueTree.start

    if currentNode.onSelect then
        currentNode.onSelect()
    end

    print("[Dialogue started]")
end

-- Draw dialogue text + choices
function dialogue_state:draw()
    if not currentNode then return end

    local y = 40
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(currentNode.text, 20, y)
    y = y + 40

    for i, choice in ipairs(currentNode.choices or {}) do
        local available = true
        if choice.repMin and game.flags.reputation < choice.repMin then
            available = false
        end
        if choice.requiresHistory and not game.flags.dialogueHistory[choice.requiresHistory] then
            available = false
        end
        if choice.requiresTrait and not traits:has(choice.requiresTrait) then
            available = false
        end
        if available then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0.5,0.5,0.5)
        end
        love.graphics.print(i .. ". " .. choice.text, 40, y + i * 20)
    end
end

-- Handle input: pick a response (1–4)
function dialogue_state:keypressed(key)
    if not currentNode or not currentNode.choices then return end

    local index = tonumber(key)
    if index and currentNode.choices[index] then
        local choice = currentNode.choices[index]

        if choice.repMin and game.flags.reputation < choice.repMin then return end
        if choice.requiresHistory and not game.flags.dialogueHistory[choice.requiresHistory] then return end
        if choice.requiresTrait and not traits:has(choice.requiresTrait) then return end

        if choice.reward then
            inventory:add(choice.reward)
        end

        if choice.map then
            local map = require("src.maps." .. choice.map)
            currentMap = map
            game.flags.currentMap = choice.map
            currentMap:load()
        end

        if choice.repChange then
            game.flags.reputation = game.flags.reputation + choice.repChange
        end
        if choice.historyKey then
            game.flags.dialogueHistory[choice.historyKey] = true
        end

        if choice.state then
            state:set(choice.state)
            if choice.state ~= "dialogue" then
                return
            end
        end

        local nextKey = choice.next
        local nextNode = nextKey and dialogueTree[nextKey]

        if nextNode then
            currentNode = nextNode
            if currentNode.onSelect then
                currentNode.onSelect()
            end
        elseif nextKey then
            print("[Dialogue node missing: " .. tostring(nextKey) .. "]")
            state:set("exploration")
        end
    elseif key == "escape" then
        state:set("exploration")
    end
end

-- No update logic needed (static)
function dialogue_state:update(dt) end

return dialogue_state

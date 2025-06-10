--========================================
-- dialogue_state.lua
-- Manages active dialogue interaction with an NPC
-- Supports branching choices, psychological expression
--========================================

local dialogue_state = {}

local inventory = require("src.inventory")

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
        love.graphics.print(i .. ". " .. choice.text, 40, y + i * 20)
    end
end

-- Handle input: pick a response (1–4)
function dialogue_state:keypressed(key)
    if not currentNode or not currentNode.choices then return end

    local index = tonumber(key)
    if index and currentNode.choices[index] then
        local choice = currentNode.choices[index]

        if choice.reward then
            inventory:add(choice.reward)
        end

        if choice.map then
            local map = require("src.maps." .. choice.map)
            currentMap = map
            game.flags.currentMap = choice.map
            currentMap:load()
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

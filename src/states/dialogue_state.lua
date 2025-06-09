--========================================
-- dialogue_state.lua
-- Manages active dialogue interaction with an NPC
-- Supports branching choices, psychological expression
--========================================

local dialogue_state = {}

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
    currentNode = dialogueTree.start

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
        local nextKey = currentNode.choices[index].next
        local nextNode = dialogueTree[nextKey]

        if nextNode then
            currentNode = nextNode
        else
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

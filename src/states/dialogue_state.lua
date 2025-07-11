--========================================
-- dialogue_state.lua
-- Manages active dialogue interaction with an NPC
-- Supports branching choices, psychological expression
--========================================

local dialogue_state = {}
local function meetsRequirements(req, npc)
    if not req then return true end
    local mem = npc and npc.memory or {}
    local shared = game.flags.sharedFlags or {}
    for k,v in pairs(req) do
        local val = mem[k]
        if val == nil then val = shared[k] end
        if val ~= v then return false end
    end
    return true
end

local inventory = require("src.inventory")
local game = require("src.game")
local traits = require("src.traits")
local journal = require("src.journal")

local function processChoice(choice)
    if not choice then return end
    if choice.reward then inventory:add(choice.reward) end
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
    if choice.journal then
        local j = choice.journal
        journal:addEntry(j.id, j.text, j.tags)
    end
    if choice.state then
        state:set(choice.state)
        if choice.state ~= "dialogue" then
            return
        end
    end
    local nextKey = choice.next
    local nextNode = nextKey and dialogueTree[nextKey]
    if nextNode and nextNode.requires and not meetsRequirements(nextNode.requires, activeNPC) then
        nextNode = nil
    end
    if nextNode then
        currentNode = nextNode
        if nextNode.journal then
            local j = nextNode.journal
            journal:addEntry(j.id, j.text, j.tags)
        end
        if currentNode.onSelect then currentNode.onSelect() end
        if currentNode.triggerNull then
            state:nullTrigger({ text = currentNode.text })
            if currentNode.choices and currentNode.choices[1] then
                processChoice(currentNode.choices[1])
            end
        end
    elseif nextKey then
        print("[Dialogue node missing: " .. tostring(nextKey) .. "]")
        state:set("exploration")
    end
end

-- Dialogue context (set when state is entered)
local dialogueTree = nil
local currentNode = nil
local activeNPC = nil

-- Called when dialogue begins
function dialogue_state:enter(context)
    if not context or not context.tree then
        print("[Dialogue state received no tree]")
        return
    end

    dialogueTree = context.tree
    activeNPC = context.npc

    if not dialogueTree.start then
        print("[Dialogue error] Tree missing 'start' node")
        state:set("exploration")
        return
    end

    local startNode = context.start or dialogueTree.start
    if type(startNode) == "string" then
        startNode = dialogueTree[startNode]
    end
    if startNode.requires and not meetsRequirements(startNode.requires, activeNPC) then
        if startNode.unmet then
            startNode = dialogueTree[startNode.unmet]
        else
            print("[Dialogue] Start requirements unmet")
            startNode = dialogueTree.start
        end
    end
    currentNode = startNode
    if currentNode.journal then
        local j = currentNode.journal
        journal:addEntry(j.id, j.text, j.tags)
    end

    if currentNode.onSelect then
        currentNode.onSelect()
    end

    if currentNode.triggerNull then
        state:nullTrigger({ text = currentNode.text })
        if currentNode.choices and currentNode.choices[1] then
            processChoice(currentNode.choices[1])
        end
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
        if choice.requires and not meetsRequirements(choice.requires, activeNPC) then
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
    if currentNode.triggerNull then return end

    local index = tonumber(key)
    if index and currentNode.choices[index] then
        local choice = currentNode.choices[index]
        if choice.repMin and game.flags.reputation < choice.repMin then return end
        if choice.requiresHistory and not game.flags.dialogueHistory[choice.requiresHistory] then return end
        if choice.requiresTrait and not traits:has(choice.requiresTrait) then return end
        if choice.requires and not meetsRequirements(choice.requires, activeNPC) then return end

        processChoice(choice)
    elseif key == "escape" then
        state:set("exploration")
    end
end

-- No update logic needed (static)
function dialogue_state:update(dt) end

return dialogue_state

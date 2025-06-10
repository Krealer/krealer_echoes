--========================================
-- dialogue.lua
-- Central dialogue manager for branching conversations
-- Used by dialogue_state and NPC scripts
--========================================

local dialogue = {}
local game = require("src.game")

-- Helper to check memory requirements
local function meetsRequirements(req, memory, shared)
    if not req then return true end
    memory = memory or {}
    shared = shared or {}
    for k, v in pairs(req) do
        local val = memory[k]
        if val == nil then
            val = shared[k]
        end
        if val ~= v then
            return false
        end
    end
    return true
end

local function meetsRepRequirement(req)
    if not req then return true end
    local current = game:getReputation(req.region)
    if req.min and current < req.min then return false end
    if req.max and current > req.max then return false end
    return true
end

-- Current dialogue context
dialogue.tree = nil
dialogue.currentNode = nil
dialogue.context = nil
dialogue.memory = nil
dialogue.shared = nil

--========================================
-- Start a new dialogue tree using a context (target.npc must define .dialogue)
--========================================
function dialogue:start(context)
    self.context = context or {}

    local npc = self.context.target
    if not npc or not npc.dialogue then
        print("[Error] NPC missing 'dialogue' key")
        return
    end

    self.memory = game.flags.npc[npc.id or npc.dialogue] or {}
    self.shared = game.flags.sharedFlags

    -- Dynamically require the NPC's dialogue file
    local success, tree = pcall(require, "src.npc_dialogue." .. npc.dialogue)
    if not success or not tree or not tree.start then
        print("[Error] Failed to load dialogue tree for: " .. tostring(npc.dialogue))
        return
    end

    self.tree = tree
    local startNode = context.start or tree.start
    if type(startNode) == "string" then
        startNode = tree[startNode] or tree.start
    end
    if startNode.requires and not meetsRequirements(startNode.requires, self.memory, self.shared) then
        -- unmet start requirements simply skip to fallback node if defined
        if startNode.unmet then
            startNode = tree[startNode.unmet]
        else
            print("[Dialogue] Start node requirements unmet")
            startNode = tree.start
        end
    end
    self.currentNode = startNode
end

--========================================
-- Return the current node (for rendering)
--========================================
function dialogue:getCurrent()
    return self.currentNode
end

--========================================
-- Return list of choices meeting requirements
--========================================
function dialogue:getChoices()
    if not self.currentNode or not self.currentNode.choices then return {} end

    local list = {}
    for _, choice in ipairs(self.currentNode.choices) do
        local ok = true
        if choice.requires and not meetsRequirements(choice.requires, self.memory, self.shared) then
            ok = false
        end
        if ok and not meetsRepRequirement(choice.requiresReputation) then
            ok = false
        end
        if ok then
            table.insert(list, choice)
        end
    end
    return list
end

--========================================
-- Advance to a new node by key
-- Called when player makes a choice
--========================================
function dialogue:advanceTo(nextKey)
    if not self.tree or not self.tree[nextKey] then
        print("[Warning] Missing dialogue node: " .. tostring(nextKey))
        self:reset()
        state:set("exploration")
        return
    end
    local nextNode = self.tree[nextKey]
    if nextNode.requires and not meetsRequirements(nextNode.requires, self.memory, self.shared) then
        print("[Dialogue] Requirements not met for node: " .. tostring(nextKey))
        return
    end
    if nextNode.requiresReputation and not meetsRepRequirement(nextNode.requiresReputation) then
        print("[Dialogue] Reputation not sufficient for node: " .. tostring(nextKey))
        return
    end

    self.currentNode = nextNode
end

--========================================
-- Reset all context (on exit or error)
--========================================
function dialogue:reset()
    self.tree = nil
    self.currentNode = nil
    self.context = nil
    self.memory = nil
    self.shared = nil
end

--========================================
-- Utility: has dialogue ended?
-- If no choices, treat as terminal node
--========================================
function dialogue:isEnded()
    return self.currentNode and (not self.currentNode.choices or #self.currentNode.choices == 0)
end

return dialogue

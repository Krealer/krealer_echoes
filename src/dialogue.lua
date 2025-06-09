--========================================
-- dialogue.lua
-- Central dialogue manager for branching conversations
-- Used by dialogue_state and NPC scripts
--========================================

local dialogue = {}

-- Current dialogue context
dialogue.tree = nil
dialogue.currentNode = nil
dialogue.context = nil

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

    -- Dynamically require the NPC's dialogue file
    local success, tree = pcall(require, "src.npc_dialogue." .. npc.dialogue)
    if not success or not tree or not tree.start then
        print("[Error] Failed to load dialogue tree for: " .. tostring(npc.dialogue))
        return
    end

    self.tree = tree
    self.currentNode = tree.start
end

--========================================
-- Return the current node (for rendering)
--========================================
function dialogue:getCurrent()
    return self.currentNode
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

    self.currentNode = self.tree[nextKey]
end

--========================================
-- Reset all context (on exit or error)
--========================================
function dialogue:reset()
    self.tree = nil
    self.currentNode = nil
    self.context = nil
end

--========================================
-- Utility: has dialogue ended?
-- If no choices, treat as terminal node
--========================================
function dialogue:isEnded()
    return self.currentNode and (not self.currentNode.choices or #self.currentNode.choices == 0)
end

return dialogue

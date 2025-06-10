--========================================
-- jayson.lua
-- Behavior and logic for the NPC "Jayson"
-- Supports dialogue branching and interaction memory
--========================================

local game = require("src.game")

local jayson = {}
jayson.id = "jayson"
jayson.memory = game.flags.npc[jayson.id] or {}
game.flags.npc[jayson.id] = jayson.memory

-- Track whether player has spoken to Jayson
jayson.hasSpoken = false
jayson.knowsNull = false

-- Called when player interacts with this NPC
function jayson:onInteract()
    print("[Jayson looks you over.]")

    -- Load dialogue from external tree
    local dialogueTree = require("src.npc_dialogue.jayson_dialogue")

    local startKey = "start"
    if self.memory.intimidated and dialogueTree.intimidated_repeat then
        startKey = "intimidated_repeat"
    elseif self.memory.trusted and dialogueTree.trust_repeat then
        startKey = "trust_repeat"
    end

    state:set("dialogue", { tree = dialogueTree, npc = self, start = startKey })

    self.hasSpoken = true
    self.memory.met = true
end

return jayson

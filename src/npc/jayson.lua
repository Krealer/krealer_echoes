--========================================
-- jayson.lua
-- Behavior and logic for the NPC "Jayson"
-- Supports dialogue branching and interaction memory
--========================================

local jayson = {}

-- Track whether player has spoken to Jayson
jayson.hasSpoken = false
jayson.knowsNull = false

-- Called when player interacts with this NPC
function jayson:onInteract()
    print("[Jayson looks you over.]")

    -- Load dialogue from external tree
    local dialogueTree = require("src.npc_dialogue.jayson_dialogue")
    dialogue:start(dialogueTree)

    -- Mark that we’ve initiated conversation
    jayson.hasSpoken = true
end

return jayson

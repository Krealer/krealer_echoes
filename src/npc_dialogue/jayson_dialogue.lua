--========================================
-- jayson_dialogue.lua
-- Dialogue tree for NPC "Jayson"
-- Cold vs human responses, subtle probing of Krealer's past
--========================================

local game = require("src.game")

return {
    start = {
        text = "You're not from around here, are you? You look... off.",
        choices = {
            { text = "Your assessment is correct. Proceed.", next = "cold_ack", repChange = 1, historyKey = "trust" },
            { text = "I escaped something. I don't owe you more.", next = "defensive" },
            { text = "(Say nothing)", next = "silent" },
            { text = "I used to be one of them. I'm trying not to be.", next = "reveal" },
            { text = "Got any supplies?", next = "end_convo", reward = { name = "Medkit", type = "healing", effect = 20 } },
            { text = "Where's the next zone?", next = "map_offer" },
            { text = "You can trust me.", next = "respect", repMin = 1 },
            { text = "Folks in Hilltown vouch for me.", next = "rep_ack", requiresReputation = { region = "hilltown", min = 1 } }
        }
    },

    cold_ack = {
        text = "That’s... honest. Kind of eerie. Are you military or something?",
        choices = {
            { text = "I'm nothing. Keep it that way.", next = "end_convo" },
            { text = "Something like that.", next = "end_convo" }
        }
    },

    defensive = {
        text = "Alright, alright. Didn't mean to pry. You just look... calculated.",
        choices = {
            { text = "Calculated is safer than vulnerable.", next = "end_convo" },
            { text = "Maybe. Or maybe you're just easy to read.", next = "intimidate" }
        }
    },

    silent = {
        text = "...",
        choices = {
            { text = "(Continue staring)", next = "npc_unsettled" },
            { text = "(Walk away)", next = "end_convo" }
        }
    },

    reveal = {
        text = "Used to be? You mean… Null-trained?",
        choices = {
            { text = "I escaped. I don't belong there anymore.", next = "respect" },
            { text = "That place still owns me more than I admit.", next = "sympathy" }
        }
    },

    intimidate = {
        text = "H-Hey, I'm just trying to be friendly. Don't get weird.",
        onSelect = function() game.flags.npc.jayson.intimidated = true end,
        choices = {
            { text = "Then don't ask questions you aren't ready to answer.", next = "end_convo" }
        }
    },

    npc_unsettled = {
        text = "Alright… you're strange. I'm gonna go.",
        onSelect = function() print("[Jayson seems uneasy.]") end,
        choices = {
            { text = "(Say nothing)", next = "end_convo" }
        }
    },

    map_offer = {
        text = "There's an old facility east of here. I'll mark it for you.",
        choices = {
            { text = "(Travel there)", map = "map02", state = "exploration" }
        }
    },

    respect = {
        text = "Huh. Guess that took some guts. I won't ask more.",
        onSelect = function() game.flags.npc.jayson.trusted = true end,
        choices = {
            { text = "Good.", next = "end_convo" },
            { text = "Thanks.", next = "end_convo" }
        }
    },

    sympathy = {
        text = "...Yeah. You carry that look. Still, you're out now, right?",
        choices = {
            { text = "Physically. Not mentally.", next = "end_convo" },
            { text = "Out enough to be dangerous.", next = "end_convo" }
        }
    },

    rep_ack = {
        text = "Huh, word travels fast around here. Keep your nose clean, then.",
        choices = {
            { text = "Understood.", next = "end_convo" }
        }
    },

    trust_repeat = {
        text = "Hey, good to see you again. Need anything?",
        requires = { trusted = true },
        choices = {
            { text = "Any supplies?", next = "end_convo", reward = { name = "Medkit", type = "healing", effect = 20 } },
            { text = "Just checking in.", next = "end_convo" },
            { text = "Everyone in Hilltown likes me now.", next = "rep_ack", requiresReputation = { region = "hilltown", min = 1 } }
        }
    },

    intimidated_repeat = {
        text = "Oh... it's you again. I don't want any trouble.",
        requires = { intimidated = true },
        choices = {
            { text = "Then keep quiet.", next = "end_convo" }
        }
    },

    end_convo = {
        text = "[Conversation ends]",
        choices = {}
    }
}

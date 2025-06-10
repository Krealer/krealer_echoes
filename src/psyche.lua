local psyche = {}

local game = require("src.game")

psyche.thresholds = {
    silence = { ["Silent Treatment"] = 3 },
    logic = { ["Cold Read"] = 3 },
    empathy = { ["Empathize"] = 3 },
    manipulation = { ["Persuade"] = 3 }
}

psyche.descriptions = {
    ["Silent Treatment"] = "Use silence to unsettle opponents.",
    ["Cold Read"] = "Quickly analyze a person's motives.",
    ["Empathize"] = "Better understand others' feelings.",
    ["Persuade"] = "Subtly bend conversations your way."
}

function psyche:add(tag, amount)
    amount = amount or 1
    if game.psyche[tag] == nil then return end
    game.psyche[tag] = game.psyche[tag] + amount
    self:checkUnlocks(tag)
end

function psyche:checkUnlocks(tag)
    local score = game.psyche[tag]
    for skill, req in pairs(self.thresholds[tag] or {}) do
        if score >= req and not game.skillsUnlocked[skill] then
            game.skillsUnlocked[skill] = self.descriptions[skill] or true
            print("[Skill Unlocked] " .. skill)
        end
    end
end

function psyche:getUnlocked()
    return game.skillsUnlocked
end

function psyche:printUnlocked()
    print("== Psyche Skills ==")
    local any = false
    for skill,_ in pairs(game.skillsUnlocked) do
        print("* " .. skill)
        any = true
    end
    if not any then
        print("None unlocked.")
    end
end

return psyche

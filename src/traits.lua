--========================================
-- traits.lua
-- Passive trait system for Krealer
-- Traits modify stats or dialogue options
--========================================

traits = {}

-- Known trait definitions
traits.definitions = {
    Emotionless = {
        onApply = function()
            -- Emotionless mainly affects dialogue; no stat change
        end
    },
    Calculating = {
        onApply = function()
            -- Slight damage boost to precision strikes
            for _, skill in ipairs(combat.player.skills) do
                skill.dmg = skill.dmg + 5
            end
        end
    },
    Suppressor = {
        onApply = function()
            combat.player.maxHp = combat.player.maxHp + 10
            combat.player.hp = combat.player.maxHp
        end
    }
}

traits.active = {}

function traits:add(name)
    if self.active[name] then return end
    local def = self.definitions[name]
    if def then
        self.active[name] = true
        if def.onApply then def.onApply() end
    end
end

function traits:has(name)
    return not not self.active[name]
end

return traits

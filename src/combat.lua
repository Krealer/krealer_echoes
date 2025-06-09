--========================================
-- combat.lua
-- Core turn-based combat system for Krealer: Echoes of the Null
-- Tactical mental-chess framework with psychological undertones
--========================================

combat = {}

-- Combat context
combat.active = false
combat.playerTurn = true
combat.enemy = nil
local enemyTimer = 0

-- Krealer's combat stats (expandable with passives/status)
combat.player = {
    name = "Krealer",
    hp = 100,
    mp = 30,
    maxHp = 100,
    maxMp = 30,
    skills = {
        { name = "Precision Strike", cost = 5, dmg = 20 },
        { name = "Analyze Weakness", cost = 3, dmg = 10 }
    },
    passives = {}
}

-- Enemy structure
local function newEnemy(name, hp, dmg)
    return {
        name = name or "Unknown Enemy",
        hp = hp or 50,
        dmg = dmg or 10,
        status = {} -- For debuffs or psychological effects
    }
end

--========================================
-- Start combat with an enemy
--========================================
function combat:start(enemyData)
    self.enemy = newEnemy(enemyData.name, enemyData.hp, enemyData.dmg)
    self.player.hp = self.player.maxHp
    self.player.mp = self.player.maxMp
    self.playerTurn = true
    self.active = true
    enemyTimer = 0.5
    print("[Combat started with " .. self.enemy.name .. "]")
end

--========================================
-- Player selects a skill by index
--========================================
function combat:useSkill(index)
    local skill = self.player.skills[index]
    if not skill then return end

    if self.player.mp < skill.cost then
        print("Not enough MP to use " .. skill.name)
        return
    end

    self.player.mp = self.player.mp - skill.cost
    self.enemy.hp = self.enemy.hp - skill.dmg

    print("Krealer used " .. skill.name .. " (−" .. skill.cost .. " MP, dealt " .. skill.dmg .. " damage)")

    self:checkOutcome()
    if self.active then
        self.playerTurn = false
    end
end

--========================================
-- Enemy turn (basic AI)
--========================================
function combat:enemyAction()
    local dmg = self.enemy.dmg
    self.player.hp = self.player.hp - dmg
    print(self.enemy.name .. " strikes for " .. dmg .. " damage.")

    self:checkOutcome()
    if self.active then
        self.playerTurn = true
        enemyTimer = 0.5
    end
end

--========================================
-- Win/loss condition checks
--========================================
function combat:checkOutcome()
    if self.enemy.hp <= 0 then
        print(self.enemy.name .. " has been neutralized.")
        self.active = false
        state:set("exploration")
    elseif self.player.hp <= 0 then
        print("Krealer falls. The Null Factor echoes louder now...")
        self.active = false
        state:set("exploration")
    end
end

--========================================
-- Draw combat UI
--========================================
function combat:draw()
    if not self.active then return end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("== COMBAT ==", 10, 50)
    love.graphics.print("Enemy: " .. self.enemy.name .. " | HP: " .. self.enemy.hp, 10, 70)
    love.graphics.print("You: " .. self.player.hp .. " HP / " .. self.player.mp .. " MP", 10, 90)

    if self.playerTurn then
        love.graphics.print("Select a skill:", 10, 120)
        for i, skill in ipairs(self.player.skills) do
            local info = i .. ". " .. skill.name .. " (MP: " .. skill.cost .. ", Dmg: " .. skill.dmg .. ")"
            love.graphics.print(info, 10, 120 + i * 20)
        end
    else
        love.graphics.print("Enemy's turn...", 10, 120)
    end
end

--========================================
-- Input handler for skills and cancel
--========================================
function combat:keypressed(key)
    if not self.playerTurn then return end

    local index = tonumber(key)
    if index and index >= 1 and index <= #self.player.skills then
        self:useSkill(index)
    elseif key == "escape" then
        print("[Combat manually exited]")
        self.active = false
        state:set("exploration")
    end
end

--========================================
-- Update (used to pace turns or delay AI)
--========================================
function combat:update(dt)
    if self.active and not self.playerTurn then
        enemyTimer = enemyTimer - dt
        if enemyTimer <= 0 then
            self:enemyAction()
        end
    end
end

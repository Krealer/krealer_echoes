--========================================
-- combat.lua
-- Core turn-based combat system for Krealer: Echoes of the Null
-- Tactical mental-chess framework with psychological undertones
--========================================

combat = {}

local traits = require("src.traits")

-- Combat context
combat.active = false
combat.playerTurn = true
combat.enemy = nil
local enemyTimer = 0

-- Process status effects on an entity
local function processStatuses(entity)
    for i = #entity.status, 1, -1 do
        local s = entity.status[i]
        if s.type == "Bleed" then
            entity.hp = entity.hp - 5
            print(entity.name .. " bleeds for 5 damage.")
        end
        s.duration = s.duration - 1
        if s.duration <= 0 then
            table.remove(entity.status, i)
        end
    end
end

-- Apply a status effect to an entity
local function addStatus(entity, status)
    if not status then return end
    local copy = { type = status.type, duration = status.duration }
    table.insert(entity.status, copy)
    print(entity.name .. " afflicted with " .. status.type .. " (" .. status.duration .. " turns)")
end

-- Calculate damage considering statuses on the target
local function calcDamage(base, target)
    for _, s in ipairs(target.status) do
        if s.type == "Guard Break" then
            return base + 5
        end
    end
    return base
end

-- Begin the turn for an entity (tick statuses)
local function startTurn(entity)
    processStatuses(entity)
end

-- Krealer's combat stats (expandable with passives/status)
combat.player = {
    name = "Krealer",
    hp = 100,
    mp = 30,
    maxHp = 100,
    maxMp = 30,
    skills = {
        { name = "Precision Strike", cost = 5, dmg = 20,
          status = { type = "Bleed", duration = 2 } },
        { name = "Analyze Weakness", cost = 3, dmg = 10,
          status = { type = "Guard Break", duration = 2 } }
    },
    status = {},
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
    self.player.status = {}
    self.enemy.status = {}
    self.playerTurn = true
    self.active = true
    enemyTimer = 0.5
    print("[Combat started with " .. self.enemy.name .. "]")
    startTurn(self.player)
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
    local dmg = calcDamage(skill.dmg, self.enemy)
    self.enemy.hp = self.enemy.hp - dmg

    print("Krealer used " .. skill.name .. " (−" .. skill.cost .. " MP, dealt " .. dmg .. " damage)")

    if skill.status then
        addStatus(self.enemy, skill.status)
    end

    self:checkOutcome()
    if self.active then
        self.playerTurn = false
        startTurn(self.enemy)
    end
end

--========================================
-- Use an inventory item during player's turn
--========================================
function combat:useItem(item)
    if not item then return end

    inventory:use(item)

    self:checkOutcome()
    if self.active then
        self.playerTurn = false
        startTurn(self.enemy)
    end
end

--========================================
-- Enemy turn (basic AI)
--========================================
function combat:enemyAction()
    local dmg = calcDamage(self.enemy.dmg, self.player)
    self.player.hp = self.player.hp - dmg
    print(self.enemy.name .. " strikes for " .. dmg .. " damage.")

    self:checkOutcome()
    if self.active then
        self.playerTurn = true
        enemyTimer = 0.5
        startTurn(self.player)
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
    local enemyStatus = ""
    for _, s in ipairs(self.enemy.status) do
        enemyStatus = enemyStatus .. " " .. s.type .. "(" .. s.duration .. ")"
    end
    love.graphics.print("Enemy: " .. self.enemy.name .. " | HP: " .. self.enemy.hp .. enemyStatus, 10, 70)

    local playerStatus = ""
    for _, s in ipairs(self.player.status) do
        playerStatus = playerStatus .. " " .. s.type .. "(" .. s.duration .. ")"
    end
    love.graphics.print("You: " .. self.player.hp .. " HP / " .. self.player.mp .. " MP" .. playerStatus, 10, 90)

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
    elseif input:matches(key, config.controls.inventory) then
        state:set("inventory", { returnTo = "combat" })
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

--========================================
-- journal.lua
-- Records notable observations in an analytical tone
--========================================

journal = {}

-- Use persistent table from game if available
journal.entries = game and game.journalEntries or {}

--========================================
-- Add a new journal entry
-- id: unique identifier
-- text: log content
-- tags: optional list for categorisation
--========================================
function journal:addEntry(id, text, tags)
    if not id or not text then return end
    if self.entries[id] then return end
    local entry = { id = id, text = text, tags = tags }
    self.entries[id] = entry
    if game and game.journalEntries then
        game.journalEntries[id] = entry
    end
    print("[Journal] Logged entry: " .. id)
end

--========================================
-- Draw journal entries
--========================================
function journal:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("== JOURNAL ==", 20, 20)
    local y = 40
    local empty = true
    for _, entry in pairs(self.entries) do
        love.graphics.print("- " .. entry.text, 40, y)
        y = y + 20
        empty = false
    end
    if empty then
        love.graphics.print("No observations recorded.", 40, y)
        y = y + 20
    end
    love.graphics.print("[J] Close", 20, y + 20)
end

return journal

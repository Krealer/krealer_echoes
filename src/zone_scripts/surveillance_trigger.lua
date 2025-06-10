local M = {}

function M.run()
    print("[Surveillance triggered]")
    game.alertLevel = (game.alertLevel or 0) + 1
    if journal then
        journal:addEntry("surveillance", "Detected lingering in surveillance zone.", {"danger"})
    end
    return { state = "echo", context = { text = "Alarms blare as enforcers approach", duration = 2 } }
end

return M

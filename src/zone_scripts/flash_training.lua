local M = {}

function M.run()
    print("[Null training flashback]")
    if journal then
        journal:addEntry("flash_training", "Brief resurgence of Null training memories.", {"memory"})
    end
    return { state = "echo", context = { text = "Memories of brutal Null training surge", duration = 2 } }
end

return M

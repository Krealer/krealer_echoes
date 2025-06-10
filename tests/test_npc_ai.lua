describe("npc ai", function()
  local em, ai
  before_each(function()
    package.loaded["src.npc.ai"] = nil
    package.loaded["src.entities.entity_manager"] = nil
    em = require("src.entities.entity_manager")
    em:clear()
    ai = require("src.npc.ai")
    config = require("src.config")
    config.mapWidth = 3
    config.mapHeight = 3
    currentMap = { tiles = { {0,0,0},{0,0,0},{0,0,0} } }
    player = { x = 1, y = 1 }
    state = { set = function(_, s, ctx) state.called = s; state.ctx = ctx end }
  end)

  it("engages hostile NPC near player", function()
    local npc = { x = 2, y = 1, type = "npc", name = "Rogue", hostile = true, hp = 30, dmg = 5 }
    em:add(npc)
    ai:update(0)
    assert.are.equal("combat", state.called)
    assert.are.equal(npc, state.ctx.enemy)
  end)
end)

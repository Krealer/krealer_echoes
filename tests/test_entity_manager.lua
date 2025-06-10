describe("entity_manager", function()
  local em
  before_each(function()
    em = require("src.entities.entity_manager")
    em:clear()
  end)

  it("adds and retrieves entities", function()
    local e = { x = 1, y = 1, type = "npc", name = "Bob" }
    em:add(e)
    assert.are.equal(e, em:getAt(1,1))
    assert.is_nil(em:getAt(2,2))
  end)

  it("clears all entities", function()
    em:add({x=1,y=2,type="npc"})
    em:clear()
    assert.are.equal(0, #em.entities)
  end)

  it("initializes default vision fields", function()
    local e = { x=1, y=1, type="enemy", name="Guard" }
    em:add(e)
    assert.are.equal(3, e.visionRange)
    assert.are.equal("down", e.facing)
    assert.is_false(e.seenPlayer)
  end)
end)

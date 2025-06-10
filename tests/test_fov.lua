describe("fov detection", function()
  before_each(function()
    package.loaded["src.entities.player"] = nil
    package.loaded["src.utils"] = nil
    package.loaded["src.entities.entity_manager"] = nil
    config = require("src.config")
    utils = require("src.utils")
    entityManager = require("src.entities.entity_manager")
    player = require("src.entities.player")
    player.x = 3
    player.y = 1
  end)

  it("detects player inside enemy cone", function()
    local enemy = { x = 1, y = 1, type = "enemy", name = "Guard", facing = "right", visionRange = 3 }
    assert.is_true(player:isInFOV(enemy))
  end)
end)

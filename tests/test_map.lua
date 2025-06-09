local config = require("src.config")
describe("map", function()
  local map
  before_each(function()
    map = require("src.map")
    currentMap = { tiles = { {0,1}, {0,0} } }
    config.mapWidth = 2
    config.mapHeight = 2
  end)

  it("checks walkable tiles", function()
    assert.is_true(map.isWalkable(1,1))
    assert.is_false(map.isWalkable(2,1))
    assert.is_false(map.isWalkable(0,1))
  end)
end)

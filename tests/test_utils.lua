describe("utils", function()
  local utils = require("src.utils")

  it("clamps values within bounds", function()
    assert.are.equal(5, utils.clamp(10, 0, 5))
    assert.are.equal(0, utils.clamp(-1, 0, 5))
    assert.are.equal(3, utils.clamp(3, 0, 5))
  end)

  it("detects same positions", function()
    assert.is_true(utils.isSamePos(1,2,1,2))
    assert.is_false(utils.isSamePos(1,2,2,1))
  end)

  it("checks coordinates inside zones", function()
    local zone = {x1=1, y1=1, x2=3, y2=3}
    assert.is_true(utils.isInZone(2,2,zone))
    assert.is_false(utils.isInZone(4,2,zone))
  end)

  it("deepcopies tables", function()
    local orig = {a=1,b={c=2}}
    local copy = utils.deepcopy(orig)
    assert.are_not.equal(orig, copy)
    assert.are_not.equal(orig.b, copy.b)
    assert.are.same(orig, copy)
  end)

  it("calculates vision cone tiles", function()
    local tiles = utils.getTilesInViewCone(2,2,"right",2)
    assert.are.equal(6, #tiles)
    local last = tiles[#tiles]
    assert.are.same({x=4, y=1}, last)
  end)

  it("rolls conditioning checks", function()
    game = { conditioning = { influence = 0, resistance = 100 } }
    local oldRand = math.random
    math.random = function() return 50 end
    assert.is_true(utils.rollConditioningCheck(60))
    game.conditioning.influence = 100
    game.conditioning.resistance = 0
    math.random = function() return 1 end
    assert.is_false(utils.rollConditioningCheck(50))
    math.random = oldRand
  end)
end)

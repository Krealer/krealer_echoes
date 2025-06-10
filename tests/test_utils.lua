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
end)

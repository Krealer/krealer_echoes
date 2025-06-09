local inventory
local combat

describe("inventory", function()
  before_each(function()
    combat = { player = { hp = 50, mp = 10, maxHp = 100, maxMp = 20 } }
    _G.combat = combat
    _G.inventory = nil
    inventory = require("src.inventory")
    inventory:clear()
  end)

  it("adds items", function()
    local item = { name = "Test", type = "misc" }
    inventory:add(item)
    assert.are.equal(1, #inventory.items)
    assert.are.same(item, inventory.items[1])
  end)

  it("removes items by index", function()
    local a = { name = "A" }
    local b = { name = "B" }
    inventory:add(a)
    inventory:add(b)
    inventory:remove(1)
    assert.are.equal(1, #inventory.items)
    assert.are.same(b, inventory.items[1])
  end)

  it("uses healing items and removes them", function()
    local item = { name = "Potion", type = "healing", effect = 30 }
    inventory:add(item)
    combat.player.hp = 50
    inventory:use(item)
    assert.are.equal(80, combat.player.hp)
    assert.are.equal(0, #inventory.items)
  end)

  it("finds index of an item", function()
    local item = { name = "FindMe" }
    inventory:add(item)
    assert.are.equal(1, inventory:indexOf(item))
  end)
end)

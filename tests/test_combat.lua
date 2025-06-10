describe("combat status effects", function()
  local combat
  before_each(function()
    package.loaded["src.combat"] = nil
    combat = require("src.combat")
    state = { set = function() end }
  end)

  it("applies bleed on skill use", function()
    combat:start({name="Dummy", hp=40, dmg=5})
    combat:useSkill(1)
    assert.are.equal("Bleed", combat.enemy.status[1].type)
    assert.are.equal(1, combat.enemy.status[1].duration)
    assert.are.equal(15, combat.enemy.hp)
  end)

  it("guard break increases next damage", function()
    combat:start({name="Dummy", hp=40, dmg=5})
    combat:useSkill(2)
    assert.are.equal(30, combat.enemy.hp)
    combat:enemyAction()
    combat:useSkill(1)
    assert.are.equal(0, combat.enemy.hp)
  end)

  it("consumes turn when using an item", function()
    combat:start({name="Dummy", hp=40, dmg=5})
    inventory = require("src.inventory")
    inventory.items = {}
    local item = {name="Small Potion", type="healing", effect=10}
    table.insert(inventory.items, item)
    combat:useItem(item)
    assert.is_false(combat.playerTurn)
  end)
end)

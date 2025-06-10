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
end)

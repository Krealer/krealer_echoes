describe("dialogue_state", function()
  local dialogue_state

  before_each(function()
    package.loaded["src.states.dialogue_state"] = nil
    dialogue_state = require("src.states.dialogue_state")
    inventory = require("src.inventory")
    inventory:clear()
    game = { flags = { currentMap = "map01" } }
    currentMap = { load = function() end }
    state = { set = function(newState, ctx) state.last = newState; state.ctx = ctx end }
  end)

  it("runs node onSelect when entering", function()
    local flag = false
    local tree = { start = { text = "hi", choices = {}, onSelect = function() flag = true end } }
    dialogue_state:enter({ tree = tree })
    assert.is_true(flag)
  end)

  it("awards reward on choice", function()
    local tree = {
      start = {
        text = "take", choices = { { text = "yes", reward = { name = "Med" }, next = "end" } }
      },
      ["end"] = { text = "done", choices = {} }
    }
    dialogue_state:enter({ tree = tree })
    dialogue_state:keypressed("1")
    assert.are.equal(1, #inventory.items)
    assert.are.equal("Med", inventory.items[1].name)
  end)

  it("loads map on choice", function()
    local loaded = false
    local fakeMap = { load = function() loaded = true end }
    package.loaded["src.maps.map02"] = fakeMap
    local tree = {
      start = { text = "go", choices = { { text = "move", map = "map02", state = "exploration" } } }
    }
    dialogue_state:enter({ tree = tree })
    dialogue_state:keypressed("1")
    assert.is_true(loaded)
    assert.are.equal(fakeMap, currentMap)
    assert.are.equal("map02", game.flags.currentMap)
  end)
end)

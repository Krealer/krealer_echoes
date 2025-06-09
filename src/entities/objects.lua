--========================================
-- objects.lua
-- Object-specific interaction logic (doors, chests, healing pits)
-- Triggered by entity interaction
--========================================

objects = {}

--========================================
-- Door object
--========================================
function objects.door(entity)
    print("You examine the door.")
    if entity.locked then
        print("It's locked.")
    else
        print("The door opens. (This could transition maps.)")
        -- In future: state:loadMap("map02")
    end
end

--========================================
-- Chest object
--========================================
function objects.chest(entity)
    if not entity.opened then
        entity.opened = true
        print("You open the chest.")
        local item = { name = "Restoration Pill", type = "healing", effect = 25 }
        inventory:add(item)
    else
        print("The chest is empty.")
    end
end

--========================================
-- Healing Pit object
--========================================
function objects.healing_pit(entity)
    print("You kneel at the healing pit.")
    combat.player.hp = combat.player.maxHp
    combat.player.mp = combat.player.maxMp
    print("You feel restored.")
end

--========================================
-- Dispatch interaction based on object type
-- Called from interactions.lua
--========================================
function objects.interact(entity)
    if entity.name == "Door" then
        objects.door(entity)
    elseif entity.name == "Chest" then
        objects.chest(entity)
    elseif entity.name == "Healing Pit" then
        objects.healing_pit(entity)
    else
        print("It's... something. But it does nothing.")
    end
end

return objects

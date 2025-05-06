--ATM Pull API 0.1 with Turtle + Ender Chest Delivery

local chests = {"enderstorage:ender_chest_0"}
local dropper = "minecraft:dropper_0"
local junk = "minecraft:dropper_1"
local coin = "minecraft:diamond"

local d = peripheral.wrap(dropper)
local j = peripheral.wrap(junk)


function getStored()
    local count = 0
    for _, chestName in pairs(chests) do
        local chest = peripheral.wrap(chestName)
        for slot, item in pairs(chest.list()) do
            if item.name == coin then
                count = count + item.count
            else
                j.pullItems(chestName, slot, item.count)
            end
        end
    end
    return count
end

function deposit()
    local count = 0
    for _, chestName in pairs(chests) do
        for i = 1, 9 do
            local item = d.getItemDetail(i)
            if item then
                if item.name == coin then
                    local deposited = d.pushItems(chestName, i, 64)
                    count = count + deposited
                else
                    d.pushItems(junk, i, 64)
                end
            end
        end
    end
    if count > 0 then
        return true, count
    else
        return false, "Deposited amount must be more than 0"
    end
end

function withdraw(amount)
    if amount > 576 then
        return false, "amount must be at maximum 9 stacks or 576 items"
    end
    if amount > getStored() then
        return false, "not enough money in storage"
    end
    
    local count = 0
    for k, v in pairs(chests) do
        cs = peripheral.wrap(v)
        for i = 1, 54 do
            tab = cs.getItemDetail(i)
            if tab ~= nil then
                if tab.name == coin then
                    if (count + tab.count) > amount then
                        d.pullItems(v, i, (amount - count))
                        return true
                    else
                        d.pullItems(v, i, tab.count)
                        count = count + tab.count
                    end
                    if count == amount then
                        return true
                    end
                else
                    j.pullItems(chests, i, 64)
                end
            end
        end
    end
end
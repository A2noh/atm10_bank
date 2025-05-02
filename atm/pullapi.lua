--ATM Pull API 0.1 with Turtle + Ender Chest Delivery

local chests = {"enderstorage:ender_chest_0"}
local dropper = "minecraft:dropper_0"
local junk = "minecraft:dropper_1"
local coin = "minecraft:diamond"

local d = peripheral.wrap(dropper)
local j = peripheral.wrap(junk)

-- Map of ATM IDs to color codes or delivery channels
local atmDeliveryMap = {
    [1] = "white_white_white", -- Example: ATM ID 1
    [2] = "red_white_blue",
    -- Add more as needed
}

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

function withdraw(amount, atmID)
    if amount > 576 then
        return false, "Max withdrawal is 576"
    end
    if amount > getStored() then
        return false, "Insufficient bank balance"
    end

    -- Pull coins into turtle's inventory
    local turtleName = "turtle_0"
    local delivered = 0

    for _, chestName in pairs(chests) do
        local chest = peripheral.wrap(chestName)
        for i = 1, 54 do
            if delivered >= amount then break end
            local item = chest.getItemDetail(i)
            if item and item.name == coin then
                local toMove = math.min(item.count, amount - delivered)
                peripheral.call(turtleName, "pullItems", chestName, i, toMove)
                delivered = delivered + toMove
            end
        end
    end

    if delivered < amount then
        return false, "Could not gather enough coins"
    end

    -- Deliver via ender chest
    if not atmDeliveryMap[atmID] then
        return false, "Unknown ATM ID"
    end

    local chestColor = atmDeliveryMap[atmID]

    rednet.send(peripheral.getName(peripheral.wrap(turtleName)), textutils.serialize({
        command = "deliver",
        toColor = chestColor,
        count = amount
    }))

    return true, "Delivery started"
end

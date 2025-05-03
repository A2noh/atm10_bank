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

function withdraw(amount)
    if amount > 576 then
        return false, "Amount must be at maximum 9 stacks or 576 items"
    end
    if amount > getStored() then
        return false, "Not enough money in storage"
    end

    local TURTLE_ID = 3  -- Replace with your turtle’s actual ID

    local message = {
        command = "deliver",
        count = amount
    }

    rednet.send(TURTLE_ID, textutils.serialize(message))

    -- Optionally wait for confirmation
    local _, reply = rednet.receive(3)  -- wait up to 3 seconds
    rednet.close("back")

    if reply then
        return true, reply
    else
        return true, "Withdraw requested: " .. amount
    end
end
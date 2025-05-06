--do 'wget https://raw.githubusercontent.com/A2noh/atm10_bank/refs/heads/main/turtle.lua'

rednet.open("right")
print("Turtle ready for delivery.")

while true do
    local senderID, msg = rednet.receive()
    print("Received message from ID " .. senderID)

    local data = msg
    if data and data.command == "deliver" then
        local count = data.count or 0
        print("Starting delivery of exactly " .. count .. " diamonds")

        -- Step 1: Pull only diamonds until we have exactly the count
        local collected = 0

        while collected < count do
            local toPull = math.min(64, count - collected)
            if turtle.suck(toPull) then
                for i = 1, 16 do
                    local item = turtle.getItemDetail(i)
                    if item then
                        if item.name == "minecraft:diamond" then
                            collected = collected + item.count
                            if collected > count then
                                -- Too many: keep only needed amount, return excess
                                turtle.select(i)
                                turtle.drop(collected - count) -- drop excess
                                collected = count
                            end
                        else
                            turtle.select(i)
                            turtle.drop() -- drop wrong item
                        end
                    end
                    if collected >= count then break end
                end
            else
                print("Not enough items to pull.")
                break
            end
        end

        -- Step 2: Turn around to face Ender Chest
        turtle.turnLeft()
        turtle.turnLeft()

        -- Step 3: Drop exactly the diamonds
        local delivered = 0
        for i = 1, 16 do
            if delivered >= count then break end
            local item = turtle.getItemDetail(i)
            if item and item.name == "minecraft:diamond" then
                turtle.select(i)
                local toDrop = math.min(item.count, count - delivered)
                turtle.drop(toDrop)
                delivered = delivered + toDrop
            end
        end

        -- Step 4: Turn back to face input chest
        turtle.turnLeft()
        turtle.turnLeft()

        print("Delivery complete: " .. delivered .. " diamonds delivered.")
        rednet.send(senderID, "Delivered exactly " .. delivered .. " diamonds.")
    else
        print("Ignored message: no valid delivery command.")
    end
end

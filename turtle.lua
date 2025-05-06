--do 'wget https://raw.githubusercontent.com/A2noh/atm10_bank/refs/heads/main/turtle.lua'

rednet.open("right")
print("Turtle ready for delivery.")

while true do
    local senderID, msg = rednet.receive()
    local data = msg
    if data and data.command == "deliver" then
        local count = data.count or 0
        print("Delivering " .. count .. " diamonds")

        local collected = 0
        while collected < count do
            local toPull = math.min(64, count - collected)
            if turtle.suck(toPull) then
                for i = 1, 16 do
                    local item = turtle.getItemDetail(i)
                    if item and item.name == "minecraft:diamond" then
                        collected = collected + item.count
                        if collected >= count then
                            break
                        end
                    else
                        turtle.select(i)
                        turtle.drop() -- Drop non-diamonds back
                    end
                end
            else
                print("No items left to pull.")
                break
            end
        end

        -- Turn around to face Ender Chest
        turtle.turnLeft()
        turtle.turnLeft()

        -- Drop only diamonds
        for i = 1, 16 do
            local item = turtle.getItemDetail(i)
            if item and item.name == "minecraft:diamond" then
                turtle.select(i)
                turtle.drop()
            end
        end

        -- Turn back to original position
        turtle.turnLeft()
        turtle.turnLeft()

        rednet.send(senderID, "Delivered " .. math.min(collected, count) .. " diamonds.")
    end
end

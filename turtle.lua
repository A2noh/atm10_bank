rednet.open("back")
print("Turtle ready for delivery.")

while true do
    local _, msg = rednet.receive()
    local data = textutils.unserialize(msg)
    if data and data.command == "deliver" then
        local color = data.toColor
        local count = data.count or 0

        -- Optional: open Ender Chest with matching color (assumed already placed)
        print("Delivering " .. count .. " coins to " .. color)

        for i = 1, 16 do
            local item = turtle.getItemDetail(i)
            if item and item.name == "minecraft:diamond" then
                turtle.select(i)
                turtle.drop() -- Assumes turtle is facing into Ender Chest
            end
        end
        rednet.send(_, "Delivered to ATM: " .. color)
    end
end
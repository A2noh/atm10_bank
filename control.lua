--Must be called control.lua--

term.clear()
term.setCursorPos(1, 1)

local ATM = "server"
local drive = "bottom"

while true do
    term.setTextColor(colors.yellow)
    print("To read log type 0. for balance type 1")
    print("For deposit type 2, for withdraw type 3")
    print("For transfer type 4, for add account type 5")
    term.setTextColor(1)
    local txt = read()
    if txt == "0" then
        print("Please enter the line you want to start at, this will read the next 7 lines")
        local number = read()
        if (tonumber(number)) then
            if tonumber(number) < 1 then
                printError("Number must be more than 0")
            else
                logRead = fs.open("log", "r")
                if logRead == nil then
                    printError("No log file found")
                else
                    local num = 1
                    while num < tonumber(number) do
                        logRead.readLine()
                        num = num + 1
                    end
                    num = 1
                    local line = logRead.readLine()
                    repeat
                        print(line)
                        line = logRead.readLine()
                        num = num + 1
                    until num > 7 or line == nil
                    logRead.close()
                end
            end
        else
            printError("Must be a number")
        end 
    elseif txt == "1" or txt == "2" or txt == "3" or txt == "4" or txt == "5" then
        print("Please enter the card")
        while disk.isPresent(drive) == false do
            sleep(0.1)
        end
        local id = disk.getID(drive)
        disk.eject(drive)
        if id == nil then
            printError("Must be valid card")
        else
            print("Please enter 5 number pin")
            local pin = read("*")
            if (tonumber(pin)) then
                if string.len(pin) ~= 5 then
                    printError("Must be 5 numbers")
                else
                    if txt == "1" then
                        print(bankAPI.balance(id, ATM, pin))
                    elseif txt == "2" then
                        print("Please enter deposit amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            amount = tonumber(amount)
                            print(bankAPI.deposit(id, amount, ATM, pin))
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "3" then
                        print("Please enter withdraw amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            amount = amount tonumber(amount)
                            print(bankAPI.withdraw(id, amount, ATM, pin))
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "4" then
                        print("Please enter the amount")
                        local amount = read()
                        if (tonumber(amount)) then
                            print("Please enter id to transfer to")
                            local id2 = read()
                            if (tonumber(id2)) then
                                id2 = tonumber(id2)
                                print(bankAPI.transfer(id, id2, amount, ATM, pin))
                            else
                                printError("Must be a valid id")
                            end
                            
                        else
                            printError("Must be a number")
                        end
                    elseif txt == "5" then    
                        print(bankAPI.create(id, ATM, pin))
                    end
                end
            else
                printError("Must be a number")
            end
        end
    else
        printError("Must be a number from the list")
    end
end

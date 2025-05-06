--ATM version 0.0.7--
--Must be called api.lua--

rednet.open("modem_0")

server = 3
vers = "0.0.7"

--functions--
function clear(col, exit)
    --add bank logo--
    term.setBackgroundColor(col)
    term.setTextColor(colors.yellow)
    term.clear()
    term.setCursorPos(1, 1)
    term.write("Bank OS ".. vers)
    term.setCursorPos(1, 18)
    term.setTextColor(colors.lightGray)
    term.write("Made By Mavric, edited by A2noh.")
    term.setCursorPos(1, 19)
    term.write("Please Report Bugs to A2noh")
    term.setTextColor(colors.white)
    if (exit) then
        term.setBackgroundColor(colors.red)
        term.setCursorPos(49, 17)
        term.write("X")
        term.setBackgroundColor(colors.black)
    end
end

function balance(account, ATM, pin)
    local msg = {"bal", account, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "balR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end

function deposit(account, amount, ATM, pin)
    local msg = {"dep", account, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "depR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end

function withdraw(account, amount, ATM, pin)
    local msg = {"wit", account, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    
    local send, mes, pro = rednet.receive("banking", 3)  -- 3 second timeout

    if not mes then
        return false, "No response from server"
    end

    if mes[1] ~= "witR" or mes[2] ~= true then
        return false, "Withdrawal denied by server: " .. tostring(mes[3] or "unknown reason")
    end

    -- Server approved the withdrawal
    local response = tostring(mes[3] or "Approved")
    local TURTLE_ID = 4  -- Update with your turtle ID

    local delivery = {
        command = "deliver",
        count = amount
    }


    rednet.send(TURTLE_ID, delivery)

    local _, turtleReply = rednet.receive(3)  -- wait up to 3 seconds
    if turtleReply then
        return success, response .. " | " .. turtleReply
    else
        return false, "oof"
    end
end   
    

function transfer(account, account2, amount, ATM, pin)
    local msg = {"tra", account, account2, amount, ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "traR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end

function create(ATM, pin)
    local msg = {"cre", ATM, pin}
    rednet.send(server, msg, "banking")
    local send, mes, pro = rednet.receive("banking")
    if mes[1] == "creR" then
        return mes[2], mes[3]
    end
    return false, "oof"
end
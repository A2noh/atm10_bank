--Must be called bankAPI.lua--

rednet.open("top")

function balance(acc, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
        table.insert(fileData, line)
        line = file.readLine()
        until line == nil
        file.close()
        if fileData[2] == pin then
            return true, fileData[1]
        else
            return false, "Incorrect pin"
        end
    end
    return false, "Not real id"
end

function deposit(acc, amm, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
        table.insert(fileData,line)
        line = file.readLine()
        until line == nil
        file.close()
        if fileData[2] == pin then
            fs.delete("saves/"..acc)
            file = fs.open("saves/".. acc, "a")
            file.writeLine(tonumber(fileData[1]) + amm)
            file.writeLine(fileData[2])
            file.close()
            return true, amm
        else
            return false, "Incorrect pin"
        end
    end
    return false, "Not a real id"
end

function withdraw(acc, amm, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file ~= nil then
        local fileData = {}
        local line = file.readLine()
        repeat
        table.insert(fileData,line)
        line = file.readLine()
        until line == nil
        file.close()
        if (tonumber(fileData[1]) - amm) >= 0 then
            if fileData[2] == pin then
                fs.delete("saves/".. acc)
                file = fs.open("saves/".. acc, "a")
                file.writeLine(tonumber(fileData[1]) - amm)
                file.writeLine(fileData[2])
                file.close()
                return true, amm
            else
                return false, "Incorrect pin"
            end
        else
            return false, "Balance to low"
        end
    end
    return false, "Not a real id"
end

function transfer(acc, acc2, amm, atm, pin)
    local suc, res = withdraw(acc, amm, atm, pin)
    if (suc) then
        file = fs.open("saves/".. acc2, "r")
        if file ~= nil then
            local fileData = {}
            local line = file.readLine()
            repeat
            table.insert(fileData,line)
            line = file.readLine()
            until line == nil
            file.close()
            fs.delete("saves/".. acc2)
            file = fs.open("saves/".. acc2, "a")
            file.writeLine(tonumber(fileData[1]) + amm)
            file.writeLine(fileData[2])
            file.close()
            return true, amm
        else
            local suc2, res2 = deposit(acc2, amm, "")
            if (suc2) then
                return false, "withdraw refund worked"
            else
                return false, "withdraw fail refund failed"
            end
        end
    end
    return false, res
end

function create(acc, atm, pin)
    file = fs.open("saves/".. acc, "r")
    if file == nil then
        file = fs.open("saves/".. acc, "a")
        file.writeLine(0)
        file.writeLine(pin)
		file.close()
        return true, acc
    else
        file.close()
        return false, "already an account"
    end
end